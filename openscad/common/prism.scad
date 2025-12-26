
use <polygon_points.scad>

// Creates a prism from polygon_points extending into the y dimension
module prism(polygon_points, depth) {
    translate([0,depth,0])
        rotate([90, 0, 0])
            linear_extrude(depth)
                polygon(polygon_points);
}
