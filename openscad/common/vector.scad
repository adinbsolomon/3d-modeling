
use <list_functions.scad>

function vector_add(a, b) =
    assert(is_list(a) && is_list(b), "vectors must be lists")
    assert(len(a) == len(b), "vectors must be the same length")
    [
        for (i = [0:len(a)-1]) a[i] + b[i]
    ];

function vector_difference(a, b) =
    assert(is_list(a) && is_list(b), "vectors must be lists")
    assert(len(a) == len(b), "vectors must be the same length")
    [
        for (i = [0:len(a)-1]) a[i] - b[i]
    ];

function vector_element_multiplication(a, b) =
    assert(is_list(a) && is_list(b), "vectors must be lists")
    assert(len(a) == len(b), "vectors must be the same length")
    [
        for (i = [0:len(a)-1]) a[i] * b[i]
    ];

function dot_product(a, b) =
    assert(is_list(a) && is_list(b), "vectors are represented by lists")
    assert(len(a) == len(b), "vectors must the same length")
    list_sum(
        [
            for (i=[0:len(a)-1]) a[i] * b[i]
        ]
    );

function magnitude(x, y) =
    sqrt(x^2 + y^2);

function vector_rotate(vector, angle) =
    assert(is_list(vector) && len(vector)==2, "vector must be a list of 2 elements")
    let(rotated_vector = [
            [cos(angle), -sin(angle)],
            [sin(angle), cos(angle)]
        ] * [[vector.x], [vector.y]])
        [rotated_vector[0][0], rotated_vector[1][0]];
    
