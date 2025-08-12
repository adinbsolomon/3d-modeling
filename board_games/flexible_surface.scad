
// Goal: test a variety of flexible surfaces to hopefully enable
//       boxes that unfold for use in-game

// Generates an unfurled prism where thicker sections of the material
// are the walls and the thinner sections are the joinery
module flexibox(
  wall_length,
  wall_width,
  layer_height,
  base_layer_count,
  wall_layer_count, // doesn't count the base layers
  distance_between_walls // hinge length
) {
  cube([
    wall_width * 4 + distance_between_walls * 3,
    wall_length,
    layer_height * base_layer_count
  ]);
  for (i = [0 : 3]) {
    translate([
      i * (wall_width + distance_between_walls),
      0,
      layer_height * base_layer_count
    ])
      cube([
        wall_width,
        wall_length,
        layer_height * wall_layer_count
      ]);
  }
}

flexibox(
  wall_length = 30,
  wall_width = 10,
  layer_height = 0.1,
  base_layer_count = 1,
  wall_layer_count = 9,
  distance_between_walls = 2
);