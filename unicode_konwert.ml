(* ====== *FIXME* ====== *FIXME* ====== *FIXME* ===== *)

type wstring = string and wchar = string
type t = wstring;;

let (++) = (^);;

let empty = "";;

let locale_charmap = 
  let s = Locale.charmap () in
    if s = "UTF-8" then
      "utf8"
    else
    try 
      let ison = Scanf.sscanf s "ISO-8859-%d" (fun n -> n) in
      if (ison <= 0) or (ison > 15) then 
        "" 
      else
        Printf.sprintf "iso%d" ison
    with
      Scanf.Scan_failure _ -> "";;
 
let wchar_of_int n =
  if n < 0 
  then
    raise(Invalid_argument "Unicode_konwert.wchar_of_int")
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
    raise(Invalid_argument "Unicode_konwert.wchar_of_int");;

let wchar_of_char c =
  wchar_of_int (int_of_char c);;

let forget _ = ();;

let perform_convert encfrom encto str =
  let cmdline = Printf.sprintf "konwert %s-%s" encfrom encto in
    let chout = Unix.open_process_out cmdline in
    let buffer = Buffer.create 16 in
    (
      output_string chout str;
(*      ( try Buffer.add_channel buffer chin 1 with End_of_file -> () ); *)
(*      forget (input_char chin); *)
      forget (Unix.close_process_out chout);
      Buffer.contents buffer
    )

let from_string =
  if locale_charmap = "" then
    raise(Failure "Unicode_konwert..from_string")
  else perform_convert locale_charmap "utf8";;
  
let to_string = 
  if locale_charmap = "" then
    raise(Failure "Unicode_konwert..to_string")
  else perform_convert "utf8" locale_charmap;;
 
let length s =
  String2.length (to_string s);;

let make n wch =
  if n < 0 then
    raise(Invalid_argument "Unicode_konwert.make")
  else
    let rec make_a str n =
      if n <= 0 then
        str
      else
        make_a (str ++ wch) (n-1)
    in
      make_a "" n;;

(* vim: set tw=96 et ts=2 sw=2: *)
