module type T = 
  Signatures.INTERPRET with type t = Parsetree.t

module Make 
  (SubInterpret : T) : 
  T with type s = SubInterpret.s =
struct
  
  type t = Parsetree.t
  type s = SubInterpret.s
  
  open Parsetree

  let rec implode args =
    match args with
      [] -> "" |
      head::[] -> head |
      head::args -> head ^ ", " ^ (implode args)

  let rec debug_rmathbox tree =
    match tree with
      Element str -> 
        "\x1B[33;1m" ^ str ^ "\x1B[0m" |
      Operator (op, treelist) ->
        let treelist = ListEx.map debug_rmathbox treelist in
        let argstr = implode treelist in
          "\x1B[35m" ^ op ^ "\x1B[0m(" ^ argstr ^ ")"

  let make tree =
    begin
      print_string ((debug_rmathbox tree) ^ "\n");
      SubInterpret.make tree
    end

end

(* vim: set tw=96 et ts=2 sw=2: *)
