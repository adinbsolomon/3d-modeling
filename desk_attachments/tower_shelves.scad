$fn = 180;

pipe_side_length = 25.5;
pipe_diameter = 16.2;
desk_to_crosspipe_height = 126.5;

pipe_grabber_thickness = (pipe_side_length - pipe_diameter) / 2;
pipe_grabber_width = pipe_diameter + pipe_grabber_thickness;
module pipe_grabber(width) {
    module profile() {
        module outer_shape() {
            union() {
                translate([
                    -pipe_grabber_width/4,
                    0,
                    0
                ]) square([pipe_grabber_width/2, pipe_grabber_width], center=true);
                circle(d=pipe_grabber_width);
            }
        }
        difference() {
            outer_shape();
            circle(d=pipe_diameter);
            translate([
                -pipe_grabber_width / 2,
                -pipe_grabber_width / 2,
                0,
            ]) square([
                    pipe_grabber_width,
                    pipe_grabber_width / 2
            ]);
        }
    }
    module pipe_grabber_half(width) {
        translate([0,pipe_grabber_width/2,0])
        rotate([90,0,90])
        linear_extrude(height = width)
        profile();
    }

    pipe_grabber_half(width);
}

bin_width = 200;
bin_depth = 75;
bin_height = desk_to_crosspipe_height + pipe_side_length;
bin_wall_thickness = 2;
bin_floor_thickness = 0.4;
module bin() {
    difference() {
        cube([
            bin_width,
            bin_depth,
            bin_height
        ]);
        translate([
            bin_wall_thickness,
            bin_wall_thickness,
            bin_floor_thickness
        ]) cube([
            bin_width - 2*bin_wall_thickness,
            bin_depth - 2*bin_wall_thickness,
            bin_height - bin_floor_thickness
        ]);
    }
}

module main() {
    pg_width = 1.5 * pipe_diameter;
    pg_height = bin_height - pipe_grabber_width/2;
    module back_pipe_grabbers() {
        translate([
            pipe_diameter,
            bin_depth,
            pg_height
        ]) pipe_grabber(width = pg_width);
        translate([
            bin_width - pg_width - pipe_diameter,
            bin_depth,
            pg_height
        ]) pipe_grabber(width = 1.5 * pipe_diameter);
    }
    module side_pipe_grabbers() {
        module pg() {
            translate([0,pg_width,0])
            rotate([0,0,-90])
            pipe_grabber(width = pg_width);
        }

        translate([
            bin_width,
            pipe_diameter,
            pg_height
        ]) pg();
        // translate([
        //     bin_width,
        //     bin_depth - pg_width - pipe_diameter,
        //     pg_height
        // ]) pg();
    }

    bin();
    back_pipe_grabbers();
    side_pipe_grabbers();
}

main();
