#!/bin/bash

# Clean environment
./clean.sh

# Generating application
cd ../apps/
./run.sh ${1}
cd -
cp ../apps/tensorflow.vhd .
cp ../apps/generic_file.txt .

# Run simulation
module load modelsim
vsim -c -do simsystolic2d.do
