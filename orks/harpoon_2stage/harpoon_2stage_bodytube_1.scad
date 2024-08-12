include <../../modules_ork.scad>

length = 358.0;
thickness = 1.8;
radius = 19.400000000000000+0.4;
motor_overhang = 0.0;
launchlug_total = 0;
trapezoidfinset_total = 2;
freeformfinset_total = 0;
trapezoidfinset_height = [51.3, 18.000000000000000];
trapezoidfinset_sweeplength = [47.800000000000000, 16.200000000000000];
trapezoidfinset_tipchord = [24.13, 27.200000000000000];
trapezoidfinset_rootchord = [48.20000000000000, 48.20000000000000];
trapezoidfinset_filletradius = [0.0, 0.0];
trapezoidfinset_cant = [0.0, 0.0];
trapezoidfinset_crosssection = ["airfoil", "rounded"];
trapezoidfinset_thickness = [2.96, 2.96];
trapezoidfinset_position_type = ["top", "top"];
trapezoidfinset_position = [0.28975, 0.18715];
trapezoidfinset_axialoffset = [289.75, 187.15];
trapezoidfinset_rotation = [0.0, 0.0];
trapezoidfinset_angleoffset = [0.0, 0.0];
trapezoidfinset_radiusoffset = [0.0, 0.0];
trapezoidfinset_fincount = [4, 4];
trapezoidfinset_instancecount = [4, 4];

/*
difference() {
    bodytube_with_fins();
    cube([radius*2, radius*2,39], center=true);
    translate([-100,-100,68]) cube([200, 200,500]);
    cylinder(h=length, r=radius-0.4, $fn=100);
}
*/


//bodytube_with_fins();

