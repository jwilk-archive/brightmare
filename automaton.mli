type command = char
type s = bool
type t

val default : t
val pubstate : t -> s
val execute : command -> t -> t

(* vim: set tw=96 et ts=2 sw=2: *)
