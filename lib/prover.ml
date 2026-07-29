(**************************************************************************)
(*                                                                        *)
(*  SPDX-License-Identifier LGPL-2.1                                      *)
(*  Copyright (C)                                                         *)
(*  CEA (Commissariat à l'énergie atomique et aux énergies alternatives)  *)
(*                                                                        *)
(**************************************************************************)

module Whyconf = Why3.Whyconf
module Driver = Why3.Driver

(* -------------------------------------------------------------------------- *)
(* --- Provers Patterns                                                   --- *)
(* -------------------------------------------------------------------------- *)

exception Invalid_pattern of string

let pattern_of_string s =
  match String.split_on_char '@' s with
  | [ name ] -> String.lowercase_ascii name, None
  | [ name ; version ] -> String.lowercase_ascii name, Some version
  | _  -> raise (Invalid_argument "Prover.split_pattern")

let pattern_name s = try fst @@ pattern_of_string s with Invalid_pattern _ -> s
let pattern_version s = try snd @@ pattern_of_string s with Invalid_pattern _ -> None

let pattern ~name ?version () =
  match version with None -> name | Some v -> Printf.sprintf "%s@%s" name v

(* -------------------------------------------------------------------------- *)
(* --- Provers Description                                                --- *)
(* -------------------------------------------------------------------------- *)

type desc = {
  name : string ;
  version : string ;
}

let desc_to_string p = Format.sprintf "%s@%s" p.name p.version

let desc_of_string s =
  try
    let (name, version) = pattern_of_string s in
    { name ; version = Option.get version }
  with Invalid_argument _ -> raise (Invalid_pattern s)

let desc_of_config_prover (cfgprover : Whyconf.config_prover) =
  if not cfgprover.interactive && cfgprover.prover.prover_altern = "" then
    Some {
      name = String.lowercase_ascii cfgprover.prover.prover_name ;
      version = cfgprover.prover.prover_version ;
    }
  else None

let pp_desc fmt p = Format.fprintf fmt "%s@%s" p.name p.version

(* -------------------------------------------------------------------------- *)
(* --- Semantic Versioning                                                --- *)
(* -------------------------------------------------------------------------- *)

type sem = V of int | S of string
let sem s = try V (int_of_string s) with Failure _ -> S s
let cmp x y =
  match x,y with
  | V a,V b -> b - a
  | V _,S _ -> (-1)
  | S _,V _ -> (+1)
  | S a,S b -> String.compare a b
let cmp x y = cmp (sem x) (sem y)

let compare_version p q =
  List.compare cmp (String.split_on_char '.' p) (String.split_on_char '.' q)

let compare_desc p q =
  let cmp = String.compare p.name q.name in
  if cmp <> 0 then cmp else
    compare_version p.version q.version

module Mdesc = Why3.Extmap.Make (struct
    type t = desc
    let compare = compare_desc
  end)

(* -------------------------------------------------------------------------- *)
(* --- Full Featured Prover                                               --- *)
(* -------------------------------------------------------------------------- *)

type prover = {
  desc : desc ;
  relaxed : bool ;
  config : Whyconf.config_prover ;
  driver : Driver.driver ;
  digest : string ;
}

let why3_desc prv = Whyconf.prover_parseable_format prv.config.prover
let name prv = prv.desc.name
let version prv = prv.desc.version
let fullname p = Format.sprintf "%s@%s" (name p) (version p)
let infoname p = Format.sprintf "%s(%s)" (name p) (version p)
let pp_prover fmt p = Format.fprintf fmt "%s@%s" (name p) (version p)

(* Digest the file that why3 will load *)
let digest_driver main (dir, name) =
  let file = Driver.resolve_driver_name main "drivers" ~extra_dir:dir name in
  Digest.file file

let digest_config main Whyconf.{
    prover ;
    command ;
    command_steps ;
    driver ;
    in_place = _ ;
    editor = _ ;
    interactive = _ ;
    extra_options ;
    extra_drivers ;
  } =
  let open Buffer in
  let buf = create 128 in
  add_string buf (Digest.string prover.prover_name);
  add_string buf (Digest.string prover.prover_version);
  add_string buf (Digest.string prover.prover_altern);
  add_string buf (Digest.string command);
  if command_steps = None then
    add_string buf "None                            "
  else
    add_string buf (Digest.string (Option.get command_steps));
  add_string buf (digest_driver main driver);
  List.iter (fun s -> add_string buf (Digest.string s))
    extra_options;
  List.iter (fun (d, l) ->
      List.iter (fun f -> add_string buf (digest_driver main (Some d, f))) l
    ) extra_drivers;
  Digest.(to_hex (string (Buffer.contents buf)))
[@@ocaml.warning "+9"] (* missing name in record **)

let all (wenv : Config.why3env) =
  Whyconf.Mprover.fold
    begin fun _ config m ->
      match desc_of_config_prover config with
      | None -> m
      | Some desc ->
        let main = Whyconf.get_main wenv.config in
        Mdesc.add desc {
          desc ; config ; relaxed = false ;
          driver = Driver.load_driver_for_prover main wenv.env config ;
          digest = digest_config main config ;
        } m
    end (Whyconf.get_provers wenv.config) Mdesc.empty

let all = Config.Whtbl.memoize 5 all

let relaxed p = { p with relaxed = true }

let filter_prover ~name ?version p =
  p.desc.name = name
  && (version = None || p.desc.version = Option.get version)

let find_exn wenv ~pattern =
  let (name, version) = pattern_of_string pattern in
  let filter _ p = filter_prover ~name ?version p in
  let prv = snd @@ Mdesc.min_binding @@ Mdesc.filter filter @@ all wenv in
  if version = None then relaxed prv else prv

let find_default (wenv : Config.why3env) name =
  try [ find_exn wenv ~pattern:name ] with Not_found -> []

let default wenv =
  find_default wenv "alt-ergo" @
  find_default wenv "z3" @
  find_default wenv "cvc4" @
  find_default wenv "cvc5"

let warn_prover_not_found =
  Why3.Wstdlib.Hstr.memo 5
    (fun s -> Log.warning "prover %s not found" s)

let select_from_map ~patterns all =
  let find pattern =
    try
      match pattern_of_string pattern with
      | name, Some version -> `Ok (Mdesc.find { name ; version } all)
      | name, None ->
        let filter { name = s ; _ } _ = String.equal name s in
        `Ok (relaxed @@ snd @@ Mdesc.min_binding @@ Mdesc.filter filter all)
    with
    | Invalid_pattern s -> `Invalid_pattern s
    | Not_found -> `PatternNotFound pattern in
  List.map find patterns

let select wenv ~patterns =
  let filter = function
    | `Ok p -> Some p
    | `Invalid_pattern s -> Log.warning "invalid prover pattern %s" s; None
    | `PatternNotFound s -> warn_prover_not_found s; None in
  List.filter_map filter @@ select_from_map ~patterns @@ all wenv

let fit prover ~name ~version =
  prover.desc.name = name &&
  match version with
  | None -> true
  | Some v ->  v = prover.desc.version

let find provers ~name ?version () =
  let result = List.find_opt (fit ~name ~version) provers in
  begin
    if result = None then warn_prover_not_found @@ pattern ~name ?version () ;
  end ; result
