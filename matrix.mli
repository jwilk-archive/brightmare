(*
 * Copyright (c) 2006, 2008 Jakub Wilk <ubanus@users.sf.net>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License, version 2, as
 * published by the Free Software Foundation.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
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

(* vim: set tw=96 et ts=2 sw=2: *)
