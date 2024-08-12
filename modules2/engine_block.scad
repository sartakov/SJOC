module engine_bay(h, ir, or, roffset, rheight, stopper=1) {
    // Outer shell
    difference() {
        // Outer tube
        cylinder(h = h, r = or, $fn = 100);

        // Inner hollow part
        cylinder(h = h, r = ir, $fn = 100);
    }

    if(stopper) 
    translate([0, 0, roffset]) difference() {
        cylinder(h=rheight*2, r1=ir, r2=ir, $fn=100);
        cylinder(h=rheight, r1=ir, r2= ir-rheight, $fn=100);
        translate([0,0,rheight]) cylinder(h=rheight, r2=ir, r1= ir-rheight, $fn=100);
    }

}


