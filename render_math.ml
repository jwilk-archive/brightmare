open Render;;

let rbm_hline width =
  if width <= 0 then
    raise(Invalid_argument "rbm_hline")
  else
    { rb_width=width; rb_height=1; rb_lines=[String.make width '-']};;

let rbm_vline height =
  if height <= 0 then
    raise(Invalid_argument "rbm_vline")
  else
    { rb_width=1; rb_height=height; rb_lines=make height "-"};;

let rbm_frac box1 box2 =
  let width = max box1.rb_width box2.rb_width in
  let separator = rbm_hline (width+2) in
    rbx_join_v 'S' [box1; separator; box2];;

(* vim: set tw=96 et ts=2 sw=2: *)
