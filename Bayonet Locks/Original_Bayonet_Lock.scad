// Copyright by Alexandre da Silva Xavier
// simple bayonet cylindrical locking mechanism
// ver 1.3 - 05/03/2019 (d/m/y)
// ===========================================


//What to render
part_to_render = "lock"; //pin or lock

// What style of lock to produce, with the pin pointed inward ou outward?
pin_inward = true;

//Render the mechanism with 2 or 4 locks?
four_locks = true;


//Variables

inner_radius = 12;
outer_radius = 18;
//watch the difference between the numbers above, or your model will have holes in it. always remember that the pin size is a function of the diference between inner and outer diameters, as well as a function os the gap, defined below
conn_height = 15;
lip_height = 2;

lock_angle = 36; 
gap = 0.4; //only change this if you are confident on the precision of your printer
detail = 48; //48 works better with Freecad

//Don't mess with it
item_height = conn_height + lip_height;
mid_in_radius = (inner_radius + outer_radius)/2 - gap/2;
mid_out_radius = mid_in_radius + gap;
pin_radius = (outer_radius - inner_radius)/4;
shaft_radius = pin_radius + gap/2;
pin_depth = conn_height/2;
$fn = detail;
pi = 3.14159265359;

//Create item
        difference(){ //base cylinder
            //external cylinder
            cylinder(lip_height, outer_radius, outer_radius);
            //internal cylinder
            translate([0,0, -item_height / 100]) {
                cylinder(item_height * 1.02, inner_radius, inner_radius);
            }
        }

