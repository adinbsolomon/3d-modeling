
include <bins.scad>

adjustment = 2;

module adjusted_bin() {
    bin(
        1 * bin_width_unit - adjustment,
        2 * bin_depth_unit,
        2,
        0.4
    );
}

adjusted_bin();
