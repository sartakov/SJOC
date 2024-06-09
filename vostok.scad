include <modules.scad>

model_default = 0;
model_vostok = 1;

// Parameters 

global_outer_radius = 10.78;
global_inner_radius = 9;
global_joint_radius_narrower = (global_outer_radius - global_inner_radius) / 2 + 0.05;
global_joint_height = 10;
global_joint_luft = 0.05;

global_engine_stopper_narrower = 2;
global_engine_stopper_height = 2;

global_engine_height = 70;

global_base_height = 144;

global_rod_radius = 2;
global_rod_height = 28;

// fins
number_of_fins = 4;

fin_height = 5;
fin_thickness = 1;
fin_z_offset = 0;
fin_base_width = 10;
fin_top_width = 1;


// central 

global_tube_height = 120;


// cone 

global_cone_height = 35;
global_cone_cone_top_inner_radius = 0.0;
global_cone_cone_top_outer_radius = 1;
global_cone_with_window = 0;


// gate
global_gate_height = 25;

global_gate_anker_h = 6;
global_gate_anker_l = 20;
global_anchor_extrude = 2;

// render

gen_base = 0;
gen_body = 1;
gen_cone = 0;

module engine_bay(base_height) {
    z_stop_ring = min(base_height-global_engine_stopper_height, global_engine_height);
    z_joint_ring = max(z_stop_ring, base_height);
    
    translate([0, 0, z_stop_ring]) tube(height = global_engine_stopper_height, inner_radius = global_inner_radius-global_engine_stopper_narrower, outer_radius = global_inner_radius);
    
    tube(height = z_stop_ring, inner_radius = global_inner_radius, outer_radius = global_outer_radius);

    translate([0, 0, z_stop_ring-global_engine_stopper_narrower]) difference() {
        cylinder(h=global_engine_stopper_narrower, r1=global_inner_radius, r2= global_inner_radius, $fn=100);
        cylinder(h=global_engine_stopper_narrower, r1=global_inner_radius, r2= global_inner_radius-global_engine_stopper_narrower, $fn=100);
    }

//in case of upside down printing
    translate([0, 0, z_stop_ring+global_engine_stopper_height]) difference() {
        cylinder(h=global_engine_stopper_narrower, r1=global_inner_radius, r2= global_inner_radius, $fn=100);
        cylinder(h=global_engine_stopper_narrower, r1=global_inner_radius-global_engine_stopper_narrower, r2= global_inner_radius, $fn=100);
    }
}

module stage1(base_height) {
                                    tube3(h = base_height, ir1 = global_inner_radius, ir2 = global_inner_radius, or1 = global_outer_radius, or2 = global_outer_radius);
    translate([0,0,base_height])    tube3(h=32, or1=global_outer_radius,or2=13.5, ir1=global_inner_radius, ir2=global_inner_radius, $fn=100);
    translate([0,0,base_height+32]) tube3(h=10.5, or1=13.5,or2=15.25,ir1=global_inner_radius, ir2=global_inner_radius, $fn=100); 
  
    
    translate([0, 0,base_height+32 + 10.5]) tube(height = global_joint_height, inner_radius = global_inner_radius, outer_radius = joint_male(global_inner_radius, 15.25, global_joint_luft));    
}

module booster_fins(base_height, number_of_fins, outer_radius, fin_height, thickness, base_width, top_width) {

    // Calculate the angle between fins
    angle = 360 / number_of_fins;

    // Draw fins around the rocket
    for (i = [0:number_of_fins - 1]) {
        rotate(i * angle) {
            rotate([0,3.5,0]) {
            translate([-global_outer_radius*2-4, 0]) {
                //boosters
                translate([0,0,0])          cylinder(h=29, r1=13.5,r2=13.5,$fn=100);
                translate([0, 0, 29])       cylinder(h=111, r1=13.5,r2=6.6,$fn=100);
                translate([0, 0, 29+111])   cylinder(h=43, r1=6.6,r2=0.8,$fn=100);
                translate([0, 0, 29+111+35])   cylinder(h=10, r1=3.5,r2=1,$fn=100);

                //fins
                rotate([0, 0, 90])
                    translate([-thickness*0.5, 13.0, base_width])
                        rotate([0, 90, 0])
                            linear_extrude(thickness)
                                polygon(points = generate_fin_shape(base_width, top_width, fin_height, 0));
                }
            }
         }
    }
}



