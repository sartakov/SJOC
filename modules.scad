include <modules/nosecones.scad>
include <modules/threads.scad>
include <modules/joints.scad>
include <modules/fins.scad>
include <modules/tubes.scad>

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
                            linear_extrude(global_anchor_extrude)
                                polygon(points = shape1, paths = [[0, 1, 2, 3]]);
                        rotate([0, 90, 0])
                            linear_extrude(global_anchor_extrude)
                                polygon(points = shape2, paths = [[0, 1, 2, 3]]);   
            
        }
}

// Create the vertical text
module vertical_text(text_string, text_size, text_extrude, total_height) {
    num_chars = len(text_string);
    spacing = total_height / num_chars;
    for (i = [0:num_chars-1]) {
        translate([0, 0, -i * spacing - text_size/2])
        rotate([90,0,0])
        linear_extrude(height = text_extrude)
        text(text = str(text_string[i]), size = text_size, valign = "center", halign = "center");
    }
}



module cone_with_base(cone_height, bottom_inner_radius, bottom_outer_radius, top_inner_radius, top_outer_radius, base_height, base_inner_radius, base_outer_radius, plank) {
    // Combine the cone and the cylinder
    union() {
        // Cone part
        difference() {
           difference() {
	    if(model_default)
                cone_power_series(n = 0.5, R = bottom_outer_radius, L = cone_height, s = 100);
	    if(model_vostok)
                cylinder(h = cone_height, r1=bottom_outer_radius, r2=0.25, $fn=100);
               //inner shape is cone to avoid problems with support
            cylinder(h = cone_height-(bottom_outer_radius-bottom_inner_radius), r1 = bottom_inner_radius, r2 = 0, $fn=100);
           }
           

          
           if(global_cone_with_window)
             translate([-cone_height/2, 0, cone_height*0.33])
              rotate([90, 90, 90])
                cylinder(h = cone_height*2, r1 = 3, r2 = 3, $fn=100);
            
        }
        // Cylindrical base part
        translate([0, 0, -base_height])
            tube(height=base_height, inner_radius=base_inner_radius, outer_radius = base_outer_radius);

        if(plank)
	    //female connector
	    if(base_outer_radius == bottom_outer_radius) {
                translate([-bottom_inner_radius, -bottom_outer_radius/4,0])
                        cube([bottom_inner_radius*2,bottom_outer_radius/2,global_joint_height*0.1]);
	    } else {
	    //so far male connector
                translate([-base_inner_radius, -base_inner_radius/4,-global_joint_height])
                        cube([base_inner_radius*2,base_inner_radius/2,global_joint_height*0.1]);
	    }
    }
}



// Function to draw rocket fins using Clipped Delta shape
module rocket_fins(base_height, number_of_fins, outer_radius, fin_height, thickness, base_width, top_width) {
    gen_fins(number_of_fins, global_inner_radius, fin_thickness, base_width, top_width, fin_height, fin_shape_type);

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

