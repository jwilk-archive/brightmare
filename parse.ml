open Tokenize;;

type parse_operator = PO_Void | PO_Custom of string;;
type parse_element = PE_Void | PE_Custom of string;;
type parse_tree = 
  PT_Element of parse_element | 
  PT_Operator of parse_operator * parse_tree list;;

let parsetree_empty = PT_Operator (PO_Void, []);;

let rec parsetree_rev tree =
  match tree with
    PT_Element _ -> tree |
    PT_Operator (op, lst) -> 
      PT_Operator (op, List.rev (List.map parsetree_rev lst));;

let parsetree_add basetree subtree  =
  match basetree with
    PT_Element _ -> PT_Operator (PO_Void, [basetree; subtree]) |
    PT_Operator (op, basetree) -> PT_Operator (op, subtree::basetree);;

let rec parse_a bldtree toklist =
  match toklist with
    [] -> (bldtree, toklist) |
    "}"::toklist -> (bldtree, toklist) |
    "{"::toklist -> 
      let (newbldtree, toklist) = parse_a parsetree_empty toklist in
        parse_a (parsetree_add bldtree newbldtree) toklist |
    token::toklist ->
      parse_a 
        (parsetree_add bldtree (PT_Element (PE_Custom token))) toklist;;

let parse str =
  let (revptree, _) = parse_a parsetree_empty (tokenize str) in
    parsetree_rev revptree;;

(* vim: set tw=96 et ts=2 sw=2: *)
