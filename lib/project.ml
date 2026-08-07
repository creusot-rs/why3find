(**************************************************************************)
(*                                                                        *)
(*  SPDX-License-Identifier LGPL-2.1                                      *)
(*  Copyright (C)                                                         *)
(*  CEA (Commissariat à l'énergie atomique et aux énergies alternatives)  *)
(*                                                                        *)
(**************************************************************************)

type env = {
  root : string ;
  cache : Cache.t ;
  config : Config.config ;
  why3 : Config.why3env ;
  pkgs : Meta.pkg list ;
}

let plugins = ref false

let create
    ?(root=".")
    ?(usecache=true)
    ?(autodetect=true)
    ?(downloaded=true)
    ?(patterns=[])
    ?(why3:Why3.Whyconf.config option)
    ?(config=Config.default)
    () =
  let pkgs = Meta.find_all config.Config.packages in
  let pkg_path = List.map (fun m -> m.Meta.path) pkgs in
  let wconfig =
    match why3 with
    | Some config -> config
    | None -> Prover.config ~autodetect ~downloaded ~patterns () in
  if not !plugins then
    begin
      Why3.Whyconf.load_plugins @@
      Why3.Whyconf.get_main wconfig ;
      plugins := true ;
    end ;
  Debug.init_why3_debug ();
  List.iter (fun s ->
      Why3.Loc.disable_warning @@
      Why3.Loc.register_warning s Why3.Pp.empty_formatted
    ) config.warnoff;
  let why3 = Config.why3env ~loadpath:(root :: pkg_path) wconfig in
  let cdir = Filename.concat root ".why3find" in
  let cache = Cache.create ~cdir ~usecache () in
  { root; config ; cache ; why3 ; pkgs }
