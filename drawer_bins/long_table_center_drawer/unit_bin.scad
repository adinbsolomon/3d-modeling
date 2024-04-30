
use <../bin.scad>

// Drawer Measurements (frontal perspective)
drawer_width = 345;
drawer_depth = 285;
drawer_height = 40;

bin_width_unit = drawer_width / 4;
bin_depth_unit = drawer_depth / 3;

module unit_bin(width_units, depth_units) {
    bin(
        width_units * bin_width_unit,
        depth_units * bin_depth_unit,
        drawer_height,
        2,
        0.4
    );
}
