(* Program g³ówny *)

let () = Locale.initialize()

include Zz_signatures

module type BRIGHTMARE =
sig
  val iterate : bool -> string list -> unit
end

module Brightmare
  (Unicode : UNICODE)
  (Decoration : DECORATION)
  (Automaton : LEX_AUTOMATON) 
  (LatDict : LATDICT) :
  BRIGHTMARE =
struct
  module LexScan = Lexscan.Make(Automaton)
  module Render = Render.Make(Unicode)(Decoration)
  module Rmath = Rmath.Make(Unicode)(Render)
  module Parse = Parse.Make(LatDict)
  module Interpret = Interpret.Make(Unicode)(LatDict)(Rmath)
  module Interpret_dbg = Interpret_debug.Make(Interpret)
  let iterate debug =
    let as_rmathbox =
      if debug then 
        Interpret_dbg.make 
      else 
        Interpret.make
    in
      ListEx.iter
        ( fun s ->
          let lexems = LexScan.make s in
          let parsetree = Parse.from_lexems lexems in
          let rmbox = as_rmathbox parsetree in
          let render = Rmath.render_str rmbox in
            print_string render
        )
end

module Brightmare_html = 
  Brightmare(Unicode_html)(Decoration_html)(Automaton)(Latex_dictionary)
module Brightmare_plain =
  Brightmare(Unicode_konwert)(Decoration)(Automaton)(Latex_dictionary)

type options_t = 
  { argv : string list; 
    opt_html : bool; opt_debug : bool; opt_help : bool }

let (exename, rev_argv) = 
  match Array.to_list Sys.argv with
    [] -> "", [] |
    exename::argv -> exename, (ListEx.rev argv)

let ifhtml =
  try
    (fun _ -> true)
      (StrEx.search_forward (StrEx.regexp "html") exename 0)
  with
    Not_found -> false

let defaultoptions = 
  { argv = []; 
    opt_html = ifhtml; opt_debug = false; opt_help = false }
 
let options =
  ListEx.fold
    ( fun a s ->
      match s with
      "--help" | "--version" -> 
        { argv = a.argv; 
          opt_html = a.opt_html; opt_debug = a.opt_debug; opt_help = true } |
      "--debug" ->
        { argv = a.argv; 
          opt_html = a.opt_html; opt_debug = true; opt_help = a.opt_help } |
      "--html" ->
        { argv = a.argv; 
          opt_html = true; opt_debug = a.opt_debug; opt_help = a.opt_help } |
      "--nohtml" ->
        { argv = a.argv; 
          opt_html = false; opt_debug = a.opt_debug; opt_help = a.opt_help } |
      _ ->
        { argv = s::a.argv; 
          opt_html = a.opt_html; opt_debug = a.opt_debug; opt_help = a.opt_help}
    )
    defaultoptions
    rev_argv

let () =
  if options.opt_help then
    Printf.printf "%s\n\n" Version.product_name
  else if options.opt_html then
    Brightmare_html.iterate options.opt_debug options.argv
  else
    Brightmare_plain.iterate options.opt_debug options.argv

(* vim: set tw=96 et ts=2 sw=2: *)
