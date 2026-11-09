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

type crc_info = {
  path : string ;
  file : string ;
  proof : string ;
  profile : Json.t ;
  strategy : strategy ;
}

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

let filename ~move ~root ~path ~file () =
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

let load ?(move=false) ~root ~path ~file () =
  let proof = filename ~move ~root ~path ~file () in
  let js = if Sys.file_exists proof then Json.of_file proof else `Null in
  let profile = if js = `Null then `List [] else Json.jfield "profile" js in
  let strategy = jmap (jmap Crc.of_json) @@ Json.jfield "proofs" js in
  { path ; file ; proof ; profile ; strategy }

type buffer = {
    crc : crc_info ;
    profile : Json.t ;
    mutable proofs : strategy ;
    theories : (string, unit) Hashtbl.t ;
  }

let dump =
  Timer.throttle @@
  Timer.timed ~name:"Proofs dump"
    begin fun b ->
      let proof = b.crc.proof in
      Utils.mkdirs (Filename.dirname proof) ;
      Json.to_file ~pretty_floats:true proof @@ `Assoc [
        "profile", `List [] ;
        "proofs", jproofs b.proofs ;
      ]
    end

let buffer ?profile crc = {
    crc ;
    proofs = crc.strategy ;
    profile = Option.value ~default:crc.profile profile ;
    theories = Hashtbl.create 8 ;
  }

let add theory goal crc buffer =
  let theory = Session.thy_name theory in
  let goal = Session.name goal in
  let tasks = M.add goal crc @@ M.find_def M.empty theory buffer.proofs in
  buffer.proofs <- M.add theory tasks buffer.proofs ; dump buffer

let init theory goals hints buffer =
  let theory = Session.thy_name theory in
  Hashtbl.add buffer.theories theory ();
  let results =
    if M.is_empty hints then M.empty else
      List.fold_left
        (fun rs goal ->
           let a = Session.name goal in
           match M.find_opt a hints with
           | None -> rs
           | Some r -> M.add a r rs)
        M.empty goals
  in buffer.proofs <- M.add theory results buffer.proofs ; dump buffer

let save cache buffer =
  begin
    buffer.proofs <-
      M.filter (fun th _ -> Hashtbl.mem buffer.theories th) buffer.proofs ;
    dump ~force:true buffer ;
    let { path ; file ; proof } = buffer.crc in
    Cache.update cache ~path ~file ~proof ;
  end
