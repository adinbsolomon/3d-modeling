
use <common/bin.scad>
use <common/triangle.scad>

// 1 inch = 25.4 mm

// Build plate dimensions (250x210x220) require two pieces... they'll be joined
// by an overlapping wall lock

$fn = 30;

width = 3 * 25.4;
depth = 9 * 25.4;
height = 1.5 * 25.4;

connector_buffer = 0.4;

module main_bin() {
    bin(
        width,
        depth,
        height,
        1,
        0.4
    );
}

module main_bin_with_additional_wall_material() {
    union(){
        main_bin();
        translate([0, depth, 0]) cube([width, 1, height]);
    }
}

module connection_male() {
    union() {
        translate([0, 1, 0]) rotate([90, 0, 0]) linear_extrude(1) polygon(equilateral_triangle(width / 4, height / 2, center=true));
        translate([0, 2, 0]) rotate([90, 0, 0]) linear_extrude(1) polygon(equilateral_triangle(width / 8, height / 4, center=true));
    }
}

module connection_female() {
    module add_wiggle_room() {
        minkowski() {
            children();
            cylinder(r=connector_buffer, h=0.5, center=false);
        }
    }

    union() {
        translate([0, 1, 0]) rotate([90, 0, 0]) add_wiggle_room() linear_extrude(0.5) polygon(equilateral_triangle(width / 4, height / 2, center=true));
        translate([0, 2, 0]) rotate([90, 0, 0]) add_wiggle_room() linear_extrude(0.5) polygon(equilateral_triangle(width / 8, height / 4, center=true));
    }
}

module main_bin_complete() {
    difference() {
        main_bin_with_additional_wall_material();
        translate([width/2, depth-1, 0]) connection_female();
    }
}

main_bin_complete();
