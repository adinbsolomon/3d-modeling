
use <layer_timeseries.scad>

layer001_height = 20;
module layer001() {
  cube(layer001_height);
}

layer002_height = 10;
module layer002() {
  cube(layer002_height);
}

layer003_height = 5;
module layer003() {
  cube(layer003_height);
}

layer_timeseries(
  [
    layer001_height,
    layer002_height,
    layer003_height,
  ]
) {
  translate([-10, 0, 0])
    cube([10, 10, 40]);
  layer001();
  layer002();
  layer003();
}
