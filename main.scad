// Parameters 

global_outer_radius = 11;
global_inner_radius = 9;
global_joint_radius_narrower = (global_outer_radius - global_inner_radius) / 2 + 0.05;
global_joint_height = 10;

global_engine_stopper_narrower = 2;
global_engine_stopper_height = 2;

global_engine_height = 70;

global_base_height = 70;

global_rod_radius = 2;
global_rod_height = 28;

// fins
number_of_fins = 4;

fin_height = 35;
fin_thickness = 2;
fin_z_offset = 0;
fin_base_width = 40;
fin_top_width = 10;


// central 

global_tube_height = 120;


// cone 

global_cone_height = 40;
global_cone_cone_top_inner_radius = 0.0;
global_cone_cone_top_outer_radius = 1;
global_cone_with_window = 0;


// gate
global_gate_height = 25;

global_gate_anker_h = 6;
global_gate_anker_l = 20;

// render
gen_rod_spacer = 1;
gen_base = 1;
gen_body = 1;
gen_gate2 = 1;
gen_cone = 1;


// Module to create a simple tube
module tube(height, inner_radius, outer_radius) {
    difference() {
        // Outer cylinder (tube)
        cylinder(h = height, r = outer_radius, $fn=100);
        // Inner cylinder (hollow part)
        translate([0, 0, 0])
            cylinder(h = height, r = inner_radius, $fn=100);
    }
}


module anchor(ah, al) {

        shape1 = [
        [0, 0],
        [ah*cos(45)*2+al, 0],
        [ah*cos(45)+al, ah*cos(45)],
        [ah*cos(45), ah*cos(45)]
    ];

        shape2 = [
        [4, 0],
        [ah*cos(45)*2+al-4, 0],
        [ah*cos(45)+al-2, ah*cos(45)-2],
        [ah*cos(45)+2, ah*cos(45)-2]
    ];  

        difference() {
                        rotate([0, 90, 0])
                            linear_extrude(2)
                                polygon(points = shape1, paths = [[0, 1, 2, 3]]);
                        rotate([0, 90, 0])
                            linear_extrude(2)
                                polygon(points = shape2, paths = [[0, 1, 2, 3]]);   
            
        }
}

module tube2(height, inner_radius, outer_radius, bottom_male, top_male,plank, gate, anch) { 
  

    difference() {
        // Outer cylinder (tube)
        cylinder(h = height, r = outer_radius, $fn=100);
        
        if(bottom_male) {
            translate([0, 0, 0])
                tube(height=global_joint_height, inner_radius=outer_radius-global_joint_radius_narrower, outer_radius=outer_radius);
        } else {
                translate([0, 0, 0])
                    cylinder(h=global_joint_height, r=inner_radius + global_joint_radius_narrower, $fn=100);                    
                translate([0, 0, global_joint_height]) cylinder(h=global_joint_radius_narrower, r1=inner_radius+global_joint_radius_narrower, r2=inner_radius,$fn=100);  
                
        }
        if(top_male) {
            translate([0, 0, height-global_joint_height])
                tube(height=global_joint_height, inner_radius=outer_radius-global_joint_radius_narrower, outer_radius=outer_radius);
        } else {
                translate([0, 0, height-global_joint_height])
                    cylinder(h=global_joint_height, r=inner_radius + global_joint_radius_narrower, $fn=100);
                translate([0, 0, height-global_joint_height-global_joint_radius_narrower]) cylinder(h=global_joint_radius_narrower, r1=inner_radius, r2=inner_radius + global_joint_radius_narrower,$fn=100);
        }
        // Inner cylinder (hollow part)
        translate([0, 0, 0])
            cylinder(h = height, r = inner_radius, $fn=100);
                 
    }
/*  
    if(top_male) {
        difference() {
            translate([0, 0, global_joint_height-global_joint_radius_narrower]) cylinder(h=global_joint_radius_narrower, r1=inner_radius+global_joint_radius_narrower, r2=outer_radius,$fn=100); 
         translate([0, 0, 0])
            cylinder(h = height, r = inner_radius, $fn=100);
            }
    } 
  */

    if(plank)
        translate([-inner_radius, -outer_radius/4, height/2-(global_joint_height*0.1)*0.5])
                        cube([inner_radius*2,outer_radius/2,global_joint_height*0.1]);
    
    if(anch) {
           translate([0, -inner_radius, height/2+global_gate_anker_h*(2*sin(45)+1)])
           anchor(global_gate_anker_h, global_gate_anker_l);
    }


    if(gate)
        translate([0, 0, height/2-(global_joint_height*0.1)*0.5])
                        cylinder(h = global_joint_height*0.1, r = inner_radius, $fn=100);
                
}

module cone_with_base(cone_height, bottom_inner_radius, bottom_outer_radius, top_inner_radius, top_outer_radius, base_height, base_inner_radius, base_outer_radius, plank) {
    // Combine the cone and the cylinder
    union() {
        // Cone part
        difference() {
            // Outer cone
            cylinder(h = cone_height, r1 = bottom_outer_radius, r2 = top_outer_radius, $fn=100);
            // Inner cone (hollow part)
            translate([0, 0, 0])
                cylinder(h = cone_height*0.95, r1 = bottom_inner_radius, r2 = top_inner_radius, $fn=100);
            
           if(global_cone_with_window)
             translate([-cone_height/2, 0, cone_height*0.33])
              rotate([90, 90, 90])
                cylinder(h = cone_height*2, r1 = 3, r2 = 3, $fn=100);
            
        }
        // Cylindrical base part
        translate([0, 0, -base_height])
            tube(height=base_height, inner_radius=base_inner_radius, outer_radius = base_outer_radius);

