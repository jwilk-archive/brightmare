open List;;

let make count elem =
  let rec make_helper newlist count elem =
    if count <= 0 then
      newlist
    else
      make_helper (elem::newlist) (count-1) elem
  in
    make_helper [] count elem;;

(* ---------------------------------------------------------------------- *)

type renderbox = 
  { rb_width: int; rb_height: int; rb_lines: string list }

let rbx_singleton str =
  { rb_width = String.length str; rb_height=1; rb_lines = [str] };;

let ($) = rbx_singleton;;

let rbx_hline width =
  if width <= 0 then
    raise(Invalid_argument "rbx_hline")
  else
    { rb_width=width; rb_height=1; rb_lines=[String.make width '-']};;

let rbx_vline height =
  if height <= 0 then
    raise(Invalid_argument "rbx_vline")
  else
    { rb_width=1; rb_height=height; rb_lines=make height "-"};;

let rbx_make width height chr =
  let filler = String.make width chr in
    { rb_width=width; rb_height=height; rb_lines=make height filler};;

let rbx_empty width height = rbx_make width height ' ';;

(* -- HORIZONTAL GROW --------------------------------------------------- *)

let rbx_grow_h box diffwidth modfun =
  if diffwidth < 0 then
    raise(Invalid_argument "rbx_grow_h")
  else
    { rb_width=box.rb_width+diffwidth; rb_height=box.rb_height;
      rb_lines=map modfun box.rb_lines};;

(* -- HORIZONTAL GROW, part II ------------------------------------------ *)

let rbx_grow_leftright box width modfun =
  let diffwidth = width-box.rb_width in
  if diffwidth < 0 then
    raise(Invalid_argument "rbx_grow_leftright")
  else
    let spacer = String.make diffwidth ' ' in
      rbx_grow_h box diffwidth (modfun spacer);;

let rbx_grow_right box width =
  rbx_grow_leftright box width (fun x y -> y^x);;
 
let rbx_grow_left box width =
  rbx_grow_leftright box width (fun x y -> x^y);;

(* -- HORIZONTAL GROW, part III ----------------------------------------- *)

let rbx_grow_center box width =
  let diffwidth = width-box.rb_width in
  if diffwidth < 0 then
    raise(Invalid_argument "rbx_grow_center")
  else
    let lspace = diffwidth/2 in
    let rspace = diffwidth-lspace in
    let 
      lspacer = String.make lspace ' ' and
      rspacer = String.make rspace ' '
    in
      rbx_grow_h box diffwidth (fun s -> lspacer^s^rspacer);;

let rbx_grow_hmiddle = rbx_grow_center;;

(* -- VERTICAL GROW ----------------------------------------------------- *)

let rbx_grow_v box diffheight modfun =
  if diffheight < 0 then
    raise(Invalid_argument "rbx_grow_h")
  else
    { rb_width=box.rb_width; rb_height=box.rb_height+diffheight;
      rb_lines=modfun box.rb_lines};;

(* -- VERTICAL GROW, part II -------------------------------------------- *)

let rbx_grow_topbottom box height modfun =
  let diffheight = height-box.rb_height in
  if diffheight < 0 then
    raise(Invalid_argument "rbx_grow_topbottom")
  else
    let spacer = make diffheight (String.make box.rb_width ' ') in
      rbx_grow_v box diffheight (modfun spacer);;

let rbx_grow_bottom box height =
  rbx_grow_topbottom box height (fun x y -> y @ x);;
 
let rbx_grow_top box height =
  rbx_grow_topbottom box height (fun x y -> x @ y);;

(* -- VERTICAL GROW, part III ------------------------------------------- *)

let rbx_grow_vmiddle box height =
  let diffheight = height-box.rb_height in
  if diffheight < 0 then
    raise(Invalid_argument "rbx_grow_vmiddle")
  else
    let tspace = diffheight/2 in
    let bspace = diffheight-tspace in
    let spacer = String.make box.rb_width ' ' in
    let 
      tspacer = make tspace spacer and
      bspacer = make bspace spacer
    in
      rbx_grow_v box diffheight (fun s -> tspacer @ s @ bspacer);;

