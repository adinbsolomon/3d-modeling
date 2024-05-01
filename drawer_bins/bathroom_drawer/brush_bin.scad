
use <../bin.scad>

// 1 inch = 25.4 mm

bin(
    2.5 * 25.4,
    249,  // 10 * 25.4  // build plate for prusa mk4 is 250mm
    1.5 * 25.4,
    1,
    0.4
);
