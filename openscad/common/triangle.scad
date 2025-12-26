
// Please see https://www.triangle-calculator.com/

function equilateral_triangle(width, height, center=false) = [
    [center ? -0.5 * width : 0, 0],
    [center ? 0.5 * width : width, 0],
    [center ? 0 : 0.5 * width, height]
];

function right_triangle(base, height) = [
    [0, 0],
    [base, 0],
    [0, height]
];

// These three triangle functions interpret arguments consistently with this diagram:
// https://drive.google.com/file/d/1ZDoTncUM-vHw5WvLdSWYfCPF4HyfT60N
function triangle_sss(a, b, c) = let(
    C = acos((a*a + b*b - c*c) / (2*a*b)),
    x3 = b * cos(C),
    y3 = b * sin(C)
)[
    [0, 0],
    [a, 0],
    [x3, y3]
];

function triangle_sas(a, C, b) = let(
    C_rad = C * PI / 180,
    // Law of Cosines for side c
    c = sqrt(a*a + b*b - 2*a*b*cos(C_rad)),
    x3 = b * cos(C),
    y3 = b * sin(C)
)
[
    [0, 0],
    [a, 0],
    [x3, y3]
];

function triangle_asa(A, c, B) = let(
    C = 180 - A - B,
    // Law of Sines for sides a and b
    a = c * sin(A * PI / 180) / sin(C * PI / 180),
    b = c * sin(B * PI / 180) / sin(C * PI / 180),
    x3 = b * cos(A),
    y3 = b * sin(A)
)
echo("A=", A, ", B=", B, ", C=", C, ", a=", a, ", b=", b, ", c=", c, ", x3=", x3, ", y3=", y3)
[
    [0, 0],
    [c, 0],
    [x3, y3]
];

function triangle_saaa(a, A, B, C) = let(
    // Law of Sines for sides b and c
    b = a * sin(B * PI / 180) / sin(A * PI / 180),
    c = a * sin(C * PI / 180) / sin(A * PI / 180),
    x3 = b * cos(A),
    y3 = b * sin(A)
) [
    [0, 0],
    [a, 0],
    [x3, y3]
];
