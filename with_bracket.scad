include <../runout_sensor/MCAD/triangles.scad>;
use <./Sensor..scad>;
$fn=60;
$fa=.5;
$fs=1;

friction_tolerance=20; // [100]
arm_thickness = 2.7;
friction_tol = friction_tolerance/100;

module carriage(){
//Import STL from Thingiverse 2770437
translate([-70,35,-10]) import("dummy/TitanAero_BRKT_Final.stl", convexity=3);
    translate([53.518,-38.785,-3])
    difference(){
        cube([14.8,25,4.5]);
        translate ([9.1,3.5,0])
            cylinder(h=4.5,r=1.6);   
        translate ([9.1,21.5,0])
            cylinder(h=4.5,r=1.6);   
    }
    translate([53.518,-17.585,-24])
        rotate([45,0,0])
        cube([3,3,30]);
}


module bracket(width, height, depth, clamp_arm_thickness, solid=false){

    module hole(length) {
        rotate([-90,0,0]) cylinder(h=length,r=1.55);
    }
    
    
    translate([0,-clamp_arm_thickness-gap-friction_tol,0]){
        difference(){
            cube(
                [depth,
                width,
                height]);
            translate([depth-5.95,-1,height-8.25])
              cube([width+1,width+2, width+20]);
            if(!solid){
            translate([0,clamp_arm_thickness,0]){
                polyhedron(
                    points=[
                        [    0,                    0, 0], //0
                        [17.65,                    0, 0], //1
                        [17.65, gap+(2*friction_tol), 0], //2
                        [    0, gap+(2*friction_tol), 0], //3
                        [    0,                    0, 30.868+friction_tol], //4
                        [17.65,                    0, 19.4565+friction_tol], //5
                        [17.65, gap+(2*friction_tol), 19.4565+friction_tol], //6
                        [    0, gap+(2*friction_tol), 30.868+friction_tol], //7
                        
                    ],
                    faces=[
                        [0,1,2,3],  // bottom
                        [4,5,1,0],  // front
                        [7,6,5,4],  // top
                        [5,6,2,1],  // right
                        [6,7,3,2],  // back
                        [7,4,0,3]   // left
                    ]
                );
            }
            translate([12.2,-2,5.4]){
                #hole(width+4);
                translate([-6.764,0,0])
                    #hole(width+4);
                translate([0,0,10])
                    #hole(width+4);
                translate([-6.764,0,10])
                    #hole(width+4);
            }
        }
        }
    }
}


tube_diameter = 4+friction_tol;
block_to_back_y = 1.1;
tube_center_from_back_y = 18.35-tube_diameter/2;
tube_center_block_y = tube_center_from_back_y - block_to_back_y;
tube_center_from_back_x = 16.62-tube_diameter/2;

gap    = 4.641;
block_width = (2 * arm_thickness)+ gap + (2 * friction_tol);

translate([5.57,-13.78,29.135]){
    union(){
      color("black") bracket(block_width,35, 17.65, arm_thickness);
      translate([-0.1,-0.23,0]){
        translate([11.8,-7.3,28]){
          rotate([180,90,0])
          color("red") triangle(15,6,2);
        }
        translate([9.8,3.1,28]){
          rotate([0,90,0])
          color("orange") triangle(15,6,2);
        }
        translate([9.8,3.13,35]){
          rotate([0,-90,90])
          color("green") triangle(9.7,12,10.44);
        }
        translate([24,-24.5,58])
          rotate([-90,0,90]){
            echo("import lid");
            enclosure("lid", true);
          }
        translate([9.8,-30,28])
        difference(){
          cube([2,5.5,34]);
          translate([-1,1.25,1.15])
          for(i=[0:4.1:30])
            translate([0,0,i])
            cube([4,2,3]);
        }
        translate([9.8,-19.1,58.1])
        
        difference(){
          cube([2,42.425-0.8,3.9]);
          translate([-1,38.625-0.8-1.25,1])
          for(i=[0:4.1:4.1*8])
            translate([0,-i,0])
            cube([4,3,2]);  
        }
      }
    }
      
    // draw tube path
    if ($preview)
      translate([tube_center_block_y,tube_center_from_back_x,0])
      #cylinder(100,d=tube_diameter);
}
//carriage();

// Import STL from Thingiverse 2228832
//#translate([-6.45,-27.631,25]) rotate([0,90,0]) import ("dummy/titan_aero_dummy.stl");
//#translate([-1463.15,-627.344, -37.85]) import ("dummy/Titan_Extruder_Dummy_v09.STL")