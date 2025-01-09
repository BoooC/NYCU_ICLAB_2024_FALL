###################################################################

# Created by write_sdc on Tue Jul 25 03:44:35 2023

###################################################################
set sdc_version 2.1

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_operating_conditions -max slow -max_library slow\
                         -min fast -min_library fast

create_clock [get_ports clk]  -period 3.5  -waveform {0 1.75}
set_drive 0.1 [all_inputs]
set_load -pin_load 20 [all_outputs]
set_input_delay   1.75 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay  1.75 -clock clk [all_outputs]
