include <../../modules_ork.scad>

length = 44.4;
thickness = 11.0;
shape = "ogive";
shapeclipped = false /* ignored */;
shapeparameter = 1.0;
aftradius = 11.0;
aftshoulderradius = 10.0-0.05;
aftshoulderlength = 10.0;
aftshoulderthickness = 10-0.05;
aftshouldercapped = false;
isflipped = false;

difference() {
    nosecone_with_shoulders();
    translate([0,0,-10])
        cylinder(h=7, r1=7, r2=0, $fn=4);
}

translate([-1, -9, -10])
        cube([2, 18, 2]);