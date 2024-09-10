
$fn = 60;

module wing() {
    translate([0,3,0])
        rotate([90,0,0])
            linear_extrude(3)
                difference() {
                    polygon([
                        [0, 0],
                        [73, 0],
                        [73, 20],
                        [0, 6]
                    ]);
                    translate([67, 13, 0])
                        circle(2.5);
                }
}

module screws() {
    // Screw head is 9.5mm diameter (r=4.25)
    // Screws are 42.5mm apart (measured from far edges)
    //  --> Screw holes are 33mm apart (42.5 - 4.25 - 4.25)
    module screw() {
        cylinder(2, d=5.5);
        translate([0,0,2])
            cylinder(25, d=10);
    }
    screw();
    translate([33, 0, 0])
        screw();
}

module main() {
    module body() {    
        cube([73, 18, 2]);
        translate([0, 0, 2])
            cube([62, 18, 4]);
        translate([62, 18, 2])
            rotate([90,0,0])
                linear_extrude(18)
                    polygon([
                        [0, 0],
                        [4, 0],
                        [0, 4]
                    ]);
        wing();
        translate([0, 15, 0])
            wing();
    }
    difference() {
        body();
        translate([17.5, 9, 0])
            screws();
    }
    
}

main();
