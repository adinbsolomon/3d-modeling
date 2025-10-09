
include <measurements.scad>
use <../flexibox.scad>
use <common/prism.scad>
use <common/triangle.scad>
use <common/list_functions.scad>

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

end_wall_slope_base = 1.0;

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

end_wall_default_height = box_height - wall_thickness;
function end_wall_slope_base_at_height(height) = end_wall_slope_base * (height / end_wall_default_height);
module end_wall(height=end_wall_default_height, thickness=wall_thickness) {
  wall_height = min(height, end_wall_default_height);
  difference() {
    cube([box_width - 2*wall_thickness, thickness, wall_height]);
    translate([box_width - 2*wall_thickness, 0, wall_height])
      rotate([180, 0, 180])
        prism(right_triangle(end_wall_slope_base_at_height(wall_height), wall_height), thickness);
  }
}

divider_wall_default_height = 12;
module divider_wall(height=divider_wall_default_height) {
  end_wall(height);
}

module divider_walls(section_lengths, wall_heights=[]) {
  for (section_num = [1:len(section_lengths)]) {
    wall_height = len(wall_heights) == 0 ? divider_wall_default_height : wall_heights[section_num-1];
    translate_past_divider_walls(section_num-1)
      translate([0, list_sum(section_lengths, end=section_num), 0])
        divider_wall(wall_height);
  }
}

tracker_diameter = _m_player_tracker_diameter + 0.5;
tracker_array_length = _m_player_atomics_length + 6;
tracker_array_width = 2 * tracker_diameter + 1;
tracker_array_shelf_height = box_height - closing_hold_bar_thickness - 2*wall_thickness - _m_player_tracker_height - wall_thickness;
tracker_array_shelf_thickness = 3;
shelf_placement_tolerance = 0.4; // y-dimension delta
module tracker_array(shelf=true, supports=true) {
  module tracker() {
    translate([0.5*tracker_diameter, 0.5*tracker_diameter, wall_thickness])
      cylinder(d=tracker_diameter, h=_m_player_tracker_height, $fn=64);
  }
  module array() {
    translate([0, 0, tracker_array_shelf_height])
      difference() {
        translate([0, 0.5*shelf_placement_tolerance, 0])
          cube([tracker_array_width, tracker_array_length - shelf_placement_tolerance, tracker_array_shelf_thickness]);
        translate([0, 0.5*shelf_placement_tolerance, 0])
          tracker();
        translate([tracker_diameter + 1, 0.5*shelf_placement_tolerance, 0])
          tracker();
        translate([0.5 * (tracker_array_width-tracker_diameter), 0.5 * (tracker_array_length-tracker_diameter), 0])
          tracker();
        translate([0, tracker_array_length - tracker_diameter - 0.5*shelf_placement_tolerance, 0])
          tracker();
        translate([tracker_diameter + 1, tracker_array_length - tracker_diameter - 0.5*shelf_placement_tolerance, 0])
          tracker();
        // A little finger space for getting the atomics out
        translate([0.75 + 0.75 * tracker_array_width, 0.5 * (tracker_array_length-tracker_diameter), -wall_thickness])
          tracker();
      }
  }
  module supporting_features() {
    support_length = 0.5 * tracker_array_shelf_height;
    support_surface = 2;
    module support(width=wall_thickness) {
      translate([0, 0, 2*support_length])
        rotate([0, 90, 0])
          prism(right_triangle(support_length, support_surface), width);
    }
    union() {
      support(tracker_array_length);
      translate([tracker_array_width, 0, 0])
        rotate([0, 0, 90])
          support(tracker_array_width);
      translate([0, tracker_array_length, 0])
        rotate([0, 0, -90])
          support(tracker_array_width);
    }
  }
  if (shelf) {
    array();
  }
  if (supports) {
    supporting_features();
  }
}

dreadnought_base_length = _m_player_dreadnought_thickness + 1;
module dreadnought_base() {
  module dreadnought() {
    cube([
      _m_player_dreadnought_width_middle + 1,
      dreadnought_base_length,
      divider_wall_default_height
    ]);
  }
  difference() {
    end_wall(
      height=divider_wall_default_height,
      thickness=dreadnought_base_length
    );
    translate([4, 0, 0])
      dreadnought();
    translate([20, 0, 0])
      dreadnought();
  }
}

