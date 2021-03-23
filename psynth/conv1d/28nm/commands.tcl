#
#	Physical Synthesis	
#	Walter Lau	09/12/2015
#

###############################
# Reading In the Design
###############################

# Load definitions
set_db init_design_uniquify 1
source ./load.tcl

# Setting VDD
set_db init_power_nets $VDD

# Setting GND
set_db init_ground_nets $GND

# Load configuration file
source $CONF_FILE 

###############################
# Floorplanning
###############################

#Design must be in memory before running "floorPlan"
# MANUALLY TRANSLATE (WARN-2): Command 'commitConfig' is obsolete in common UI and is removed. 
# commitConfig

#Generating square floorplan (1) with 70% of density (0.7) with 4um margins (4 4 4 4)
create_floorplan -site $CORE_NAME -core_density_size $FLOORPLAN

#fit screen
gui_fit

###############################
# Power Planning
###############################

#Generate vdd and gnd
delete_global_net_connections

# Connect vdd and gnd
connect_global_net vdd -type pg_pin -pin_base_name $VDD 
connect_global_net gnd -type pg_pin -pin_base_name $GND 
connect_global_net vdd -type tie_hi 
connect_global_net gnd -type tie_lo 

# Generate power ring with 0.25um spacing (between metal lines), 0.5um width and 1.5um offset from the core. Use M1 for horizontal and M2 for vertical
add_rings -spacing 0.25 -width 0.5 -layer {top M1 bottom M1 left M2 right M2} -jog_distance 2.5 -offset 1.5 -nets {gnd vdd} -threshold 2.5

# Route power rails using M1 
route_special -connect {block_pin core_pin pad_pin pad_ring floating_stripe} -layer_change_range {M1 AP} -block_pin_target {nearest_target} -pad_pin_port_connect {all_port one_geom} -block_pin {use_lef} -allow_jogging 1  -crossover_via_layer_range {M1 AP} -allow_layer_change 1 -target_via_layer_range {M1 AP} -nets {gnd vdd}

# Add well taps
add_well_taps -cell $WELL_TAPS_CELL -cell_interval $CELL_INTERVAL -fixed_gap -prefix WELLTAP -in_row_offset $IN_ROW_OFFSET

# Add power stripes
add_stripes -block_ring_top_layer_limit M3 -max_same_layer_jog_length $LAYER_JOG_LENGTH -pad_core_ring_bottom_layer_limit $HORIZONTAL_LAYER -set_to_set_distance $SET_DISTANCE -pad_core_ring_top_layer_limit M3 -spacing $SPACING -merge_stripes_value $MERGE_STRIP_VAL -layer $VERTICAL_LAYER -block_ring_bottom_layer_limit $HORIZONTAL_LAYER -width $WIDTH -nets {gnd vdd} 

####################################
# Placing the Standard Cells
####################################

set_db route_design_top_routing_layer 6
reset_db -category place
set_db place_global_cong_effort auto 
set_db place_global_clock_gate_aware 0 
set_db place_global_ignore_scan 1
set_db place_global_ignore_spare 1 
set_db place_global_place_io_pins 1 
set_db place_global_module_aware_spare 0 
set_db place_detail_preserve_routing 0 
set_db place_detail_remove_affected_routing 0 
set_db place_detail_check_route 0
set_db place_detail_swap_eeq_cells 0
set_db place_design_floorplan_mode false
place_design

##########################################
# Pre Clock Tree Synthesys Optimizations
##########################################

set_interactive_constraint_modes [all_constraint_modes -active]
reset_ideal_network *

# Optimize only for setup
set_db opt_fix_fanout_load false
opt_design -pre_cts 
opt_design -pre_cts -incremental

# Optimize MaxFan
set_db opt_fix_fanout_load true
opt_design -pre_cts
opt_design -pre_cts -incremental

write_db convolution_pre_cts.dat

#######################
# Clock Tree Synthesys 
#######################

ccopt_design 

##########################################
# Pos Clock Tree Synthesys Optimizations
##########################################

# Fix DRC
set_db opt_fix_fanout_load true
opt_design -post_cts

# Fix DRC + setup
set_db opt_fix_fanout_load false
opt_design -post_cts -drv

# Fix hold
opt_design -hold -post_cts
opt_design -post_cts -incremental

# Save design
write_db convolution_pos_cts.dat

####################################
# Route
####################################

set_db route_design_bottom_routing_layer 0
set_db route_design_detail_end_iteration 0
set_db route_design_with_timing_driven false
set_db route_design_with_si_driven false
set_db route_design_number_fail_limit 10

route_special -connect {block_pin pad_pin pad_ring core_pin} -layer_change_range { METAL1 METAL6 } -block_pin_target { nearest_target} -pad_pin_port_connect {all_port one_geom} -block_pin use_lef -allow_jogging 1 -allow_layer_change 1 
route_trial -max_route_layer 6
route_design -global
route_design -global_detail
route_detail
route_global_detail

write_db convolution_pos_route.dat

####################################
# Checking the Result
####################################

report_constraint -drv_violation_type max_fanout
report_constraint -drv_violation_type max_transition
report_constraint -drv_violation_type max_capacitance

check_process_antenna

check_design -type all

set_db timing_analysis_check_type hold
report_timing

set_db timing_analysis_check_type setup
report_timing

####################################
# Post Route Optimization
####################################
 
# Fix fannout
set_db timing_analysis_type ocv
set_db opt_fix_fanout_load yes
opt_design -post_route -incremental
opt_design -post_route -drv

write_db convolution_pos_fix_fan.dat  
 
# Fix hold
set_db opt_fix_fanout_load false
opt_design -hold -post_route
opt_design -post_route -drv
opt_design -incremental -post_route
opt_design -incremental -hold -post_route

write_db convolution_pos_opt.dat

####################################
# Adding Filler Cells
####################################

add_fillers -base_cells $FILLER_CELLS -prefix FILLER

write_db convolution_pos_filler.dat

############################################################
# Saving and Erm r-f xporting the Placed and Routed Design
############################################################

# Export design netlist
write_netlist ./outputs/${DESIGN_TOP}.v

# Generate outputs
#create_clock -name {clk_in} -period 1 [get_ports {clk_in}]
extract_rc 
write_sdc ./outputs/${DESIGN_TOP}.sdc
write_sdf ./outputs/${DESIGN_TOP}.sdf
write_def -floorplan -netlist -routing ./outputs/${DESIGN_TOP}.def

# Generate reports
report_summary -out_dir summaryReport
report_power -out_file ./reports/${DESIGN_TOP}_power.txt -cap
report_timing > ./reports/${DESIGN_TOP}_timing.txt
report_area > ./reports/${DESIGN_TOP}_area.txt
report_nets > ./reports/${DESIGN_TOP}_nets.txt

exit
