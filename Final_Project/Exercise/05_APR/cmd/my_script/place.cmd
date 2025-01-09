#====================================================================
#  Set Placement Blockage & Placement Std Cell
#====================================================================
setPlaceMode -prerouteAsObs {2 3}
setPlaceMode -fp false
place_design -noPrePlaceOpt

#====================================================================
#  Check Timing
#====================================================================
timeDesign -preCTS -pathReports -drvReports -slackReports -numPaths 50 -prefix CHIP_preCTS -outDir timingReports

