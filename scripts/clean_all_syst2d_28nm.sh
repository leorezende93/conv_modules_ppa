#!/bin/sh

cd ../

cd apps/
./clean.sh
cd -

cd sim_rtl/
./clean.sh
cd -

cd lsynth/systolic2d/28nm/
./clean.sh
cd -

cd psynth/systolic2d/28nm/
./clean.sh
cd -

cd sim_netlist/28nm/
./clean.sh
cd -

cd power_analisys/systolic2d/28nm/
./clean.sh
cd -