if (part_to_render == "lock"){   //render_lock_part)
    if (pin_inward) { //locking turned outside
        difference(){ 
            //external cylinder
            cylinder(item_height, mid_in_radius, mid_in_radius);
            //internal cylinder
            translate([0,0, -item_height / 100]) {
                cylinder(item_height * 1.02, inner_radius, inner_radius);
            }
            //vertical shaft 1    
            translate([mid_in_radius, 0, item_height - pin_depth]){
                cylinder(item_height, shaft_radius, shaft_radius);
            }
            //vertical shaft 2
            translate([mid_in_radius*-1, 0, item_height - pin_depth]){
                cylinder(item_height, shaft_radius, shaft_radius);
            }
            //locks
            difference(){
                translate([0, 0, item_height - pin_depth]){
                    rotate_extrude(convexity = 10){
                        translate([mid_in_radius+gap, 0, 0]){
                        circle(r = shaft_radius);
                        }
                    }
                }

                translate([0,0,item_height - pin_depth - shaft_radius]) {
//4 locks start

                    if(four_locks){
                        translate([0,0,shaft_radius*2+gap/2]){
                        rotate([0,90,-lock_angle]){prism(2*shaft_radius+gap,mid_in_radius, tan((90-lock_angle))*(mid_in_radius));}
                        rotate([0,90,180-lock_angle]){prism(2*shaft_radius+gap, mid_in_radius, tan((90-lock_angle))*(mid_in_radius));}
                        rotate([0,90,270-lock_angle]){prism(2*shaft_radius+gap, mid_in_radius, tan((90-lock_angle))*(mid_in_radius));}
                        rotate([0,90,90-lock_angle]){prism(2*shaft_radius+gap, mid_in_radius, tan((90-lock_angle))*(mid_in_radius));}
                    }
                        }else{
//4 locks end
                        rotate(atan2(0, mid_in_radius)){
                            cube([mid_in_radius, mid_in_radius, 2 * shaft_radius]);
                        }
                        rotate(180-lock_angle - 2 * atan2(mid_in_radius, mid_in_radius)){
                            cube([mid_in_radius, mid_in_radius, 2 * shaft_radius]);
                        }
                        rotate(180 + atan2(0, mid_in_radius)){
                            cube([mid_in_radius, mid_in_radius, 2 * shaft_radius]);
                        }
                        rotate(360 - lock_angle - 2* atan2(mid_in_radius, mid_in_radius)){
                            cube([mid_in_radius, mid_in_radius, 2 * shaft_radius]);
                        }
                    }
                }                    
            }
            translate([mid_in_radius,0,item_height - pin_depth]){
                sphere(shaft_radius);
                }    
            translate([mid_in_radius*-1,0,item_height - pin_depth]){
                sphere(shaft_radius);
                }    
           translate([cos(lock_angle)*(mid_in_radius), -sin(lock_angle)*(mid_in_radius), item_height - pin_depth]){
                    sphere(shaft_radius);
                    }
            translate([-cos(lock_angle)*(mid_in_radius), sin(lock_angle)*(mid_in_radius), item_height - pin_depth]){
                    sphere(shaft_radius);
                    }
//4 locks start
            //vertical shaft 3
        if(four_locks){
            translate([0,mid_in_radius,  item_height - pin_depth]){
                cylinder(item_height, shaft_radius, shaft_radius);
            }
            //vertical shaft 4
            translate([0,mid_in_radius*-1,  item_height - pin_depth]){
                cylinder(item_height, shaft_radius, shaft_radius);
            }

            translate([0,mid_in_radius,item_height - pin_depth]){
                sphere(shaft_radius);
                }    
            translate([0,mid_in_radius*-1,item_height - pin_depth]){
                sphere(shaft_radius);
                }    
           translate([cos(lock_angle+90)*(mid_in_radius), -sin(lock_angle+90)*(mid_in_radius), item_height - pin_depth]){
                    sphere(shaft_radius);
                    }
            translate([-cos(lock_angle+90)*(mid_in_radius), sin(lock_angle+90)*(mid_in_radius), item_height - pin_depth]){
                    sphere(shaft_radius);
                    }
                }
//4 locks end

        }
        translate([cos(lock_angle - atan2((shaft_radius+gap),mid_in_radius))*(mid_in_radius-pin_radius), -sin(lock_angle - atan2((shaft_radius+gap),mid_in_radius))*(mid_in_radius-pin_radius),item_height - pin_depth-shaft_radius]){cylinder(2*shaft_radius, gap, gap);}
        translate([-cos(lock_angle - atan2((shaft_radius+gap),mid_in_radius))*(mid_in_radius-pin_radius), sin(lock_angle - atan2((shaft_radius+gap),mid_in_radius))*(mid_in_radius-pin_radius),item_height - pin_depth-shaft_radius]){cylinder(2*shaft_radius, gap, gap);}

//_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
        
    } else { //pin outward - locking pointed in

//_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
        
        difference(){
            //external cylinder
            cylinder(item_height, outer_radius, outer_radius);
            //internal cylinder
            translate([0,0, -item_height / 100]) {
                cylinder(item_height * 1.02, mid_out_radius, mid_out_radius);
            }
            //vertical shaft 1
            translate([mid_out_radius, 0, item_height - pin_depth]){
                cylinder(item_height, shaft_radius, shaft_radius);
            }
            //vertical shaft 2
            translate([mid_out_radius*-1, 0, item_height - pin_depth]){
                cylinder(item_height, shaft_radius, shaft_radius);
            }
            //locks
            difference(){
                translate([0, 0, item_height - pin_depth]){
                    rotate_extrude(convexity = 10){
                        translate([mid_out_radius-gap, 0, 0]){
                            circle(r = shaft_radius);
                        }
                    }
                }
//4 locks start

                    if(four_locks){
                        translate([0,0,item_height - pin_depth +  shaft_radius]){
                        rotate([0,90,-lock_angle]){prism(2*shaft_radius+gap,outer_radius, tan((90-lock_angle))*(mid_out_radius));}
                        rotate([0,90,180-lock_angle]){prism(2*shaft_radius+gap, outer_radius, tan((90-lock_angle))*(mid_out_radius));}
                        rotate([0,90,270-lock_angle]){prism(2*shaft_radius+gap, outer_radius, tan((90-lock_angle))*(mid_out_radius));}
                        rotate([0,90,90-lock_angle]){prism(2*shaft_radius+gap, outer_radius, tan((90-lock_angle))*(mid_out_radius));}
                    }
                        }else{
//4 locks end

                    translate([0,0,item_height - pin_depth - shaft_radius]) {
                        rotate(atan2(0, mid_out_radius)){
                            cube([outer_radius, outer_radius, 2 * shaft_radius]);
                        }
                        rotate(180-lock_angle - 2 * atan2(mid_out_radius, mid_out_radius)){
                            cube([outer_radius, outer_radius, 2 * shaft_radius]);
                        }
                        rotate(180 + atan2(0, mid_out_radius)){
                            cube([outer_radius, outer_radius, 2 * shaft_radius]);
                        }
                        rotate(360 - lock_angle - 2* atan2(mid_out_radius, mid_out_radius)){
                            cube([outer_radius, outer_radius, 2 * shaft_radius]);
                        }
                    }
                }                    
            }
            translate([mid_out_radius,0,item_height - pin_depth]){
                sphere(shaft_radius);
                }    
            translate([mid_out_radius*-1,0,item_height - pin_depth]){
                sphere(shaft_radius);
                }  
           translate([cos(lock_angle)*(mid_out_radius), -sin(lock_angle)*(mid_out_radius), item_height - pin_depth]){
                    sphere(shaft_radius);
                    }
            translate([-cos(lock_angle)*(mid_out_radius), sin(lock_angle)*(mid_out_radius), item_height - pin_depth]){
                    sphere(shaft_radius);
                    }
//4 locks start
            //vertical shaft 3
        if(four_locks){
            translate([0,mid_out_radius,  item_height - pin_depth]){
                cylinder(item_height, shaft_radius, shaft_radius);
            }
            //vertical shaft 4
            translate([0,mid_out_radius*-1,  item_height - pin_depth]){
                cylinder(item_height, shaft_radius, shaft_radius);
            }

            translate([0,mid_out_radius,item_height - pin_depth]){
                sphere(shaft_radius);
                }    
            translate([0,mid_out_radius*-1,item_height - pin_depth]){
                sphere(shaft_radius);
                }    
           translate([cos(lock_angle+90)*(mid_out_radius), -sin(lock_angle+90)*(mid_out_radius), item_height - pin_depth]){
                    sphere(shaft_radius);
                    }
            translate([-cos(lock_angle+90)*(mid_out_radius), sin(lock_angle+90)*(mid_out_radius), item_height - pin_depth]){
                    sphere(shaft_radius);
                    }
                }
//4 locks end
                    
        }
        translate([cos(lock_angle - atan2((shaft_radius+gap),mid_in_radius))*(mid_out_radius+pin_radius), -sin(lock_angle - atan2((shaft_radius+gap),mid_in_radius))*(mid_out_radius+pin_radius),item_height - pin_depth-shaft_radius]){cylinder(2*shaft_radius, gap, gap);}
        translate([-cos(lock_angle - atan2((shaft_radius+gap),mid_in_radius))*(mid_out_radius+pin_radius), sin(lock_angle - atan2((shaft_radius+gap),mid_in_radius))*(mid_out_radius+pin_radius),item_height - pin_depth-shaft_radius]){cylinder(2*shaft_radius, gap, gap);}
    }
}


