(*
 * Copyright © 2006-2013 Jakub Wilk <jwilk@jwilk.net>
 * SPDX-License-Identifier: MIT
 *)

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
val map2 : ('a -> 'b -> 'c) -> 'a list -> 'b list -> 'c list
val rev_map : ('a -> 'b) -> 'a list -> 'b list
val fold : ('a -> 'b -> 'a) -> 'a -> 'b list -> 'a
val fold2 : ('a -> 'b -> 'c -> 'a) -> 'a -> 'b list -> 'c list -> 'a
val rfold : ('a -> 'b -> 'b) -> 'a list -> 'b -> 'b
val exists : ('a -> bool) -> 'a list -> bool
val filter : ('a -> bool) -> 'a list -> 'a list
