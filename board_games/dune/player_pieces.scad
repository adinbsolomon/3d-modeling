
// Units in millimeters

use <../../common/trapezoid.scad>
use <../../common/triangle.scad>
use <../../common/list_functions.scad>

// Utility funcs

module stand_upright(depth) {
    translate([0,agent_depth,0])
    rotate([90,0,0])
    children();
}

// Pieces

troop_side_length = 8;
module troop() {
    cube([troop_side_length, troop_side_length, troop_side_length]);
}

tracker_diameter = 16;
tracker_height = 10;
module tracker() {
    translate([
        tracker_diameter / 2,
        tracker_diameter / 2,
        0
    ]) cylinder(h=tracker_height, d=tracker_diameter);
}

flag_width = 18;
flag_depth = 21.5;
flag_depth_inner = 17;
flag_height = 2;
module flag() {
    difference() {
        cube([
            flag_width,
            flag_depth,
            flag_height
        ]);
        linear_extrude(height=flag_height)
        polygon(points=equilateral_triangle(flag_width, flag_depth-flag_depth_inner));
    }
}

combat_token_side_length = 16;
combat_token_height = 2;
module combat_token() {
    cube([combat_token_side_length, combat_token_side_length, combat_token_height]);
}

// Agent is made of three sections
agent_base_width = 11.5;
agent_waist_width = 8.25;
agent_waist_height = 7.4;
agent_elbow_width = 14;
agent_elbow_height_from_waist = 3.3;
agent_shoulder_width = 7;
agent_torso_height = 7;
agent_neck_width = 5.1;
agent_neck_height = 0.7;
agent_head_width = 5.8;
agent_height = 24.5;
agent_depth = 10;
module agent() {
    module extrude() {
        linear_extrude(height=agent_depth) children();
    }
    module base() {
        extrude()
        polygon(points=trapezoid(
            agent_base_width,
            agent_waist_width,
            agent_waist_height
        ));
    }
    module midsection() {
        extrude()
        polygon(points=trapezoid(
            agent_waist_width,
            agent_elbow_width,
            agent_elbow_height_from_waist
        ));
    }
    module torso() {
        extrude()
        polygon(points=trapezoid(
            agent_elbow_width,
            agent_shoulder_width, 
            agent_torso_height
        ));
    }
    module neck() {
        extrude()
        square([agent_neck_width, agent_neck_height]);
    }
    module head() {
        extrude()
        polygon(points=equilateral_triangle(
            agent_head_width,
            agent_height-(
                agent_neck_height +
                agent_torso_height +
                agent_elbow_height_from_waist +
                agent_waist_height
            )
        ));
    }

    translate([
        (agent_elbow_width-agent_base_width)/2,
        0,
        0]
    ) base();
    translate([
        0,
        agent_waist_height,
        0
    ]) midsection();
    translate([
        0,
        agent_waist_height+agent_elbow_height_from_waist,
        0
    ]) torso();
    translate([
        (agent_elbow_width-agent_neck_width)/2,
        agent_waist_height+agent_elbow_height_from_waist+agent_torso_height,
        0
    ]) neck();
    translate([
        (agent_elbow_width-agent_head_width)/2,
        agent_waist_height+agent_elbow_height_from_waist+agent_torso_height+agent_neck_height,
        0
    ]) head();
}


dreadnought_top_width = 2.8;
dreadnought_top_height = 2.3;
dreadnought_cap_width = 5.3;
dreadnought_cap_height = 2.1;
dreadnought_body_width = 10;
dreadnought_body_height = 18 - dreadnought_top_height - dreadnought_cap_height;
dreadnought_fin_width = 13.2;
dreadnought_fin_base_height = 6.8;
dreadnought_fin_outer_height = 3;
dreadnought_fin_heel_height = 1.3;
dreadnought_inter_fin_width = 5.2;
dreadnought_lower_fin_base_width = 1.5;
dreadnought_lower_fin_bottom_width = 2.8;
dreadnought_fin_inter_base_width = (dreadnought_fin_width - dreadnought_body_width) / 2;
dreadnought_depth = 10;
module dreadnought(standing_upright=false) {
    module extrude() {
        linear_extrude(height=dreadnought_depth) children();
    }
    module top() {
        extrude()
        polygon(points=trapezoid(
            dreadnought_cap_width,
            dreadnought_top_width,
            dreadnought_top_height
        ));
    }
    module cap() {
        extrude()
        polygon(points=trapezoid(
            dreadnought_body_width,
            dreadnought_cap_width,
            dreadnought_cap_height
        ));
    }
    module body() {
        extrude()
        square([dreadnought_body_width, dreadnought_body_height]);
    }
    module fins() {
        module fin() {
            translate([dreadnought_fin_inter_base_width,0,0])
            rotate([0,0,90])
            extrude()
            polygon(points=trapezoid(
                dreadnought_fin_base_height,
                dreadnought_fin_outer_height,
                dreadnought_fin_inter_base_width
            ));
            translate([dreadnought_fin_inter_base_width+(dreadnought_lower_fin_base_width-dreadnought_lower_fin_bottom_width)/2,0,0])
            extrude()
            polygon(points=trapezoid(
                dreadnought_lower_fin_base_width,
                dreadnought_lower_fin_bottom_width,
                dreadnought_fin_heel_height
            ));
        }
        fin();
        translate([
            dreadnought_body_width + dreadnought_fin_outer_height,
            0,
            0
        ]) mirror([1,0,0]) fin();
    }

    translate([
        (dreadnought_fin_width-dreadnought_cap_width)/2,
        dreadnought_cap_height+dreadnought_body_height+dreadnought_fin_heel_height,
        0
    ]) top();
    translate([
        (dreadnought_fin_width-dreadnought_body_width)/2,
        dreadnought_body_height+dreadnought_fin_heel_height,
        0
    ]) cap();
    translate([
        (dreadnought_fin_width-dreadnought_body_width)/2,
        dreadnought_fin_heel_height,
        0
    ]) body();
    translate([
        0,
        0,
        0
    ]) fins();
}

atomics_token_depth = 2;
atomics_token_width = 34.3;

module display_all_player_pieces() {
    module troops() {
        for (i = [0:3]) {
            for (j = [0:3]) {
                translate([
                    (troop_side_length + 1)*i,
                    (troop_side_length + 1)*j,
                    0
                ]) troop();
            }
        }
    }
    module trackers() {
        for (i = [0:4]) {
            translate([
                (tracker_diameter + 1)*i,
                0,
                0
            ]) tracker();
        }
    }
    module dreadnoughts() {
        dreadnought();
        translate([dreadnought_fin_width + 1.5, 0, 0]) dreadnought();
    }
    module agents() {
        for (i = [0:2]) {
            translate([
                (agent_elbow_width + 1)*i,
                0,
                0
            ]) stand_upright(agent_depth) agent();
        }
    }
    module flags() {
        for (i = [0:2]) {
            translate([
                (flag_width + 0.7)*i,
                0,
                0
            ]) flag();
        }
    }
    
    translations = [
        0,
        combat_token_side_length + 2,
        flag_depth + 2,
        5*troop_side_length + 2,
        tracker_diameter + 2,
        25
    ];
    module t(n) {
        translate([
            0,
            list_sum(
                translations,
                start = 0,
                end = n
            )
        ]) children();
    }
    t(1) combat_token();
    t(2) flags();
    t(3) troops();
    t(4) trackers();
    t(5) dreadnoughts();
    t(6) agents();
}

display_all_player_pieces();
