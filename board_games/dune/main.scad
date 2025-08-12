
include <measurements.scad>

include <cards_holder.scad>
use <game_box.scad>
use <game_boards.scad>

bin_width = 104.1;

module game_box(
  line_for_rulebooks = false,
  include_board_configuration = false
) {
  difference() {
    // No need to translate inserts above the floor
    translate([-_m_box_wall_thickness, -_m_box_wall_thickness, 0])
      _game_box();
    
    // Showing constraints
    if (line_for_rulebooks) {
      translate([
        -0.5 * _m_box_wall_thickness,
        -0.5 * _m_box_wall_thickness,
        _m_box_height - _m_rulebook_thickness,
      ])
        cube([
          _m_box_length + _m_box_wall_thickness,
          _m_box_length + _m_box_wall_thickness,
          _m_rulebook_thickness,
        ]);
    }
    if (include_board_configuration) {
      // Main and Uprising Boards
      translate([
        -0.5 * _m_box_wall_thickness,
        -0.5 * _m_box_wall_thickness,
        _m_box_height
          - _m_rulebook_thickness
          - _m_board_main_thickness,
      ])
        cube([
          _m_board_main_length + 0.5 * _m_box_wall_thickness,
          _m_board_main_length + 0.5 * _m_box_wall_thickness,
          2 * _m_board_main_thickness
        ]);
      // Other Boards
      translate([
        -0.5 * _m_box_wall_thickness,
        -0.5 * _m_box_wall_thickness,
        _m_box_height
          - _m_rulebook_thickness
          - 2 * _m_board_main_thickness
          - 4 * _m_board_thickness,
      ])
        cube([
          _m_board_uprising_length + 0.5 * _m_box_wall_thickness,
          _m_board_uprising_length + 0.5 * _m_box_wall_thickness,
          2 * _m_board_uprising_thickness
        ]);
    }
  }
}

module main() {
  game_box(
    line_for_rulebooks = true,
    include_board_configuration = true
  );
  // max_height_dual_stack_bin();
  // translate([
  //   2 * _m_card_width
  //     + 4 * _card_stack_bin_default_wiggle_margin
  //     + 4 * _cards_bin_default_wall_thickness,
  //   0,
  //   0
  // ])
  //   max_height_dual_stack_bin();
}

render(convexity = 10)
  main();
