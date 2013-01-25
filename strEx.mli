(*
 * Copyright © 2006, 2008, 2013 Jakub Wilk <jwilk@jwilk.net>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the “Software”),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
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

