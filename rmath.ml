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
      rmb_baseline = (height-1)/2 };;

let width box = Render.width box.rmb_rbx;;
let height box = Render.height box.rmb_rbx;;

let frac box1 box2 =
  let width = max (width box1) (width box2) in
  let separator = hline (width+2) in
    { rmb_rbx = Render.join_v 'S' [box1.rmb_rbx; separator.rmb_rbx; box2.rmb_rbx];
      rmb_baseline = height box1 }

let empty width height = 
  { rmb_rbx = Render.empty width height;
    rmb_baseline = 0 };;

let si str = 
  { rmb_rbx = Render.si str;
    rmb_baseline = 0 };;

let join_h boxes =
  let 
    maxbaseline = List2.max_map (fun box -> box.rmb_baseline) boxes and
    maxheight = List2.max_map (fun box -> height box) boxes
  in
  let
    boxes = 
      List.map 
        ( fun box -> 
          Render.grow_custom 
            'Q'
            box.rmb_rbx
            (width box) 
            (height box + maxbaseline - box.rmb_baseline)
        )
        boxes
  in
    { rmb_rbx = Render.join_h 'Z' boxes; 
      rmb_baseline = maxbaseline; };;

let crossjoin_NE box appbox =
  { rmb_rbx = Render.crossjoin_tr box.rmb_rbx appbox.rmb_rbx;
    rmb_baseline = (height appbox) + box.rmb_baseline };;

let crossjoin_SE box appbox =
  { rmb_rbx = Render.crossjoin_br box.rmb_rbx appbox.rmb_rbx;
    rmb_baseline = box.rmb_baseline };;

let crossjoin_SW box appbox =
  { rmb_rbx = Render.crossjoin_tr appbox.rmb_rbx box.rmb_rbx;
    rmb_baseline = box.rmb_baseline };;

let crossjoin_NW box appbox =
  { rmb_rbx = Render.crossjoin_br appbox.rmb_rbx box.rmb_rbx;
    rmb_baseline = (height appbox) + box.rmb_baseline };;

let render_str box =
  Render.render_str box.rmb_rbx;;

(* vim: set tw=96 et ts=2 sw=2: *)
