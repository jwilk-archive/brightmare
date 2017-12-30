(*
 * Copyright © 2006-2013 Jakub Wilk <jwilk@jwilk.net>
 * SPDX-License-Identifier: MIT
 *)

type t =
| Element of string
| Operator of string * t list

(* vim: set tw=96 et ts=2 sts=2 sw=2: *)
