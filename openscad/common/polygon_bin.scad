
use <../common/angles.scad>
use <../common/list_functions.scad>
use <../common/vector.scad>

// Note: polygon_points should be used exactly the same as with polygon()
// Note: This assumes a non-self-intersecting polygon
module polygon_bin(polygon_points, height, wall_thickness, floor_thickness) {
    // Make sure each point is (x,y)
    for (i = [0 : len(polygon_points)-1]) {
        assert(len(polygon_points[i]) == 2, str("polygon must be a list of 2d points: ", polygon_points[i]));
    }

    // Add up the angles of the polygon
    angles = concat(
        [
            for (i = [0 : len(polygon_points)-3]) angle_of_three_points(
                polygon_points[i],
                polygon_points[i+1],
                polygon_points[i+2]
            ),
        ],
        [
            angle_of_three_points(
                polygon_points[len(polygon_points)-2],
                polygon_points[len(polygon_points)-1],
                polygon_points[0]
            ),
            angle_of_three_points(
                polygon_points[len(polygon_points)-1],
                polygon_points[0],
                polygon_points[1]
            ),
        ]
    );
    angles_sum = list_sum(angles);
    echo(angles);
    echo(angles_sum);
    clockwise = angles_sum == 360; // Direction of traversal around polygon

    // Create the floor of the bin
    linear_extrude(floor_thickness) polygon(polygon_points);

    // Create the walls of the bin
    function process_wall_number(wall_number) =
        wall_number < 0 ? 
                len(polygon_points) + wall_number : 
                wall_number % len(polygon_points);
    function wall_start_point(wall_number) =
        polygon_points[process_wall_number(wall_number)];
    function wall_end_point(wall_number) = 
        polygon_points[(process_wall_number(wall_number+1))];
    // TODO: replace with expressive function about obtuse interior angle
    function angle_after_wall(wall_number) =
        angles[process_wall_number(wall_number)];
    function angle_before_wall(wall_number) =
        angles[process_wall_number(wall_number-1)];
    for (wall_number = [0:len(polygon_points)-1]) {
        wall_start = wall_start_point(wall_number);
        wall_end = wall_end_point(wall_number);
        wall_vector = vector_difference(wall_end, wall_start);
        echo(wall_vector);
        wall_length = magnitude(wall_vector.x, wall_vector.y
        );
        echo(wall_length)
        if (wall_length != 0) {
            rotated_wall_vector = vector_rotate(wall_vector, clockwise ? -90 : 90);
            extrude_vector = [
                wall_thickness * rotated_wall_vector.x / wall_length,
                wall_thickness * rotated_wall_vector.y / wall_length
            ];
            echo(extrude_vector);
            echo(angle_before_wall(wall_number))
            echo(angle_after_wall(wall_number))
            linear_extrude(height) polygon([
                wall_start,
                wall_end,
                // If the interior angle AFTER this wall is obtuse adjust for corner coverage
                vector_add(
                    wall_end,
                    angles_sum * angle_after_wall(wall_number) > 0 ? // same sign indicates acute interior angle
                        extrude_vector :
                        vector_rotate(extrude_vector, angle_after_wall(wall_number) / -2)
                ),
                // If the interior angle BEFORE this wall is obtuse adjust for corner coverage
                vector_add(
                    wall_start,
                    angles_sum * angle_before_wall(wall_number) > 0 ? // same sign indicates acute interior angle
                        extrude_vector :
                        vector_rotate(extrude_vector, angle_before_wall(wall_number) / 2)
                )
            ]);
        }
    }
}
