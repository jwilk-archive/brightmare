module type UNICODE = 
  Zz_signatures.UNICODE
module type LATDICT =
  Zz_signatures.LATDICT
module type RMATH = 
  Zz_signatures.RMATH
module type T = 
  Zz_signatures.INTERPRET with type t = Parsetree.t

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

  let rec make tree =
    match tree with
      Element "" -> Rmath.empty 1 1 |
      Element str -> Rmath.si (Uni.from_string str) |
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
          "\\left\\right", d1::d2::boxlist ->
            let b = Rmath.join_h boxlist in
              Rmath.join_h [d1;b;d2] |
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
