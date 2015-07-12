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

(* vim: set tw=96 et ts=2 sts=2 sw=2: *)
