module type UNICODE = Signatures.UNICODE
module type RENDER = Signatures.RENDER
module type T = Signatures.RMATH

module Make
  (Uni : UNICODE) 
  (Render : RENDER with module Uni = Uni) : 
  T with module Uni = Uni =
struct

  type t = { rbox: Render.t; baseline: int }
  
  module Uni = Uni

  let hline width =
    if width < 0 then
      raise(Invalid_argument "Rmath.rbm_hline")
    else
      { rbox = Render.make width 1 (Uni.wchar_of_int 0x2500);
        baseline = 0 }

  let vline height =
    if height < 0 then
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

  type bracket_t = 
    Bracket_round | 
    Bracket_square | 
    Bracket_brace | 
    Bracket_angle
  type delimiter_t = 
    Delim_bracket of bool * bracket_t | 
    Delim_floor of bool | 
    Delim_ceil of bool

  let largedelimiter sbox kind =
    let n = height sbox in
    let n = 
      ( if n<=1 then 
          raise(Invalid_argument "Rmath.delimiter")
        else if n<3 then 
          3 
        else 
          n
      ) 
    in let
      p = (n-3)/2 and
      q = -(3-n)/2
    in let (tu, mu, bu) =
      match kind with
        Delim_bracket (true,  Bracket_round) -> (0x256D, 0x2502, 0x2570) |
        Delim_bracket (false, Bracket_round) -> (0x256E, 0x2502, 0x256F) |
        Delim_bracket (true,  Bracket_square) -> (0x250C, 0x2502, 0x2514) |
        Delim_bracket (false, Bracket_square) -> (0x2510, 0x2502, 0x2518) |
        Delim_bracket (true,  Bracket_brace) -> (0x256D, 0x7B, 0x2570) |
        Delim_bracket (false, Bracket_brace) -> (0x256E, 0x7D, 0x256F) |
        Delim_bracket (true,  Bracket_angle) -> (0x2571, 0x3C, 0x2572) |
        Delim_bracket (false, Bracket_angle) -> (0x2572, 0x3E, 0x2571) |
        Delim_floor true  -> (0x2502, 0x2502, 0x2514) |
        Delim_floor false -> (0x2502, 0x2502, 0x2518) |
        Delim_ceil true  -> (0x250C, 0x2502, 0x2502) |
        Delim_ceil false -> (0x2510, 0x2502, 0x2502)
    in let
      tbox = Render.make 1 1 (Uni.wchar_of_int tu) and
      mbox = Render.make 1 1 (Uni.wchar_of_int mu) and
      bbox = Render.make 1 1 (Uni.wchar_of_int bu) and
      pbox = (vline p).rbox and
      qbox = (vline q).rbox
    in
      { rbox = Render.join_v 'Q' [tbox; pbox; mbox; qbox; bbox];
        baseline = sbox.baseline }

  let integral () =
    let 
      i1 = Render.make 1 1 (Uni.wchar_of_int 0x256d) and 
      i2 = Render.make 1 1 (Uni.wchar_of_int 0x2502) and
      i3 = Render.make 1 1 (Uni.wchar_of_int 0x256f) 
    in let
      rbox = Render.join_v 'Q' [i1; i2; i3] 
    in
      { rbox = rbox; baseline = 1 }

  let ointegral () =
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
