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

List2.iter
  ( fun s ->
    let
      tokens = aos2str (Tokenize.make s) and
      render = Rmath.render_str (Parse.string_to_rmathbox s)
    in
      Printf.printf 
        "\x1B[12mZ\x1B[10m %s \n\x1B[12mSRR\x1B[10m> %s\n%s\n" 
        s tokens (Unicode.to_string render)
  ) argv;;


(* vim: set tw=96 et ts=2 sw=2: *)
