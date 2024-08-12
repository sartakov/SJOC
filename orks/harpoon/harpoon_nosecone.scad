include <../../modules_ork.scad>

length = 63.5;
thickness = 2;
shape = "ellipsoid";
shapeclipped = false /* ignored */;
shapeparameter = 0.5;
aftradius = 20;
aftshoulderradius = 17.9;
aftshoulderlength = 10;
aftshoulderthickness = 2;
aftshouldercapped = false;
isflipped = false;

scale([0.5,0.5,0.5]) {
    nosecone_with_shoulders();
}