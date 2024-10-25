use <../../drawer_bins/bin.scad>
use <../../common/triangle.scad>
use <../../common/prism.scad>
use <../../common/list_functions.scad>

// Box and Card Dimensions
box_side_length = 254;
max_bin_height = 79 - 5.6 - 20; // 52.4 = Box height - rule books thickness - board thickness
card_width = 66.3;
card_height = 99.1;

// Bin construction
bin_floor_thickness = 0.4;
bin_wall_thickness = 1;
bin_width = card_height + 2 * bin_wall_thickness + 3; // 3mm wiggle room for cards
module card_bin(card_stack_thickness_list) {

    // - Cards need to be on a slant to stand up on their side
    max_height = max_bin_height - bin_floor_thickness; // 52
    minimum_card_tilt = asin(max_height / card_width); // ~52 (total coincidence lol)
    tilted_card_shadow = sqrt(card_width ^ 2 - max_height ^ 2); // ~41.5

    module main_bin(bin_length) {
        bin(
            bin_length,
            bin_width,
            max_bin_height,
            bin_wall_thickness,
            bin_floor_thickness
        );
    }

    module tilt_support() {
        prism(
                right_triangle(tilted_card_shadow, max_height),
                bin_width
            );
    }

    // A static divider could be parallel to the cards (same tilt angle), but getting cards
    // would be difficult. Instead the divider should have a wider footprint so cards on the
    // underside can be tilted up to be removed. Let's try ~10 degree difference for card pickup.
    divider_height = 40; // lower than bin height makes the card placement look natural
    divider_footprint = 11;
    divider_overhang = 20;
    module static_divider() {
        prism(
            [
                [0, 0],
                [divider_footprint, 0],
                [- divider_overhang + 1, divider_height], // Divider should have a small flat top
                [- divider_overhang, divider_height]
            ],
            bin_width
        );
    }

    // Subtract this from the rest of the bin to make fingertip access
    fingertip_access_diameter = 20;
    module fingertip_access_negative(bin_length) {
        translate([0, bin_width / 2, max_bin_height])
            rotate([90, 0, 90])
                cylinder(d=20, h=bin_length);
    }

    module main() {
        // Calculate bin_length from stack count and thicknesses
        bin_length = 2 * bin_wall_thickness +
            tilted_card_shadow +
            list_sum(card_stack_thickness_list) +
            (len(card_stack_thickness_list) - 1) * divider_footprint;
        echo("Total bin length: ", bin_length);

        difference() {
            union() {
                main_bin(bin_length); // add param
                translate([bin_wall_thickness, 0, bin_floor_thickness])
                    tilt_support();
                for (stack_num = [0:len(card_stack_thickness_list) - 2]) {
                    translate(
                        [
                            bin_wall_thickness + tilted_card_shadow +
                                list_sum(list_sublist(card_stack_thickness_list, 0, stack_num + 1)) + 
                                stack_num * divider_footprint,
                            0,
                            bin_floor_thickness
                        ]
                    )
                        static_divider();
                }
            }
            fingertip_access_negative(bin_length);
        }
    }

    main();
}

stack_base = 42;
stack_ix = 22;
stack_immo = 20;
stack_uprising = 48;
stack_staples = 16;
stack_staples_uprising = 12;
stack_tleilax = 13;
stack_starting = 33;
stack_hagal = 15;
stack_uprising_misc = 30;

// All cards width is more than the box's inner sidelengths, so dividing them up is needed
// - Imperium decks: 132mm (base, ix, immo, uprising)
// - Staples and Tleilax: 41mm (base, uprising, immo)
// - Starting: 33mm + ??? (base, uprising)
// - Misc: 45mm (hagal, uprising hagal, misc)

card_bin([
    stack_base,
    stack_ix + stack_immo,
    stack_uprising,
    stack_staples + stack_staples_uprising
]);
