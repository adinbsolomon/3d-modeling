
include <measurements.scad>

use <../../drawer_bins/bin.scad>
use <../../common/triangle.scad>
use <../../common/prism.scad>
use <../../common/list_functions.scad>

// Box and Card Dimensions
box_side_length = 254;
max_bin_height = 79 - 5.6 - 20; // 52.4 = Box height - rule books thickness - board thickness
card_width = 66.3;
card_height = 99.1;

// Bin construction
bin_floor_thickness = 0.2;
bin_wall_thickness = 1;
bin_width = card_height + 2 * bin_wall_thickness + 3; // 3mm wiggle room for cards

// - Cards need to be on a slant to stand up on their side
max_height = max_bin_height - bin_floor_thickness; // 52
minimum_card_tilt = asin(max_height / card_width); // ~52 (total coincidence lol)
tilted_card_shadow = sqrt(card_width ^ 2 - max_height ^ 2); // ~41.5

module _cards_holder_outer_bin(bin_length) {
  bin(
    bin_length,
    bin_width,
    max_bin_height,
    bin_wall_thickness,
    bin_floor_thickness
  );
}

module _cards_holder_tilt_support() {
  prism(
    right_triangle(tilted_card_shadow, max_height),
    bin_width
  );
}

// A static divider could be parallel to the cards (same tilt angle), but getting cards
// would be difficult. Instead the divider should have a wider footprint so cards on the
// underside can be tilted up to be removed. Let's try ~10 degree difference for card pickup.
divider_height = 40; // lower than bin height makes the card placement look natural
divider_footprint = 11;
divider_overhang = 20;
module _cards_holder_static_divider() {
  prism(
    [
      [0, 0],
      [divider_footprint, 0],
      [-divider_overhang + 1, divider_height], // Divider should have a small flat top
      [-divider_overhang, divider_height],
    ],
    bin_width
  );
}

// Subtract this from the rest of the bin to make fingertip access
fingertip_access_diameter = 20;
module _cards_holder_fingertip_access_negative(bin_length) {
  translate([0, bin_width / 2, max_bin_height])
    rotate([90, 0, 90])
      cylinder(d=20, h=bin_length);
}

module _cards_holder_default_bin(bin_length) {
  difference() {
    union() {
      _cards_holder_outer_bin(bin_length); // add param
      translate([bin_wall_thickness, 0, bin_floor_thickness])
        _cards_holder_tilt_support();
    }
    _cards_holder_fingertip_access_negative(bin_length);
    // translate([0, bin_width / 2 - 2.5])
    //     cube([bin_length, 5, bin_floor_thickness]);
  }
}

module _cards_holder_divided_bin(card_stack_thickness_list) {
  // Calculate bin_length from stack count and thicknesses
  bin_length = 2 * bin_wall_thickness + tilted_card_shadow + list_sum(card_stack_thickness_list) + (len(card_stack_thickness_list) - 1) * divider_footprint;
  echo("Total bin length: ", bin_length);
  union() {
    _cards_holder_default_bin(bin_length);
    for (stack_num = [0:len(card_stack_thickness_list) - 2]) {
      translate(
        [
          bin_wall_thickness + tilted_card_shadow + list_sum(list_sublist(card_stack_thickness_list, 0, stack_num + 1)) + stack_num * divider_footprint,
          0,
          bin_floor_thickness,
        ]
      )
        _cards_holder_static_divider();
    }
  }
}

line_thickness = 0.2;
line_width = 1;
line_gap = 1;
module _cards_holder_lined_bin(bin_length) {
  number_of_lines = round((bin_length - 2 * bin_wall_thickness - tilted_card_shadow) / (line_width + line_gap));
  echo("Number of lines: ", number_of_lines);
  union() {
    _cards_holder_default_bin(bin_length);
    for (line_num = [0:number_of_lines]) {
      translate(
        [
          bin_wall_thickness + tilted_card_shadow + line_gap + line_num * (line_width + line_gap),
          0,
          bin_floor_thickness,
        ]
      )
        cube([line_width, bin_width, line_thickness]);
    }
  }
}

stack_base = 42;
stack_ix = 22;
stack_immo = 20;
stack_uprising = 48;
stack_staples = 16;
stack_staples_uprising = 12;
stack_tleilax = 13;
stack_starting = 33;
stack_hagal = 15;
stack_uprising_misc = 30;

// All cards width is more than the box's inner sidelengths, so dividing them up is needed
// - Imperium decks: 132mm (base, ix, immo, uprising)
// - Staples and Tleilax: 41mm (base, uprising, immo)
// - Starting: 33mm + ??? (base, uprising)
// - Misc: 45mm (hagal, uprising hagal, misc)

// _cards_holder_divided_bin([
//     stack_base / 2,
//     stack_base / 2
// ]);

_cards_holder_lined_bin(250);
