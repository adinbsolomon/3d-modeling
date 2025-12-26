
// Returns the points corresponding to the trapezoid
function trapezoid(base1, base2, height) = [
    [
        base1 >= base2 ? 0 : (base2-base1)/2,
        0
    ],
    [
        base1 + (base1 >= base2 ? 0 : (base2-base1)/2),
        0
    ],
    [
        base2 + (base2 >= base1 ? 0 : (base1-base2)/2),
        height
    ],
    [
        base2 >= base1 ? 0 : (base1-base2)/2,
        height
    ]
];
