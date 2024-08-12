include <../../modules_ork.scad>

length = 253.75;
thickness = 1;
radius = 11.1;
motor_overhang = 8.0;
motor_diameter = 18.0;
motor_length = 70.0;
launchlug_total = 1;
trapezoidfinset_total = 3;
freeformfinset_total = 1;
launchlug_instancecount = [1];
launchlug_instanceseparation = [60.0];
launchlug_length = [21.1455];
launchlug_radius = [1.5425226];
launchlug_position = [-0.0972693];
launchlug_thickness = [0.000333];
trapezoidfinset_height = [1.757275, 2.1, 21.1455];
trapezoidfinset_sweeplength = [2.11455, 4.2595362, 59.2074];
trapezoidfinset_tipchord = [44.41, 215.6, 15.4362];
trapezoidfinset_rootchord = [46.52, 219.9132, 88.8111];
trapezoidfinset_filletradius = [0.0, 0.0, 0.0];
trapezoidfinset_cant = [0.0, 0.0, 0.0];
trapezoidfinset_crosssection = ["square", "square", "square"];
//trapezoidfinset_thickness = [4.2291, 3.171825, 1.75];
trapezoidfinset_thickness = [4.5, 0, 0];
trapezoidfinset_position_type = ["bottom", "bottom", "top"];
trapezoidfinset_position = [-0.0, -0.0, 0.098326575];
trapezoidfinset_axialoffset = [-0.0, -0.0, 98.326575];
trapezoidfinset_rotation = [135, 0.0, 0.0];
trapezoidfinset_angleoffset = [135.0, 0.0, 0.0];
trapezoidfinset_radiusoffset = [0.0, 0.0, 0.0];
trapezoidfinset_fincount = [2, 4, 4];
trapezoidfinset_instancecount = [2, 4, 4];
freeformfinset_instancecount = [4];
freeformfinset_fincount = [4];
freeformfinset_radiusoffset = [0.0];
freeformfinset_angleoffset = [0.0];
freeformfinset_rotation = [0.0];
freeformfinset_axialoffset = [-3.171825];
freeformfinset_position = ["bottom"];
//freeformfinset_thickness = [1.75];
freeformfinset_thickness = [0];
freeformfinset_crosssection = ["square"];
freeformfinset_cant = [0.0];
freeformfinset_tabheight = [];
freeformfinset_tablength = [];
freeformfinset_tabposition_front = [""];
freeformfinset_tabposition_top = [""];
freeformfinset_filletradius = [0.0];
freeformfinset_radiusoffset_method = ["surface"];
freeformfinset_angleoffset_method = ["relative"];
freeformfinset_axialoffset_method = ["bottom"];
freeformfinset_finpoints = [[[0.0, 0.0], [0.01, 0.02], [0.015, 0.013], [0.017, 0.0]]];



difference() {
    union() {
        bodytube_with_fins();
        engine_bay(65, 9.01, radius, 60, 2, stopper=1);
    }
    difference() {
        cylinder(h=length, r=radius, $fn=100);
        cylinder(h=length, r=radius-thickness-0.1, $fn=100);
    }
    
//    translate([-50, -radius, -1]) cube([100, 100,length*2]);
}

    difference() {
        cylinder(h=2, r=radius, $fn=100);
        cylinder(h=2, r=9.01, $fn=100);
    }

