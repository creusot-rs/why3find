(**************************************************************************)
(*                                                                        *)
(*  SPDX-License-Identifier LGPL-2.1                                      *)
(*  Copyright (C)                                                         *)
(*  CEA (Commissariat à l'énergie atomique et aux énergies alternatives)  *)
(*                                                                        *)
(**************************************************************************)

(* -------------------------------------------------------------------------- *)
(* --- Why3find Environment                                               --- *)
(* -------------------------------------------------------------------------- *)

type t = private {
  root : string ;
  cache : Cache.t ;
  config : Config.config ;
  whyconf : Why3.Whyconf.config ;
  env : Why3.Env.env ;
  pkgs : Meta.pkg list ;
  provers : Prover.(prover portfolio) ;
}

val create :
  ?root:string ->
  ?config:Config.config ->
  ?usecache:bool ->
  ?autodetect:bool ->
  ?downloaded:bool ->
  ?autoload:bool ->
  ?missing:bool ->
  unit -> t
(** Create an environment with configuration [config] for the project
    located in [root] (which default to ".").
    See {Prover.config} for prover loading options. *)

val select_tactics : t -> Tactic.tactic list
val select_provers : ?patterns:string list -> t -> Prover.prover list
val select_default : t -> Prover.prover list
