onerror {resume}
# Create the library.
if [file exists work] {
    vdel -all
}
vlib work

# Compile the Verilog source(s).
vlog /soft64/design-kits/stm/65nm-cmos065_536/CORE65GPSVT_5.1/behaviour/verilog/CORE65GPSVT.v
vlog /soft64/design-kits/stm/65nm-cmos065_536/CLOCK65GPSVT_3.1/behaviour/verilog/CLOCK65GPSVT.v
vlog ../../psynth/conv2d/65nm/outputs/conv2d.v

# Compile the VHDL source(s).
vcom -novopt ../../tb/65nm/tb2d_netlist.vhd

# Simulate the design.
onerror {resume}
vsim -t ps -novopt -sdfmax /tb/DUT=/home/leonardo.juracy/Rep/conv_modules_ppa/psynth/conv2d/65nm/outputs/conv2d.sdf tb
vcd file conv2d.vcd
vcd add -r /tb/DUT/*
do wave2d.do
run 3000 ns
exit
