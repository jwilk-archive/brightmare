(*
 * Copyright © 2006-2017 Jakub Wilk <jwilk@jwilk.net>
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

type action_t = Default | Help | Version

type options_t =
  { argv : string list;
    opt_uni : int;
    opt_debug : bool;
    opt_action : action_t;
  }

let (exename, rev_argv) =
  match Array.to_list Sys.argv with
  | [] -> "", []
  | exename::argv -> exename, (ListEx.rev argv)

let defaultoptions =
  { argv = [];
    opt_uni = 0;
    opt_debug = false;
    opt_action = Default;
  }

let options =
  ListEx.fold
    ( fun a s ->
      match s with
      | "--help" -> { a with opt_action = Help }
      | "--version" -> { a with opt_action = Version }
      | "--debug" -> { a with opt_debug = true }
      | "--ascii" -> { a with opt_uni = 0 }
      | "--html" -> { a with opt_uni = 1 }
      | "--utf8" -> { a with opt_uni = 2 }
      | _ -> { a with argv = s::a.argv }
    )
    defaultoptions
    rev_argv

let help_message =
"Usage: brightmare [--debug] [--html | --ascii | --utf8] EXPRESSION...

Options:
  --debug      turn on debug output
  --html       output HTML
  --ascii      force the US-ASCII encoding
  --utf8       force the UTF-8 encoding
  --help       show version information and exit
  --version    show this help message and exit
"

let () =
  match options.opt_action with
  | Help -> Printf.printf "%s" help_message
  | Version -> Printf.printf "%s\n" Version.product_name
  | Default ->
    match options.opt_uni with
    | 1 -> Brightmare_html.iterate options.opt_debug options.argv
    | 2 -> Brightmare_utf8.iterate options.opt_debug options.argv
    | _ -> Brightmare_plain.iterate options.opt_debug options.argv

(* vim: set tw=96 et ts=2 sts=2 sw=2: *)
