
include <measurements.scad>
include <../cards_bin.scad>

// Two pairs of dual stack bins
max_bin_height = _m_box_height - _m_rulebook_thickness - 2 * _m_board_main_thickness;

// Dimensions for this piece:
// - x: 0.5 * _m_box_length
// - y: < 94 mm
// - z: max_bin_height (56 mm)
module max_height_dual_stack_bin() {
  translate([
    0,
    -_cards_bin_default_wall_thickness,
    0
  ])
    difference() {
      dual_card_stack_bin(
        card_length = _m_card_length,
        card_width = _m_card_width,
        stack_height = max_bin_height - _cards_bin_default_floor_thickness
      );
      cube([
        _m_box_length,
        _cards_bin_default_wall_thickness,
        max_bin_height
      ]);
      // TODO - maybe remove one the side walls?
    }
}
