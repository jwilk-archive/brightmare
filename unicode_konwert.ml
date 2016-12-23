(*
 * Copyright © 2006-2013 Jakub Wilk <jwilk@jwilk.net>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the “Software”),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *)

type
  wstring = string and
  wchar = string and
  t = string

let ( ** ) = StrEx.( ** )

let empty = ""

let locale_charmap =
  let s = Locale.charmap () in
    if s = "UTF-8" then
      "utf8"
    else
    try
      let ison = Scanf.sscanf s "ISO-8859-%d" (fun n -> n) in
      if (ison < 1) || (ison > 16) then
        "ascii"
      else
        Printf.sprintf "iso%d" ison
    with
      Scanf.Scan_failure _ -> "ascii"

let fetch_contents chin =
  let rec f q accum =
    try
      let nl = input_line chin in
      if not q then
        f true nl
      else
        f true (accum ^ "\n" ^ nl)
    with
      End_of_file -> accum
  in
    f false ""

let perform_filter cmdline str =
  let
    (chin, chout) = Unix.open_process cmdline and
    forget _ = ()
  in
    begin
      output_string chout str;
      close_out chout;
      let s = fetch_contents chin in
      begin
        forget (Unix.close_process (chin, chout));
        s
      end
    end

let perform_convert encfrom encto str =
    let cmdline =
      Printf.sprintf
        "if [ -x /usr/bin/konwert ]; then /usr/bin/konwert %s-%s; else cat; fi"
        encfrom
        encto
    in try
      perform_filter cmdline str
    with
      _ -> ""

let from_utf8 =
  perform_convert "utf8" locale_charmap

let id x = x

let from_string = id
let to_string = id

let wchar_of_int n =
  if n < 127 then
    1 ** char_of_int n
  else
    from_utf8 (Unicore.utf8char_of_int n)

let wchar_of_char ch =
  wchar_of_int (int_of_char ch)

let length =
  match locale_charmap with
  | "utf8" -> Unicore.utf8string_length
  | _ -> StrEx.length

let ( ** ) = StrEx.( **! )
let ( ++ ) = StrEx.( ++ )

(* vim: set tw=96 et ts=2 sts=2 sw=2: *)
