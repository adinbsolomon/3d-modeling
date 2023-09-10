
module rounded_edge_cube(width, depth, height, edge_radius) {
    $fn=50;
    translate([
        edge_radius,
        edge_radius,
        edge_radius
    ]) minkowski() {
        cube([
            width-2*edge_radius,
            depth-2*edge_radius,
            height-2*edge_radius]);
        sphere(r=edge_radius);
    }
}

rounded_edge_cube(20, 10, 5, 2);
