module AsocString = Map.Make(String);;

type 'b t = 'b AsocString.t;;

let empty = AsocString.empty;;

let put arr key value = AsocString.add key value arr;;

let multi_put arr kv_list =
  List.fold_left (fun arr (k, v) -> put arr k v) empty kv_list;;

let from_list kv_list =
  multi_put empty kv_list;;

let get arr key = AsocString.find key arr;;

let exist arr key = AsocString.mem key arr;;

(* vim: set tw=96 et ts=2 sw=2: *)
