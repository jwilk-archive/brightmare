type rmathbox = { rmb_rbx: Render.renderbox; rmb_baseline: int }

let hline width =
  if width <= 0 then
    raise(Invalid_argument "rbm_hline")
  else
    { rmb_rbx = Render.make width 1 "-";
      rmb_baseline = 0 };;

let vline height =
  if height <= 0 then
    raise(Invalid_argument "rbm_vline")
  else
    { rmb_rbx = Render.make 1 height "|";
      rmb_baseline = 0 };;

let width box = Render.width box.rmb_rbx;;
let height box = Render.height box.rmb_rbx;;

let frac box1 box2 =
  let width = max (width box1) (height box2) in
  let separator = hline (width+2) in
    { rmb_rbx = Render.join_v 'S' [box1.rmb_rbx; separator.rmb_rbx; box2.rmb_rbx];
      rmb_baseline = 0 }

let empty width height = 
  { rmb_rbx = Render.empty width height;
    rmb_baseline = 0 };;

let si str = 
  { rmb_rbx = Render.si str;
    rmb_baseline = 0 };;

let join_h choice boxes = 
  { rmb_rbx = Render.join_h choice (List.map (function box -> box.rmb_rbx) boxes);
    rmb_baseline = 0 };;

let render_str box =
  Render.render_str box.rmb_rbx;;

(* vim: set tw=96 et ts=2 sw=2: *)
