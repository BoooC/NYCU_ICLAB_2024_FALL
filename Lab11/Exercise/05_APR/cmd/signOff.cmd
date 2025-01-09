redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -signoff -pathReports -drvReports -slackReports -numPaths 50 -prefix CHIP_signOff -outDir timingReports

redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -signoff -hold -pathReports -slackReports -numPaths 50 -prefix CHIP_signOff -outDir timingReports

#setMultiCpuUsage -remoteHost 8
#signoffOptDesign -setup
#signoffOptDesign -hold
