
$fn = 32;

sink_height = 82;
sink_to_wall = 105;
warmer_height = 155;
warmer_waist_height = 45;
floorprint_radius = 50;
warmer_waist_radius = 65;
sink_pipe_width = 46;
sink_to_pipe = 21;
sink_lip_diameter = 6;
platform_height = sink_height + 2;
platform_width = warmer_waist_radius * 2 + 10;
sink_lip_hold_width = sink_lip_diameter + 2;

module bottle_warmer() {
  rotate_extrude(convexity=10)
  polygon([
    [0,0],
    [floorprint_radius, 0],
    [warmer_waist_radius, warmer_waist_height],
    [floorprint_radius, warmer_height],
    [0, warmer_height]
  ]);
}

module platform() {
  module sink_lip_hold() {
    intersection() {
      translate([0, sink_lip_hold_width / 2, 0])
      cube([sink_lip_hold_width, sink_lip_hold_width, platform_width* 2], center=true);
      difference() {
        union() {
          cube([sink_lip_hold_width / 2, sink_lip_hold_width / 2, platform_width]);
          cylinder(d=sink_lip_hold_width, h=platform_width);
        }
        cylinder(d=sink_lip_diameter, h=platform_width);
      }
    }
  }

  difference() {
    union() {
      cube([
        platform_width,
        sink_to_wall,
        platform_height
      ]);
      translate([0, -sink_lip_hold_width / 2, platform_height - (sink_lip_hold_width / 2)])
        rotate([90, 0, 90])
          sink_lip_hold();
    }
    translate([platform_width / 2, sink_to_wall - warmer_waist_radius, platform_height-1])
      bottle_warmer();
  }
}

module main(){
  platform();
  // translate([platform_width / 2, sink_to_wall - warmer_waist_radius, platform_height])
  //   bottle_warmer();
}

main();
