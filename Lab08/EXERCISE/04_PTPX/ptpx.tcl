#======================================================
#
# PrimeTime  Scripts (dctcl mode)
#
#======================================================

#======================================================
#  1. Set the Power Analysis Mode
#======================================================

set power_enable_analysis true
set power_analysis_mode time_based
set power_report_leakage_breakdowns true
set power_clock_network_include_register_clock_pin_power false

#======================================================
#  2. Read and link the design
#======================================================
set search_path         " ./ \
                        ./File/ \
			../01_RTL                     \
                        ~iclabTA01/UMC018_CBDK/CIC/SynopsysDC/db/    \
                        ~iclabTA01/UMC018_CBDK/CIC/Sdb/          \
                        /usr/cad/synopsys/synthesis/cur/libraries/syn/ \
                        /usr/cad/synopsys/synthesis/cur/dw "
set target_library      " fsa0m_a_generic_core_ss1p62v125c.db \
                        fsa0m_a_generic_core_ff1p98vm40c.db \
                        fsa0m_a_t33_generic_io_ss1p62v125c.db \
                        fsa0m_a_t33_generic_io_tt1p8v25c.db" 
set link_library        " * $target_library dw_foundation.sldb standard.sldb "
set synthetic_library   " dw_foundation.sldb "

set DESIGN "SA"
read_verilog $DESIGN\_SYN.v
current_design $DESIGN
link

#======================================================
#  3. Set transition time / annotate parasitics
#======================================================
set_input_transition .1 [all_inputs]
read_sdc $DESIGN\_SYN.sdc
read_sdf -load_delay net $DESIGN\_SYN.sdf

#======================================================
#  4. Read Switching Activity File
#======================================================
read_vcd -strip_path TESTBED/I_$DESIGN $DESIGN\_SYN.fsdb

#======================================================
#  5. Perform power analysis
#======================================================
check_power
update_power

#======================================================
#  6. Generate Power Report
#======================================================
# BUG command 

set_power_analysis_options -waveform_interval 1 -waveform_format out -waveform_output vcd
# vcd.out
report_power > Report/$DESIGN\_POWER 
 

exit