function joint_male(inner_radius, outer_radius, luft) =
    (inner_radius + outer_radius)/2 - luft;


function joint_female(inner_radius, outer_radius, luft) =
    (inner_radius + outer_radius)/2 + luft;


module gen_female_joint(ir1, or1) {
    tube3(h=global_joint_height, ir1=ir1, or1=joint_female(ir1, or1, global_joint_luft),ir2=ir1, or2=joint_female(ir1, or1, global_joint_luft));
}

module gen_male_joint(ir1, or1) {
    tube3(h=global_joint_height, ir1=ir1, or1=joint_male(ir1, or1, global_joint_luft),ir2=ir1, or2=joint_male(ir1, or1, global_joint_luft));
}
