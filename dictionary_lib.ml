module AsocString = Map.Make(String);;

module type DICTIONARY_DRAFT =
  sig
    type (+'a) t
    val get : 'a t -> string -> 'a
    val exist : 'a t -> string -> bool
  end;;

module type DICTIONARY =
  sig
    include DICTIONARY_DRAFT
    val make : (string * 'a) list -> 'a t
    val map : ('a -> 'b) -> 'a t -> 'b t
   end;;

let asoc_multi_put dict kv_list =
  List.fold_left (fun dict (k, v) -> AsocString.add k v dict) (AsocString.empty) kv_list;;

module Dictionary =
  struct
    type 'a t = 'a AsocString.t
    let make kv_list = asoc_multi_put AsocString.empty kv_list
    let get dict key = AsocString.find key dict
    let exist dict key = AsocString.mem key dict
    let map = AsocString.map (* FIXME -- implement in a better way *)
  end;;

module type JOINED_DICTIONARY =
  sig
    include DICTIONARY_DRAFT
    val make : 'a Dictionary.t list -> 'a t
  end;;

let rec jdict_get lst key =
  match lst with
    [] -> raise(Not_found) |
    head::lst ->
      try
        Dictionary.get head key
      with
        Not_found -> jdict_get lst key;;

let rec jdict_exist lst key =
  match lst with
    [] -> false |
    head::lst ->
      if Dictionary.exist head key then
        true
      else
        jdict_exist lst key;;

module JoinedDictionary =
  struct
    type 'a t = 'a Dictionary.t list
    let get = jdict_get
    let exist = jdict_exist
    let make dict_list = dict_list
  end;;

(* vim: set tw=96 et ts=2 sw=2: *)
