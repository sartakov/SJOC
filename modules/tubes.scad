module tube(height, inner_radius, outer_radius) {
    difference() {
        // Outer cylinder (tube)
        cylinder(h = height, r = outer_radius, $fn=100);
        // Inner cylinder (hollow part)
        translate([0, 0, 0])
            cylinder(h = height, r = inner_radius, $fn=100);
    }
}

module tube2(height, inner_radius, outer_radius, bottom_male, top_male,plank, gate, anch, add_text) { 
  

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
           translate([-global_anchor_extrude/2, -inner_radius, height-(1-top_male)*global_joint_height-global_gate_anker_h])
           anchor(global_gate_anker_h, global_gate_anker_l);
    }


    if(gate)
        translate([0, 0, height/2-(global_joint_height*0.1)*0.5])
                        cylinder(h = global_joint_height*0.1, r = inner_radius, $fn=100);

    if(add_text) {
        // Parameters
        text_string = "SJOC3";
        text_size = 10; // Size of the text
       // total_height = 100; // Total height for the vertical text

        total_height = height - 2*global_joint_height;
        
        text_begin = height - global_joint_height - text_size/2;
        
        translate([0, -global_joint_radius_narrower/4, 0])
        intersection() {
         cylinder(h = height, r = outer_radius, $fn=100);
        translate([0, -inner_radius, text_begin])
                vertical_text(text_string, text_size, (outer_radius-inner_radius), total_height);
        }
    }
                
}


module tube3(h, ir1, or1, ir2, or2, text) {
    difference() {
        cylinder(h = h, r1 = or1, r2 = or2, $fn=100);
	cylinder(h = h, r1 = ir1, r2 = ir2, $fn=100);
    }

    if(text) {
        // Parameters
        text_size = global_text_size; // Size of the text
       // total_height = 100; // Total height for the vertical text

        total_height = h - text_size;
        
        text_begin = h - text_size/2;
        
        translate([0, -global_joint_radius_narrower/4, 0])
        intersection() {
         cylinder(h = h, r1 = or1, r2=or2, $fn=100);
        translate([0, -ir1, text_begin])
                vertical_text(text, text_size, (or1-ir1), total_height);
        }
    }

}

