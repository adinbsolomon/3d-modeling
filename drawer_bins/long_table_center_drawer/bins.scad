
// Drawer Measurements (frontal perspective)
drawer_width = 345;
drawer_depth = 285;
drawer_height = 40;

module bin(width, depth, wall_thickness, floor_thickness) {
    difference() {
        cube([width, depth, drawer_height]);
        translate([
            wall_thickness, wall_thickness, floor_thickness
        ]) cube([
            width - 2 * wall_thickness,
            depth - 2 * wall_thickness,
            drawer_height - floor_thickness
        ]);
    }
}

bin_width_unit = drawer_width / 4;
bin_depth_unit = drawer_depth / 3;

module unit_bin(width_units, depth_units) {
    bin(
        width_units * bin_width_unit,
        depth_units * bin_depth_unit,
        2,
        0.4
    );
}
