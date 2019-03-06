use <Bayonet_Locks.scad>;

//test();
$fn=48;

male_connector();

/*
difference() {
    female_connector();
    for(i=[0:15]) {
        rotate([0,0,i*24]) {
            translate([21,0,0]) {
                cylinder(r=4,h=20);
            }
        }
    }
}
*/