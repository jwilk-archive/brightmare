module type UNICODE = Zz_signatures.UNICODE
module type RENDER = Zz_signatures.RENDER
module type T = Zz_signatures.RMATH

module Make
  (Uni : UNICODE) 
  (Render : RENDER with module Uni = Uni) : 
  T with module Uni = Uni =
struct

  type t = { rbox: Render.t; baseline: int }
  
  module Uni = Uni

  let hline width =
    if width <= 0 then
      raise(Invalid_argument "Rmath.rbm_hline")
    else
      { rbox = Render.make width 1 (Uni.wchar_of_int 0x2500);
        baseline = 0 }

  let vline height =
    if height <= 0 then
      raise(Invalid_argument "Rmath.rbm_vline")
    else
      { rbox = Render.make 1 height (Uni.wchar_of_int 0x2502);
        baseline = (height-1)/2 }

  let width box = Render.width box.rbox
  let height box = Render.height box.rbox

  let si str = 
    { rbox = Render.si str;
      baseline = 0 }

  let empty width height = 
    { rbox = Render.empty width height;
      baseline = 0 }

  let join_h boxes =
    let 
      maxbaseline = ListEx.max_map (fun box -> box.baseline) boxes and
      maxheight = ListEx.max_map (fun box -> height box) boxes
    in let
      boxes = 
        ListEx.map 
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
        baseline = maxbaseline; }

  let crossjoin_NE box appbox =
    { rbox = Render.crossjoin_tr box.rbox appbox.rbox;
      baseline = (height appbox) + box.baseline }

  let crossjoin_SE box appbox =
    { rbox = Render.crossjoin_br box.rbox appbox.rbox;
      baseline = box.baseline }

  let crossjoin_SW box appbox =
    { rbox = Render.crossjoin_tr appbox.rbox box.rbox;
      baseline = box.baseline }

  let crossjoin_NW box appbox =
    { rbox = Render.crossjoin_br appbox.rbox box.rbox;
      baseline = (height appbox) + box.baseline }

  let render_str box =
    Render.render_str box.rbox

  let frac box1 box2 =
    let width = max (width box1) (width box2) in
    let separator = hline (width+2) in
      { rbox = Render.join_v 'S' [box1.rbox; separator.rbox; box2.rbox];
        baseline = height box1 }

  let sqrt box upbox =
    let 
      vline = vline (height box) and
      hline = hline (width box) and
      joint = Render.make 1 1 (Uni.wchar_of_int 0x250C) and
      hook = Render.make 1 1 (Uni.wchar_of_int 0x2572)
    in let 
      rbox = Render.join4 joint vline.rbox hline.rbox box.rbox and
      hook = Render.join_v 'Q' [upbox.rbox; hook]
    in
      { rbox = Render.join_h 'Q' [hook; rbox];
        baseline = box.baseline + 1 }
 
  let integral =
    let 
      i1 = Render.make 1 1 (Uni.wchar_of_int 0x256d) and 
      i2 = Render.make 1 1 (Uni.wchar_of_int 0x2502) and
      i3 = Render.make 1 1 (Uni.wchar_of_int 0x256f) 
    in let
      rbox = Render.join_v 'Q' [i1; i2; i3] 
    in
      { rbox = rbox; baseline = 1 }

  let ointegral =
    let 
      i1 = Render.make 1 1 (Uni.wchar_of_int 0x256d) and 
      i2 = Render.make 1 1 (Uni.wchar_of_int 0x25ef) and
      i3 = Render.make 1 1 (Uni.wchar_of_int 0x256f) 
    in let
      rbox = Render.join_v 'Q' [i1; i2; i3] 
    in
      { rbox = rbox; baseline = 1 }

end

(* vim: set tw=96 et ts=2 sw=2: *)
