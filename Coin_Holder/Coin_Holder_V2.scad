/*********************************************************************
 *                                                                   *
 *                     Parameterised Coin Holder                     *
 *                     =========================                     *
 *                                                                   *
 * Author: Steve Morgan                                              *
 * Project Source: https://github.com/smorgo/3DDesigns               *
 *                                                                   *
 * License: Creative Commons - Attribution - Non Commercial          *
 *                                                                   *
 * 3D printable design for a coin holder.                            *
 *                                                                   *
 * This design is initially configured to hold a full set of UK      *
 * coins from 1p to £2. But the set of coins can be readily          *
 * changed to suit your own needs, be it a subset of UK coins, or    *
 * coins of a different currency, completely.                        *
 *                                                                   *
 * The design cleverly calculates the correct overall diameter for   *
 * the coin holder, based on the coins that it's configured to hold. *
 * Much of the calculation must be credited to my daughter, Alice    *
 * Morgan who, by applying her A-Level maths skills, gave me a       *
 * solution that was evading me.                                     *
 *                                                                   *
 *********************************************************************/
 
$fn=60; // Reasonably high quality

overall_height = 50; // Height in mm.

// These are the dimensions for UK coins

// You can change the list to suit other currencies, including adding
// or removing entries (note: if you add or remove, make sure that each 
// coin, except the last one, has a comma "," after it. If you know OpenSCAD,
// you'll know this, anyway.

// Each coin entry is made up of three values, text, diameter and thickness
// e.g.
// ["1",20.3,1.65] defines a UK 1 penny piece
// where: "1" is the text printed on the base
//        20.3 is the diameter of the coin in mm
//        1.65 is the thickness of the coin in mm

// Note: the design doesn't use the thickness, at the moment. Maybe a later version will.

// Dimensions for UK coins
coins = [
    ["1",20.3,1.65],
    ["2",25.9,2.03],
    ["5",18,1.89],
    ["10",24.5,2.05],
    ["20",21.4,1.7],
    ["50",27.3,1.78],
    ["£1",23.43,2.8],
    ["£2",28.4,2.5]
    ];

clearance = 0.4; // How much space around each coin
coin_spacing = 1; // Spacing between coin slots
trim_radius = 3; // We trim off a little from the outside to allow room for a finger
base_thickness = 2; // Thickness of the base in mm
text_size = 10; // Change this is the text, embossed in each tube, is too big or too small

pillars = len(coins);

module main() {
    r = find_r(); // Recursively find the correct sized circle to contain all the coins
    echo("r = ", r);
    
    coin_holder(r);
}

module coin_holder(r) {
    
    e = pillars -1;
    // Cutout a hole in the centre
    all_d = [ for(i = [0:1:e]) coins[i][1] ];
    max_d = max(all_d);

    difference() {
            chamfer_cylinder(r = r-trim_radius, h = overall_height, center=true, chamfer=2);
            translate([0,0,base_thickness]) cylinder(r = r-(max_d /1.5), h = overall_height, center=true);
    
        translate([0,0,base_thickness]) {
            for(n = [0:1:e]) {
                rn = (coins[n][1])/2;
                m = (n-1) < 0 ? e : (n-1);
                tth = total_theta(r,m);
                echo("tth = ",tth);
                rotate([0,0,tth]) {
                    translate([r-rn,0,0]) {
                        translate([0,0,-overall_height/2]) {
                            rotate([0,0,90]) {
                                linear_extrude(height = base_thickness, center=true) {
                                    text(coins[n][0], valign="center", halign="center", size=text_size);
                                }
                            }
                        }
//                        difference() {
                            cylinder(r = rn+coin_spacing * 2,h=overall_height,center=true);
//                            cylinder(r = rn+clearance,h=overall_height + 0.02,center=true);
//                        }
                    }
                }
            }
        }
    }

    
    translate([0,0,base_thickness]) {
            for(n = [0:1:e]) {
                rn = (coins[n][1])/2;
                m = (n-1) < 0 ? e : (n-1);
                tth = total_theta(r,m);
                echo("tth = ",tth);
                rotate([0,0,tth]) {
                    translate([r-rn,0,0]) {
                        translate([0,0,-overall_height/2]) {
                            rotate([0,0,90]) {
                                linear_extrude(height = base_thickness, center=true) {
                                    text(coins[n][0], valign="center", halign="center", size=text_size);
                                }
                            }
                        }
                        difference() {
                            cylinder(r = rn+coin_spacing * 2,h=overall_height,center=true);
                            cylinder(r = rn+clearance,h=overall_height + 0.02,center=true);
                        }
                    }
                }
            }
        }
    
}

module chamfer_cylinder(r,h,center=false,chamfer=2) {
    hull() {
        translate([0,0,-chamfer/2]) cylinder(r = r, h = h - chamfer, center = center);
        translate([0,0,chamfer/2]) {
            cylinder(r = r-chamfer, h = h-chamfer, center=center);
        }
    }
}

function find_r(r = 10,rl = 0,rh = 200) = 
    let(t = total_theta(r,pillars-1))
    (t != t || (t > 360.001)) ? find_r((r+rh)/2,r,rh) : ((t < 359.999) ? find_r((r+rl)/2,rl,r) : r);
    
function sum(v, i = 0, r = 0) = i < len(v) ? sum(v, i + 1, r + v[i]) : r;

function total_theta(r,n) = 
    sum( [ for(i=[0:n]) coin_theta(r,i, (i+1) == pillars ? 0 : (i+1)) ]);
        
function coin_theta(r,n,m) =
    theta(r, (coins[n][1])/2 + coin_spacing, (coins[m][1])/2 + coin_spacing);

function theta(r,rn,rm) =
    acos(((r-rn)*(r-rn)+(r-rm)*(r-rm)-(rn+rm)*(rn+rm))/(2 * (r-rn) * (r-rm)));

main();
