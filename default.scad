include <modules.scad>

model_default = 1;
model_vostok = 0;

// Parameters 

global_outer_radius = 12;
global_inner_radius = 9;

// joint

global_joint_height = 10;
global_joint_luft = 0.05;

// narrower for engine bay

global_engine_stopper_narrower = 2;
global_engine_stopper_height = 2;
global_engine_height = 65;

// first stage

global_base_height = 70;

// fins
number_of_fins = 3;

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


// lug for a rod 

global_lug_radius = 2;
global_lug_height = 35;
global_lug_count = 1;

// central 

global_tube_height = 100;

// gate

global_gate_anker_h = 6;
global_gate_anker_l = 20;
global_anchor_extrude = 2;

// cone 

global_cone_height = 35;
global_cone_cone_top_inner_radius = 0.0;
global_cone_cone_top_outer_radius = 1;
global_cone_with_window = 0;

// text
global_text_size = 10;

// render
gen_rod_spacer = 0;
gen_base = 0;
gen_body = 0;
gen_cone = 0;
gen_ork = 0;


if(gen_rod_spacer)
        tube(height = 50, inner_radius = global_rod_radius, outer_radius = global_rod_radius+0.5);

if(gen_base) {
    engine_bay(base_height = global_base_height);
    tube3(h = global_base_height, ir1 = global_inner_radius, or1 = global_outer_radius, ir2 = global_inner_radius, or2 = global_outer_radius);   
    gen_fins(number_of_fins, global_inner_radius, fin_thickness, fin_base_width, fin_top_width, fin_height, fin_shape_type,lug_position=global_outer_radius, lug_number = global_lug_count);
    
    translate([0, 0,global_base_height]) 
            gen_male_joint(ir1=global_inner_radius, or1=global_outer_radius);
}


if(gen_body) {
translate([0, 0, global_base_height + 10*1]) {
    difference() {
            tube3(h = global_tube_height, ir1 = global_inner_radius, or1 = global_outer_radius, ir2 = global_inner_radius, or2 = global_outer_radius,text="SJOC4");
            gen_female_joint(ir1=global_inner_radius, or1=global_outer_radius);
            translate([0,0,global_tube_height-global_joint_height]) gen_female_joint(ir1=global_inner_radius, or1=global_outer_radius);
    }
    translate([-global_anchor_extrude/2, -global_inner_radius, global_joint_height+4.75*global_gate_anker_h]) anchor(global_gate_anker_h, global_gate_anker_l);
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
            base_height = 0,
            base_inner_radius = global_inner_radius,
            base_outer_radius = global_outer_radius,
            plank = 1,
            fill = 0
         );
         translate([0, 0, -global_joint_height*1])
        gen_male_joint(ir1=global_inner_radius, or1=global_outer_radius);
    }

}


