module AsocString = Map.Make(String);;

type 'a t = 'a AsocString.t list;;

let asoc_multi_put kv_list dict =
  List.fold_left 
    (fun dict (k, v) -> AsocString.add k v dict) 
    (AsocString.empty) 
    kv_list;;

let make kv_list = [asoc_multi_put kv_list AsocString.empty];;

let exists key = List.exists (AsocString.mem key);;

let map f = List.map (AsocString.map f);; 
(* FIXME -- implement in a better way; is it possible?! *)

let rec get key dict =
  match dict with
    [] -> raise(Not_found) |
    head::dict ->
      try
        AsocString.find key head
      with
        Not_found -> get key dict;;

let join = List.flatten;;

(* vim: set tw=96 et ts=2 sw=2: *)
