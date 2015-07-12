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

(* vim: set tw=96 et ts=2 sts=2 sw=2: *)
