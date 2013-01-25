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

module type LEX_AUTOMATON = Signatures.LEX_AUTOMATON
module type T = Signatures.LEXSCAN

module Make(Aut : LEX_AUTOMATON) : T =
struct

  let ( ** ) = StrEx.( ** )
  
  let rec scan lastlex lexlist chars state =
    match chars with
    | [] -> lastlex::lexlist
    | head::chars ->
        let state = Aut.execute head state in
        let head = 1 ** head in
          if Aut.pubstate state then
            scan head (lastlex::lexlist) chars state
          else
            scan (lastlex ^ head) lexlist chars state

  let make str =
    let result =
      ListEx.rev 
        (scan "" [] (StrEx.as_list str) Aut.default)
    in 
      match result with
      | ""::result -> result
      | _ -> result

end

(* vim: set tw=96 et ts=2 sw=2: *)
