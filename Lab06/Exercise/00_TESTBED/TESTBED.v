/**************************************************************************/
// Copyright (c) 2024, SI2 Lab
// MODULE: TESTBED
// FILE NAME: TESTBED.v
// VERSRION: 1.0
// DATE: Oct 15, 2024
// AUTHOR: Yu-Hsiang Wang, NYCU IEE
// CODE TYPE: RTL or Behavioral Level (Verilog)
// 
/**************************************************************************/

`timescale 1ns/1ps

// PATTERN
`include "PATTERN.v"
// DESIGN
`ifdef RTL
	`include "MDC.v"
`elsif GATE
	`include "MDC_SYN.v"
`endif


module TESTBED();

	wire clk, rst_n, in_valid, out_valid;
	wire [8:0] in_mode;
	wire [14:0] in_data; 
	wire [206:0] out_data;

initial begin
 	`ifdef RTL
    	//$fsdbDumpfile("MDC.fsdb");
		//$fsdbDumpvars(0,"+mda");
	`elsif GATE
		//$fsdbDumpfile("MDC_SYN.fsdb");
		//$fsdbDumpvars(0,"+mda");
		$sdf_annotate("MDC_SYN.sdf", I_MDC); 
	`endif
end

MDC I_MDC 
(
	// Input signals
    .clk(clk),
	.rst_n(rst_n),
	.in_valid(in_valid),
    .in_data(in_data), 
	.in_mode(in_mode),
    // Output signals
    .out_valid(out_valid), 
	.out_data(out_data)
);


PATTERN I_PATTERN
(
	// Output signals
    .clk(clk),
	.rst_n(rst_n),
	.in_valid(in_valid),
    .in_data(in_data), 
	.in_mode(in_mode),
    // Input signals
    .out_valid(out_valid), 
	.out_data(out_data)
);

endmodule
