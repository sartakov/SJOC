include <modules.scad>

model_default = 1;
model_vostok = 0;

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

fin_height = 30;
fin_thickness = 1;
fin_z_offset = 0;
fin_base_width = 40;
fin_top_width = 10;

//0 Clipped Delta
//1 Taper Swept
//2 Trapecoid
//3 Swept
fin_shape_type = 0; 


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
gen_rod_spacer = 0;
gen_base = 1;
gen_body = 0;
gen_cone = 0;


if(gen_rod_spacer)
        tube(height = 50, inner_radius = global_rod_radius, outer_radius = global_rod_radius+0.5);


if(gen_base)
rocket_fins(base_height = global_base_height, number_of_fins = number_of_fins, outer_radius = global_outer_radius, fin_height = fin_height, thickness = fin_thickness, base_width = fin_base_width, top_width = fin_top_width); 


if(gen_body)
translate([0, 0, global_base_height + global_gate_height + 20*1]) tube2(height = global_tube_height, inner_radius = global_inner_radius, outer_radius = global_outer_radius, bottom_male=0, top_male=1, anch=1, plank=0, add_text=1);


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


