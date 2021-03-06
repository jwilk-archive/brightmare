(*
 * Copyright © 2006-2013 Jakub Wilk <jwilk@jwilk.net>
 * SPDX-License-Identifier: MIT
 *)

let ( ** ) = StrEx.( ** )

let str_of_int n = 1 ** (char_of_int n)

let utf8char_of_int n =
  if n < 0 then
    raise(Invalid_argument "Unicore.utf8char_of_int")
  else if n < 0x80
  then
    str_of_int n
  else if n < 0x800
  then
    str_of_int (0xc0 + (n lsr 6) land 0x1f) ^
    str_of_int (0x80 +  n        land 0x3f)
  else if n < 0x10000
  then
    str_of_int (0xe0 + (n lsr 12) land 0x0f) ^
    str_of_int (0x80 + (n lsr  6) land 0x3f) ^
    str_of_int (0x80 +  n         land 0x3f)
  else
    raise(Invalid_argument "Unicore.utf8char_of_int")

let utf8char_of_char c =
  utf8char_of_int (int_of_char c)

let utf8string_length s =
  let plen = StrEx.length s in
  let rec length_a ac i =
    if i >= plen then
      ac
    else
      let ch = int_of_char s.[i] in
      let n =
        if ch < 0x80 then 0 else
        if (ch land 0xe0) = 0xc0 then 1 else
        if (ch land 0xf0) = 0xe0 then 2 else
        if (ch land 0xf8) = 0xf0 then 3 else
        if (ch land 0xfc) = 0xf8 then 4 else
        if (ch land 0xfe) = 0xfc then 5 else 1
      in
        length_a (ac-n) (i+n+1)
  in let len = length_a plen 0 in
    if len >= 0 then
      len
    else
      raise (Failure "Unicore.length")

(* vim: set tw=96 et ts=2 sts=2 sw=2: *)
