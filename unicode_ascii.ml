type 
  wstring = string and 
  wchar = string and
  t = string

let empty = ""

let id x = x

let from_string = id
let to_string = id

let locale_charmap = Locale.charmap ()

let wchar_of_int =
  match locale_charmap with
    "UTF-8" -> Unicore.utf8char_of_int |
    _ -> Unicore_convert.ascii_of_int

let wchar_of_char ch = 
  wchar_of_int (int_of_char ch)

let length =
  match locale_charmap with
    "UTF-8" -> Unicore.utf8string_length |
    _ -> StrEx.length

let ( ** ) = StrEx.( **! )
let ( ++ ) = StrEx.( ++ )

(* vim: set tw=96 et ts=2 sw=2: *)
