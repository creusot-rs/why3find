(**************************************************************************)
(*                                                                        *)
(*  SPDX-License-Identifier LGPL-2.1                                      *)
(*  Copyright (C)                                                         *)
(*  CEA (Commissariat à l'énergie atomique et aux énergies alternatives)  *)
(*                                                                        *)
(**************************************************************************)

(* -------------------------------------------------------------------------- *)
(* --- Proof Files                                                        --- *)
(* -------------------------------------------------------------------------- *)

open Why3.Wstdlib

(** Contains CRCs for theories and tasks of a single mlw file.
    The map is indexed first by theory name then by  task name. *)
type strategy = Crc.crc Mstr.t Mstr.t

val filename : string -> string
(** Returns the proofs file associated with the given mlw file *)

type t = { profile : Json.t ; strategy : strategy }

val load : string -> t
(** Load the content of the proofs file associated with the given mlw file. *)

(** Collection of proofs to be saved *)
type buffer

val create : file:string -> Json.t -> strategy -> buffer
val add : Session.theory -> Session.goal -> Crc.crc -> buffer -> unit
val init : Session.theory -> Session.goal list -> Crc.crc Mstr.t -> buffer -> unit
val save : buffer -> unit
