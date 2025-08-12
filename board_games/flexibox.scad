
use <common/list_functions.scad>

// Goal: test a variety of flexible surfaces to hopefully enable
//       boxes that unfold for use in-game

// Generates an unfurled prism where thicker sections of the material
// are the walls and the thinner sections are the joinery
module flexibox(
  wall_length,
  wall_widths, // list of widths
  layer_height,
  base_layer_count,
  wall_layer_count, // doesn't count the base layers
  distance_between_walls // hinge length
) {
  cube(
    [
      list_sum(wall_widths) + distance_between_walls * (len(wall_widths) - 1),
      wall_length,
      layer_height * base_layer_count,
    ]
  );
  for (i = [0:len(wall_widths) - 1]) {
    translate(
      [
        list_sum(wall_widths, end=i + 1) + i * distance_between_walls,
        0,
        layer_height * base_layer_count,
      ]
    )
      cube(
        [
          wall_widths[i],
          wall_length,
          layer_height * wall_layer_count,
        ]
      );
  }
}
