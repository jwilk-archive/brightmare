module type UNICODE = Zz_signatures.UNICODE
module type T = Zz_signatures.RENDER

module Make (Uni : UNICODE) : 
  T with type wstring = Uni.wstring and type wchar = Uni.wchar

(* vim: set tw=96 et ts=2 sw=2: *)