        if(plank)
            translate([-bottom_inner_radius, -bottom_outer_radius/4,-base_height/2-(global_joint_height*0.1)*0.5])
                        cube([bottom_inner_radius*2,bottom_outer_radius/2,global_joint_height*0.1]);

    }
}


// Function to draw rocket fins using Clipped Delta shape
module rocket_fins(base_height, number_of_fins, outer_radius, fin_height, thickness, base_width, top_width) {
    // Define the shape of the fin
    
    edge_distance = (base_width - top_width) / 2;



//clipped delta
        shape = [
        [0, 0],
        [base_width, 0],
        [base_width, fin_height],
        [edge_distance, fin_height]
    ];


/*
//trapecoid
        shape = [
        [0, 0],
        [base_width, 0],
        [base_width - edge_distance, fin_height],
        [edge_distance, fin_height]
    ];
*/


/*
// swept
        shape = [
        [0, 0],
        [base_width, 0],
        [base_width+edge_distance, fin_height],
        [edge_distance, fin_height]
    ];
*/

/*
// tapered swept
        shape = [
        [0, 0],
        [base_width, 0],
        [base_width+edge_distance, fin_height],
        [2*edge_distance, fin_height]
    ];
*/


    // Calculate the angle between fins
    angle = 360 / number_of_fins;

    // Draw fins around the rocket
    for (i = [0:number_of_fins - 1]) {
        rotate(i * angle)
            translate([-global_inner_radius, 0])
                rotate([0, 0, 90])
                    translate([-thickness*0.5, 0, fin_z_offset+base_width])
                        rotate([0, 90, 0])
                            linear_extrude(thickness)
                                polygon(points = shape, paths = [[0, 1, 2, 3]]);
    }


    tube(height = base_height, inner_radius = global_inner_radius, outer_radius = outer_radius);

    z_stop_ring = min(base_height-global_engine_stopper_height, global_engine_height);
    z_joint_ring = max(z_stop_ring, base_height);
    
    translate([0, 0, z_stop_ring]) tube(height = global_engine_stopper_height, inner_radius = global_inner_radius-global_engine_stopper_narrower, outer_radius = global_outer_radius);

    translate([0, 0, z_stop_ring-global_engine_stopper_narrower]) difference() {
        cylinder(h=global_engine_stopper_narrower, r1=global_inner_radius, r2= global_inner_radius, $fn=100);
        cylinder(h=global_engine_stopper_narrower, r1=global_inner_radius, r2= global_inner_radius-global_engine_stopper_narrower, $fn=100);
    }

//in case of upside down printing
    translate([0, 0, z_stop_ring+global_engine_stopper_height]) difference() {
        cylinder(h=global_engine_stopper_narrower, r1=global_inner_radius, r2= global_inner_radius, $fn=100);
        cylinder(h=global_engine_stopper_narrower, r1=global_inner_radius-global_engine_stopper_narrower, r2= global_inner_radius, $fn=100);
    }
    
    translate([0, 0, z_joint_ring]) tube(height = global_joint_height, inner_radius = global_inner_radius, outer_radius = global_outer_radius-global_joint_radius_narrower);

//rod
    translate([-outer_radius-global_rod_radius, global_rod_radius+thickness/2, fin_z_offset]) tube(height = min(global_rod_height, base_height), inner_radius = global_rod_radius, outer_radius = global_rod_radius+0.5);
    translate([outer_radius+global_rod_radius, -(global_rod_radius+thickness/2), fin_z_offset]) tube(height = min(global_rod_height, base_height), inner_radius = global_rod_radius, outer_radius = global_rod_radius+0.5);

}
///////////////////////////////////////////////////////////

if(gen_rod_spacer)
        tube(height = 50, inner_radius = global_rod_radius, outer_radius = global_rod_radius+0.5);


if(gen_base)
rocket_fins(base_height = global_base_height, number_of_fins = number_of_fins, outer_radius = global_outer_radius, fin_height = fin_height, thickness = fin_thickness, base_width = fin_base_width, top_width = fin_top_width); 


if(gen_body)
translate([0, 0, global_base_height + global_gate_height + 20*1]) tube2(height = global_tube_height, inner_radius = global_inner_radius, outer_radius = global_outer_radius, bottom_male=0, top_male=1, anch=1, plank=0);


if(gen_cone) {
    translate([0, 0, global_base_height + global_tube_height + 2*global_gate_height + 20*2])
        cone_with_base(
            cone_height = global_cone_height,
            bottom_inner_radius = global_inner_radius + global_joint_radius_narrower,
            bottom_outer_radius = global_outer_radius,
            top_inner_radius = global_cone_cone_top_inner_radius,
            top_outer_radius = global_cone_cone_top_outer_radius,
            base_height = global_joint_height,
            base_inner_radius = global_inner_radius + global_joint_radius_narrower,
            base_outer_radius = global_outer_radius,
            plank = 1
    );

}
