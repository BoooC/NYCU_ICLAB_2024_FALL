createBasicPathGroups -expanded
get_path_groups
setPlaceMode -prerouteAsObs {2 3}
place_opt_design

redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -preCTS -pathReports -drvReports -slackReports -numPaths 50 -prefix CHIP_preCTS -outDir timingReports

setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -preCTS

saveDesign ./DBS/CHIP_preCTS.inn
