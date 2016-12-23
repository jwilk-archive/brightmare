(*
 * Copyright © 2006-2013 Jakub Wilk <jwilk@jwilk.net>
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

module type UNICODE = Signatures.UNICODE
module type DECORATION = Signatures.DECORATION
module type T = Signatures.RENDER

module Make
  (Uni : UNICODE)
  (Decoration : DECORATION) :
  T with module Uni = Uni =
struct
  module Uni = Uni

  type wstring = Uni.wstring
  type wchar = Uni.wchar

  type t =
    { width: int; height: int; lines: wstring list }

  let ( ++ ) = Uni.( ++ )
  let ( ** ) = Uni.( ** )

  let s str =
    { width = Uni.length str; height=1; lines = [str] }

  let make width height chr =
    let filler = width ** chr in
      { width=width; height=height; lines=ListEx.make height filler}

  let wspace = Uni.wchar_of_char ' '

  let empty width height = make width height wspace

(* ---------------------------------------------------------------------- *)

  let width box = box.width
  let height box = box.height

(* ---------------------------------------------------------------------- *)

  let grow_h box diffwidth modfun =
    if diffwidth < 0 then
      raise(Invalid_argument "Render.Make()().grow_h")
    else
      { width=box.width+diffwidth; height=box.height;
        lines=ListEx.map modfun box.lines}

(* ---------------------------------------------------------------------- *)

  let grow_leftright box width modfun =
    let diffwidth = width-box.width in
    if diffwidth < 0 then
      raise(Invalid_argument "Render.Make()().grow_leftright")
    else
      let spacer = diffwidth ** wspace in
        grow_h box diffwidth (modfun spacer)

  let grow_right box width =
    grow_leftright box width (fun x y -> y ++ x)

  let grow_left box width =
    grow_leftright box width (fun x y -> x ++ y)

(* ---------------------------------------------------------------------- *)

  let grow_center box width =
    let diffwidth = width-box.width in
    if diffwidth < 0 then
      raise(Invalid_argument "Render.Make()().grow_center")
    else
      let lspace = diffwidth/2 in
      let rspace = diffwidth-lspace in
      let
        lspacer = lspace ** wspace and
        rspacer = rspace ** wspace
      in
        grow_h box diffwidth (fun s -> lspacer ++ s ++ rspacer)

  let grow_hmiddle = grow_center

(* ---------------------------------------------------------------------- *)

  let grow_v box diffheight modfun =
    if diffheight < 0 then
      raise(Invalid_argument "Render.Make()().grow_h")
    else
      { width=box.width; height=box.height+diffheight;
        lines=modfun box.lines}

(* ---------------------------------------------------------------------- *)

  let grow_topbottom box height modfun =
    let diffheight = height-box.height in
    if diffheight < 0 then
      raise(Invalid_argument "Render.Make()().grow_topbottom")
    else
      let spacer = ListEx.make diffheight (box.width ** wspace) in
        grow_v box diffheight (modfun spacer)

  let grow_bottom box height =
    grow_topbottom box height (fun x y -> y @ x)

  let grow_top box height =
    grow_topbottom box height (fun x y -> x @ y)

(* ---------------------------------------------------------------------- *)

  let grow_vmiddle box height =
    let diffheight = height-box.height in
    if diffheight < 0 then
      raise(Invalid_argument "Render.Make()().grow_vmiddle")
    else
      let tspace = diffheight/2 in
      let bspace = diffheight-tspace in
      let spacer = box.width ** wspace in
      let
        tspacer = ListEx.make tspace spacer and
        bspacer = ListEx.make bspace spacer
      in
        grow_v box diffheight (fun s -> tspacer @ s @ bspacer)

(* ---------------------------------------------------------------------- *)

  let grow_universal box width height wgrow hgrow =
    let box = wgrow box width in
    let box = hgrow box height in
      box

  let grow choice box width height =
    let g = grow_universal box width height in
    match choice with
    | 'Q' -> g grow_left   grow_top
    | 'W' -> g grow_center grow_top
    | 'E' -> g grow_right  grow_top
    | 'A' -> g grow_left   grow_vmiddle
    | 'S' -> g grow_center grow_vmiddle
    | 'D' -> g grow_right  grow_vmiddle
    | 'Z' -> g grow_left   grow_bottom
    | 'X' -> g grow_center grow_bottom
    | 'C' -> g grow_right  grow_bottom
    | _ -> raise(Invalid_argument "Render.Make()().grow_universal9")

  let grow_middle = grow 'S'

(* ---------------------------------------------------------------------- *)

  let grow_auto_h choice boxlist =
    let maxwidth = ListEx.fold (fun width box -> (max width box.width)) 0 boxlist in
      ListEx.map (fun box -> grow choice box maxwidth box.height) boxlist

  let grow_auto_v choice boxlist =
    let maxheight = ListEx.fold (fun height box -> (max height box.height)) 0 boxlist in
      ListEx.map (fun box -> grow choice box box.width maxheight) boxlist

(* ---------------------------------------------------------------------- *)

  let join_v choice boxlist =
    match grow_auto_h choice boxlist with
    | [] -> raise (Invalid_argument "Render.Make()().join_v")
    | head::boxlist ->
        ListEx.fold
          ( fun addbox box ->
            { width = head.width;
              height = addbox.height+box.height;
              lines = addbox.lines @ box.lines }
          )
          head
          boxlist

  let join_h choice boxlist =
    match grow_auto_v choice boxlist with
    | [] -> raise (Invalid_argument "Render.Make()().join_h")
    | head::boxlist ->
        ListEx.fold
          (fun addbox box ->
            { width=addbox.width+box.width;
              height=head.height;
              lines=ListEx.map2 (++) addbox.lines box.lines}
          )
          head
          boxlist

(* ---------------------------------------------------------------------- *)

  let join4 topleft botleft topright botright =
    let
      left  = join_v 'Z' [topleft;  botleft] and
      right = join_v 'Z' [topright; botright]
    in
      join_h 'Z' [left; right]

  let join_tr botleft topright =
    let
      topleft  = empty  botleft.width topright.height and
      botright = empty topright.width  botleft.height
    in
      join4 topleft botleft topright botright

  let join_br topleft botright =
    let
      topright = empty botright.width  topleft.height and
      botleft  = empty  topleft.width botright.height
    in
      join4 topleft botleft topright botright

(* ---------------------------------------------------------------------- *)

  let render box =
    let lines = ListEx.map Uni.to_string box.lines in
    let contents =
      ListEx.rfold
        ( fun s1 s2 ->
          Decoration.line_begin ^ s1 ^ Decoration.line_end ^ s2
        )
        lines
        ""
    in
      Decoration.formula_begin ^ contents ^ Decoration.formula_end

end

(* vim: set tw=96 et ts=2 sts=2 sw=2: *)
