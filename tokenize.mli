module type TOK_AUTOMATON = Zz_signatures.TOK_AUTOMATON
module type T = Zz_signatures.TOKENIZE

module Make(Aut : TOK_AUTOMATON) : T

(* vim: set tw=96 et ts=2 sw=2: *)
