type t

val empty : t

val as_rmathbox : t -> Rmath.t
val tokens_to_rmathbox : string list -> Rmath.t

(* vim: set tw=96 et ts=2 sw=2: *)