(* -- UNIVERSAL GROW ---------------------------------------------------- *)

let rbx_grow_universal box width height wgrow hgrow =
  let box = wgrow box width in
  let box = hgrow box height in
    box;;

let rbx_grow_custom choice box width height =
  let grow = rbx_grow_universal box width height in
  match choice with
    'Q' -> grow rbx_grow_left   rbx_grow_top |
    'W' -> grow rbx_grow_center rbx_grow_top |
    'E' -> grow rbx_grow_right  rbx_grow_top |
    'A' -> grow rbx_grow_left   rbx_grow_vmiddle |
    'S' -> grow rbx_grow_center rbx_grow_vmiddle |
    'D' -> grow rbx_grow_right  rbx_grow_vmiddle |
    'Z' -> grow rbx_grow_left   rbx_grow_bottom |
    'X' -> grow rbx_grow_center rbx_grow_bottom |
    'C' -> grow rbx_grow_right  rbx_grow_bottom |
    _ -> raise(Invalid_argument "rbx_grow_universal9");;

let rbx_grow_middle = rbx_grow_custom 'S';;

(* -- AUTOMATIC GROW ---------------------------------------------------- *)

let rbx_grow_auto_h choice boxlist =
  let maxwidth = fold_left (fun width box -> (max width box.rb_width)) 0 boxlist in
    map (fun box -> rbx_grow_custom choice box maxwidth box.rb_height) boxlist;;


let rbx_grow_auto_v choice boxlist =
  let maxheight = fold_left (fun height box -> (max height box.rb_height)) 0 boxlist in
    map (fun box -> rbx_grow_custom choice box box.rb_width maxheight) boxlist;;


(* -- SIMPLE JOINS ------------------------------------------------------ *)

let rbx_join_v choice boxlist =
  match rbx_grow_auto_h choice boxlist with
    [] -> raise (Invalid_argument "rbx_join_v") |
    head::boxlist ->
      fold_left 
        (fun addbox box -> 
          {rb_width=head.rb_width; 
          rb_height=addbox.rb_height+box.rb_height; 
          rb_lines=addbox.rb_lines@box.rb_lines}
        )
        head 
        boxlist;;

let ($%) b1 b2 = rbx_join_v 'S' [b1;b2];;

let rbx_join_h choice boxlist =
  match rbx_grow_auto_v choice boxlist with
    [] -> raise (Invalid_argument "rbx_join_h") |
    head::boxlist ->
      fold_left 
        (fun addbox box -> 
          {rb_width=addbox.rb_width+box.rb_width; 
          rb_height=head.rb_height; 
          rb_lines=map2 (^) addbox.rb_lines box.rb_lines}
        )
        head 
        boxlist;;

let ($+) b1 b2 = rbx_join_h 'S' [b1;b2];;

(* -- CROSS JOINS ------------------------------------------------------- *)

let rbx_4join topleft botleft topright botright =
  let
    left  = rbx_join_v 'Q' [topleft;  botleft] and
    right = rbx_join_v 'Q' [topright; botright]
  in
    rbx_join_h 'Q' [left; right];;

let rbx_crossjoin_tr botleft topright =
  let 
    topleft  = rbx_empty  botleft.rb_width topright.rb_height and
    botright = rbx_empty topright.rb_width  botleft.rb_height 
  in
    rbx_4join topleft botleft topright botright;;

let ($^) = rbx_crossjoin_tr;;

let rbx_crossjoin_br topleft botright =
  let 
    topright = rbx_empty botright.rb_width  topleft.rb_height and
    botleft  = rbx_empty  topleft.rb_width botright.rb_height 
  in
    rbx_4join topleft botleft topright botright;;

let ($-) = rbx_crossjoin_br;;


(* ---------------------------------------------------------------------- *)

let rbx_render box =
  Printf.printf "%s"
  (
    List.fold_right (fun s1 s2 -> "\x1B[1;44m"^s1^"\x1B[22;49m\n"^s2^"\x1B[49m" ) box.rb_lines ""
  );;

(* vim: set tw=96 et ts=2 sw=2: *)
