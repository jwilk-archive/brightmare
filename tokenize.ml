type token_state =
  TS_Normal | TS_SCommand | TS_Command | TS_UpLow;;

let array_of_string str =
  let len = String.length str in
  let rec aos_helper lst i =
    if i < 0 then
      lst
    else
      aos_helper ((String.get str i)::lst) (i-1)
  in
    aos_helper [] (len-1);;

let rec extokenize arr state lasttok toklist =
  match arr with
    [] -> lasttok::toklist |
    head::arr ->
      let 
        et = extokenize arr and
        hd = String.make 1 head and
        nstate = (if state = TS_SCommand then TS_Command else state)
      in let
        et_append () = et nstate (lasttok^hd) toklist and
        et_fresh state = et state "" (hd::lasttok::toklist)
      in 
      match head, state with
        ('^' | '_'), _ -> et_fresh TS_UpLow |
        ('\\' | '{' | '}'), TS_SCommand -> et TS_Normal "" (("\\"^hd)::toklist) |
        '\\', _ -> et TS_SCommand "\\" (lasttok::toklist) |
        _, TS_UpLow -> et_fresh TS_Normal |
        '0'..'9', TS_Normal -> et_append () |
        '0'..'9', _ -> et TS_Normal hd (lasttok::toklist) |
        ('a'..'z' | 'A'..'Z'), _ -> et_append () |
        _, _ -> et_fresh TS_Normal;;

let tokenize_a arr =
  List.rev 
    (List.filter 
      (function s -> s <> "") 
      (extokenize arr TS_Normal "" [])
    );;

let tokenize str =
  tokenize_a (array_of_string str);;

(* vim: set tw=96 et ts=2 sw=2: *)
