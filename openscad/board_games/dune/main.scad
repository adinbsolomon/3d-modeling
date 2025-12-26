
include <measurements.scad>

include <cards_holder.scad>
use <game_box.scad>
use <game_boards.scad>
include <tiles.scad>
use <../cards_bin.scad>

use <common/list_functions.scad>
use <common/animation/layer_timeseries.scad>

layer_misc_boards_height = 10;
module layer_misc_boards() {
  translate([0, _m_box_length, 0])
    rotate([0, 0, -90]) {
      _board_ix_tech();
      translate([0, _m_board_ix_tech_width, 0])
        _board_bl();
      translate([0, 0, _m_board_thickness])
        mirror([-1, 1, 0])
          _board_im();
      translate([0, 0, 2 * _m_board_thickness])
        mirror([-1, 1, 0])
          _board_ix_shipping();
      translate([0, _m_board_ix_shipping_length, 2 * _m_board_thickness])
        _board_uprising_6p(both=true, stacked=true);
    }
}

layer_cards_height = max_bin_height - layer_misc_boards_height;
dual_card_stack_bin_width = 2 * 70.3;
dual_card_stack_bin_length = 94.3;
module layer_cards() {
  translate([-1, 0, 0]) {
    max_height_dual_stack_bin();
    translate([dual_card_stack_bin_width, 0, 0])
      max_height_dual_stack_bin();
  }
}

layer_boards_and_player_boxes_height = _m_board_main_thickness + _m_board_uprising_thickness;
module layer_boards_and_player_boxes(){
  _board_main();
  translate([0, 0, _m_board_main_thickness])
    _board_uprising();
}

layer_rulebook_height = _m_rulebook_thickness;
module layer_rulebook() {
  cube(
    [
      _m_box_length,
      _m_box_length,
      _m_rulebook_thickness,
    ]
  );
}

layer_unused_height = _m_box_height - layer_rulebook_height - layer_boards_and_player_boxes_height - layer_misc_boards_height;
module layer_unused() {
  translate([0, _m_box_length - 10, 0])
    cube([10, 10, layer_unused_height]);
}

layer_tiles_height = 45;
tile_bin_group_width = 71 + 58;
module layer_tiles() {
  translate([0, dual_card_stack_bin_length, 0]) {
    translate([0, _m_tile_tech_stack_thickness + _tiles_bin_length_additions, 0])
      rotate([0, 0, -90])
        _tiles_techs_bin();
    translate([0, _m_tile_tech_stack_thickness + _m_tile_sardukar_stack_thickness + 2*_tiles_bin_length_additions, 0])
      rotate([0, 0, -90])
        _tiles_sardukar_bin();
    translate([71, _m_tile_contract_stack_thickness + _tiles_bin_length_additions, 0])
      rotate([0, 0, -90])
        _tiles_contracts_bin();
  }
}

module layer_leftover_cards() {
  translate([tile_bin_group_width, dual_card_stack_bin_length, 0]) {
    translate([0, 69, 0])
      rotate([0, 0, -90])
        cards_bin(
          _m_scard_length,
          _m_scard_width,
          _m_scard_intrigue_stack_thickness + _m_scard_conflict_stack_thickness + _m_scard_special_stack_thickness
        );
    translate([71, 0, 0])
    cards_bin(
      _m_card_length,
      layer_unused_height + _cards_bin_default_floor_thickness,
      _m_card_width
    );
  }
}

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
      translate(
        [
          -0.5 * _m_box_wall_thickness,
          -0.5 * _m_box_wall_thickness,
          _m_box_height - _m_rulebook_thickness,
        ]
      )
        cube(
          [
            _m_box_length + _m_box_wall_thickness,
            _m_box_length + _m_box_wall_thickness,
            _m_rulebook_thickness,
          ]
        );
    }
    if (include_board_configuration) {
      // Main and Uprising Boards
      translate(
        [
          -0.5 * _m_box_wall_thickness,
          -0.5 * _m_box_wall_thickness,
          _m_box_height - _m_rulebook_thickness - _m_board_main_thickness,
        ]
      )
        cube(
          [
            _m_board_main_length + 0.5 * _m_box_wall_thickness,
            _m_board_main_length + 0.5 * _m_box_wall_thickness,
            2 * _m_board_main_thickness,
          ]
        );
      // Other Boards
      translate(
        [
          -0.5 * _m_box_wall_thickness,
          -0.5 * _m_box_wall_thickness,
          _m_box_height - _m_rulebook_thickness - 2 * _m_board_main_thickness - 4 * _m_board_thickness,
        ]
      )
        cube(
          [
            _m_board_uprising_length + 0.5 * _m_box_wall_thickness,
            _m_board_uprising_length + 0.5 * _m_box_wall_thickness,
            2 * _m_board_uprising_thickness,
          ]
        );
    }
  }
}

module main() {
  layer_timeseries(
    [
      0,
      0,
      0,
      layer_cards_height,
      layer_misc_boards_height,
      layer_boards_and_player_boxes_height,
      layer_rulebook_height,
    ]
  ) {
    game_box();
    layer_cards();
    layer_tiles();
    layer_leftover_cards();
    layer_unused();
    layer_misc_boards();
    layer_boards_and_player_boxes();
    layer_rulebook();
  }
}

render(convexity=10)
  main();
