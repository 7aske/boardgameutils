/* [General] */

Generate_top = true;
Generate_bottom = true;
Bottom_window = true;

// Size of the Chamfer (0 - disable)
Chamfer_size = 1; // [0:1:9]

/* [Extrusion] */

// Width of the nozzle
Extrusion_width = 0.4; // [0.1:0.1:1.0]
// Extrusion lines per wall
Extrusion_lines = 2;  // [1:1:10]

/* [Token parameters] */

// Height of the token in mm
Token_height = 2.5;

// Token height
Token_length = 17.6;

// Token width
Token_width = 17.6;

// Horizontal distance from the edge to window
Capsule_window_frame_length = 14;
// Vertical distance from the edge to window
Capsule_window_frame_width = 14;

//------------------------ DERIVED CONSTANTS ------------------------
wall_width = Extrusion_width * Extrusion_lines;
lower_lip_height = Extrusion_width * Extrusion_lines;

capsule_height = Token_height + lower_lip_height;
window_length = Token_length - Capsule_window_frame_length;
window_width = Token_width - Capsule_window_frame_width;


//------------------------ MODULES ------------------------
module rounded_cube(size, radius) {
    minkowski() {
        cube(size - [radius*2, radius*2, 0]);
        cylinder(r = radius, h = 0.01, center = true, $fn = 32);
    }
}

module base_capsule() {
    difference() {
        union() {
            // lip base
            translate([0, 0, 0]) {
                rounded_cube([Token_length + wall_width * 2, Token_width + wall_width * 2, lower_lip_height], Chamfer_size);
            }
            // token container
            translate([wall_width / 2, wall_width / 2, lower_lip_height]) {
                rounded_cube([Token_length + wall_width, Token_width + wall_width, Token_height], Chamfer_size);
            }
        }

        if (Bottom_window) {
            union() {
                translate([0, 0, Token_height]) {
                    translate([wall_width, wall_width, -Token_height + lower_lip_height]) {
                        rounded_cube([Token_length, Token_width, Token_height * 2], Chamfer_size);
                    }
                    translate([wall_width + window_length / 2, wall_width + window_width / 2, -capsule_height * 3 / 2]) {
                        rounded_cube([Token_length - window_length, Token_width - window_width, capsule_height * 3], Chamfer_size);
                    }
                }
            }
        } else {
            translate([wall_width, wall_width, lower_lip_height]) {
                rounded_cube([Token_length, Token_width, Token_height * 2], Chamfer_size);
            }
        }
    }
}

module top_capsule() {
    translate([Token_length + 15, 0, 0]) {
        difference() {
            union() {
                rounded_cube([Token_length + wall_width * 2, Token_width + wall_width * 2, Token_height + lower_lip_height], Chamfer_size);
            }
            union() {
                translate([wall_width / 2, wall_width / 2, lower_lip_height]) {
                    // +1 for z-fighting to disappear
                    rounded_cube([Token_length + wall_width, Token_width + wall_width, Token_height + 1], Chamfer_size);
                }
                translate([wall_width + window_length / 2, wall_width + window_width / 2, -1]) {
                    // -1 for z-fighting to disappear
                    rounded_cube([Token_length - window_length, Token_width - window_width, capsule_height], Chamfer_size);
                }
            }
        }
    }
}

//------------------------ MAIN EXECUTION ------------------------
if (Generate_bottom) {
    base_capsule();
}
if (Generate_top) {
    top_capsule();
}
