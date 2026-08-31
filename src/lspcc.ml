(**************************************************************************)
(*                                                                        *)
(*  SPDX-License-Identifier LGPL-2.1                                      *)
(*  Copyright (C)                                                         *)
(*  CEA (Commissariat à l'énergie atomique et aux énergies alternatives)  *)
(*                                                                        *)
(**************************************************************************)

let init () = () (* for dependencies only *)

(* -------------------------------------------------------------------------- *)
(* ---  Source Management                                                 --- *)
(* -------------------------------------------------------------------------- *)

type source = {
  project : Project.t ;
  src : Docref.source ;
  refs : Srcref.symbol Rangemap.t ;
  types : Namespace.t ;
  symbols : Lspserver.symbol list ;
  mutable updates : Lspserver.update list ;
}

let sources = Hashtbl.create 0
let set_source ~filename project src refs types symbols =
  Hashtbl.replace sources filename {
    project ; src ; refs ; types ; symbols ; updates = [] ;
  }

let find_decl (source:source) id =
  Docref.find_decl source.project.env source.src id

(* -------------------------------------------------------------------------- *)
(* --- Compiler for the LSP Server                                        --- *)
(* -------------------------------------------------------------------------- *)

let of_loc (loc : Why3.Loc.position) : string * Range.range =
  let file,l1,c1,l2,c2 = Why3.Loc.get loc in
  let start = Range.at ~line:(l1-1) ~col:c1 () in
  let stop = Range.at ~line:(l2-1)~col:c2 () in
  file , (start, stop)

type lexpos = Lexing.position * Lexing.position

let range_of_pos ((p,q) : lexpos) : string * Range.range =
  let file = p.pos_fname in
  let p = Range.at ~line:(p.pos_lnum - 1) ~col:(p.pos_cnum - p.pos_bol) () in
  let q = Range.at ~line:(q.pos_lnum - 1) ~col:(q.pos_cnum - q.pos_bol) () in
  file , (p,q)

let preprocess file diagnostics =
  try
    let warning (f,range) message =
      if f = file then
        let severity = `Warning in
        let diag = Lspserver.diagnostic ~range ~severity ~message () in
        diagnostics := diag :: !diagnostics
      else
        Format.printf "[Warning] File %s, line %d: %s@."
          f (1+(fst range).line) message
    in
    Why3.Loc.set_warning_hook
      begin fun ?loc message ->
        match loc with
        | None -> Format.printf "[Warning] %s@." message
        | Some loc -> warning (of_loc loc) message
      end ;
    Token.set_handler
      begin fun input message ->
        warning (range_of_pos @@ Token.position input) message
      end ;
    let root =
      match Config.root_for file with
      | None -> Filename.dirname file
      | Some root -> root
    in
    Hashtbl.remove sources file ;
    let config = Config.load_config ~root in
    let project = Wenv.init ~root config in
    let wenv = project.env in
    let henv = Axioms.init project in
    let _,path,lib = Wutil.filepath ~root ~file in
    let cache = Cache.create ~root () in
    let parser = Docref.source ~cache ~wenv ~henv ~lib ~root ~path ~file in
    let src = Utils.input ~file:file parser in
    let types =
      Why3.Wstdlib.Mstr.fold
        (fun _ (t : Docref.theory) d ->
           Namespace.add_types ~lib:src.lib t.theory d)
        src.theories Namespace.empty in
    let refs, symbols = Srcref.parse ~doc:false ~project ~src file in
    set_source ~filename:file project src refs types symbols ;
  with
  | Why3.Loc.Located(loc,exn) ->
    let file,range = of_loc loc in
    if file = file then
      let severity = `Error in
      let message = Printexc.to_string exn in
      let diag = Lspserver.diagnostic ~range ~severity ~message () in
      diagnostics := diag :: !diagnostics
    else
      Format.printf "[Warning]@[ File %a:@ %a@]@."
        Wutil.pp_position loc Why3.Exn_printer.exn_printer exn
  | exn ->
    Format.printf "[Error] %s@." (Printexc.to_string exn)

let compile channel doc =
  let Lspserver.Doc { uri } = doc in
  match Lspserver.to_file ~uri with
  | None -> ()
  | Some filename ->
    if Filename.check_suffix filename ".mlw" then
      begin
        let diagnostics = ref [] in
        preprocess filename diagnostics ;
        Lspserver.publish_diagnostic channel ~uri !diagnostics ;
        Lspserver.refresh_codelens channel ;
        Lspserver.refresh_folding channel ;
      end

let update _channel ~uri update =
  match Lspserver.to_file ~uri with
  | None -> ()
  | Some filename ->
    match Hashtbl.find sources filename with
    | exception Not_found -> ()
    | source -> source.updates <- update :: source.updates

let () = Lspserver.on_open compile
let () = Lspserver.on_save compile
let () = Lspserver.on_update update

(* -------------------------------------------------------------------------- *)
(* --- References                                                         --- *)
(* -------------------------------------------------------------------------- *)

let rec backward updates pos =
  match updates with
  | [] -> Some pos
  | upd::updates ->
    Option.bind (Lspserver.backward_position upd pos) (backward updates)

let rec forward updates pos =
  match updates with
  | [] -> Some pos
  | upd::updates ->
    Option.bind (Lspserver.forward_position pos upd) (forward updates)

let forward_range updates (start,stop) =
  match forward updates start , forward updates stop with
  | Some start , Some stop -> Some (start,stop)
  | _ -> None

let locate ~uri (pos : Range.pos) =
  match Lspserver.to_file ~uri with
  | None -> raise Not_found
  | Some filename ->
    let src = Hashtbl.find sources filename in
    match backward src.updates pos with
    | None -> raise Not_found
    | Some pos ->
      let rg,symbol = Rangemap.find pos src.refs in
      filename, src, rg, symbol

(* -------------------------------------------------------------------------- *)
(* --- Goto Definition                                                    --- *)
(* -------------------------------------------------------------------------- *)

let goto = function
  | None -> raise Not_found
  | Some loc ->
    let filename,range = of_loc loc in
    let uri = Lspserver.to_uri ~filename in
    Lspserver.Loc { uri ; range }

let definition _channel ~uri (pos : Range.pos) =
  let _,_,_,s = locate ~uri pos in
  match s with
  | Def _ | Section _ -> []
  | Ref id | Clone(id,_) -> [goto id.self.id_loc]

let () = Lspserver.on_definition definition

let typeof_ty (ty : Why3.Ty.ty) =
  match ty.ty_node with
  | Why3.Ty.Tyvar _ -> raise Not_found
  | Why3.Ty.Tyapp (ts, _) -> ts

let typeof_decl = function
  | Id.Type(ts,_) -> ts
  | Id.Logic { ls_value = Some result } -> typeof_ty result
  | Id.Var pv -> typeof_ty pv.pv_vs.vs_ty
  | Id.Let r -> typeof_ty @@ Why3.Ity.ty_of_ity r.rs_cty.cty_result
  | Id.Exn x -> typeof_ty @@ Why3.Ity.ty_of_ity x.xs_ity
  | Id.Logic { ls_value = None }
  | Id.Axiom _ | Id.Lemma _ | Id.Goal _ -> raise Not_found

let typedef _channel ~uri (pos : Range.pos) =
  let _,src,_,s = locate ~uri pos in
  match s with
  | Section _ -> []
  | Def id | Ref id | Clone(id,_) ->
    try
      let ts = typeof_decl @@ find_decl src id in
      [goto ts.ts_name.id_loc]
    with Not_found ->
      [goto id.self.id_loc]

let () = Lspserver.on_definition ~kind:`Typedef typedef

(* -------------------------------------------------------------------------- *)
(* --- Proof Results                                                      --- *)
(* -------------------------------------------------------------------------- *)

let get_proof source (id : Id.id) =
  let thy = Docref.Mstr.find_opt id.id_mod source.src.theories in
  Docref.find_proof id.self thy

(* -------------------------------------------------------------------------- *)
(* --- Symbol Printers                                                    --- *)
(* -------------------------------------------------------------------------- *)

let lib = ref []
let types = ref Namespace.empty
let scoped = ref false
let pp_typename fmt id =
  Id.pp_qid fmt @@ Namespace.find ~lib:!lib id !types
let pp_name fmt (id : Why3.Ident.ident) =
  Format.pp_print_string fmt (Id.of_infix id.id_string)
let pp_scoped fmt (id : Why3.Ident.ident) =
  if !scoped then
    let _,_,qid = Id.path id in Id.pp_qid fmt qid
  else pp_name fmt id

let pp_infix fmt (id : Why3.Ident.ident) =
  Format.pp_print_string fmt (Id.of_infix id.id_string)

let pp_tvar fmt (x : Why3.Ty.tvsymbol) =
  Format.fprintf fmt "'%a" pp_name x.tv_name

let builtins =
  let open Why3.Ty in
  Mts.add ts_int "int" @@
  Mts.add ts_bool "bool" @@
  Mts.add ts_real "real" @@
  Mts.add ts_str "string" @@
  Mts.empty

let pp_tsymbol fmt ts =
  try Format.pp_print_string fmt @@ Why3.Ty.Mts.find ts builtins
  with Not_found -> pp_typename fmt ts.ts_name

let rec ppt ~par fmt (t : Why3.Ty.ty) =
  match t.ty_node with
  | Why3.Ty.Tyvar x -> pp_tvar fmt x
  | Why3.Ty.Tyapp (t, ts) when Why3.Ty.is_ts_tuple t -> pp_tuple fmt ts
  | Why3.Ty.Tyapp (t, [a;b]) when Why3.Ty.(ts_equal t ts_func) ->
    Format.fprintf fmt "@[<hov 2>(%a@ -> %a)@]" pp_type a pp_func b ;
  | Why3.Ty.Tyapp (t, []) -> pp_tsymbol fmt t
  | Why3.Ty.Tyapp (t, ts) ->
    Format.fprintf fmt "@[<hov 2>" ;
    if par then Format.pp_print_char fmt '(' ;
    pp_typename fmt t.ts_name ;
    List.iter (Format.fprintf fmt "@ %a" pp_subtype) ts ;
    if par then Format.pp_print_char fmt ')' ;
    Format.fprintf fmt "@]"

and pp_tuple fmt = function
  | [] -> Format.pp_print_string fmt "unit"
  | t::ts ->
    Format.fprintf fmt "@[<hov 2>(%a" pp_type t ;
    List.iter (Format.fprintf fmt ",@ %a" pp_type) ts ;
    Format.fprintf fmt ")@]"

and pp_func fmt t =
  match t.ty_node with
  | Why3.Ty.Tyapp (t, [a;b]) when Why3.Ty.(ts_equal t ts_func) ->
    Format.fprintf fmt "%a@ -> %a" pp_type a pp_func b
  | _ -> pp_type fmt t

and pp_type fmt t = ppt ~par:false fmt t
and pp_subtype fmt t = ppt ~par:true fmt t

let is_record (c : Why3.Decl.constructor) =
  List.for_all (function None -> false | Some _ -> true) @@ snd c

let is_unit ty = Why3.Ity.(ity_equal ty ity_unit)

let pp_pty fmt ty =
  pp_subtype fmt @@ Why3.Ity.ty_of_ity ty

let pp_rty fmt ty =
  pp_type fmt @@ Why3.Ity.ty_of_ity ty

let pp_field fmt (f : Why3.Term.lsymbol option) =
  match f with
  | None -> ()
  | Some ls ->
    Format.fprintf fmt "@ @[<hov 2>%a:@ %a ;@]"
      pp_name ls.ls_name
      pp_type (Option.value ~default:Why3.Ty.ty_bool ls.ls_value)

let pp_constr fmt (c : Why3.Decl.constructor) =
  let ls = fst c in
  Format.fprintf fmt "@ | %a" pp_name ls.ls_name ;
  List.iter (Format.fprintf fmt " %a" pp_subtype) ls.ls_args

let pp_tdecl fmt (ts : Why3.Ty.tysymbol) =
  pp_scoped fmt ts.ts_name ;
  List.iter (Format.fprintf fmt " %a" pp_tvar) ts.ts_args

let pp_vdecl fmt (pv : Why3.Ity.pvsymbol) =
  if pv.pv_ghost then Format.fprintf fmt "ghost " ;
  let vs = pv.pv_vs in
  Format.fprintf fmt "%a : %a" pp_scoped vs.vs_name pp_type vs.vs_ty

let pp_varg ~ghost fmt (pv : Why3.Ity.pvsymbol) =
  if not ghost && pv.pv_ghost
  then Format.fprintf fmt "(ghost %a)" pp_rty pv.pv_ity
  else pp_pty fmt pv.pv_ity

let pp_kind fmt (kind : Why3.Expr.rs_kind) =
  match kind with
  | RKnone | RKlocal -> ()
  | RKfunc -> Format.pp_print_string fmt "function "
  | RKpred -> Format.pp_print_string fmt "predicate "
  | RKlemma -> Format.pp_print_string fmt "lemma "

let pp_decl fmt (d : Id.decl) =
  match d with
  | Id.Type (t, []) ->
    begin
      match t.ts_def with
      | Why3.Ty.NoDef ->
        Format.fprintf fmt "type %a" pp_tdecl t
      | Why3.Ty.Alias ty ->
        Format.fprintf fmt "type %a = %a" pp_tdecl t pp_type ty
      | Why3.Ty.Range { ir_lower ; ir_upper } ->
        Format.fprintf fmt "type %a = <range %s %s>" pp_scoped t.ts_name
          (Why3.BigInt.to_string ir_lower)
          (Why3.BigInt.to_string ir_upper)
      | Why3.Ty.Float ff ->
        Format.fprintf fmt "type %a = <float %d %d>" pp_scoped t.ts_name
          ff.fp_significand_digits ff.fp_exponent_digits
    end
  | Id.Type (t, [r]) when is_record r ->
    Format.fprintf fmt "@[<hv 0>@[<hv 2>type %a = {" pp_tdecl t ;
    List.iter (pp_field fmt) @@ snd r ;
    Format.fprintf fmt "@]@ }@]"
  | Id.Type (t, cs) ->
    Format.fprintf fmt "@[<hv 2>type %a =" pp_tdecl t ;
    List.iter (pp_constr fmt) cs ;
    Format.fprintf fmt "@]"
  | Id.Logic ls ->
    let kind = if ls.ls_value = None then "predicate" else "function" in
    Format.fprintf fmt "@[<hv 2>%s %a" kind pp_infix ls.ls_name ;
    List.iter (Format.fprintf fmt "@ %a" pp_subtype) ls.ls_args ;
    Option.iter (Format.fprintf fmt "@ : %a" pp_type) ls.ls_value ;
    if ls.ls_proj then Format.fprintf fmt "@ (* field *)" ;
    if ls.ls_constr > 0 then Format.fprintf fmt "@ (* constructor *)" ;
    Format.fprintf fmt "@]"
  | Id.Var x ->
    Format.fprintf fmt "@[<hov 2>val %a@]" pp_vdecl x
  | Id.Let r ->
    begin
      Format.fprintf fmt "@[<hov 2>val " ;
      let kind = Why3.Expr.rs_kind r in
      let ghost = Why3.Expr.rs_ghost r in
      if ghost && kind <> RKlemma then Format.fprintf fmt "ghost " ;
      pp_kind fmt kind ;
      pp_scoped fmt r.rs_name ;
      let args = r.rs_cty.cty_args in
      List.iter (Format.fprintf fmt "@ %a" (pp_varg ~ghost)) args ;
      Format.fprintf fmt "@ : %a@]" pp_rty r.rs_cty.cty_result
    end
  | Id.Exn x ->
    Format.fprintf fmt "@[<hov 2>exception %a" pp_scoped x.xs_name ;
    let ty = x.xs_ity in
    if not @@ is_unit ty then Format.fprintf fmt " : %a" pp_rty ty ;
    Format.fprintf fmt "@]"
  | Id.Axiom p -> Format.fprintf fmt "@[<hov 2>axiom %a@]" pp_scoped p.pr_name
  | Id.Lemma p -> Format.fprintf fmt "@[<hov 2>lemma %a@]" pp_scoped p.pr_name
  | Id.Goal p -> Format.fprintf fmt "@[<hov 2>goal %a@]" pp_scoped p.pr_name

let clear () =
  begin
    lib := [] ;
    types := Namespace.empty ;
    scoped := false ;
  end

let context source ?(scope=false) fn =
  try
    lib := source.src.lib ;
    types := source.types ;
    scoped := scope ;
    let r = fn () in
    clear () ; r
  with exn ->
    clear () ; raise exn

let code source id =
  context source
    begin fun () ->
      try Some (Format.asprintf "%a" pp_decl @@ find_decl source id)
      with Not_found -> None
    end

let clone source ids =
  let ds =
    List.filter_map
      (fun id -> try Some (id, find_decl source id) with Not_found -> None) ids in
  if ds = [] then None else
    context source ~scope:true
      begin fun () ->
        let tt =
          Format.asprintf "scope%t@\nend"
            begin fun fmt ->
              List.iter
                (fun (id,decl) ->
                   Option.iter
                     (Format.fprintf fmt "@\n  (* %a *)" Crc.pp_hint)
                     (get_proof source id) ;
                   Format.fprintf fmt "@\n  %a" pp_decl decl ;
                ) ds
            end
        in Some tt
      end

let mk_hover range ~title ?code ?(infos=[]) () =
  let code =
    match code with
    | None -> []
    | Some tt -> Lspserver.code ~lang:"why3" (String.split_on_char '\n' tt) in
  Lspserver.hover ~range ~kind:`Markdown (title :: code @ infos)

let hover _channel ~uri (pos : Range.pos) =
  let _,src,rg,s = locate ~uri pos in
  match s with
  | Section _ -> raise Not_found
  | Clone(id,ids) ->
    let title = Format.asprintf "cloned %a" Id.pp_title id in
    mk_hover rg ~title ?code:(clone src ids) ()
  | Def id | Ref id ->
    let title = Format.asprintf "%a" Id.pp_title id in
    mk_hover rg ~title ?code:(code src id) ()

let () = Lspserver.on_hover hover

(* -------------------------------------------------------------------------- *)
(* ---  Code Lenses                                                       --- *)
(* -------------------------------------------------------------------------- *)

let pp_outdated fmt outdated =
  if outdated then Format.fprintf fmt " (outdated)"

let lenses _channel ~uri =
  match Lspserver.to_file ~uri with
  | None -> raise Not_found
  | Some filename ->
    let source = Hashtbl.find sources filename in
    let pool = ref [] in
    Rangemap.iter
      begin fun rg (s : Srcref.symbol) ->
        match forward source.updates (fst rg) with
        | None -> ()
        | Some pos ->
          match s with
          | Ref _ | Section _ -> ()
          | Clone(_,ids) ->
            let cs = List.filter_map (get_proof source) ids in
            if cs <> [] then
              let title =
                Format.asprintf "%a%a"
                  Crc.pp_hints cs pp_outdated source.src.outdated in
              let cmd = Lspserver.Cmd { title ; command = "" ; args = [] } in
              pool := Lspserver.resolved pos cmd :: !pool
          | Def id ->
            match get_proof source id with
            | None -> ()
            | Some crc ->
              let title = Format.asprintf "%a%a"
                  Crc.pp_hint crc pp_outdated source.src.outdated in
              let cmd = Lspserver.Cmd { title ; command = "" ; args = [] } in
              pool := Lspserver.resolved pos cmd :: !pool
      end source.refs ;
    !pool

let () = Lspserver.on_codelens lenses

(* -------------------------------------------------------------------------- *)
(* ---  Folding Ranges                                                    --- *)
(* -------------------------------------------------------------------------- *)

let folding _channel ~uri =
  match Lspserver.to_file ~uri with
  | None -> raise Not_found
  | Some filename ->
    let source = Hashtbl.find sources filename in
    let pool = ref [] in
    Rangemap.iter
      begin fun rg (s : Srcref.symbol) ->
        match s with
        | Ref _ | Def _ | Clone _ -> ()
        | Section _title ->
          match forward_range source.updates rg with
          | None -> ()
          | Some range ->
            pool := Lspserver.folding ~kind:"region" ~range () :: !pool
      end source.refs ;
    !pool

let () = Lspserver.on_folding folding

(* -------------------------------------------------------------------------- *)
(* ---  Document Symbols                                                  --- *)
(* -------------------------------------------------------------------------- *)

let symbols _channel ~uri =
  match Lspserver.to_file ~uri with
  | None -> raise Not_found
  | Some filename ->
    let source = Hashtbl.find sources filename in
    source.symbols

let () = Lspserver.on_document_symbol symbols

(* -------------------------------------------------------------------------- *)
(* ---  Document Preview                                                  --- *)
(* -------------------------------------------------------------------------- *)

let () = Lsp.register "why3find/openDocPreview"
    begin fun _channel data ->
      let uri = Json.jfield "textDocument" data |> Json.jstring in
      (* let pos = Json.jfield "position" data |> Lspserver.jposition in *)
      match Lspserver.to_file ~uri with
      | None -> failwith "No such document"
      | Some filename ->
        let source = Hashtbl.find sources filename in
        let filename = Printf.sprintf "%s/html/index.html" source.project.root in
        Json.string @@ Lspserver.to_uri ~filename
    end

(* -------------------------------------------------------------------------- *)
(* ---  Proof Watcher                                                     --- *)
(* -------------------------------------------------------------------------- *)

let watching = ref false

let () = Lspserver.on_open
    begin fun channel _doc ->
      if not !watching then
        begin
          watching := true ;
          ignore @@ Lspserver.watch channel ["**/.why3find/crc/*.crc"] ;
          ignore @@ Lspserver.watch channel ["**/why3find.proofs/*.json"] ;
        end
    end

let watched file =
  let dir = Filename.dirname file in
  let root =
    match Filename.basename dir with
    | "crc" -> Filename.dirname @@ Filename.dirname dir
    | "why3find.proofs" -> Filename.dirname dir
    | _ -> raise Not_found in
  let path = Filename.basename @@ Filename.chop_extension file in
  let lib = String.split_on_char '.' path in
  let src = List.fold_left Filename.concat root lib ^ ".mlw" in
  Hashtbl.find sources src

let () = Lspserver.on_file_event
    begin fun channel ~uri _evt ->
      match Lspserver.to_file ~uri with
      | None -> ()
      | Some file ->
        if Filename.check_suffix file ".json"
        || Filename.check_suffix file ".crc"
        then
          try
            let source = watched file in
            Docref.reload_proofs source.src ;
            Lspserver.refresh_codelens channel ;
          with _ -> ()
    end


(* -------------------------------------------------------------------------- *)
