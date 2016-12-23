(*
 * Copyright © 2006-2013 Jakub Wilk <jwilk@jwilk.net>
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

type command = char
type internal_state = A_Normal | A_Number | A_CommandBegin | A_Command | A_CommandEnd
type s = bool
type t = s * internal_state

let default = false, A_Normal

let pubstate (st, _) = st

let execute cmd (_, is) =
  match (is, cmd) with
  | A_CommandBegin, '\\' ->                  false, A_CommandEnd
  | _, '\\' ->                                true, A_CommandBegin
  | A_CommandBegin, ('A'..'Z' | 'a'..'z') -> false, A_Command
  | A_CommandBegin, _ ->                     false, A_CommandEnd
  | A_Command, ('A'..'Z' | 'a'..'z') ->      false, A_Command
  | A_Command, _ ->                           true, A_Normal
  | A_Normal, '0'..'9' ->                     true, A_Number
  | A_Number, '0'..'9' ->                    false, A_Number
  | _, _  ->                                  true, A_Normal

(* vim: set tw=96 et ts=2 sts=2 sw=2: *)
