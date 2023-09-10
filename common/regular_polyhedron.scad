
use <regular_polygon.scad>

module regular_polyhedron(sides, radius, height) {
    linear_extrude(height=height)
    regular_polygon(
        sides=sides,
        radius=radius
    );
}
