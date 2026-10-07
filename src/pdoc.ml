(**************************************************************************)
(*                                                                        *)
(*  SPDX-License-Identifier LGPL-2.1                                      *)
(*  Copyright (C)                                                         *)
(*  CEA (Commissariat à l'énergie atomique et aux énergies alternatives)  *)
(*                                                                        *)
(**************************************************************************)

(* -------------------------------------------------------------------------- *)
(* --- HTML Doc Printer                                                   --- *)
(* -------------------------------------------------------------------------- *)

type 'a fmt = Format.formatter -> 'a -> unit
type 'a printf =  ('a, Format.formatter, unit) format -> 'a

let pp_span ?className pp fmt v =
  match className with
  | None -> pp fmt v
  | Some cla -> Format.fprintf fmt "<span class=\"%s\">%a</span>" cla pp v

let urichars = function
  | 'A'..'Z'
  | 'a'..'z'
  | '0'..'9'
  | '-' | '.' | '_' | '~' | '!' | '$'
  | '\'' | '(' | ')' | '*' | '+'
  | ',' | ';' | '=' | ':' | '@' | '/' | '?'
    -> true
  | _ -> false

let pp_name fmt a =
  String.iter
    begin fun c ->
      if urichars c then
        Format.pp_print_char fmt c
      else
        Format.fprintf fmt "%%%02X" (Char.code c)
    end a

let pp_html = Why3.Pp.html_string
let to_html = Format.asprintf "%a" pp_html

let pp_scope fmt s =
  Format.fprintf fmt "<span class=scope>%s</span>" s

let pp_keyword fmt s =
  Format.fprintf fmt "<span class=keyword>%s</span>" s

let pp_admitted fmt s =
  Format.fprintf fmt "<span class=admitted>%s</span>" s

let pp_attribute fmt s =
  Format.fprintf fmt "<span class=attribute>%s</span>" s

let pp_spaces fmt n =
  for _ = 1 to n do
    Format.pp_print_char fmt ' '
  done

(* -------------------------------------------------------------------------- *)
(* --- Html Buffers                                                       --- *)
(* -------------------------------------------------------------------------- *)

type buffer = {
  buffer : Buffer.t ;
  fmt : Format.formatter ;
}

let buffer () =
  let buffer = Buffer.create 80 in
  let fmt = Format.formatter_of_buffer buffer in
  { buffer ; fmt }

let bprintf (b : buffer) msg = Format.fprintf b.fmt msg

let contents (b : buffer) =
  Format.pp_print_flush b.fmt () ;
  let s = Buffer.contents b.buffer in
  Buffer.clear b.buffer ; s

let pp_buffer fmt b =
  Format.pp_print_string fmt (contents b)

(* -------------------------------------------------------------------------- *)
(* --- Html Output                                                        --- *)
(* -------------------------------------------------------------------------- *)

type header = {
  level: int;
  name: string;
  title: string;
}

type target = {
  file: string;
  htitle: string;
  mutable headers: header list; (* in reverse order *)
  mutable matheq: int ;
  mutable treemap: int ;
  contents: Buffer.t;
  forked: target option;
}

type output = {
  mutable target: target;
  mutable current: buffer;
}

let output ~file ~title =
  {
    target = {
      file ; htitle = title ; headers = [] ;
      contents = Buffer.create 80 ;
      forked = None ; matheq = 0 ; treemap = 0 ;
    } ;
    current = buffer () ;
  }

let null () = output ~file:"" ~title:""

let buffered output = contents output.current

let push output =
  let stacked = output.current in
  output.current <- buffer () ;
  stacked

let pop output stack =
  let contents = contents output.current in
  output.current <- stack ;
  Buffer.add_string stack.buffer contents

let spaceonly s =
  try
    for i = 0 to String.length s - 1 do
      match s.[i] with ' ' | '\t' | '\n' -> () | _ -> raise Exit
    done ; true
  with Exit -> false

let flush ?(onlyspace=true) output =
  let trailing = buffered output in
  if onlyspace || not (spaceonly trailing) then
    Buffer.add_string output.target.contents trailing

let fork out ~file ~title =
  flush out ;
  out.target <- {
    file ; htitle = title ; headers = [] ;
    contents = Buffer.create 80 ;
    forked = Some out.target ;
    treemap = 0 ;
    matheq = out.target.matheq ;
  }

let matheq out =
  let k = succ out.target.matheq in
  out.target.matheq <- k ; k

let treemap out =
  let k = succ out.target.treemap in
  out.target.treemap <- k ; k

let printf out msg = Format.fprintf out.current.fmt msg
let pp out p v = p out.current.fmt v
let ppt out k = k out.current.fmt

let pp_print_char out c = pp out Format.pp_print_char c
let pp_print_string out s = pp out Format.pp_print_string s

let pp_html_c out c = Why3.Pp.html_char out.current.fmt c
let pp_html_s out ?className s =
  pp_span ?className Why3.Pp.html_string out.current.fmt s

let header out ~level ~title ?(toc=title) () =
  let target = out.target in
  let name = Printf.sprintf "_%d" (succ @@ List.length target.headers) in
  target.headers <- { level ; name ; title = toc } :: target.headers ;
  Format.fprintf out.current.fmt
    "<h%d><a><div class=anchor id=\"%s\"></div>%s</a></h%d>@\n"
    level name title level

let head = {html|
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
<link rel="stylesheet" type="text/css" href="style.css">
<link rel="stylesheet" type="text/css" href="icofont.min.css">
|html}

let katex = {html|
<link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.18.5/katex.min.css"
    integrity="sha512-eLvr2vghJzBvLDxpgIyx3qrDj1chzZfD4SPOE4otnJPa6GsyJ/lBDGFhZO8OsmyYNnqqjqXOSjHAV1cBax33oA=="
    crossorigin="anonymous" referrerpolicy="no-referrer">
<script
    src="https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.18.5/katex.min.js"
    integrity="sha512-yRrA0fXbfdjHDJXBxj4ABSlaLGZk5HOm5qpvXx6GEjR1t5yCLdenOvN9hzHZhrznHyHVKuIK+QltSR4gc//lQA=="
    crossorigin="anonymous" referrerpolicy="no-referrer"></script>
|html}

let d3treemap = {html|
<script
    src="https://cdnjs.cloudflare.com/ajax/libs/d3/7.9.0/d3.min.js"
    integrity="sha512-vc58qvvBdrDR4etbxMdlTt4GBQk1qjvyORR2nrsPsFPyrs+/u5c3+1Ct6upOgdZoIl7eq6k3a1UPDSNAQi/32A=="
    crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/d3-graphviz/5.6.0/d3-graphviz.min.js"
    integrity="sha512-Le8HpIpS2Tc7SDHLM6AOgAKq6ZR4uDwLhjPSR20DtXE5dFb9xECHRwgpc1nxxnU0Dv+j6FNMoSddky5gyvI3lQ=="
    crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script type="text/javascript" src="treemap.js"></script>
|html}


let foot = {html|<script type="text/javascript" src="script.js"></script>
</body>
</html>
|html}

let table_of_contents cout heads =
  if heads <> [] then
    begin
      output_string cout "<nav>\n" ;
      let fmt = Format.formatter_of_out_channel cout in
      List.iter
        (fun { level ; name ; title } ->
           Format.fprintf fmt "<a class=\"toc%d\" href=\"#%s\">%s</a>@\n"
             level name title
        ) heads ;
      Format.pp_print_flush fmt () ;
      output_string cout "</nav>\n" ;
    end

let close output =
  flush output ;
  let target = output.target in
  Utils.outputfile ~file:target.file begin fun cout ->
    output_string cout "<!DOCTYPE html>" ;
    output_string cout head ;
    if target.matheq > 0 then output_string cout katex ;
    if target.treemap > 0 then output_string cout d3treemap ;
    output_string cout "<title>" ;
    output_string cout target.htitle ;
    output_string cout "</title>\n</head>\n<body>\n" ;
    table_of_contents cout (List.rev target.headers) ;
    Buffer.output_buffer cout target.contents;
    output_string cout foot
  end ;
  Option.iter
    (fun tgt -> output.target <- tgt)
    output.target.forked

let close_all output =
  close output ;
  while output.target.forked <> None do
    close output ;
  done

(* -------------------------------------------------------------------------- *)
