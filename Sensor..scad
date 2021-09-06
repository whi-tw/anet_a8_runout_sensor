include <MCAD/bearing.scad>;
include <MCAD/triangles.scad>;
use <MCAD/regular_shapes.scad>;

// general friction fit tolerance (n/100)
friction_tolerance=20; // [100]
friction_tol = friction_tolerance/100;

/* [Rendering] */
which = "base"; // ["base","slider", "lid", "tube cut jig"]

/* [Dev] */
draw_box = true;
draw_lid = false;
draw_bearings = true;
// slice height (n/100)
slice_z= 2000; //[2000]
s_z = slice_z/100;

/* [Hidden] */
$fn=100;
size = [47.025,30,12];
box_size = size+[0,0,0.2];
wall_thickness = 2;
bearing_dim = bearingDimensions(608);
bearing_inner_tol = friction_tol;
bearing_outer_tol = 0.8;

bearing_dim_tol = bearingDimensions(608) + [-bearing_inner_tol, bearing_outer_tol,0];
bearing_standoff = 0.8;

interactive_bearing_slide_length = 2;

filament_od = 1.75;
filament_od_tol=filament_od+0.25;


tube_od = 4+friction_tol;
tube_insert_depth = 5;




dist_between_bearing_edges = 0.8;
interactive_center_x = size[0]-wall_thickness-bearing_dim_tol[1]/2-5.5+0.625;

filament_center_x = interactive_center_x+(bearing_dim[1]/2)-0.525;
tube_cutout_x = filament_center_x;
tube_stickin_length = 12;
tube_cut_angle = 50;

switch_height = 6.2;
switch_depth = 20;
switch_width = 10.8;
button_height = 2.4;
button_depth = 1.8;
button_width = 1.5;
switch_pos = [interactive_center_x-interactive_bearing_slide_length-bearing_dim[1]/2-bearing_outer_tol-switch_width-button_width, wall_thickness+1, box_size[2]-switch_height/2-bearing_dim[2]/2];



function cat(L1, L2) = [for(L=[L1, L2], a=L) a];
  
module bearing_mount() {
  union(){
    cylinder(bearing_standoff, d=bearing_dim[0]+1.4);
    translate([0,0,bearing_standoff])
      cylinder(bearing_dim[2],d=bearing_dim_tol[0]);
  }
}

