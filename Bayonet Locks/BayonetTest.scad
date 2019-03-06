use <Bayonet_Locks.scad>;

//test();
$fn=48;

male_connector(number_of_locks = 4, pin_inward=true);

translate([100,100,0])
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
