/* [General] */

Generate_top = true;
Generate_bottom = true;
Bottom_window = true;

// Gap between parts (0 - snug friction fit)
Fit_tolerance = 0;

// Size of the Chamfer (0 - disable)
Chamfer_size = 1;

/* [Extrusion] */

// Width of the nozzle
Extrusion_width = 0.4;
// Extrusion lines per wall
Extrusion_lines = 4;

/* [Token parameters] */

// Height of the token in mm
Token_thickness = 2.5;

// Token height
Token_length = 17.5;

// Token width
Token_width = 17.5;

// Distance from the edge to window
Capsule_window_frame_size = 2;

//------------------------ DERIVED CONSTANTS ------------------------
window_distance = Extrusion_width;
lower_lip_height = Extrusion_width;
capsule_height = Token_thickness + lower_lip_height + window_distance;
wall_width = Extrusion_width * Extrusion_lines;
base_height = capsule_height - Token_thickness - lower_lip_height - window_distance;
cap_offset = capsule_height - window_distance - lower_lip_height;
wall_offset = wall_width - Fit_tolerance;
bottom_x = -Token_length / 2 + wall_offset;
bottom_y = -Token_width / 2 + wall_offset;
inner_lip = Capsule_window_frame_size + wall_width;

echo("Base Height:", base_height);

//------------------------ MODULES ------------------------
module rounded_cube(size, radius) {
    minkowski() {
        cube(size - [radius * 2, radius * 2, 0]);
        cylinder(r = radius, h = 0.01, center = true, $fn = 32);
    }
}

module base_capsule() {
    difference() {
        union() {
            translate([0, 0, 0]) {
                rounded_cube([Token_length + wall_offset * 2, Token_width + wall_offset * 2, lower_lip_height], Chamfer_size);
            }
            translate([wall_offset / 2, wall_offset / 2, lower_lip_height]) {
                rounded_cube([Token_length + wall_offset, Token_width + wall_offset, base_height + Token_thickness], Chamfer_size);
            }
        }

        if (Bottom_window) {
            union() {
                translate([0, 0, (cap_offset + window_distance)]) {
                    translate([wall_offset, wall_offset, - (cap_offset + window_distance) / 2 - lower_lip_height]) {
                        rounded_cube([Token_length, Token_width, Token_thickness * 2], Chamfer_size);
                    }
                    translate([wall_offset + inner_lip / 2, wall_offset + inner_lip / 2, -capsule_height * 3 / 2]) {
                        rounded_cube([Token_length - inner_lip, Token_width - inner_lip, capsule_height * 3], Chamfer_size);
                    }
                }
            }
        } else {
            translate([wall_offset, wall_offset, lower_lip_height + base_height]) {
                rounded_cube([Token_length, Token_width, Token_thickness * 2], Chamfer_size);
            }
        }
    }
}

module top_capsule() {
    difference() {
        union() {
            translate([Token_length + 15, 0, 0]) {
                rounded_cube([Token_length + wall_offset * 2, Token_width + wall_offset * 2, cap_offset + window_distance], Chamfer_size);
            }
        }
        union() {
            translate([Token_length + 15, 0, (cap_offset + window_distance)]) {
                translate([wall_offset / 2, wall_offset / 2, - (cap_offset + window_distance) / 2 - lower_lip_height]) {
                    rounded_cube([Token_length + wall_offset, Token_width + wall_offset, Token_thickness * 2], Chamfer_size);
                }
                translate([wall_offset + inner_lip / 2, wall_offset + inner_lip / 2, -capsule_height * 3 / 2]) {
                    rounded_cube([Token_length - inner_lip, Token_width - inner_lip, capsule_height * 3], Chamfer_size);
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
