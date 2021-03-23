set DESIGN_TOP "conv2d" 

read_db ../../../psynth/conv2d/65nm/convolution_pos_filler.dat

read_activity_file -start 32ns -end 520ns -reset -scope tb/DUT -format VCD ../../../sim_netlist/65nm/${DESIGN_TOP}.vcd

report_vector_profile -detailed_report true -out_file activity.report

exit
