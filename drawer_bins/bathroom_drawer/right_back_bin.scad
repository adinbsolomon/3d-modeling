
use <../bin.scad>

// 1 inch = 25.4 mm

total_drawer_depth = 18.75 * 25.4;
brush_bin_depth = 245;
razor_bin_depth = 7 * 25.4;
razor_bin_width = 5 * 25.4;

bin(
    razor_bin_width,
    total_drawer_depth - brush_bin_depth,
    1.5 * 25.4,
    1,
    0.4
);
