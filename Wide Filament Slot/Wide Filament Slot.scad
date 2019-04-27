/***********************************************************
 *                                                         *
 *      Extended filament slot for IKEA Lack enclosure     *
 *      ==============================================     *
 *                                                         *
 * By https://www.thingiverse.com/smorgo                   *
 *                                                         *
 * Remixed from: https://www.thingiverse.com/thing:3433026 *
 * This version has an overall length of 310mm and needs a *
 * slot of around 298mm, compared to the original's 250mm. *
 *                                                         *
 * Check it fits on your print bed! On my Prusa MK3S, it   *
 * JUST fits by rotating it so that it runs corner-to-     *
 * corner.                                                 *
 *                                                         *
 ***********************************************************/
 
 // NOTE: For me, preview in OpenSCAD didn't render properly.
 //       Use the Render function (F8) to see it in all its glory
 
render_slot = true;
render_lock = true;
 
/* These were just some guide objects that I used to help 
 * get the dimensions right. You may want to use them if
 * you're modifying the design for your own purposes.
 
translate([-13.6,-30,0]) cube([2,60,2]);
translate([310-11.6,-30,0]) cube([2,60,2]);
translate([-11.6,10,0]) {
    cube([310,10,10]);
}
*/

if(render_slot) {
    part_slot();
    translate([286.9,0,0]) mirror([1,0,0]) part_slot();
}

if(render_lock) {
    translate([37,0,0]) {
        stretch_lock();
    }
}

module part_slot() {
    difference() {
        import("Slot_Insert.stl");
        translate([320,0,-30]) cube([160,40,80], center=true);
    }
}

module stretch_lock() {
    translate([0,-20,0]) {
        import("Slide_Lock.stl");
        translate([-18,0,0]) {
            difference() {
                import("Slide_Lock.stl");
                translate([210,0,-55]) cube([120,30,20],center=true);
            }
        }
    }
}
