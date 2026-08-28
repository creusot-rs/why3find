(**************************************************************************)
(*                                                                        *)
(*  SPDX-License-Identifier LGPL-2.1                                      *)
(*  Copyright (C)                                                         *)
(*  CEA (Commissariat à l'énergie atomique et aux énergies alternatives)  *)
(*                                                                        *)
(**************************************************************************)

module M = Why3.Wstdlib.Mstr
module Th = Why3.Theory

type strategy = Crc.crc M.t M.t (* Theory -> Task -> CRC *)

type proof = { file : string ; profile : Json.t ; strategy : strategy }

(* -------------------------------------------------------------------------- *)
(* --- Proof Files                                                        --- *)
(* -------------------------------------------------------------------------- *)

(* Json to Map converter *)
let jmap cc js =
  let m = ref M.empty in
  Json.jiter (fun fd js -> m := M.add fd (cc js) !m) js ; !m

(* Map to Json converter *)
let map ?keepnull cc m =
  Json.assoc ?keepnull @@ List.rev @@ M.fold (fun a e js -> (a, cc e) :: js) m []

let jproofs : strategy -> Json.t = map (map  ~keepnull:true Crc.to_json)

let warn_moved =
  let once = ref true in
  fun () ->
    if !once then
      begin
        once := false ;
        if Sys.file_exists ".git" then
          Log.warning "Moving proof files to `./why3find.proofs (use git add -A)"
        else
          Log.warning "Moving proof files to `./why3find.proofs"
      end

let moved = Hashtbl.create 32

let filename ?(move=true) ~root ~path ~file () =
  let target =
    Filename.concat root @@
    Filename.concat "why3find.proofs" @@ path ^ ".json" in
  let source =
    Filename.concat (Filename.chop_extension file) "proof.json" in
  if move then
    begin
      (* upgrade old proof files (once) *)
      if not (Hashtbl.mem moved file) then
        begin
          Hashtbl.add moved file () ;
          (* move old file to new target *)
          if Sys.file_exists source then
            begin
              if Utils.outdated ~source ~target then
                begin
                  warn_moved () ;
                  Utils.copy ~source ~target ;
                end ;
              Utils.rmpath source ;
            end ;
          (* cleanup old directory *)
          Utils.rmdirs (Filename.dirname source) ;
        end ;
      target
    end
  else
  if Sys.file_exists source && not (Sys.file_exists target)
  then source else target

let load ?move ~root ~path ~file () =
  let file = filename ?move ~root ~path ~file () in
  let js = if Sys.file_exists file then Json.of_file file else `Null in
  let profile = if js = `Null then `List [] else Json.jfield "profile" js in
  let strategy = jmap (jmap Crc.of_json) @@ Json.jfield "proofs" js in
  { file ; profile ; strategy }

type buffer = Buffer of {
    file : string ;
    profile : Json.t ;
    mutable proofs : strategy ;
    theories_seen : (string, unit) Hashtbl.t ;
  }

let dump =
  Timer.throttle @@
  Timer.timed ~name:"Proofs dump"
    begin function Buffer b ->
      Utils.mkdirs (Filename.dirname b.file) ;
      Json.to_file ~pretty_floats:true b.file @@ `Assoc [
        "profile", b.profile ;
        "proofs", jproofs b.proofs ;
      ]
    end

let buffer ?profile origin =
  Buffer {
    file = origin.file ;
    proofs = origin.strategy ;
    profile = Option.value ~default:origin.profile profile ;
    theories_seen = Hashtbl.create 8
  }

let add theory goal crc (Buffer b as buffer) =
  let theory = Session.thy_name theory in
  let goal = Session.name goal in
  let tasks = M.add goal crc @@ M.find_def M.empty theory b.proofs in
  b.proofs <- M.add theory tasks b.proofs ; dump buffer

let init theory goals hints (Buffer b as buffer) =
  let theory = Session.thy_name theory in
  Hashtbl.add b.theories_seen theory ();
  let results =
    if M.is_empty hints then M.empty else
      List.fold_left
        (fun rs goal ->
           let a = Session.name goal in
           match M.find_opt a hints with
           | None -> rs
           | Some r -> M.add a r rs)
        M.empty goals
  in b.proofs <- M.add theory results b.proofs ; dump buffer

let save (Buffer b as buffer) =
  b.proofs <- M.filter (fun th _ -> Hashtbl.mem b.theories_seen th) b.proofs ;
  dump ~force:true buffer
