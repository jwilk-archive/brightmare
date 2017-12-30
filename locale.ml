(*
 * Copyright © 2006-2013 Jakub Wilk <jwilk@jwilk.net>
 * SPDX-License-Identifier: MIT
 *)

external charmap : unit -> string = "locale_charmap"
external utf8string_of_string : string -> string = "utf8string_of_string"

(* vim: set tw=96 et ts=2 sts=2 sw=2: *)
