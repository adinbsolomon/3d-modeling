
use <common/list_functions.scad>

// A laptop stand that attaches to a small drawer stack that I own.
// - Should hold standing vertically
//   - A keyboard on its long side
//   - Up to three laptops on their short sides

// Model parameters
layer_thickness = 0.1;
floor_thickness = 0.3;
slanted_floor_height = 1;
thickness_of_bar_attachment = 3;
end_block_height = 10;
number_of_leaning_objects = 8;
width = 50;

// Measurements are in mm
diameter_of_bar = 10;
distance_from_foot_to_bottom_of_bar = 13;
distance_from_foot_to_top_of_bar = distance_from_foot_to_bottom_of_bar + diameter_of_bar;
thickness_of_shelf_board = 32;
difference_in_length_between_drawers_and_shelf = 10;
distance_from_drawers_to_foot_of_keyboard = 38;
thickness_of_leaning_object = 10;
capacity_beyond_keyboard = number_of_leaning_objects * thickness_of_leaning_object;

// Notable points
x_of_center_of_bar = 0.5*diameter_of_bar+thickness_of_bar_attachment;
height_of_center_of_bar = distance_from_foot_to_bottom_of_bar + 0.5*diameter_of_bar;
distance_under_overhang = thickness_of_bar_attachment + 0.8*diameter_of_bar;
height_of_clasp_lower_arm = distance_from_foot_to_bottom_of_bar + 0.2*diameter_of_bar;
height_of_clasp_upper_arm = distance_from_foot_to_top_of_bar - 0.3  *diameter_of_bar;
height_of_clasp_head = distance_from_foot_to_top_of_bar + thickness_of_bar_attachment;
distance_to_foot_of_keyboard = thickness_of_bar_attachment + diameter_of_bar + distance_from_drawers_to_foot_of_keyboard;
distance_to_end_of_keyboard = distance_to_foot_of_keyboard + thickness_of_leaning_object;
start_of_leaning_objects = distance_to_end_of_keyboard + 2*end_block_height;


module main() {
  points = concat(
    [
      // Bar Attachment
      [distance_under_overhang, 0],
      [distance_under_overhang, height_of_clasp_upper_arm],
      [0, height_of_clasp_upper_arm],
      [0, height_of_clasp_head - 1.5*thickness_of_bar_attachment],
      [1.5*thickness_of_bar_attachment, height_of_clasp_head],
      [distance_under_overhang, height_of_clasp_head],
      // Keyboard Footing
      [distance_to_foot_of_keyboard, floor_thickness],
      [distance_to_end_of_keyboard, slanted_floor_height],
      [distance_to_end_of_keyboard, end_block_height]
    ], // Leaning Object Slants
    join_list_of_lists([ for(i = [0 : number_of_leaning_objects - 1])
      [
        [start_of_leaning_objects + i*thickness_of_leaning_object, floor_thickness],
        [start_of_leaning_objects + (i+1)*thickness_of_leaning_object, slanted_floor_height]
      ]
    ]),
    [ // End Block
      [start_of_leaning_objects + number_of_leaning_objects*thickness_of_leaning_object, end_block_height],
      [start_of_leaning_objects + number_of_leaning_objects*thickness_of_leaning_object + 2*end_block_height, 0]
    ]
  );

  translate([0, width, 0])
    rotate([90, 0, 0])
      linear_extrude(width)
        difference() {
          polygon(points);
          translate([x_of_center_of_bar, height_of_center_of_bar, 0])
            circle(d=diameter_of_bar);
          square([distance_under_overhang, height_of_clasp_upper_arm]);
        }
};

main();
