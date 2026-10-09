(**************************************************************************)
(*                                                                        *)
(*  SPDX-License-Identifier LGPL-2.1                                      *)
(*  Copyright (C)                                                         *)
(*  CEA (Commissariat à l'énergie atomique et aux énergies alternatives)  *)
(*                                                                        *)
(**************************************************************************)

(* -------------------------------------------------------------------------- *)
(* --- Why3 Identifiers                                                   --- *)
(* -------------------------------------------------------------------------- *)

module I = Why3.Ident
module Mstr = Why3.Wstdlib.Mstr

type t = I.ident
let hash = I.id_hash
let equal = I.id_equal
let compare = I.id_compare
let pp fmt (id : t) =
  Format.fprintf fmt "%s<%d>" id.id_string (Why3.Weakhtbl.tag_hash id.id_tag)

(* Location *)

let loc (id : t) =
  match id.id_loc with
  | None -> raise Not_found
  | Some loc -> loc

let line id =
  let _,line,_,_,_ = Why3.Loc.get (loc id) in line

let file id =
  let file,_,_,_,_ = Why3.Loc.get (loc id) in file

let path ?lib id =
  let path =
    try Why3.Pmodule.restore_path id
    with Not_found ->
      try Why3.Theory.restore_path id
      with Not_found -> ["unknown"],"Unknown",["unknown"]
  in match lib with
  | None -> path
  | Some lib ->
    let lp,md,qid = path in
    if lp = [] then lib,md,qid else path

let cat = String.concat "."

(* Ident Absolute Name *)

type package = [ `Local | `Stdlib | `Package of Meta.pkg ]

type id = {
  self : t ;
  id_pkg : package ;
  id_lib : string list ;
  id_mod : string ;
  id_qid : string list ;
}

let lemma id = String.ends_with ~suffix:"'lemma" id.I.id_string

let is_relative ?root f =
  Filename.is_relative f ||
  match root with
  | None -> false
  | Some prefix -> String.starts_with ~prefix f

let resolve ~lib ?root id =
  let lp,id_mod,id_qid = path id in
  if lp = [] then
    { self = id ; id_pkg = `Local ; id_lib = lib ; id_mod ; id_qid }
  else
    let id_pkg =
      if is_relative ?root (file id) then `Local else
        try `Package (Meta.find (List.hd lp))
        with _ -> `Stdlib
    in { self = id ; id_pkg ; id_lib = lp ; id_mod ; id_qid }

let fullname ?lib id =
  let lp,id_mod,id_qid = path ?lib id in
  String.concat "." @@ lp @ id_mod :: id_qid

let ppr fmt id =
  Format.pp_print_string fmt @@ fullname id

let standard id =
  let lp,_,_ = path id in
  lp <> [] &&
  not @@ Filename.is_relative (file id) &&
  try let _ = Meta.find (List.hd lp) in false with _ -> true

(* List Printing *)

let pp_prefix fmt q =
  Format.pp_print_string fmt q ; Format.pp_print_char fmt '.'

let rec pp_last fmt pp = function
  | [] -> ()
  | [a] -> pp fmt a
  | q::qid -> pp_prefix fmt q ; pp_last fmt pp qid

(* Title Resolution *)

let to_infix s =
  let n = String.length s in
  if n > 2 && s.[0] = '(' && s.[n-1] = ')' then
    if String.index_opt s '[' <> None
    then "mixfix " ^ String.sub s 1 (n-2) else
    if n > 3 && s.[n-2] = '_'
    then "prefix " ^ String.sub s 1 (n-3)
    else "infix " ^ String.sub s 1 (n-2)
  else s

let rec unwrap_any s = function
  | [] -> s
  | prefix::others ->
    if String.starts_with ~prefix s then
      let n = String.length s in
      let p = String.length prefix in
      Printf.sprintf "(%s)" @@ String.sub s p (n-p)
    else unwrap_any s others

let prefixes = ["prefix ";"infix ";"mixfix "]
let of_infix s = unwrap_any s prefixes
let is_infix s =
  List.exists (fun prefix -> String.starts_with ~prefix s) prefixes

let pp_infix fmt a = Format.pp_print_string fmt (of_infix a)

let pp_qpath ~local fmt r =
  let rec pp fmt = function
    | [] | [_] -> ()
    | a::w -> pp_prefix fmt a ; pp fmt w
  in
  let rec pp2 fmt s r =
    match s,r with
    | x::s , y::r when x = y -> pp2 fmt s r
    | _ -> pp fmt r
  in pp2 fmt local r.id_qid

let pp_qname fmt r =
  let rec pp fmt = function
    | [] -> ()
    | [a] -> pp_infix fmt a
    | _::w -> pp fmt w
  in pp fmt r.id_qid

let pp_local fmt r =
  pp_last fmt pp_infix r.id_qid

let pp_qid fmt qid = pp_last fmt pp_infix qid

let pp_path fmt (lib,m,qid) =
  List.iter (pp_prefix fmt) lib ;
  if qid = [] then
    Format.pp_print_string fmt m
  else
    begin
      pp_prefix fmt m ;
      pp_qid fmt qid ;
    end

let pp_title fmt r = pp_path fmt (r.id_lib,r.id_mod,r.id_qid)

let name id =
  let rec last = function
    | [] -> ""
    | [a] -> of_infix a
    | _::qid -> last qid
  in last id.id_qid

(* URI Encoding *)

let charset_uri =
  let m = Array.make 256 true in
  let r = " !#$%&'()*+,/:;=?@[]<>" in
  String.iter (fun c -> m.(Char.code c) <- false) r ; m

let charset_why3 =
  let m = Array.make 256 false in
  let s = "-._~!$'()*+,;=:@/?" in (* authorised *)
  String.iter (fun c -> m.(Char.code c) <- true) s;
  let span m a b = for i = Char.code a to Char.code b do m.(i) <- true done in
  span m 'A' 'Z'; span m 'a' 'z'; span m '0' '9'; m

let encode_char m fmt c =
  let k = int_of_char c in
  if m.(k) then
    Format.pp_print_char fmt c
  else
    Format.fprintf fmt "%%%2X" k

let encode fmt a =
  String.iter (encode_char charset_uri fmt) a

let encode_why3 fmt a =
  String.iter (encode_char charset_why3 fmt) a

(* URL Resolution *)

let pp_anchor fmt qid = pp_last fmt encode qid

let pp_selector fmt qid =
  Format.pp_print_char fmt '#' ;
  pp_anchor fmt qid

let pp_htmlfile fmt r =
  List.iter (pp_prefix fmt) r.id_lib ;
  Format.pp_print_string fmt r.id_mod ;
  Format.pp_print_string fmt ".html"

let pp_aname fmt r = pp_anchor fmt r.id_qid

let pp_ahref ~current ~package_url fmt r =
  match r.id_pkg with
  | `Local ->
    let is_decl = r.id_qid <> [] in
    let is_extern = not (is_decl && current = Some r.id_mod) in
    begin
      if is_extern then pp_htmlfile fmt r ;
      if is_decl then pp_selector fmt r.id_qid ;
    end
  | `Package m ->
    begin
      match package_url with
      | None -> Format.fprintf fmt "file://%s/html/" m.path
      | Some prefix -> Format.fprintf fmt "%s/%s/" prefix m.name
    end ;
    pp_htmlfile fmt r ;
    pp_selector fmt r.id_qid
  | `Stdlib ->
    Format.pp_print_string fmt "https://www.why3.org/stdlib/" ;
    let id = r.self in
    let name = id.id_string in
    List.iter (pp_prefix fmt) r.id_lib ;
    if r.id_qid = [] then
      Format.fprintf fmt "html#%a_" encode_why3 name
    else
      Format.fprintf fmt "html#%a_%d" encode_why3 name (line id)

let pp_proof_aname fmt r =
  pp_anchor fmt (r.id_mod :: r.id_qid)

let pp_proof_ahref fmt r =
  List.iter (pp_prefix fmt) r.id_lib ;
  Format.pp_print_string fmt "proof.html#" ;
  pp_proof_aname fmt r

(* -------------------------------------------------------------------------- *)
(* --- Declaration Kind                                                   --- *)
(* -------------------------------------------------------------------------- *)

type kind =
  | KType (* abstract type *)
  | KLogic (* constant, function of predicate *)
  | KAxiom (* hypothesis *)
  | KParam (* non-constrained val *)
  | KValue (* constrained val *)
  | KUnsafe


(* -------------------------------------------------------------------------- *)
(* --- Definition Kind                                                    --- *)
(* -------------------------------------------------------------------------- *)

type cany =
  | Free (* no post *)
  | Verified (* post with witness of existence *)
  | Unverified (* post without witness of existence *)

(* Checks that contract of Cany is provable, ie. its pre-condition contains a
   proof witnessing the existence of a result value that satisfy all
   post-conditions. This is the only way to distinguish "val" from "let"
   definitions. *)

let verified ~pre ~post =
  let module Term = Why3.Term in
  begin
    (* compare pre and post *)
    let instance vr (q : Term.term) p =
      let q = (* return variable alpha-conversion *)
        match q.t_node with
        | Tlet( { t_node = Tvar r },q) when Term.vs_equal r vr -> Term.t_eps q
        | _ -> Term.t_eps_close vr q
      in Term.t_equal p q in
    (* compare pre-condition conjunctions wrt list of post-conditions *)
    let rec postcond vr (q : Term.term) (ps : Term.term list) =
      match q.t_node, ps with
      | _ , [p] -> instance vr q p
      | Tbinop(Tand,q,qs) , p::ps -> instance vr q p && postcond vr qs ps
      | _ , _::_ -> false
      | _ , [] -> true in
    (* witness proof is the last pre-condition *)
    let rec witness = function
      | [] -> Term.t_true
      | [pre] -> pre
      | _::ps -> witness ps in
    let w = witness pre in
    (* unfold the witness existential *)
    match w.t_node with
    | Tquant(Texists,tq) ->
      let vs,_trigger,pre = Term.t_open_quant tq in
      begin
        match vs with
        | [vret] -> postcond vret pre post
        | _ -> false
      end
    | _ -> false
  end

let cany (cty: Why3.Ity.cty) : cany =
  if cty.cty_post = [] && Why3.Ity.Mxs.is_empty cty.cty_xpost
  then Free else
  if verified ~pre:cty.cty_pre ~post:cty.cty_post
  then Verified else Unverified

(* -------------------------------------------------------------------------- *)
(* --- Sound Expression Check                                             --- *)
(* -------------------------------------------------------------------------- *)

let rec safe_let_defn (def : Why3.Expr.let_defn) =
  match def with
  | LDvar(_,e) -> safe_expr e
  | LDsym(_,ce) -> safe_cexpr ce
  | LDrec lts -> List.for_all safe_rec_defn lts

and safe_rec_defn (d : Why3.Expr.rec_defn) = safe_cexpr d.rec_fun

and safe_expr (e : Why3.Expr.expr) =
  match e.e_node with
  | Evar _ | Econst _ | Eassign _  | Epure _ | Eabsurd -> true
  | Eexec (ce, _) -> safe_cexpr ce
  | Elet(def,e) -> safe_let_defn def && safe_expr e
  | Eif (a, b, c) -> safe_expr a && safe_expr b && safe_expr c
  | Ewhile(a,_,_,b) -> safe_expr a && safe_expr b
  | Efor (_, _, _, _, b) -> safe_expr b
  | Eraise (_, e) | Eexn (_, e) | Eghost e -> safe_expr e
  | Eassert ((Assert | Check), _) -> true
  | Eassert (Assume,_) -> false
  | Ematch (a, ps, xs) ->
    safe_expr a &&
    List.for_all safe_branch ps &&
    Why3.Ity.Mxs.for_all safe_handler xs

and safe_branch (_,e) = safe_expr e
and safe_handler _ (_,e) = safe_expr e

and safe_cexpr (ce : Why3.Expr.cexp) =
  match ce.c_node with
  | Cfun e -> safe_expr e
  | Capp _ | Cpur _ -> true
  | Cany ->
    match cany ce.c_cty with
    | Free | Verified -> true | Unverified -> false

let rec kind_of_expr (e : Why3.Expr.expr) =
  (* looking for top-level Cany definition *)
  match e.e_node with
  | Eexec(ce,_) -> kind_of_cexp ce
  | _ -> if safe_expr e then None else Some KUnsafe

and kind_of_cexp (ce : Why3.Expr.cexp) =
  match ce.c_node with
  | Cpur _ | Capp _ -> None
  | Cfun e -> kind_of_expr e
  | Cany ->
    match cany ce.c_cty with
    | Free -> Some KParam
    | Unverified -> Some KValue
    | Verified -> None

(* -------------------------------------------------------------------------- *)
(* --- Declaration Resolution                                             --- *)
(* -------------------------------------------------------------------------- *)

type decl =
  | Type of Why3.Ty.tysymbol * Why3.Decl.constructor list
  | Logic of Why3.Term.lsymbol * bool
  | Inductive of Why3.Decl.ind_sign * Why3.Term.lsymbol
  | Letv of Why3.Ity.pvsymbol * Why3.Expr.expr
  | Letr of Why3.Expr.rsymbol * Why3.Expr.cexp
  | Exn of Why3.Ity.xsymbol
  | Axiom of Why3.Decl.prsymbol
  | Lemma of Why3.Decl.prsymbol
  | Goal of Why3.Decl.prsymbol

let is_parameter = function
  | Type({ ts_def = NoDef },[]) -> true | Type _ -> false
  | Logic(_,def) -> not def
  | Inductive _ -> false
  | Letv(_,e) -> kind_of_expr e <> None
  | Letr(_,c) -> kind_of_cexp c <> None
  | Exn _ | Axiom _ | Lemma _ | Goal _ -> false

let eq = Why3.Ident.id_equal

let find_logic id ds =
  fst @@ List.find (fun (ls,_) -> eq id @@ ls.Why3.Term.ls_name) ds

let rec find_data id (ds : Why3.Decl.data_decl list) =
  match ds with
  | [] -> raise Not_found
  | (ts,cs) :: ds ->
    if eq id ts.ts_name then Type(ts,cs) else
      try Logic (find_logic id cs,true)
      with Not_found -> find_data id ds

let find_decl id (d: Why3.Decl.decl) =
  match d.d_node with
  | Dtype ts when eq id ts.ts_name -> Type(ts,[])
  | Dparam ls when eq id ls.ls_name -> Logic(ls,false)
  | Ddata ds -> find_data id ds
  | Dlogic ds -> Logic (find_logic id ds,true)
  | Dind(s,ds) -> Inductive (s,find_logic id ds)
  | Dprop(Paxiom,p,_) -> Axiom p
  | Dprop(Plemma,p,_) -> Lemma p
  | Dprop(Pgoal,_,_) | Dtype _ | Dparam _ -> raise Not_found

let rec find_letdefs id = function
  | [] -> raise Not_found
  | (d : Why3.Expr.rec_defn) :: ds ->
    let rs = d.rec_sym in
    let rd = d.rec_fun in
    if Why3.Ident.id_equal id rs.rs_name
    then Letr(rs,rd)
    else find_letdefs id ds

let find_pdecl id (pd : Why3.Pdecl.pdecl) =
  match pd.pd_node with
  | PDtype _ | PDpure ->
    begin
      match
        List.find_map
          (fun d -> try Some (find_decl id d) with Not_found -> None)
          pd.pd_pure
      with None -> raise Not_found | Some d -> d
    end
  | PDlet (LDvar(x,def)) -> Letv(x,def)
  | PDlet (LDsym (s,def)) -> Letr(s,def)
  | PDlet (LDrec ds) -> find_letdefs id ds
  | PDexn x -> Exn x

let find thy id : decl =
  match Why3.Pmodule.restore_module thy with
  | m ->
    find_pdecl id (Why3.Ident.Mid.find id m.mod_known)
  | exception Not_found ->
    find_decl id (Why3.Ident.Mid.find id thy.th_known)

(* -------------------------------------------------------------------------- *)
