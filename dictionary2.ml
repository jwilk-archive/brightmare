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

(* vim: set tw=96 et ts=2 sts=2 sw=2: *)
