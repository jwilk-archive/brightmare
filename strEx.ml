include String
include Str

let as_list str =
  let len = length str in
  let rec los_helper lst i =
    if i < 0 then
      lst
    else
      los_helper ((get str i)::lst) (i-1)
  in
    los_helper [] (len-1)

let ( ++ ) = ( ^ )


let ( **! ) n str =
  if n < 0 then
    raise(Invalid_argument "StrEx.(**!)")
  else
    let rec multi accum n =
      if n <= 0 then
        accum
      else
        multi (accum ++ str) (n-1)
    in
      multi "" n

let substitute = global_substitute
let replace = global_replace

let str_after = string_after
let str_before = string_before

let ( ** ) = make

(* vim: set tw=96 et ts=2 sw=2: *)
