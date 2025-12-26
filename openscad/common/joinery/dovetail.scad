
// --------- \\
//  Cutouts  \\
// --------- \\

module cutout_male(base_width, height, edge_width, minkowski_radius=1) {
    difference() {
        translate([1, 0.5, 0]) minkowski() {
            polygon(points = [
                [0,5], [10,5], [7,0], [3,0]
            ]);
            circle(minkowski_radius, $fn=32);
        }
        polygon(points = [
            [3,0], [9,0], [9, -0.5], [3, -0.5]
        ]);
    }
}

module cutout_female() {
    difference() {
        polygon(points = [
            [0,0], [0, 7], [14, 7], [14, 0]
        ]);
        translate([1, 0, 0]) minkowski() {
            cutout_male();
            circle(0.25, $fn=32);
        }
    }
}

translate([1, 0, 0]) cutout_male();
cutout_female();
