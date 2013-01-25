(*
 * Copyright (c) 2006, 2008 Jakub Wilk <jwilk@jwilk.net>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License, version 2, as
 * published by the Free Software Foundation.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *)

type ('a, 'b) bst = 
| BST_Empty
| BST_Node of 'a * 'b * ('a,'b) bst * ('a,'b) bst

let rec bst_of_sarray_lim arr p q =
  if p > q then
    BST_Empty
  else
    let m = (p+q)/2 in
    let (k, v) = arr.(m) in
      BST_Node 
        ( k, 
          v, 
          bst_of_sarray_lim arr p (m-1), 
          bst_of_sarray_lim arr (m+1) q )

let rec bst_of_sarray arr =
  bst_of_sarray_lim arr 0 (-1 + Array.length arr)

let rec bst_of_slist lst =
  bst_of_sarray (Array.of_list lst)
  
let rec bst_of_list lst =
  bst_of_slist 
    ( List.sort
        (fun (k1, _) (k2, _) -> compare k1 k2)
        lst
    )  

let rec bst_get tree key =
  match tree with
  | BST_Empty -> raise Not_found
  | BST_Node (k, v, leftson, rightson) ->
      match compare key k with
      | 0 -> v
      | 1 -> bst_get rightson key
      | _ -> bst_get leftson  key

(* ------------------------------------------------------------------------------------------ *)
    
type ('a, 'b) t =
  ('a -> 'b)

let empty _ =
  raise Not_found
  
let make lst =
  let bst = bst_of_list lst in
    bst_get bst

let union2 dict1 dict2 key =
  try
    dict1 key
  with
    Not_found -> dict2 key

let get key dict = dict key

let exists key dict =
  try
    let _ = dict key in true
  with
    Not_found -> false

let map f dict key =
  f (dict key)

let union dicts =
  match dicts with
  | [] -> empty
  | fdict::dicts -> List.fold_left union2 fdict dicts
    
(* vim: set tw=96 et ts=2 sw=2: *)
