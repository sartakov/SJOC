module nosecone_with_shoulders(
    length = length,
    thickness = thickness,
    shape = shape,
    shapeparameter = shapeparameter,
    aftradius = aftradius,
    aftshoulderradius = aftshoulderradius,
    aftshoulderlength = aftshoulderlength,
    aftshoulderthickness = aftshoulderthickness,
    aftshouldercapped = aftshouldercapped,
    isflipped = isflipped
) {
    // Function to generate the desired shape
    module gen_shape() {
        if (shape == "ellipsoid") {
            gen_ellipsoid(length, aftradius, thickness, aftshoulderradius, aftshoulderthickness, shapeparameter);
        } else if (shape == "conical") {
            gen_cone(length, aftradius, thickness, aftshoulderradius, aftshoulderthickness, shapeparameter);
        } else if (shape == "parabolic") {
            gen_parabolic(length, aftradius, thickness, aftshoulderradius, aftshoulderthickness, shapeparameter);
        } else if (shape == "power") {
            gen_power(length, aftradius, thickness, aftshoulderradius, aftshoulderthickness, shapeparameter);
        } else if (shape == "haack") {
            gen_haack(length, aftradius, thickness, aftshoulderradius, aftshoulderthickness, shapeparameter);
        } else if (shape == "ogive") {
	    if(shapeparameter == 1)
	        gen_ogive_tan(length, aftradius, thickness, aftshoulderradius, aftshoulderthickness, shapeparameter);
	    else
		echo(str("Unsupported shape"));
        } else {
            echo(str("Unsupported shape"));
        }
    }

    // Generate the nosecone
    module gen_nosecone() {
        gen_shape();
    }

    // Generate the aft shoulder
    module gen_aft_shoulder() {
        difference() {
            cylinder(r = aftshoulderradius, h = aftshoulderlength, center = false, $fn=100);
            cylinder(r = aftshoulderradius - aftshoulderthickness, h = aftshoulderlength, center = false, $fn=100);
        }
    }

    // Main body
    module body() {
        if (isflipped) {
            rotate([180, 0, 0]) {
                translate([0, 0, -aftshoulderlength])
                    gen_aft_shoulder();
                translate([0, 0, aftshoulderlength])
                    gen_nosecone();
            }
        } else {
            gen_nosecone();
            translate([0, 0, -aftshoulderlength])
                gen_aft_shoulder();
        }
    }

    // Add cap to the aft shoulder if needed
    module cap_aft_shoulder() {
        if (aftshouldercapped) {
            translate([0, 0, -aftshoulderlength])
                cylinder(r = aftshoulderradius, h = aftshoulderthickness, center = false, $fn=100);
        }
    }

    // Generate the full nosecone with shoulder
    body();
    cap_aft_shoulder();
}


// Assuming gen_ellipsoid and gen_cone are defined elsewhere
module gen_ellipsoid(length, radius, thickness, shoulderradius, shoulderthickness, shapeparameter) {
    difference() {
        cone_elliptical(n = 0.5, R = radius, L = length, s = 100);
        cone_elliptical(n = 0.5, R = radius-thickness, L = length-thickness, s = 100);
    }
    intersection() {
	difference() {
            cylinder(r =                            radius, h = thickness, center = false, $fn=100);
            cylinder(r = shoulderradius-shoulderthickness, h = thickness, center = false, $fn=100);
	}
        cone_elliptical(n = 0.5, R = radius, L = length, s = 100);
    }
}

module gen_cone(length, radius, thickness, shoulderradius, shoulderthickness, shapeparameter) {
    difference() {
        cone_cone(R = radius, L = length, s = 100);
        cone_cone(R = radius-thickness, L = length-thickness, s = 100);
    }
    intersection() {
        difference() {
            cylinder(r =                            radius, h = thickness, center = false, $fn=100);
            cylinder(r = shoulderradius-shoulderthickness, h = thickness, center = false, $fn=100);
	}
        cone_cone(R = radius, L = length, s = 100);
    }
}

module gen_parabolic(length, radius, thickness, shoulderradius, shoulderthickness, shapeparameter) {
    difference() {
        cone_parabolic(K = shapeparameter, R = radius, L = length, s = 100);
        cone_parabolic(K = shapeparameter, R = radius-thickness, L = length-thickness, s = 100);
    }
    intersection() {
        difference() {
            cylinder(r =                            radius, h = thickness, center = false, $fn=100);
            cylinder(r = shoulderradius-shoulderthickness, h = thickness, center = false, $fn=100);
	}
        cone_parabolic(K = shapeparameter, R = radius, L = length, s = 100);
    }

}

module gen_power(length, radius, thickness, shoulderradius, shoulderthickness, shapeparameter) {
    difference() {
        cone_power_series(n = shapeparameter, R = radius, L = length, s = 100);
        cone_power_series(n = shapeparameter, R = radius-thickness, L = length-thickness, s = 100);
    }
    intersection() {
        difference() {
            cylinder(r =                            radius, h = thickness, center = false, $fn=100);
            cylinder(r = shoulderradius-shoulderthickness, h = thickness, center = false, $fn=100);
	}
        cone_power_series(n = shapeparameter, R = radius, L = length, s = 100);
    }
}

module gen_haack(length, radius, thickness, shoulderradius, shoulderthickness, shapeparameter) {
    difference() {
        cone_haack(C = shapeparameter, R = radius, L = length, s = 100);
        cone_haack(C = shapeparameter, R = radius-thickness, L = length-thickness, s = 100);
    }
        difference() {
            cylinder(r =                            radius, h = thickness, center = false, $fn=100);
            cylinder(r = shoulderradius-shoulderthickness, h = thickness, center = false, $fn=100);
	}
}

module gen_ogive_sec(length, radius, thickness, shoulderradius, shoulderthickness, shapeparameter) {
    difference() {
        cone_ogive_sec(rho = shapeparameter*10, R = radius, L = length, s = 100);
        cone_ogive_sec(rho = shapeparameter*10, R = radius-thickness, L = length-thickness, s = 100);
    }
    intersection() {
        difference() {
            cylinder(r =                            radius, h = thickness, center = false, $fn=100);
            cylinder(r = shoulderradius-shoulderthickness, h = thickness, center = false, $fn=100);
	}
        cone_ogive_sec(rho = shapeparameter*10, R = radius, L = length, s = 100);
    }

}

module gen_ogive_tan(length, radius, thickness, shoulderradius, shoulderthickness, shapeparameter) {
    difference() {
        cone_ogive_tan(R = radius, L = length, s = 100);
        cone_ogive_tan(R = radius-thickness, L = length-thickness, s = 100);
    }
    intersection() {
        difference() {
            cylinder(r =                            radius, h = thickness, center = false, $fn=100);
            cylinder(r = shoulderradius-shoulderthickness, h = thickness, center = false, $fn=100);
	}
        cone_ogive_tan(R = radius, L = length, s = 100);
    }
}

