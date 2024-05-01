
use <../bin.scad>
use <teeth_care_bin.scad>

// 1 inch = 25.4 mm

width = 3 * 25.4;
depth = 2 * 25.4;
height = 1.5 * 25.4;

bin(width, depth, height, 1, 0.4);
translate([width/2,depth+2,0]) rotate([0,0,180]) connection_male();
