open Printf;;
open Tokenize;;
open Version;;

let rec aos2str aos =
  match aos with
    [] -> "" |
    head::tail -> "\x1B[1m" ^ head ^ "\x1B[0m." ^ (aos2str tail);;

print_string product_name;
print_newline;;

let argv = match Array.to_list Sys.argv with
  [] -> [] |
  _::tail -> tail;;

List.iter
  ( fun s -> 
    printf 
      "\x1B[12mZ\x1B[10m %s \n\x1B[12mSRR\x1B[10m> %s\n\n" 
      s 
      (aos2str (tokenize s)) 
  ) argv;;

(* vim: set tw=96 et ts=2 sw=2: *)