if(gen_ork) {

echo(str("<?xml version='1.0' encoding='utf-8'?>                                                        "));
echo(str("<openrocket version=\"1.9\" creator=\"OpenRocket 23.09\">                                     "));
echo(str("  <rocket>                                                                                    "));
echo(str("    <name>Rocket</name>                                                                       "));
echo(str("    <id></id>                                                                                 "));
echo(str("    <axialoffset method=\"absolute\">0.0</axialoffset>                                        "));
echo(str("    <position type=\"absolute\">0.0</position>                                                "));
echo(str("    <comment>Comment</comment>                                                                "));
echo(str("    <designer>Space Junk Open Construction</designer>                                         "));
echo(str("    <revision>0.4</revision>                                                                  "));
echo(str("    <motorconfiguration configid=\"e01aebf0-7a9c-4f34-bc45-9b218e43f80b\" default=\"true\">   "));
echo(str("      <stage number=\"0\" active=\"true\"/>                                                   "));
echo(str("    </motorconfiguration>                                                                     "));
echo(str("    <referencetype>maximum</referencetype>                                                    "));


echo(str("     <subcomponents>                                                                          "));
echo(str("          <stage>                                                                             "));
echo(str("            <name>Sustainer</name>                                                            "));
echo(str("            <id>5b246466-15c7-46a5-96a0-b75faba848d2</id>                                     "));
echo(str("            <subcomponents>                                                                   "));

//nose

echo(str("              <nosecone>                                                                      "));
echo(str("                <name>Printable nose cone</name>                                              "));
echo(str("                <id>c230e845-9783-4cf6-80d7-772d97828bbe</id>                                 "));
echo(str("                <appearance>                                                                  "));
echo(str("                  <paint red=\"0\" green=\"204\" blue=\"51\" alpha=\"255\"/>                  "));
echo(str("                  <shine>0.6</shine>                                                          "));
echo(str("                </appearance>                                                                 "));
echo(str("                <finish>rough</finish>                                                        "));
echo(str("                <material type=\"bulk\" density=\"1250.0\">PLA - 100% infill</material>       "));
            
echo(str("                <length>", global_cone_height/1000, "</length>                                 "));
echo(str("                <thickness>", (global_cone_cone_top_outer_radius - global_cone_cone_top_inner_radius)/1000, "</thickness> "));
echo(str("                <shape>power</shape>                                                          "));
echo(str("                <shapeclipped>false</shapeclipped>                                            "));
echo(str("                <shapeparameter>0.5</shapeparameter>                                          "));
echo(str("                <aftradius>",global_outer_radius/1000, "</aftradius>                                   "));
echo(str("                <aftshoulderradius>",joint_male(global_inner_radius, global_outer_radius, global_joint_luft)/1000 ,"</aftshoulderradius>                  "));
echo(str("                <aftshoulderlength>",global_joint_height/1000,"</aftshoulderlength>            "));
echo(str("                <aftshoulderthickness>", (joint_male(global_inner_radius, global_outer_radius, global_joint_luft) - global_inner_radius) / 1000, "</aftshoulderthickness>                             "));
echo(str("                <aftshouldercapped>false</aftshouldercapped>                                   "));
echo(str("                <isflipped>false</isflipped>                                                  "));
echo(str("              </nosecone>                                                                     "));

//body

echo(str("              <bodytube>                                                                                  "));
echo(str("                          <name>Paper Body Tube</name>                                                    "));
echo(str("                          <id>402aead9-e43c-4d53-9367-03011b9c3776</id>                                   "));
echo(str("                          <appearance>                                                                    "));
echo(str("                            <paint red=\"255\" green=\"255\" blue=\"255\" alpha=\"255\"/>                 "));
echo(str("                            <shine>0.21</shine>                                                           "));
echo(str("                          </appearance>                                                                   "));
echo(str("                          <insideappearance>                                                              "));
echo(str("                            <edgessameasinside>false</edgessameasinside>                                  "));
echo(str("                            <insidesameasoutside>true</insidesameasoutside>                               "));
echo(str("                            <paint red=\"187\" green=\"187\" blue=\"187\" alpha=\"255\"/>                 "));
echo(str("                            <shine>0.1</shine>                                                            "));
echo(str("                          </insideappearance>                                                             "));
echo(str("                          <finish>unfinished</finish>                                                     "));
echo(str("                          <material type=\"bulk\" density=\"1250.0\">PLA - 100% infill</material>         "));
echo(str("                          <length>",global_tube_height/1000, "</length>                                   "));
echo(str("                          <thickness>",(global_outer_radius - global_inner_radius)/1000,"</thickness>     "));
echo(str("                          <radius>",global_outer_radius/1000,"</radius>                                   "));

echo(str("                     <subcomponents>                                                                          "));

echo(str("                     <parachute>                                                                          "));
echo(str("                       <name>Parachute</name>                                                             "));
echo(str("                       <id>1b9849c1-68f4-4cfb-836c-65aecf733bca</id>                                      "));
echo(str("                       <axialoffset method=\"top\">",global_joint_height/1000,"</axialoffset>                                      "));
echo(str("                       <position type=\"top\">",global_joint_height/1000,"</position>                                              "));
echo(str("                       <packedlength>0.042</packedlength>                                                 "));
echo(str("                       <packedradius>0.009000000000000001</packedradius>                                  "));
echo(str("                       <radialposition>0.0</radialposition>                                               "));
echo(str("                       <radialdirection>0.0</radialdirection>                                             "));
echo(str("                       <cd>auto</cd>                                                                      "));
echo(str("                       <material type=\"surface\" density=\"0.04\">Polyethylene (heavy)</material>            "));
echo(str("                       <deployevent>ejection</deployevent>                                                "));
echo(str("                       <deployaltitude>200.0</deployaltitude>                                             "));
echo(str("                       <deploydelay>0.0</deploydelay>                                                     "));
echo(str("                       <diameter>0.31</diameter>                                                          "));
echo(str("                       <linecount>6</linecount>                                                           "));
echo(str("                       <linelength>0.3</linelength>                                                       "));
echo(str("                       <linematerial type=\"line\" density=\"3.0E-4\">Thread (heavy-duty)</linematerial>      "));
echo(str("                     </parachute>                                                                         "));

echo(str("                     <shockcord>                                                                          "));
echo(str("                       <name>Shock cord</name>                                                            "));
echo(str("                       <id>50e19614-2f1a-4b74-86b3-941842e4f59e</id>                                      "));
echo(str("                       <axialoffset method=\"middle\">0.00</axialoffset>                                       "));
echo(str("                       <position type=\"middle\">0.00</position>                                               "));
echo(str("                       <comment>The shock cord does not need to be attached to anything in particular, as it functions only as a mass component.</comment>    "));
echo(str("                       <packedlength>0.052000000000000005</packedlength>                                  "));
echo(str("                       <packedradius>0.006</packedradius>                                                 "));
echo(str("                       <radialposition>0.0</radialposition>                                               "));
echo(str("                       <radialdirection>0.0</radialdirection>                                             "));
echo(str("                       <cordlength>0.4</cordlength>                                                       "));
echo(str("                       <material type=\"line\" density=\"0.0018\">Elastic cord (round 2mm, 1/16 in)</material>"));
echo(str("                     </shockcord>                                                                         "));

echo(str("                     <masscomponent>                                                                      "));
echo(str("                       <name>Wadding</name>                                                               "));
echo(str("                       <id>516d8224-de7a-4e11-b14a-62d05543b754</id>                                      "));
echo(str("                       <axialoffset method=\"bottom\">",-global_joint_height/1000,"</axialoffset>                                       "));
echo(str("                       <position type=\"bottom\">",-global_joint_height/1000,"</position>                                               "));
echo(str("                       <packedlength>0.03</packedlength>                                                  "));
echo(str("                       <packedradius>0.0115</packedradius>                                                "));
echo(str("                       <radialposition>0.0</radialposition>                                               "));
echo(str("                       <radialdirection>0.0</radialdirection>                                             "));
echo(str("                       <mass>0.002</mass>                                                                 "));
echo(str("                       <masscomponenttype>masscomponent</masscomponenttype>                               "));
echo(str("                     </masscomponent>                                                                     "));


echo(str("                          <tubecoupler>                                                                       "));
echo(str("                             <name>Tube Coupler</name>                                                "));
echo(str("                             <id>4849d48a-f8c6-4dde-9a4a-df299c2f2cd6</id>                            "));
echo(str("                             <axialoffset method=\"bottom\">0.00</axialoffset>                        "));
echo(str("                             <position type=\"bottom\">0.00</position>                                "));
echo(str("                             <material type=\"bulk\" density=\"1250.0\">PLA - 100% infill</material>  "));
echo(str("                             <length>",global_joint_height/1000,"</length>                                                    "));
echo(str("                             <radialposition>0.0</radialposition>                                     "));
echo(str("                             <radialdirection>0.0</radialdirection>                                   "));
echo(str("                             <outerradius>",joint_male(global_inner_radius, global_outer_radius, global_joint_luft)/1000,"</outerradius> "));
echo(str("                             <thickness>",(joint_male(global_inner_radius, global_outer_radius, global_joint_luft) - global_inner_radius) / 1000,"</thickness>"));
echo(str("                          </tubecoupler>                                                              "));
echo(str("                     </subcomponents>                                                                 "));

echo(str("               </bodytube>                                                                            "));


echo(str("               <bodytube>                                                                                 "));
echo(str("                           <name>Fin Can and Motor Mount</name>                                           "));
echo(str("                           <id>2cdfe954-7c39-4fd6-bde3-471feb6ee0b3</id>                                  "));
echo(str("                           <appearance>                                                                   "));
echo(str("                             <paint red=\"0\" green=\"204\" blue=\"51\" alpha=\"255\"/>                   "));
echo(str("                             <shine>0.6</shine>                                                           "));
echo(str("                           </appearance>                                                                  "));
echo(str("                           <finish>rough</finish>                                                         "));
echo(str("                           <material type=\"bulk\" density=\"1250.0\">PLA - 100% infill</material>        "));
echo(str("                           <length>",global_base_height/1000,"</length>                                   "));
echo(str("                           <thickness>",(global_outer_radius-global_inner_radius)/1000,"</thickness>      "));
echo(str("                           <radius>",global_outer_radius/1000,"</radius>                                  "));
echo(str("                           <motormount>                                                                   "));
echo(str("                             <ignitionevent>automatic</ignitionevent>                                     "));
echo(str("                             <ignitiondelay>0.0</ignitiondelay>                                           "));
echo(str("                             <overhang>",(global_base_height - global_engine_height)/1000,"</overhang>    "));
echo(str("                             <motor configid=\"e01aebf0-7a9c-4f34-bc45-9b218e43f80b\">                    "));
echo(str("                               <type>single</type>                                                        "));
echo(str("                               <manufacturer>Estes</manufacturer>                                         "));
echo(str("                               <digest>f3a785e1523935caf239c7366cf81fee</digest>                          "));
echo(str("                               <designation>A8</designation>                                              "));
echo(str("                               <diameter>0.018</diameter>                                                 "));
echo(str("                               <length>0.07</length>                                                      "));
echo(str("                               <delay>3.0</delay>                                                         "));
echo(str("                             </motor>                                                                     "));
echo(str("                             <ignitionconfiguration configid=\"e01aebf0-7a9c-4f34-bc45-9b218e43f80b\">    ")); 
echo(str("                               <ignitionevent>automatic</ignitionevent>                                   "));
echo(str("                               <ignitiondelay>0.0</ignitiondelay>                                         "));
echo(str("                             </ignitionconfiguration>                                                     "));
echo(str("                           </motormount>                                                                  "));

echo(str("                   <subcomponents>                                                                        "));
echo(str("                  <launchlug>                                                                             "));
echo(str("                    <name>Launch lug</name>                                                               "));
echo(str("                    <id>dfebe2ef-b4f3-4bdb-a6ca-f6e7e434e73d</id>                                         "));
echo(str("                    <appearance>                                                                          "));
echo(str("                      <paint red=\"0\" green=\"204\" blue=\"51\" alpha=\"255\"/>                          "));
echo(str("                      <shine>0.6</shine>                                                                  "));
echo(str("                    </appearance>                                                                         "));
echo(str("                    <instancecount>1</instancecount>                                                      "));
echo(str("                    <instanceseparation>0.0</instanceseparation>                                          "));

echo(str("                    <radialdirection>-12.0</radialdirection>                                              "));  
//I do not know what these two do, but angleoffset was equal to radialdirection
echo(str("                    <angleoffset method=\"relative\">-12.0</angleoffset>                                  "));                                       
echo(str("                    <axialoffset method=\"top\">0.0075</axialoffset>                                      "));

echo(str("                    <position type=\"bottom\">",-fin_z_offset/1000,"</position>                           "));
echo(str("                    <finish>rough</finish>                                                                "));
echo(str("                    <material type=\"bulk\" density=\"1250.0\">PLA - 100% infill</material>               "));
echo(str("                    <radius>",(global_lug_radius+0.5)/1000,"</radius>                                     "));
echo(str("                    <length>",global_lug_height/1000,"</length>                                           "));
echo(str("                    <thickness>",0.5/1000,"</thickness>                                                   "));
echo(str("                  </launchlug>                                                                            "));


echo(str("                  <trapezoidfinset>                                                                       "));
echo(str("                    <name>Trapezoidal fin set</name>                                                      "));
echo(str("                    <id>c294e437-de25-422e-b656-8f038ccacb4d</id>                                         "));
echo(str("                    <appearance>                                                                          "));
echo(str("                      <paint red=\"0\" green=\"204\" blue=\"51\" alpha=\"255\"/>                          "));
echo(str("                      <shine>0.6</shine>                                                                  "));
echo(str("                    </appearance>                                                                         "));
echo(str("                    <instancecount>3</instancecount>                                                      "));
echo(str("                    <fincount>3</fincount>                                                                "));
echo(str("                    <radiusoffset method=\"surface\">0.0</radiusoffset>                                   "));
echo(str("                    <angleoffset method=\"relative\">0.0</angleoffset>                                    "));
echo(str("                    <rotation>0.0</rotation>                                                              "));
echo(str("                    <axialoffset method=\"bottom\">0.0</axialoffset>                                      "));
echo(str("                    <position type=\"bottom\">0.0</position>                                              "));
echo(str("                    <finish>rough</finish>                                                                "));
echo(str("                    <material type=\"bulk\" density=\"1250.0\">PLA - 100% infill</material>               "));
echo(str("                    <thickness>",fin_thickness/1000,"</thickness>                                         "));
echo(str("                    <crosssection>rounded</crosssection>                                                  "));
echo(str("                    <cant>0.0</cant>                                                                      "));
echo(str("                    <filletradius>0.0</filletradius>                                                      "));
echo(str("                    <filletmaterial type=\"bulk\" density=\"1250.0\">PLA - 100% infill</filletmaterial>  "));

//this part is defined by the way how we compute fins
echo(str("                    <rootchord>",fin_base_width/1000,"</rootchord>                                        "));
echo(str("                    <tipchord>",(fin_base_width-fin_top_width)/1000,"</tipchord>                          "));
echo(str("                    <sweeplength>",fin_top_width/1000,"</sweeplength>                                     "));
echo(str("                    <height>",fin_height/1000,"</height>                                                  "));
echo(str("                  </trapezoidfinset>                                                                      "));


echo(str("                </subcomponents>                                                                          "));


echo(str("               </bodytube>                                                                                "));
echo(str("             </subcomponents>                                                                 "));
echo(str("           </stage>                                                                           "));
echo(str("      </subcomponents>                                                                        "));


echo(str("  </rocket>                                                                                   "));
echo(str("</openrocket>                                                                                 "));

}
