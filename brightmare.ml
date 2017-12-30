(*
 * Copyright © 2006-2013 Jakub Wilk <jwilk@jwilk.net>
 * SPDX-License-Identifier: MIT
 *)

include Signatures

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
          let render = Rmath.render rmbox in
            print_string render
        )
end

module Brightmare_html =
  Brightmare(Unicode_html)(Decoration_html)(Automaton)(Latex_dictionary)
module Brightmare_plain =
  Brightmare(Unicode_ascii)(Decoration)(Automaton)(Latex_dictionary)
module Brightmare_utf8 =
  Brightmare(Unicode)(Decoration)(Automaton)(Latex_dictionary)

type options_t =
  { argv : string list;
    opt_uni : int; opt_debug : bool; opt_help : bool }

let (exename, rev_argv) =
  match Array.to_list Sys.argv with
  | [] -> "", []
  | exename::argv -> exename, (ListEx.rev argv)

let defaultoptions =
  { argv = [];
    opt_uni = 0; opt_debug = false; opt_help = false }

let options =
  ListEx.fold
    ( fun a s ->
      match s with
      | "--help" | "--version" ->
        { argv = a.argv;
          opt_uni = a.opt_uni; opt_debug = a.opt_debug; opt_help = true }
      | "--debug" ->
        { argv = a.argv;
          opt_uni = a.opt_uni; opt_debug = true; opt_help = a.opt_help }
      | "--html" ->
        { argv = a.argv;
          opt_uni = 1; opt_debug = a.opt_debug; opt_help = a.opt_help }
      | "--ascii" ->
        { argv = a.argv;
          opt_uni = 0; opt_debug = a.opt_debug; opt_help = a.opt_help }
      | "--utf8" ->
        { argv = a.argv;
          opt_uni = 2; opt_debug = a.opt_debug; opt_help = a.opt_help }
       | _ ->
        { argv = s::a.argv;
          opt_uni = a.opt_uni; opt_debug = a.opt_debug; opt_help = a.opt_help}
    )
    defaultoptions
    rev_argv

let () =
  if options.opt_help then
    Printf.printf "%s\n\n" Version.product_name
  else
  match options.opt_uni with
  | 1 -> Brightmare_html.iterate options.opt_debug options.argv
  | 2 -> Brightmare_utf8.iterate options.opt_debug options.argv
  | _ -> Brightmare_plain.iterate options.opt_debug options.argv

(* vim: set tw=96 et ts=2 sts=2 sw=2: *)
