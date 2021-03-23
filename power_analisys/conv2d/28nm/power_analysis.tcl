set DESIGN_TOP "conv2d" 

read_db ../../../psynth/${DESIGN_TOP}/28nm/convolution_pos_filler.dat

read_activity_file -start 10ns -reset -scope tb/DUT -format VCD ../../../sim_netlist/28nm/${DESIGN_TOP}.vcd

report_vector_profile -detailed_report true -out_file activity.report

exit
