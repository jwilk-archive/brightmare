let rec aos2str aos =
  match aos with
    [] -> "" |
    head::tail -> "\x1B[1m" ^ head ^ "\x1B[0m." ^ (aos2str tail);;

print_string Version.product_name;
print_newline;;

let argv = match Array.to_list Sys.argv with
  [] -> [] |
  _::tail -> tail;;

Locale.initialize();;

Printf.printf "Locale charmap = %s\n\n" (Locale.charmap ());;

let module Tokenize = Tokenize.Make(Automaton2) in
  List2.iter
    ( fun s ->
      let tokens = Tokenize.make s in
      let mathbx = Parse.tokens_to_rmathbox tokens in
      let render = Rmath.render_str mathbx in
      let render = Unicode.to_string render in
      let tokens = aos2str tokens in
        Printf.printf 
          "\x1B[12mZ\x1B[10m %s \n\x1B[12mSRR\x1B[10m> %s\n%s\n" 
          s tokens render
    ) argv;;


(* vim: set tw=96 et ts=2 sw=2: *)
