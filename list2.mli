val min_map : ('a -> 'b) -> 'a list -> 'b
val max_map : ('a -> 'b) -> 'a list -> 'b
val min : 'a list -> 'a
val max : 'a list -> 'a
val make : int -> 'a -> 'a list

val length : 'a list -> int
val rev : 'a list -> 'a list
val flatten : 'a list list -> 'a list

val iter : ('a -> unit) -> 'a list -> unit
val map : ('a -> 'b) -> 'a list -> 'b list
val rev_map : ('a -> 'b) -> 'a list -> 'b list
val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b list -> 'a
val fold_right : ('a -> 'b -> 'b) -> 'a list -> 'b -> 'b

val iter2 : ('a -> 'b -> unit) -> 'a list -> 'b list -> unit
val map2 : ('a -> 'b -> 'c) -> 'a list -> 'b list -> 'c list
val rev_map2 : ('a -> 'b -> 'c) -> 'a list -> 'b list -> 'c list
val fold_left2 : ('a -> 'b -> 'c -> 'a) -> 'a -> 'b list -> 'c list -> 'a
val fold_right2 : ('a -> 'b -> 'c -> 'c) -> 'a list -> 'b list -> 'c -> 'c

val for_all : ('a -> bool) -> 'a list -> bool
val exists : ('a -> bool) -> 'a list -> bool
val mem : 'a -> 'a list -> bool
val memq : 'a -> 'a list -> bool

val find : ('a -> bool) -> 'a list -> 'a
val seek : ('a -> 'b) -> 'a list -> 'b

val filter : ('a -> bool) -> 'a list -> 'a list
val partition : ('a -> bool) -> 'a list -> 'a list * 'a list

val split : ('a * 'b) list -> 'a list * 'b list
val combine : 'a list -> 'b list -> ('a * 'b) list

(* vim: set tw=96 et ts=2 sw=2: *)
