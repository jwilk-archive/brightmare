type 'a t
val empty : 'a t
val put : 'a t -> string -> 'a -> 'a t
val multi_put : 'a t -> (string * 'a) list -> 'a t
val from_list : (string * 'a) list -> 'a t
val get : 'a t -> string -> 'a

(* vim: set tw=96 et ts=2 sw=2: *)
