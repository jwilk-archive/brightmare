module type PARSE = Zz_signatures.PARSE
module type LATDICT = Zz_signatures.LATDICT

module Make 
  (LatDict : LATDICT) : 
  PARSE with type t = Parsetree.t and module LatDict = LatDict =
struct

  type t = Parsetree.t
  module LatDict = LatDict
 
  exception Parse_error
 
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
      Operator ("\\left\\right", d1::d2::trees) ->
        Operator ("\\left\\right", d1::d2::(ListEx.rev_map fix trees)) |
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
      _ -> raise(Parse_error) (* FIXME *)

  let oo = -1 (* oo + 1 == oo, thus oo = -1 *)

  let extract_delim toklist =
    match toklist with
      [] -> ".", [] |
      cand::tail ->
        if LatDict.exists cand LatDict.delimiters then
          cand, tail
        else
          ".", toklist

  let rec parse_a accum toklist limit brlimit br =
    if limit = 0 then
      (accum, toklist)
    else
    match toklist with
      [] -> (accum, toklist) |

      "}"::toklist -> (accum, toklist) |
      "{"::toklist -> 
        let (newaccum, toklist) = parse_a empty toklist oo 0 false in
          parse_a (add accum newaccum) toklist (limit-1) 0 br  |

      "\\right"::toklist ->
      (
        match accum with
          Operator ("\\left", trees) ->
            let (delim, toklist) = extract_delim toklist in
              Operator ("\\left\\right", (Element delim)::trees), toklist |
          _ ->
            parse_a 
              (add accum (Element "\\right")) toklist (limit-1) 0 br 
      ) |
      "\\left"::toklist ->
        let (delim, toklist) = extract_delim toklist in
        let (newaccum, toklist) = parse_a (Operator ("\\left", [])) toklist oo 0 false in
        let newaccum = add newaccum (Element delim) in
          parse_a (add accum newaccum) toklist (limit-1) 0 br |

      "["::toklist ->
        if brlimit = 0 then
          parse_a (add accum (Element "[")) toklist (limit-1) 0 br
        else
          let (newaccum, toklist) = parse_a (Operator ("[", [])) toklist oo 0 true in
            parse_a (add accum newaccum) toklist limit (brlimit-1) false |
      "]"::toklist -> 
        if br then 
          (accum, toklist) 
        else
          parse_a (add accum (Element "]")) toklist (limit-1) brlimit false |

      token::toklist ->
        try 
          let 
            (p, q) = LatDict.get token LatDict.commands
          in
            let (subtree, toklist) = parse_a (Operator (token, [])) toklist q p br in
              parse_a 
                ( (if token.[0] = '^' || token.[0] = '_' then backadd else add)
                    accum 
                    subtree
                 ) 
                toklist 
                (limit-1) 0 br
        with 
          Not_found ->
            parse_a 
              (add accum (Element token)) toklist (limit-1) 0 br

  let from_tokens tokens =
    let (revptree, _) = parse_a empty tokens oo 0 false in
      fix revptree

end

(* vim: set tw=96 et ts=2 sw=2: *)
