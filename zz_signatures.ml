module type AUTOMATON =
(* Automat skoñczony typu [t], o pocz±tkowym stanie [default], udostêpniaj±cy publicznie
 * ([pubstate]) swój stan typu [s], akceptuj±cy ([execute]) polecenia typu [command]. *)
sig
  type t
  type s
  type command
  val default : t
  val pubstate : t -> s
  val execute : command -> t -> t
end

module type LEX_AUTOMATON =
(* Automat rozpoznaj±cy koniec leksemu. Karmiony znakami, odpowiada [true], je¶li poprzednio
 * wczytany znak koñczy leksem. *)
  AUTOMATON with 
    type command = char and 
    type s = bool

module type LEXSCAN =
(* Analizator leksykalny. Rozbija napis na listê napisów-leksemów. *)
sig
  val make : string -> string list
end

module type UNICODE =
(* Biuro obs³ugi Unikodu. *)
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
      (* Konkatenacja uninapisów *)
  val ( ** ) : int -> wchar -> wstring
      (* Utworzenie uninapisu z zadanej ilo¶ci uniznaków. *)
end

module type DECORATION =
sig
  val line_begin : string
  val line_end : string
  val equation_begin : string
  val equation_end : string
end

module type SIMPLE_RENDER =
(* Ogólny renderer obrazów o typie [t] z unistringów obs³ugiwanych przez [Uni]. *)
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
(* Renderer obrazów *)
sig
  include SIMPLE_RENDER
  val make : int -> int -> Uni.wchar -> t
  (* Obraz o zadanych rozmiarach, wype³niony du¿± ilo¶ci± pojedynczych znaków *)
  val grow_custom : char -> t -> int -> int -> t
  (* [grow_custom dir w h]:
   * Rozszerza obraz do zadanych wymiarów [w]×[h], zostawiaj±c w kierunku [dir] puste miejsce.
   * Kierunek mo¿e byæ jedn± z liter:
   *   Q W E
   *   A S D
   *   Z X C
   *)
  val join_v : char -> t list -> t
  (* [join_v dir boxes]:
   * £±czy, ustawiaj±c w pionie, obrazy z listy [boxes], przy rozszerzaniu zostawiaj±c puste
   * miejsce w kierunku [dir]
   *)
  val join_h : char -> t list -> t
  (* [join_v dir boxes]:
   * £±czy, ustawiaj±c w poziomie, obrazy z listy [boxes], przy rozszerzaniu zostawiaj±c puste
   * miejsce w kierunku [dir]
   *)
  val join4 : t -> t -> t -> t -> t
  (* [join4 tl bl tr br]:
   * £±czy obrazy w nastêpuj±cy sposób:
   *  -- -- 
   * |tl|tr|
   *  -- -- 
   * |bl|br|
   *  -- --
   * Aby uzyskaæ odpowiedni efekt, rozmiary obrazów musz± do siebie pasowaæ.
   *)
  val crossjoin_tr : t -> t -> t
  (* [crossjoin_tr bl tr]:
   * Podobnie jak [join4], zostawiaj±c puste miejsca. *)
  val crossjoin_br : t -> t -> t
  (* [crossjoin_br tl br]:
   * Podobnie jak [join4], zostawiaj±c puste miejsca. *)
end

module type RMATH =
(* Renderer obrazów matematycznych. *)
sig
  include SIMPLE_RENDER
  val hline : int -> t
  val vline : int -> t
(* TODO: plus wiele operacji rysowania ograniczników (nawiasów) o dowolnych rozmiarach *)
  val join_h : t list -> t
  val crossjoin_SE : t -> t -> t
  val crossjoin_SW : t -> t -> t
  val crossjoin_NE : t -> t -> t
  val crossjoin_NW : t -> t -> t
  val frac : t -> t -> t
  val sqrt : t -> t-> t
  val integral : unit -> t
  val ointegral : unit -> t
(* TODO: plus wiele operacji rysowania du¿ych symboli (suma, kwantyfikatory, etc.) *)
(* TODO: plus jeszcze kilka innych operacji... *)
end

module type DICTIONARY =
(* S³ownik z³±czalny. *)
sig
  type 'a t
  val get : string -> 'a t -> 'a
  val exists : string -> 'a t -> bool
  val make : (string * 'a) list -> 'a t
  val map : ('a -> 'b) -> 'a t -> 'b t
  val merge : 'a t list -> 'a t
end

module type LATDICT =
(* S³owniki symboli, poleceñ, ograniczników, whatever, LaTeX-a *)
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
(* Analizator sk³adni. Analiza daje w wyniku drzewko typu [t]. *)
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

