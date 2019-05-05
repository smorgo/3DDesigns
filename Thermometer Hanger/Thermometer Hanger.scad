// Thermometer hanger

$fn=30;

l = 50;
d = 3;
w = 30;

bd = 8;
bw = 16;
bh = 10;

plate();
translate([0,0,d]) hanger();

module plate() {
    hl = bw + 3 * bd;
    translate([-l+hl/4,-w/2,0]) {
        difference() {
            union() {
                roundedcube(size=[l,w,d],radius=1.5,apply_to="z");
                translate([l/4,0,0]) cylinder(d=12,h=d);
                translate([l*.75,w,0]) cylinder(d=12,h=d);
            }
            translate([l/4,0,0]) cylinder(d=3.4,h=d*4,center=true);
            translate([l*.75,w,0]) cylinder(d=3.4,h=d*4,center=true);
        }
    }
    
}

module hanger() {
    cylinder(d=bd,h=bh-bd,$fn=100);
    translate([0,0,bh-bd]) corner(d=bd,r=bd);
    translate([-bd-bw,0,bh]) rotate([0,90,0]) cylinder(d=bd,h=bw,$fn=100);
    translate([-bd-bd-bw,0,bh-bd]) mirror([1,0,0]) corner(d=bd,r=bd);
    translate([-bd-bd-bw,0,0]) cylinder(d=bd,h=bh-bd,$fn=100);
}

module corner(d,r) {
    translate([-r,0,0])
    rotate([90,0,0]) 
    intersection() {
        rotate_extrude(convexity=10,$fn=100) {
            translate([r,0,0]) circle(r = d/2,$fn=100);
        }
        translate([0,0,-r*.75]) cube([r*1.5,r*1.5,r*1.5]);
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



