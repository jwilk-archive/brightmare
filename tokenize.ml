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

module Make(Aut : TOK_AUTOMATON) =
struct
  let rec extokenize lasttok toklist chars state =
    match chars with
      [] -> lasttok::toklist |
      head::chars ->
        let state = Aut.execute head state in
        let head = String.make 1 head in
          if Aut.pubstate state then
            extokenize head (lasttok::toklist) chars state
          else
            extokenize (lasttok^head) toklist chars state

  let make str =
    let chars = (String2.as_list str) in
      List2.rev 
        ( List2.filter
            (fun s -> s <> "")
            (extokenize "" [] chars Aut.default)
        )
  end

(* vim: set tw=96 et ts=2 sw=2: *)
