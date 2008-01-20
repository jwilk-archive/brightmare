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

type t = string

val ( ++ ) : t -> t -> t
val ( ** ) : int -> char -> t
val ( **! ) : int -> t -> t
val as_list : t -> char list
val of_list : char list -> t

val length : t -> int
val get : t -> int -> char
val make : int -> char -> t
val copy : t -> t
val sub : t -> int -> int -> t
val concat : t -> t list -> t
val iter : (char -> unit) -> t -> unit
val escaped : t -> t
val index : t -> char -> int
val rindex : t -> char -> int
val index_from : t -> int -> char -> int
val rindex_from : t -> int -> char -> int
val contains : t -> char -> bool
val contains_from : t -> int -> char -> bool
val rcontains_from : t -> int -> char -> bool
val compare: t -> t -> int

type regexp
val regexp : string -> regexp

val search_forward : regexp -> string -> int -> int

val replace : regexp -> string -> string -> string
val replace_first : regexp -> string -> string -> string
val substitute : regexp -> (string -> string) -> string -> string
val substitute_first : regexp -> (string -> string) -> string -> string

val str_before : string -> int -> string
val str_after : string -> int -> string
val first_chars : string -> int -> string
val last_chars : string -> int -> string

