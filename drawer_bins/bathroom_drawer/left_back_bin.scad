
use <common/polygon_bin.scad>

// 1 inch = 25.4 mm

total_drawer_depth = 18.75 * 25.4;

teeth_unit_depth = 9 * 25.4 + 2 * 25.4 + 1;
teeth_unit_width = 3 * 25.4;

brush_bin_depth = 245;
brush_bin_width = 2.5 * 25.4;

polygon_bin(
    [
        [0, teeth_unit_depth - brush_bin_depth],
        [0, total_drawer_depth - brush_bin_depth],
        [teeth_unit_width + brush_bin_width, total_drawer_depth - brush_bin_depth],
        [teeth_unit_width + brush_bin_width, 0],
        [teeth_unit_width, 0],
        [teeth_unit_width, teeth_unit_depth - brush_bin_depth]
    ],
    1.5 * 25.4,
    1,
    0.4
);
