module type UNICODE = Zz_signatures.UNICODE
module type RENDER = Zz_signatures.RENDER
module type T = Zz_signatures.RMATH

module Make
  (Uni : UNICODE) 
  (Render : RENDER with type wstring = Uni.wstring and type wchar = Uni.wchar) : 
  T with type wstring = Uni.wstring and type wchar = Uni.wchar

(* vim: set tw=96 et ts=2 sw=2: *)
