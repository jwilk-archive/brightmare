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

type command = char
type internal_state = A_Normal | A_CommandBegin | A_Command | A_CommandEnd
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
  | _, _  ->                                  true, A_Normal

(* vim: set tw=96 et ts=2 sw=2: *)
