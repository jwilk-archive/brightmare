type 'a t
val get : string -> 'a t -> 'a
val exists : string -> 'a t -> bool
val make : (string * 'a) list -> 'a t
val map : ('a -> 'b) -> 'a t -> 'b t
val join : 'a t list -> 'a t

(* vim: set tw=96 et ts=2 sw=2: *)
