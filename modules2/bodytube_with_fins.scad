module bodytube_with_fins(trapezoidfinset_total=trapezoidfinset_total, 
                          trapezoidfinset_height=trapezoidfinset_height, 
                          trapezoidfinset_sweeplength=trapezoidfinset_sweeplength, 
                          trapezoidfinset_tipchord=trapezoidfinset_tipchord, 
                          trapezoidfinset_rootchord=trapezoidfinset_rootchord, 
                          trapezoidfinset_filletradius=trapezoidfinset_filletradius, 
                          trapezoidfinset_cant=trapezoidfinset_cant, 
                          trapezoidfinset_crosssection=trapezoidfinset_crosssection, 
                          trapezoidfinset_thickness=trapezoidfinset_thickness, 
                          trapezoidfinset_position=trapezoidfinset_position, 
                          trapezoidfinset_axialoffset=trapezoidfinset_axialoffset, 
                          trapezoidfinset_rotation=trapezoidfinset_rotation, 
                          trapezoidfinset_angleoffset=trapezoidfinset_angleoffset, 
                          trapezoidfinset_radiusoffset=trapezoidfinset_radiusoffset, 
                          trapezoidfinset_fincount=trapezoidfinset_fincount, 
                          trapezoidfinset_instancecount=trapezoidfinset_instancecount,
                          trapezoidfinset_position_type=trapezoidfinset_position_type,

                          freeformfinset_total = freeformfinset_total,
                          freeformfinset_instancecount = freeformfinset_instancecount,
                          freeformfinset_fincount = freeformfinset_fincount,
                          freeformfinset_radiusoffset = freeformfinset_radiusoffset,
                          freeformfinset_angleoffset = freeformfinset_angleoffset,
                          freeformfinset_rotation = freeformfinset_rotation,
                          freeformfinset_axialoffset = freeformfinset_axialoffset,
                          freeformfinset_position = freeformfinset_position,
                          freeformfinset_thickness = freeformfinset_thickness,
                          freeformfinset_crosssection = freeformfinset_crosssection,
                          freeformfinset_cant = freeformfinset_cant,
                          freeformfinset_tabheight = freeformfinset_tabheight,
                          freeformfinset_tablength = freeformfinset_tablength,
                          freeformfinset_tabposition_front = freeformfinset_tabposition_front,
                          freeformfinset_tabposition_top = freeformfinset_tabposition_top,
                          freeformfinset_filletradius = freeformfinset_filletradius,
                          freeformfinset_radiusoffset_method = freeformfinset_radiusoffset_method,
                          freeformfinset_angleoffset_method = freeformfinset_angleoffset_method,
                          freeformfinset_axialoffset_method = freeformfinset_axialoffset_method,
                          freeformfinset_finpoints = freeformfinset_finpoints,

                          radius=radius,
                          length=length,
                          thickness=thickness) {
    // Placeholder for the body tube
    module body() {
	difference() {
	    cylinder(r = radius, h = length, $fn=100);
	    cylinder(r = radius-thickness, h = length, $fn=100);
        }
    }

    // Function to generate a single trapezoidal fin based on the given parameters
    module fin(index) {
        height = trapezoidfinset_height[index];
        sweep = trapezoidfinset_sweeplength[index];
        tip = trapezoidfinset_tipchord[index];
        root = trapezoidfinset_rootchord[index];
        fillet = trapezoidfinset_filletradius[index];
        thickness = trapezoidfinset_thickness[index];
        cant = trapezoidfinset_cant[index];


        linear_extrude(height=thickness, twist=cant)
        translate([0, 0, 0])
        polygon(points=[
            [0, 0],
            [root, 0],
            [root - sweep, height],
            [root - sweep - tip, height]
        ]);
        
    }

    module fin2(thicnkess, points) {
        translate([thickness, 0, -0.5*thickness	])
            linear_extrude(height=thickness)
	        polygon(points);
    }

    

    module trapezoidfins() {
    // Generate each set of fins
    for (i = [0 : trapezoidfinset_total - 1]) {
        for (j = [0 : trapezoidfinset_fincount[i] - 1]) {
            rotate([0, 0, j * 360 / trapezoidfinset_fincount[i] + trapezoidfinset_rotation[i]])
            translate([trapezoidfinset_radiusoffset[i] + 0.5*trapezoidfinset_thickness[i], radius-0.5*thickness, trapezoidfin_position(trapezoidfinset_position_type[i], length, trapezoidfinset_axialoffset[i], trapezoidfinset_rootchord[i])])
                rotate([0,-90,0]) fin(i);
    	    }
	}        
    }

    module freeformfins(total, fincount, rotation, radiusoffset, fin_thickness, axialoffset_method, axialoffset, fin_length, finpoints) {
    // Generate each set of fins
    for (i = [0 : total - 1]) {
        for (j = [0 : fincount[i] - 1]) {
	    echo(find_max_x(finpoints[i]));
            echo(axialoffset_method[i], length, axialoffset[i], /* fin_length[i]*/ find_max_x(finpoints[i]));
            rotate([0, 0, j * 360 / fincount[i] + rotation[i]])
            translate([radiusoffset[i], radius-thickness*0.5, freeformfin_position(axialoffset_method[i], length, axialoffset[i], /* fin_length[i]*/ find_max_x(finpoints[i]))])
                rotate([0,90,0])
            	    fin2(fin_thickness[i], finpoints[i]);
    	    }
	}        
    }

    function trapezoidfin_position(pos, length, offset, root) = 
        pos == "bottom" ? -offset: 
        pos == "top" ? length - offset - root: 
        length / 2 - offset - root/2;


    function freeformfin_position(pos, length, offset, root) = 
        pos == "bottom" ? -offset + root: 
        pos == "top" ? length - offset: 
        length / 2 - offset + root/2;

    function find_max_x(points) = max([for (point = points) point[0]]);

///////

    body();

    if(trapezoidfinset_total)
	trapezoidfins();

    if(freeformfinset_total)
	freeformfins(freeformfinset_total, freeformfinset_fincount, freeformfinset_rotation, freeformfinset_radiusoffset, freeformfinset_thickness, freeformfinset_axialoffset_method, freeformfinset_axialoffset, freeformfinset_tablength, freeformfinset_finpoints*1000);


}

