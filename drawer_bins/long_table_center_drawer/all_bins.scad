
include <bins.scad>

module all_bins() {
    unit_bin(2,1);
    translate([2 * bin_width_unit,0,0]) unit_bin(2,1);
    translate([0,bin_depth_unit,0]) unit_bin(1,2);
    translate([bin_width_unit,bin_depth_unit,0]) unit_bin(2,2);
    translate([3*bin_width_unit,bin_depth_unit,0]) unit_bin(1,2);
}

all_bins();
