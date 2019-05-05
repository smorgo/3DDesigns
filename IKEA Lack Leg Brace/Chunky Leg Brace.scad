// Lack Leg Brace
$fn=30;

leg_width = 50;
depth = 75;
length = 150;
wall_thickness = 6;

outer();

module outer() {
    difference() {
        hull() {
            roundedcube(size=[leg_width + wall_thickness, leg_width+wall_thickness,depth],radius=3,apply_to="z");
            translate([length,length,0]) {
                cylinder(d = leg_width/1.5, h = depth/3);
            }
        }
        translate([-4,-4,-4]) {
            roundedcube([leg_width+4,leg_width+4,depth+8],radius=2,apply_to="z");
        }
        translate([length,length,-1]) {
            base_screw();
        }
        translate([length/1.5,length/1.5,-1]) {
            base_screw();
        }
        translate([leg_width - 1,leg_width/2,depth/4]) {
            rotate([0,90,0]) {
                leg_screw();
            }
            translate([0,0,depth/3]) {
                rotate([0,90,0]) {
                    leg_screw();
                }
            }
        }
        translate([leg_width/2,leg_width - 1,depth/4]) {
            rotate([-90,0,0]) {
                leg_screw();
            }
            translate([0,0,depth/3]) {
                rotate([-90,0,0]) {
                    leg_screw();
                }
            }
        }
    }
}

module base_screw() {
    cylinder(d=5,h=40);
    translate([0,0,6]) {
        cylinder(d=20,h=depth);
    }
}

module leg_screw() {
    cylinder(d=4.5,h=60);
    translate([0,0,6]) {
        cylinder(d=12,h=60);
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


