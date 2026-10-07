(**************************************************************************)
(*                                                                        *)
(*  SPDX-License-Identifier LGPL-2.1                                      *)
(*  Copyright (C)                                                         *)
(*  CEA (Commissariat à l'énergie atomique et aux énergies alternatives)  *)
(*                                                                        *)
(**************************************************************************)

(* -------------------------------------------------------------------------- *)
(* ---  Document Lightweight Parsing for LSP                              --- *)
(* -------------------------------------------------------------------------- *)

module Sid = Why3.Ident.Sid

type symbol =
  | Ref of Id.id
  | Def of Id.id
  | Clone of Id.id * Id.id list
  | Section of string

type frame = Frame of {
    name : string ;
    first : Token.position ;
    token : Token.position ;
    kind : Lspserver.kind ;
    stacked : Lspserver.symbol list ;
  }

type doc = {
  project : Project.t ;
  src : Docref.source ;
  input : Token.input ;
  mutable blanklines : int ; (* number of consecutive blanklines so far *)
  mutable closing : Token.position ; (* last code-token before the first *)
  mutable first : Token.position ; (* fist code-token after last blankline *)
  mutable last : Token.position ; (* last code-token so far *)
  mutable current : string option ; (* theory name *)
  mutable thy : Docref.theory option ;
  mutable opened : string list ;
  mutable scopes : string list ;
  mutable declared : Sid.t ;
  mutable cloning : Cloning.state ;
  mutable sections : (string * Lexing.position) list ;
  mutable symbols : Lspserver.symbol list ;
  mutable frame : frame option ;
  mutable stack : frame list ;
  mutable refs : symbol Rangemap.t ;
}

(* -------------------------------------------------------------------------- *)
(* ---  Positions & Ranges                                                --- *)
(* -------------------------------------------------------------------------- *)

let init project src input =
  let here = Token.position input in
  {
    project ; src ; input ; thy = None ; current = None ;
    blanklines = 0 ; closing = here ; first = here ; last = here ;
    opened = [] ; scopes = [] ; sections = [] ;
    declared = Sid.empty ;
    cloning = Cloning.init ;
    symbols = [] ; frame = None ; stack = [] ;
    refs = Rangemap.empty ;
  }

let lexpos (pos : Lexing.position) : Range.pos =
  Range.at ~line:(pos.pos_lnum - 1) ~col:(pos.pos_cnum - pos.pos_bol) ()

let lexrange ((p,q) : Token.position) : Range.range = lexpos p, lexpos q

(* -------------------------------------------------------------------------- *)
(* ---  Document Symbols Stack                                            --- *)
(* -------------------------------------------------------------------------- *)

let flush doc =
  match doc.frame with
  | None -> ()
  | Some (Frame { first ; token ; name ; kind }) ->
    let range = lexrange (fst first,snd doc.closing) in
    let selection = lexrange token in
    let symbol = Lspserver.symbol ~range ~name ~kind ~selection () in
    doc.symbols <- symbol :: doc.symbols ;
    doc.frame <- None

let frame doc name kind =
  flush doc ;
  let token = Token.position doc.input in
  doc.last <- token ;
  doc.closing <- token ;
  doc.frame <- Some (Frame {
      first = doc.first ;
      token ; name ; kind ; stacked = [] ;
    })

let push doc name kind =
  begin
    flush doc ;
    let token = Token.position doc.input in
    doc.last <- token ;
    doc.closing <- token ;
    let frame =
      Frame {
        first = doc.first ;
        token ; name ; kind ;
        stacked = doc.symbols
      } in
    doc.symbols <- [] ;
    doc.stack <- frame :: doc.stack ;
  end

let pop doc =
  flush doc ;
  match doc.stack with
  | [] -> ()
  | Frame { first ; token ; name ; kind ; stacked } :: frames ->
    let children = List.rev doc.symbols in
    let range = lexrange (fst first,snd doc.last) in
    let selection = lexrange token in
    let symbol = Lspserver.symbol ~range ~name ~kind ~selection ~children () in
    begin
      doc.stack <- frames ;
      doc.symbols <- symbol :: stacked ;
    end

let add_symbol doc id =
  try
    let kind : Lspserver.kind =
      match Docref.find_decl doc.project.env doc.src id with
      | Type _ -> `TypeParameter
      | Logic _ -> `Function
      | Var _ -> `Variable
      | Let _ -> `Method
      | Exn _ -> `Event
      | Id.Axiom _ | Id.Lemma _ | Id.Goal _ -> `Property in
    frame doc (Id.name id) kind ;
  with Not_found -> ()

(* -------------------------------------------------------------------------- *)
(* ---  Clones & Identifiers                                              --- *)
(* -------------------------------------------------------------------------- *)

let resolve doc id =
  let root = if doc.src.root = "." then None else Some doc.src.root in
  Id.resolve ~lib:doc.src.lib ?root id

let process_clone_token doc token =
  let state, action = Cloning.process doc.cloning doc.input token in
  doc.cloning <- state ;
  match action with
  | `Nop | `Space | `Spaces _ | `Target _ -> ()
  | `Clone(_,export,pos,id) ->
    match doc.thy with
    | None -> ()
    | Some thy ->
      let scope = Cloning.instance ~scope:doc.scopes ~cloned:id export in
      match Docref.find_instance thy.instances ~scope id with
      | None -> ()
      | Some (Instance s) ->
        let id = resolve doc id in
        let ids =
          List.filter_map
            (function
              | Docref.Inst _ -> None
              | Clone { target } ->
                if Sid.mem target doc.declared then None else
                  ( doc.declared <- Sid.add target doc.declared ;
                    Some (resolve doc target) )
            ) s.clones in
        let symbol = Clone(id,ids) in
        doc.refs <- Rangemap.add (lexrange pos) symbol doc.refs

(* -------------------------------------------------------------------------- *)
(* ---  References                                                        --- *)
(* -------------------------------------------------------------------------- *)

let process_reference doc s =
  try
    let { src ; current } = doc in
    let env = doc.project.env in
    let _, id = Docref.reference ~env ~src ~current s in
    let id = Id.resolve ~lib:src.lib id in
    let pos = Token.position doc.input in
    doc.refs <- Rangemap.add (lexrange pos) (Ref id) doc.refs ;
  with
  | Not_found -> Token.error doc.input "unknown reference"
  | Failure msg -> Token.error doc.input "%s" msg

let process_href doc pos token (href : Docref.href) =
  match href with
  | NoRef ->
    process_clone_token doc (`Name token)
  | Def(id,_) ->
    doc.declared <- Sid.add id.self doc.declared ;
    doc.refs <- Rangemap.add (lexrange pos) (Def id) doc.refs ;
    add_symbol doc id
  | Ref id ->
    process_clone_token doc (`Id id.self) ;
    doc.refs <- Rangemap.add (lexrange pos) (Ref id) doc.refs

let process_identifier ?(infix=false) doc token =
  let pos = Token.position doc.input in
  let href = Docref.resolve ~infix ~src:doc.src ~theory:doc.thy pos in
  process_href doc pos token href

let process_open_module doc kind =
  begin
    let id = Token.fetch_id doc.input ~kind in
    doc.thy <- Docref.Mstr.find_opt id doc.src.theories ;
    doc.current <- Some id ;
    doc.opened <- [] ;
    doc.scopes <- [] ;
    doc.declared <- Sid.empty ;
    doc.cloning <- Cloning.init ;
    push doc id `Module ;
  end

let process_close_module doc =
  begin
    pop doc ;
    doc.thy <- None ;
    doc.current <- None ;
    doc.opened <- [] ;
    doc.scopes <- [] ;
    doc.declared <- Sid.empty ;
    doc.cloning <- Cloning.init ;
  end

let process_opening doc s =
  begin
    doc.opened <- s :: doc.opened ;
    if s = "scope" then
      begin
        let id = Token.fetch_id ~kind:s doc.input in
        push doc id `Namespace ;
        doc.scopes <- id :: doc.scopes ;
      end
  end

let process_closing doc s =
  match doc.opened with
  | k0::ks ->
    doc.opened <- ks ;
    if k0 = "scope" then
      begin
        pop doc ;
        doc.scopes <- List.tl doc.scopes ;
      end
  | [] ->
    Token.error doc.input "No matching opening keyword for '%s" s

let process_word doc s =
  if Docref.is_keyword s then
    begin
      match s with
      | "module" | "theory" -> process_open_module doc s
      | "end" when doc.opened = [] -> process_close_module doc
      | _ ->
        if Docref.is_opening s then process_opening doc s ;
        if Docref.is_closing s then process_closing doc s ;
        process_clone_token doc (`Kwd s)
    end
  else
    process_identifier doc s

let process_open_section doc input s =
  let _,p = Token.position input in
  doc.sections <- (s,p) :: doc.sections

let process_close_section doc input =
  match doc.sections with
  | [] -> ()
  | (s,p) :: sections ->
    let q,_ = Token.position input in
    doc.sections <- sections ;
    doc.refs <- Rangemap.add (lexrange (p,q)) (Section s) doc.refs

let process_block doc = function
  | Token.Newline ->
    doc.blanklines <- succ doc.blanklines

  | Infix _ | Ident _ | Ref _ ->
    let here = Token.position doc.input in
    if doc.blanklines > 0 then
      begin
        doc.closing <- doc.last ;
        doc.first <- here ;
        doc.blanklines <- 0 ;
      end ;
    doc.last <- here

  | Comment _ | Space | Eof
  | Char _ | Text _ | Style _
  | OpenDoc | CloseDoc
  | OpenSection _ | CloseSection _
  | Verb _ | Math _ | Equation _ -> ()

let parse ?doc ?filename ~project ~src file =
  let input = Token.input ?doc ?filename file in
  let doc = init project src input in
  try
    while not @@ Token.eof input do
      let tok = Token.token input in
      process_block doc tok ;
      match tok with

      (* scanned *)
      | Ident s -> process_word doc s
      | Infix s -> process_identifier ~infix:true doc s
      | Ref s -> process_reference doc s
      | Newline -> process_clone_token doc `Newline
      | Comment _ -> process_clone_token doc `Comment

      (* folding *)
      | OpenSection (_, s) -> process_open_section doc input s
      | CloseSection _ -> process_close_section doc input

      (* skipped *)
      | Eof
      | Char _ | Text _
      | OpenDoc | CloseDoc
      | Space | Style (_, _) | Verb _ | Math _ | Equation _ -> ()

    done ;
    Token.close input ;
    doc.refs, doc.symbols
  with exn ->
    Token.close input ;
    raise exn
