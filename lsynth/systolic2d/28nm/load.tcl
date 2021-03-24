##############################################################
##              Logical synthesis commands                  ##
## Modified  by Fernando Moraes - 29/set/2012               ##
##############################################################

#===============================================================================
## load synthesis configuration, read description and elaborate design 
#===============================================================================

set REPORTS_PATH "reports/"
set DESIGN_TOP "systolic2d"
set OUTPUTS_PATH "outputs/"

set_db script_search_path "./"
set_db hdl_search_path "../../../rtl/arrays ../../../rtl/components"
set_db information_level 9 

set_db hdl_track_filename_row_col true
set_db hdl_array_naming_style %s_%d
set_db hdl_instance_array_naming_style %s_%d
set_db hdl_generate_index_style %s_%d
set_db hdl_bus_wire_naming_style %s_%d

#===============================================================================
#  Load libraries
#===============================================================================
#Set liberty
set_db library "/soft64/design-kits/stm/28nm-cmos28fdsoi_25d/C28SOI_SC_12_CORE_LR@2.0@20130411.0/libs/C28SOI_SC_12_CORE_LR_ss28_0.90V_125C.lib \
                /soft64/design-kits/stm/28nm-cmos28fdsoi_25d/C28SOI_SC_12_PR_LR@2.0@20130412.0/libs/C28SOI_SC_12_PR_LR_tt28_1.00V_25C.lib \
                /soft64/design-kits/stm/28nm-cmos28fdsoi_25d/C28SOI_SC_12_CLK_LR@2.1@20130621.0/libs/C28SOI_SC_12_CLK_LR_tt28_1.00V_25C.lib"
             
#set LEF           
set_db lef_library "/soft64/design-kits/stm/28nm-cmos28fdsoi_25d/SiteDefKit_cmos28@1.4@20120720.0/LEF/sites.lef \
                    /home/leonardo.juracy/Rep/conv_modules_ppa/psynth/${DESIGN_TOP}/28nm/lef/technology.12T.lef \
                    /soft64/design-kits/stm/28nm-cmos28fdsoi_25d/C28SOI_SC_12_CORE_LR@2.0@20130411.0/CADENCE/LEF/C28SOI_SC_12_CORE_LR_soc.lef \
                    /soft64/design-kits/stm/28nm-cmos28fdsoi_25d/C28SOI_SC_12_PR_LR@2.0@20130412.0/CADENCE/LEF/C28SOI_SC_12_PR_LR_soc.lef \
                    /soft64/design-kits/stm/28nm-cmos28fdsoi_25d/C28SOI_SC_12_CLK_LR@2.1@20130621.0/CADENCE/LEF/C28SOI_SC_12_CLK_LR_soc.lef"

#Set captable
set_db cap_table_file "/soft64/design-kits/stm/28nm-cmos28lp_42/CadenceTechnoKit_cmos028_6U1x_2U2x_2T8x_LB@4.2.1/CAP_TABLE/FuncRCmax.captable"

#Set PLE
set_db interconnect_mode ple
