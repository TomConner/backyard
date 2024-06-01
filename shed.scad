echo(version=version());

include <BOSL2/std.scad>


in_ft = 12;
si_sf = in_ft * in_ft;

joists_on_center = 16;
studs_on_center = 16;

shed_length = 16 * in_ft;
shed_width = 10 * in_ft;
shed_height = 7 * in_ft;

// rise per 12 unit run
shed_roof_pitch = 9; 
shed_roof_pitch_ratio = shed_roof_pitch/12;
theta = 90-atan(shed_roof_pitch_ratio);
echo("Pitch and angle: ", shed_roof_pitch, theta);
rafter_notch_rise = 3;

shed_roof_overhang = 6;

echo("Shed area: ", shed_length * shed_width / in_ft / in_ft, "sf");


stud_x = 3.5;
stud_y = 1.5;

joist_x = 5.5;
joist_y = 1.5;

plywood_width = 4 * in_ft;
plywood_length = 8 * in_ft;
plywood_thickness = 11/16;

t111_x = 4 * in_ft;
t111_y = 8 * in_ft;

gap = 3/4;

// Lumber
//
module board(wx,wy,wz) {
 cube(size=[wx,wy,wz], center=false);
}

module t111() {
}

module studs(width, height) {
  count = width / studs_on_center + 1;
  for (a=[0:count-1]) { 
    translate([0, a*studs_on_center, 0])
      board(stud_x, stud_y, height);
  }
}

module plywood(width, length, thickness) {
  translate([-thickness, 0, 0])
    board(thickness, length, width);
}

module wall(width, height) {
  studs(width, height);
    plywood(plywood_width - gap,    plywood_length - gap,         plywood_thickness);
  
  translate([0,0,             plywood_width])
    plywood(height - plywood_width, plywood_length - gap,         plywood_thickness);
  
  translate([0,plywood_length,0])
    plywood(plywood_width - gap,    width - plywood_length - gap, plywood_thickness);
  
  translate([0,plywood_length,plywood_width])
    plywood(height - plywood_width, width - plywood_length - gap, plywood_thickness);
}

module xjoist() {

}
module floor() {
  xjoist(shed_width);
}

module wall_front(width, height) {
 studs(width, height);
                                             plywood(plywood_width - gap,    plywood_length - gap,         plywood_thickness);
 translate([0,0,             plywood_width]) plywood(height - plywood_width, plywood_length - gap,         plywood_thickness);
 translate([0,plywood_length,0])             plywood(plywood_width - gap,    width - plywood_length - gap, plywood_thickness);
 translate([0,plywood_length,plywood_width]) plywood(height - plywood_width, width - plywood_length - gap, plywood_thickness);
}


module shed_roof_panel() {
 run = shed_width / 2 + shed_roof_overhang;
 rise = shed_roof_pitch * run / 12 ;
 panel_width = sqrt(run*run+rise*rise);
 echo("Rise ", shed_width, shed_length, rise, run, panel_width);
 dip = shed_roof_pitch_ratio * shed_roof_overhang;
 translate([-shed_roof_overhang,0,-dip+rafter_notch_rise])
   rotate([0,theta,0]) 
     wall(shed_length, panel_width);
}

module shed() {
  
  floor();
  /*
  translate([0,0,joist_x + plywood_thickness]) {
    // Left
    wall(shed_length, shed_height);  

    // Right
    translate([shed_width,0,0]) 
      mirror([1,0,0]) 
        wall(shed_length, shed_height);

    // Front (TODO: door)
    mirror([1,0,0])
      rotate([0,0,90])
        wall_front(shed_width, shed_height);

    // Back
    translate([0,shed_length,0])
      mirror([0,1,0])
        mirror([1,0,0])
          rotate([0,0,90])
            wall(shed_width, shed_height);

    // Left roof panel
    translate([0,0,shed_height])
      shed_roof_panel();
        
        
    // Right roof panel (mirror of left)
    translate([shed_width, 0, 0])
    mirror([1,0,0])
      translate([0,0,shed_height])
        shed_roof_panel();

    shed_sign();
  }
  */
}

module shed_sign() {
 translate([ 60, -60, 10])
 color("white", alpha=0.4) {
   cube(10, center = true);
   cylinder(r = 2, h = 12, $fn = 40);
   translate([0, 0, 12])
     rotate([90, 0, 0])
       linear_extrude(height = 2, center = true)
         text("Shed", 24, halign = "center");
   translate([0, 0, 12])
     cube([22, 1.6, 0.4], center = true);
 }
}

shed();

