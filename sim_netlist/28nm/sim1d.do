onerror {resume}
# Create the library.
if [file exists work] {
    vdel -all
}
vlib work

# Compile the Verilog source(s).
vlog /soft64/design-kits/stm/28nm-cmos28fdsoi_24/C28SOI_SC_12_CORE_LR@2.0@20130411.0/behaviour/verilog/C28SOI_SC_12_CORE_LR.v
vlog /soft64/design-kits/stm/28nm-cmos28fdsoi_24/C28SOI_SC_12_CLK_LR@2.1@20130621.0/behaviour/verilog/C28SOI_SC_12_CLK_LR.v
vlog ../../psynth/conv1d/28nm/outputs/conv1d.v

# Compile the VHDL source(s).
vcom ./tensorflow.vhd
vcom -novopt ../../tb/28nm/tb1d_netlist.vhd

# Simulate the design.
onerror {resume}
vsim -t ps -novopt -sdfmax /tb/DUT=/home/leonardo.juracy/Rep/conv_modules_ppa/psynth/conv1d/28nm/outputs/conv1d.sdf tb -f generic_file.txt
vcd file conv1d.vcd
vcd add -r /tb/DUT/* 
do wave1d.do
onfinish exit
onbreak exit
run -all
exit
