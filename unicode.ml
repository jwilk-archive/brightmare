type wstring = string and wchar = string
type t = wstring;;

let (++) = (^);;

let empty = "";;

let string_of_int n =
  String.make 1 (char_of_int n)

let wchar_of_int n =
  if n < 0 
  then
    raise(Invalid_argument "Unicode.wchar_of_int")
  else if n < 0x80
  then
    string_of_int n
  else if n < 0x800
  then
    string_of_int (0xC0 + (n lsr 6) land 0x1F) ++
    string_of_int (0x80 + n land 0x3F)
  else if n < 0x10000
  then
    string_of_int (0xE0 + (n lsr 12) land 0x0F) ++
    string_of_int (0x80 + (n lsr 6) land 0x3F) ++
    string_of_int (0x80 + n land 0x3F)
  else
    raise(Invalid_argument "Unicode.wchar_of_int");;

let wchar_of_char c =
  wchar_of_int (int_of_char c);;

let from_string s =
  if Locale.charmap () = "UTF-8" then
    s
  else
    let s = String2.as_list s in
    let s = List.map wchar_of_char s in
      List.fold_left (++) empty s;;

let to_string s = s;; (* FIXME or not FIXME -- that is the question *)

let length s =
  let plen = String.length s in
  let rec length_a ac i =
    if i >= plen then
      ac
    else
      let ch = int_of_char s.[i] in
      let n =
        if ch < 0x80 then 0 else
        if (ch land 0xE0) = 0xC0 then 1 else
        if (ch land 0xF0) = 0xE0 then 2 else
        if (ch land 0xF8) = 0xF0 then 3 else
        if (ch land 0xFC) = 0xF8 then 4 else
        if (ch land 0xFE) = 0xFC then 5 else 1
      in
        length_a (ac-n) (i+n+1)
  in let len = length_a plen 0 in
    if len >= 0 then
      len
    else
      raise (Failure "Unicode.length");;


let make n wch =
  if n < 0 then
    raise(Invalid_argument "Unicode.make")
  else
    let rec make_a str n =
      if n <= 0 then
        str
      else
        make_a (str ++ wch) (n-1)
    in
      make_a "" n;;

(* vim: set tw=96 et ts=2 sw=2: *)
