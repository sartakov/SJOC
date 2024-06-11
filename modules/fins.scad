function generate_fin_shape(base_width, top_width, fin_height, shape_type) =
    shape_type == 1 ?
// tapered swept 
 [
        [0, 0],
        [base_width, 0],
        [base_width+(base_width - top_width) / 2, fin_height],
        [2*(base_width - top_width) / 2, fin_height]
    ] :
    shape_type == 2 ?
// trapecoid
    [
        [0, 0],
        [base_width, 0],
        [base_width - (base_width - top_width) / 2, fin_height],
        [(base_width - top_width) / 2, fin_height]
    ] :
    shape_type == 3 ?
 // swept
   [
        [0, 0],
        [base_width, 0],
        [base_width+(base_width - top_width) / 2, fin_height],
        [(base_width - top_width) / 2, fin_height]
    ] :
//default: clipped delta
    [
        [0, 0],
        [base_width, 0],
        [base_width, fin_height],
        [(base_width - top_width) / 2, fin_height]
    ];

module gen_fins(number_of_fins, radius, thickness, base_width, top_width, fin_height, shape_type, rod_radius) {

    // Calculate the angle between fins
    angle = 360 / number_of_fins;

    // Draw fins around the rocket
    for (i = [0:number_of_fins - 1]) {
        rotate(i * angle)
            translate([-radius, 0])
                rotate([0, 0, 90])
                    translate([-thickness * 0.5, 0, fin_z_offset+base_width])
                        rotate([0, 90, 0])
                            linear_extrude(thickness)
                                polygon(points = generate_fin_shape(base_width, top_width, fin_height, shape_type));
    }
    

    if(rod_radius) {
	    translate([-rod_radius-global_rod_radius, global_rod_radius+thickness/2, fin_z_offset]) tube(height = global_rod_height, inner_radius = global_rod_radius, outer_radius = global_rod_radius+0.5);
	    translate([rod_radius+global_rod_radius, -(global_rod_radius+thickness/2), fin_z_offset]) tube(height = global_rod_height, inner_radius = global_rod_radius, outer_radius = global_rod_radius+0.5);
    }
}

