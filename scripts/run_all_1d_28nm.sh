#!/bin/sh

module load genus innovus modelsim

./clean_all_1d_28nm.sh

cd ../

cd sim_rtl/
./run_sim1d.sh ${1}
cd -

cd lsynth/conv1d/28nm/
./run.sh
cd -

cd psynth/conv1d/28nm/
./run.sh
cd -

cd sim_netlist/28nm/
./run_sim1d.sh
cd -

cd power_analisys/conv1d/28nm/
./run.sh
cd -
