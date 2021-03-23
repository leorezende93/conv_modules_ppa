##############################################################
##              Logical synthesis commands                  ##
##                   GAPH/FACIN/PUCRS                       ##
##############################################################

## 1) load synthesis configuration, read description and elaborate design 
include load.tcl
read_hdl -language vhdl "${DESIGN_TOP}.vhd"
elaborate ${DESIGN_TOP}

## 2) read constraints
read_sdc ./constraints.sdc
set_dont_use *SDF*

## 3) synthesize 
set_db auto_ungroup none
synthesize -to_mapped -eff high -no_incr

## 4) build physical synthesis environment
write_design -encounter -basename layout/${DESIGN_TOP}
write_design -encounter -basename ../../../psynth/${DESIGN_TOP}/65nm/layout/${DESIGN_TOP}

## 5) post synthesis reports
report area > ${REPORTS_PATH}/${DESIGN_TOP}_area.txt
report timing > ${REPORTS_PATH}/${DESIGN_TOP}_timing.txt
report power > ${REPORTS_PATH}/${DESIGN_TOP}_power.txt
								
#Generate sdc pos synthesis
write_sdc > ${OUTPUTS_PATH}/${DESIGN_TOP}.sdc
							
#Generate sdf pos synthesis
write_sdf > ${OUTPUTS_PATH}/${DESIGN_TOP}.sdf

exit
