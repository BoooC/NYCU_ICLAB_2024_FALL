#====================================================================
#   In-Place Optimization (consider crosstalk effects)
#====================================================================
setAnalysisMode -cppr none -clockGatingCheck true -timeBorrowing true -useOutputPinCap true -sequentialConstProp false -timingSelfLoopsNoSkew false -enableMultipleDriveNet true -clkSrcPath true -warn true -usefulSkew true -analysisType onChipVariation -log true
setExtractRCMode -engine postRoute -effortLevel signoff -coupled true -capFilterMode relOnly -coupling_c_th 3 -total_c_th 5 -relative_c_th 0.03 -lefTechFileMap ./layermap/lefdef.layermap.cmd
set_db extract_rc_engine post_route
set_db extract_rc_effort_level high
set_db delaycal_enable_si true

#setExtractRCMode -engine postRoute
#setExtractRCMode -effortLevel high
#setDelayCalMode -SIAware true