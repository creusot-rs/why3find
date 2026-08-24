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

let pattern_of_string s =
  match String.split_on_char '@' s with
  | [] -> "?", None
  | [ name ] -> String.lowercase_ascii name, None
  | name :: version :: _ -> String.lowercase_ascii name, Some version

let pattern_name s = fst @@ pattern_of_string s
let pattern_version s = snd @@ pattern_of_string s

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
  let (name, version) = pattern_of_string s in
  { name ; version = Option.get version }

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

let by_version u v = compare_version (fst u) (fst v)

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

let warn_prover_not_found =
  Why3.Wstdlib.Hstr.memo 5 (fun p -> Log.warning "prover %s not found" p)

let select
    ~name ?version ?(warn=true) ?pattern:spec
    (m : 'a portfolio) : 'a option =
  try
    let w = Smap.find name m in
    let a =
      match version with
      | Some v -> Vmap.find v w
      | None -> snd @@ Vmap.min_binding w
    in Some a
  with Not_found ->
    if warn then
      begin
        warn_prover_not_found @@
        match spec with Some s -> s | None -> pattern ~name ?version ()
      end ;
    None

let is_empty = Smap.is_empty

let iter f m =
  Smap.iter
    (fun name w -> Vmap.iter
        (fun version x ->
           f { name ; version } x
        ) w) m

let iterl f m =
  Smap.iter (fun name w -> f name @@ Vmap.bindings w) m

let portfolio f config =
  Whyconf.Mprover.fold
    begin fun _ config m ->
      match desc_of_config_prover config with
      | None -> m
      | Some desc -> add desc (f desc config) m
    end (Whyconf.get_provers config) empty

(* -------------------------------------------------------------------------- *)
(* --- Matching                                                           --- *)
(* -------------------------------------------------------------------------- *)

let pmatch pattern =
  let name,version = pattern_of_string pattern in
  fun d ->
    d.name = name &&
    match version with None -> true | Some v -> d.version = v

(* -------------------------------------------------------------------------- *)
(* --- Downloaded Provers                                                 --- *)
(* -------------------------------------------------------------------------- *)

let binarycache = lazy
  begin
    try Sys.getenv "WHY3FIND_PROVERS" with Not_found ->
      let xdg_cache = Xdg.cache_dir @@ Xdg.create ~env:Sys.getenv_opt () in
      Filename.concat xdg_cache "why3find/provers"
  end

let find_downloaded_provers () =
  let cache = Lazy.force binarycache in
  let files = try Sys.readdir cache with _ -> [| |] in
  let provers = ref [] in
  Array.iter
    (fun file ->
       match String.split_on_char '@' file with
       | [ name ; version ] ->
         let path = Filename.concat cache file in
         provers := (path,name,version) :: !provers
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

let downloadrc ~name ~version ~spec =
  Utils.flush () ;
  Utils.hline () ;
  Printf.printf "  Downloading %s@%s\n" name version ;
  Utils.hline () ;
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
        begin
          if Filename.check_suffix file ".zip" then
            command ~prover ~step:"Unpack" "unzip %s %s" file path
          else
            command ~prover ~step:"Unpack" "tar zxf %s %s" file path
        end ; path
    in
    command ~prover ~step:"Permissions" "chmod a+x %s" binary ;
    if Version.system = "macosx" then
      begin
        command ~prover ~step:"Quarantine"
          "xattr -dr com.apple.quarantine %s" binary ;
        command ~prover ~step:"Autosign"
          "codesign -s - --deep --force %s" binary ;
      end ;
    begin
      let config = Why3.Whyconf.init_config ~extra_config:[] None in
      let data = Why3.Autodetection.read_auto_detection_data config in
      match Why3.Autodetection.find_prover data name binary with
      | None | Some "" ->
        Log.warning "Unrecognized version for %s (use %s)" name version
      | Some vp ->
        if vp <> version then
          Log.error "Incorrect version for %s (use %s)" name version
    end ;
    let cache = Lazy.force binarycache in
    Utils.mkdirs cache ;
    command ~prover ~step:"Installation" "mv -f %s %s/%s" binary cache prover ;
    Utils.flush () ;
    Sys.chdir pwd ;
    command ~prover ~step:"Cleaning" "rm -fr %s" tmp ;
    Utils.flush () ;
    Format.printf "Installed prover %s@." prover ;
    Utils.hline () ;
    Filename.concat binary prover, name, version
  with err ->
    Sys.chdir pwd ;
    Utils.flush () ;
    command ~prover ~step:"Cleaning" "rm -fr %s" tmp ;
    Utils.hline () ;
    raise err

let download ~name ~version ~spec = ignore @@ downloadrc ~name ~version ~spec

let shared ~name =
  List.sort by_version @@
  Json.jassoc Json.jstring @@ Json.of_file @@ Meta.shared @@
  let open Version in
  Printf.sprintf "provers/%s.%s.%s.json" name system architecture

(* -------------------------------------------------------------------------- *)
(* --- Missing Provers                                                    --- *)
(* -------------------------------------------------------------------------- *)

let missed = ref 0
let installed = ref 0

let ask name version =
  Utils.tty &&
  match
    String.uppercase_ascii @@
    Utils.ask ~default:"Y"
      "Missing prover @{<bold>%s@@%s@}. Download @{<bold>[Y/n]@} ?" name version
  with "Y" | "YES" -> true | _ -> false

let add_missing ~auto provers pattern =
  let name, version = pattern_of_string pattern in
  let pmatch (_,p,v) =
    String.lowercase_ascii p = name &&
    match version with None -> true | Some version -> v = version
  in
  if List.exists pmatch provers then provers else
    try
      incr missed ;
      let specs = shared ~name in
      let version,spec =
        match version with
        | Some v -> v, List.assoc v specs
        | None -> List.hd specs in
      if not auto && not @@ ask name version then raise Exit ;
      let prv = downloadrc ~name ~version ~spec in
      incr installed ; prv :: provers
    with
    | Exit -> provers
    | Not_found ->
      warn_prover_not_found pattern ; provers
    | _exn ->
      Log.warning "Can not download missing prover %s" pattern ; provers

(* -------------------------------------------------------------------------- *)
(* --- Prover Scanning                                                    --- *)
(* -------------------------------------------------------------------------- *)

let rc_prover_section (path,name,version) =
  let s = Why3.Rc.empty_section in
  let s = Why3.Rc.set_string s "name" name in
  let s = Why3.Rc.set_string s "path" path in
  let s = Why3.Rc.set_string s "version" version in s

let config ?(autodetect=true) ?(downloaded=true) ?(autoload=[]) ?(missing=[]) () =
  (* load the Why3 user's config first, if any *)
  let config = Why3.Whyconf.init_config ~extra_config:[] None in
  let data = Why3.Autodetection.read_auto_detection_data config in
  (* downloaded provers *)
  let ps = if downloaded then find_downloaded_provers () else [] in
  (* prover autodetection *)
  let qs = if autodetect then Why3.Autodetection.find_provers data else [] in
  (* download missing provers *)
  missed := 0 ;
  installed := 0 ;
  let provers = List.fold_left (add_missing ~auto:true) (ps @ qs) autoload in
  let provers = List.fold_left (add_missing ~auto:false) provers missing in
  if !missed > 1 then
    if !installed = 0 then
      Format.printf "Missing %d provers.@." !missed
    else
      Format.printf "Downloaded %d/%d missing provers.@." !installed !missed ;
  (* complete configuration *)
  if provers <> [] then
    !Why3.Whyconf.provers_from_detected_provers config @@
    Why3.Rc.set_simple_family Why3.Rc.empty "partial_prover" @@
    List.map rc_prover_section provers
  else config

let available whyconf = portfolio (fun d _ -> d) whyconf

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

let load whyconf env desc config =
  let main = Whyconf.get_main whyconf in
  let digest = digest_config main config in
  let driver = Driver.load_driver_for_prover main env config in
  { desc ; config ; relaxed = false ; driver ; digest }

let provers whyconf env = portfolio (load whyconf env) whyconf

let relaxed p = { p with relaxed = true }
