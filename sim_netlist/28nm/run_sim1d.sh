#!/bin/bash

# Clean environment
./clean.sh

# Copying Generating application
cp ../../apps/tensorflow.vhd .
cp ../../apps/generic_file.txt .

# Run simulation
module load modelsim
vsim -c -do sim1d.do

