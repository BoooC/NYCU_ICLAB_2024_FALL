###################################################################

# Created by write_sdc on Fri Nov 15 17:38:43 2024

###################################################################
set sdc_version 2.1

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_load -pin_load 0.05 [get_ports out_valid]
set_load -pin_load 0.05 [get_ports {out_data[63]}]
set_load -pin_load 0.05 [get_ports {out_data[62]}]
set_load -pin_load 0.05 [get_ports {out_data[61]}]
set_load -pin_load 0.05 [get_ports {out_data[60]}]
set_load -pin_load 0.05 [get_ports {out_data[59]}]
set_load -pin_load 0.05 [get_ports {out_data[58]}]
set_load -pin_load 0.05 [get_ports {out_data[57]}]
set_load -pin_load 0.05 [get_ports {out_data[56]}]
set_load -pin_load 0.05 [get_ports {out_data[55]}]
set_load -pin_load 0.05 [get_ports {out_data[54]}]
set_load -pin_load 0.05 [get_ports {out_data[53]}]
set_load -pin_load 0.05 [get_ports {out_data[52]}]
set_load -pin_load 0.05 [get_ports {out_data[51]}]
set_load -pin_load 0.05 [get_ports {out_data[50]}]
set_load -pin_load 0.05 [get_ports {out_data[49]}]
set_load -pin_load 0.05 [get_ports {out_data[48]}]
set_load -pin_load 0.05 [get_ports {out_data[47]}]
set_load -pin_load 0.05 [get_ports {out_data[46]}]
set_load -pin_load 0.05 [get_ports {out_data[45]}]
set_load -pin_load 0.05 [get_ports {out_data[44]}]
set_load -pin_load 0.05 [get_ports {out_data[43]}]
set_load -pin_load 0.05 [get_ports {out_data[42]}]
set_load -pin_load 0.05 [get_ports {out_data[41]}]
set_load -pin_load 0.05 [get_ports {out_data[40]}]
set_load -pin_load 0.05 [get_ports {out_data[39]}]
set_load -pin_load 0.05 [get_ports {out_data[38]}]
set_load -pin_load 0.05 [get_ports {out_data[37]}]
set_load -pin_load 0.05 [get_ports {out_data[36]}]
set_load -pin_load 0.05 [get_ports {out_data[35]}]
set_load -pin_load 0.05 [get_ports {out_data[34]}]
set_load -pin_load 0.05 [get_ports {out_data[33]}]
set_load -pin_load 0.05 [get_ports {out_data[32]}]
set_load -pin_load 0.05 [get_ports {out_data[31]}]
set_load -pin_load 0.05 [get_ports {out_data[30]}]
set_load -pin_load 0.05 [get_ports {out_data[29]}]
set_load -pin_load 0.05 [get_ports {out_data[28]}]
set_load -pin_load 0.05 [get_ports {out_data[27]}]
set_load -pin_load 0.05 [get_ports {out_data[26]}]
set_load -pin_load 0.05 [get_ports {out_data[25]}]
set_load -pin_load 0.05 [get_ports {out_data[24]}]
set_load -pin_load 0.05 [get_ports {out_data[23]}]
set_load -pin_load 0.05 [get_ports {out_data[22]}]
set_load -pin_load 0.05 [get_ports {out_data[21]}]
set_load -pin_load 0.05 [get_ports {out_data[20]}]
set_load -pin_load 0.05 [get_ports {out_data[19]}]
set_load -pin_load 0.05 [get_ports {out_data[18]}]
set_load -pin_load 0.05 [get_ports {out_data[17]}]
set_load -pin_load 0.05 [get_ports {out_data[16]}]
set_load -pin_load 0.05 [get_ports {out_data[15]}]
set_load -pin_load 0.05 [get_ports {out_data[14]}]
set_load -pin_load 0.05 [get_ports {out_data[13]}]
set_load -pin_load 0.05 [get_ports {out_data[12]}]
set_load -pin_load 0.05 [get_ports {out_data[11]}]
set_load -pin_load 0.05 [get_ports {out_data[10]}]
set_load -pin_load 0.05 [get_ports {out_data[9]}]
set_load -pin_load 0.05 [get_ports {out_data[8]}]
set_load -pin_load 0.05 [get_ports {out_data[7]}]
set_load -pin_load 0.05 [get_ports {out_data[6]}]
set_load -pin_load 0.05 [get_ports {out_data[5]}]
set_load -pin_load 0.05 [get_ports {out_data[4]}]
set_load -pin_load 0.05 [get_ports {out_data[3]}]
set_load -pin_load 0.05 [get_ports {out_data[2]}]
set_load -pin_load 0.05 [get_ports {out_data[1]}]
set_load -pin_load 0.05 [get_ports {out_data[0]}]
set_max_capacitance 0.15 [get_ports clk]
set_max_capacitance 0.15 [get_ports rst_n]
set_max_capacitance 0.15 [get_ports cg_en]
set_max_capacitance 0.15 [get_ports in_valid]
set_max_capacitance 0.15 [get_ports {T[3]}]
set_max_capacitance 0.15 [get_ports {T[2]}]
set_max_capacitance 0.15 [get_ports {T[1]}]
set_max_capacitance 0.15 [get_ports {T[0]}]
set_max_capacitance 0.15 [get_ports {in_data[7]}]
set_max_capacitance 0.15 [get_ports {in_data[6]}]
set_max_capacitance 0.15 [get_ports {in_data[5]}]
set_max_capacitance 0.15 [get_ports {in_data[4]}]
set_max_capacitance 0.15 [get_ports {in_data[3]}]
set_max_capacitance 0.15 [get_ports {in_data[2]}]
set_max_capacitance 0.15 [get_ports {in_data[1]}]
set_max_capacitance 0.15 [get_ports {in_data[0]}]
set_max_capacitance 0.15 [get_ports {w_Q[7]}]
set_max_capacitance 0.15 [get_ports {w_Q[6]}]
set_max_capacitance 0.15 [get_ports {w_Q[5]}]
set_max_capacitance 0.15 [get_ports {w_Q[4]}]
set_max_capacitance 0.15 [get_ports {w_Q[3]}]
set_max_capacitance 0.15 [get_ports {w_Q[2]}]
set_max_capacitance 0.15 [get_ports {w_Q[1]}]
set_max_capacitance 0.15 [get_ports {w_Q[0]}]
set_max_capacitance 0.15 [get_ports {w_K[7]}]
set_max_capacitance 0.15 [get_ports {w_K[6]}]
set_max_capacitance 0.15 [get_ports {w_K[5]}]
set_max_capacitance 0.15 [get_ports {w_K[4]}]
set_max_capacitance 0.15 [get_ports {w_K[3]}]
set_max_capacitance 0.15 [get_ports {w_K[2]}]
set_max_capacitance 0.15 [get_ports {w_K[1]}]
set_max_capacitance 0.15 [get_ports {w_K[0]}]
set_max_capacitance 0.15 [get_ports {w_V[7]}]
set_max_capacitance 0.15 [get_ports {w_V[6]}]
set_max_capacitance 0.15 [get_ports {w_V[5]}]
set_max_capacitance 0.15 [get_ports {w_V[4]}]
set_max_capacitance 0.15 [get_ports {w_V[3]}]
set_max_capacitance 0.15 [get_ports {w_V[2]}]
set_max_capacitance 0.15 [get_ports {w_V[1]}]
set_max_capacitance 0.15 [get_ports {w_V[0]}]
set_max_fanout 10 [get_ports clk]
set_max_fanout 10 [get_ports rst_n]
set_max_fanout 10 [get_ports cg_en]
set_max_fanout 10 [get_ports in_valid]
set_max_fanout 10 [get_ports {T[3]}]
set_max_fanout 10 [get_ports {T[2]}]
set_max_fanout 10 [get_ports {T[1]}]
set_max_fanout 10 [get_ports {T[0]}]
set_max_fanout 10 [get_ports {in_data[7]}]
set_max_fanout 10 [get_ports {in_data[6]}]
set_max_fanout 10 [get_ports {in_data[5]}]
set_max_fanout 10 [get_ports {in_data[4]}]
set_max_fanout 10 [get_ports {in_data[3]}]
set_max_fanout 10 [get_ports {in_data[2]}]
set_max_fanout 10 [get_ports {in_data[1]}]
set_max_fanout 10 [get_ports {in_data[0]}]
set_max_fanout 10 [get_ports {w_Q[7]}]
set_max_fanout 10 [get_ports {w_Q[6]}]
set_max_fanout 10 [get_ports {w_Q[5]}]
set_max_fanout 10 [get_ports {w_Q[4]}]
set_max_fanout 10 [get_ports {w_Q[3]}]
set_max_fanout 10 [get_ports {w_Q[2]}]
set_max_fanout 10 [get_ports {w_Q[1]}]
set_max_fanout 10 [get_ports {w_Q[0]}]
set_max_fanout 10 [get_ports {w_K[7]}]
set_max_fanout 10 [get_ports {w_K[6]}]
set_max_fanout 10 [get_ports {w_K[5]}]
set_max_fanout 10 [get_ports {w_K[4]}]
set_max_fanout 10 [get_ports {w_K[3]}]
set_max_fanout 10 [get_ports {w_K[2]}]
set_max_fanout 10 [get_ports {w_K[1]}]
set_max_fanout 10 [get_ports {w_K[0]}]
set_max_fanout 10 [get_ports {w_V[7]}]
set_max_fanout 10 [get_ports {w_V[6]}]
set_max_fanout 10 [get_ports {w_V[5]}]
set_max_fanout 10 [get_ports {w_V[4]}]
set_max_fanout 10 [get_ports {w_V[3]}]
set_max_fanout 10 [get_ports {w_V[2]}]
set_max_fanout 10 [get_ports {w_V[1]}]
set_max_fanout 10 [get_ports {w_V[0]}]
set_max_transition 3 [get_ports clk]
set_max_transition 3 [get_ports rst_n]
set_max_transition 3 [get_ports cg_en]
set_max_transition 3 [get_ports in_valid]
set_max_transition 3 [get_ports {T[3]}]
set_max_transition 3 [get_ports {T[2]}]
set_max_transition 3 [get_ports {T[1]}]
set_max_transition 3 [get_ports {T[0]}]
set_max_transition 3 [get_ports {in_data[7]}]
set_max_transition 3 [get_ports {in_data[6]}]
set_max_transition 3 [get_ports {in_data[5]}]
set_max_transition 3 [get_ports {in_data[4]}]
set_max_transition 3 [get_ports {in_data[3]}]
set_max_transition 3 [get_ports {in_data[2]}]
set_max_transition 3 [get_ports {in_data[1]}]
set_max_transition 3 [get_ports {in_data[0]}]
set_max_transition 3 [get_ports {w_Q[7]}]
set_max_transition 3 [get_ports {w_Q[6]}]
set_max_transition 3 [get_ports {w_Q[5]}]
set_max_transition 3 [get_ports {w_Q[4]}]
set_max_transition 3 [get_ports {w_Q[3]}]
set_max_transition 3 [get_ports {w_Q[2]}]
set_max_transition 3 [get_ports {w_Q[1]}]
set_max_transition 3 [get_ports {w_Q[0]}]
set_max_transition 3 [get_ports {w_K[7]}]
set_max_transition 3 [get_ports {w_K[6]}]
set_max_transition 3 [get_ports {w_K[5]}]
set_max_transition 3 [get_ports {w_K[4]}]
set_max_transition 3 [get_ports {w_K[3]}]
set_max_transition 3 [get_ports {w_K[2]}]
set_max_transition 3 [get_ports {w_K[1]}]
set_max_transition 3 [get_ports {w_K[0]}]
set_max_transition 3 [get_ports {w_V[7]}]
set_max_transition 3 [get_ports {w_V[6]}]
set_max_transition 3 [get_ports {w_V[5]}]
set_max_transition 3 [get_ports {w_V[4]}]
set_max_transition 3 [get_ports {w_V[3]}]
set_max_transition 3 [get_ports {w_V[2]}]
set_max_transition 3 [get_ports {w_V[1]}]
set_max_transition 3 [get_ports {w_V[0]}]
create_clock [get_ports clk]  -period 50  -waveform {0 25}
set_max_delay 50  -from [list [get_ports clk] [get_ports rst_n] [get_ports cg_en] [get_ports    \
in_valid] [get_ports {T[3]}] [get_ports {T[2]}] [get_ports {T[1]}] [get_ports  \
{T[0]}] [get_ports {in_data[7]}] [get_ports {in_data[6]}] [get_ports           \
{in_data[5]}] [get_ports {in_data[4]}] [get_ports {in_data[3]}] [get_ports     \
{in_data[2]}] [get_ports {in_data[1]}] [get_ports {in_data[0]}] [get_ports     \
{w_Q[7]}] [get_ports {w_Q[6]}] [get_ports {w_Q[5]}] [get_ports {w_Q[4]}]       \
[get_ports {w_Q[3]}] [get_ports {w_Q[2]}] [get_ports {w_Q[1]}] [get_ports      \
{w_Q[0]}] [get_ports {w_K[7]}] [get_ports {w_K[6]}] [get_ports {w_K[5]}]       \
[get_ports {w_K[4]}] [get_ports {w_K[3]}] [get_ports {w_K[2]}] [get_ports      \
{w_K[1]}] [get_ports {w_K[0]}] [get_ports {w_V[7]}] [get_ports {w_V[6]}]       \
[get_ports {w_V[5]}] [get_ports {w_V[4]}] [get_ports {w_V[3]}] [get_ports      \
{w_V[2]}] [get_ports {w_V[1]}] [get_ports {w_V[0]}]]  -to [list [get_ports out_valid] [get_ports {out_data[63]}] [get_ports         \
{out_data[62]}] [get_ports {out_data[61]}] [get_ports {out_data[60]}]          \
[get_ports {out_data[59]}] [get_ports {out_data[58]}] [get_ports               \
{out_data[57]}] [get_ports {out_data[56]}] [get_ports {out_data[55]}]          \
[get_ports {out_data[54]}] [get_ports {out_data[53]}] [get_ports               \
{out_data[52]}] [get_ports {out_data[51]}] [get_ports {out_data[50]}]          \
[get_ports {out_data[49]}] [get_ports {out_data[48]}] [get_ports               \
{out_data[47]}] [get_ports {out_data[46]}] [get_ports {out_data[45]}]          \
[get_ports {out_data[44]}] [get_ports {out_data[43]}] [get_ports               \
{out_data[42]}] [get_ports {out_data[41]}] [get_ports {out_data[40]}]          \
[get_ports {out_data[39]}] [get_ports {out_data[38]}] [get_ports               \
{out_data[37]}] [get_ports {out_data[36]}] [get_ports {out_data[35]}]          \
[get_ports {out_data[34]}] [get_ports {out_data[33]}] [get_ports               \
{out_data[32]}] [get_ports {out_data[31]}] [get_ports {out_data[30]}]          \
[get_ports {out_data[29]}] [get_ports {out_data[28]}] [get_ports               \
{out_data[27]}] [get_ports {out_data[26]}] [get_ports {out_data[25]}]          \
[get_ports {out_data[24]}] [get_ports {out_data[23]}] [get_ports               \
{out_data[22]}] [get_ports {out_data[21]}] [get_ports {out_data[20]}]          \
[get_ports {out_data[19]}] [get_ports {out_data[18]}] [get_ports               \
{out_data[17]}] [get_ports {out_data[16]}] [get_ports {out_data[15]}]          \
[get_ports {out_data[14]}] [get_ports {out_data[13]}] [get_ports               \
{out_data[12]}] [get_ports {out_data[11]}] [get_ports {out_data[10]}]          \
[get_ports {out_data[9]}] [get_ports {out_data[8]}] [get_ports {out_data[7]}]  \
[get_ports {out_data[6]}] [get_ports {out_data[5]}] [get_ports {out_data[4]}]  \
[get_ports {out_data[3]}] [get_ports {out_data[2]}] [get_ports {out_data[1]}]  \
[get_ports {out_data[0]}]]
set_false_path   -from [get_clocks clk]  -to [list [get_cells GATED_out_reg/latch_or_sleep_reg] [get_cells             \
genblk7_7__GATED_P/latch_or_sleep_reg] [get_cells                              \
genblk7_6__GATED_P/latch_or_sleep_reg] [get_cells                              \
genblk7_5__GATED_P/latch_or_sleep_reg] [get_cells                              \
genblk7_4__GATED_P/latch_or_sleep_reg] [get_cells                              \
genblk7_3__GATED_P/latch_or_sleep_reg] [get_cells                              \
genblk7_2__GATED_P/latch_or_sleep_reg] [get_cells                              \
genblk7_1__GATED_P/latch_or_sleep_reg] [get_cells                              \
genblk7_0__GATED_P/latch_or_sleep_reg] [get_cells                              \
genblk6_7__genblk1_7__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_7__genblk1_6__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_7__genblk1_5__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_7__genblk1_4__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_7__genblk1_3__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_7__genblk1_2__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_7__genblk1_1__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_7__genblk1_0__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_6__genblk1_7__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_6__genblk1_6__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_6__genblk1_5__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_6__genblk1_4__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_6__genblk1_3__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_6__genblk1_2__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_6__genblk1_1__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_6__genblk1_0__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_5__genblk1_7__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_5__genblk1_6__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_5__genblk1_5__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_5__genblk1_4__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_5__genblk1_3__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_5__genblk1_2__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_5__genblk1_1__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_5__genblk1_0__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_4__genblk1_7__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_4__genblk1_6__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_4__genblk1_5__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_4__genblk1_4__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_4__genblk1_3__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_4__genblk1_2__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_4__genblk1_1__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_4__genblk1_0__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_3__genblk1_7__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_3__genblk1_6__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_3__genblk1_5__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_3__genblk1_4__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_3__genblk1_3__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_3__genblk1_2__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_3__genblk1_1__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_3__genblk1_0__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_2__genblk1_7__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_2__genblk1_6__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_2__genblk1_5__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_2__genblk1_4__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_2__genblk1_3__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_2__genblk1_2__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_2__genblk1_1__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_2__genblk1_0__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_1__genblk1_7__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_1__genblk1_6__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_1__genblk1_5__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_1__genblk1_4__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_1__genblk1_3__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_1__genblk1_2__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_1__genblk1_1__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_1__genblk1_0__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_0__genblk1_7__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_0__genblk1_6__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_0__genblk1_5__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_0__genblk1_4__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_0__genblk1_3__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_0__genblk1_2__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_0__genblk1_1__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk6_0__genblk1_0__GATED_QK/latch_or_sleep_reg] [get_cells                  \
genblk5_7__genblk1_7__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_7__genblk1_6__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_7__genblk1_5__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_7__genblk1_4__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_7__genblk1_3__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_7__genblk1_2__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_7__genblk1_1__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_7__genblk1_0__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_6__genblk1_7__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_6__genblk1_6__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_6__genblk1_5__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_6__genblk1_4__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_6__genblk1_3__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_6__genblk1_2__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_6__genblk1_1__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_6__genblk1_0__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_5__genblk1_7__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_5__genblk1_6__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_5__genblk1_5__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_5__genblk1_4__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_5__genblk1_3__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_5__genblk1_2__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_5__genblk1_1__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_5__genblk1_0__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_4__genblk1_7__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_4__genblk1_6__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_4__genblk1_5__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_4__genblk1_4__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_4__genblk1_3__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_4__genblk1_2__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_4__genblk1_1__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_4__genblk1_0__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_3__genblk1_7__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_3__genblk1_6__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_3__genblk1_5__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_3__genblk1_4__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_3__genblk1_3__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_3__genblk1_2__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_3__genblk1_1__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_3__genblk1_0__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_2__genblk1_7__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_2__genblk1_6__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_2__genblk1_5__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_2__genblk1_4__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_2__genblk1_3__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_2__genblk1_2__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_2__genblk1_1__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_2__genblk1_0__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_1__genblk1_7__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_1__genblk1_6__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_1__genblk1_5__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_1__genblk1_4__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_1__genblk1_3__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_1__genblk1_2__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_1__genblk1_1__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_1__genblk1_0__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_0__genblk1_7__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_0__genblk1_6__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_0__genblk1_5__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_0__genblk1_4__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_0__genblk1_3__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_0__genblk1_2__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_0__genblk1_1__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk5_0__genblk1_0__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_7__genblk1_7__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_7__genblk1_6__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_7__genblk1_5__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_7__genblk1_4__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_7__genblk1_3__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_7__genblk1_2__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_7__genblk1_1__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_7__genblk1_0__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_6__genblk1_7__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_6__genblk1_6__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_6__genblk1_5__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_6__genblk1_4__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_6__genblk1_3__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_6__genblk1_2__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_6__genblk1_1__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_6__genblk1_0__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_5__genblk1_7__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_5__genblk1_6__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_5__genblk1_5__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_5__genblk1_4__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_5__genblk1_3__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_5__genblk1_2__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_5__genblk1_1__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_5__genblk1_0__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_4__genblk1_7__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_4__genblk1_6__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_4__genblk1_5__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_4__genblk1_4__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_4__genblk1_3__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_4__genblk1_2__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_4__genblk1_1__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_4__genblk1_0__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_3__genblk1_7__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_3__genblk1_6__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_3__genblk1_5__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_3__genblk1_4__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_3__genblk1_3__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_3__genblk1_2__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_3__genblk1_1__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_3__genblk1_0__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_2__genblk1_7__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_2__genblk1_6__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_2__genblk1_5__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_2__genblk1_4__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_2__genblk1_3__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_2__genblk1_2__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_2__genblk1_1__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_2__genblk1_0__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_1__genblk1_7__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_1__genblk1_6__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_1__genblk1_5__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_1__genblk1_4__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_1__genblk1_3__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_1__genblk1_2__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_1__genblk1_1__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_1__genblk1_0__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_0__genblk1_7__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_0__genblk1_6__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_0__genblk1_5__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_0__genblk1_4__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_0__genblk1_3__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_0__genblk1_2__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_0__genblk1_1__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk4_0__genblk1_0__GATED_K/latch_or_sleep_reg] [get_cells                   \
genblk3_7__genblk1_7__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_7__genblk1_6__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_7__genblk1_5__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_7__genblk1_4__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_7__genblk1_3__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_7__genblk1_2__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_7__genblk1_1__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_7__genblk1_0__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_6__genblk1_7__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_6__genblk1_6__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_6__genblk1_5__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_6__genblk1_4__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_6__genblk1_3__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_6__genblk1_2__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_6__genblk1_1__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_6__genblk1_0__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_5__genblk1_7__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_5__genblk1_6__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_5__genblk1_5__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_5__genblk1_4__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_5__genblk1_3__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_5__genblk1_2__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_5__genblk1_1__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_5__genblk1_0__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_4__genblk1_7__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_4__genblk1_6__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_4__genblk1_5__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_4__genblk1_4__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_4__genblk1_3__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_4__genblk1_2__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_4__genblk1_1__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_4__genblk1_0__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_3__genblk1_7__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_3__genblk1_6__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_3__genblk1_5__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_3__genblk1_4__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_3__genblk1_3__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_3__genblk1_2__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_3__genblk1_1__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_3__genblk1_0__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_2__genblk1_7__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_2__genblk1_6__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_2__genblk1_5__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_2__genblk1_4__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_2__genblk1_3__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_2__genblk1_2__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_2__genblk1_1__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_2__genblk1_0__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_1__genblk1_7__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_1__genblk1_6__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_1__genblk1_5__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_1__genblk1_4__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_1__genblk1_3__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_1__genblk1_2__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_1__genblk1_1__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_1__genblk1_0__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_0__genblk1_7__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_0__genblk1_6__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_0__genblk1_5__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_0__genblk1_4__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_0__genblk1_3__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_0__genblk1_2__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_0__genblk1_1__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk3_0__genblk1_0__GATED_Q/latch_or_sleep_reg] [get_cells                   \
genblk2_7__genblk1_7__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_7__genblk1_6__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_7__genblk1_5__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_7__genblk1_4__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_7__genblk1_3__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_7__genblk1_2__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_7__genblk1_1__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_7__genblk1_0__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_6__genblk1_7__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_6__genblk1_6__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_6__genblk1_5__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_6__genblk1_4__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_6__genblk1_3__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_6__genblk1_2__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_6__genblk1_1__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_6__genblk1_0__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_5__genblk1_7__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_5__genblk1_6__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_5__genblk1_5__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_5__genblk1_4__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_5__genblk1_3__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_5__genblk1_2__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_5__genblk1_1__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_5__genblk1_0__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_4__genblk1_7__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_4__genblk1_6__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_4__genblk1_5__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_4__genblk1_4__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_4__genblk1_3__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_4__genblk1_2__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_4__genblk1_1__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_4__genblk1_0__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_3__genblk1_7__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_3__genblk1_6__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_3__genblk1_5__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_3__genblk1_4__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_3__genblk1_3__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_3__genblk1_2__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_3__genblk1_1__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_3__genblk1_0__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_2__genblk1_7__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_2__genblk1_6__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_2__genblk1_5__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_2__genblk1_4__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_2__genblk1_3__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_2__genblk1_2__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_2__genblk1_1__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_2__genblk1_0__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_1__genblk1_7__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_1__genblk1_6__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_1__genblk1_5__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_1__genblk1_4__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_1__genblk1_3__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_1__genblk1_2__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_1__genblk1_1__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_1__genblk1_0__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_0__genblk1_7__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_0__genblk1_6__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_0__genblk1_5__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_0__genblk1_4__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_0__genblk1_3__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_0__genblk1_2__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_0__genblk1_1__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk2_0__genblk1_0__GATED_weight/latch_or_sleep_reg] [get_cells              \
genblk1_7__genblk1_7__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_7__genblk1_6__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_7__genblk1_5__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_7__genblk1_4__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_7__genblk1_3__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_7__genblk1_2__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_7__genblk1_1__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_7__genblk1_0__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_6__genblk1_7__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_6__genblk1_6__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_6__genblk1_5__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_6__genblk1_4__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_6__genblk1_3__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_6__genblk1_2__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_6__genblk1_1__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_6__genblk1_0__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_5__genblk1_7__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_5__genblk1_6__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_5__genblk1_5__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_5__genblk1_4__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_5__genblk1_3__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_5__genblk1_2__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_5__genblk1_1__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_5__genblk1_0__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_4__genblk1_7__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_4__genblk1_6__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_4__genblk1_5__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_4__genblk1_4__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_4__genblk1_3__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_4__genblk1_2__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_4__genblk1_1__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_4__genblk1_0__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_3__genblk1_7__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_3__genblk1_6__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_3__genblk1_5__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_3__genblk1_4__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_3__genblk1_3__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_3__genblk1_2__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_3__genblk1_1__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_3__genblk1_0__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_2__genblk1_7__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_2__genblk1_6__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_2__genblk1_5__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_2__genblk1_4__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_2__genblk1_3__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_2__genblk1_2__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_2__genblk1_1__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_2__genblk1_0__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_1__genblk1_7__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_1__genblk1_6__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_1__genblk1_5__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_1__genblk1_4__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_1__genblk1_3__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_1__genblk1_2__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_1__genblk1_1__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_1__genblk1_0__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_0__genblk1_7__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_0__genblk1_6__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_0__genblk1_5__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_0__genblk1_4__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_0__genblk1_3__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_0__genblk1_2__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_0__genblk1_1__GATED_in_data/latch_or_sleep_reg] [get_cells             \
genblk1_0__genblk1_0__GATED_in_data/latch_or_sleep_reg]]
set_input_delay -clock clk  0  [get_ports clk]
set_input_delay -clock clk  0  [get_ports rst_n]
set_input_delay -clock clk  0  [get_ports cg_en]
set_input_delay -clock clk  25  [get_ports in_valid]
set_input_delay -clock clk  25  [get_ports {T[3]}]
set_input_delay -clock clk  25  [get_ports {T[2]}]
set_input_delay -clock clk  25  [get_ports {T[1]}]
set_input_delay -clock clk  25  [get_ports {T[0]}]
set_input_delay -clock clk  25  [get_ports {in_data[7]}]
set_input_delay -clock clk  25  [get_ports {in_data[6]}]
set_input_delay -clock clk  25  [get_ports {in_data[5]}]
set_input_delay -clock clk  25  [get_ports {in_data[4]}]
set_input_delay -clock clk  25  [get_ports {in_data[3]}]
set_input_delay -clock clk  25  [get_ports {in_data[2]}]
set_input_delay -clock clk  25  [get_ports {in_data[1]}]
set_input_delay -clock clk  25  [get_ports {in_data[0]}]
set_input_delay -clock clk  25  [get_ports {w_Q[7]}]
set_input_delay -clock clk  25  [get_ports {w_Q[6]}]
set_input_delay -clock clk  25  [get_ports {w_Q[5]}]
set_input_delay -clock clk  25  [get_ports {w_Q[4]}]
set_input_delay -clock clk  25  [get_ports {w_Q[3]}]
set_input_delay -clock clk  25  [get_ports {w_Q[2]}]
set_input_delay -clock clk  25  [get_ports {w_Q[1]}]
set_input_delay -clock clk  25  [get_ports {w_Q[0]}]
set_input_delay -clock clk  25  [get_ports {w_K[7]}]
set_input_delay -clock clk  25  [get_ports {w_K[6]}]
set_input_delay -clock clk  25  [get_ports {w_K[5]}]
set_input_delay -clock clk  25  [get_ports {w_K[4]}]
set_input_delay -clock clk  25  [get_ports {w_K[3]}]
set_input_delay -clock clk  25  [get_ports {w_K[2]}]
set_input_delay -clock clk  25  [get_ports {w_K[1]}]
set_input_delay -clock clk  25  [get_ports {w_K[0]}]
set_input_delay -clock clk  25  [get_ports {w_V[7]}]
set_input_delay -clock clk  25  [get_ports {w_V[6]}]
set_input_delay -clock clk  25  [get_ports {w_V[5]}]
set_input_delay -clock clk  25  [get_ports {w_V[4]}]
set_input_delay -clock clk  25  [get_ports {w_V[3]}]
set_input_delay -clock clk  25  [get_ports {w_V[2]}]
set_input_delay -clock clk  25  [get_ports {w_V[1]}]
set_input_delay -clock clk  25  [get_ports {w_V[0]}]
set_output_delay -clock clk  25  [get_ports out_valid]
set_output_delay -clock clk  25  [get_ports {out_data[63]}]
set_output_delay -clock clk  25  [get_ports {out_data[62]}]
set_output_delay -clock clk  25  [get_ports {out_data[61]}]
set_output_delay -clock clk  25  [get_ports {out_data[60]}]
set_output_delay -clock clk  25  [get_ports {out_data[59]}]
set_output_delay -clock clk  25  [get_ports {out_data[58]}]
set_output_delay -clock clk  25  [get_ports {out_data[57]}]
set_output_delay -clock clk  25  [get_ports {out_data[56]}]
set_output_delay -clock clk  25  [get_ports {out_data[55]}]
set_output_delay -clock clk  25  [get_ports {out_data[54]}]
set_output_delay -clock clk  25  [get_ports {out_data[53]}]
set_output_delay -clock clk  25  [get_ports {out_data[52]}]
set_output_delay -clock clk  25  [get_ports {out_data[51]}]
set_output_delay -clock clk  25  [get_ports {out_data[50]}]
set_output_delay -clock clk  25  [get_ports {out_data[49]}]
set_output_delay -clock clk  25  [get_ports {out_data[48]}]
set_output_delay -clock clk  25  [get_ports {out_data[47]}]
set_output_delay -clock clk  25  [get_ports {out_data[46]}]
set_output_delay -clock clk  25  [get_ports {out_data[45]}]
set_output_delay -clock clk  25  [get_ports {out_data[44]}]
set_output_delay -clock clk  25  [get_ports {out_data[43]}]
set_output_delay -clock clk  25  [get_ports {out_data[42]}]
set_output_delay -clock clk  25  [get_ports {out_data[41]}]
set_output_delay -clock clk  25  [get_ports {out_data[40]}]
set_output_delay -clock clk  25  [get_ports {out_data[39]}]
set_output_delay -clock clk  25  [get_ports {out_data[38]}]
set_output_delay -clock clk  25  [get_ports {out_data[37]}]
set_output_delay -clock clk  25  [get_ports {out_data[36]}]
set_output_delay -clock clk  25  [get_ports {out_data[35]}]
set_output_delay -clock clk  25  [get_ports {out_data[34]}]
set_output_delay -clock clk  25  [get_ports {out_data[33]}]
set_output_delay -clock clk  25  [get_ports {out_data[32]}]
set_output_delay -clock clk  25  [get_ports {out_data[31]}]
set_output_delay -clock clk  25  [get_ports {out_data[30]}]
set_output_delay -clock clk  25  [get_ports {out_data[29]}]
set_output_delay -clock clk  25  [get_ports {out_data[28]}]
set_output_delay -clock clk  25  [get_ports {out_data[27]}]
set_output_delay -clock clk  25  [get_ports {out_data[26]}]
set_output_delay -clock clk  25  [get_ports {out_data[25]}]
set_output_delay -clock clk  25  [get_ports {out_data[24]}]
set_output_delay -clock clk  25  [get_ports {out_data[23]}]
set_output_delay -clock clk  25  [get_ports {out_data[22]}]
set_output_delay -clock clk  25  [get_ports {out_data[21]}]
set_output_delay -clock clk  25  [get_ports {out_data[20]}]
set_output_delay -clock clk  25  [get_ports {out_data[19]}]
set_output_delay -clock clk  25  [get_ports {out_data[18]}]
set_output_delay -clock clk  25  [get_ports {out_data[17]}]
set_output_delay -clock clk  25  [get_ports {out_data[16]}]
set_output_delay -clock clk  25  [get_ports {out_data[15]}]
set_output_delay -clock clk  25  [get_ports {out_data[14]}]
set_output_delay -clock clk  25  [get_ports {out_data[13]}]
set_output_delay -clock clk  25  [get_ports {out_data[12]}]
set_output_delay -clock clk  25  [get_ports {out_data[11]}]
set_output_delay -clock clk  25  [get_ports {out_data[10]}]
set_output_delay -clock clk  25  [get_ports {out_data[9]}]
set_output_delay -clock clk  25  [get_ports {out_data[8]}]
set_output_delay -clock clk  25  [get_ports {out_data[7]}]
set_output_delay -clock clk  25  [get_ports {out_data[6]}]
set_output_delay -clock clk  25  [get_ports {out_data[5]}]
set_output_delay -clock clk  25  [get_ports {out_data[4]}]
set_output_delay -clock clk  25  [get_ports {out_data[3]}]
set_output_delay -clock clk  25  [get_ports {out_data[2]}]
set_output_delay -clock clk  25  [get_ports {out_data[1]}]
set_output_delay -clock clk  25  [get_ports {out_data[0]}]
