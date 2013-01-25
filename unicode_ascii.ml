(*
 * Copyright (c) 2006, 2008 Jakub Wilk <jwilk@jwilk.net>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License, version 2, as
 * published by the Free Software Foundation.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *)

type 
  wstring = string and 
  wchar = string and
  t = string

let empty = ""

let id x = x

let from_string = id
let to_string = id

let locale_charmap = Locale.charmap ()

let wchar_of_int =
  match locale_charmap with
  | "UTF-8" -> Unicore.utf8char_of_int
  | _ -> Unicore_convert.ascii_of_int

let wchar_of_char ch = 
  wchar_of_int (int_of_char ch)

let length =
  match locale_charmap with
    "UTF-8" -> Unicore.utf8string_length |
    _ -> StrEx.length

let ( ** ) = StrEx.( **! )
let ( ++ ) = StrEx.( ++ )

(* vim: set tw=96 et ts=2 sw=2: *)
