(*
print_string Version.product_name;
print_newline ();;
*)

let argv = match Array.to_list Sys.argv with
  [] -> [] |
  _::tail -> tail;;

Locale.initialize();;

module Unicode = Unicode_html
module Tokenize = Tokenize.Make(Automaton)
module Render = Render.Make(Unicode)(Decoration_html)
module Rmath = Rmath.Make(Unicode)(Render)
module Parse = Parse.Make(Unicode)(Rmath);;

ListEx.iter
  ( fun s ->
    let tokens = Tokenize.make s in
    let mathbx = Parse.tokens_to_rmathbox tokens in
    let render = Rmath.render_str mathbx in
      print_string render
  ) argv;;

(* vim: set tw=96 et ts=2 sw=2: *)
