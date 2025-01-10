###################################################################

# Created by write_sdc on Fri Jan 10 12:54:37 2025

###################################################################
set sdc_version 2.1

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_operating_conditions -max slow -max_library slow\
                         -min fast -min_library fast
set_wire_load_mode top
set_wire_load_model -name umc18_wl10 -library slow
set_load -pin_load 0.05 [get_ports out_valid]
set_load -pin_load 0.05 [get_ports {out_change[8]}]
set_load -pin_load 0.05 [get_ports {out_change[7]}]
set_load -pin_load 0.05 [get_ports {out_change[6]}]
set_load -pin_load 0.05 [get_ports {out_change[5]}]
set_load -pin_load 0.05 [get_ports {out_change[4]}]
set_load -pin_load 0.05 [get_ports {out_change[3]}]
set_load -pin_load 0.05 [get_ports {out_change[2]}]
set_load -pin_load 0.05 [get_ports {out_change[1]}]
set_load -pin_load 0.05 [get_ports {out_change[0]}]
set_max_delay 20  -from [list [get_ports {card_num[63]}] [get_ports {card_num[62]}] [get_ports  \
{card_num[61]}] [get_ports {card_num[60]}] [get_ports {card_num[59]}]          \
[get_ports {card_num[58]}] [get_ports {card_num[57]}] [get_ports               \
{card_num[56]}] [get_ports {card_num[55]}] [get_ports {card_num[54]}]          \
[get_ports {card_num[53]}] [get_ports {card_num[52]}] [get_ports               \
{card_num[51]}] [get_ports {card_num[50]}] [get_ports {card_num[49]}]          \
[get_ports {card_num[48]}] [get_ports {card_num[47]}] [get_ports               \
{card_num[46]}] [get_ports {card_num[45]}] [get_ports {card_num[44]}]          \
[get_ports {card_num[43]}] [get_ports {card_num[42]}] [get_ports               \
{card_num[41]}] [get_ports {card_num[40]}] [get_ports {card_num[39]}]          \
[get_ports {card_num[38]}] [get_ports {card_num[37]}] [get_ports               \
{card_num[36]}] [get_ports {card_num[35]}] [get_ports {card_num[34]}]          \
[get_ports {card_num[33]}] [get_ports {card_num[32]}] [get_ports               \
{card_num[31]}] [get_ports {card_num[30]}] [get_ports {card_num[29]}]          \
[get_ports {card_num[28]}] [get_ports {card_num[27]}] [get_ports               \
{card_num[26]}] [get_ports {card_num[25]}] [get_ports {card_num[24]}]          \
[get_ports {card_num[23]}] [get_ports {card_num[22]}] [get_ports               \
{card_num[21]}] [get_ports {card_num[20]}] [get_ports {card_num[19]}]          \
[get_ports {card_num[18]}] [get_ports {card_num[17]}] [get_ports               \
{card_num[16]}] [get_ports {card_num[15]}] [get_ports {card_num[14]}]          \
[get_ports {card_num[13]}] [get_ports {card_num[12]}] [get_ports               \
{card_num[11]}] [get_ports {card_num[10]}] [get_ports {card_num[9]}]           \
[get_ports {card_num[8]}] [get_ports {card_num[7]}] [get_ports {card_num[6]}]  \
[get_ports {card_num[5]}] [get_ports {card_num[4]}] [get_ports {card_num[3]}]  \
[get_ports {card_num[2]}] [get_ports {card_num[1]}] [get_ports {card_num[0]}]  \
[get_ports {input_money[8]}] [get_ports {input_money[7]}] [get_ports           \
{input_money[6]}] [get_ports {input_money[5]}] [get_ports {input_money[4]}]    \
[get_ports {input_money[3]}] [get_ports {input_money[2]}] [get_ports           \
{input_money[1]}] [get_ports {input_money[0]}] [get_ports {snack_num[31]}]     \
[get_ports {snack_num[30]}] [get_ports {snack_num[29]}] [get_ports             \
{snack_num[28]}] [get_ports {snack_num[27]}] [get_ports {snack_num[26]}]       \
[get_ports {snack_num[25]}] [get_ports {snack_num[24]}] [get_ports             \
{snack_num[23]}] [get_ports {snack_num[22]}] [get_ports {snack_num[21]}]       \
[get_ports {snack_num[20]}] [get_ports {snack_num[19]}] [get_ports             \
{snack_num[18]}] [get_ports {snack_num[17]}] [get_ports {snack_num[16]}]       \
[get_ports {snack_num[15]}] [get_ports {snack_num[14]}] [get_ports             \
{snack_num[13]}] [get_ports {snack_num[12]}] [get_ports {snack_num[11]}]       \
[get_ports {snack_num[10]}] [get_ports {snack_num[9]}] [get_ports              \
{snack_num[8]}] [get_ports {snack_num[7]}] [get_ports {snack_num[6]}]          \
[get_ports {snack_num[5]}] [get_ports {snack_num[4]}] [get_ports               \
{snack_num[3]}] [get_ports {snack_num[2]}] [get_ports {snack_num[1]}]          \
[get_ports {snack_num[0]}] [get_ports {price[31]}] [get_ports {price[30]}]     \
[get_ports {price[29]}] [get_ports {price[28]}] [get_ports {price[27]}]        \
[get_ports {price[26]}] [get_ports {price[25]}] [get_ports {price[24]}]        \
[get_ports {price[23]}] [get_ports {price[22]}] [get_ports {price[21]}]        \
[get_ports {price[20]}] [get_ports {price[19]}] [get_ports {price[18]}]        \
[get_ports {price[17]}] [get_ports {price[16]}] [get_ports {price[15]}]        \
[get_ports {price[14]}] [get_ports {price[13]}] [get_ports {price[12]}]        \
[get_ports {price[11]}] [get_ports {price[10]}] [get_ports {price[9]}]         \
[get_ports {price[8]}] [get_ports {price[7]}] [get_ports {price[6]}]           \
[get_ports {price[5]}] [get_ports {price[4]}] [get_ports {price[3]}]           \
[get_ports {price[2]}] [get_ports {price[1]}] [get_ports {price[0]}]]  -to [list [get_ports out_valid] [get_ports {out_change[8]}] [get_ports        \
{out_change[7]}] [get_ports {out_change[6]}] [get_ports {out_change[5]}]       \
[get_ports {out_change[4]}] [get_ports {out_change[3]}] [get_ports             \
{out_change[2]}] [get_ports {out_change[1]}] [get_ports {out_change[0]}]]
