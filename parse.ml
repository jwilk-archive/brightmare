open List;;
open Tokenize;;
open Render;;
open Render_math;;

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

let rec parse_a bldtree toklist =
  match toklist with
    [] -> (bldtree, toklist) |
    "}"::toklist -> (bldtree, toklist) |
    "{"::toklist -> 
      let (newbldtree, toklist) = parse_a parsetree_empty toklist in
        parse_a (parsetree_add bldtree newbldtree) toklist |
    token::toklist ->
      if token.[0] = '\\' then
        let (newbldtree, toklist) = parse_a (PT_Operator (PO_Custom token, [])) toklist in
          parse_a (parsetree_add bldtree newbldtree) toklist
      else
        parse_a 
          (parsetree_add bldtree (PT_Element (PE_Custom token))) toklist;;

let rec parsetree_to_renderbox tree =
  match tree with
    PT_Element (PE_Void) -> rbx_empty 1 1 |
    PT_Element (PE_Custom str) -> rbx_si str |
    PT_Operator (_, []) -> rbx_empty 1 1 |
    PT_Operator (PO_Void, treelist) ->
      let boxlist = map parsetree_to_renderbox treelist in
        rbx_join_h 'S' boxlist |
    PT_Operator (PO_Custom "\\frac", [t1;t2]) ->
      let 
        b1 = parsetree_to_renderbox t1 and
        b2 = parsetree_to_renderbox t2
      in
        rbm_frac b1 b2 |
    PT_Operator (PO_Custom op, treelist) ->
      let 
        boxlist = map parsetree_to_renderbox treelist and
        opbox = rbx_si (op^": ")
      in
        rbx_join_h 'S' (opbox::boxlist);;

let parse str=
  let (revptree, _) = parse_a parsetree_empty (tokenize str) in
    parsetree_rev revptree;;

(* vim: set tw=96 et ts=2 sw=2: *)
