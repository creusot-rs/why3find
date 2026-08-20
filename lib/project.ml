(**************************************************************************)
(*                                                                        *)
(*  SPDX-License-Identifier LGPL-2.1                                      *)
(*  Copyright (C)                                                         *)
(*  CEA (Commissariat à l'énergie atomique et aux énergies alternatives)  *)
(*                                                                        *)
(**************************************************************************)

type t = {
  root : string ;
  cache : Cache.t ;
  config : Config.config ;
  whyconf : Why3.Whyconf.config ;
  env : Why3.Env.env ;
  pkgs : Meta.pkg list ;
  provers : Prover.(prover portfolio) ;
}

let plugins = ref false

let create
    ?(root=".")
    ?(config=Config.default)
    ?(usecache=true)
    ?(autodetect=true)
    ?(downloaded=true)
    ?(autoload=false)
    ?(missing=false)
    () =
  let pkgs = Meta.find_all config.Config.packages in
  let pkg_path = List.map (fun m -> m.Meta.path) pkgs in
  let autoload = if autoload then config.provers else [] in
  let missing= if missing then config.provers else [] in
  let whyconf = Prover.config ~autodetect ~downloaded ~autoload ~missing () in
  if not !plugins then
    begin
      Why3.Whyconf.load_plugins @@
      Why3.Whyconf.get_main whyconf ;
      plugins := true ;
    end ;
  Debug.init_why3_debug ();
  List.iter (fun s ->
      Why3.Loc.disable_warning @@
      Why3.Loc.register_warning s Why3.Pp.empty_formatted
    ) config.warnoff;
  let stdpath = Why3.Whyconf.(loadpath @@ get_main whyconf) in
  let loadpath = root :: pkg_path @ stdpath in
  let env = Why3.Env.create_env loadpath in
  let cdir = Filename.concat root ".why3find" in
  let cache = Cache.create ~cdir ~usecache () in
  let provers = Prover.provers whyconf env in
  { root ; config ; cache ; whyconf ; env ; pkgs ; provers }

let select_tactics prj =
  Tactic.select prj.env prj.config.tactics

let select_provers ?patterns prj =
  List.filter_map
    (fun pattern ->
       let name, version = Prover.pattern_of_string pattern in
       Prover.select ~name ?version ~pattern prj.provers
    ) @@
  match patterns with Some ps -> ps | None -> prj.config.provers

let select_default prj =
  begin
    let pool = ref [] in
    let add p = pool := p :: !pool in
    let select name =
      match Prover.select ~name ~warn:false prj.provers
      with Some p -> add p ; true | None -> false in
    ignore @@ select "alt-ergo" ;
    ignore @@ select "z3" ;
    if not (select "cvc5") then ignore (select "cvc4") ;
    List.rev !pool
  end
