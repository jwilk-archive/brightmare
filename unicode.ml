(*
 * Copyright © 2006-2013 Jakub Wilk <jwilk@jwilk.net>
 * SPDX-License-Identifier: MIT
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

(* vim: set tw=96 et ts=2 sts=2 sw=2: *)
