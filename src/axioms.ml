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

open Id
open Why3
module Sid = Ident.Sid
module Mid = Ident.Mid
module Hid = Ident.Hid

(* -------------------------------------------------------------------------- *)
(* --- Theory & Module Assumed Symbols                                    --- *)
(* -------------------------------------------------------------------------- *)

type parameter = {
  kind : Id.kind ;
  name : Ident.ident ;
  builtin : (Prover.prover * string) list ;
  extern : string option ;
}

let is_free_kind = function
  | KType | KLogic | KParam -> true
  | KUnsafe | KAxiom | KValue -> false

let is_unsafe_kind = function
  | KUnsafe -> true
  | KType | KLogic | KParam | KValue | KAxiom -> false

let is_free { kind } = is_free_kind kind
let is_unsafe { kind } = is_unsafe_kind kind
let is_external { builtin ; extern } = builtin <> [] || extern <> None

type signature = {
  locals : parameter Mid.t ;
  used_theories : Theory.theory list ;
  cloned_theories : Theory.theory list ;
}

type henv = {
  builtins : (Prover.prover * string) list Mid.t ;
  externals : string Mid.t ;
  signatures : signature Hid.t ;
}

(* -------------------------------------------------------------------------- *)
(* --- Builtin & Extracted Environments                                   --- *)
(* -------------------------------------------------------------------------- *)

let ocaml64 main =
  Filename.concat (Why3.Whyconf.datadir main) @@
  Filename.concat "extraction_drivers" @@
  "ocaml64.drv"

let pkg_drivers (pkg : Meta.pkg) =
  List.map (Filename.concat pkg.path) pkg.drivers

let add_builtins bmap p =
  Mid.merge
    (fun _ a b ->
       match a,b with
       | None, None -> None
       | Some _, None -> a
       | None, Some (m,_) -> Some [p,m]
       | Some xs, Some (m,_) -> Some ((p,m) :: xs)
    ) bmap @@ Driver.syntax_map p.Prover.driver

let init (project : Why3find.Project.t) =
  let provers = Project.select_provers project in
  let builtins = List.fold_left add_builtins Mid.empty provers in
  let drivers = List.concat_map pkg_drivers project.pkgs @ project.config.drivers in
  let main = Whyconf.get_main project.whyconf in
  let pdriver = Pdriver.load_driver main project.env (ocaml64 main) drivers in
  let externals = Mid.map fst pdriver.drv_syntax in
  { builtins ; externals ; signatures = Hid.create 0 }

(* -------------------------------------------------------------------------- *)
(* --- Elementary Operations                                              --- *)
(* -------------------------------------------------------------------------- *)

let empty = {
  locals = Mid.empty ;
  used_theories = [] ;
  cloned_theories = [] ;
}

let add henv hs name kind =
  let builtin = Mid.find_def [] name henv.builtins in
  let extern = Mid.find_opt name henv.externals in
  let prm = { name ; kind ; builtin ; extern } in
  { hs with locals = Mid.add name prm hs.locals }

let add_used hs (thy : Theory.theory) =
  { hs with used_theories = thy :: hs.used_theories }

let add_cloned hs (thy : Theory.theory) =
  { hs with cloned_theories = thy :: hs.cloned_theories }

(* -------------------------------------------------------------------------- *)
(* --- Theory Declarations                                                --- *)
(* -------------------------------------------------------------------------- *)

let nodef (td : _ Ty.type_def) = match td with
  | NoDef -> true
  | Alias _ | Range _ | Float _ -> false

let add_type henv hs (ty : Ty.tysymbol) =
  if nodef ty.ts_def then add henv hs ty.ts_name KType else hs

let add_decl henv (hs : signature) (d : Decl.decl) : signature =
  match d.d_node with
  | Dlogic _ | Dind _ | Ddata _ -> hs
  | Dtype ty -> add_type henv hs ty
  | Dparam ls -> add henv hs ls.ls_name KLogic
  | Dprop(Paxiom,pr,_) -> add henv hs pr.pr_name KAxiom
  | Dprop((Plemma|Pgoal),_,_) -> hs

let add_tdecl henv (hs : signature) (d : Theory.tdecl) : signature =
  match d.td_node with
  | Decl d -> add_decl henv hs d
  | Use thy -> add_used hs thy
  | Clone(thy,_) -> add_cloned hs thy
  | Meta _ -> hs

