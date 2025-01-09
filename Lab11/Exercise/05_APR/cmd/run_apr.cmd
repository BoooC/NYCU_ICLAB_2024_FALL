# ========================================================
# Project:  iclab APR Flow
# File:     run_apr.cmd
# Author:   Lai Lin-Hung @ Si2 Lab
# Date:     2023.07.25
# ========================================================
############################################
############  Paremeter setting  ###########
############################################
set ProcessRoot "/RAID2/COURSE/BackUp/2023_Spring/iclab/iclabta01/UMC018_CBDK/CIC/SOCE/"
set MemoryRoot "../Memory/ftclib_200901.2.1/EXE/"
set NUM_OF_CPU 48
set mmmcFile "mmmc.view"
set lefFile "
    $ProcessRoot/lef/header6_V55_20ka_cic.lef
    $ProcessRoot/lef/fsa0m_a_generic_core.lef
    $ProcessRoot/lef/FSA0M_A_GENERIC_CORE_ANT_V55.lef
    $ProcessRoot/lef/fsa0m_a_t33_generic_io.lef
    $ProcessRoot/lef/FSA0M_A_T33_GENERIC_IO_ANT_V55.lef
    $ProcessRoot/lef/BONDPAD.lef
    ../04_MEM/SRAM_80X40.lef
    ../04_MEM/SRAM_512X128.lef
    ../04_MEM/SRAM_1296X20.lef
"
set topDesign "CHIP"
set verilogFile "./CHIP_SYN.v"
set ioFile "./CHIP.io"
set pwrNet "VCC"
set gndNet "GND"

############################################
############  APR UMC018 setting ###########
############################################
set init_design_uniquify 1
setDesignMode -process 180
suppressMessage TECHLIB 1318
suppressMessage ENCEXT-2799
############################################
############  Initial Design     ###########
############################################
set init_mmmc_file $mmmcFile
set init_lef_file $lefFile
set init_verilog $verilogFile
set init_top_cell $topDesign
set init_io_file $ioFile
set init_pwr_net $pwrNet
set init_gnd_net $gndNet
init_design -setup {av_func_mode_max} -hold {av_func_mode_min}

save_global CHIP.globals
win


