(*
 * Copyright © 2006, 2008, 2013 Jakub Wilk <jwilk@jwilk.net>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the “Software”),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *)

module type PARSE = Signatures.PARSE
module type LATDICT = Signatures.LATDICT

module Make 
  (LatDict : LATDICT) : 
  PARSE with type t = Parsetree.t =
struct

  let ( ++ ) = StrEx.( ++ )

  type t = Parsetree.t
  module LatDict = LatDict

  exception Parse_error
  exception Internal_error
 
  open Parsetree

  let empty = Operator ("", [])

  let rec fix tree =
    match tree with
    | Element _ -> tree
    | Operator ("", [tree]) -> fix tree
    | Operator ("\\left\\right", d1::d2::trees) ->
        Operator ("\\left\\right", d1::d2::(ListEx.rev_map fix trees))
    | Operator ("_", [Operator ("^", [tree; b]); a]) ->
        Operator ("_^", [fix a; fix b; fix tree])
    | Operator ("^", [Operator ("_", [tree; b]); a]) ->
        Operator ("_^", [fix b; fix a; fix tree])
    | Operator (op, trees) -> 
        Operator (op, ListEx.rev_map fix trees)

  let rec add basetree subtree =
    match basetree with
    | Element _ -> 
        Operator ("", [subtree; basetree])
    | Operator (("&" | "\\\\" | "\\newline") as opstr, baselast::basetrees) ->
        Operator (opstr, (add baselast subtree)::basetrees)
    | Operator (opstr, basetrees) -> 
        Operator (opstr, subtree::basetrees)

  let add_nl_0 basetree subtree =
    match subtree with
    | Operator (("\\\\" | "\\newline"), subtrees) ->
      ( match basetree with
        | Operator (("\\\\" | "\\newline"), basetrees) -> 
            Operator ("\\\\", subtrees@basetrees)
        | _ -> 
            Operator("\\\\", subtrees@[basetree]) )
    | _ -> raise(Internal_error)

  let add_nl basetree subtree =
    let subtrees =
      match subtree with
      | Operator (("\\\\" | "\\newline"), subtrees) -> subtrees
      | Operator ("&", _) -> [subtree]
      | _ -> []
    in 
    match basetree with
    | Operator (("\\\\" | "\\newline"), basetrees) -> 
        Operator ("\\\\", subtrees@basetrees)
    | _ -> 
        Operator ("\\\\", subtrees@[basetree])

  let rec add_amp basetree subtree =
    let nullop = [Operator ("", [])] in
    match subtree with
    | Operator ("&", []) ->
        add_amp basetree (Operator ("&", nullop))
    | Operator ("&", subtrees) ->
      ( match basetree with
        | Operator ("&", []) -> 
            Operator ("&", subtrees@nullop)
        | Operator ("&", basetrees) -> 
            Operator ("&", subtrees@basetrees)
        | Operator (("\\\\" | "\\newline"), baselast::basetrees) ->
            Operator ("\\\\", (add_amp baselast subtree)::basetrees)
        | _ -> 
            Operator ("&", subtrees@[basetree]) )
    | _ -> 
      raise(Internal_error)

  let rec add_infix basetree subtree =
    match subtree with
    | Operator (subop, subtrees) ->
      ( match basetree with
        | Operator (("\\\\" | "\\newline" | "&") as opstr, baselast::basetrees) ->
            Operator (opstr, (add_infix baselast subtree)::basetrees)
        | Operator ("", baselast::basetrees) ->
            Operator 
            ( "", 
              Operator (subop, baselast::subtrees)::basetrees )
        | _ -> 
            Operator (subop, basetree::subtrees) )
    | _ -> raise(Internal_error)

  let oo = -1 (* oo + 1 == oo, thus oo = -1 *)

  let extract_delim lexlist =
    match lexlist with
    | [] -> ".", []
    | cand::tail ->
        if LatDict.exists cand LatDict.delimiters then
          cand, tail
        else
          ".", lexlist

  let rec flatten_lexems lexems =
    ListEx.fold
      ( fun accum lexem ->
          match lexem with
          | Operator (opstr, lexems) -> opstr ^ (flatten_lexems lexems) ^ accum
          | Element b -> b ^ accum )
      ""
      lexems

  let extract_envname lex =
    flatten_lexems [lex]

  let rec parse_a accum lexlist limit brlimit br =
    if limit = 0 then
      (accum, lexlist)
    else
    match lexlist with
    | [] -> (accum, lexlist)
    | lexem::lexlist -> 
    match lexem with
    | "}" -> (accum, lexlist)
    | "{" -> 
        let (newaccum, lexlist) = parse_a empty lexlist oo 0 false in
          parse_a (add accum newaccum) lexlist (limit-1) 0 br

    | "\\end" ->
        let (_, lexlist) = parse_a empty lexlist 1 0 false in
          (accum, lexlist)
    | "\\begin" ->
        let (envnamelex, lexlist) = parse_a empty lexlist 1 0 false in
        let envname = extract_envname envnamelex in
        let (params, lexlist) =
          if not (LatDict.exists envname LatDict.environments) then
            Operator ("", []), lexlist
          else
            let (p, q) = LatDict.get envname LatDict.environments in
              parse_a empty lexlist q p false in
        let (newaccum, lexlist) = parse_a empty lexlist oo 0 false in
          parse_a 
            (add accum (Operator ("#"^envname, [newaccum; params])))
            lexlist 
            (limit-1) 0 br

    | "\\right" ->
        let (delim, lexlist) = extract_delim lexlist in
          Operator ("\\right", [Operator (delim, []); accum]), lexlist
    | "\\left" ->
        let (delim, lexlist) = extract_delim lexlist in
        let (newaccum, lexlist) = parse_a empty lexlist oo 0 false in
        let newaccum =
        ( match newaccum with
          | Operator ("\\right", trees) ->
              Operator 
                ( "\\left\\right", 
                  (Operator (delim, []))::trees )
          | _ -> 
              Operator 
                ( "\\left\\right", 
                  [Operator (delim, []); Operator (".", []); newaccum] )
        ) in          
          parse_a 
            (add accum newaccum) 
            lexlist 
            (limit-1) 0 br

    | "[" ->
        if brlimit = 0 then
          parse_a 
            (add accum (Element "[")) 
            lexlist 
            (limit-1) 0 br
        else
          let (newaccum, lexlist) = parse_a (Operator ("[", [])) lexlist oo 0 true in
            parse_a 
              (add accum newaccum) 
              lexlist 
              limit (brlimit-1) false
    | "]" -> 
        if br then 
          (accum, lexlist) 
        else
          parse_a 
            (add accum (Element "]")) 
            lexlist 
            (limit-1) brlimit false

    | "\x00" | "\t" | "\r" | "\n" | " " ->
        if limit > 0 then
          parse_a accum lexlist limit brlimit br  
        else
          parse_a
            (add accum (Element " "))
            lexlist
            (-1) 0 br
    | _ ->
      try 
        let (p, q) = LatDict.get lexem LatDict.commands in
        let (subtree, lexlist) = parse_a (Operator (lexem, [])) lexlist q p br in
          parse_a
            ( ( match lexem with 
                | "^" | "_"   -> add_infix
                | "&"         -> add_amp
                | "\\\\"      -> add_nl 
                | "\\newline" -> add_nl 
                | _           -> add )
                accum 
                subtree ) 
            lexlist 
            (limit-1) 0 br
      with 
        Not_found ->
          parse_a 
            (add accum (Element lexem)) 
            lexlist 
            (limit-1) 0 br

  let from_lexems lexems =
    let (revptree, _) = parse_a empty lexems oo 0 false in
      fix revptree

end

(* vim: set tw=96 et ts=2 sw=2: *)