let theory_signature henv (thy : Theory.theory) =
  List.fold_left (add_tdecl henv) empty thy.th_decls

(* -------------------------------------------------------------------------- *)
(* --- Value Definitions                                                  --- *)
(* -------------------------------------------------------------------------- *)

let add_kind henv hs decl = function None -> hs | Some kd -> add henv hs decl kd
let add_def_expr henv hs decl e = add_kind henv hs decl @@ Id.kind_of_expr e
let add_def_cexp henv hs decl c = add_kind henv hs decl @@ Id.kind_of_cexp c

(* -------------------------------------------------------------------------- *)
(* --- Module Declarations                                                --- *)
(* -------------------------------------------------------------------------- *)

let add_mtype henv (hs : signature) (it : Pdecl.its_defn) : signature =
  if it.itd_fields = [] && it.itd_constructors = [] then
    let its = it.itd_its in
    if nodef its.its_def then add henv hs its.its_ts.ts_name KType else hs
  else hs

let add_rsymbol henv hs (rs : Expr.rsymbol) (ce : Expr.cexp) =
  if Id.lemma rs.rs_name then hs else add_def_cexp henv hs rs.rs_name ce

let add_psymbol henv hs (pv : Ity.pvsymbol) (expr : Expr.expr) =
  add_def_expr henv hs pv.pv_vs.vs_name expr

let add_rec_def henv hs (def : Expr.rec_defn) =
  add_def_cexp henv hs def.rec_sym.rs_name def.rec_fun

let add_pdecl henv (hs : signature) (d : Pdecl.pdecl) : signature =
  match d.pd_node with
  | PDexn _ -> hs
  | PDtype tys -> List.fold_left (add_mtype henv) hs tys
  | PDlet (LDsym(r,c)) -> add_rsymbol henv hs r c
  | PDlet (LDvar(v,e)) -> add_psymbol henv hs v e
  | PDlet (LDrec defs) -> List.fold_left (add_rec_def henv) hs defs
  | PDpure -> List.fold_left (add_decl henv) hs d.pd_pure

let rec add_munit henv (hs : signature) (m : Pmodule.mod_unit) : signature =
  match m with
  | Udecl pd -> add_pdecl henv hs pd
  | Uuse pm -> add_used hs pm.mod_theory
  | Uclone mi ->
    add_cloned hs mi.mi_mod.mod_theory
  | Uscope(_,ms) -> List.fold_left (add_munit henv) hs ms
  | Umeta _ -> hs

let module_signature henv (pm : Pmodule.pmodule) : signature =
  List.fold_left (add_munit henv) empty pm.mod_units

(* -------------------------------------------------------------------------- *)
(* --- Signature                                                          --- *)
(* -------------------------------------------------------------------------- *)

let signature henv (thy : Theory.theory) =
  let id = thy.th_name in
  try Hid.find henv.signatures id
  with Not_found ->
    let hs =
      try module_signature henv @@ Pmodule.restore_module thy
      with Not_found -> theory_signature henv thy
    in Hid.add henv.signatures id hs ; hs

let parameter s id = Mid.find_opt id s.locals
let parameters s = Mid.values s.locals

(* -------------------------------------------------------------------------- *)
(* --- Consolidated Hypotheses                                            --- *)
(* -------------------------------------------------------------------------- *)

let dependencies henv ?(self=false) theories =
  let deps = ref Mid.empty in
  let rec add (thy : Theory.theory) =
    let id = thy.th_name in
    if not @@ Mid.mem id !deps then
      begin
        deps := Mid.add id thy !deps ;
        add_derived thy
      end
  and add_derived thy =
    add_depends (signature henv thy)
  and add_depends s =
    List.iter add s.used_theories ;
    List.iter add_derived s.cloned_theories ;
  in
  let add_init = if self then add else add_derived in
  List.iter add_init theories ; Mid.values !deps

let iter henv ?(self=false) f theories =
  List.iter
    (fun thy ->
       let s = signature henv thy in
       Mid.iter (fun _ p -> f p) s.locals
    ) (dependencies henv ~self theories)

(* -------------------------------------------------------------------------- *)
