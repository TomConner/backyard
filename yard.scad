echo(version=version());

include <BOSL2/std.scad>

//use <beds.scad>
use <shed.scad>

module lawn() {
  color("green", alpha=0.2)
    translate([-1000, -700, -1])
      cube([1400, 1700, 1]);
}

module patio() {
 color("lightgray")
   cube([400, 400, 1]);
}

module yard() {
  //lawn();
  translate([0,20,0])
    shed();
  translate([-600, 140, 0])
    raised_beds();
  translate([-800, -600, 1])
    patio();
  translate([-600, 3*12, 0])
    arbor();
}

yard();
wall_front();

