module type AUTOMATON =
sig
  type t
  type s
  type command
  val default : t
  val pubstate : t -> s
  val execute : command -> t -> t
end

module type TOK_AUTOMATON =
sig
  include AUTOMATON with 
    type command = char and 
    type s = bool
end

module type T =
sig
  val make : string -> string list
end

module Make(Aut : TOK_AUTOMATON) : T

(* vim: set tw=96 et ts=2 sw=2: *)
