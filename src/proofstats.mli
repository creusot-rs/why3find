(**************************************************************************)
(*                                                                        *)
(*  SPDX-License-Identifier LGPL-2.1                                      *)
(*  Copyright (C)                                                         *)
(*  CEA (Commissariat à l'énergie atomique et aux énergies alternatives)  *)
(*                                                                        *)
(**************************************************************************)

type jstats = { time : float ; stuck : int ; proved : int ; json : Json.t }

val empty : jstats
val jmap : ('a -> jstats) -> 'a list -> jstats

val stats_session :
  Why3.Env.env -> file:string -> path:string -> Proofs.strategy -> Session.session -> jstats

val statistics : root:string -> env:Why3.Env.env -> files:string list -> jstats
