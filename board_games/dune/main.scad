
include <measurements.scad>

use <cards_holder.scad>
use <game_box.scad>

bin_width = 104.1;

module game_box() {
    difference() {
        // No need to translate inserts above the floor
        translate([-_m_box_wall_thickness, -_m_box_wall_thickness, 0])
            _game_box();
        // Line for Rulebooks
        translate([
            -0.5 * _m_box_wall_thickness,
            -0.5 * _m_box_wall_thickness,
            _m_box_height - _m_rulebook_thickness
        ])
            cube([
                _m_box_length + _m_box_wall_thickness,
                _m_box_length + _m_box_wall_thickness,
                0.5
            ]);
    }

}

module main() {
    game_box();
    translate([_m_box_length / 2, 0, 0])
        _cards_holder_lined_bin(_m_box_length / 2);
    translate([_m_box_length / 2, bin_width, 0])
        rotate([0, 0, 180])
            _cards_holder_default_bin(_m_box_length / 2);
}

main();
