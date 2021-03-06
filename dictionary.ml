(*
 * Copyright © 2006-2013 Jakub Wilk <jwilk@jwilk.net>
 * SPDX-License-Identifier: MIT
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
