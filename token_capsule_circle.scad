/* [General] */

Generate_top = true;
Generate_bottom = true;
Bottom_window = true;

/* [Extrusion] */

// Width of the nozzle
Extrusion_width = 0.4; // [0.1:0.1:1.0]
// Extrusion lines per wall
Extrusion_lines = 2;  // [1:1:10]

/* [Token parameters] */

// Height of the token in mm
Token_height = 2.5;

// Token diameter
Token_diameter = 17.6;

// Horizontal distance from the edge to window
Capsule_window_frame_diameter = 5;

//------------------------ DERIVED CONSTANTS ------------------------
wall_width = Extrusion_width * Extrusion_lines;
lower_lip_height = Extrusion_width * Extrusion_lines;

capsule_height = Token_height + lower_lip_height;
window_diameter = Capsule_window_frame_diameter;

//------------------------ MODULES ------------------------

module base_capsule() {
    difference() {
        union() {
            // lip base
            translate([0, 0, 0]) {
                cylinder(d = Token_diameter + wall_width * 4, lower_lip_height);
            }
            // token container
            translate([0, 0, lower_lip_height]) {
                cylinder(d = Token_diameter + wall_width * 2, Token_height);
            }
        }

        if (Bottom_window) {
            union() {
                translate([0, 0, lower_lip_height]) {
                    cylinder(d = Token_diameter, Token_height+1);
                }
                cylinder(d = window_diameter, lower_lip_height, $fn=40);
            }
        } else {
            translate([0, 0, lower_lip_height]) {
                cylinder(d = Token_diameter, Token_height+1);
            }
        }
    }
}

module top_capsule() {
    translate([Token_diameter + 15, 0, 0]) {
        difference() {
            union() {
                cylinder(d = Token_diameter + wall_width * 4, Token_height + lower_lip_height);
            }
            union() {
                translate([0, 0, lower_lip_height]) {
                    cylinder(d = Token_diameter + wall_width * 2, Token_height+1);
                }
                cylinder(d = window_diameter, lower_lip_height, $fn=40);
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
