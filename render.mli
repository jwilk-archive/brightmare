type t

val si : Unicode.wstring -> t
val make : int -> int -> Unicode.wchar -> t
val empty : int -> int -> t

val width : t -> int
val height : t -> int

val grow_custom : char -> t -> int -> int -> t

val join_v : char -> t list -> t
val join_h : char -> t list -> t

val join4 : t -> t -> t -> t -> t
val crossjoin_tr : t -> t -> t
val crossjoin_br : t -> t -> t

val render_str : t -> Unicode.wstring

(* vim: set tw=96 et ts=2 sw=2: *)
