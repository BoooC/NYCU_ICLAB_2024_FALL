getFillerMode -quiet
addFiller -cell FILLER64 FILLER32 FILLER16 FILLER8 FILLER4 FILLER2 FILLER1 -prefix FILLER

addMetalFill -layer { metal1 metal2 metal3 metal4 metal5 metal6 } -timingAware sta -slackThreshold 0.2
