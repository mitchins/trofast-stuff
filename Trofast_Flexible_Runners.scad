// A note on my use case:
// My desk has metal beams that are 40mm below the wood
// This means the mount for the drawer can only begin below that
// The space between is just spacing, and the screws need to factor this in too.

// Valid values:
// CENTER: The middle piece with rails on both sides
// LEFT: Only has rails on its right (mounts left)
// RIGHT: Only has rails on its left (mounts right)
// TEST: A small subsection designed for checking to save material printing
mode = "Center";

beam_depth = (mode == "Test") ? 12 : 250;
beam_width = 12;
beam_extra_height = 40; // compensates for desks with rails and struts
railing_width = 15;
railing_height = 20; // This one is the runner groove itself
rail_extrusion_height = 5;
beam_standard_height = (2 * rail_extrusion_height) + railing_height;
total_unit_height = beam_extra_height + beam_standard_height;

// The screws I am using: M8 (head) with 4.5mm shaft (0.2mm added to each)
// The screw length is 50mm from head to shaft, and I want it to dig 15mm into the desk
screw_head_radius = 8.4/2;
screw_shaft_radius = 4.7/2;
screw_length = 50;
screw_drill_depth = 15;


module main_beam() {
  translate([0,0,(beam_extra_height + beam_standard_height)/2])
  cube([beam_width, beam_depth, beam_extra_height + beam_standard_height], center=true);
  // The railing is on both sides
  total_railing_width = (mode == "Center" || mode == "Test") ? 
  ((2 * railing_width) + beam_width) : railing_width;
  offset_abs = beam_width/2 + railing_width/2;
  offset = (mode == "Left") ? offset_abs :  (mode == "Right") ? -offset_abs : 0; 
  // Lower railing
  translate([offset,0, rail_extrusion_height/2])
  cube([total_railing_width, beam_depth, rail_extrusion_height], center=true);
  // Upper railing
  translate([offset,0,rail_extrusion_height/2 + railing_height])
  cube([total_railing_width, beam_depth, rail_extrusion_height], center=true);
}

difference() {
  main_beam();
  // Determine how much of the screw will be recessed into the beam
  effective_screw_length = screw_length - screw_drill_depth;
  // Determine how empty shaft from bottom of unit to screw head
  screw_lead_height = total_unit_height - effective_screw_length;
  // Plot three screws
  start = (mode == "Test") ? 0 : -1;
  end = (mode == "Test") ? 0 : 1;
  for ( i = [start:1:end]) { 
    // The thinner shaft end of the screw
    translate([0,i * beam_depth/3,total_unit_height - effective_screw_length])
    cylinder(h=effective_screw_length, r=screw_shaft_radius, center=false);
    // The wider entry for the head of the screw
    translate([0,i * beam_depth/3,0])
    cylinder(h=screw_lead_height, r=screw_head_radius, center=false);
  }
}