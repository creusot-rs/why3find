(**************************************************************************)
(*                                                                        *)
(*  SPDX-License-Identifier LGPL-2.1                                      *)
(*  Copyright (C)                                                         *)
(*  CEA (Commissariat à l'énergie atomique et aux énergies alternatives)  *)
(*                                                                        *)
(**************************************************************************)

(** Types representing provers and associated operations *)

(** {1 Prover descriptions} *)

type desc = { name : string ; version : string }
(** The type of prover descriptions, identifying a unique prover version. *)

val desc_to_string : desc -> string
val desc_of_string : string -> desc
(** Converts prover descriptions to and from string. The syntax is the same as
    patterns below, but the version part is mandatory. *)

val desc_of_config_prover : Why3.Whyconf.config_prover -> desc option
(** Returns None for alternative or interactive provers *)

val pp_desc : Format.formatter -> desc -> unit

val compare_version : string -> string -> int
(** Compare version in descending order (most recent comes first). *)

val compare_desc : desc -> desc -> int
(** Compare by prover name, then prover version (most recent comes first). *)

(** {1 Portfolios} *)

type 'a portfolio
val empty : 'a portfolio
val add : desc -> 'a -> 'a portfolio -> 'a portfolio
val mem : desc -> 'a portfolio -> bool
val find : desc -> 'a portfolio -> 'a
val select :
  name:string -> ?version:string -> ?warn:bool -> ?pattern:string ->
  'a portfolio -> 'a option
(** No version means the most recent one, if any.
    Does not warn if [~warn:true] and warns with [~pattern] if provided. *)

val is_empty : 'a portfolio -> bool
val iter : (desc -> 'a -> unit) -> 'a portfolio -> unit

(** {1 Patterns} *)

(** Patterns identify provers. The syntax is [prover-name@prover-version].
    The [prover-name] match the prover name case-insensitively. (eg [alt-ergo]
    match the prover of Why3 name [Alt-Ergo])
    The version part, starting from the '@', is optional. If omitted, it
    generally means the last available version. *)

val pattern : name:string -> ?version:string -> unit -> string

val pattern_name : string -> string
val pattern_version : string -> string option
val pattern_of_string : string -> string * string option
val pmatch : string -> (desc -> bool) (** Compiled from pattern. *)

(** {1 Why3 Config} *)

val config :
  ?autodetect:bool ->
  ?downloaded:bool ->
  ?autoload:string list ->
  ?missing:string list ->
  unit -> Why3.Whyconf.config
(** Configure available provers:
    - use global Why3 configuration
    - use PATH autodetection unless [~autodetect:false]
    - use HOME/.why3find.provers unless [~downloaded:false]
    - auto-download missing provers [~autoload] (if any)
    - ask for downloading provers [~missing] (if any)
*)

val available : Why3.Whyconf.config -> desc portfolio
val shared : name:string -> (string * string) list (* [VERSION,URL;…] sorted *)

(** {1 Provers} *)

type prover = private {
  desc : desc ;
  relaxed : bool ;
  config : Why3.Whyconf.config_prover ;
  driver : Why3.Driver.driver ;
  digest : string ;
}
(** The type of provers.

    [digest] is an hexadecimal digest of the prover and its config. For now,
    drivers are not completely taken into account, for instance modifying a
    driver which is [import]ed into the main driver won't change the digest. *)

val why3_desc : prover -> string
(** The prover descriptions in Why3 syntax. *)

val name : prover -> string
val version : prover -> string
val fullname : prover -> string
val infoname : prover -> string
val relaxed : prover -> prover

val pp_prover : Format.formatter -> prover -> unit
(** Prints prover fullname. *)

val load : Why3.Whyconf.config -> Why3.Env.env -> desc -> Why3.Whyconf.config_prover -> prover
(** Load the prover with its configured drivers *)

val download : name:string -> version:string -> spec:string -> unit
(** Download and install the given prover in binary cache. *)

val provers : Why3.Whyconf.config -> Why3.Env.env -> prover portfolio
