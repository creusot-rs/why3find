(**************************************************************************)
(*                                                                        *)
(*  SPDX-License-Identifier LGPL-2.1                                      *)
(*  Copyright (C)                                                         *)
(*  CEA (Commissariat à l'énergie atomique et aux énergies alternatives)  *)
(*                                                                        *)
(**************************************************************************)

(* -------------------------------------------------------------------------- *)
(* --- Transport Layer                                                    --- *)
(* -------------------------------------------------------------------------- *)

type channel = {
  rd : Unix.file_descr ; (* Input (socket or standard input) *)
  wr : Unix.file_descr ; (* Output (socket or standard output) *)
  rcv : bytes ; (* RCV bytes buffer, re-used for transport *)
  snd : bytes ; (* SND bytes buffer, re-used for transport *)
  brcv : Buffer.t ; (* RCV data buffer, accumulated *)
  bsnd : Buffer.t ; (* SND data buffer, accumulated *)
}

let read_bytes { rd ; rcv ; brcv ; bsnd } =
  (* rcv buffer is only used locally *)
  let s = Bytes.length rcv in
  let rec scan p =
    (* try to fill RCV buffer *)
    let n =
      try
        let n = Unix.read rd rcv p (s-p) in
        if n = 0 && p = 0 then raise End_of_file ; n
      with Unix.Unix_error((EAGAIN|EWOULDBLOCK),_,_) -> 0
    in
    let p = p + n in
    if n > 0 && p < s then scan p else p
  in
  match scan 0 with
  | n -> if n > 0 then Buffer.add_subbytes brcv rcv 0 n
  | exception End_of_file ->
    (* The peer closed the connection: leave once the pending messages are
       processed and answered *)
    if Buffer.length brcv = 0 && Buffer.length bsnd = 0 then begin
      Log.message "Client disconnected." ; exit 0
    end

let send_bytes { wr ; snd ; bsnd } =
  (* snd buffer is only used locally *)
  let n = Buffer.length bsnd in
  if n > 0 then
    let s = Bytes.length snd in
    let rec send p =
      (* try to flush BSND buffer *)
      let w = min (n-p) s in
      Buffer.blit bsnd p snd 0 w ;
      let r =
        try Unix.single_write wr snd 0 w
        with Unix.Unix_error((EAGAIN|EWOULDBLOCK),_,_) -> 0
      in
      let p = p + r in
      if r > 0 && p < n then send p else p
    in
    let p = send 0 in
    if p > 0 then
      let tail = Buffer.sub bsnd p (n-p) in
      Buffer.reset bsnd ;
      Buffer.add_string bsnd tail

let yield chan =
  begin
    send_bytes chan ;
    read_bytes chan ;
  end

let flush = send_bytes

let processing { brcv ; bsnd } =
  Buffer.length brcv > 0 || Buffer.length bsnd > 0

(* -------------------------------------------------------------------------- *)
(* --- Establish Protocol                                                 --- *)
(* -------------------------------------------------------------------------- *)

type transport =
  | PIPE of string
  | PORT of int
  | STDIO (* the protocol uses the standard input and output *)

let socket = function
  | PORT port ->
    Log.message "Socket port %d" port ;
    let fd = Unix.socket ~cloexec:true PF_INET SOCK_STREAM 0 in
    Unix.setsockopt fd SO_REUSEADDR true ;
    let localhost = Unix.inet_addr_of_string "0.0.0.0" in
    Unix.bind fd (ADDR_INET(localhost,port)) ; fd
  | PIPE file ->
    Log.message "Socket pipe %s" file ;
    if Sys.file_exists file then Unix.unlink file ;
    let fd = Unix.socket PF_UNIX SOCK_STREAM 0 in
    Unix.bind fd (ADDR_UNIX file) ; fd
  | STDIO -> invalid_arg "Rpc.socket"

let set_socket_size socket opt s =
  begin
    let nbytes = s * 1024 in
    begin
      try Unix.setsockopt_int socket opt nbytes
      with Unix.Unix_error(err,_,_) ->
        let msg = Unix.error_message err in
        Log.warning "Invalid socket size (%d: %s)" nbytes msg ;
    end ;
    Unix.getsockopt_int socket opt
  end

(* The standard output is kept for the protocol (not inherited by the
   provers), the descriptor 1 is redirected to the standard error: logs and
   output of the provers can not corrupt the protocol. *)
let establish_stdio () =
  let out = Unix.dup ~cloexec:true Unix.stdout in
  Unix.set_nonblock out ;
  Unix.set_nonblock Unix.stdin ;
  Unix.dup2 Unix.stderr Unix.stdout ;
  (* the description of stdin may be shared with other processes *)
  at_exit (fun () -> try Unix.clear_nonblock Unix.stdin with _ -> ()) ;

  let rcv = 65536 and snd = 65536 in {
    rd = Unix.stdin ; wr = out ;
    snd = Bytes.create snd ;
    rcv = Bytes.create rcv ;
    bsnd = Buffer.create snd ;
    brcv = Buffer.create rcv ;
  }

let establish = function
  | STDIO -> establish_stdio ()
  | transport ->
  let exception Channel of channel in
  try
    let fd = try socket transport with exn ->
      Log.error "Socket: %s" (Printexc.to_string exn) ;
      exit 1 in
    Unix.listen fd 1 ;
    while true do
      try
        Log.message "Waiting..." ;
        let socket,_addr = Unix.accept ~cloexec:true fd in
        Unix.set_nonblock socket ;
        let rcv = set_socket_size socket SO_RCVBUF 256 in
        let snd = set_socket_size socket SO_SNDBUF 256 in
        let server = {
          rd = socket ; wr = socket ;
          snd = Bytes.create snd ;
          rcv = Bytes.create rcv ;
          bsnd = Buffer.create snd ;
          brcv = Buffer.create rcv ;
        } in
        Log.message "Client connected." ;
        raise (Channel server)
      with
      | Unix.Unix_error(EAGAIN,_,_) ->
        Unix.sleepf 0.1 ; (* 100ms *)
      | Unix.Unix_error(EPIPE,_,_) ->
        Log.message "Client disconnected." ;
        Unix.close fd ; exit 0
    done ;
    assert false
  with Channel server -> server

(* -------------------------------------------------------------------------- *)
(* --- Decoding Base Protocole                                            --- *)
(* -------------------------------------------------------------------------- *)

let ahead = "\r\n\r\n"
let content_length = Str.regexp "Content-Length: \\([0-9]+\\)\r\n"

let rec lookahead buf s p =
  if s = 4 then p else
    let s' = if ahead.[s] = Buffer.nth buf p then s+1 else 0 in
    (lookahead[@tailrec]) buf s' (p+1)

let pull { brcv } =
  try
    let h = lookahead brcv 0 0 in
    let head = Buffer.sub brcv 0 h in
    ignore @@ Str.search_forward content_length head 0 ;
    let d = int_of_string @@ Str.matched_group 1 head in
    let n = Buffer.length brcv in
    let data = Buffer.sub brcv h d in
    let tail = Buffer.sub brcv (h+d) (n-h-d) in
    Buffer.clear brcv ;
    Buffer.add_string brcv tail ;
    Some data
  with Not_found | Invalid_argument _ -> None

let push { bsnd } data =
  begin
    let n = String.length data in
    Printf.bprintf bsnd "Content-Length: %d\r\n\r\n%s" n data ;
  end

(* -------------------------------------------------------------------------- *)
