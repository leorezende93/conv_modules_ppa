onerror {resume}
# Create the library.
if [file exists work] {
    vdel -all
}
vlib work

# Compile the Verilog source(s).
vlog /soft64/design-kits/stm/65nm-cmos065_536/CORE65GPSVT_5.1/behaviour/verilog/CORE65GPSVT.v
vlog /soft64/design-kits/stm/65nm-cmos065_536/CLOCK65GPSVT_3.1/behaviour/verilog/CLOCK65GPSVT.v
vlog ../../psynth/conv1d/65nm/outputs/conv1d.v

# Compile the VHDL source(s).
vcom -novopt ../../tb/65nm/tb1d_netlist.vhd

# Simulate the design.
onerror {resume}
vsim -t ps -novopt -sdfmax /tb/DUT=/home/leonardo.juracy/Rep/conv_modules_ppa/psynth/conv1d/65nm/outputs/conv1d.sdf tb
vcd file conv1d.vcd
vcd add -r /tb/DUT/* 
do wave1d.do
run 6000 ns
exit
