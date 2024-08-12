include <../../modules_ork.scad>

nose_length = 63.5;
nose_thickness = 2;
nose_shape = "ellipsoid";
nose_shapeclipped = false /* ignored */;
nose_shapeparameter = 0.5;
nose_aftradius = 20;
nose_aftshoulderradius = 18;
nose_aftshoulderlength = 6;
nose_aftshoulderthickness = 0;
nose_aftshouldercapped = false;
nose_isflipped = false;

length = 457.2;
thickness = 2;
radius = 20;
motor_overhang = 12.7;
launchlug_total = 0;
trapezoidfinset_total = 3;
freeformfinset_total = 0;
trapezoidfinset_height = [53.975, 53.975, 19.05];
trapezoidfinset_sweeplength = [19.6452939813905, 50.3325038573256, 17.1466782837076];
trapezoidfinset_tipchord = [25.4, 25.4, 28.575];
trapezoidfinset_rootchord = [63.5, 50.8, 50.8];
trapezoidfinset_filletradius = [0.0, 0.0, 0.0];
trapezoidfinset_cant = [0.0, 0.0, 0.0];
trapezoidfinset_crosssection = ["rounded", "airfoil", "rounded"];
trapezoidfinset_thickness = [3.175, 3.175, 3.175];
trapezoidfinset_position_type = ["top", "top", "top"];
trapezoidfinset_position = [0.38735, 0.3048, 0.19685];
trapezoidfinset_axialoffset = [387.35, 304.8, 196.85];
trapezoidfinset_rotation = [0.0, 0.0, 0.0];
trapezoidfinset_angleoffset = [0.0, 0.0, 0.0];
trapezoidfinset_radiusoffset = [0.0, 0.0, 0.0];
trapezoidfinset_fincount = [4, 4, 4];
trapezoidfinset_instancecount = [4, 4, 4];


scale([0.50,0.50,0.50]) {
        bodytube_with_fins();

        lug(8, 4, 5, radius+thickness+1.5, thickness+3.8,30, 1);
        lug(8, 4, 5, radius+thickness+1.5, thickness+3.8,230, 1);

}

engine_bay(60+4, 9.01, radius*0.50, 60, 2);

