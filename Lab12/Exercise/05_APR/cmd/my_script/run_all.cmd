#====================================================================
# RUN
#====================================================================
# source ./cmd/run_all.cmd


#====================================================================
# Initial Setting
#====================================================================
source ./cmd/apr_setting.cmd


#====================================================================
# Specify floorplan
#====================================================================
source ./cmd/floorPlan.cmd
# saveDesign ./DBS/CHIP_floorplan.inn

#====================================================================
# Power Ring
#====================================================================
source ./cmd/powerRing.cmd

#====================================================================
#  Add Power Stripes
#====================================================================
source ./cmd/powerStripe.cmd
# saveDesign ./DBS/CHIP_powerplan.inn


#====================================================================
#  Set Placement Blockage & Placement Std Cell
#====================================================================
source ./cmd/place.cmd

# Optimization
# source ./cmd/pre_CTS_opt.cmd
# saveDesign ./DBS/CHIP_placement.inn


#====================================================================
#  Clock Tree Synthesis (CTS)
#====================================================================
source ./cmd/ccopt.cmd
source ./cmd/postCTSTiming.cmd

# Optimization
# source ./cmd/post_CTS_setup_opt.cmd
# source ./cmd/post_CTS_hold_opt.cmd
# saveDesign ./DBS/CHIP_CTS.inn

#====================================================================
#  Add PAD Filler  (If no pad, skip this step)
#====================================================================
source ./cmd/addIOFiller.cmd

#====================================================================
#  SI-Prevention Detail Route (NanoRoute)
#====================================================================
source ./cmd/nanoRoute.cmd

source ./cmd/postRouteVerify.cmd
# saveDesign ./DBS/CHIP_nanoRoute.inn


#====================================================================
#   In-Place Optimization (consider crosstalk effects)
#====================================================================
source ./cmd/IPO.cmd


#====================================================================
#   Routing Timing check
#====================================================================
source ./cmd/postRouteTiming.cmd

# Optimization
# source ./cmd/post_route_setup_opt.cmd
# source ./cmd/post_route_hold_opt.cmd


#====================================================================
#   Add CORE Filler Cells
#====================================================================
source ./cmd/addFiller.cmd


#====================================================================
#   Final Check
#====================================================================
source ./cmd/final_LVS.cmd
source ./cmd/final_DRC.cmd
source ./cmd/final_setup.cmd
source ./cmd/final_hold.cmd


#====================================================================
# Stream Out and Write Netlist
#====================================================================
source ./cmd/write_file.cmd
