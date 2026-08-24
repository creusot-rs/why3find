(**************************************************************************)
(*                                                                        *)
(*  SPDX-License-Identifier LGPL-2.1                                      *)
(*  Copyright (C)                                                         *)
(*  CEA (Commissariat à l'énergie atomique et aux énergies alternatives)  *)
(*                                                                        *)
(**************************************************************************)

(* -------------------------------------------------------------------------- *)
(* --- Why3Find Environment                                               --- *)
(* -------------------------------------------------------------------------- *)

let prefix = ref ""
let chdir = ref ""
let moved = ref false

let move_to_root () =
  if not !moved then
    begin
      moved := true;
      if !chdir <> "" then
        Utils.chdir !chdir
      else
        match Utils.locate Config.conf_file with
        | Some(dir,path) -> Utils.chdir dir ; prefix := path
        | None -> ()
    end

(* -------------------------------------------------------------------------- *)
(* --- Command Line Options                                               --- *)
(* -------------------------------------------------------------------------- *)

let fast = ref None
let time = ref None
let depth = ref None
let drvs = ref []
let pkgs = ref []
let prvs = ref []
let tacs = ref []
let warn = ref []
let prep = ref None
let jobs = ref 0
let autodetect = ref true
let downloaded = ref true
let autoload = ref false
let loadmissing = ref false
let usecache = ref true

(* -------------------------------------------------------------------------- *)
(* --- Variable Argument Processing                                       --- *)
(* -------------------------------------------------------------------------- *)

type mode =
  | Set
  | Add
  | Sub
  | Move of int

let parse_arg ~mode s =
  let n = String.length s in
  if n > 1 then
    match s.[0] with
    | '+' -> Add, String.sub s 1 (n-1)
    | '-' -> Sub, String.sub s 1 (n-1)
    | _ ->
      let rec digits k =
        if k < n then
          match s.[k] with
          | ':' -> k
          | '0'..'9' -> digits (succ k)
          | _ -> 0
        else 0 in
      let d = digits 0 in
      if d > 0 then
        let at = int_of_string (String.sub s 0 d) in
        Move at, String.sub s (d+1) (n-d-1)
      else mode, s
  else mode, s

(* principal prover name (without '@version') *)
let name p =
  String.lowercase_ascii @@ List.hd @@ String.split_on_char '@' p

(* equal by principal name *)
let eq_name p q = name p = name q

(* has an '@version' qualifier *)
let precise p = String.contains p '@'

(* append or update an item *)
let rec add a = function
  | [] -> [a]
  | p::ps -> if eq_name a p then a :: ps else p :: add a ps

(* remove an item *)
let rec sub a = function
  | [] -> []
  | p::ps -> if eq_name a p then ps else p :: sub a ps

(* current version of the name, if any *)
let rec current a = function
  | [] -> a
  | p::ps -> if eq_name a p then p else current a ps

(* insert at position, starting at 1 *)
let rec insert ~at a = function
  | [] -> [a]
  | p::ps ->
    if eq_name a p then
      if at <= 1 then a :: sub a ps
      else insert ~at a ps
    else
    if at <= 1 then a :: p :: sub a ps
    else p :: insert ~at:(pred at) a ps

let move ~at a ps =
  insert ~at (if precise a then a else current a ps) ps

let rec process config mode = function
  | [] -> config
  | arg :: args ->
    let m, a = parse_arg ~mode arg in
    if a = "none" then
      match m with
      | Set -> process [] Add args
      | Add | Sub | Move _ -> process config mode args
    else
      match m with
      | Set -> process [ a ] Add args
      | Add -> process (add a config) Add args
      | Sub -> process (sub a config) Sub args
      | Move at -> process (move ~at a config) (Move (succ at)) args

let process_args config args =
  process config Set @@ String.split_on_char ',' args

(* -------------------------------------------------------------------------- *)
(* --- Command Line Arguments                                             --- *)
(* -------------------------------------------------------------------------- *)

let setv r v = r := Some v
let getv fd r = match !r with Some v -> v | None -> fd

let geto fd r =
  match !r with
  | None -> fd
  | Some a when a = "none" -> None
  | Some a ->
    match parse_arg ~mode:Set a with
    | (Set | Add | Move _), a -> Some a
    | Sub, a -> Option.bind fd (fun s -> if s = a then None else fd)

let add r a =
  r := a :: !r

let gets fd ropt =
  List.fold_left process_args fd !ropt

type opt = [
  | `All
  | `Package
  | `Prover
  | `Driver
  | `Download
]

let setjobs arg =
  try let n = int_of_string arg in Runner.set_jobs n ; jobs := n
  with _ -> Runner.set_jobs (-1) ; jobs := (-1)

let settime prm s =
  try setv prm (Utils.pa_time s)
  with Invalid_argument _ -> Utils.failwith "Invalid time (-t %s)" s

let alloptions : (opt * string * Arg.spec * string) list = [
  `All, "--root", Arg.Set_string chdir, "DIR change to directory";
  `All, "--why3-warn-off", Arg.String (add warn), "WRN,… disable why3 warnings";
  `Package, "--package", Arg.String (add pkgs), "±PKG,… add package dependency";
  `Prover,  "--fast", Arg.String (settime fast), "TIME fast proof time (default 200ms)";
  `Prover,  "--time", Arg.String (settime time), "TIME median proof time (default 1s)";
  `Prover,  "--depth", Arg.Int (setv depth), "DEPTH proof search limit";
  `Prover,  "--prover", Arg.String (add prvs), "±PRV,… configure provers";
  `Prover,  "--tactic", Arg.String (add tacs), "±TAC,… configure tactics";
  `Prover,  "--preprocess", Arg.String (setv prep), "±TAC configure the preprocessing tactic";
  `Driver,  "--driver", Arg.String (add drvs), "±DRV,… configure drivers";
  `Package, "-p", Arg.String (add pkgs), " same as --package";
  `Prover,  "-t", Arg.String (settime time), " same as --time";
  `Prover,  "-d", Arg.Int (setv depth), " same as --depth";
  `Prover,  "-P", Arg.String (add prvs), " same as --prover";
  `Prover,  "-T", Arg.String (add tacs), " same as --tactic";
  `Driver,  "-D", Arg.String (add drvs), " same as --driver";
  `Prover,  "-j", Arg.String setjobs, "JOBS|'auto' max parallel provers" ;
  `Prover,  "--no-cache", Arg.Clear usecache, "do not read results from cache";
  `Download, "--autoload", Arg.Set autoload, " automatic download of missing provers";
  `Download, "--no-autoload", Arg.Clear loadmissing, " disable downloading of missing provers";
  `Driver, "--no-autodetect", Arg.Clear autodetect, " disable prover autodetection";
  `Driver, "--no-downloaded", Arg.Clear downloaded, " disable downloaded provers";
  `Prover,  "--log-prover-results", Arg.String Runner.set_logfile, "FILE log the prover results in the given file";
]

let options ?(packages=false) ?(provers=false) ?(drivers=false) ?(download=false) ?(missing=false) () =
  let default = not packages && not provers && not drivers in
  autoload := false ;
  loadmissing := missing && download ;
  List.filter_map
    (fun (opt,name,spec,descr) ->
       if match opt with
          | `All -> true
          | `Download -> download
          | `Package -> default || packages
          | `Prover -> default || provers
          | `Driver -> default || drivers
       then Some(name,spec,descr)
       else None
    ) alloptions

let fast config = getv config.Config.fast fast
let time config = getv config.Config.time time
let depth config = getv config.Config.depth depth
let packages config = gets config.Config.packages pkgs
let provers config = gets config.Config.provers prvs
let tactics config = gets config.Config.tactics tacs
let drivers config = gets config.Config.drivers drvs
let warnoff config = gets config.Config.warnoff warn
let preprocess config = geto config.Config.preprocess prep

let arg0 file =
  if Filename.is_relative file then Filename.concat !prefix file else file

let arg1 file = move_to_root () ; arg0 file
let argv files = move_to_root () ; List.map arg1 files

let filter ~exts p = List.mem (Filename.extension p) exts

let ignored p =
  match String.get (Filename.basename p) 0 with
  | 'a'..'z' | 'A'..'Z' | '0'..'9' -> false
  | _ -> true

let allfiles ?exts f path =
  let exts = match exts with Some es -> es | None -> Wutil.exts () in
  if not (Sys.file_exists path) then
    Utils.failwith "Unknown file or directory %S" path ;
  if not (filter ~exts path || Sys.is_directory path) then
    Utils.failwith "File %S is neither a Why3 file nor a directory" path ;
  Utils.iterpath
    ~file:(fun p -> if filter ~exts p then f p)
    ~ignored:(fun p -> ignored p && p <> path)
    path

let argfiles ?exts files =
  begin
    move_to_root () ;
    let paths = ref [] in
    List.iter
      (fun f -> allfiles ?exts (fun p -> paths := p :: !paths) (arg1 f))
      files ;
    List.rev !paths
  end

(* -------------------------------------------------------------------------- *)
(* --- Saving Project Config                                              --- *)
(* -------------------------------------------------------------------------- *)

let save conf =
  let root = Sys.getcwd () in
  Config.save_config ~root conf ;
  Format.printf "Why3find config saved to %s@."
    (Filename.concat root Config.conf_file)

(* -------------------------------------------------------------------------- *)
(* --- Why3 Environment                                                   --- *)
(* -------------------------------------------------------------------------- *)

let default = Config.default

let load_raw_config () =
  move_to_root ();
  Config.load_raw_config ~root:"."

let add_options config =
  {
    Config.fast = fast config ;
    Config.time = time config ;
    Config.depth = depth config ;
    Config.packages = packages config ;
    Config.provers = provers config  ;
    Config.tactics = tactics config ;
    Config.drivers = drivers config ;
    Config.warnoff = warnoff config ;
    Config.preprocess = preprocess config ;
    Config.profile = config.profile ;
  }

let load_config () =
  add_options @@ Config.config_of_json @@ load_raw_config ()

let autodetect () =
  try Sys.getenv "WHY3FIND_AUTODETECT" <> "no" with Not_found -> !autodetect

let downloaded () =
  try Sys.getenv "WHY3FIND_DOWNLOADED" <> "no" with Not_found -> !downloaded

(* Invariant: missing and autoload can never be true at the same time *)

let missing () =
  Utils.tty &&
  downloaded () &&
  match Sys.getenv "WHY3FIND_AUTOLOAD" with
  | "yes" | "no" -> false
  | _ | exception Not_found -> not !autoload && !loadmissing

let autoload () =
  downloaded () &&
  match Sys.getenv "WHY3FIND_AUTOLOAD" with
  | "yes" -> true
  | _ -> false
  | exception Not_found -> !autoload

let init ?root config =
  Project.create
    ?root ~config
    ~usecache:!usecache
    ~autodetect:(autodetect ())
    ~downloaded:(downloaded ())
    ~autoload:(autoload ())
    ~missing:(missing ())
    ()

let save_jobs () =
  if !jobs < 0 then Utils.rmpath ".why3find/jobs" else
  if !jobs > 0 then
    begin
      Utils.mkdirs ".why3find" ;
      Utils.writefile ~file:".why3find/jobs" (string_of_int !jobs) ;
    end

(* -------------------------------------------------------------------------- *)
