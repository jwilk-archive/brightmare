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

module type T =
  Signatures.INTERPRET with type t = Parsetree.t

module Make
  (SubInterpret : T) :
  T with type s = SubInterpret.s =
struct

  type t = Parsetree.t
  type s = SubInterpret.s

  open Parsetree

  let rec implode =
    function
    | [] -> ""
    | head::[] -> head
    | head::args -> head ^ ", " ^ (implode args)

  let rec debug_rmathbox =
    function
    | Element str -> "\x1B[33;1m" ^ str ^ "\x1B[0m"
    | Operator (op, treelist) ->
        let treelist = ListEx.map debug_rmathbox treelist in
        let argstr = implode treelist in
          "\x1B[35m" ^ op ^ "\x1B[0m(" ^ argstr ^ ")"

  let make tree =
    begin
      print_string ((debug_rmathbox tree) ^ "\n");
      SubInterpret.make tree
    end

end

(* vim: set tw=96 et ts=2 sw=2: *)
