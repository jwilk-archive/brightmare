module type UNICODE = Zz_signatures.UNICODE
module type RMATH = Zz_signatures.RMATH
module type T = Zz_signatures.PARSE

module Make 
  (Uni : UNICODE) 
  (Rmath : RMATH with type wstring = Uni.wstring and type wchar = Uni.wchar) :
  T with type rmath_t = Rmath.t

(* vim: set tw=96 et ts=2 sw=2: *)
