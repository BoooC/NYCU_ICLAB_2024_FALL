module PATTERN(
    // Input Ports
    clk,
    rst_n,
    in_valid,
    inning,
    half,
    action,

    // Output Ports
    out_valid,
    score_A,
    score_B,
    result
);

// Output Registers
output reg clk, rst_n, in_valid;
output reg [1:0] inning; // Indicates the current inning
output reg half;         // 0: Top half, 1: Bottom half
output reg [2:0] action; // Action code

// Input Signals
input out_valid;
input [7:0] score_A;
input [7:0] score_B;
input [1:0] result; // 0: Team A wins, 1: Team B wins, 2: Draw


endmodule