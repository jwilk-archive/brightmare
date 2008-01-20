(*
 * Copyright (c) 2006, 2008 Jakub Wilk <ubanus@users.sf.net>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License, version 2, as
 * published by the Free Software Foundation.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
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
