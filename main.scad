// Parameters 

global_outer_radius = 10;
global_inner_radius = 9;
global_joint_radius_narrower = (global_outer_radius - global_inner_radius) / 2 * 1.1;
global_joint_height = 10;

global_engine_stopper_narrower = 2;
global_engine_stopper_height = 2;

global_engine_height = 70;

global_base_height = 60;

global_rod_radius = 2;
global_rod_height = 28;

// fins
number_of_fins = 4;
fin_height = 35;
fin_thickness = 1;
fin_z_offset = 10;
fin_base_width = 40;
fin_top_width = 10;

// central 

global_tube_height = 60;


// cone 

global_cone_height = 40;
global_cone_cone_top_inner_radius = 0.0;
global_cone_cone_top_outer_radius = 0.5;
global_cone_with_window = 1;


// gate
global_gate_height = 25;

// render
gen_base = 1;
gen_body = 1;
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

module tube2(height, inner_radius, outer_radius, bottom_male, top_male,bottom_plank, close_top) {
    difference() {
        // Outer cylinder (tube)
        cylinder(h = height, r = outer_radius, $fn=100);
        if(bottom_male) {
            translate([0, 0, 0])
                tube(height=global_joint_height, inner_radius=outer_radius-global_joint_radius_narrower, outer_radius=outer_radius);
        } else {
                translate([0, 0, 0])
                    cylinder(h=global_joint_height, r=inner_radius + global_joint_radius_narrower, $fn=100);
        }
        if(top_male) {
            translate([0, 0, height-global_joint_height])
                tube(height=global_joint_height, inner_radius=outer_radius-global_joint_radius_narrower, outer_radius=outer_radius);
        } else {
                translate([0, 0, height-global_joint_height])
                    cylinder(h=global_joint_height, r=inner_radius + global_joint_radius_narrower, $fn=100);
        }
        // Inner cylinder (hollow part)
        translate([0, 0, 0])
            cylinder(h = height, r = inner_radius, $fn=100);
    }
    if(bottom_plank)
        translate([-inner_radius, -outer_radius/4, 0])
                        cube([inner_radius*2,outer_radius/2,global_joint_height*0.1]);
    if(close_top)
        translate([0, 0, height-global_joint_height*0.1])
                        cylinder(h = global_joint_height*0.1, r = inner_radius, $fn=100);
}

module cone_with_base(cone_height, bottom_inner_radius, bottom_outer_radius, top_inner_radius, top_outer_radius, base_height, base_inner_radius, base_outer_radius) {
    // Combine the cone and the cylinder
    union() {
        // Cone part
        difference() {
            // Outer cone
            cylinder(h = cone_height, r1 = bottom_outer_radius, r2 = top_outer_radius, $fn=100);
            // Inner cone (hollow part)
            translate([0, 0, 0])
                cylinder(h = cone_height*0.95, r1 = bottom_inner_radius, r2 = top_inner_radius, $fn=100);
        }
        // Cylindrical base part
        translate([0, 0, -base_height])
            tube(height=base_height, inner_radius=base_inner_radius, outer_radius = base_outer_radius);
        
        
        translate([-base_inner_radius, -bottom_outer_radius/4, -base_height])
                        cube([base_inner_radius*2,bottom_outer_radius/2,global_joint_height*0.1]);
    }
}

module cone_with_window(cone_height, bottom_inner_radius, bottom_outer_radius, top_inner_radius, top_outer_radius, base_height, base_inner_radius, base_outer_radius) {
    // Combine the cone and the cylinder
    union() {
        // Cone part
        difference() {
            // Outer cone
            cylinder(h = cone_height, r1 = bottom_outer_radius, r2 = top_outer_radius, $fn=100);
            // Inner cone (hollow part)
            translate([0, 0, 0])
                cylinder(h = cone_height*0.95, r1 = bottom_inner_radius, r2 = top_inner_radius, $fn=100);
            translate([-cone_height/2, 0, cone_height*0.33])
              rotate([90, 90, 90])
                cylinder(h = cone_height*2, r1 = 3, r2 = 3, $fn=100);
        }
        // Cylindrical base part
        translate([0, 0, -base_height]) 
                tube(height=base_height, inner_radius=base_inner_radius, outer_radius = base_outer_radius);
    }
}


// Function to draw rocket fins using Clipped Delta shape
module rocket_fins(base_height, number_of_fins, outer_radius, fin_height, thickness, base_width, top_width) {
    // Define the shape of the fin
    
    edge_distance = (base_width - top_width) / 2;
        shape = [
        [0, 0],
        [base_width, 0],
        [base_width - edge_distance, fin_height],
        [edge_distance, fin_height]
    ];
    
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
    translate([0, 0, z_joint_ring]) tube(height = global_joint_height, inner_radius = global_inner_radius, outer_radius = global_outer_radius-global_joint_radius_narrower);

//rod
    translate([-outer_radius-global_rod_radius, global_rod_radius+thickness/2, fin_z_offset]) tube(height = min(global_rod_height, base_height), inner_radius = global_rod_radius, outer_radius = global_rod_radius+0.5);
    translate([outer_radius+global_rod_radius, -(global_rod_radius+thickness/2), fin_z_offset]) tube(height = min(global_rod_height, base_height), inner_radius = global_rod_radius, outer_radius = global_rod_radius+0.5);

}
///////////////////////////////////////////////////////////

if(gen_base)
rocket_fins(base_height = global_base_height, number_of_fins = number_of_fins, outer_radius = global_outer_radius, fin_height = fin_height, thickness = fin_thickness, base_width = fin_base_width, top_width = fin_top_width); 

if(gen_body)
translate([0, 0, global_base_height + 20]) tube2(height = global_tube_height, inner_radius = global_inner_radius, outer_radius = global_outer_radius, bottom_male=0, top_male=0);

if(gen_cone) {
if(global_cone_with_window) {

    translate([0, 0, global_base_height + global_tube_height + 20*2]) tube2(height = global_gate_height, inner_radius = global_inner_radius, outer_radius = global_outer_radius, bottom_male=1, top_male=1, bottom_plank=1, close_top=1);


    translate([0, 0, global_base_height + global_tube_height + global_gate_height + 3*20])
        cone_with_window(
            cone_height = global_cone_height,
            bottom_inner_radius = global_inner_radius,
            bottom_outer_radius = global_outer_radius,
            top_inner_radius = global_cone_cone_top_inner_radius,
            top_outer_radius = global_cone_cone_top_outer_radius,
            base_height = global_joint_height,
            base_inner_radius = global_inner_radius+global_joint_radius_narrower,
            base_outer_radius = global_outer_radius
);


} else {
    translate([0, 0, global_base_height + global_tube_height + 20*2])
        cone_with_base(
            cone_height = global_cone_height,
            bottom_inner_radius = global_inner_radius,
            bottom_outer_radius = global_outer_radius,
            top_inner_radius = global_cone_cone_top_inner_radius,
            top_outer_radius = global_cone_cone_top_outer_radius,
            base_height = global_joint_height,
            base_inner_radius = global_inner_radius,
            base_outer_radius = global_outer_radius - global_joint_radius_narrower
);

}

}
