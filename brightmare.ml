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

module XUnicode = Unicode
module XTokenize = Tokenize.Make(Automaton2)
module XRender = Render.Make(XUnicode)
module XRmath = Rmath.Make(XUnicode)(XRender)
module XParse = Parse.Make(XUnicode)(XRmath);;

List2.iter
  ( fun s ->
    let tokens = XTokenize.make s in
    let mathbx = XParse.tokens_to_rmathbox tokens in
    let render = XRmath.render_str mathbx in
    let render = XUnicode.to_string render in
    let tokens = aos2str tokens in
      Printf.printf 
        "\x1B[12mZ\x1B[10m %s \n\x1B[12mSRR\x1B[10m> %s\n%s\n" 
        s tokens render
  ) argv;;

(* vim: set tw=96 et ts=2 sw=2: *)
