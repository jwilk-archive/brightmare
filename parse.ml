open Dictionary_lib;;

type parse_operator = PO_Void | PO_Custom of string;;
type parse_element = PE_Void | PE_Custom of string;;
type parse_tree = 
  Element of parse_element | 
  Operator of parse_operator * parse_tree list;;

type t = parse_tree

let empty = Operator (PO_Void, []);;

(* rev: fixes up a `tree' *) (* curiously, FIXME *)
let rec rev tree =
  match tree with
    Element _ -> tree |
    Operator (PO_Void, []) ->
      Element (PE_Void) |
    Operator (PO_Void, [tree]) ->
      rev tree |
    Operator (op, [Operator (PO_Void, lst)]) ->
      Operator (op, List.rev (List.map rev lst)) |
    Operator (op, lst) -> 
      Operator (op, List.rev (List.map rev lst));;

let add basetree subtree  =
  match basetree with
    Element _ -> Operator (PO_Void, [basetree; subtree]) |
    Operator (op, basetrees) -> Operator (op, subtree::basetrees);;

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
    _ -> raise(Failure "backadd");; (* FIXME *)

let oo = -1;; (* oo + 1 == oo, hence oo = -1 *)

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
          (p, q) = JoinedDictionary.get Latex_dictionary.commands token 
       in
         let (subtree, toklist) = parse_a (Operator (PO_Custom token, [])) toklist q in
         parse_a 
            ( (if token.[0] = '\\' then add else backadd)
                bldtree 
                subtree
            ) 
            toklist 
            (limit - 1)
     with 
        Not_found ->
          parse_a 
            (add bldtree (Element (PE_Custom token))) toklist (limit-1);;

let rec as_rmathbox tree =
  match tree with
    Element (PE_Void) -> Rmath.empty 1 1 |
    Element (PE_Custom str) -> Rmath.si (Unicode.from_string str) |
    Operator (op, treelist) ->
      let boxlist = List.map as_rmathbox treelist in
      match (op, boxlist) with
        PO_Custom opstr, [] -> 
          if Dictionary.exist Latex_dictionary.symbols opstr
          then
            let symbol = Dictionary.get Latex_dictionary.symbols opstr in
            let symbol = Unicode.wchar_of_int symbol in
            let symbol = Unicode.make 1 symbol in
              Rmath.si symbol 
          else
            Rmath.si (Unicode.from_string opstr) (* FIXME *) |
        PO_Void, _ -> Rmath.join_h boxlist |
        PO_Custom "\\frac", [b1; b2] -> Rmath.frac b1 b2 |
        PO_Custom "_", [b1; b2] -> Rmath.crossjoin_SE b2 b1 |
        PO_Custom "^", [b1; b2] -> Rmath.crossjoin_NE b2 b1 |
        PO_Custom opstr, _ ->
          if Dictionary.exist Latex_dictionary.alphabets opstr 
          then
            Rmath.join_h boxlist (* FIXME *)
          else
            let
              opbox = Rmath.si (Unicode.from_string (opstr^"[[")) and (* FIXME *)
              opbox2 = Rmath.si (Unicode.from_string "]]") (* FIXME *)
            in
              Rmath.join_h (opbox::boxlist @ [opbox2]);;

let from_string str =
  let (revptree, _) = parse_a empty (Tokenize.make str) oo in
    rev revptree;;

let string_to_rmathbox s =
  as_rmathbox (from_string s);;

(* vim: set tw=96 et ts=2 sw=2: *)
