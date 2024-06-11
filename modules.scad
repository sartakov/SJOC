include <modules/nosecones.scad>
include <modules/threads.scad>
include <modules/joints.scad>
include <modules/fins.scad>
include <modules/tubes.scad>
include <modules/block_engine.scad>

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



