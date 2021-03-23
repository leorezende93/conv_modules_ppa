## Define variables
set sdc_version 2.0
set_units -capacitance pF -time ns

# Create timing constraints
create_clock -period 1 -name clock [get_ports clock]

# Create timing constraints for combinational logic
set_multicycle_path 4 -from [get_pins hpin_bus:systolic2d/cols0_0.mac0/op1] -to [get_pins hpin_bus:systolic2d/cols0_0.mac0/res_mac]
set_multicycle_path 4 -from [get_pins hpin_bus:systolic2d/cols0_0.mac0/op2] -to [get_pins hpin_bus:systolic2d/cols0_0.mac0/res_mac]

set_multicycle_path 4 -from [get_pins hpin_bus:systolic2d/cols0_1.mac0/op1] -to [get_pins hpin_bus:systolic2d/cols0_1.mac0/res_mac]
set_multicycle_path 4 -from [get_pins hpin_bus:systolic2d/cols0_1.mac0/op2] -to [get_pins hpin_bus:systolic2d/cols0_1.mac0/res_mac]

set_multicycle_path 4 -from [get_pins hpin_bus:systolic2d/cols0_2.mac0/op1] -to [get_pins hpin_bus:systolic2d/cols0_2.mac0/res_mac]
set_multicycle_path 4 -from [get_pins hpin_bus:systolic2d/cols0_2.mac0/op2] -to [get_pins hpin_bus:systolic2d/cols0_2.mac0/res_mac]

# Input delay           
set_input_delay -clock clock 0.03 data_from_mem        
set_input_delay -clock clock 0.03 start_line          
set_input_delay -clock clock 0.03 weight_en
set_input_delay -clock clock 0.03 bias_en
          
# Output delay
set_output_delay -clock clock 0.03 [all_outputs]

# Ignore timing for reset signal
set_ideal_network [get_ports reset]

# Output pins should support to drive a load of an inverter
set_load 0.000570 [all_outputs]
