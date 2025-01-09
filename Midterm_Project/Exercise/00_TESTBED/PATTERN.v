`define CYCLE_TIME 2.2

`include "../00_TESTBED/pseudo_DRAM.v"

module PATTERN(
    // Input Signals
    clk,
    rst_n,
    in_valid,
    in_pic_no,
    in_mode,
    in_ratio_mode,
    out_valid,
    out_data
);

//======================================
//      INPUT & OUTPUT
//======================================
output reg       clk, rst_n;
output reg       in_valid;

output reg [3:0] in_pic_no;
output reg       in_mode;
output reg [1:0] in_ratio_mode;

input out_valid;
input [7:0] out_data;

//======================================
//      PARAMETERS & VARIABLES
//======================================











endmodule