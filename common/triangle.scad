
// Please see https://www.triangle-calculator.com/

function equilateral_triangle(width, height, center=false) = [
    [center ? -0.5 * width : 0, 0],
    [center ? 0.5 * width : width, 0],
    [center ? 0 : 0.5 * width, height]
];
