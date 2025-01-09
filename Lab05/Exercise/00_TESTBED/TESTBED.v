//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2024 Fall
//   Lab05 Exercise		: Template Matching with Image Processing
//   Author     		: Bang-Yuan Xiao (xuan95732@gmail.com)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : TESETBED.v
//   Module Name : TESETBED
//   Release version : V1.0 (Release Date: 2024-08)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

`timescale 1ns/10ps

`include "PATTERN.v"

`ifdef RTL
    `include "TMIP.v"
`elsif GATE
    `include "TMIP_SYN.v"
`elsif POST
    `include "CHIP.v"
`endif

	  		  	
module TESTBED;

wire         clk, rst_n, in_valid, in_valid2;
wire  [7:0]  image;
wire  [7:0]  template;
wire  [1:0]  image_size;
wire  [2:0]  action;
wire         out_valid;
wire         out_value;


initial begin
	`ifdef RTL
		$fsdbDumpfile("TMIP.fsdb");
		$fsdbDumpvars(0,"+mda");
		$fsdbDumpvars();
	`endif
	`ifdef GATE
		$sdf_annotate("TMIP_SYN.sdf", u_TMIP);
		//$fsdbDumpfile("TMIP_SYN.fsdb");
		//$fsdbDumpvars();    
	`endif
	`ifdef POST
		$sdf_annotate("CHIP.sdf", u_CHIP);
		//$fsdbDumpfile("CHIP.fsdb");
		//$fsdbDumpvars();    
	`endif
end

`ifdef RTL
	TMIP u_TMIP(
		// Input signals
		.clk(clk),
		.rst_n(rst_n),
		
		.in_valid(in_valid),
		.in_valid2(in_valid2),
		
		.image(image),
		.template(template),
		.image_size(image_size),
		.action(action),
	
		// Output signals
		.out_valid(out_valid),
		.out_value(out_value)
	);
`elsif GATE
	TMIP u_TMIP(
		// Input signals
		.clk(clk),
		.rst_n(rst_n),
		
		.in_valid(in_valid),
		.in_valid2(in_valid2),
		
		.image(image),
		.template(template),
		.image_size(image_size),
		.action(action),
	
		// Output signals
		.out_valid(out_valid),
		.out_value(out_value)
	);
`elsif POST
	CHIP u_CHIP(
		// Input signals
		.clk(clk),
		.rst_n(rst_n),
		
		.in_valid(in_valid),
		.in_valid2(in_valid2),
		
		.image(image),
		.template(template),
		.image_size(image_size),
		.action(action),
	
		// Output signals
		.out_valid(out_valid),
		.out_value(out_value)
	);
`endif

PATTERN u_PATTERN(
    // Output signals
    .clk(clk),
	.rst_n(rst_n),
	
	.in_valid(in_valid),
	.in_valid2(in_valid2),
	
    .image(image),
	.template(template),
	.image_size(image_size),
	.action(action),

    // Input signals
	.out_valid(out_valid),
	.out_value(out_value)
);
 
endmodule
