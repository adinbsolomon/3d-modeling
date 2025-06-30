
include <measurements.scad>

// The proportion argument in each of these is useful for splitting the stack

module _tiles_tech(proportion = 1) {
    cube([
        _m_tile_tech_length,
        _m_tile_tech_stack_thickness * proportion,
        _m_tile_tech_width
    ]);
}

module _tiles_contract(proportion = 1) {
    cube([
        _m_tile_contract_length,
        _m_tile_contract_stack_thickness * proportion,
        _m_tile_contract_width
    ]);
}

module _tiles_sardukar(proportion = 1) {
    cube([
        _m_tile_sardukar_length,
        _m_tile_sardukar_stack_thickness * proportion,
        _m_tile_sardukar_width
    ]);
}
