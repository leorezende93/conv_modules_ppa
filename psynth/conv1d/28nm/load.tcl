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
set VDD vdd
set GND gnd
set CONF_VAL 0

###############################
# Step 2: Floorplanning
###############################

set CORE_NAME CORE12T
set FLOORPLAN {1 0.7 0.1 0.2 0.1 0.2}

###############################
# Step 4: Power Planning
###############################

set JOG 2.5
set OFFSET_BOTTOM 1.5
set THRESHOLD 2.5
set OFFSET_LEFT 1.5
set OFFSET_RIGHT 1.5
set OFFSET_TOP 1.5
set CELL_INTERVAL 20
set IN_ROW_OFFSET 6.0

set CHECK_ALIGN_SEC_PIN 1
set ALLOW_JOG 1
set ALLOW_LAYER_CHANGE 1

set SPACE 0.25
set WIDTH 0.5
set OFFSET 1.5
set HORIZONTAL_LAYER M1
set VERTICAL_LAYER M2
set WELL_TAPS_CELL C12T28SOI_LR_FILLERNPW4

set LAYER_JOG_LENGTH 6
set SET_DISTANCE 25
set SPACING 4
set MERGE_STRIP_VAL 2.5
set LEFT_OFFSET 10.0
####################################
# Step 5: Placing the Standard Cells
####################################

#Pins
set LAYER_TOP 2
set SPACING_TOP 3
set LAYER_LEFT 3
set SPACING_LEFT 3
set LAYER_BOTTOM 2
set SPACING_BOTTOM 3
set LAYER_RIGHT 3
set SPACING_RIGHT 3

####################################
# Step 11: Adding Filler Cells
####################################

set FILLER_CELLS {C12T28SOI_LR_FILLERNPW4 C12T28SOI_LR_FILLERCELL1 C12T28SOI_L_FILLERCELL1 C12T28SOI_L_FILLERCELL2  C12T28SOI_LR_FILLERPFOP2 C12T28SOI_LR_FILLERPFOP4  C12T28SOI_LR_FILLERPFOP8 C12T28SOI_LR_FILLERPFOP16  C12T28SOI_LR_FILLERPFOP32 C12T28SOI_LR_FILLERPFOP64 C12T28SOI_LR_FILLERFLPCHKAE16  C12T28SOI_LR_FILLERFLPCHKAE2 C12T28SOI_LR_FILLERFLPCHKAE32 C12T28SOI_LR_FILLERFLPCHKAE4 C12T28SOI_LR_FILLERFLPCHKAE64  C12T28SOI_LR_FILLERFLPCHKAE8 }
