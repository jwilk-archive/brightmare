type parse_operator = PO_Void | PO_Custom of string;;
type parse_element = PE_Void | PE_Custom of string;;
type parse_tree = 
  PT_Element of parse_element | 
  PT_Operator of parse_operator * parse_tree list;;

let parsetree_empty = PT_Operator (PO_Void, []);;

(* parsetree_rev: fixes up a `tree' *)
let rec parsetree_rev tree =
  match tree with
    PT_Element _ -> tree |
    PT_Operator (PO_Void, [tree]) ->
      parsetree_rev tree |
    PT_Operator (op, [PT_Operator (PO_Void, lst)]) ->
      PT_Operator (op, List.rev (List.map parsetree_rev lst)) |
    PT_Operator (op, lst) -> 
      PT_Operator (op, List.rev (List.map parsetree_rev lst));;

let parsetree_add basetree subtree  =
  match basetree with
    PT_Element _ -> PT_Operator (PO_Void, [basetree; subtree]) |
    PT_Operator (op, basetree) -> PT_Operator (op, subtree::basetree);;

let infty = -1;;

let rec parse_a bldtree toklist limit =
  if limit = 0 then
    (bldtree, toklist)
  else
  match toklist with
    [] -> (bldtree, toklist) |
    "}"::toklist -> (bldtree, toklist) |
    "{"::toklist -> 
      let (newbldtree, toklist) = parse_a parsetree_empty toklist infty in
        parse_a (parsetree_add bldtree newbldtree) toklist (limit-1) |
    token::toklist ->
      try 
        let 
          (p, q) = 
            if Dictionary.exist Latex_dictionary.symbols token 
            then
              (0, 0)
            else if Dictionary.exist Latex_dictionary.alphabets token 
            then
              (0, 1)
            else
              Dictionary.get Latex_dictionary.commands token 
        in
        let (newbldtree, toklist) = parse_a (PT_Operator (PO_Custom token, [])) toklist q in
          parse_a (parsetree_add bldtree newbldtree) toklist (limit-1)
      with 
        Not_found ->
          parse_a 
            (parsetree_add bldtree (PT_Element (PE_Custom token))) toklist (limit-1);;

let rec parsetree_to_renderbox tree =
  match tree with
    PT_Element (PE_Void) -> Rmath.empty 1 1 |
    PT_Element (PE_Custom str) -> Rmath.si str |
    PT_Operator (PO_Custom op, []) -> 
      if Dictionary.exist Latex_dictionary.symbols op
      then
        Rmath.si (Unicode.wchar_of_int (Dictionary.get Latex_dictionary.symbols op))
      else
        Rmath.si ("<["^op^"]>") (* FIXME *) |
    PT_Operator (PO_Void, treelist) ->
      let boxlist = List.map parsetree_to_renderbox treelist in
        Rmath.join_h 'S' boxlist |
    PT_Operator (PO_Custom "\\frac", [t1;t2]) ->
      let 
        b1 = parsetree_to_renderbox t1 and
        b2 = parsetree_to_renderbox t2
      in
        Rmath.frac b1 b2 |
    PT_Operator (PO_Custom op, treelist) ->
      let boxlist = List.map parsetree_to_renderbox treelist in
        if Dictionary.exist Latex_dictionary.alphabets op 
        then
          Rmath.join_h 'S' boxlist (* FIXME *)
        else
          let
            opbox = Rmath.si (op^": ")
          in
            Rmath.join_h 'S' (opbox::boxlist);;

let parse str =
  let (revptree, _) = parse_a parsetree_empty (Tokenize.make str) infty in
    parsetree_rev revptree;;

let string_to_renderbox s =
  parsetree_to_renderbox (parse s);;

(* vim: set tw=96 et ts=2 sw=2: *)
