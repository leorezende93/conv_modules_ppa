set DESIGN_TOP "conv1d" 

read_db ../../../psynth/${DESIGN_TOP}/28nm/convolution_pos_filler.dat

#set_default_switching_activity -reset 
#set_default_switching_activity -input_activity 0.3 -sequential_activity 0.3

#report_power > reports/report_power_switching_30.txt

#set_default_switching_activity -reset 
#set_default_switching_activity -input_activity 0.5 -sequential_activity 0.5

#report_power > reports/report_power_switching_50.txt

read_activity_file -reset 
read_activity_file -start 11.53ns -scope tb/DUT -format VCD ../../../sim_netlist/28nm/${DESIGN_TOP}.vcd

report_vector_profile -detailed_report true -out_file activity.report

#exit
