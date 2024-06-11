include <modules.scad>

model_default = 1;
model_vostok = 0;

// Parameters 

global_outer_radius = 11;
global_inner_radius = 9;
global_joint_radius_narrower = (global_outer_radius - global_inner_radius) / 2 + 0.05;
global_joint_height = 10;
global_joint_luft = 0.1;

global_engine_stopper_narrower = 2;
global_engine_stopper_height = 2;

global_engine_height = 65;

global_base_height = 85;

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

global_tube_height = 80;


// cone 

global_cone_height = 35;
global_cone_cone_top_inner_radius = 0.0;
global_cone_cone_top_outer_radius = 1;
global_cone_with_window = 0;

// render
gen_rod_spacer = 0;
gen_base = 1;
gen_body = 1;
gen_cone = 1;

// text
global_text_size = 10;


if(gen_rod_spacer)
        tube(height = 50, inner_radius = global_rod_radius, outer_radius = global_rod_radius+0.5);

if(gen_base) {
    engine_bay(base_height = global_base_height);
    tube3(h = global_base_height, ir1 = global_inner_radius, or1 = global_outer_radius, ir2 = global_inner_radius, or2 = global_outer_radius);   
    gen_fins(number_of_fins, global_inner_radius, fin_thickness, fin_base_width, fin_top_width, fin_height, fin_shape_type,rod_radius=global_outer_radius);
    
    
    translate([0, 0,global_base_height]) 
            gen_male_joint(ir1=global_inner_radius, or1=global_outer_radius);
}


if(gen_body) {
translate([0, 0, global_base_height + 10*1])
    difference() {
            tube3(h = global_tube_height, ir1 = global_inner_radius, or1 = global_outer_radius, ir2 = global_inner_radius, or2 = global_outer_radius,text="SJOC4");
            gen_female_joint(ir1=global_inner_radius, or1=global_outer_radius);
            translate([0,0,global_tube_height-global_joint_height]) gen_female_joint(ir1=global_inner_radius, or1=global_outer_radius);
    }
}

if(gen_cone) {
    translate([0, 0, global_base_height+global_tube_height + 10*2 + 10]) {
          cone_with_base(
            cone_height = global_cone_height,
            bottom_inner_radius = global_inner_radius,
            bottom_outer_radius = global_outer_radius,
            top_inner_radius = global_cone_cone_top_inner_radius,
            top_outer_radius = global_cone_cone_top_outer_radius,
            base_height = global_joint_height,
            base_inner_radius = global_inner_radius,
            base_outer_radius = global_outer_radius,
            plank = 1
         );
         translate([0, 0, -global_joint_height*2])
        gen_male_joint(ir1=global_inner_radius, or1=global_outer_radius);
    }

}


