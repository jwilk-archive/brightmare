type command = char
type internal_state = A_Normal | A_Number | A_CommandBegin | A_Command | A_CommandEnd
type s = bool
type t = s * internal_state

let default = false, A_Normal

let pubstate (st, _) = st

let execute cmd (_, is) =
  match (is, cmd) with
    A_CommandBegin, '\\' ->                  false, A_CommandEnd   |
    _, '\\' ->                                true, A_CommandBegin |
    A_CommandBegin, ('A'..'Z' | 'a'..'z') -> false, A_Command      |
    A_CommandBegin, _ ->                     false, A_CommandEnd   |
    A_Command, ('A'..'Z' | 'a'..'z') ->      false, A_Command      |
    A_Command, _ ->                           true, A_Normal       |
    A_Normal, '0'..'9' ->                     true, A_Number       |
    A_Number, '0'..'9' ->                    false, A_Number       |
    _, _  ->                                  true, A_Normal

(* vim: set tw=96 et ts=2 sw=2: *)
