(*
 * Copyright © 2006-2013 Jakub Wilk <jwilk@jwilk.net>
 * SPDX-License-Identifier: MIT
 *)

module type UNICODE =
  Signatures.UNICODE
module type LATDICT =
  Signatures.LATDICT
module type RMATH =
  Signatures.RMATH
module type T =
  Signatures.INTERPRET with type t = Parsetree.t

module Make
  (Uni : UNICODE)
  (LatDict : LATDICT)
  (Rmath : RMATH with module Uni = Uni) :
  T with type s = Rmath.t =
struct

  let ( ** ) = Uni.( ** )

  type t = Parsetree.t
  type s = Rmath.t

  open Parsetree

  let get_large_delim d box =
    try
      let d =
        match d with
        | "(" | "\\lgroup" -> Rmath.Delim_bracket (true,  Rmath.Bracket_round)
        | ")" | "\\rgroup" -> Rmath.Delim_bracket (false, Rmath.Bracket_round)
        | "[" | "\\lbrack" -> Rmath.Delim_bracket (true,  Rmath.Bracket_square)
        | "]" | "\\rbrack" -> Rmath.Delim_bracket (false, Rmath.Bracket_square)
        | "\\{" | "\\lbrace" -> Rmath.Delim_bracket (true,  Rmath.Bracket_brace)
        | "\\}" | "\\rbrace" -> Rmath.Delim_bracket (false, Rmath.Bracket_brace)
        | "<" | "\\langle" -> Rmath.Delim_bracket (true, Rmath.Bracket_angle)
        | ">" | "\\rangle" -> Rmath.Delim_bracket (true, Rmath.Bracket_angle)
        | "\\lfloor" -> Rmath.Delim_floor true
        | "\\rfloor" -> Rmath.Delim_floor false
        | "\\lceil" -> Rmath.Delim_ceil true
        | "\\rceil" -> Rmath.Delim_ceil false
        | "\\vert" | "|" -> Rmath.Delim_vert
        | "\\Vert" | "\\|" -> Rmath.Delim_doublevert
        | _ -> raise(Failure "")
      in
        Rmath.largedelimiter box d
    with
      Failure "" -> Rmath.empty 1 1

  let rec
    env_array_make accum =
      function
      | Operator ("\\\\", []) -> accum
      | Operator ("\\\\", tree::trees) ->
          let result =
            env_array_make
              (Matrix.append_row accum)
              tree
          in
            env_array_make
              result
              (Operator ("\\\\", trees))
      | Operator ("&", []) -> accum
      | Operator ("&", tree::trees) ->
          env_array_make
            (Matrix.append accum (make tree))
            (Operator ("&", trees))
      | tree ->
          env_array_make accum (Operator ("&", [tree]))
    and
    make =
      function
      | Element "" -> Rmath.empty 1 1
      | Element str -> Rmath.s (Uni.from_string str)
      | Operator ("\\left\\right", d1::d2::treelist) ->
          let boxlist = ListEx.map make treelist in
          let box = Rmath.join_h boxlist in
          if Rmath.height box <= 1 then
            Rmath.join_h [(make d1); box; (make d2)]
          else
          (
            match (d1, d2) with
            | Operator (d1, []), Operator(d2, []) ->
                let
                  d1 = get_large_delim d1 box and
                  d2 = get_large_delim d2 box
                in
                  Rmath.join_h [d1; box; d2]
            | _ -> Rmath.join_h [(make d1); box; (make d2)]
          )
      | Operator ("_", [sub; obj]) ->
          let subbox = make sub and objbox = make obj in
          let joinf =
            ( match obj with
              | Operator (opstr, []) ->
                  if
                    LatDict.exists opstr LatDict.loglikes ||
                    LatDict.exists opstr LatDict.operators
                  then
                    Rmath.join_bot
                  else
                    Rmath.join_SE
              | Operator (("\\mathop" | "\\underbrace"), _) -> Rmath.join_bot
              | _ -> Rmath.join_SE )
          in
            joinf objbox subbox
      | Operator ("^", [sup; obj]) ->
          let supbox = make sup and objbox = make obj in
          let joinf =
          ( match obj with
            | Operator (opstr, []) ->
                if LatDict.exists opstr LatDict.operators then
                  Rmath.join_top
                else
                  Rmath.join_NE
            | Operator (("\\mathop" | "\\overbrace"), _) -> Rmath.join_top
            | _ -> Rmath.join_NE )
          in
            joinf objbox supbox
      | Operator ("_^", [sub; sup; obj]) ->
          let supbox = make sup and subbox = make sub and objbox = make obj in
          let joinf =
          ( match obj with
            | Operator (opstr, []) ->
                if LatDict.exists opstr LatDict.operators then
                  Rmath.join_topbot
                else
                  Rmath.join_NESE
            | Operator ("\\mathop", _) -> Rmath.join_topbot
            | _ -> Rmath.join_NESE )
          in
            joinf objbox supbox subbox
      | Operator ("#array", [optv; cont]) ->
          let optv =
            match optv with
            | Operator ("", trees) ->
                ListEx.map
                  ( function
                    | Element "l" -> 'E'
                    | Element "c" -> 'W'
                    | Element "r" -> 'Q'
                    | _ -> '?' )
                  trees
            | Element "l" -> ['E']
            | Element "c" -> ['W']
            | Element "r" -> ['Q']
            | _ -> []
          in let optv =
            ListEx.filter
              ( function
                | 'E' | 'W' | 'Q' -> true
                | _ -> false)
              optv
          in let optc = ListEx.length optv in
          let matrix = Matrix.make (Rmath.empty 0 0) in
          let matrix = env_array_make matrix cont in
          let matrix = Matrix.grow matrix optc 0 in
          let matrix = Matrix.fillup matrix in
          let width = Matrix.width matrix in
          let (optc, optv) =
            if optc < width then
              width, optv @ (ListEx.make (width-optc) 'Z')
            else
              optc, optv
          in let widths =
            Matrix.eachcol_fold
              (fun ac box -> max ac (Rmath.width box))
              0
              matrix
          in let widths_aligns =
            ListEx.map2 (fun x y -> x, y) widths optv
          in let matrix =
            Matrix.eachcol_map
              (fun (w, al) box -> Rmath.align al box w)
              widths_aligns
              matrix
          in let spacings =
            match width with
            | 0 -> []
            | 1 -> [0]
            | n -> 0::(ListEx.make (n-1) 1)
          in let matrix =
            Matrix.eachcol_map
              (fun w box -> Rmath.join_h [Rmath.empty w 1; box])
              spacings
              matrix
          in let rows =
            Matrix.eachrow_fold
              (fun ac box -> Rmath.join_h [ac; box])
              (Rmath.empty 0 0)
              matrix
          in
            Rmath.join_v rows
      | Operator ("\\mathbb", [Element "C"]) -> Rmath.s (1 ** (Uni.wchar_of_int 0x2102))
      | Operator ("\\mathbb", [Element "H"]) -> Rmath.s (1 ** (Uni.wchar_of_int 0x210D))
      | Operator ("\\mathbb", [Element "N"]) -> Rmath.s (1 ** (Uni.wchar_of_int 0x2115))
      | Operator ("\\mathbb", [Element "P"]) -> Rmath.s (1 ** (Uni.wchar_of_int 0x2119))
      | Operator ("\\mathbb", [Element "Q"]) -> Rmath.s (1 ** (Uni.wchar_of_int 0x211a))
      | Operator ("\\mathbb", [Element "R"]) -> Rmath.s (1 ** (Uni.wchar_of_int 0x211d))
      | Operator ("\\mathbb", [Element "Z"]) -> Rmath.s (1 ** (Uni.wchar_of_int 0x2124))
      | Operator (op, treelist) ->
          let boxlist = ListEx.map make treelist in
          match (op, boxlist) with
          | "\\!", [] -> Rmath.empty 0 1
          | ("\\;" | "\\:" | "\\,"), [] -> Rmath.empty 1 1
          | "\\overbrace",      [b] ->
              Rmath.join_top b (Rmath.overornament b Rmath.Ornament_brace)
          | "\\overleftarrow",  [b] ->
              Rmath.join_top b (Rmath.overornament b (Rmath.Ornament_arrow (true)))
          | "\\overline",       [b] ->
              Rmath.join_top b (Rmath.overornament b Rmath.Ornament_line)
          | "\\overrightarrow", [b] ->
              Rmath.join_top b (Rmath.overornament b (Rmath.Ornament_arrow (false)))
          | "\\underbrace",     [b] ->
              Rmath.join_bot b (Rmath.underornament b Rmath.Ornament_brace)
          | "\\underline",      [b] ->
              Rmath.join_bot b (Rmath.underornament b Rmath.Ornament_line)
          | "\\bigcap",    [] -> Rmath.bigcap false 0x20
          | "\\bigcup",    [] -> Rmath.bigcup false 0x20
          | "\\bigodot",   [] -> Rmath.bigo 0xb7
          | "\\bigoplus",  [] -> Rmath.bigo 0x2b
          | "\\bigotimes", [] -> Rmath.bigo 0xd7
          | "\\bigsqcup",  [] -> Rmath.bigcup true  0x20
          | "\\biguplus",  [] -> Rmath.bigcup false 0x61
          | "\\bigvee",    [] -> Rmath.bigvee ()
          | "\\bigwedge",  [] -> Rmath.bigwedge ()
          | "\\coprod",    [] -> Rmath.coprod ()
          | "\\int",       [] -> Rmath.integral ()
          | "\\oint",      [] -> Rmath.ointegral ()
          | "\\prod",      [] -> Rmath.prod ()
          | "\\sum",       [] -> Rmath.sum ()
          | "\\displaystyle", [] -> Rmath.empty 0 0
          | "\\\\",      _::_ -> Rmath.join_v boxlist
          | "\\newline", _::_ -> Rmath.join_v boxlist
          | "&", b1::boxlist ->
              ListEx.fold
                (fun accum box -> Rmath.join_h [accum; Rmath.empty 3 1; box])
                b1
                boxlist
          | ("\\mod" | "\\bmod"), [] -> Rmath.s (Uni.from_string "mod")
          | "\\pmod", [b] ->
              let spc = Rmath.empty 2 1 in
              let d x = Rmath.Delim_bracket (x,  Rmath.Bracket_round) in
              let (d1, d2) =
                if (Rmath.height b) > 1 then
                  Rmath.largedelimiter b (d true),
                  Rmath.largedelimiter b (d false)
                else
                  Rmath.s (Uni.from_string "("), Rmath.s (Uni.from_string ")")
              in
              let modb = Rmath.s (Uni.from_string "mod ") in
                Rmath.join_h [spc; d1; modb; b; d2]
          | opstr, [] ->
              if LatDict.exists opstr LatDict.symbols
              then
                let symbol = LatDict.get opstr LatDict.symbols in
                let symbol = Uni.wchar_of_int symbol in
                let symbol = 1 ** symbol in
                  Rmath.s symbol
              else if LatDict.exists opstr LatDict.loglikes then
                Rmath.s (Uni.from_string (StrEx.str_after opstr 1))
              else
                Rmath.s (Uni.from_string opstr)
          | ("" | "[" | "\\mathop"), _ -> Rmath.join_h boxlist
          | "\\binom", [b1; b2] ->
              let b = Rmath.fraclike b1 b2 in
              let d x = Rmath.Delim_bracket (x,  Rmath.Bracket_round) in
              let d1 = Rmath.largedelimiter b (d true) in
              let d2 = Rmath.largedelimiter b (d false) in
                Rmath.join_h [d1; b; d2]
          | ("\\frac" | "\\cfrac"), [b1; b2] -> Rmath.frac b1 b2
          | "\\sqrt", [bi; b] -> Rmath.sqrt b bi
          | "\\sqrt", [b] -> Rmath.sqrt b (Rmath.empty 1 1)
          | opstr, _ ->
              if LatDict.is_alphabet opstr then
                Rmath.join_h boxlist (* FIXME *)
              else
                let opbox = Rmath.s (Uni.from_string opstr) in
                  Rmath.join_h (opbox::boxlist)

end

(* vim: set tw=96 et ts=2 sts=2 sw=2: *)
