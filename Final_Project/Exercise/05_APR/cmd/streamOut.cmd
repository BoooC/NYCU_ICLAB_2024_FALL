set ProcessRoot "/RAID2/COURSE/BackUp/2023_Spring/iclab/iclabta01/UMC018_CBDK/CIC/SOCE/"
set MemGDSFile "../04_MEM/"

setAnalysisMode -analysisType bcwc
write_sdf   -max_view av_func_mode_max \
            -min_view av_func_mode_min \
            -edges noedge \
            -splitsetuphold \
            -remashold \
            -splitrecrem \
            -min_period_edges none \
            ./StreamOut/CHIP.sdf

setStreamOutMode -specifyViaName default -SEvianames false -virtualConnection false -uniquifyCellNamesPrefix false -snapToMGrid false -textSize 1 -version 3
streamOut ./StreamOut/CHIP.gds \
            -mapFile  $ProcessRoot/streamOut.map \
            -merge "  $ProcessRoot/../Phantom/fsa0m_a_generic_core_cic.gds $ProcessRoot/../Phantom/fsa0m_a_t33_generic_io_cic.gds" \
            -stripes 1 -units 1000 -mode ALL

        
saveNetlist ./StreamOut/CHIP.v
saveNetlist -includePowerGround ./StreamOut/CHIP_PG.v

saveDesign ./DBS/CHIP.inn
