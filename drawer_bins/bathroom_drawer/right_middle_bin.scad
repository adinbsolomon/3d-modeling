
use <common/bin.scad>

// 1 inch = 25.4 mm

brush_bin_depth = 245;
razor_bin_depth = 7 * 25.4;
razor_bin_width = 5 * 25.4;

bin(
    razor_bin_width,
    brush_bin_depth - razor_bin_depth,
    1.5 * 25.4,
    1,
    0.4
);
