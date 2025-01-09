
set mmmcFile "mmmc.view"
set lefFile "
    LEF/header6_V55_20ka_cic.lef
    LEF/fsa0m_a_generic_core.lef
    LEF/FSA0M_A_GENERIC_CORE_ANT_V55.lef
    LEF/fsa0m_a_t33_generic_io.lef
    LEF/FSA0M_A_T33_GENERIC_IO_ANT_V55.lef
    LEF/BONDPAD.lef
"
set topDesign "CHIP"
set verilogFile "CHIP_SYN.v"
set ioFile "CHIP.io"
set pwrNet "VCC"
set gndNet "GND"


set init_mmmc_file $mmmcFile
set init_lef_file $lefFile
set init_verilog $verilogFile
set init_top_cell $topDesign
#set init_io_file $ioFile
set init_pwr_net $pwrNet
set init_gnd_net $gndNet
init_design -setup {av_func_mode_max} -hold {av_func_mode_min}

save_global CHIP.globals
win