module body() {
   difference() {
    union() {
    
      translate([0,0,0]) cylinder(h=59, r1=15.25,r2=13.27,$fn=100);  
      translate([0,0,59]) cylinder(h=2.31, r1=13.6,r2=13.6,$fn=100);  
      translate([0,0, 59+2.31]) cylinder(h=12.6, r1=12.65,r2=12.3,$fn=100);  
      translate([0,0,59+2.31+12.6]) cylinder(h=3, r1=12.3,r2=0,$fn=100); 
        
        
        
    // Calculate the angle between fins
    angle2 = 360 / 6;

    translate([0,0,59+2.31])
    // Draw fins around the rocket
    for (i = [0:6 - 1])
        rotate(i * angle2)
            translate([-12.4, 0]) {
                rotate([0, 0, 45]) cylinder(h=10, r1=2.5,r2=0,$fn=4);
                translate([0,0,-2]) rotate([0, 0, 45]) cylinder(h=2, r1=2.5,r2=2.5,$fn=4); 
            }

        
//end of stage 2


      translate([0,0,59+2.31+8])
        cylinder(h=4, r1=13.6,r2=13.6,$fn=100);


    // Calculate the angle between fins
    angle3 = 360 / 9;

    translate([0,0,59+2.31+8+4-1]) {
    // Draw fins around the rocket
    for (i = [0:9 - 1]) {
        rotate(i * angle3) {

            translate([-12.0, 0, 7*cos(45)]) {
                rotate([0, 45, 90]) cube([1, 1, 14],center=true);
                rotate([0, -45, 90]) cube([1, 1, 14],center=true);
            }

         }
        }
    }
 
    //this cylinder does not exist in reality
    
        translate([0,0,59+2.31+8 + 4])
        cylinder(h=14*cos(45)-0.5, r1=global_outer_radius,r2=global_outer_radius,$fn=100);  
    

      translate([0,0,59+2.31+8+4-1+14*cos(45)-1])
        cylinder(h=4, r1=13.6,r2=13.6,$fn=100);


     translate([0,0,59+2.31+8+4-1+14*cos(45)-1+4])
        cylinder(h=5.8, r1=13.2,r2=13.2,$fn=100);    
    
    n_sh=90;

    // Calculate the angle between fins
    angle4 = 360 / n_sh;

    translate([0,0,59+2.31+8+4-1+14*cos(45)-1+4]) {
    // Draw fins around the rocket
    for (i = [0:n_sh - 1]) {
        rotate(i * angle4) {

            translate([-13.2, 0, 5.8/2]) {
                rotate([0, 0, 90]) cube([0.5, 0.5, 5.8],center=true);
            }

         }
        }
    }


///////
     translate([0,0,59+2.31+8+4-1+14*cos(45)-1+4+5.8])
        cylinder(h=34, r1=13.8,r2=13.8,$fn=100);    
    
    angle5 = 360 / 4;


    translate([0,0,59+2.31+8+4-1+14*cos(45)-1+4+5.8]) {
    // Draw fins around the rocket
    for (i = [0:4 - 1]) {
        rotate(i * angle5) {

            translate([-13.4, 0]) {
                translate([0,0,4]) rotate([0, 0, 45]) cylinder(h=6, r1=3.0,r2=1.0,$fn=4);
                translate([0,0,0]) rotate([0, 0, 45]) cylinder(h=4, r1=3.0,r2=3.0,$fn=4); 
            }

         }
        }
    }    
  
//////
}

cylinder(h=59+2.31+8+4-1+14*cos(45)-1+4+5.8 + 34,r=global_inner_radius, $fn=100);
cylinder(h = global_joint_height, r = joint_female(global_inner_radius, 15.25, global_joint_luft), $fn=100);

translate([0, 0,59+2.31+8+4-1+14*cos(45)-1+4+5.8 + 34-global_joint_height]) 
    cylinder(h= global_joint_height, r = joint_female(global_inner_radius, 13.8, global_joint_luft), $fn=100);
}


translate([-global_anchor_extrude/2, -global_inner_radius, global_joint_height+4.75*global_gate_anker_h])
           anchor(global_gate_anker_h, global_gate_anker_l);

}


if(gen_base) {
    engine_bay(base_height = global_base_height);
    stage1(base_height = global_base_height);   
    booster_fins(base_height = global_base_height, number_of_fins = number_of_fins, outer_radius = global_outer_radius, fin_height = fin_height, thickness = fin_thickness, base_width = fin_base_width, top_width = fin_top_width); 
}

if(gen_body)
       translate([0,0,global_base_height+32+10.5 + 12.0*1])
            body();


if(gen_cone) {
    translate([0, 0, global_base_height+32+10.5+59+2.31+8+4-1+14*cos(45)-1+4+5.8+34 + global_joint_height + 12.0])
        cone_with_base(
            cone_height = global_cone_height,
            bottom_inner_radius = joint_female(global_inner_radius, 13.8, global_joint_luft),
            bottom_outer_radius = 13.8,
            top_inner_radius = global_cone_cone_top_inner_radius,
            top_outer_radius = global_cone_cone_top_outer_radius,
            base_height = global_joint_height,
            base_inner_radius = global_inner_radius,
            base_outer_radius = joint_male(global_inner_radius, 13.8, global_joint_luft),
            plank = 1
    );

}

