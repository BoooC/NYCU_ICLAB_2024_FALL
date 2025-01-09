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
`include "PATTERN_IP.v"
// DESIGN
`ifdef RTL
	`include "HAMMING_IP_demo.v"
`elsif GATE
	`include "HAMMING_IP_demo_SYN.v"
`endif


module TESTBED();

// Parameter
parameter IP_BIT = 8;

// Connection wires
wire [IP_BIT+4-1:0] code_in;
wire [IP_BIT-1:0] code_out;

initial begin
 	`ifdef RTL
    	$fsdbDumpfile("HAMMING_IP_demo.fsdb");
		$fsdbDumpvars(0,"+mda");
	`elsif GATE
		$sdf_annotate("HAMMING_IP_demo_SYN.sdf",IP_sort); 
		$fsdbDumpfile("HAMMING_IP_demo_SYN.fsdb");
		$fsdbDumpvars(0,"+mda");
	`endif
end

`ifdef RTL
	HAMMING_IP_demo #(.IP_BIT(IP_BIT)) IP_HAMMING (
		.IN_code(code_in),
		.OUT_code(code_out)
	);


	PATTERN #(.IP_BIT(IP_BIT)) I_PATTERN(
		.IN_code(code_in),
		.OUT_code(code_out)
	);
	
`elsif GATE
    HAMMING_IP_demo IP_HAMMING  (
        .IN_code(code_in),
		.OUT_code(code_out)
    );
    
    PATTERN #(.IP_BIT(IP_BIT)) My_PATTERN (
        .IN_code(code_in),
		.OUT_code(code_out)
    );

`endif  

endmodule
