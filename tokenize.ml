type token_state =
  TS_Normal | TS_SCommand | TS_Command;;

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
        ('^' | '_'), _ -> 
          et_fresh TS_Normal |
        ('\\' | '{' | '}' | '|' | '#' | '&' | '!' | ',' | ':' | ';'), TS_SCommand -> 
        (* FIXME *) 
          et TS_Normal "" (("\\"^hd)::toklist) |
        '\\', _ -> 
          et TS_SCommand "\\" (lasttok::toklist) |
        ('a'..'z' | 'A'..'Z'), (TS_SCommand | TS_Command) -> 
          et_append () |
        _, _ -> 
          et_fresh TS_Normal;;

let tokenize_a arr =
  List2.rev 
    (List2.filter 
      (fun s -> s <> "") 
      (extokenize arr TS_Normal "" [])
    );;

let make str =
  tokenize_a (String2.as_list str);;

(* vim: set tw=96 et ts=2 sw=2: *)
