module type UNICODE = Zz_signatures.UNICODE
module type RMATH = Zz_signatures.RMATH
module type T = Zz_signatures.PARSE

module Make 
  (Uni : UNICODE) 
  (Rmath : RMATH with module Uni = Uni) :
  T with type rmath_t = Rmath.t =
struct
  
  let ( ** ) = Uni.( ** )

  type parse_operator = PO_Void | PO_Custom of string
  type parse_element = PE_Void | PE_Custom of string
  type parse_tree = 
    Element of parse_element | 
    Operator of parse_operator * parse_tree list

  type t = parse_tree
  type rmath_t = Rmath.t

  let empty = Operator (PO_Void, [])

  (* rev: fixes up a `tree' *) (* curiously enough, FIXME *)
  let rec rev tree =
    match tree with
      Element _ -> 
        tree |
      Operator (PO_Void, []) ->
        Element (PE_Void) |
      Operator (PO_Void, [tree]) ->
        rev tree |
      Operator (op, [Operator (PO_Void, lst)]) ->
        Operator (op, ListEx.rev_map rev lst) |
      Operator (op, lst) -> 
        Operator (op, ListEx.rev_map rev lst)

  let add basetree subtree  =
    match basetree with
      Element _ -> Operator (PO_Void, [basetree; subtree]) |
      Operator (op, basetrees) -> Operator (op, subtree::basetrees)

  let backadd basetree subtree =
    match subtree with
      Operator (subop, subtrees) ->
      ( match basetree with
          Operator (PO_Void, baselast::basetrees) ->
            Operator 
            ( PO_Void, 
              [ Operator (subop, baselast::subtrees);
                Operator (PO_Void, basetrees) ] ) |
          _ -> 
            Operator (subop, basetree::subtrees)
      ) |
      _ -> raise(Failure "Parse.backadd") (* FIXME *)

  let oo = -1 (* oo + 1 == oo, hence oo = -1 *)

  let rec parse_a bldtree toklist limit =
    if limit = 0 then
      (bldtree, toklist)
    else
    match toklist with
      [] -> (bldtree, toklist) |
      "}"::toklist -> (bldtree, toklist) |
      "{"::toklist -> 
        let (newbldtree, toklist) = parse_a empty toklist oo in
          parse_a (add bldtree newbldtree) toklist (limit-1) |
      token::toklist ->
        try 
          let 
            (p, q) = Dictionary.get token Latex_dictionary.commands
          in
            let (subtree, toklist) = parse_a (Operator (PO_Custom token, [])) toklist q in
              parse_a 
                ( (if token.[0] = '^' || token.[0] = '_' then backadd else add)
                    bldtree 
                    subtree
                 ) 
                toklist 
                (limit - 1)
        with 
          Not_found ->
            parse_a 
              (add bldtree (Element (PE_Custom token))) toklist (limit-1)

  let rec as_rmathbox tree =
    match tree with
      Element (PE_Void) -> Rmath.empty 1 1 |
      Element (PE_Custom str) -> Rmath.si (Uni.from_string str) |
      Operator (op, treelist) ->
        let boxlist = ListEx.map as_rmathbox treelist in
        match (op, boxlist) with
          PO_Custom opstr, [] -> 
            if Dictionary.exists opstr Latex_dictionary.allsymbols
            then
              let symbol = Dictionary.get opstr Latex_dictionary.allsymbols in
              let symbol = Uni.wchar_of_int symbol in
              let symbol = 1 ** symbol in
                Rmath.si symbol 
            else if Dictionary.exists opstr Latex_dictionary.loglikes then 
              Rmath.si (Uni.from_string (StrEx.str_after opstr 1))
            else
              Rmath.si (Uni.from_string opstr) (* FIXME *) |
          PO_Void, _ -> Rmath.join_h boxlist |
          PO_Custom "\\frac", [b1; b2] -> Rmath.frac b1 b2 |
          PO_Custom "_", [b1; b2] -> Rmath.crossjoin_SE b2 b1 |
          PO_Custom "^", [b1; b2] -> Rmath.crossjoin_NE b2 b1 |
          PO_Custom opstr, _ ->
            if Dictionary.exists opstr Latex_dictionary.alphabets
            then
              Rmath.join_h boxlist (* FIXME *)
            else 
              let
                opbox = Rmath.si (Uni.from_string opstr)
              in
                Rmath.join_h (opbox::boxlist)

  let from_tokens tokens =
    let (revptree, _) = parse_a empty tokens oo in
      rev revptree

  let tokens_to_rmathbox s =
    as_rmathbox (from_tokens s)

end

(* vim: set tw=96 et ts=2 sw=2: *)
