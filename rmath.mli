type t

val width : t -> int
val height : t -> int

val hline : int -> t
val vline : int -> t

val frac : t -> t -> t
val empty : int -> int -> t
val si : Unicode.wstring -> t
val join_h : t list -> t

val crossjoin_NE : t -> t -> t
val crossjoin_SE : t -> t -> t
val crossjoin_SW : t -> t -> t
val crossjoin_NW : t -> t -> t

val render_str : t -> Unicode.wstring

(* vim: set tw=96 et ts=2 sw=2: *)
