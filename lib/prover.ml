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

(* -------------------------------------------------------------------------- *)
(* --- Prover Description Portfolios                                      --- *)
(* -------------------------------------------------------------------------- *)

module Smap = Why3.Wstdlib.Mstr
module Vmap =
  Why3.Extmap.Make
    (struct
      type t = string
      let compare = compare_version
    end)

type 'a portfolio = 'a Vmap.t Smap.t

let empty : 'a portfolio = Smap.empty

let add d v (m : 'a portfolio) : 'a portfolio =
  let w = Smap.find_def Vmap.empty d.name m in
  Smap.add d.name (Vmap.add d.version v w) m

let mem d (m : 'a portfolio) : bool =
  Vmap.mem d.version (Smap.find d.name m)

let find d (m : 'a portfolio) : 'a =
  Vmap.find d.version (Smap.find d.name m)

let select ~name ?version (m : 'a portfolio) : 'a =
  let w = Smap.find name m in
  match version with
  | Some v -> Vmap.find v w
  | None -> snd @@ Vmap.min_binding w

let is_empty = Smap.is_empty
let iter f m =
  Smap.iter (fun name w -> Vmap.iter (fun version x ->
      f { name ; version } x
    ) w) m

(* -------------------------------------------------------------------------- *)
(* --- Matching                                                           --- *)
(* -------------------------------------------------------------------------- *)

let warn_invalid_pattern =
  Why3.Wstdlib.Hstr.memo 5 (fun s -> Log.warning "invalid prover pattern %s" s)

let warn_prover_not_found =
  Why3.Wstdlib.Hstr.memo 5 (fun s -> Log.warning "prover %s not found" s)

let pmatch pattern =
  try
    let name,version = pattern_of_string pattern in
    fun d -> d.name = name &&
             match version with None -> true | Some v -> d.version = v
  with Invalid_pattern s -> warn_invalid_pattern s ; fun _ -> false

(* -------------------------------------------------------------------------- *)
(* --- Downloaded Provers                                                 --- *)
(* -------------------------------------------------------------------------- *)

let binarycache = lazy
  begin
    try Sys.getenv "WHY3FIND_PROVERS" with Not_found ->
    try Filename.concat (Sys.getenv "HOME") ".why3find.provers" with Not_found ->
      Log.warning "Binary cache not found (use 'WHY3FIND_PROVERS')." ; ""
  end

let find_downloaded_provers data =
  let cache = Lazy.force binarycache in
  let files = try Sys.readdir cache with _ -> [| |] in
  let provers = ref [] in
  Array.iter
    (fun file ->
       match String.split_on_char '@' file with
       | [ name ; version_exec ] ->
         let path = Filename.concat cache file in
         begin
           match Why3.Autodetection.find_prover data name path with
           | None ->
             Log.warning "Binary %S no more recognized" path
           | Some version ->
             if not (String.starts_with ~prefix:version version_exec) then
               Log.warning "Binary %S is %s@%s" path name version ;
             provers := (path,name,version) :: !provers
         end
       | _ -> ()
    ) files ; !provers

(* -------------------------------------------------------------------------- *)
(* --- Download Provers                                                   --- *)
(* -------------------------------------------------------------------------- *)

let command ~prover ~step msg =
  Format.kasprintf
    (begin fun cmd ->
       if Sys.command cmd <> 0 then
         begin
           Utils.flush () ;
           Utils.failwith "[%s] %s failed" prover step ;
         end
     end)
    msg

let download ~name ~version ~spec =
  let prover = Printf.sprintf "%s@%s" name version in
  let tmp = Filename.temp_dir "why3find" "download" in
  let pwd = Sys.getcwd () in
  try
    Sys.chdir tmp ;
    let url, path =
      match String.split_on_char '#' spec with
      | [ url ] -> url , None
      | [ url ; path ] -> url , Some path
      | _ -> Utils.failwith "[%s] Invalid prover URL %S" prover spec in
    let file = Filename.basename url in
    command ~prover ~step:"Download"
      "wget -t 5 -q --show-progress %S -O %s" url file ;
    Utils.killline () ;
    let binary =
      match path with
      | None -> file
      | Some path ->
        command ~prover ~step:"Unpack" "tar zxf %s %s" file path ; path
    in
    command ~prover ~step:"Permissions" "chmod a+x %s" binary ;
    if Version.system = "macosx" then
      begin
        command ~prover ~step:"Quanrantine"
          "xattr -dr com.apple.quarantine %s" binary ;
        command ~prover ~step:"Autosign"
          "codesign -s - --deep --force %s" binary ;
      end ;
    let cache = Lazy.force binarycache in
    Utils.mkdirs cache ;
    command ~prover ~step:"Installation"
      "mv -f %s %s/%s" binary cache prover ;
    Utils.flush () ;
    Sys.chdir pwd ;
    command ~prover ~step:"Cleaning" "rm -fr %s" tmp ;
    Utils.flush () ;
    Format.printf "Installed prover %s@." prover
  with err ->
    Sys.chdir pwd ;
    command ~prover ~step:"Cleaning" "rm -fr %s" tmp ;
    raise err

(* -------------------------------------------------------------------------- *)
(* --- Prover Scanning                                                    --- *)
(* -------------------------------------------------------------------------- *)

let rc_prover_section (path,name,version) =
  let s = Why3.Rc.empty_section in
  let s = Why3.Rc.set_string s "name" name in
  let s = Why3.Rc.set_string s "path" path in
  let s = Why3.Rc.set_string s "version" version in s

let config ?(autodetect=false) ?(downloaded=false) () =
  (* load the Why3 user's config first, if any *)
  let config = Why3.Whyconf.init_config ~extra_config:[] None in
  let data = Why3.Autodetection.read_auto_detection_data config in
  (* downloaded provers *)
  let ps = if downloaded then find_downloaded_provers data else [] in
  (* prover autodetection *)
  let qs = if autodetect then Why3.Autodetection.find_provers data else [] in
  (* consolidation *)
  let provers = ps @ qs in
  if provers <> [] then
    !Why3.Whyconf.provers_from_detected_provers config @@
    Why3.Rc.set_simple_family Why3.Rc.empty "partial_prover" @@
    List.map rc_prover_section provers
  else config

let available config =
  Whyconf.Mprover.fold
    begin fun _ config m ->
      match desc_of_config_prover config with
      | None -> m
      | Some desc -> add desc desc m
    end (Whyconf.get_provers config) empty

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

let load (wenv : Config.why3env) desc config =
  let main = Whyconf.get_main wenv.config in {
    desc ; config ; relaxed = false ;
    driver = Driver.load_driver_for_prover main wenv.env config ;
    digest = digest_config main config ;
  }

let all (wenv : Config.why3env) =
  Whyconf.Mprover.fold
    begin fun _ config m ->
      match desc_of_config_prover config with
      | None -> m
      | Some desc ->
        let main = Whyconf.get_main wenv.config in
        add desc {
          desc ; config ; relaxed = false ;
          driver = Driver.load_driver_for_prover main wenv.env config ;
          digest = digest_config main config ;
        } m
    end (Whyconf.get_provers wenv.config) empty

let all = Config.Whtbl.memoize 5 all

let relaxed p = { p with relaxed = true }

let default wenv =
  let provers = all wenv in
  let select name = try [ select ~name provers ] with Not_found -> [] in
  List.concat_map select [ "alt-ergo" ; "z3" ; "cvc4" ; "cvc5" ]

let filter ~pattern provers =
  try
    let name, version = pattern_of_string pattern in
    Some (select ~name ?version provers)
  with
  | Not_found -> warn_prover_not_found pattern ; None
  | Invalid_pattern s -> warn_invalid_pattern s ; None

let select_all wenv ~patterns =
  let provers = all wenv in
  List.filter_map (fun pattern -> filter ~pattern provers) patterns

let fit prover ~name ~version =
  prover.desc.name = name &&
  match version with
  | None -> true
  | Some v ->  v = prover.desc.version

let retrieve ~name ?version provers =
  let result = List.find_opt (fit ~name ~version) provers in
  begin
    if result = None then warn_prover_not_found @@ pattern ~name ?version () ;
  end ; result
