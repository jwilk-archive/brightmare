module OrderedString =
struct
  type t = string
  let compare x y =
    if x < y then -1
    else if x > y then 1
    else 0
end ;;

module AsocString = Map.Make(OrderedString);;

type 'b t = 'b AsocString.t;;

let empty = AsocString.empty;;

let put arr key value = AsocString.add key value arr;;

let multiput arr kv_list =
  List.fold_left (fun arr (k, v) -> put arr k v) empty kv_list;;
  
let get arr key = AsocString.find key arr

(* vim: set tw=96 et ts=2 sw=2: *)
