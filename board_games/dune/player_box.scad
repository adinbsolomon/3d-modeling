
include <measurements.scad>
use <../flexibox.scad>

layer_height = 0.15;
wall_thickness = layer_height * 5;

flexibox(
  wall_length=0.5 * _m_board_main_length,
  wall_widths=[36, 19, 36, 19],
  layer_height=layer_height,
  base_layer_count=1,
  wall_layer_count=(wall_thickness / layer_height) - 1,
  distance_between_walls=sqrt(2) * wall_thickness
);