standard_stand_length = _m_player_combat_tracker_length;
standard_stand_depth = _m_player_hooks_length;
module standard_stand() {
  module flags() {
    cube([
      _m_player_flag_length,
      3.3*_m_player_flag_thickness,
      _m_player_flag_width
    ]);
  }
  module hooks() {
    union() {
      translate([
        0, 0, _m_player_hooks_width - _m_player_hooks_neck_width
      ])
        cube([
          _m_player_hooks_length,
          1.5*_m_player_hooks_thickness,
          _m_player_hooks_neck_width,
        ]);
      translate([
        _m_player_hooks_length - _m_player_hooks_body_length,
        0,
        _m_player_hooks_width - _m_player_hooks_neck_width])
        rotate([0, 90, 0])
          prism(
            right_triangle(
              _m_player_hooks_body_length - _m_player_hooks_toe_length,
              _m_player_hooks_body_length - _m_player_hooks_toe_length
            ),
            1.5*_m_player_hooks_thickness
          );
      cube([
        _m_player_hooks_toe_length,
        1.5*_m_player_hooks_thickness,
        _m_player_hooks_width
      ]);
    }
  }
  difference() {
    // cube([
    //   standard_stand_depth,
    //   standard_stand_length,
    //   0.75 * _m_player_combat_tracker_length
    // ]);
    end_wall(
      height=divider_wall_default_height,
      thickness=standard_stand_length
    );
    translate([
      box_width - 3*wall_thickness - _m_player_flag_length - end_wall_slope_base_at_height(divider_wall_default_height), 2, 0
    ])
      flags();
    translate([
      box_width - 3*wall_thickness - _m_player_hooks_length - end_wall_slope_base_at_height(divider_wall_default_height),
      5 + 3*_m_player_flag_thickness,
      0
    ])
      hooks();
    cube([
      box_width - 4*wall_thickness - _m_player_hooks_length - end_wall_slope_base_at_height(divider_wall_default_height),
      standard_stand_length,
      divider_wall_default_height
    ]);
  }
}

// Merging the Dreadnought Base and the Standard Stand
dreadnought_thickness = _m_player_dreadnought_thickness + 1;
dreadnought_width = _m_player_dreadnought_width_middle + 1;
dreadnought_foot_width = 0.5 * (_m_player_dreadnought_width_bottom - _m_player_dreadnought_width_middle);
flags_thickness = 3.3*_m_player_flag_thickness;
flags_width = _m_player_flag_length + 1;
hooks_thickness = 1.5*_m_player_hooks_thickness;
combat_tracker_length = 1.1 * _m_player_combat_tracker_length;
dreadnought_bay_length = dreadnought_thickness + flags_thickness + hooks_thickness + 2 * wall_thickness;
dreadnought_bay_width = box_width - 2*wall_thickness - end_wall_slope_base_at_height(divider_wall_default_height);
module dreadnought_bay() {
  module dreadnought() {
    cube([
      dreadnought_width,
      dreadnought_thickness,
      divider_wall_default_height
    ]);
  }
  module flags() {
    cube([
      flags_width,
      flags_thickness,
      _m_player_flag_width
    ]);
  }
  module hooks() {
    union() {
      translate([
        0, 0, _m_player_hooks_width - _m_player_hooks_neck_width
      ])
        cube([
          _m_player_hooks_length,
          hooks_thickness,
          _m_player_hooks_neck_width,
        ]);
      translate([
        _m_player_hooks_length - _m_player_hooks_body_length,
        0,
        _m_player_hooks_width - _m_player_hooks_neck_width])
        rotate([0, 90, 0])
          prism(
            right_triangle(
              _m_player_hooks_body_length - _m_player_hooks_toe_length,
              _m_player_hooks_body_length - _m_player_hooks_toe_length
            ),
            hooks_thickness
          );
      cube([
        _m_player_hooks_toe_length,
        hooks_thickness,
        _m_player_hooks_width
      ]);
    }
  }
  module combat_tracker() {
    cube([
      2 * _m_player_combat_tracker_thickness,
      combat_tracker_length,
      divider_wall_default_height
    ]);
  }
  difference() {
    end_wall(
      height=divider_wall_default_height,
      thickness=dreadnought_bay_length
    );
    translate([ 
      dreadnought_bay_width - flags_width - wall_thickness, 0, 0
    ])
      flags();
    translate([
      dreadnought_bay_width - _m_player_hooks_length - wall_thickness,
      flags_thickness + wall_thickness,
      0
    ])
      hooks();
    translate([
      dreadnought_bay_width - dreadnought_width - wall_thickness - dreadnought_foot_width,
      flags_thickness + hooks_thickness + 2*wall_thickness,
      0
    ])
      dreadnought();
    translate([
      dreadnought_bay_width - 2*dreadnought_width - wall_thickness - 2*dreadnought_foot_width - 2,
      flags_thickness + hooks_thickness + 2*wall_thickness,
      0
    ])
      dreadnought();
    translate([0, 0.5 * (dreadnought_bay_length - combat_tracker_length), 0])
      combat_tracker();
  }
}

