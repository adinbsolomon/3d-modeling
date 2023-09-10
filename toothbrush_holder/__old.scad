
////////////////////
//                //
//  Measurements  //
//                //
////////////////////

// Notes:
// - Measurements are taken from a frontal perspective, while
//   subject is standing

// Sophie's Electric Toothbrush
// - the base of the toothbrush is an unusual oval shape and
//   narrows towards the top
tb1_depth = 32;
tb1_width = 28;
tb1_height = 170;

// Adin/Sophie's Non-Electric Toothbrushes
tb2_depth = 10;
tb2_width = 13;
tb2_height = 180;

// Sophie's Toothpaste
tp1_depth = -1;
tp1_width = -1;
tp1_height = 150;

// Adin's Toothpaste
tp2_bottom_depth = 20;
tp2_bottom_width = 60;
tp2_top_depth = 38;
tp2_top_width = 40;
tp2_height = 200;

/////////////
//         //
//  Model  //
//         //
/////////////

base_depth = 300;
base_width = 100;
base_height = 100;

module base() {
    difference() {
        cube([base_width, base_depth, base_height]);
        translate([
            0,
            20,
            40
        ]) cube([base_width, base_depth - 40, base_height - 60]);
    }
}

module toothbrush(depth, width, height) {
    diameter = max(depth, width);
    cylinder(height, d=diameter);
}

module toothpaste(bottom_depth, bottom_width, top_depth, top_width, height) {
    diameter = max(bottom_depth, bottom_width, top_depth, top_width);
    cylinder(height, d=diameter);
}

module tb1() {
    toothbrush(tb1_depth, tb1_width, tb1_height);
}

module tb2() {
    toothbrush(tb2_depth, tb2_width, tb2_height);
}

module tp1() {
    assert(false, "Not Implemented");
};

module tp2() {
    toothpaste(tp2_bottom_depth, tp2_bottom_width, tp2_top_depth, tp2_top_width, tp2_height);
}

////////////
//        //
//  Main  //
//        //
////////////

module main() {
    difference() {
        base();
        translate([
            base_width / 2,
            50,
            20
        ]) tp2();
        translate([
            base_width / 2,
            100,
            20
        ]) tb2();
        
    }
}

main();
