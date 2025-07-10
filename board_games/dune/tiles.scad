
include <../cards_bin.scad>
use <common/prism.scad>
use <common/triangle.scad>

include <measurements.scad>

// TODO - get actual measurements from the tiles
_m_tile_sardukar_length = 46;
_m_tile_sardukar_width = 46;
_m_tile_sardukar_width_2 = 36;
_m_tile_sardukar_stack_thickness = 100;

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

module _tiles_contracts_bin() {
  difference() {
    cards_bin(
      card_height = _m_tile_contract_width,
      card_width = _m_tile_contract_length,
      bin_length = _m_tile_contract_stack_thickness,
      use_finger_access_negative = true
    );
    // TODO - Dune font?
    translate([0, 0, _cards_bin_default_floor_thickness / 2])
      text(
        "Contracts",
        size = _m_tile_contract_width * 0.8, // TODO
        valign = "center",
        halign = "center"
      );
  }
}

module _tiles_techs_bin() {
  difference() {
    cards_bin(
      card_height = _m_tile_tech_width,
      card_width = _m_tile_tech_length,
      bin_length = _m_tile_tech_stack_thickness,
      use_finger_access_negative = true
    );
    // TODO - Dune font?
    translate([0, 0, _cards_bin_default_floor_thickness / 2])
      text(
        "Techs",
        size = _m_tile_tech_width * 0.8, // TODO
        valign = "center",
        halign = "center"
      );
  }
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

  difference() {
    union() {
      cards_bin(
        card_height = _m_tile_sardukar_width,
        card_width = _m_tile_sardukar_length,
        bin_length = _m_tile_sardukar_stack_thickness + 2 * _cards_bin_default_wall_thickness
      );
      translate([
        _cards_bin_default_wall_thickness + _m_tile_sardukar_stack_thickness,
        _cards_bin_default_wall_thickness,
        _cards_bin_default_floor_thickness
      ])
        _tiles_sardukar_bin_wing();
      translate([
        _cards_bin_default_wall_thickness,
        _m_tile_sardukar_width + wing_offset - _cards_bin_default_wall_thickness,
        _cards_bin_default_floor_thickness
      ])
        rotate([0,0, 180])
          _tiles_sardukar_bin_wing();
    }
    translate([
      _m_tile_sardukar_stack_thickness/2 + _cards_bin_default_wall_thickness,
      _m_tile_sardukar_width / 2 + _cards_bin_default_wall_thickness,
      _cards_bin_default_floor_thickness / 2
    ])
      linear_extrude(_cards_bin_default_floor_thickness / 2)
        text(
          "Sardukar",
          size = _m_tile_sardukar_width * 0.15, // TODO
          font = "Dune Rise",
          valign = "center",
          halign = "center"
        );
  }
}

_tiles_sardukar_bin();
