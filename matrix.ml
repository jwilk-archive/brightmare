(*
 * Copyright (c) 2006, 2008 Jakub Wilk <ubanus@users.sf.net>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License, version 2, as
 * published by the Free Software Foundation.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *)

type 'a t = 
{ up : bool;
  width : int;
  height : int;
  default : 'a;
  lines : (int * 'a list) list }

let make e = 
  { up = true;
    width = 0;
    height = 0;
    default = e;
    lines = [] }

let width { width = w } = w
let height { height = h } = h

let empty_row =
  0, []

let append_row mat =
  { up = false;
    width = mat.width;
    height = mat.height + 1;
    default = mat.default;
    lines = empty_row::mat.lines }

let append mat e =
  match mat.lines with
  | [] -> 
      { up = false;
        width = 1;
        height = 1;
        default = mat.default;
        lines = [(1, [e])] }
  | (lw, ll)::tail ->
      let (lw, ll) = lw+1, e::ll in
        { up = false;
          width = max lw mat.width;
          height = mat.height;
          default = mat.default;
          lines = (lw, ll)::tail
        }

let grow mat dw dh =
  let
    desw = max mat.width dw and
    desh = max mat.height dh in
  let rec growup lst h =
    if h >= desh then
      lst
    else
      growup ((0, [])::lst) (h+1)
  in
    { up = false;
      width = desw;
      height = desh;
      default = mat.default;
      lines = growup mat.lines mat.height }

let rec fillup_row desw def (w, lst) =
  if w >= desw then
    w, lst
  else
    fillup_row desw def (w+1, def::lst)

let fillup mat =
  { up = true;
    width = mat.width;
    height = mat.height;
    default = mat.default;
    lines = ListEx.map (fillup_row mat.width mat.default) mat.lines }

let eachrow_rfold f mat a =
  if not mat.up then
    raise(Invalid_argument "Matrix.eachrow_rfold")
  else
    ListEx.rev_map
      ( fun (_, lst) ->
        ListEx.fold (fun x y -> f y x) a lst )
      mat.lines

let eachrow_fold f a mat =
  if not mat.up then
    raise(Invalid_argument "Matrix.eachrow_fold")
  else
    ListEx.rev_map
      ( fun (_, lst) ->
        ListEx.rfold (fun x y -> f y x) lst a )
      mat.lines

let split mat =
  let lst = 
    ListEx.map 
      ( function 
        | n, (head::tail as lst) -> 
            if n < mat.width then 
              mat.default, n, lst 
            else 
              head, n-1, tail
        | _ -> mat.default, 0, [] )
      mat.lines
  in let 
    (heads, tails) = 
      ListEx.rfold 
        (fun (h, n, t) (ah, at) -> h::ah, (n, t)::at)
        lst
        ([], []) 
  in
    (mat.height, heads), 
    { up = mat.up;
      width = mat.width-1;
      height = mat.height;
      default = mat.default;
      lines = tails }

let vreverse mat =
  { up = mat.up;
    width = mat.width;
    height = mat.height;
    default = mat.default;
    lines = mat.lines }

let transpose mat =
  let rec trans ah alst mat =
    if mat.width = 0 then
    { up = true;
      width = mat.height;
      height = ah;
      default = mat.default;
      lines = alst }
    else
      let nelem, mat = split mat in
        trans (ah+1) (nelem::alst) mat
  in
    vreverse (trans 0 [] mat)

let eachcol_fold f a mat =
  if not mat.up then
    raise(Invalid_argument "Matrix.eachcol_fold")
  else 
    let result = eachrow_fold f a (transpose mat) in
      ListEx.rev result

let eachcol_rfold f mat a = 
  if not mat.up then
    raise(Invalid_argument "Matrix.eachcol_rfold")
  else
    let result = eachrow_rfold f (transpose mat) a in
      ListEx.rev result

let map f mat =
  if not mat.up then
    raise(Invalid_argument "Matrix.map")
  else 
    { up = true;
      width = mat.width;
      height = mat.height;
      default = f mat.default;
      lines = ListEx.map (fun (w, lst) -> w, ListEx.map f lst) mat.lines }

let eachrow_map f mlst mat =
  if not mat.up then
    raise(Invalid_argument "Matrix.eachrow_map")
  else 
    let mlst = ListEx.rev mlst in
      { up = true;
        width = mat.width;
        height = mat.height;
        default = mat.default;
        lines = ListEx.map2 (fun m (w, lst) -> w, ListEx.map (f m) lst) mlst mat.lines }

let eachcol_map f mlst mat =
  if not mat.up then
    raise(Invalid_argument "Matrix.eachcol_map")
  else 
    let mlst = ListEx.rev mlst in
      { up = true;
        width = mat.width;
        height = mat.height;
        default = mat.default;
        lines = ListEx.map (fun (w, lst) -> w, ListEx.map2 f mlst lst) mat.lines }


(* vim: set tw=96 et ts=2 sw=2: *)
