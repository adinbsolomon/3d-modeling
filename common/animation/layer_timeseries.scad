
use <common/list_functions.scad>

module layer_timeseries(layer_heights) {
  // Instructions:
  // - The first child should be the container which moves with the layers
  // - All subsequent children should be the layers themselves
  // - The number of layers should be the same as the number of layer heights
  echo(str("Calling layer_timeseries with ", $children, " children and layer_heights=", layer_heights));
  assert($children - 1 == len(layer_heights));
  layer_count = len(layer_heights);
  total_height = list_sum(layer_heights);
  timestep = 0.01; // TODO: change this based on the number of layers and echo details.
  layer_time = min(floor($t / timestep), layer_count);
  translate([0, 0, -1 * list_sum(layer_heights, 0, layer_time)])
    children(0);
  for (layer_num = [0:layer_count - 1]) {
    layer_height = layer_heights[layer_num];
    if (layer_time > layer_num) {
      echo(str("Layer #", layer_num, " - Past layer (height=", layer_height, ")"));
      translate([0, 0, -1 * list_sum(layer_heights, layer_num, layer_time)])
        children(layer_num + 1);
    }
    if (layer_time == layer_num) {
      echo(str("Layer #", layer_num, " - Current layer (height=", layer_height, ")"));
      children(layer_num + 1);
    }
    if (layer_time < layer_num) {
      echo(str("Layer #", layer_num, " - Future layer (height=", layer_height, ")"));
    }
  }
}
