#!/bin/sh

module load modelsim
vdel -all
rm -rf *.vcd modelsim.ini transcript vsim.wlf
rm -rf .nfs*
