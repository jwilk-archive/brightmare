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

include String
include Str

let ( ++ ) = ( ^ )

let ( ** ) = make

let ( **! ) n str =
  if n < 0 then
    raise(Invalid_argument "StrEx.(**!)")
  else
    let rec multi accum n =
      if n <= 0 then
        accum
      else
        multi (accum ++ str) (n-1)
    in
      multi "" n

let as_list str =
  let len = length str in
  let rec los_helper lst i =
    if i < 0 then
      lst
    else
      los_helper ((get str i)::lst) (i-1)
  in
    los_helper [] (len-1)

let of_list =
  ListEx.fold 
    (fun acc ch -> acc ^ (1 ** ch))
    ""

let substitute = global_substitute
let replace = global_replace

let str_after = string_after
let str_before = string_before

(* vim: set tw=96 et ts=2 sw=2: *)
