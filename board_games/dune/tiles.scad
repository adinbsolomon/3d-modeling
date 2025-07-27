
include <../cards_bin.scad>
use <common/prism.scad>
use <common/triangle.scad>

include <measurements.scad>

// The proportion argument in each of these is useful for splitting the stack

module _tiles_tech(proportion = 1) {
  cube(
    [
      _m_tile_tech_length,
      _m_tile_tech_stack_thickness * proportion,
      _m_tile_tech_width,
    ]
  );
}

module _tiles_contract(proportion = 1) {
  cube(
    [
      _m_tile_contract_length,
      _m_tile_contract_stack_thickness * proportion,
      _m_tile_contract_width,
    ]
  );
}

module _tiles_sardukar(proportion = 1) {
  cube(
    [
      _m_tile_sardukar_length,
      _m_tile_sardukar_stack_thickness * proportion,
      _m_tile_sardukar_width,
    ]
  );
}

module _tiles_bin(
  tile_length,
  tile_width,
  tile_stack_thickness,
  tile_text,
  tile_text_size
) {
  difference() {
    cards_bin(
      card_height = tile_length,
      card_width = tile_width,
      bin_length = tile_stack_thickness + 2 * _cards_bin_default_wall_thickness,
      cards_laying_down = false
    );
    translate([
      0.5 * tile_stack_thickness + _cards_bin_default_wall_thickness,
      0.5 * tile_width
        + _cards_bin_default_wall_thickness
        + 0.5 * _cards_bin_default_wiggle_room,
      0.5 * _cards_bin_default_floor_thickness
    ])
      rotate([0,0,90])
        linear_extrude(_cards_bin_default_floor_thickness / 2)
          text(
            tile_text,
            size = tile_text_size,
            font = "Dune Rise",
            valign = "center",
            halign = "center"
          );
  }
}

module _tiles_contracts_bin() {
  _tiles_bin(
    tile_length = _m_tile_contract_length,
    tile_width = _m_tile_contract_width,
    tile_stack_thickness = _m_tile_contract_stack_thickness,
    tile_text = "Contracts",
    tile_text_size = 3.5
  );
}

module _tiles_techs_bin() {
  _tiles_bin(
    tile_length = _m_tile_tech_length,
    tile_width = _m_tile_tech_width,
    tile_stack_thickness = _m_tile_tech_stack_thickness,
    tile_text = "Techs",
    tile_text_size = 3.5
  );
}

module _tiles_sardukar_bin() {

  wing_offset = 0.5 * (_m_tile_sardukar_width - _m_tile_sardukar_width_2);

  module _tiles_sardukar_bin_wing() {
    rotate([0, 0, 90])
    prism(
      right_triangle(
        wing_offset,
        _m_tile_sardukar_length
      ),
      _m_tile_sardukar_stack_thickness
    );
  }

  union() {
    _tiles_bin(
      tile_length = _m_tile_sardukar_length,
      tile_width = _m_tile_sardukar_width,
      tile_stack_thickness = _m_tile_sardukar_stack_thickness,
      tile_text = "Sardukar",
      tile_text_size = 3.5
    );
    translate([
      _cards_bin_default_wall_thickness + _m_tile_sardukar_stack_thickness,
      _cards_bin_default_wall_thickness,
      _cards_bin_default_floor_thickness
    ])
      _tiles_sardukar_bin_wing();
    translate([
      _cards_bin_default_wall_thickness,
      _cards_bin_default_wall_thickness
        + wing_offset * 2
        + _m_tile_sardukar_width_2
        + _cards_bin_default_wiggle_room,
      _cards_bin_default_floor_thickness
    ])
      rotate([0,0, 180])
        _tiles_sardukar_bin_wing();
  } 
}
