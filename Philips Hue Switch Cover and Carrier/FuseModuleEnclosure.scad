$fn = 30;

make_lid = false;
make_body = true;

module_width = 34.9;
module_inner_length = 84.1;
module_outer_length = 91.9;
module_height = 30;
module_radius = 2;
slide_depth = 16.8;
slide_notch_thickness = 2.2;
slide_notch_wall_width = 1.8;
slide_radius = 2;
slide_width = 4;
lock_channel_width = 8;
lock_height = 8.4; // relative to slide
lock_thickness = 1.4;
lock_depth = 2.2;
lid_depth = 6;
lid_wall_thickness = 2;
lid_inner_radius = 2;
internal_width = 30;
internal_length = 78;
body_screw_diameter = 2.6;
lid_screw_diameter = 3;
lid_screw_head_diameter = 6;
lid_screw_head_depth = 3;

main();

module main() {

    if(make_body) {
        difference() {
        body();
            translate([15,0,0]) cube([module_outer_length + 1, module_width + 1, module_height + 1], center=true);
        }
    }
    
    if(make_lid) {
        translate([0,80,0]) {
            difference() {
                lid();
                lid_screws();
            }
        }
    }
}

module lid(clearance = 0) {
    mirror([0,0,1]) {
    translate([0,0,-module_height/2]) {
        difference() {
            translate([0,0,clearance/2]) {
                roundedcube([module_inner_length + clearance, module_width + clearance, module_height + clearance], center=true, radius=slide_radius);
            }
            translate([0,0,-lid_depth]) {
                cube([module_inner_length+1, module_width+1, module_height], center=true);
            }
            translate([0,0,-lid_wall_thickness]) {
                roundedcube([module_inner_length - 2 * lid_wall_thickness, module_width - 2 * lid_wall_thickness, module_height], center=true, radius=lid_inner_radius, apply_to="z");
            }
//        cube([20,100,100], center=true);
        }
    }
    lid_posts();
    }
}

module lid_posts() {
    lid_post();
    rotate([0,0,180]) lid_post();
    mirror([1,0,0]) lid_post();
    mirror([1,0,0]) rotate([0,0,180]) lid_post();
}

module lid_post() {
    translate([module_inner_length/2 - 4, module_width/2 - 4,-lid_depth/2]) {
        cylinder(h = lid_depth, r = 3, center=true);
    }
}

module lid_screws() {
    lid_screw();
    rotate([0,0,180]) lid_screw();
    mirror([1,0,0]) lid_screw();
    mirror([1,0,0]) rotate([0,0,180]) lid_screw();
}

module lid_screw() {
    translate([module_inner_length/2 - 4, module_width/2 - 4, lid_depth/2]) {
        cylinder(h = lid_depth + 0.1, d = lid_screw_diameter, center=true);
        translate([0,0,-lid_screw_head_depth]) {
            cylinder(h = lid_screw_head_depth, d = lid_screw_head_diameter, center=true);
        }
    }
}


module body() {

    difference() {
        union() {
            roundedcube([module_outer_length, module_width, slide_depth], center=true, radius=slide_radius, apply_to="z");
            roundedcube([module_inner_length, module_width, module_height], center=true, radius=module_radius);
        }
        slots();
        locks();
        translate([0,0,module_height/2]) rotate([180,0,0]) lid(clearance = 0.2);
        translate([0,0,lid_wall_thickness]) {
            cube([internal_length, internal_width - 10, module_height], center=true);
            cube([internal_length - 10, internal_width, module_height], center=true);
        }
        body_screws();
    }
}

module body_screws() {
    body_screw();
    rotate([0,0,180]) body_screw();
    mirror([1,0,0]) body_screw();
    mirror([1,0,0]) rotate([0,0,180]) body_screw();
}

module body_screw() {
    translate([module_inner_length/2 - 4, module_width/2 - 4,lid_depth/2]) {
        cylinder(h = module_height, d = body_screw_diameter, center=true);
    }
}

module slots() {
    slot();
    rotate([0,0,180]) {
        slot();
    }
}

module slot() {
    translate([module_inner_length/2 + slide_notch_thickness/2,0]) {
        cube([slide_notch_thickness, module_width - 2 * slide_notch_wall_width, slide_depth + 0.2], center=true);
        translate([(module_outer_length - module_inner_length)/2+0.1,0,0]) {
            cube([module_outer_length - module_inner_length,module_width - 2 * slide_width,slide_depth + 0.2], center=true);
        }
    }
}

module locks() {
    lock();
    rotate([0,0,180]) {
        lock();
    }
}

module lock() {
    translate([(module_inner_length - lock_depth)/2,0,0]) {
        translate([0,0,lock_height + lock_thickness/2]) {
            cube([lock_depth + 0.1,lock_channel_width, slide_depth], center=true);
        }
        translate([0,0,-lock_height - lock_thickness/2]) {
            cube([lock_depth + 0.1,lock_channel_width, slide_depth], center=true);
        }
    }
}


// The roundedcube function, shamelessy lifted from:
// https://danielupshaw.com/openscad-rounded-corners/
module roundedcube(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all") {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate_min = radius;
	translate_xmax = size[0] - radius;
	translate_ymax = size[1] - radius;
	translate_zmax = size[2] - radius;

	diameter = radius * 2;

	module build_point(type = "sphere", rotate = [0, 0, 0]) {
		if (type == "sphere") {
			sphere(r = radius);
		} else if (type == "cylinder") {
			rotate(a = rotate)
			cylinder(h = diameter, r = radius, center = true);
		}
	}

	obj_translate = (center == false) ?
		[0, 0, 0] : [
			-(size[0] / 2),
			-(size[1] / 2),
			-(size[2] / 2)
		];

	translate(v = obj_translate) {
		hull() {
			for (translate_x = [translate_min, translate_xmax]) {
				x_at = (translate_x == translate_min) ? "min" : "max";
				for (translate_y = [translate_min, translate_ymax]) {
					y_at = (translate_y == translate_min) ? "min" : "max";
					for (translate_z = [translate_min, translate_zmax]) {
						z_at = (translate_z == translate_min) ? "min" : "max";

						translate(v = [translate_x, translate_y, translate_z])
						if (
							(apply_to == "all") ||
							(apply_to == "xmin" && x_at == "min") || (apply_to == "xmax" && x_at == "max") ||
							(apply_to == "ymin" && y_at == "min") || (apply_to == "ymax" && y_at == "max") ||
							(apply_to == "zmin" && z_at == "min") || (apply_to == "zmax" && z_at == "max")
						) {
							build_point("sphere");
						} else {
							rotate = 
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] :
								[0, 0, 0]
							);
							build_point("cylinder", rotate);
						}
					}
				}
			}
		}
	}
}
