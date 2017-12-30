(*
 * Copyright © 2006-2013 Jakub Wilk <jwilk@jwilk.net>
 * SPDX-License-Identifier: MIT
 *)

type 'a t

val make : 'a -> 'a t

val width : 'a t -> int
val height : 'a t -> int

val append_row : 'a t -> 'a t
val append : 'a t -> 'a -> 'a t

val grow : 'a t -> int -> int -> 'a t

val fillup : 'a t -> 'a t

val eachrow_fold : ('a -> 'b -> 'a) -> 'a -> 'b t -> 'a list
val eachrow_rfold : ('a -> 'b -> 'b) -> 'a t -> 'b -> 'b list
val eachcol_fold : ('a -> 'b -> 'a) -> 'a -> 'b t -> 'a list
val eachcol_rfold : ('a -> 'b -> 'b) -> 'a t -> 'b -> 'b list

val map : ('a -> 'b) -> 'a t -> 'b t
val eachrow_map : ('a -> 'b -> 'b) -> 'a list -> 'b t -> 'b t
val eachcol_map : ('a -> 'b -> 'b) -> 'a list -> 'b t -> 'b t

(* vim: set tw=96 et ts=2 sts=2 sw=2: *)
