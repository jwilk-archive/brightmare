type renderbox

val si : Unicode.wstring -> renderbox
val make : int -> int -> Unicode.wchar -> renderbox
val empty : int -> int -> renderbox

val width : renderbox -> int
val height : renderbox -> int

val grow_custom : char -> renderbox -> int -> int -> renderbox

val join_v : char -> renderbox list -> renderbox
val join_h : char -> renderbox list -> renderbox

val join4 : renderbox -> renderbox -> renderbox -> renderbox -> renderbox
val crossjoin_tr : renderbox -> renderbox -> renderbox
val crossjoin_br : renderbox -> renderbox -> renderbox

val render_str : renderbox -> Unicode.wstring

(* vim: set tw=96 et ts=2 sw=2: *)
