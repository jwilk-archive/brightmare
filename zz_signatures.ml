module type AUTOMATON =
(* Automat sko�czony typu [t], o pocz�tkowym stanie [default], udost�pniaj�cy publicznie
 * ([pubstate]) sw�j stan typu [s], akceptuj�cy ([execute]) polecenia typu [command]. *)
sig
  type t
  type s
  type command
  val default : t
  val pubstate : t -> s
  val execute : command -> t -> t
end

module type LEX_AUTOMATON =
(* Automat rozpoznaj�cy koniec leksemu. Karmiony znakami, odpowiada [true], je�li poprzednio
 * wczytany znak ko�czy leksem. *)
  AUTOMATON with 
    type command = char and 
    type s = bool

module type LEXSCAN =
(* Analizator leksykalny. Rozbija napis na list� napis�w-leksem�w. *)
sig
  val make : string -> string list
end

module type UNICODE =
(* Biuro obs�ugi Unikodu. *)
sig
  type wstring
  type wchar
  type t = wstring
  val wchar_of_int : int -> wchar
      (* Uni-znak o zdanym kodzie *)
  val wchar_of_char : char -> wchar
      (* Konwersja znak -> uniznak *)
  val from_string : string -> wstring
      (* Konwersja napis -> uninapis *)
  val to_string : wstring -> string
      (* Konwersja uninapis -> napis *)
  val empty : wstring
  val length : wstring -> int
  val ( ++ ) : wstring -> wstring -> wstring
      (* Konkatenacja uninapis�w *)
  val ( ** ) : int -> wchar -> wstring
      (* Utworzenie uninapisu z zadanej ilo�ci uniznak�w. *)
end

module type DECORATION =
sig
  val line_begin : string
  val line_end : string
  val equation_begin : string
  val equation_end : string
end

module type SIMPLE_RENDER =
(* Og�lny renderer obraz�w o typie [t] z unistring�w obs�ugiwanych przez [Uni]. *)
sig
  type t
  module Uni : UNICODE
  val width : t -> int
  val height : t -> int
  val empty : int -> int -> t
  val si : Uni.wstring -> t
  (* Obraz zadanego napisu *)
  val render_str : t -> string
  (* Konwersja obraz -> napis *)
end

module type RENDER =
(* Renderer obraz�w *)
sig
  include SIMPLE_RENDER
  val make : int -> int -> Uni.wchar -> t
  (* Obraz o zadanych rozmiarach, wype�niony du�� ilo�ci� pojedynczych znak�w *)
  val grow_custom : char -> t -> int -> int -> t
  (* [grow_custom dir w h]:
   * Rozszerza obraz do zadanych wymiar�w [w]�[h], zostawiaj�c w kierunku [dir] puste miejsce.
   * Kierunek mo�e by� jedn� z liter:
   *   Q W E
   *   A S D
   *   Z X C
   *)
  val join_v : char -> t list -> t
  (* [join_v dir boxes]:
   * ��czy, ustawiaj�c w pionie, obrazy z listy [boxes], przy rozszerzaniu zostawiaj�c puste
   * miejsce w kierunku [dir]
   *)
  val join_h : char -> t list -> t
  (* [join_v dir boxes]:
   * ��czy, ustawiaj�c w poziomie, obrazy z listy [boxes], przy rozszerzaniu zostawiaj�c puste
   * miejsce w kierunku [dir]
   *)
  val join4 : t -> t -> t -> t -> t
  (* [join4 tl bl tr br]:
   * ��czy obrazy w nast�puj�cy spos�b:
   *  -- -- 
   * |tl|tr|
   *  -- -- 
   * |bl|br|
   *  -- --
   * Aby uzyska� odpowiedni efekt, rozmiary obraz�w musz� do siebie pasowa�.
   *)
  val crossjoin_tr : t -> t -> t
  (* [crossjoin_tr bl tr]:
   * Podobnie jak [join4], zostawiaj�c puste miejsca. *)
  val crossjoin_br : t -> t -> t
  (* [crossjoin_br tl br]:
   * Podobnie jak [join4], zostawiaj�c puste miejsca. *)
end

module type RMATH =
(* Renderer obraz�w matematycznych. *)
sig
  include SIMPLE_RENDER
  val hline : int -> t
  val vline : int -> t
(* TODO: plus wiele operacji rysowania ogranicznik�w (nawias�w) o dowolnych rozmiarach *)
  val join_h : t list -> t
  val crossjoin_SE : t -> t -> t
  val crossjoin_SW : t -> t -> t
  val crossjoin_NE : t -> t -> t
  val crossjoin_NW : t -> t -> t
  val frac : t -> t -> t
  val sqrt : t -> t-> t
  val integral : unit -> t
  val ointegral : unit -> t
(* TODO: plus wiele operacji rysowania du�ych symboli (suma, kwantyfikatory, etc.) *)
(* TODO: plus jeszcze kilka innych operacji... *)
end

module type DICTIONARY =
(* S�ownik z��czalny. *)
sig
  type 'a t
  val get : string -> 'a t -> 'a
  val exists : string -> 'a t -> bool
  val make : (string * 'a) list -> 'a t
  val map : ('a -> 'b) -> 'a t -> 'b t
  val merge : 'a t list -> 'a t
end

module type LATDICT =
(* S�owniki symboli, polece�, ogranicznik�w, whatever, LaTeX-a *)
sig
  include DICTIONARY
  val main_commands : (int * int) t
  val alphabets : unit t
  val operators : unit t
  val loglikes : unit t
  val delimiters : int t
  val allsymbols : int t
  val commands : (int * int) t
end

module type PARSE =
(* Analizator sk�adni. Analiza daje w wyniku drzewko typu [t]. *)
sig
  type t
  val from_lexems : string list -> t
end

module type INTERPRET =
(* Interpreter uzyskanego przez analizator drzewka [t]. 
 * Interpretacja daje w wyniku cokolwiek typu [s]. *)
sig
  type t
  type s
  val make : t -> s
end

(* vim: set tw=96 et ts=2 sw=2: *)

