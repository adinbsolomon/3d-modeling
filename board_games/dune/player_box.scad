
include <measurements.scad>
use <../flexibox.scad>
use <common/prism.scad>
use <common/triangle.scad>

layer_height = 0.15;
wall_thickness = layer_height * 5;
box_length = 0.5 * _m_board_main_length;
box_height = 20;
box_width = 37;
distance_between_walls = sqrt(2) * wall_thickness;

closing_hold_opposite_wall_stabilizer_height = 5;
closing_hold_nub_offset = 5;
closing_hold_nub_width = 3;

finger_access_cutout_diameter = 25;


module supported_wall() {
  difference() {
    union() {
        cube([
          box_width - 1,
          2 * wall_thickness,
          box_height - wall_thickness
        ]);
        translate([wall_thickness + 0.5 * (box_width - 1), 2 * wall_thickness, 0])
          rotate([0, 0, 90])
            prism(right_triangle(box_height - wall_thickness, box_height - wall_thickness), wall_thickness);
    }
    translate([0, 0, box_height - closing_hold_opposite_wall_stabilizer_height])
      opposite_wall_stabilizer();
    translate([0, wall_thickness, 0])
      closing_hold_nub();
    translate([box_width - 1 - closing_hold_nub_width, wall_thickness, 0])
      closing_hold_nub();
  }
}

module opposite_wall_stabilizer() {
  union() {
    cube([box_width - 1, wall_thickness, closing_hold_opposite_wall_stabilizer_height]);
    translate([wall_thickness, wall_thickness, 0])
      rotate([0, 0, 90])
       prism(right_triangle(closing_hold_opposite_wall_stabilizer_height, closing_hold_opposite_wall_stabilizer_height), wall_thickness);
    translate([box_width - 1, wall_thickness, 0])
      rotate([0, 0, 90])
       prism(right_triangle(closing_hold_opposite_wall_stabilizer_height, closing_hold_opposite_wall_stabilizer_height), wall_thickness);
  }
}

module closing_hold_nub() {
  cube([closing_hold_nub_width, wall_thickness, closing_hold_nub_offset]);
}

module finger_access_cutout() {
  sphere(d=finger_access_cutout_diameter, $fn=128);
}


module main() {
  union() {
    difference() {
      flexibox(
        wall_length=box_length,
        wall_widths=[
          box_width - 1,
          box_height - 1,
          box_width - 1,
          box_height - 1
        ],
        layer_height=layer_height,
        base_layer_count=1,
        wall_layer_count=(wall_thickness / layer_height) - 1,
        distance_between_walls=distance_between_walls
      );
      // Finger access cutout where outer walls meet
      translate([0, 0.5*box_length, 0])
        finger_access_cutout();
      translate([2*box_width + 2*box_height - 4 + 3*distance_between_walls, 0.5*box_length, 0])
        finger_access_cutout();
    }
    // Side walls and their supports
    translate([0, 0, wall_thickness])
      supported_wall();
    translate([box_width - 1, box_length, wall_thickness])
      rotate([0, 0, 180])
        supported_wall();
    // Opposite wall stabilizers
    translate([box_width + box_height - 2 + 2*distance_between_walls, 0, wall_thickness])
      opposite_wall_stabilizer();
    translate([box_width - 1 + box_width + box_height - 2 + 2*distance_between_walls, box_length, wall_thickness])
      rotate([0, 0, 180])
        opposite_wall_stabilizer();
    // Closing hold nubs
    translate([2*box_width + 2*box_height - 4 + 3*distance_between_walls - closing_hold_nub_width, 0, wall_thickness])
      closing_hold_nub();
    translate([2*box_width + 2*box_height - 4 + 3*distance_between_walls - closing_hold_nub_width, box_length - wall_thickness, wall_thickness])
        closing_hold_nub();
  }
}

main();