// other part
    
    
    if (part_to_render == "pin"){   //render_pin_part){
        if (pin_inward) { //pin inside
        difference(){
            //external cylinder   
            cylinder(item_height, outer_radius, outer_radius);
            //internal cylinder   
            translate([0,0, -item_height / 100]) {
                cylinder(item_height + (item_height / 50), mid_out_radius, mid_out_radius);
            }
         }
         //pin 1
         translate([mid_out_radius,0,item_height - pin_depth]){
                 sphere (pin_radius);
         } 
         //pin 2
         translate([-mid_out_radius,0,item_height - pin_depth]){
                 sphere (pin_radius);
         }

//4 locks start

        if(four_locks){
             //pin 3
             translate([0,mid_out_radius,item_height - pin_depth]){
                     sphere (pin_radius);
             } 
             //pin 4
             translate([0,-mid_out_radius,item_height - pin_depth]){
                     sphere (pin_radius);
            
            }
         }
// 4 locks end
    } else { //pin pointed out
        difference(){
            //external cylinder   
            cylinder(item_height, mid_in_radius, mid_in_radius);
            //internal cylinder   
            translate([0,0, -item_height / 100]) {
                cylinder(item_height + (item_height / 50), inner_radius, inner_radius);
            }
        }
        //pin 1
        translate([mid_in_radius,0,item_height - pin_depth]){
        sphere (pin_radius);
        }
        //pin 2
        translate([-mid_in_radius,0,item_height - pin_depth]){
        sphere (pin_radius);
        }
        //4 locks start

        if(four_locks){
             //pin 3
            translate([0,mid_in_radius,item_height - pin_depth]){
                     sphere (pin_radius);
             } 
             //pin 4
            translate([0,-mid_in_radius,item_height - pin_depth]){
                     sphere (pin_radius);
            
            }
}
        // 4 locks end

    }
}

   module prism(l, w, h){
       polyhedron(
               points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
               faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
               );
   }