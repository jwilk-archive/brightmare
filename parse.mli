type t

val empty : t

val from_string : string -> t
val as_rmathbox : t -> Rmath.t
val string_to_rmathbox : string -> Rmath.t

(* vim: set tw=96 et ts=2 sw=2: *)
