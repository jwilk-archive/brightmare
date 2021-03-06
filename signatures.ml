(*
 * Copyright © 2006-2013 Jakub Wilk <jwilk@jwilk.net>
 * SPDX-License-Identifier: MIT
 *)

module type AUTOMATON =
sig
  type t
  type s
  type command
  val default : t
  val pubstate : t -> s
  val execute : command -> t -> t
end

module type LEX_AUTOMATON =
  AUTOMATON with
    type command = char and
    type s = bool

module type LEXSCAN =
sig
  val make : string -> string list
end

module type UNICODE =
sig
  type wstring
  type wchar
  type t = wstring
  val empty : wstring
  val length : wstring -> int
  val ( ++ ) : wstring -> wstring -> wstring
  val ( ** ) : int -> wchar -> wstring
  val wchar_of_int : int -> wchar
  val wchar_of_char : char -> wchar
  val from_string : string -> wstring
  val to_string : wstring -> string
end

module type DECORATION =
sig
  val line_begin : string
  val line_end : string
  val formula_begin : string
  val formula_end : string
end

module type SIMPLE_RENDER =
sig
  type t
  module Uni : UNICODE
  val empty : int -> int -> t
  val width : t -> int
  val height : t -> int
  val s : Uni.wstring -> t
  val render : t -> string
end

module type RENDER =
sig
  include SIMPLE_RENDER
  val make : int -> int -> Uni.wchar -> t
  val grow : char -> t -> int -> int -> t
  val join_v : char -> t list -> t
  val join_h : char -> t list -> t
  val join4 : t -> t -> t -> t -> t
  val join_tr : t -> t -> t
  val join_br : t -> t -> t
end

module type RMATH =
sig
  include SIMPLE_RENDER
  val baseline : t -> int
  val align : char -> t -> int -> t
  val join_h : t list -> t
  val join_v : t list -> t
  val join_top : t -> t -> t
  val join_bot : t -> t -> t
  val join_topbot : t -> t -> t -> t
  val join_NE : t -> t -> t
  val join_SE : t -> t -> t
  val join_NESE : t -> t -> t -> t
  val frac : t -> t -> t
  val fraclike : t -> t -> t
  val sqrt : t -> t-> t
  val sum : unit -> t
  val prod : unit -> t
  val coprod : unit -> t
  val bigcap : bool -> int -> t
  val bigcup : bool -> int -> t
  val bigo : int -> t
  val bigvee : unit -> t
  val bigwedge : unit -> t
  val integral : unit -> t
  val ointegral : unit -> t
  type bracket_t =
  | Bracket_round
  | Bracket_square
  | Bracket_brace
  | Bracket_angle
  type delimiter_t =
  | Delim_bracket of bool * bracket_t
  | Delim_floor of bool
  | Delim_ceil of bool
  | Delim_vert
  | Delim_doublevert
  val largedelimiter : t -> delimiter_t -> t
  type ornament_t =
  | Ornament_line
  | Ornament_arrow of bool
  | Ornament_brace
  val overornament : t -> ornament_t -> t
  val underornament : t -> ornament_t -> t
(* TODO: and many, many more operations... *)
end

module type DICTIONARY =
sig
  type ('a, 'b) t
  val get : 'a -> ('a, 'b) t -> 'b
  val exists : 'a -> ('a, 'b) t -> bool
  val make : ('a * 'b) list -> ('a, 'b) t
  val map : ('b -> 'c) -> ('a, 'b) t -> ('a, 'c) t
  val union : ('a, 'b) t list -> ('a, 'b) t
end

module type LATDICT =
sig
  include DICTIONARY
  val alphabets : (string, unit) t
  val delimiters : (string, int) t
  val loglikes : (string, unit) t
  val operators : (string, unit) t
  val ornaments : (string, unit) t
  val symbols : (string, int) t
  val commands : (string, int * int) t
  val environments : (string, int * int) t
  val is_alphabet : string -> bool
  val is_ornament : string -> bool
end

module type PARSE =
sig
  type t
  exception Parse_error
  val from_lexems : string list -> t
end

module type INTERPRET =
sig
  type t
  type s
  val make : t -> s
end

(* vim: set tw=96 et ts=2 sts=2 sw=2: *)
