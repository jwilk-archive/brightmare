include List

let fold = List.fold_left
let rfold = List.fold_right
let fold2 = List.fold_left2

let id x = x

let min_map f lst =
  match lst with
    [] -> raise(Invalid_argument "ListEx.min_map") |
    head::tail -> 
      fold 
        (fun x y -> min (f y) x) 
        (f head) 
        tail

let max_map f lst =
  match lst with
    [] -> raise(Invalid_argument "ListEx.max_map") |
    head::tail -> 
      fold 
        (fun x y -> max (f y) x) 
        (f head) 
        tail

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

(* vim: set tw=96 et ts=2 sw=2: *)
