(**************************************************************************)
(*                                                                        *)
(*  SPDX-License-Identifier LGPL-2.1                                      *)
(*  Copyright (C)                                                         *)
(*  CEA (Commissariat à l'énergie atomique et aux énergies alternatives)  *)
(*                                                                        *)
(**************************************************************************)

type pstats
val create : unit -> pstats
val add_crc : pstats -> Crc.crc -> unit
val add_strategy : pstats -> Proofs.strategy -> unit
val failed : pstats -> int
val proved : pstats -> int
val total : pstats -> int
val time : pstats -> float
val depth : pstats -> int
val iter_tactics:  (string -> int -> unit) -> pstats -> unit
val iter_provers : (string -> Stats.stats -> unit) -> pstats -> unit

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
