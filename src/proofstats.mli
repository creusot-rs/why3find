(**************************************************************************)
(*                                                                        *)
(*  SPDX-License-Identifier LGPL-2.1                                      *)
(*  Copyright (C)                                                         *)
(*  CEA (Commissariat à l'énergie atomique et aux énergies alternatives)  *)
(*                                                                        *)
(**************************************************************************)

type pstats = (string,Stats.stats) Hashtbl.t
val add_crc : pstats -> Crc.crc -> unit
val add_strategy : pstats -> Proofs.strategy -> unit
val iter : (string -> Stats.stats -> unit) -> pstats -> unit

type jstats = {
  time : float ;
  stuck : int ;
  proved : int ;
  json : Json.t ;
}

val empty : jstats
val jmap : ('a -> jstats) -> 'a list -> jstats

val stats_session :
  file:string -> path:string ->
  ?lenses:(int,string) Hashtbl.t ->
  Proofs.strategy -> Session.session -> jstats

val statistics : root:string -> env:Why3.Env.env -> files:string list -> jstats
