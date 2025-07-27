
use <common/bin.scad>
use <common/triangle.scad>
use <common/prism.scad>
use <common/list_functions.scad>

// TODO
// - Add support for floor lines

// Notes:
// - Card dimensions as a rectangular prism:
//  - card_height: the longest dimension of the card
//  - card_width: the second-longest dimension of the card
//  - card_thickness: the shortest dimension of the card
// - cards_laying_down: if true, the card_height is used to determine the bin width, else card_width
// - Tilt angle is the angle joining the floor to the card as a hypotenuse
// - Static Dividers:
//   - if tilt_angle = undef:
//     - Dividers will just be internal walls at the specified distances
//   - if tilt_angle is defined:
//     - Dividers will be triangular prisms supporting the cards similarly to the tilt support
//     - The footprint is the length of the divider along the bin floor

// Default parameters
_cards_bin_default_wall_thickness = 1;
_cards_bin_default_floor_thickness = 0.4;
_cards_bin_default_wiggle_room = 3;
_cards_bin_default_finger_access_negative_diameter = 20;

module cards_bin(
  card_height,
  card_width,
  bin_length,
  bin_wall_thickness = _cards_bin_default_wall_thickness,
  bin_floor_thickness = _cards_bin_default_floor_thickness,
  cards_laying_down = true,
  wiggle_room = _cards_bin_default_wiggle_room,
  use_finger_access_negative = true,
  finger_access_diameter = _cards_bin_default_finger_access_negative_diameter,
  tilt_angle = undef,
  static_divider_distances_from_wall = undef,
  static_divider_footprint = undef,
  floor_lines_thickness = undef,
  floor_lines_width = undef,
  floor_lines_gap = undef
) {

  // Derived parameters
  card_vertical = cards_laying_down ? card_width : card_height;
  card_horizontal = cards_laying_down ? card_height : card_width;
  card_shadow = is_undef(tilt_angle) ? undef : cos(tilt_angle) * card_horizontal;
  bin_height = (is_undef(tilt_angle) ? 1 : sin(tilt_angle)) * card_vertical + bin_floor_thickness;
  bin_width = card_horizontal + 2 * bin_wall_thickness + wiggle_room;

  module _cards_bin_tilt_support() {
    prism(
      right_triangle(card_shadow, bin_height - bin_floor_thickness),
      bin_width
    );
  }

  module _cards_bin_straight_divider() {
    cube(
      [
        bin_wall_thickness,
        bin_width,
        bin_height,
      ]
    );
  }
  
  module _cards_bin_tilted_divider() {
    assert(
      !is_undef(static_divider_footprint),
      "static_divider_footprint must be defined for tilted dividers."
    );
    translate([static_divider_footprint, bin_width, bin_wall_thickness])
    rotate([0, 0, 180])
    prism(
      triangle_sas(
        static_divider_footprint,
        tilt_angle,
        (bin_height - bin_floor_thickness - finger_access_diameter/2) / sin(tilt_angle)
      ),
      bin_width
    );
  }

  module _cards_bin_finger_access_negative() {
    cylinder(d=20, h=bin_length);
  }

  module _cards_bin_main_bin() {
    echo("Cards bin dimensions: length=", bin_length, ", width=", bin_width, ", height=", bin_height);
    bin(
      bin_length,
      bin_width,
      bin_height,
      bin_wall_thickness,
      bin_floor_thickness
    );
  }

  module _cards_bin_main() {
    difference() {
      union() {
        _cards_bin_main_bin();
        // Tilt Support
        if (!is_undef(tilt_angle)) {
          translate([bin_wall_thickness, 0, bin_floor_thickness])
            _cards_bin_tilt_support();
        }
        // Static Dividers
        if (!is_undef(static_divider_distances_from_wall) && is_list(static_divider_distances_from_wall)) {
          for (wall_num = [0:len(static_divider_distances_from_wall) - 1]) {
            translate([bin_wall_thickness + static_divider_distances_from_wall[wall_num], 0, 0])
              if (is_undef(tilt_angle))
                _cards_bin_straight_divider();
              else
                _cards_bin_tilted_divider();
          }
        }
      }
      if (use_finger_access_negative) {
        translate([0, bin_width / 2, bin_height])
          rotate([90, 0, 90])
            _cards_bin_finger_access_negative();
      }
    }
  }

  _cards_bin_main();
}

_card_stack_bin_default_wiggle_margin = 1;

module dual_card_stack_bin(
  card_length,
  card_width,
  stack_height,
  bin_wall_thickness = _cards_bin_default_wall_thickness,
  bin_floor_thickness = _cards_bin_default_floor_thickness,
  wiggle_margin = _card_stack_bin_default_wiggle_margin,
  generate_lifter_instead_of_bins = false
) {
  bin_length = card_width + 2*wiggle_margin + 2*bin_wall_thickness;
  bin_width = card_length + 2*wiggle_margin + 2*bin_wall_thickness;
  bin_height = stack_height + bin_floor_thickness;

  module _card_stack_bin() {
    echo("Card stack bin dimensions: length=", bin_length, ", width=", bin_width, ", height=", bin_height);
    bin(
      bin_length,
      bin_width,
      bin_height,
      bin_wall_thickness,
      bin_floor_thickness
    );
  }

  card_lifter_arm_length = 0.5 * card_width + wiggle_margin;
  card_lifter_arm_width = 0.1 * card_length;

  // Idea for card lifter: have a small spool spring in the handle that keeps fishing line taught instead of floor panel
  module _card_lifter() {
    cube([
      card_lifter_arm_length * 2
        + 2 * bin_wall_thickness,
      card_lifter_arm_width,
      bin_floor_thickness
    ]);
    translate([
      card_lifter_arm_length,
      0,
      0
    ])
      cube([
        2 * bin_wall_thickness,
        card_lifter_arm_width,
        bin_height
      ]);
  }

  module _card_stack_bin_main() {
    difference() {
      union() {
        _card_stack_bin();
        translate([bin_length, 0, 0])
          _card_stack_bin();
      }
      translate([
        0.5 * bin_length,
        0.5 * bin_width + bin_wall_thickness,
        0
      ])
        _card_lifter();
    }
  }

  if (generate_lifter_instead_of_bins) {
    _card_lifter();
  } else {
    _card_stack_bin_main();
  }
}
