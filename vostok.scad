include <modules.scad>


// Parameters 

global_outer_radius = 10.78;
global_inner_radius = 9;
global_joint_radius_narrower = (global_outer_radius - global_inner_radius) / 2 + 0.05;
global_joint_height = 10;

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

gen_base = 1;
gen_body = 0;
gen_cone = 0;

module booster_fins(base_height, number_of_fins, outer_radius, fin_height, thickness, base_width, top_width) {
    // Define the shape of the fin
    
    edge_distance = (base_width - top_width) / 2;



//clipped delta
        shape = [
        [0, 0],
        [base_width, 0],
        [base_width, fin_height],
        [edge_distance, fin_height]
    ];



    // Calculate the angle between fins
    angle = 360 / number_of_fins;

    // Draw fins around the rocket
    for (i = [0:number_of_fins - 1]) {
        rotate(i * angle) {
            rotate([0,3.5,0]) {
            translate([-global_outer_radius*2-4, 0]) {
                cylinder(h=29, r1=13.5,r2=13.5,$fn=100);
                translate([0, 0, 29]) cylinder(h=111, r1=13.5,r2=6.6,$fn=100);
                translate([0, 0, 29+111]) cylinder(h=43, r1=6.6,r2=0.8,$fn=100);
                
                   rotate([0, 0, 90])
                    translate([0, 13.0, base_width])
                        rotate([0, 90, 0])
                            linear_extrude(thickness)
                                polygon(points = shape, paths = [[0, 1, 2, 3]]);
                
                
                }
            }
         }
    }


    tube(height = base_height, inner_radius = global_inner_radius, outer_radius = outer_radius);


    translate([0,0,base_height])
        cylinder(h=32, r1=outer_radius,r2=13.5,$fn=100);
    translate([0,0,base_height+32])
        cylinder(h=10.5, r1=13.5,r2=15.25,$fn=100);
  
      translate([0,0,base_height+32+10.5])
        cylinder(h=59, r1=15.25,r2=13.27,$fn=100);  

      translate([0,0,base_height+32+10.5+59])
        cylinder(h=2.31, r1=13.6,r2=13.6,$fn=100);  


    
//goes insidem should be  12.6+3, but i use +5 instead
      translate([0,0,base_height+32+10.5+59+2.31])
        cylinder(h=12.6, r1=12.65,r2=12.3,$fn=100);  

      translate([0,0,base_height+32+10.5+59+2.31+12.6])
        cylinder(h=3, r1=12.3,r2=0,$fn=100); 
 
 
//end of stage 2

      translate([0,0,base_height+32+10.5+59+2.31+5])
        cylinder(h=40, r1=13.6,r2=13.6,$fn=100);   
      
     translate([0,0,base_height+32+10.5+59+2.31+5+40])
        cylinder(h=5.57, r1=12.8,r2=12.8,$fn=100);    

     translate([0,0,base_height+32+10.5+59+2.31 + 5+40+5.57])
        cylinder(h=44, r1=13.8,r2=13.8,$fn=100);    

     translate([0,0,base_height+32+10.5+59+2.31 + 5+40+5.57+44])
        cylinder(h=34, r1=13.8,r2=0.25,$fn=100);    

  
}



if(gen_base)
booster_fins(base_height = global_base_height, number_of_fins = number_of_fins, outer_radius = global_outer_radius, fin_height = fin_height, thickness = fin_thickness, base_width = fin_base_width, top_width = fin_top_width); 



