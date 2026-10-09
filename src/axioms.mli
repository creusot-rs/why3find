(**************************************************************************)
(*                                                                        *)
(*  SPDX-License-Identifier LGPL-2.1                                      *)
(*  Copyright (C)                                                         *)
(*  CEA (Commissariat à l'énergie atomique et aux énergies alternatives)  *)
(*                                                                        *)
(**************************************************************************)

(* -------------------------------------------------------------------------- *)
(* --- Compute Axioms                                                     --- *)
(* -------------------------------------------------------------------------- *)

type henv
val init : Project.t -> henv

open Why3

type signature
val signature : henv -> Theory.theory -> signature

type parameter = {
  kind : Id.kind ;
  name : Ident.ident ;
  builtin : (Prover.prover * string) list ;
  extern : string option ;
}

val is_free : parameter -> bool
val is_unsafe : parameter -> bool
val is_external : parameter -> bool

val parameter : signature -> Ident.ident -> parameter option
val parameters : signature -> parameter list
val iter : henv -> ?self:bool -> (parameter -> unit) -> Theory.theory list -> unit

(* -------------------------------------------------------------------------- *)
