
charger_width = 42;
charger_depth = 54;
charger_height = 22;

charger_dongle_diameter = 6;
charger_dongle_distance_from_back = 35 - charger_dongle_diameter;

width = 150;
depth = charger_width + 4;
height = 120;

module bottom() {
    difference() {
        cube([width, depth, charger_height + 2]);
        translate([
            width - charger_depth,
            2,
            1
        ]) cube([charger_depth, charger_width, charger_height]);
        translate([
            width - charger_dongle_distance_from_back - 3,
            depth / 2,
            charger_height
        ]) cylinder(d=35, h=2);
        translate([
            width - charger_dongle_distance_from_back,
            (depth - charger_dongle_diameter) / 2,
            charger_height + 1
        ]) cube([charger_dongle_distance_from_back, charger_dongle_diameter+0.75, 2]);
    }
}

bottom();
