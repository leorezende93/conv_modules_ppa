#!/bin/sh

module load modelsim
vdel -all
rm -rf modelsim.ini transcript vsim.wlf wlf* *.txt work
rm -rf tensorflow.vhd
