
use <../bin.scad>

// 1 inch = 25.4 mm

total_drawer_depth = 18.75 * 25.4;
teeth_unit_depth = 9 * 25.4 + 2 * 25.4 + 1;
width = 3 * 25.4;

bin(
    width,
    total_drawer_depth - teeth_unit_depth,
    1.5 * 25.4,
    1,
    0.4
);
