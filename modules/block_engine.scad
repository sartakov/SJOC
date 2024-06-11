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

