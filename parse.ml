module type PARSE = Zz_signatures.PARSE
module type LATDICT = Zz_signatures.LATDICT

module Make 
  (LatDict : LATDICT) : 
  PARSE with type t = Parsetree.t and module LatDict = LatDict =
struct

  type t = Parsetree.t
  module LatDict = LatDict
  
  open Parsetree

  let empty = Operator ("", [])

  let rec fix tree =
    match tree with
      Element _ -> 
        tree |
      Operator ("", []) ->
        Element "" |
      Operator ("", [tree]) ->
        fix tree |
      Operator (op, lst) -> 
        Operator (op, ListEx.rev_map fix lst)

  let add basetree subtree  =
    match basetree with
      Element _ -> Operator ("", [basetree; subtree]) |
      Operator (op, basetrees) -> Operator (op, subtree::basetrees)

  let backadd basetree subtree =
    match subtree with
      Operator (subop, subtrees) ->
      ( match basetree with
          Operator ("", baselast::basetrees) ->
            Operator 
            ( "", 
              [ Operator (subop, baselast::subtrees);
                Operator ("", basetrees) ] ) |
          _ -> 
            Operator (subop, basetree::subtrees)
      ) |
      _ -> raise(Failure "Parse.backadd") (* FIXME *)

  let oo = -1 (* oo + 1 == oo, thus oo = -1 *)

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
            (p, q) = LatDict.get token LatDict.commands
          in
            let (subtree, toklist) = parse_a (Operator (token, [])) toklist q in
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
              (add bldtree (Element token)) toklist (limit-1)

  let from_tokens tokens =
    let (revptree, _) = parse_a empty tokens oo in
      fix revptree

end

(* vim: set tw=96 et ts=2 sw=2: *)
