
use <list_functions.scad>

// polygon_points should be a list of 2d points
function shift_to_first_quadrant(polygon_points) = 
    let(
        min_x = min(list_cross_section(polygon_points, 0)),
        min_y = min(list_cross_section(polygon_points, 1))
    )
    [
        for (i = [0:len(polygon_points)]) [
            polygon_points[i][0] - min_x,
            polygon_points[i][1] - min_y
        ]
    ];
