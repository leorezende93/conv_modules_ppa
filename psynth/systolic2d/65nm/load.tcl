#	Definitions for physical synthesis
#
#	Walter Lau
#	08/12/2015
#

###############################
# Step 1: Reading In the Design
###############################

# Top name
set DESIGN_TOP "conv1d"

# Configure design
set CONF_FILE layout/${DESIGN_TOP}.invs_init.tcl
set VDD {VDD vdd vdd!}
set GND {VSS GND gnd gnd!}

###############################
# Floorplanning
###############################

set CORE_NAME CORE
set FLOORPLAN {1 0.8 3 3 3 3}

###############################
# Power Planning
###############################

set WELL_TAPS_CELL HS65_GS_FILLERNPWPFP3
set CELL_INTERVAL 20
set IN_ROW_OFFSET 8.0
set LAYER_JOG_LENGTH 6
set HORIZONTAL_LAYER M1
set SET_DISTANCE 25
set SPACING 6
set MERGE_STRIP_VAL 2.5
set VERTICAL_LAYER M2
set WIDTH 0.5

####################################
# Adding Filler Cells
####################################

set FILLER_CELLS {HS65_GS_FILLERPFP4 HS65_GS_FILLERPFP3 HS65_GS_FILLERPFP2 HS65_GS_FILLERPFP1}
