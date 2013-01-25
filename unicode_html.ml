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

type wstring = int * string
type wchar = string
type t = wstring

let ( ++ ) = StrEx.( ++ )
let ( ** ) = StrEx.( ** )
let ( **! ) = StrEx.( **! )

let empty = 0, ""

let from_string s = 
  let len = StrEx.length s in
  let 
    repl_from = ["&"; "<"; ">"] and
    repl_to = ["&amp;"; "&lt;"; "&gt;"]
  in let 
    repl_from = ListEx.map StrEx.regexp repl_from 
  in let
    s = 
      ListEx.fold2 
      ( fun s sfrom sto ->
        StrEx.replace sfrom sto s )
      s repl_from repl_to
  in
    len, s
  
let to_string (_, s) = s

let wchar_of_int n = 
  if (n<127) && (n!=38) && (n!=60) && (n!=62) then
    1 ** (char_of_int n)
  else
    Printf.sprintf "&#%d;" n

let wchar_of_char ch = wchar_of_int (int_of_char ch)

let length (l, _) = l

let ( ++ ) (l1, s1) (l2, s2) = l1 + l2, s1 ++ s2
let ( ** ) n ch = n, n **! ch

(* vim: set tw=96 et ts=2 sw=2: *)
