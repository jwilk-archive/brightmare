module type DICTIONARY =
  sig
    type (+'a) t
    val get : 'a t -> string -> 'a
    val exist : 'a t -> string -> bool
    val make : (string * 'a) list -> 'a t
    val map : ('a -> 'b) -> 'a t -> 'b t
  end

module Dictionary : DICTIONARY

module type JOINED_DICTIONARY =
  sig
    type (+'a) t
    val get : 'a t -> string -> 'a
    val exist : 'a t -> string -> bool
    val make : 'a Dictionary.t list -> 'a t
  end

module JoinedDictionary : JOINED_DICTIONARY

(* vim: set tw=96 et ts=2 sw=2: *)
