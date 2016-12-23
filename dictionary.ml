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

type ('a, 'b) t =
| BST_Empty
| BST_Node of 'a * 'b * ('a, 'b) t * ('a, 'b) t

let bst_empty =
  BST_Empty

let bst_single key value =
  BST_Node (key, value, bst_empty, bst_empty)

let rec bst_add nkey nvalue tree =
  match tree with
  | BST_Empty -> bst_single nkey nvalue
  | BST_Node (key, value, leftson, rightson) ->
      match compare nkey key with
      | 0 -> BST_Node (key, nvalue, leftson, rightson)
      | 1 -> BST_Node (key, value, bst_add nkey nvalue leftson, rightson)
      | _ -> BST_Node (key, value, leftson, bst_add nkey nvalue rightson)

let rec list_split accum lst curlen deslen =
  match lst with
  | [] -> raise(Failure "Dictionary.list_split")
  | mid::right ->
      if curlen >= deslen then
        (accum, mid, right)
      else
        list_split (mid::accum) right (curlen+1) deslen

let rec bst_from_list lst len tree =
  if lst = [] then
    tree
  else
    let llen=(len-1)/2 in
    let rlen=len-1-llen in
    let (left, (key, value), right) = list_split [] lst 0 llen in
    let tree = bst_add key value tree in
    let tree = bst_from_list (ListEx.rev left) llen tree in
    let tree = bst_from_list right rlen tree in
      tree

let rec bst_union atree tree =
  match atree with
  | BST_Empty -> tree
  | BST_Node (key, value, leftson, rightson) ->
      let tree = bst_union leftson  tree in
      let tree = bst_union rightson tree in
      let tree = bst_add key value tree in
        tree

let rec bst_get nkey tree =
  match tree with
  | BST_Empty -> raise(Not_found)
  | BST_Node (key, value, leftson, rightson) ->
      match compare nkey key with
        0 -> value |
        1 -> bst_get nkey leftson |
        _ -> bst_get nkey rightson

let rec bst_map f tree =
  match tree with
  | BST_Empty -> bst_empty
  | BST_Node (key, value, leftson, rightson) ->
      BST_Node (key, f value, bst_map f leftson, bst_map f rightson)

(* ------------------------------------------------------------------------------------------ *)

let make lst = bst_from_list lst (ListEx.length lst) bst_empty

let get = bst_get

let exists key dict =
  try
    let _ = get key dict in true
  with
    Not_found -> false

let map = bst_map

let union trees = ListEx.fold bst_union bst_empty trees

(* vim: set tw=96 et ts=2 sts=2 sw=2: *)
