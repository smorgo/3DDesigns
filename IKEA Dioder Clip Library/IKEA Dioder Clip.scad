/***********************************************************
 *                                                         *
 *                  IKEA Dioder Clip Library               *
 *                  ========================               *
 *                                                         *
 * Generate simple clip profiles that fit IKEA's Dioder    *
 * light strips. You need to combine them with your design *
 * to make a functional mount. This library only generates *
 * the bit that physically clips around the strip.         *
 *                                                         *
 * Designed by: https://www.thingiverse.com/smorgo         *
 *                                                         *
 ***********************************************************/
 
 
 //demo();
 //main();
 surface_clip();
 
 module surface_clip(w=30) {
    difference() {
        cube([30,2,w], center=true);
        translate([11,0,0]) {
            rotate([90,0,0]) {
                cylinder(d=3.2,h=4,center=true,$fn=30);
            }
        }
        translate([-11,0,0]) {
            rotate([90,0,0]) {
                cylinder(d=3.2,h=4,center=true,$fn=30);
            }
        }
    }
     
     translate([0.22,3.38,0]) {
        rotate([0,0,18.5]) {
            dioder_clip(w);
        }
     }


     translate([6,5,w/2]) {
         rotate([0,90,180]) {
            prism(w,4,12);
         }
     }
 }
 
 module corner_clip(w=20) {
     dioder_clip(w);
     fixing(w);
     mirror([1,0,0]) fixing(w);
 }
 
 module fixing(w) {
    translate([0,-0.3,-w/2]) {
        rotate([0,0,-45]) {
            difference() {
                cube([12,1.5,w]);
                translate([8,0.8,w/2]) rotate([90,0,0]) cylinder(d=2,h=2,center=true,$fn=30);
            }
        }
     }
 }
 
 module demo() {
    dioder_clip(w = 6); 
}

module dioder_clip(w = 1) {
    translate([0,4,0]) {
        difference() {
            translate([0,-1.1,0]) {
                cube([12,6.4,w], center=true);
            }
            cube([9.6,6.4,w+0.1], center=true);
            translate([-6,3,0]) {
                rotate([0,0,45]) {
                    cube([2,2,w+0.1], center=true);
                }
            }
            translate([6,2.8,0]) {
                rotate([0,0,45]) {
                    cube([2,2,w+0.1], center=true);
                }
            }
        }
        translate([-4.7,1.75,0]) {
            cylinder(r=0.8,h=w,center=true,$fn=30);
        }
        translate([4.7,1.75,0]) {
            cylinder(r=0.8,h=w,center=true,$fn=30);
        }
    }
} 

module prism(l, w, h){
    polyhedron(
        points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}