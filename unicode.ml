type wstring = string and wchar = string
type t = wstring

let ( ++ ) = StrEx.( ++ )
let ( ** ) = StrEx.( **! )

let empty = ""

let wchar_of_int = Unicore.utf8char_of_int
let wchar_of_char = Unicore.utf8char_of_char

let from_string s =
  if Locale.charmap () = "UTF-8" then
    s
  else
    let s = StrEx.as_list s in
    let s = List.map wchar_of_char s in
      List.fold_left (++) empty s

let to_string s = s

let length = Unicore.utf8string_length

(* vim: set tw=96 et ts=2 sw=2: *)
