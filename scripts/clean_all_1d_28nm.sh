#!/bin/sh

cd ../

cd apps/
./clean.sh
cd -

cd sim_rtl/
./clean.sh
cd -

cd lsynth/conv1d/28nm/
./clean.sh
cd -

cd psynth/conv1d/28nm/
./clean.sh
cd -

cd sim_netlist/28nm/
./clean.sh
cd -

cd power_analisys/conv1d/28nm/
./clean.sh
cd -
