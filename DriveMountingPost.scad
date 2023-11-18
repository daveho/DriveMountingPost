// 3D-printed 3.5" drive mount posts

// Idea is to print 4 of these; they hold two drives
// securely, allow front access (e.g., for inserting
// media), and can be screwed down. M3 screws are
// assumed for securing the drives. 6-32 screws are
// assumed for screwing the posts to whatever surface
// the posts are attached to.

$fn = 60;

// ----------------------------------------------------------------------
// design parameters (all units are mm)
// ----------------------------------------------------------------------

// main post dimensions
post_h = 64;
post_w = 16;
post_d = 3;

// how deep the foot extends back from the "front" of the post
foot_d = post_w;

brace_side_len = foot_d;

// how far below center of drive screw hole the top surface
// of the support ledge should be
ledge_offset_h = 6;

// ledge depth
ledge_d = 3;

// thickness of ledge above the bevel (so there isn't a sharp edge)
ledge_h = 1;

// drive placement
drive_clearance_h = 20; // how far above the surface the bottom drive is placed
drive_separation_h = 30; // separation, bottom of bottom drive to bottom of top drive

bottom_drive_h = drive_clearance_h;
top_drive_h = bottom_drive_h + drive_separation_h;

// M3 screw hole diameter
m3_hole_diameter = 3.2;

// 6-32 screw hole diameter (these are a bit larger than M3)
n6_hole_diameter = 3.6;

// "countersink" diameter and depth (so that screw holes are recessed slightly)
m3_countersink_diameter = 7.2;
n6_countersink_diameter = 9;
countersink_d = 1;

// ----------------------------------------------------------------------
// component modules
// ----------------------------------------------------------------------

// triangular brace to help keep the post rigid with respect to the foot
module foot_brace() {
    translate([post_d, brace_side_len, 0]) {
        rotate([90, 0, 270]) {
            linear_extrude(post_d) {
                polygon([[0, 0], [brace_side_len, 0], [0, brace_side_len]]);
            }
        }
    }
}

// trangular "bevel" below the drive ledge
module ledge_bevel() {
    rotate([90, 90, 90]) {
        linear_extrude(post_w) {
            polygon([[0, 0], [ledge_d, 0], [0, ledge_d]]);
        }
    }
}

// drive "ledge"; z reference is the surface that the
// drive sits on
module ledge() {
    translate([0, 0, -ledge_h]) {
        cube([post_w, ledge_d, ledge_h]);
        ledge_bevel();
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
    translate([0, -brace_side_len, post_d]) {
        foot_brace();
    }
    translate([post_w - post_d, -brace_side_len, post_d]) {
        foot_brace();
    }

    // ledge for bottom drive
    translate([0, post_d, top_drive_h]) {
        ledge();
    }

    // ledge for top drive
    translate([0, post_d, bottom_drive_h]) {
        ledge();
    }
}

// Cylinder to be subtracted to create a screw hole for a drive.
// Reference is center of hole in the x/z plane. The cylinder extends
// 10mm in both directions, so it should be able to "punch through"
// the solid post as needed.
module drive_screw_hole() {
    translate([0, -10, 0]) {
        rotate([-90, 0, 0]) {
            cylinder(h=20, d=m3_hole_diameter);
        }
    }
}

// cylinder for the foot screw hole
module foot_screw_hole() {
    translate([0, 0, -10]) {
        cylinder(h=20, d=n6_hole_diameter);
    }
}

// countersink cylinder for punching into a vertical surface
// (i.e., the drive post)
module countersink(diameter) {
    translate([0, countersink_d, 0]) {
        rotate([90, 0, 0]) {
            cylinder(h=5, d=diameter);
        }
    }
}

// countersink cylinder for punching into a horizontal surface
// (i.e., the foot)
module countersink_horiz(diameter) {
    translate([0, 0, post_d]) {
        rotate([-90, 0, 0]) {
            countersink(diameter);
        }
    }
}

// ----------------------------------------------------------------------
// complete drive post module
// ----------------------------------------------------------------------


// post with screw holes and countersinks
module post() {
    difference() {
        post_body();

        // screw hole for bottom drive
        translate([post_w/2, 0, bottom_drive_h + ledge_offset_h]) {
            drive_screw_hole();
            countersink(m3_countersink_diameter);
        }

        // screw hole for top drive
        translate([post_w/2, 0, top_drive_h + ledge_offset_h]) {
            drive_screw_hole();
            countersink(m3_countersink_diameter);
        }

        // screw hole for foot
        translate([foot_d/2, -foot_d/2, 0]) {
            foot_screw_hole();
            countersink_horiz(n6_countersink_diameter);
        }
    }
}

// can uncomment these for testing...
//post_body();
//foot_brace();
//ledge();
//ledge_bevel();
//drive_screw_hole();
//countersink();
//countersink_horiz();
//foot_screw_hole();

// generate the post
post();
