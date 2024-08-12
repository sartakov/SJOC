include <../../modules_ork.scad>

length = 76.0;
thickness = 1.8;
radius = 19.400000000000000+0.2;
motor_overhang = 0.0;
launchlug_total = 0;
trapezoidfinset_total = 1;
freeformfinset_total = 0;
trapezoidfinset_height = [51.3];
trapezoidfinset_sweeplength = [18.67167301785618];
trapezoidfinset_tipchord = [24.0];
trapezoidfinset_rootchord = [60.300000000000000];
trapezoidfinset_filletradius = [0.0];
trapezoidfinset_cant = [0.0];
trapezoidfinset_crosssection = ["rounded"];
trapezoidfinset_thickness = [2.96];
trapezoidfinset_position_type = ["top"];
trapezoidfinset_position = [0.007];
trapezoidfinset_axialoffset = [7];
trapezoidfinset_rotation = [0.0];
trapezoidfinset_angleoffset = [0.0];
trapezoidfinset_radiusoffset = [0.0];
trapezoidfinset_fincount = [4];
trapezoidfinset_instancecount = [4];


difference() {

union() {
    //bodytube_with_fins();
    

    
    translate([0,0,76.5])
        difference() {
            union() {
                engine_bay(65, 9.01, 11, 53.7, 2);
                cylinder(h=1, r=radius, center=true, $fn=100);
                cylinder(h=15, r=radius-thickness-0.05, center=true, $fn=100);
                
                translate([0,0,65])
                    difference() {
                        cylinder(h=2, r=radius-thickness, center=true, $fn=100);
                        cylinder(h=2, r=9.01, center=true, $fn=100);
                    }
               
                translate([0, 0, 65-(12)])
                    difference(){
                      cylinder(h=11, r1=11, r2=radius-thickness, $fn=100); 
                      cylinder(h=11, r=9.01, $fn=100);   
                    }
            }
    
        cylinder(h=30, r=9.01, center=true, $fn=100);
        
        cylinder(h=30, r=9.01, center=true, $fn=100);
    
        translate([0,0,-10]) cylinder(h=15.5, r=16.0, $fn=100);
        }


        /*
       engine_bay(65, 9.01, 11, 65, 2, stopper=0);
       translate([0,0,65])
       difference() {
            cylinder(h=2, r=radius-thickness, center=true, $fn=100);
            cylinder(h=2, r=9.05, center=true, $fn=100);
        }
                translate([0, 0, 65-1-(7)])
                    difference(){
                      cylinder(h=7, r1=11, r2=radius-thickness, $fn=100); 
                      cylinder(h=7, r=9.05, $fn=100);   
                    }


        translate([0,0,70.0])
        difference(){
                    cylinder(h=23.9, r=11, center=true, $fn=100);
                    cylinder(h=23.9, r=9.05, center=true, $fn=100);
        }

        difference() {
            cylinder(h=1, r=radius, $fn=100);
            cylinder(h=1, r=9.01, $fn=100);
        }
        */
    }

    //cube([1000, 1000, 1000]);
}


//translate([0,0,-10])
//cylinder(h=70, r=9, $fn=100);

//translate([0,0,60.1])
//cylinder(h=70, r=9, $fn=100);