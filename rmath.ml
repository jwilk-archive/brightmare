module type UNICODE = Signatures.UNICODE
module type RENDER = Signatures.RENDER
module type T = Signatures.RMATH

module Make
  (Uni : UNICODE) 
  (Render : RENDER with module Uni = Uni) : 
  T with module Uni = Uni =
struct

  type t = 
  { rbox : Render.t; 
    baseline : int }
  
  module Uni = Uni

  let hline width =
    if width < 0 then
      raise(Invalid_argument "Rmath.Make()().hline")
    else
      { rbox = Render.make width 1 (Uni.wchar_of_int 0x2500);
        baseline = 0 }

  let vline height =
    if height < 0 then
      raise(Invalid_argument "Rmath.Make()().vline")
    else
      { rbox = Render.make 1 height (Uni.wchar_of_int 0x2502);
        baseline = (height-1)/2 }

  let width box = Render.width box.rbox
  let height box = Render.height box.rbox
  let baseline box = box.baseline

  let s str = 
    { rbox = Render.s str;
      baseline = 0 }

  let empty width height = 
    { rbox = Render.empty width height;
      baseline = 0 }

  let align dir box width =
    { rbox = Render.grow dir box.rbox width (height box);
      baseline = box.baseline }

  let join_v =
    function
    | [] -> 
        raise(Invalid_argument "Rmath()().join_v")
    | box::_ as boxes ->
        let boxes = ListEx.map (fun box -> box.rbox) boxes in
          { rbox = Render.join_v 'E' boxes;
            baseline = box.baseline }

  let join_h =
    function
    | [] -> raise(Invalid_argument "Rmath()().join_h")
    | _ as boxes ->
      let 
        maxbaseline = ListEx.max_map (fun box -> box.baseline) boxes
      in let
        boxes = 
          ListEx.map 
            ( fun box -> 
              Render.grow 
                'Q'
                box.rbox
                (width box) 
                (height box + maxbaseline - box.baseline)
            )
            boxes
      in
        { rbox = Render.join_h 'Z' boxes; 
          baseline = maxbaseline; }

  let join_top box top =
    { rbox = Render.join_v 'X' [top.rbox; box.rbox];
      baseline = (height top) + box.baseline }

  let join_bot box bot =
    { rbox = Render.join_v 'X' [box.rbox; bot.rbox];
      baseline = box.baseline }

  let join_topbot box top bot =
    { rbox = Render.join_v 'X' [top.rbox; box.rbox; bot.rbox];
      baseline = (height top) + box.baseline }

  let join_NE box top =
    { rbox = Render.join_tr box.rbox top.rbox;
      baseline = (height top) + box.baseline }

  let join_SE box bot =
    { rbox = Render.join_br box.rbox bot.rbox;
      baseline = box.baseline }

  let join_NESE box top bot =
    let w = max (width top) (width bot) in
    let 
      rtop = Render.grow 'E' top.rbox w (height top) and
      rbot = Render.grow 'E' bot.rbox w (height bot)
    in
    let rbox = 
      Render.grow 'E' box.rbox (width box + w) (height box)
    in
      { rbox = Render.join_v 'Q' [rtop; rbox; rbot];
        baseline = (height top) + box.baseline }

  let render box =
    Render.render box.rbox

  let fraclike box1 box2 =
    let separator = empty 0 1 in
      { rbox = Render.join_v 'S' [box1.rbox; separator.rbox; box2.rbox];
        baseline = height box1 }

  let frac box1 box2 =
    let width = max (width box1) (width box2) in
    let separator = hline (width+2) in
      { rbox = Render.join_v 'S' [box1.rbox; separator.rbox; box2.rbox];
        baseline = height box1 }

  let c n = Render.make 1 1 (Uni.wchar_of_int n)

  let sqrt box upbox =
    let 
      vline = vline (height box) and
      hline = hline (width box) and
      joint = c 0x250C and
      hook = c 0x2572
    in let 
      rbox = Render.join4 joint vline.rbox hline.rbox box.rbox and
      hook = Render.join_v 'Q' [upbox.rbox; hook]
    in
      { rbox = Render.join_h 'Q' [hook; rbox];
        baseline = box.baseline + 1 }

  type bracket_t = 
  | Bracket_round 
  | Bracket_square
  | Bracket_brace
  | Bracket_angle
  type delimiter_t = 
  | Delim_bracket of bool * bracket_t
  | Delim_floor of bool
  | Delim_ceil of bool
  | Delim_vert
  | Delim_doublevert

  let largedelimiter sbox kind =
    let n = height sbox in
    let n = 
      ( if n <= 1 then 
          raise(Invalid_argument "Rmath.Make()().delimiter")
        else
          max 3 n
      ) in 
    let p = (n-3)/2 in
    let q = (n-3)-p in
    let (tu, mu, bu) =
      match kind with
      | Delim_bracket (true,  Bracket_round)  -> 0x256d, 0x2502, 0x2570
      | Delim_bracket (false, Bracket_round)  -> 0x256e, 0x2502, 0x256f
      | Delim_bracket (true,  Bracket_square) -> 0x2308, 0x2502, 0x230a
      | Delim_bracket (false, Bracket_square) -> 0x2309, 0x2502, 0x230b
      | Delim_bracket (true,  Bracket_brace)  -> 0x256d, 0x007b, 0x2570
      | Delim_bracket (false, Bracket_brace)  -> 0x256e, 0x007d, 0x256f
      | Delim_bracket (true,  Bracket_angle)  -> 0x2571, 0x2329, 0x2572
      | Delim_bracket (false, Bracket_angle)  -> 0x2572, 0x232a, 0x2571
      | Delim_floor true  -> 0x2502, 0x2502, 0x2514
      | Delim_floor false -> 0x2502, 0x2502, 0x2518
      | Delim_ceil  true  -> 0x250c, 0x2502, 0x2502
      | Delim_ceil  false -> 0x2510, 0x2502, 0x2502
      | Delim_vert        -> 0x2502, 0x2502, 0x2502
      | Delim_doublevert  -> 0x2551, 0x2551, 0x2551 
  in
  let
    baseline = 
      if (height sbox = 2) && (sbox.baseline = 0)
      then
        1
      else
        sbox.baseline
  in
    { rbox = Render.join_v 'Q' [c tu; (vline p).rbox; c mu; (vline q).rbox; c bu];
      baseline = baseline }

  let sum () =
    let 
      s1 = Render.make 3 1 (Uni.wchar_of_int 0x2550) and
      s2 = c 0x003e
    in
      { rbox = Render.join_v 'E' [s1; s2; s1];
        baseline = 1 }

  let prod () = 
    let
      t = c 0x2564 and v = c 0x2502
    in let
      p1 = Render.join_h 'Q' [t; c 0x2550; t] and
      p2 = Render.join_h 'Q' [v; c 0x0020; v]
    in
      { rbox = Render.join_v 'Q' [p1; p2; p2];
        baseline = 1 }
      
  let coprod () = 
    let
      t = c 0x2567 and v = c 0x2502
    in let
      p1 = Render.join_h 'Q' [t; c 0x2550; t] and
      p2 = Render.join_h 'Q' [v; c 0x0020; v]
    in
      { rbox = Render.join_v 'Q' [p2; p2; p1];
        baseline = 1 }

  let bigcap sq ch =
    let
      v = c 0x2502 and
      (l, r) = 
        match sq with
        | false -> c 0x256d, c 0x256e
        | true  -> c 0x250c, c 0x2510
    in let
      p1 = Render.join_h 'Q' [l; c 0x2500; r] and
      p2 = Render.join_h 'Q' [v; c ch;     v] and
      p3 = Render.join_h 'Q' [v; c 0x0020; v]
    in
      { rbox = Render.join_v 'Q' [p1; p2; p3];
        baseline = 1 }

  let bigcup sq ch =
    let
      v = c 0x2502 and
      (l, r) = 
        match sq with
        | false -> c 0x2570, c 0x256f
        | true  -> c 0x2514, c 0x2518
    in let
      p1 = Render.join_h 'Q' [v; c 0x0020; v] and
      p2 = Render.join_h 'Q' [v; c ch    ; v] and
      p3 = Render.join_h 'Q' [l; c 0x2500; r]
    in
      { rbox = Render.join_v 'Q' [p1; p2; p3];
        baseline = 1 }

  let bigo ch =
    let
      v = c 0x2502 and h = c 0x2500
    in let
      p1 = Render.join_h 'Q' [c 0x256d; h; c 0x256e] and
      p2 = Render.join_h 'Q' [v; c ch; v] and
      p3 = Render.join_h 'Q' [c 0x2570; h; c 0x256f]
    in
      { rbox = Render.join_v 'Q' [p1; p2; p3];
        baseline = 1 }

  let bigvee () =
    let 
      l = c 0x2572 and r = c 0x2571 and s = c 0x20
    in let
      p1 = Render.join_h 'Q' [l; s; s;  r] and
      p2 = Render.join_h 'Q' [l;  r]
    in
      { rbox = Render.join_v 'W' [Render.empty 0 1; p1; p2];
        baseline = 1 }

  let bigwedge () =
    let 
      l = c 0x2571 and  r = c 0x2572 and s = c 0x20
    in let
      p1 = Render.join_h 'Q' [l;  r] and
      p2 = Render.join_h 'Q' [l; s; s;  r]
    in
      { rbox = Render.join_v 'W' [Render.empty 0 1; p1; p2];
        baseline = 1 }

  let integral () =
    { rbox = Render.join_v 'Q' [c 0x256d; c 0x2502; c 0x256f];
      baseline = 1 }

  let ointegral () =
    { rbox = Render.join_v 'Q' [c 0x256d; c 0x25ef; c 0x256f];
      baseline = 1 }

  type ornament_t =
  | Ornament_line
  | Ornament_arrow of bool
  | Ornament_brace

  let ornament isunder sbox kind =
    let n = max 3 (width sbox) in
    let p = (n-3)/2 in
    let q = (n-3)-p in
    let (lu, mu, ru) =
      match isunder, kind with
      | _, Ornament_line          -> 0x2500, 0x2500, 0x2500
      | _, Ornament_arrow (true)  -> 0x2500, 0x2500, 0x2192
      | _, Ornament_arrow (false) -> 0x2190, 0x2500, 0x2500
      | false, Ornament_brace     -> 0x256d, 0x005e, 0x256e
      | true, Ornament_brace      -> 0x2570, 0x0076, 0x256f
    in
      { rbox = Render.join_h 'Q' [c lu; (hline p).rbox; c mu; (hline q).rbox; c ru];
        baseline = 0 }

  let underornament = ornament true

  let overornament = ornament false

end

(* vim: set tw=96 et ts=2 sw=2: *)
