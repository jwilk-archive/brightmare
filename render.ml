let (++) = Unicode.(++);;

type renderbox = 
  { rb_width: int; rb_height: int; rb_lines: Unicode.wstring list }

let si str =
  { rb_width = Unicode.length str; rb_height=1; rb_lines = [str] };;

let make width height chr =
  let filler = Unicode.make width chr in
    { rb_width=width; rb_height=height; rb_lines=List2.make height filler};;

let empty width height = make width height " ";;

(* ---------------------------------------------------------------------- *)

let width box = box.rb_width;;
let height box = box.rb_height;;

(* -- HORIZONTAL GROW --------------------------------------------------- *)

let grow_h box diffwidth modfun =
  if diffwidth < 0 then
    raise(Invalid_argument "grow_h")
  else
    { rb_width=box.rb_width+diffwidth; rb_height=box.rb_height;
      rb_lines=List.map modfun box.rb_lines};;

(* -- HORIZONTAL GROW, part II ------------------------------------------ *)

let grow_leftright box width modfun =
  let diffwidth = width-box.rb_width in
  if diffwidth < 0 then
    raise(Invalid_argument "grow_leftright")
  else
    let spacer = Unicode.make diffwidth " " in
      grow_h box diffwidth (modfun spacer);;

let grow_right box width =
  grow_leftright box width (fun x y -> y ++ x);;
 
let grow_left box width =
  grow_leftright box width (fun x y -> x ++ y);;

(* -- HORIZONTAL GROW, part III ----------------------------------------- *)

let grow_center box width =
  let diffwidth = width-box.rb_width in
  if diffwidth < 0 then
    raise(Invalid_argument "grow_center")
  else
    let lspace = diffwidth/2 in
    let rspace = diffwidth-lspace in
    let 
      lspacer = Unicode.make lspace " " and
      rspacer = Unicode.make rspace " "
    in
      grow_h box diffwidth (fun s -> lspacer ++ s ++ rspacer);;

let grow_hmiddle = grow_center;;

(* -- VERTICAL GROW ----------------------------------------------------- *)

let grow_v box diffheight modfun =
  if diffheight < 0 then
    raise(Invalid_argument "grow_h")
  else
    { rb_width=box.rb_width; rb_height=box.rb_height+diffheight;
      rb_lines=modfun box.rb_lines};;

(* -- VERTICAL GROW, part II -------------------------------------------- *)

let grow_topbottom box height modfun =
  let diffheight = height-box.rb_height in
  if diffheight < 0 then
    raise(Invalid_argument "grow_topbottom")
  else
    let spacer = List2.make diffheight (Unicode.make box.rb_width " ") in
      grow_v box diffheight (modfun spacer);;

let grow_bottom box height =
  grow_topbottom box height (fun x y -> y @ x);;
 
let grow_top box height =
  grow_topbottom box height (fun x y -> x @ y);;

(* -- VERTICAL GROW, part III ------------------------------------------- *)

let grow_vmiddle box height =
  let diffheight = height-box.rb_height in
  if diffheight < 0 then
    raise(Invalid_argument "grow_vmiddle")
  else
    let tspace = diffheight/2 in
    let bspace = diffheight-tspace in
    let spacer = Unicode.make box.rb_width " " in
    let 
      tspacer = List2.make tspace spacer and
      bspacer = List2.make bspace spacer
    in
      grow_v box diffheight (fun s -> tspacer @ s @ bspacer);;

(* -- UNIVERSAL GROW ---------------------------------------------------- *)

let grow_universal box width height wgrow hgrow =
  let box = wgrow box width in
  let box = hgrow box height in
    box;;

let grow_custom choice box width height =
  let grow = grow_universal box width height in
  match choice with
    'Q' -> grow grow_left   grow_top |
    'W' -> grow grow_center grow_top |
    'E' -> grow grow_right  grow_top |
    'A' -> grow grow_left   grow_vmiddle |
    'S' -> grow grow_center grow_vmiddle |
    'D' -> grow grow_right  grow_vmiddle |
    'Z' -> grow grow_left   grow_bottom |
    'X' -> grow grow_center grow_bottom |
    'C' -> grow grow_right  grow_bottom |
    _ -> raise(Invalid_argument "grow_universal9");;

let grow_middle = grow_custom 'S';;

(* -- AUTOMATIC GROW ---------------------------------------------------- *)

let grow_auto_h choice boxlist =
  let maxwidth = List.fold_left (fun width box -> (max width box.rb_width)) 0 boxlist in
    List.map (fun box -> grow_custom choice box maxwidth box.rb_height) boxlist;;

let grow_auto_v choice boxlist =
  let maxheight = List.fold_left (fun height box -> (max height box.rb_height)) 0 boxlist in
    List.map (fun box -> grow_custom choice box box.rb_width maxheight) boxlist;;

(* -- SIMPLE JOINS ------------------------------------------------------ *)

let join_v choice boxlist =
  match grow_auto_h choice boxlist with
    [] -> raise (Invalid_argument "join_v") |
    head::boxlist ->
      List.fold_left 
        (fun addbox box -> 
          { rb_width = head.rb_width; 
            rb_height = addbox.rb_height+box.rb_height; 
            rb_lines = addbox.rb_lines@box.rb_lines}
        )
        head 
        boxlist;;

let join_h choice boxlist =
  match grow_auto_v choice boxlist with
    [] -> raise (Invalid_argument "join_h") |
    head::boxlist ->
      List.fold_left 
        (fun addbox box -> 
          { rb_width=addbox.rb_width+box.rb_width; 
            rb_height=head.rb_height; 
            rb_lines=List.map2 (++) addbox.rb_lines box.rb_lines}
        )
        head 
        boxlist;;

(* -- CROSS JOINS ------------------------------------------------------- *)

let join4 topleft botleft topright botright =
  let
    left  = join_v 'Z' [topleft;  botleft] and
    right = join_v 'Z' [topright; botright]
  in
    join_h 'Z' [left; right];;

let crossjoin_tr botleft topright =
  let 
    topleft  = empty  botleft.rb_width topright.rb_height and
    botright = empty topright.rb_width  botleft.rb_height 
  in
    join4 topleft botleft topright botright;;

let crossjoin_br topleft botright =
  let 
    topright = empty botright.rb_width  topleft.rb_height and
    botleft  = empty  topleft.rb_width botright.rb_height 
  in
    join4 topleft botleft topright botright;;

(* ---------------------------------------------------------------------- *)

let render_str box =
  List.fold_right 
    (fun s1 s2 -> "\x1B[1;44m" ++ s1 ++ "\x1B[22;49m\n" ++ s2 ++ "\x1B[49m" )
    box.rb_lines 
    ""

(* vim: set tw=96 et ts=2 sw=2: *)
