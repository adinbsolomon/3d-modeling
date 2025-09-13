
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

closing_hold_bar_long = 4.5;
closing_hold_bar_short = 3;
closing_hold_bar_thickness = 3;

end_wall_slope_base = closing_hold_bar_long - 0.5 * closing_hold_bar_short;

section_troop_width = 18;

module finger_access_cutout() {
  sphere(d=finger_access_cutout_diameter, $fn=128);
}

module closing_hold_bar() {
  prism([
    [0, 0],
    [0, closing_hold_bar_thickness],
    [closing_hold_bar_long, closing_hold_bar_thickness],
    [closing_hold_bar_short, 0]
  ], box_length);
}

module end_wall() {
  difference() {
    cube([box_width - wall_thickness, wall_thickness, box_height - wall_thickness]);
    translate([box_width - wall_thickness, 0, box_height - wall_thickness])
      rotate([180, 0, 180])
        prism(right_triangle(end_wall_slope_base, box_height), wall_thickness);
  }
}

module _player_box_v1() {
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
    translate([2*box_width + 2*box_height - 4 + 3*distance_between_walls - closing_hold_nub_width, wall_thickness, wall_thickness])
      closing_hold_nub();
    translate([2*box_width + 2*box_height - 4 + 3*distance_between_walls - closing_hold_nub_width, box_length - 2*wall_thickness, wall_thickness])
        closing_hold_nub();
  }
}

module main_box() {
  difference() {
    union() {
      flexibox(
        wall_length=box_length,
        wall_widths=[
          box_width - wall_thickness,
          box_height - wall_thickness,
          box_width - wall_thickness
        ],
        layer_height=layer_height,
        base_layer_count=1,
        wall_layer_count=(wall_thickness / layer_height) - 1,
        distance_between_walls=distance_between_walls
      );
      translate([0, 0, wall_thickness])
        cube([wall_thickness, box_length, box_height - wall_thickness]);
      translate([0, 0, wall_thickness])
        end_wall();
      translate([0, box_length - wall_thickness, wall_thickness])
        end_wall();
      translate([2*box_width + box_height - 3*wall_thickness + 2*distance_between_walls, box_length, wall_thickness])
        rotate([0, 0, 180])
          closing_hold_bar();
    }
    translate([0, box_length, box_height])
      rotate([180, 0, 0])
        closing_hold_bar();
  }
}

module main() {
  main_box();
  // Troop section
  translate([wall_thickness, box_length - section_troop_width - 2*wall_thickness, wall_thickness])
    cube([box_width - 2*wall_thickness, wall_thickness, _m_player_troop_length * 1.5]);
  // Dreadnought section
  translate([wall_thickness, box_length - section_troop_width - wall_thickness - _m_player_dreadnought_thickness, wall_thickness])
    cube([box_width - 2*wall_thickness, wall_thickness, _m_player_troop_length * 1.5]);
  // Marker section
  translate([wall_thickness, box_length - section_troop_width - _m_player_dreadnought_thickness - _m_player_combat_tracker_length, wall_thickness])
    cube([box_width - 2*wall_thickness, wall_thickness, _m_player_troop_length * 1.5]);
  translate([wall_thickness + 2*_m_player_combat_tracker_thickness, box_length - section_troop_width - _m_player_dreadnought_thickness - _m_player_combat_tracker_length, wall_thickness])
    cube([wall_thickness, _m_player_combat_tracker_length, 0.75 * _m_player_combat_tracker_length]);
  // Agent and Spy section
  translate([wall_thickness, box_length - section_troop_width - _m_player_dreadnought_thickness - _m_player_combat_tracker_length - 3*_m_player_agent_thickness, wall_thickness])
    cube([wall_thickness + box_width - 2*wall_thickness, wall_thickness, _m_player_troop_length*1.5]);
  translate([1.5*_m_player_spy_diameter, box_length - section_troop_width - _m_player_dreadnought_thickness - _m_player_combat_tracker_length - 3*_m_player_agent_thickness, wall_thickness])
    cube([wall_thickness, 3*_m_player_agent_thickness, 0.75*_m_player_spy_height]);
  // Family Atomics section
  translate([wall_thickness, wall_thickness, wall_thickness + 1.5*_m_player_atomics_thickness])
    cube([box_width - wall_thickness - 0.25*_m_player_tracker_diameter, box_length - section_troop_width - _m_player_dreadnought_thickness - _m_player_combat_tracker_length - 3*_m_player_agent_thickness, wall_thickness]);
}

main();
