type wstring
type wchar
type t = wstring

val wchar_of_int : int -> wchar
val wchar_of_char : char -> wchar

val from_string : string -> wstring
val to_string : wstring -> string

val empty : wstring
val length : wstring -> int
val make : int -> wchar -> wstring
val ( ++ ) : wstring -> wstring -> wstring

(* vim: set tw=96 et ts=2 sw=2: *)
