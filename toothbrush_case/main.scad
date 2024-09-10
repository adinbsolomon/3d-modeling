
use <../common/ellipse.scad>

// TODO: confirm these dimensions before printing
toothbrush_length = 250;
toothbrush_thickness = 15;
toothpaste_length = 50;
toothpaste_thickness = 25;

// Goals
// - Long case (like a glasses case) for travel and convenience
// - Holds toothbrush
// - Holds travel-sized toothpaste tube

// Nice-to-haves
// - Rounded edges and maybe ovular prism shape
// - Toothbrush is held in place
// - A spot for placing a folded standard napkin faced by the bristels to minimize internal humidity

case_x_outer = (toothpaste_thickness + 50);
case_y_outer = toothbrush_length + 50;
ellipse_x = case_x_outer / 2;
ellipse_y = case_y_outer / 1.5;

translate([case_y_outer/2, case_x_outer/2, case_x_outer/2])
rotate([-90, 0, 90])
rotate_extrude(angle=180, convexity=10) 
difference() {
    ellipse(r_x=ellipse_x, r_y=ellipse_y);
    polygon([
        [0, -ellipse_y],
        [0, ellipse_y],
        [-ellipse_x, ellipse_y],
        [-ellipse_x, -ellipse_y],
    ]);
    polygon([
        [0, case_y_outer / 2],
        [0, ellipse_y],
        [ellipse_x, ellipse_y],
        [ellipse_x, case_y_outer / 2],
    ]);
    polygon([
        [0, -case_y_outer / 2],
        [0, -ellipse_y],
        [ellipse_x, -ellipse_y],
        [ellipse_x, -case_y_outer / 2],
    ]);
}
