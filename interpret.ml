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
          "(" -> Rmath.Delim_bracket (true,  Rmath.Bracket_round) |
          ")" -> Rmath.Delim_bracket (false, Rmath.Bracket_round) |
          "[" -> Rmath.Delim_bracket (true,  Rmath.Bracket_square) |
          "]" -> Rmath.Delim_bracket (false, Rmath.Bracket_square) |
          "\\{" -> Rmath.Delim_bracket (true,  Rmath.Bracket_brace) |
          "\\}" -> Rmath.Delim_bracket (false, Rmath.Bracket_brace) |
          "<" | "\\langle" -> Rmath.Delim_bracket (true, Rmath.Bracket_angle) |
          ">" | "\\rangle" -> Rmath.Delim_bracket (true, Rmath.Bracket_angle) |
          "\\lfloor" -> Rmath.Delim_floor true  |
          "\\rfloor" -> Rmath.Delim_floor false |
          "\\lceil" -> Rmath.Delim_ceil true  | 
          "\\rceil" -> Rmath.Delim_ceil false |
          _ -> raise(Failure "")
      in
        Rmath.largedelimiter box d
    with
      Failure "" -> Rmath.empty 1 1

  let rec make tree =
    match tree with
      Element "" -> Rmath.empty 1 1 |
      Element str -> Rmath.si (Uni.from_string str) |
      Operator ("\\left\\right", d1::d2::treelist) ->
        let boxlist = ListEx.map make treelist in
        let box = Rmath.join_h boxlist in
        if Rmath.height box <= 1 then
          Rmath.join_h [(make d1);box;(make d2)]
        else
        (
          match (d1, d2) with
            Operator (d1, []), Operator(d2, []) ->
              let 
                d1 = get_large_delim d1 box and
                d2 = get_large_delim d2 box
              in
                Rmath.join_h [d1;box;d2] |
            _ -> Rmath.join_h [(make d1);box;(make d2)]
        ) |
      Operator (op, treelist) ->
        let boxlist = ListEx.map make treelist in
        match (op, boxlist) with
          "\\int", [] -> Rmath.integral () |
          "\\oint", [] -> Rmath.ointegral () |
          opstr, [] -> 
            if LatDict.exists opstr LatDict.allsymbols
            then
              let symbol = LatDict.get opstr LatDict.allsymbols in
              let symbol = Uni.wchar_of_int symbol in
              let symbol = 1 ** symbol in
                Rmath.si symbol 
            else if LatDict.exists opstr LatDict.loglikes then 
              Rmath.si (Uni.from_string (StrEx.str_after opstr 1))
            else
              Rmath.si (Uni.from_string opstr) (* FIXME *) |
          "", _ | "[", _ -> Rmath.join_h boxlist |
          "\\frac", [b1; b2] -> Rmath.frac b1 b2 |
          "\\sqrt", [bi; b] -> Rmath.sqrt b bi |
          "\\sqrt", [b] -> Rmath.sqrt b (Rmath.empty 1 1) |
          "_", [b1; b2] -> Rmath.crossjoin_SE b2 b1 |
          "^", [b1; b2] -> Rmath.crossjoin_NE b2 b1 |
          opstr, _ ->
            if LatDict.exists opstr LatDict.alphabets
            then
              Rmath.join_h boxlist (* FIXME *)
            else 
              let
                opbox = Rmath.si (Uni.from_string opstr)
              in
                Rmath.join_h (opbox::boxlist)

end

(* vim: set tw=96 et ts=2 sw=2: *)
