open String;;

let as_list str =
  let len = length str in
  let rec los_helper lst i =
    if i < 0 then
      lst
    else
      los_helper ((get str i)::lst) (i-1)
  in
    los_helper [] (len-1)

include String

(* vim: set tw=96 et ts=2 sw=2: *)
