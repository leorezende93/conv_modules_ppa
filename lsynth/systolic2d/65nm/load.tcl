##############################################################
##              Logical synthesis commands                  ##
## Modified  by Fernando Moraes - 29/set/2012               ##
##############################################################

#===============================================================================
## load synthesis configuration, read description and elaborate design 
#===============================================================================

set REPORTS_PATH "reports/"
set DESIGN_TOP "conv1d"
set OUTPUTS_PATH "outputs/"

set_db script_search_path "./"
set_db hdl_search_path "../../../rtl/"
set_db information_level 9 

set_db hdl_track_filename_row_col true
set_db hdl_array_naming_style %s_%d
set_db hdl_instance_array_naming_style %s_%d
set_db hdl_generate_index_style %s_%d
set_db hdl_bus_wire_naming_style %s_%d

#===============================================================================
#  Load libraries
#===============================================================================
set DK_PATH  "/soft64/design-kits/stm/65nm-cmos065_536" 

set_db library "${DK_PATH}/CORE65GPSVT_5.1/libs/CORE65GPSVT_nom_1.00V_25C.lib \
                ${DK_PATH}/CLOCK65GPSVT_3.1/libs/CLOCK65GPSVT_nom_1.00V_25C.lib \
                ${DK_PATH}/IO65LPHVT_SF_1V8_50A_7M4X0Y2Z_7.0/libs/IO65LPHVT_SF_1V8_50A_7M4X0Y2Z_nom_1.00V_1.80V_25C.lib"
                       
set_db lef_library "${DK_PATH}/EncounterTechnoKit_cmos065_7m4x0y2z_AP@5.3.1/TECH/cmos065_7m4x0y2z_AP_Worst.lef \
                           ${DK_PATH}/PRHS65_7.0.a/CADENCE/LEF/PRHS65_soc.lef \
                           ${DK_PATH}/CORE65GPSVT_5.1/CADENCE/LEF/CORE65GPSVT_soc.lef \        
                           ${DK_PATH}/CLOCK65GPSVT_3.1/CADENCE/LEF/CLOCK65GPSVT_soc.lef \
                           ${DK_PATH}/IO65LPHVT_SF_1V8_50A_7M4X0Y2Z_7.0/CADENCE/LEF/IO65LPHVT_SF_1V8_50A_7M4X0Y2Z_soc.lef \
                           ${DK_PATH}/IO65LPHVT_CORESUPPLY_50A_7M4X0Y2Z@7.0.c.UD5357/CADENCE/LEF/IO65LPHVT_CORESUPPLY_50A_7M4X0Y2Z_gaph.lef \
                           ${DK_PATH}/IO65LP_SF_BASIC_50A_ST_7M4X0Y2Z_7.2/CADENCE/LEF/IO65LP_SF_BASIC_50A_ST_7M4X0Y2Z_soc.lef"

#Set captable
set_db cap_table_file ${DK_PATH}/EncounterTechnoKit_cmos065_7m4x0y2z_AP@5.3.1/TECH/cmos065_7m4x0y2z_AP_Worst.captable

#Set PLE
set_db interconnect_mode ple
