
max_print_width = 250; // millimeters
print_thickness = 5;
print_height = 80;
wall_to_fridge = 210;
wall_tile_thickness = 10;
counter_to_fridge_a = 15;
counter_to_fridge_b = 13; // at max_print_width from wall
counter_thickness = 31;
counter_overhang = 10;
overhang_thickness = 2;

module overhang() {
  // TODO: maybe make this a sloped plane instead?
  cube([counter_overhang, max_print_width - wall_tile_thickness, overhang_thickness]);
}

module fence() {
  // the counter will extend from origin towards +x and the countertop
  // will be the xz plane
  rotate([0, -90, 0])
    linear_extrude(print_thickness)
      polygon(
        [
          [-counter_thickness, 0],
          [-counter_thickness, max_print_width],
          [print_height, max_print_width],
          [print_height, 0],
        ]
      );
}

module wedge() {
  rotate([0, 180, 0])
    translate([0, 0, -print_height])
      linear_extrude(print_height + counter_thickness)
        polygon(
          [
            [0, 0],
            [0, max_print_width - wall_to_fridge],
            [counter_to_fridge_a, max_print_width - wall_to_fridge],
            [counter_to_fridge_b, 0],
          ]
        );
}

module main() {
  overhang();
  fence();
  wedge();
}

main();
