
include <../cards_bin.scad>
use <common/prism.scad>
use <common/triangle.scad>

include <measurements.scad>

// TODO - find the on-board symbol for each tile type and use that instead of text

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

_tiles_bin_stack_thickness_padding = floor(_m_tile_thickness);
_tiles_bin_length_additions = 2 * _cards_bin_default_wall_thickness + _tiles_bin_stack_thickness_padding;
module _tiles_bin(
  tile_length,
  tile_width,
  tile_stack_thickness,
  tile_text,
  tile_text_size
) {
  echo("Creating tiles bin for ", tile_text, "with dimenstions: ", [
    tile_length,
    tile_width,
    tile_stack_thickness
  ]);
  difference() {
    cards_bin(
      card_height = tile_length,
      card_width = tile_width,
      bin_length = tile_stack_thickness + _tiles_bin_length_additions,
      cards_laying_down = false
    );
    // translate([
    //   0.5 * tile_stack_thickness
    //     + _cards_bin_default_wall_thickness
    //     + 0.5 * _tiles_bin_stack_thickness_padding,
    //   0.5 * tile_width
    //     + _cards_bin_default_wall_thickness
    //     + 0.5 * _cards_bin_default_wiggle_room,
    //   0
    // ])
    //   rotate([0,0,90])
    //     linear_extrude(_cards_bin_default_floor_thickness)
    //       text(
    //         tile_text,
    //         size = tile_text_size,
    //         font = "Dune Rise",
    //         valign = "center",
    //         halign = "center"
    //       );
  }
}

module _tiles_contracts_bin() {
  _tiles_bin(
    tile_length = _m_tile_contract_length,
    tile_width = _m_tile_contract_width,
    tile_stack_thickness = _m_tile_contract_stack_thickness,
    tile_text = "CONTRACTS",
    tile_text_size = 4.5
  );
}

module _tiles_techs_bin() {
  _tiles_bin(
    tile_length = _m_tile_tech_length,
    tile_width = _m_tile_tech_width,
    tile_stack_thickness = _m_tile_tech_stack_thickness,
    tile_text = "TECHS",
    tile_text_size = 8
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
      _m_tile_sardukar_stack_thickness + _tiles_bin_stack_thickness_padding
    );
  }

  union() {
    _tiles_bin(
      tile_length = _m_tile_sardukar_length,
      tile_width = _m_tile_sardukar_width,
      tile_stack_thickness = _m_tile_sardukar_stack_thickness,
      tile_text = "SKILLS",
      tile_text_size = 5
    );
    translate([
      _cards_bin_default_wall_thickness
        + _m_tile_sardukar_stack_thickness
        + _tiles_bin_stack_thickness_padding,
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
