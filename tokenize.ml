module type TOK_AUTOMATON = Zz_signatures.TOK_AUTOMATON
module type T = Zz_signatures.TOKENIZE

module Make(Aut : TOK_AUTOMATON) : T =
struct

  let ( ** ) = StrEx.( ** )
  
  let rec extokenize lasttok toklist chars state =
    match chars with
      [] -> lasttok::toklist |
      head::chars ->
        let state = Aut.execute head state in
        let head = 1 ** head in
          if Aut.pubstate state then
            extokenize head (lasttok::toklist) chars state
          else
            extokenize (lasttok^head) toklist chars state

  let make str = 
    let chars = (StrEx.as_list str) in
      ListEx.rev 
        ( ListEx.filter
            (fun s -> s <> "")
            (extokenize "" [] chars Aut.default)
        )
(* FIXME - does filtering is neccessary? *)

end

(* vim: set tw=96 et ts=2 sw=2: *)
