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

type wstring = string and wchar = string
type t = wstring

let ( ** ) = StrEx.( ** )

let empty = ""

let wchar_of_int = Unicore.utf8char_of_int

let from_string s =
  if Locale.charmap () = "UTF-8" then
    s
  else
    Locale.utf8string_of_string s

let wchar_of_char ch = 
  from_string (1 ** ch)

let to_string s = s

let length = Unicore.utf8string_length

let ( ++ ) = StrEx.( ++ )
let ( ** ) = StrEx.( **! )

(* vim: set tw=96 et ts=2 sw=2: *)
