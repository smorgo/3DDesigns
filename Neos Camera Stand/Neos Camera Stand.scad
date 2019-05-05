// Camera Stand
$fn=30;
dia = 51;
wall = 2;
base = 70;
height = 50;

v2();

module v2() {
    offset = (base - dia)/2-wall;
    
    difference() {
        hull() {
            roundedcube(size=[base,base,2], radius=3, center=true, apply_to="z");
            translate([offset,0,height]) {
                cylinder(d = dia+wall*2,h=1,center=true);
            }
        }
        translate([offset,0,height]) {
            cylinder(d=dia,h=1.1,center=true);
        }
        translate([0,0,10]) inner(offset);
    }
}

module inner(offset=0) {
//    roundedcube(size=[base+20,base-20,10],radius=6,center=true);
    for(i=[0:3]) {
        hull() {
            rotate([0,0,i*90]) {
                translate([-base/2,0,12]) sphere(r=base/4,center=true);
            }
            translate([offset,0,height/4]) {
                sphere(r=dia/2,center=true);
            }
        }
    }
}

module v1() {
difference() {
    hull() {
        roundedcube(size=[base,base,2], radius=3, center=true, apply_to="z");
        translate([0,0,height]) {
            cylinder(d = dia+wall,h=1,center=true);
        }
    }
    translate([0,0,height]) {
        cylinder(d=dia,h=1.1,center=true);
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


