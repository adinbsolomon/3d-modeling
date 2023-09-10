
use <../common/curves.scad>

// Units = Millimeters

outer_diameter = 15;
thickness = 2.5;
hook_length = 35;

module half_circle(outer_diameter, inner_diameter) {
    difference() {
        circle(d=outer_diameter);
        circle(d=inner_diameter);
        translate([-outer_diameter/2,0,0])
            square([outer_diameter, outer_diameter/2]);
    }
}

module halfpipe(outer_diameter, inner_diameter, length) {
    translate([0,outer_diameter/2,outer_diameter/2])
    rotate([90,0,90])
    linear_extrude(length) half_circle(outer_diameter, inner_diameter);
}

module hook() {
    intersection() {
        halfpipe(outer_diameter, outer_diameter - thickness, hook_length);
        linear_extrude(outer_diameter / 2) sinusoid(
            amplitude = outer_diameter,
            period = 1 / 7,
            phase_shift = 0,
            vertical_shift = 0,
            length = hook_length,
            precision = 36
        );
    }
}
