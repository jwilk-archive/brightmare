module AsocString = Map.Make(String);;

type 'a t = 'a AsocString.t list;;

let asoc_multi_put kv_list dict =
  List2.fold_left 
    (fun dict (k, v) -> AsocString.add k v dict) 
    (AsocString.empty) 
    kv_list;;

let make kv_list = 
  [asoc_multi_put kv_list AsocString.empty];;

let exists key =
  List2.exists (AsocString.mem key);;

let map f = 
  List2.map (AsocString.map f);; 
(* FIXME -- is it possible to implement it in a better way? *)

let rec get key = 
  List2.seek (AsocString.find key);;

let join = 
  List2.flatten;;

(* vim: set tw=96 et ts=2 sw=2: *)
