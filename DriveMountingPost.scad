// 3D-printed 3.5" drive mount posts

// Idea is to print 4 of these; they hold two drives
// securely, allow front access (e.g., for inserting
// media), and can be screwed down. M3 screws are
// assumed for securing the drives. 6-32 screws are
// assumed for screwing the posts to whatever surface
// the posts are attached to.

$fn = 60;

// design parameters (all units are mm)
post_h = 60;
post_w = 16;
post_d = 3;

foot_d = post_w;

brace_side_len = foot_d - 0;

module foot_brace() {
    translate([post_d, 0, 0]) {
        rotate([90, 0, 270]) {
            linear_extrude(post_d) {
                polygon([[0, 0], [brace_side_len, 0], [0, brace_side_len]]);
            }
        }
    }
}

// body of post: defines the solid shapes, but doesn't
// have the screw holes
module post_body() {
    // main post
    cube([post_w, post_d, post_h]);
    
    // foot
    translate([0, -foot_d, 0]) {
        cube([post_w, foot_d, post_d]);
    }
    
    // diagonal bracing for foot
    translate([0, 0, post_d]) {
        foot_brace();
    }
    translate([post_w - post_d, 0, post_d]) {
        foot_brace();
    }
}

post_body();
//foot_brace();