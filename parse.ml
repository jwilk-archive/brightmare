module type PARSE = Signatures.PARSE
module type LATDICT = Signatures.LATDICT

module Make 
  (LatDict : LATDICT) : 
  PARSE with type t = Parsetree.t =
struct

  type t = Parsetree.t
  module LatDict = LatDict
 
  exception Parse_error
  exception Internal_error
 
  open Parsetree

  let empty = Operator ("", [])

  let rec fix tree =
    match tree with
      Element _ -> 
        tree |
      Operator ("", [tree]) ->
        fix tree |
      Operator ("\\left\\right", d1::d2::trees) ->
        Operator ("\\left\\right", d1::d2::(ListEx.rev_map fix trees)) |
      Operator ("_", [Operator ("^", [tree;b]); a]) ->
        Operator ("_^", [fix a; fix b; fix tree]) |
      Operator ("^", [Operator ("_", [tree;b]); a]) ->
        Operator ("_^", [fix b; fix a; fix tree]) |
      Operator (op, trees) -> 
        Operator (op, ListEx.rev_map fix trees)

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
      _ -> raise(Internal_error)

  let oo = -1 (* oo + 1 == oo, thus oo = -1 *)

  let extract_delim lexlist =
    match lexlist with
      [] -> ".", [] |
      cand::tail ->
        if LatDict.exists cand LatDict.delimiters then
          cand, tail
        else
          ".", lexlist

  let rec parse_a accum lexlist limit brlimit br =
    if limit = 0 then
      (accum, lexlist)
    else
    match lexlist with
      [] -> (accum, lexlist) |

      "}"::lexlist -> (accum, lexlist) |
      "{"::lexlist -> 
        let (newaccum, lexlist) = parse_a empty lexlist oo 0 false in
          parse_a (add accum newaccum) lexlist (limit-1) 0 br  |

      "\\right"::lexlist ->
        let (delim, lexlist) = extract_delim lexlist in
          Operator ("\\right", [Operator (delim, []); accum]), lexlist |
      "\\left"::lexlist ->
        let (delim, lexlist) = extract_delim lexlist in
        let (newaccum, lexlist) = parse_a empty lexlist oo 0 false in
        let newaccum =
        ( match newaccum with
            Operator ("\\right", trees) ->
              Operator 
                ( "\\left\\right", 
                  (Operator (delim, []))::trees
                ) |
            _ -> 
              Operator 
                ( "\\left\\right", 
                  [Operator (delim, []); Operator (".", []); newaccum]
                )
        ) in          
          parse_a (add accum newaccum) lexlist (limit-1) 0 br |
      "["::lexlist ->
        if brlimit = 0 then
          parse_a (add accum (Element "[")) lexlist (limit-1) 0 br
        else
          let (newaccum, lexlist) = parse_a (Operator ("[", [])) lexlist oo 0 true in
            parse_a (add accum newaccum) lexlist limit (brlimit-1) false |
      "]"::lexlist -> 
        if br then 
          (accum, lexlist) 
        else
          parse_a (add accum (Element "]")) lexlist (limit-1) brlimit false |

      lexem::lexlist ->
        try 
          let 
            (p, q) = LatDict.get lexem LatDict.commands
          in
            let (subtree, lexlist) = parse_a (Operator (lexem, [])) lexlist q p br in
              parse_a
                ( (match lexem with "^" | "_" -> backadd | _ -> add)
                    accum 
                    subtree
                 ) 
                lexlist 
                (limit-1) 0 br
        with 
          Not_found ->
            parse_a 
              (add accum (Element lexem)) lexlist (limit-1) 0 br

  let from_lexems lexems =
    let (revptree, _) = parse_a empty lexems oo 0 false in
      fix revptree

end

(* vim: set tw=96 et ts=2 sw=2: *)
