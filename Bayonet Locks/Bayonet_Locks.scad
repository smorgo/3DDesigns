/************************************************************
 * This library created collaboratively by Steve Morgan and *
 * Alexandre da Silva Xavier under copyright                *
 *                                                          *
 * Based on original work by Alexandre da Silva Xavier      *
 * (https://www.thingiverse.com/thing:3471896)              *
 *                                                          *
 * Licensed under Creative Commons - Attribution            *
 *                                                          *
 * Simple bayonet cylindrical locking mechanism             *
 * Original: ver 1.3 - 05/03/2019 (d/m/y)                   *
 ************************************************************/

module test() {
    $fn=30;
    outer_radius = 18;

    female_connector(pin_inward=true);
    translate([outer_radius * 2, outer_radius * 2, 0]) {
        male_connector(pin_inward=true);
    }
    translate([outer_radius * -2, outer_radius * 2, 0]) {
        female_connector(pin_inward=false);
    }
    translate([outer_radius * -2, outer_radius * -2, 0]) {
        male_connector(pin_inward=false);
    }
}

module female_connector(
    outer_radius = 18, 
    inner_radius = 12, 
    connector_height = 15, 
    lip_height = 2,
    number_of_locks = 4,
    pin_inward = true,
    clearance = 0.4,
    twist_angle = 30) {

    item_height = connector_height + lip_height;
    mid_in_radius = (inner_radius + outer_radius)/2 - clearance/2;
    mid_out_radius = mid_in_radius + clearance;
    pin_radius = (outer_radius - inner_radius)/4;
    shaft_radius = pin_radius + clearance/2;
    pin_depth = connector_height/2;

    render_shell(lip_height, outer_radius, inner_radius);
        
        
    if(pin_inward) {
        render_shell(item_height, outer_radius, mid_out_radius);
        render_pins(number_of_locks, mid_out_radius, item_height, pin_radius, pin_depth, clearance);
    } else {
        difference() {
            render_shell(item_height, outer_radius, mid_out_radius);
            render_locks(number_of_locks, mid_out_radius, item_height, shaft_radius, pin_depth, clearance, twist_angle);
        }
    }
}

module male_connector(
    outer_radius = 18, 
    inner_radius = 12, 
    connector_height = 15, 
    lip_height = 2,
    number_of_locks = 4,
    pin_inward = true,
    clearance = 0.4,
    twist_angle = 30) {

    item_height = connector_height + lip_height;
    mid_in_radius = (inner_radius + outer_radius)/2 - clearance/2;
    mid_out_radius = mid_in_radius + clearance;
    pin_radius = (outer_radius - inner_radius)/4;
    shaft_radius = pin_radius + clearance/2;
    pin_depth = connector_height/2;

    render_shell(lip_height, outer_radius, inner_radius);
        
    if(pin_inward) {
        difference() {
            render_shell(item_height, mid_in_radius, inner_radius);
            render_locks(number_of_locks, mid_in_radius, item_height, shaft_radius, pin_depth, clearance, twist_angle);
        }
    } else {
        render_shell(item_height, mid_in_radius, inner_radius);
        render_pins(number_of_locks, mid_in_radius, item_height, pin_radius, pin_depth, clearance);
    }
}

module render_pins(
    number_of_locks,
    r,
    h,
    pin_radius,
    pin_depth,
    clearance) {

    module render_pin(r,h, pin_radius, pin_depth, clearance) {
        translate([r,0,h - pin_depth]) {
            sphere(pin_radius);
        }
    }
        
    delta_angle = 360 / number_of_locks;
        
    for(i = [0:number_of_locks-1]) {
        rotate([0,0,i * delta_angle]) {
            render_pin(r, h, pin_radius, pin_depth, clearance);
        }
    }
}


module render_locks(
    number_of_locks,
    r,
    h,
    shaft_radius,
    pin_depth,
    clearance,
    twist_angle) {

    module render_lock(r,h, shaft_radius, pin_depth, clearance, a) {
        translate([0,0,h - pin_depth]) {
            difference() {
                rotate_extrude2(angle = -a, convexity = 10, size=2 * r){
                    translate([r+clearance, 0, 0]){
                        circle(r = shaft_radius);
                    }
                }
                // This needs to be calculated properly!
                echo("*** WARNING: Generating the locking notch in the wrong place!");
                rotate([0,0,-a/2]) {
                    translate([r - shaft_radius/2,0,-shaft_radius/2]) {
                        cylinder(r=shaft_radius/8,h=shaft_radius);
                    }
                }
            }
            translate([r+clearance, 0, 0]){
                cylinder(r = shaft_radius, h=h);
                sphere(shaft_radius);
                rotate([0,0,-a/2]) {
                    sphere(shaft_radius);
                }
            }
            rotate([0,0,-a]) {
                translate([r+clearance, 0, 0]){
                    sphere(shaft_radius);
                }
            }
        }
    }

    delta_angle = 360 / number_of_locks;
        
    for(i = [0:number_of_locks-1]) {
        rotate([0,0,i * delta_angle]) {
            render_lock(r, h, shaft_radius, pin_depth, clearance, twist_angle);
        }
    }
}
    

module render_shell(
    lip_height,
    outer_radius,
    inner_radius) {
        
    difference() { //base cylinder
        //external cylinder
        cylinder(lip_height, outer_radius, outer_radius);
        //internal cylinder
        translate([0,0, -0.1]) {
            cylinder(lip_height + 0.2, inner_radius, inner_radius);
        }
    }
}

module rotate_extrude2(angle=360, convexity=2, size=1000) {

  module angle_cut(angle=90,size=1000) {
    x = size*cos(angle/2);
    y = size*sin(angle/2);
    translate([0,0,-size]) 
      linear_extrude(2*size) polygon([[0,0],[x,y],[x,size],[-size,size],[-size,-size],[x,-size],[x,-y]]);
  }

  // support for angle parameter in rotate_extrude was added after release 2015.03 
  // Thingiverse customizer is still on 2015.03
  angleSupport = (version_num() > 20150399) ? true : false; // Next openscad releases after 2015.03.xx will have support angle parameter
  // Using angle parameter when possible provides huge speed boost, avoids a difference operation

  if (angleSupport) {
    rotate_extrude(angle=angle,convexity=convexity)
      children();
  } else {
    rotate([0,0,angle/2]) difference() {
      rotate_extrude(convexity=convexity) children();
      angle_cut(angle, size);
    }
  }
}