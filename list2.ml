let length = List.length;;
let rev = List.rev;;
let flatten = List.flatten;;

let iter = List.iter;;
let map = List.map;;
let rev_map = List.rev_map;;
let fold_left = List.fold_left;;
let fold_right = List.fold_right;;

let id x = x

let min_map f lst =
  match lst with
    [] -> raise(Invalid_argument "List2.min_map") |
    head::tail -> 
      fold_left 
        (fun x y -> min (f y) x) (f head) tail

let max_map f lst =
  match lst with
    [] -> raise(Invalid_argument "List2.max_map") |
    head::tail -> 
      fold_left 
        (fun x y -> max (f y) x) (f head) tail

let max lst = max_map id lst
let min lst = min_map id lst

let make count elem =
  let rec make_helper newlist count elem =
    if count <= 0 then
      newlist
    else
      make_helper (elem::newlist) (count-1) elem
  in
    make_helper [] count elem

let rec seek f lst =
  match lst with
    [] -> raise(Not_found) |
    head::tail ->
      try
        f head
      with
        Not_found -> seek f tail;;

include List

(* vim: set tw=96 et ts=2 sw=2: *)