safe_house_length = 3 * _m_player_agent_thickness + 3;
module safe_house() {
  module footrest() {
    intersection() {
      end_wall(
        height=_m_player_agent_forearm_length,
        thickness=safe_house_length
      );
      translate([box_width - 2*wall_thickness - _m_player_agent_leg_length, 0, 0])
        cube([
          _m_player_agent_leg_length,
          safe_house_length,
          _m_player_agent_forearm_length
        ]);
    }
  }
  spy_negative_diameter = _m_player_spy_diameter + 1.0;
  module spy_stand() {
    // I'd like to have the spies line up with the center of the agents...
    spy_y_centering = safe_house_length / 3 / 2;
    module spy(spy_num=0) {
      translate([
        0.5*spy_negative_diameter,
        spy_y_centering + spy_num*_m_player_agent_thickness,
        box_height - wall_thickness - closing_hold_bar_thickness - _m_player_spy_height
      ])
        cylinder(d=spy_negative_diameter, h=_m_player_spy_height, $fn=64);
    }
    difference() {
      cube([
        spy_negative_diameter - 0.5,
        safe_house_length,
        divider_wall_default_height
      ]);
      spy(0);
      spy(1);
      spy(2); 
    }
  }
  footrest();
  spy_stand();
}

module translate_into_box(x_delta=0, y_delta=0, z_delta=0) {
  translate([wall_thickness+x_delta, wall_thickness+y_delta, wall_thickness+z_delta]) children();
}

module translate_past_divider_walls(number_of_walls) {
  translate([0, number_of_walls * wall_thickness, 0]) children();
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

module _player_box_v2() {
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
        translate([wall_thickness, 0, wall_thickness])
          end_wall();
        translate([wall_thickness, box_length - wall_thickness, wall_thickness])
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
    cube([wall_thickness + box_width - 3*wall_thickness, wall_thickness, _m_player_troop_length*1.5]);
  translate([1.5*_m_player_spy_diameter, box_length - section_troop_width - _m_player_dreadnought_thickness - _m_player_combat_tracker_length - 3*_m_player_agent_thickness, wall_thickness])
    cube([wall_thickness, 3*_m_player_agent_thickness, 0.75*_m_player_spy_height]);
  // Family Atomics section
  translate([wall_thickness, wall_thickness, wall_thickness + 1.5*_m_player_atomics_thickness])
    cube([box_width - wall_thickness - 0.25*_m_player_tracker_diameter, box_length - section_troop_width - _m_player_dreadnought_thickness - _m_player_combat_tracker_length - 3*_m_player_agent_thickness, wall_thickness]);
}

module _player_box_v3(include_shelf=true) {
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
        translate_into_box(y_delta=-wall_thickness)
          end_wall();
        translate([wall_thickness, box_length - wall_thickness, wall_thickness])
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

  main_box();
  translate_into_box()
    divider_walls([
        tracker_array_length,
        safe_house_length,
        dreadnought_bay_length
      ], [
        tracker_array_shelf_height + tracker_array_shelf_thickness,
        divider_wall_default_height,
        divider_wall_default_height
      ]
    );
  translate_into_box() {
    // Tracker Array
    tracker_array(shelf=include_shelf, supports=true);
    // Safe House
    translate_past_divider_walls(1)
      translate([0, tracker_array_length, 0])
        safe_house();
    // Dreadnought Bay
    translate_past_divider_walls(2)
      translate([
        0,
        tracker_array_length + safe_house_length,
        0
      ])
        dreadnought_bay();
    // Troop Barracks (just to see how much wiggle room there is)
    // translate_past_divider_walls(3)
    // translate([0, tracker_array_length + safe_house_length + dreadnought_bay_length]) {
    //   cube(_m_player_troop_length);
    //   translate([2, 0.5*_m_player_troop_length, 0])
    //     cube(_m_player_troop_length);
    //   translate([4, 0.9*_m_player_troop_length, 0])
    //     cube(_m_player_troop_length);
    //   translate([6, _m_player_troop_length, 0])
    //     cube(_m_player_troop_length);
    // }
  }
}

module main() {
  _player_box_v3(include_shelf=false);
  // tracker_array(supports=false);
}

main();
