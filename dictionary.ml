module AsocString = Map.Make(StrEx)

type 'a t = 'a AsocString.t list

let asoc_multi_put kv_list dict =
  ListEx.fold 
    (fun dict (k, v) -> AsocString.add k v dict) 
    (AsocString.empty) 
    kv_list;;

let make kv_list = 
  [asoc_multi_put kv_list AsocString.empty]

let exists key =
  ListEx.exists (AsocString.mem key)

let map f = 
  ListEx.map (AsocString.map f)
(* FIXME -- is it possible to implement it in a better way? *)

let rec get key = 
  ListEx.seek (AsocString.find key)

let join = 
  ListEx.flatten

(* vim: set tw=96 et ts=2 sw=2: *)
