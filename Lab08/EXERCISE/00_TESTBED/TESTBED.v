/**************************************************************************/
// Copyright (c) 2024, OASIS Lab
// MODULE: SA
// FILE NAME: TESTBED.v
// VERSRION: 1.0
// DATE: Nov 06, 2024
// AUTHOR: Yen-Ning Tung, NYCU AIG
// CODE TYPE: RTL or Behavioral Level (Verilog)
// DESCRIPTION: 2024 Fall IC Lab / Exersise Lab08 / TESTBED
// MODIFICATION HISTORY:
// Date                 Description
// 
/**************************************************************************/

`timescale 1ns/10ps
`ifdef RTL
    `ifdef NCG
    `include "PATTERN.v"
    `endif
    `ifdef CG
    `include "PATTERN_CG.v"
    `endif
`endif
`ifdef GATE
    `ifdef NCG
    `include "PATTERN.v"
    `endif
    `ifdef CG
    `include "PATTERN_CG.v"
    `endif
`endif

`ifdef RTL
  `include "SA.v"
`endif
`ifdef GATE
  `include "SA_SYN.v"
`endif

	  		  	
module TESTBED;

    wire clk, rst_n, in_valid;
    wire cg_en;
    wire [3:0] T;
    wire signed [7:0] in_data;
    wire signed [7:0] w_Q;
    wire signed [7:0] w_K;
    wire signed [7:0] w_V;
    wire out_valid;
    wire signed [63:0] out_data;


initial begin
  `ifdef RTL
    `ifdef NCG
    $fsdbDumpfile("SA.fsdb");
    $fsdbDumpvars(0,"+mda");
    $fsdbDumpvars();
    `endif

    `ifdef CG
    $fsdbDumpfile("SA_CG.fsdb");
    $fsdbDumpvars(0,"+mda");
    $fsdbDumpvars();
    `endif
  `endif
  `ifdef GATE
    `ifdef NCG
            $sdf_annotate("SA_SYN.sdf", I_SA);
            $fsdbDumpfile("SA_SYN.fsdb");
            $fsdbDumpvars();    
    `endif
    `ifdef CG   
            $sdf_annotate("SA_SYN.sdf", I_SA);
            $fsdbDumpfile("SA_SYN_CG.fsdb");
            $fsdbDumpvars();    
    `endif

  `endif
end

`ifdef RTL
SA I_SA(
    // Input signals
    .clk(clk),
    .rst_n(rst_n),
    .cg_en(cg_en),
    .in_valid(in_valid),
    .T(T),
    .in_data(in_data),
    .w_Q(w_Q),
    .w_K(w_K),
    .w_V(w_V),

    // Output signals
    .out_valid(out_valid),
    .out_data(out_data)
);
`endif

`ifdef GATE
SA I_SA(
    // Input signals
    .clk(clk),
    .rst_n(rst_n),
    .cg_en(cg_en),
    .in_valid(in_valid),
    .T(T),
    .in_data(in_data),
    .w_Q(w_Q),
    .w_K(w_K),
    .w_V(w_V),

    // Output signals
    .out_valid(out_valid),
    .out_data(out_data)
);
`endif

PATTERN I_PATTERN
(
    // Output signals
    .clk(clk),
    .rst_n(rst_n),
    .cg_en(cg_en),
    .in_valid(in_valid),
    .T(T),
    .in_data(in_data),
    .w_Q(w_Q),
    .w_K(w_K),
    .w_V(w_V),

    // Input signals
    .out_valid(out_valid),
    .out_data(out_data)
);
  
endmodule
