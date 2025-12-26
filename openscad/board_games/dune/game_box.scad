
include <measurements.scad>

use <common/bin.scad>

module _game_box(floor_thickness = 0) {
  bin(
    _m_box_length + 2 * _m_box_wall_thickness,
    _m_box_length + 2 * _m_box_wall_thickness,
    _m_box_height,
    _m_box_wall_thickness,
    floor_thickness // No need to translate everything above the floor
  );
}
