type parse_operator = PO_Void | PO_Custom of string;;
type parse_element = PE_Void | PE_Custom of string;;
type parse_tree = 
  PT_Element of parse_element | 
  PT_Operator of parse_operator * parse_tree list;;

let pt_empty = PT_Operator (PO_Void, []);;

(* pt_rev: fixes up a `tree' *)
let rec pt_rev tree =
  match tree with
    PT_Element _ -> tree |
    PT_Operator (PO_Void, [tree]) ->
      pt_rev tree |
    PT_Operator (op, [PT_Operator (PO_Void, lst)]) ->
      PT_Operator (op, List.rev (List.map pt_rev lst)) |
    PT_Operator (op, lst) -> 
      PT_Operator (op, List.rev (List.map pt_rev lst));;

let pt_add basetree subtree  =
  match basetree with
    PT_Element _ -> PT_Operator (PO_Void, [basetree; subtree]) |
    PT_Operator (op, basetree) -> PT_Operator (op, subtree::basetree);;

let pt_backadd basetree subtree  =
  pt_add subtree basetree;;
(*  match basetree with
    PT_Element _ -> PT_Operator (PO_Void, [basetree; subtree]) |
    PT_Operator (op, basetree) -> PT_Operator (op, subtree::basetree);; *)

let infty = -1;;

let rec parse_a bldtree toklist limit =
  if limit = 0 then
    (bldtree, toklist)
  else
  match toklist with
    [] -> (bldtree, toklist) |
    "}"::toklist -> (bldtree, toklist) |
    "{"::toklist -> 
      let (newbldtree, toklist) = parse_a pt_empty toklist infty in
        parse_a (pt_add bldtree newbldtree) toklist (limit-1) |
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
         parse_a 
            ( (if token.[0] = '\\' then pt_add else pt_backadd)
                bldtree 
                newbldtree
            ) 
            toklist 
            (limit - 1)
     with 
        Not_found ->
          parse_a 
            (pt_add bldtree (PT_Element (PE_Custom token))) toklist (limit-1);;

let rec pt_to_rmb tree =
  match tree with
    PT_Element (PE_Void) -> Rmath.empty 1 1 |
    PT_Element (PE_Custom str) -> Rmath.si str |
    PT_Operator (op, treelist) ->
      let boxlist = List.map pt_to_rmb treelist in
      match (op, boxlist) with
        PO_Custom opstr, [] -> 
          if Dictionary.exist Latex_dictionary.symbols opstr
          then
            Rmath.si (Unicode.wchar_of_int (Dictionary.get Latex_dictionary.symbols opstr))
          else
            Rmath.si (opstr) (* FIXME *) |
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
              opbox = Rmath.si (opstr^"[[") and (* FIXME *)
              opbox2 = Rmath.si "]]" (* FIXME *)
            in
              Rmath.join_h (opbox::boxlist @ [opbox2]);;

let parse str =
  let (revptree, _) = parse_a pt_empty (Tokenize.make str) infty in
    pt_rev revptree;;

let string_to_rmb s =
  pt_to_rmb (parse s);;

(* vim: set tw=96 et ts=2 sw=2: *)
