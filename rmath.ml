type t = { rbox: Render.t; baseline: int }

let hline width =
  if width <= 0 then
    raise(Invalid_argument "rbm_hline")
  else
    { rbox = Render.make width 1 (Unicode.wchar_of_int 0x2500);
      baseline = 0 };;

let vline height =
  if height <= 0 then
    raise(Invalid_argument "rbm_vline")
  else
    { rbox = Render.make 1 height (Unicode.wchar_of_int 0x2502);
      baseline = (height-1)/2 };;

let width box = Render.width box.rbox;;
let height box = Render.height box.rbox;;

let frac box1 box2 =
  let width = max (width box1) (width box2) in
  let separator = hline (width+2) in
    { rbox = Render.join_v 'S' [box1.rbox; separator.rbox; box2.rbox];
      baseline = height box1 }

let empty width height = 
  { rbox = Render.empty width height;
    baseline = 0 };;

let si str = 
  { rbox = Render.si str;
    baseline = 0 };;

let join_h boxes =
  let 
    maxbaseline = List2.max_map (fun box -> box.baseline) boxes and
    maxheight = List2.max_map (fun box -> height box) boxes
  in
  let
    boxes = 
      List2.map 
        ( fun box -> 
          Render.grow_custom 
            'Q'
            box.rbox
            (width box) 
            (height box + maxbaseline - box.baseline)
        )
        boxes
  in
    { rbox = Render.join_h 'Z' boxes; 
      baseline = maxbaseline; };;

let crossjoin_NE box appbox =
  { rbox = Render.crossjoin_tr box.rbox appbox.rbox;
    baseline = (height appbox) + box.baseline };;

let crossjoin_SE box appbox =
  { rbox = Render.crossjoin_br box.rbox appbox.rbox;
    baseline = box.baseline };;

let crossjoin_SW box appbox =
  { rbox = Render.crossjoin_tr appbox.rbox box.rbox;
    baseline = box.baseline };;

let crossjoin_NW box appbox =
  { rbox = Render.crossjoin_br appbox.rbox box.rbox;
    baseline = (height appbox) + box.baseline };;

let render_str box =
  Render.render_str box.rbox;;

(* vim: set tw=96 et ts=2 sw=2: *)
