(**************************************************************************)
(*                                                                        *)
(*  SPDX-License-Identifier LGPL-2.1                                      *)
(*  Copyright (C)                                                         *)
(*  CEA (Commissariat à l'énergie atomique et aux énergies alternatives)  *)
(*                                                                        *)
(**************************************************************************)

(* -------------------------------------------------------------------------- *)
(* --- JSON Utilities                                                     --- *)
(* -------------------------------------------------------------------------- *)

let jsloc ~file = function
  | None -> `Null
  | Some loc ->
    let f,l1,c1,l2,c2 = Why3.Loc.get loc in
    if f <> file then `Null else
      Json.assoc [
        "line", `Int l1 ;
        "column", `Int c1 ;
        "end_line", if l2 = l1 then `Null else `Int l2 ;
        "end_column", if c2 = c1 then `Null else `Int c2 ;
      ]

let jurl_name ~url = function
  | None -> `Null
  | Some name -> `String (Printf.sprintf "%s#%s" url name)

let jurl_loc ~file ~url ?name = function
  | None -> jurl_name ~url name
  | Some loc ->
    let f,line,_,_,_ = Why3.Loc.get loc in
    if f <> file
    then jurl_name ~url name
    else `String (Printf.sprintf "%s#_L%d" url line)

(* -------------------------------------------------------------------------- *)
(* --- Proof Statistics                                                   --- *)
(* -------------------------------------------------------------------------- *)

type jstats = {
  time : float ;
  stuck : int ;
  proved : int ;
  json : Json.t ;
}

let empty = { time = 0.0 ; stuck = 0 ; proved = 0 ; json = `Null }

let jmap f xs =
  let time = ref 0.0 in
  let stuck = ref 0 in
  let proved = ref 0 in
  let js = List.map
      (fun x ->
         let s = f x in
         time := !time +. s.time ;
         stuck := !stuck + s.stuck ;
         proved := !proved + s.proved ;
         s.json
      ) xs
  in {
    time = !time ;
    stuck = !stuck ;
    proved = !proved ;
    json = Json.list js ;
  }

(* -------------------------------------------------------------------------- *)
(* --- Compute Statistics                                                 --- *)
(* -------------------------------------------------------------------------- *)

let subgoals env ?goal id children =
  let (let*) v fn = match v with None -> [] | Some a -> fn a in
  let goals =
    let* goal = goal in
    let* tactic = Tactic.lookup env id in
    let* goals = Session.apply env tactic goal in
    goals in
  let rec pairwise gs cs =
    match gs, cs with
    | _, [] -> []
    | [] , cs -> List.map (fun c -> None,c) cs
    | g::gs , c::cs -> (Some g,c) :: pairwise gs cs
  in pairwise goals children

let rec stats_crc env ~file ~url (goal,crc) : Json.t =
  let loc = Option.bind goal Session.target in
  let base = [
    "url" , jurl_loc ~file ~url loc ;
    "location" , jsloc ~file loc ;
  ] in
  let stats =
    match crc with
    | Crc.Stuck -> [ "stuck", `Int 1 ]
    | Crc.Prover(p,_,time) -> [
        "time" , `Float time ;
        "proved" , `Int 1 ;
        "prover" , `String p ;
      ]
    | Crc.Tactic { id ; children ; time ; stuck ; proved } -> [
        "time" , `Float time ;
        "stuck" , Json.optint stuck ;
        "proved" , Json.optint proved ;
        "tactic" , `String id ;
        "children" , Json.list_map
          (stats_crc env ~file ~url)
          (subgoals env ?goal id children) ;
      ]
  in Json.assoc (base @ stats)

let stats_goal proofs ?env ?lenses ~file ~path ~url (goal : Session.goal) =
  let name = Session.name goal in
  let crc = Why3.Wstdlib.Mstr.find_def Crc.stuck name proofs in
  let infix = Id.of_infix @@ name in
  let status = Format.asprintf "%a" Crc.pp_hint crc in
  let loc = Session.target goal in
  begin match lenses , loc with
    | None , _ | _ , None -> ()
    | Some lenses , Some loc ->
      let f,line,_,_,_ = Why3.Loc.get loc in
      if f = file then Hashtbl.add lenses line status
  end ;
  let base = [
    "goal" , `String name ;
    "path" , `String (Printf.sprintf "%s.%s" path infix) ;
    "url" , jurl_loc ~file ~url ~name loc ;
    "status", `String status ;
    "location", jsloc ~file loc ;
  ] in
  match crc with
  | Crc.Stuck ->
    { json = Json.assoc base ; stuck = 1 ; proved = 0 ; time = 0.0 }
  | Crc.Prover(_,_,time) -> {
      json = Json.assoc @@ base @ [
          "time", `Float time ;
          "proved", `Int 1 ;
        ] ;
      stuck = 0 ; proved = 1 ; time ;
    }
  | Crc.Tactic { time ; stuck ; proved ; id ; children } ->
    let children =
      match env with None -> `Null | Some env ->
          Json.list_map
            (stats_crc env ~url ~file)
            (subgoals env ~goal id children)
    in {
      json = Json.assoc @@ base @ [
          "time" , `Float time ;
          "stuck" , Json.optint stuck ;
          "proved" , Json.optint proved ;
          "children" , children ;
        ] ;
      stuck ; proved ; time ;
    }

let stats_theory ?lenses ~file ~path strategy (thy : Session.theory) =
  let name = Session.thy_name thy in
  let line =
    match (Session.thy thy).th_name.id_loc with
    | None -> 0
    | Some loc -> let _,l,_,_,_ = Why3.Loc.get loc in l in
  let proofs = Why3.Wstdlib.Mstr.(find_def empty name strategy) in
  let goals = Session.split thy in
  let path = Printf.sprintf "%s.%s" path name in
  let url = Printf.sprintf "%s.html" path in
  let jstats = jmap (stats_goal proofs ?lenses ~file ~path ~url) goals in
  let json =
    Json.assoc [
      "path", `String path ;
      "file", `String file ;
      "line", `Int line ;
      "url", `String (Printf.sprintf "%s#_L%d" url line) ;
      "children", jstats.json ;
      "time", `Float jstats.time ;
      "stuck" , Json.optint jstats.stuck ;
      "proved" , Json.optint jstats.proved ;
    ]
  in { jstats with json }

let stats_session ~file ~path ?lenses strategy session =
  let theories = Session.theories session in
  let jstats = jmap (stats_theory ?lenses strategy ~file ~path) theories in
  let url = Printf.sprintf "%s.html" path in
  let json = Json.assoc [
      "path", `String path ;
      "file", `String file ;
      "url", `String url ;
      "children", jstats.json ;
      "time", `Float jstats.time ;
      "stuck" , Json.optint jstats.stuck ;
      "proved" , Json.optint jstats.proved ;
    ]
  in { jstats with json }

let stats_file env ~root ~file =
  let theories, format = Wutil.load_theories env file in
  let dir, path, _ = Wutil.filepath ~root ~file in
  let session = Session.create ~dir ~file ~format theories in
  let Proofs.{ strategy } = Proofs.load ~move:false ~root ~path ~file () in
  stats_session ~file ~path strategy session

let statistics ~root ~env ~files =
  let jstats = jmap (fun file -> stats_file env ~root ~file) files in
  let json =
    Json.assoc [
      "files", jstats.json ;
      "time", `Float jstats.time ;
      "stuck", Json.optint jstats.stuck ;
      "proved", Json.optint jstats.proved ;
    ] in
  { jstats with json }

(* -------------------------------------------------------------------------- *)
