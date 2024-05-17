
use <vector.scad>

function positive_angle(angle) = 
    let(a = angle % 360)
    a > 0 ? a : a + 360;

function angle_of_three_points(point1, point2, point3) =
    assert(len(point1) == 2, str("points must be (x,y): ", point1))
    assert(len(point2) == 2, str("points must be (x,y): ", point1))
    assert(len(point3) == 2, str("points must be (x,y): ", point1))
    let(
        a = vector_difference(point1, point2),
        b = vector_difference(point3, point2)
    )
        atan2(a.x*b.y - b.x*a.y, a.x*a.y + b.x*b.y);
