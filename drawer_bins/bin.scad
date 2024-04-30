
module bin(width, depth, height, wall_thickness, floor_thickness) {
    difference() {
        cube([width, depth, height]);
        translate([
            wall_thickness, wall_thickness, floor_thickness
        ]) cube([
            width - 2 * wall_thickness,
            depth - 2 * wall_thickness,
            height - floor_thickness
        ]);
    }
}
