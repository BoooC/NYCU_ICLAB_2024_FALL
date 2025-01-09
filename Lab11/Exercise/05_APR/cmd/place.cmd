setPlaceMode -prerouteAsObs {2 3}
setPlaceMode -fp false
place_design -noPrePlaceOpt

saveDesign ./DBS/CHIP_placement.inn
