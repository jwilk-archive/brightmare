type t = string

val as_list : t -> char list
val ( ++ ) : t -> t -> t
val ( ** ) : int -> char -> t
val ( **! ) : int -> t -> t

val length : t -> int
val get : t -> int -> char
val make : int -> char -> t
val copy : t -> t
val sub : t -> int -> int -> t
val concat : t -> t list -> t
val iter : (char -> unit) -> t -> unit
val escaped : t -> t
val index : t -> char -> int
val rindex : t -> char -> int
val index_from : t -> int -> char -> int
val rindex_from : t -> int -> char -> int
val contains : t -> char -> bool
val contains_from : t -> int -> char -> bool
val rcontains_from : t -> int -> char -> bool
val compare: t -> t -> int

type regexp
val regexp : string -> regexp

val replace : regexp -> string -> string -> string
val replace_first : regexp -> string -> string -> string
val substitute : regexp -> (string -> string) -> string -> string
val substitute_first : regexp -> (string -> string) -> string -> string

val str_before : string -> int -> string
val str_after : string -> int -> string
val first_chars : string -> int -> string
val last_chars : string -> int -> string