module enclosure(r_which, import=false){
  
difference(){
union(){
if (!import && $preview || r_which=="base" || $preview && import && r_which=="base"){
// Shell of box
if(!$preview || draw_box){
  union(){
  difference() {
    translate([0,-4,0])
      cube(size+[0,4,0.2]);
    
    //slider cutout
    translate([
      interactive_center_x,
      size[1]/2,
      wall_thickness])
      cylinder(box_size[2]-wall_thickness+0.1, d=bearing_dim_tol[1]); // bearing cutout
    
    translate(
      [switch_width+switch_pos[0], wall_thickness,wall_thickness])
      cube([
        interactive_bearing_slide_length+bearing_dim_tol[1]/2,
        box_size[1]-wall_thickness*2,
        box_size[2]-wall_thickness+0.1]);
      
    translate([
      interactive_center_x-interactive_bearing_slide_length-0.1,
      size[1]/2-bearing_dim_tol[1]/2,
      wall_thickness])
      cube([
        interactive_bearing_slide_length,
        bearing_dim_tol[1],
        box_size[2]-wall_thickness+0.1]);
        
    //switch cutout
    translate([-0.1,wall_thickness,box_size[2]-switch_pos[2]-friction_tol])
      cube([
      switch_pos[0]+switch_width+friction_tol+0.2,
      switch_depth+friction_tol+switch_pos[1]-wall_thickness,
      20]);
      
    // last screw hole spot
    translate([6-0.6,-4.1,-0.1])
      cube([box_size[0],4,box_size[2]+0.2]);
    
      
  }
  }
}

}

if (!import && $preview || r_which=="slider" || $preview && import && r_which=="slider"){
// create interactive bearing slider
color("red")
translate([
  interactive_center_x,
  size[1]/2,
  wall_thickness+0.25]){
  union(){
    translate([0,0,size[2]-bearing_dim[2]-bearing_standoff-wall_thickness-0.25])
      bearing_mount();
    hull(){
      cylinder(size[2]-bearing_dim[2]-bearing_standoff-wall_thickness-0.25, d=bearing_dim[1]-2);
      translate([
        -interactive_bearing_slide_length-bearing_dim[1]/2-bearing_outer_tol,
        1-bearing_dim[1]/2])
      cube([
        interactive_bearing_slide_length+bearing_dim[1]/2+bearing_outer_tol,
        bearing_dim[1]-2,
        size[2]-bearing_dim[2]-bearing_standoff-wall_thickness-0.25]);
    }
    translate([
      -interactive_bearing_slide_length-bearing_dim[1]/2-bearing_outer_tol,
      wall_thickness+0.25-size[1]/2,
      size[2]-bearing_dim[2]-bearing_standoff-wall_thickness-0.25])
      cube([wall_thickness, size[1]-2*wall_thickness-0.5,size[2]-wall_thickness*2-0.2]);
    
    translate([
      -interactive_bearing_slide_length-bearing_dim[1]/2-bearing_outer_tol+wall_thickness,
      wall_thickness*2+0.25-size[1]/2,
      size[2]-bearing_dim[2]-bearing_standoff-wall_thickness-0.25])
      rotate([90,0,0])
      triangle(
        size[2]-wall_thickness*2-0.2,
        wall_thickness*4-0.2,
        wall_thickness);
    translate([
      -interactive_bearing_slide_length-bearing_dim[1]/2-bearing_outer_tol+wall_thickness,
      -0.25+size[1]/2-wall_thickness,
      size[2]-bearing_dim[2]-bearing_standoff-wall_thickness-0.25])
      rotate([90,0,0])
      triangle(
        size[2]-wall_thickness*2-0.2,
        wall_thickness*4-0.2,
        wall_thickness);
    translate([
      -interactive_bearing_slide_length-bearing_dim[1]/2-bearing_outer_tol,
      wall_thickness+0.25-size[1]/2])
      cube([
        bearing_dim[1]/2-0.25,
        size[1]-2*wall_thickness-0.57,
        size[2]-bearing_dim[2]-bearing_standoff-wall_thickness-0.25]);
        
  }
}
}
translate([
  interactive_center_x,
  size[1]/2,
  size[2]-bearing_dim[2]]){
  if($preview && !import && draw_bearings) #bearing(model="Skate");
  }
  
// lid
if (!import && $preview && draw_lid || r_which=="lid" || $preview && import && r_which=="lid"){
  color("grey")
  translate([0,-4,box_size[2]])
  difference(){
    union(){
        cube(size-[0,-4,size[2]-wall_thickness]);
        back_thick = switch_pos[0]-friction_tol;
        translate([0,2+switch_pos[1]+friction_tol*2+switch_depth/2,-switch_pos[2]]){
          for(i=[-4.725,4.725]){
            translate([0, i, 0])  
              cube([back_thick,3.4-friction_tol,switch_pos[2]]);
            }
        }

    }
    // last screw hole spot
    translate([6-0.6,-0.1,-0.1])
      cube([box_size[0],4,box_size[2]+0.2]);
    
  }
}

//end union for solids
}

/* START SUBTRACTIONS */

// filament cutout 
translate([
  filament_center_x,
  -1,
  box_size[2]-bearing_dim[2]/2]){
  rotate([-90,0,0]) cylinder(size[1]+5,d=filament_od_tol); // filament path
  translate([0,0,0]) 
    rotate([-90,0,0]) 
    cylinder(size[1]/2+1,d1=filament_od_tol*2, d2=filament_od_tol); // filament path flare
}

// tube cutout 
translate([
  tube_cutout_x,
  box_size[1]-tube_stickin_length,
  box_size[2]-bearing_dim[2]/2]){
    difference(){
      rotate([-90,0,0]) cylinder(tube_stickin_length+1,d=tube_od); // tube path
      translate([-tube_od/2,0, -tube_od/2])
        a_triangle(tube_cut_angle,tube_od,tube_od);
    }
}


//screw holes
translate([0,0,-1])
for(i=[
  [3,size[1]-3,0],
  [size[0]-3,size[1]-3,0],
  [size[0]-3,3-0.1,0],
  [3,-1,0]
  ]){
  translate(i){
    hexagon_prism(3.6,across_flats=5.5+friction_tol);
    translate([0,0,3.8])
    cylinder(size[2]+2+wall_thickness,d=3.1);
    }
}

// cut mounting holes for switch
translate(switch_pos-[-1.25-1.5,-switch_depth/2,switch_pos[2]]){
    for(i=[-4.75,4.75]){
      translate([0, i, -1]){
        hexagon_prism(3.6,across_flats=5.5+friction_tol);
        translate([0,0,switch_pos[2]-wall_thickness+0.2])
        cylinder(d=3.2,h=wall_thickness+2);
      }
      translate([0,i,switch_pos[2]]) cylinder(d=5.5,h=100); // head holes in lid
    }

}
//end difference
}

//dummy switch
if($preview && !import ) 
  color("orange", 0.6)
  translate(switch_pos+[0,0,friction_tol]){
  union(){
    //body
    clipping_offset = 1;
    difference(){
      cube([switch_width,switch_depth,switch_height]);
      translate([0,0,-clipping_offset])
        linear_extrude(switch_height+2*clipping_offset)
        polygon([
          [-clipping_offset,3.6],
          [-clipping_offset,-clipping_offset],
          [0.4,-clipping_offset],
          [0.4,3.3],
          [0,3.6]
        ]);
      translate([0,switch_depth/2,-clipping_offset])
        linear_extrude(switch_height+2*clipping_offset)
        polygon([
          [-clipping_offset,6.1/2],
          [-clipping_offset,-6.1/2],
          [0,-6.1/2],
          [0.4,-5.5/2],
          [0.4,5.5/2],
          [0,6.1/2],
          
        ]);
      translate([0,switch_depth,-clipping_offset])
        linear_extrude(switch_height+2*clipping_offset)
        polygon([
          [-clipping_offset, clipping_offset],
          [-clipping_offset, -3.6],
          [0, -3.6],
          [0.4, -3.3],
          [0.4, clipping_offset]
        ]);
      
      translate([0,switch_depth/2,0])
      for(i=[4.75,-4.75])
        translate([1.25+1.5, i,-1])
          cylinder(11, r=1.5);
      translate([switch_width-0.5,-0.1,-0.1])
        cube([0.51,10.1,switch_height+0.2]);
    }
    //button
    translate([switch_width,12.2,switch_height/2-button_height/2])
    hull(){
      cube([button_width/2,button_depth,button_height]);
      translate([button_width/2,button_depth/2])
        cylinder(button_height, d=button_depth);
    }
  }
  }

}
if(which == "tube cut jig"){
difference(){
    difference(){
      cube([tube_od*2,15,tube_od*2]);
      #translate([tube_od,-1,tube_od])
        rotate([-90,0,0]) 
        cylinder(17,d=tube_od); // tube path
        difference(){
          a_triangle(tube_cut_angle,tube_od*2,tube_od*2);
        }
      
    }
}
}
else {
  enclosure(which);
}