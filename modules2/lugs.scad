module lug(h, ir, or, x, y, z, m) {
	translate([x, y,z])
        difference() {
                cylinder(h=h, r=or, $fn=100);
                cylinder(h=h, r=ir, $fn=100);
        }
        
        if(m) {
    	    translate([-x, -y,z])
    		difference() {
            	    cylinder(h=h, r=or, $fn=100);
            	    cylinder(h=h, r=ir, $fn=100);
    		}

        }
}


