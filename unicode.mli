type wstring = string
type wchar = wstring

val wchar_of_int : int -> wchar
val wstring_of_string : string -> wstring
val length : wstring -> int
val make : int -> wchar -> wstring
val ( ++ ) : wstring -> wstring -> wstring

(* vim: set tw=96 et ts=2 sw=2: *)
