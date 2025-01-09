#======================================================
#
# Synopsys Synthesis Scripts (Design Vision dctcl mode)
#
#======================================================

#======================================================
# (A) Global Parameters
#======================================================
set DESIGN "SA"
set clock_gating_module_name "GATED_OR"
set CYCLE 50.0
set INPUT_DLY [expr 0.5*$CYCLE]
set OUTPUT_DLY [expr 0.5*$CYCLE]

#======================================================
# (B) Read RTL Code
#======================================================
set hdlin_auto_save_templates TRUE
read_verilog {./Netlist/GATED_OR_SYN.v}
set_dont_touch $clock_gating_module_name
analyze -f sverilog $DESIGN\.v 
elaborate $DESIGN 

current_design $DESIGN
link 

#======================================================
#  (C) Global Setting
#======================================================
#set_wire_load_mode top
#set_wire_load_model -name umc18_wl10 -library slow
#set_operating_conditions -min fast  -max slow

#======================================================
#  (D) Set Design Constraints
#======================================================

create_clock -name "clk" -period $CYCLE clk 
set_input_delay  [ expr $CYCLE*0.5 ] -clock clk [all_inputs]
set_output_delay [ expr $CYCLE*0.5 ] -clock clk [all_outputs]
set_input_delay 0 -clock clk clk
set_input_delay 0 -clock clk rst_n
set_input_delay 0 -clock clk cg_en

set_load 0.05 [all_outputs]
set_max_delay $CYCLE -from [all_inputs] -to [all_outputs]

set_max_transition      3       [all_inputs]   ; # U18 LUT Max Transition Value  
set_max_capacitance     0.15    [all_inputs]   ; # U18 LUT Max Capacitance Value
set_max_fanout          10      [all_inputs]

#======================================================
#  (E) Optimization
#======================================================
check_design > Report/$DESIGN\.check
uniquify
set_fix_multiple_port_nets -all -buffer_constants

current_design $DESIGN
set_false_path -from clk -to [get_cells */latch_or_sleep_reg ]

compile_ultra
#compile

#======================================================
#  (F) Output Reports 
#======================================================
report_timing >  Report/$DESIGN\.timing
report_area >  Report/$DESIGN\.area
report_resource >  Report/$DESIGN\.resource
#report_reference > Report/$DESIGN\.reference

#======================================================
#  (G) Change Naming Rule
#======================================================
set bus_inference_style "%s\[%d\]"
set bus_naming_style "%s\[%d\]"
set hdlout_internal_busses true
change_names -hierarchy -rule verilog
define_name_rules name_rule -allowed "a-z A-Z 0-9 _" -max_length 255 -type cell
define_name_rules name_rule -allowed "a-z A-Z 0-9 _[]" -max_length 255 -type net
define_name_rules name_rule -map {{"\\*cell\\*" "cell"}}
change_names -hierarchy -rules name_rule


#======================================================
#  (H) Output Results
#======================================================
set verilogout_higher_designs_first true
write -format verilog -output Netlist/$DESIGN\_SYN.v -hierarchy

write_sdf -version 3.0 -context verilog -load_delay cell Netlist/$DESIGN\_SYN.sdf -significant_digits 6
write_sdc Netlist/$DESIGN\_SYN.sdc

#======================================================
#  (I) Finish and Quit
#======================================================

report_area -designware -hierarchy
report_timing
exit
