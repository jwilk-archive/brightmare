module type AUTOMATON =
sig
  type t
  type s
  type command
  val default : t
  val pubstate : t -> s
  val execute : command -> t -> t
end

module type TOK_AUTOMATON =
sig
  include AUTOMATON with 
    type command = char and 
    type s = bool
end

module type TOKENIZE =
sig
  val make : string -> string list
end

module type UNICODE =
sig
  type wstring
  type wchar
  type t = wstring
  val wchar_of_int : int -> wchar
  val wchar_of_char : char -> wchar
  val from_string : string -> wstring
  val to_string : wstring -> string
  val empty : wstring
  val length : wstring -> int
  val ( ++ ) : wstring -> wstring -> wstring
  val ( ** ) : int -> wchar -> wstring
end

module type DECORATION =
sig
  val line_begin : string
  val line_end : string
  val equation_begin : string
  val equation_end : string
end

module type SIMPLE_RENDER =
sig
  type t
  module Uni : UNICODE
  val width : t -> int
  val height : t -> int
  val empty : int -> int -> t
  val si : Uni.wstring -> t
  val render_str : t -> string
end

module type RENDER =
sig
  include SIMPLE_RENDER
  val make : int -> int -> Uni.wchar -> t
  val grow_custom : char -> t -> int -> int -> t
  val join_v : char -> t list -> t
  val join_h : char -> t list -> t
  val join4 : t -> t -> t -> t -> t
  val crossjoin_tr : t -> t -> t
  val crossjoin_br : t -> t -> t
end

module type RMATH =
sig
  include SIMPLE_RENDER
  val hline : int -> t
  val vline : int -> t
  val frac : t -> t -> t
  val join_h : t list -> t
  val crossjoin_SE : t -> t -> t
  val crossjoin_SW : t -> t -> t
  val crossjoin_NE : t -> t -> t
  val crossjoin_NW : t -> t -> t
end

module type PARSE =
sig
  type t
  type rmath_t
  val empty : t
  val as_rmathbox : t -> rmath_t
  val tokens_to_rmathbox : string list -> rmath_t
end

(* vim: set tw=96 et ts=2 sw=2: *)

