module type LEX_AUTOMATON = Signatures.LEX_AUTOMATON
module type T = Signatures.LEXSCAN

module Make(Aut : LEX_AUTOMATON) : T =
struct

  let ( ** ) = StrEx.( ** )
  
  let rec scan lastlex lexlist chars state =
    match chars with
      [] -> lastlex::lexlist |
      head::chars ->
        let state = Aut.execute head state in
        let head = 1 ** head in
          if Aut.pubstate state then
            scan head (lastlex::lexlist) chars state
          else
            scan (lastlex^head) lexlist chars state

  let make str = 
    let chars = (StrEx.as_list str) in
      ListEx.rev 
        ( ListEx.filter
            (fun s -> s <> "")
            (scan "" [] chars Aut.default)
        )
(* FIXME - does filtering is neccessary? *)

end

(* vim: set tw=96 et ts=2 sw=2: *)
