//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2024 Fall
//   Lab01 Exercise		: Snack Shopping Calculator
//   Author     		: Yu-Hsiang Wang
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : TESTBED.v
//   Module Name : TESTBED
//   Release version : V1.0 (Release Date: 2024-09)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

`timescale 1ns/10ps
`include "PATTERN.v"
`ifdef RTL
  `include "SSC.v"
`endif
`ifdef GATE
  `include "SSC_SYN.v"
`endif
	  		  	
module TESTBED; 

//Connection wires
wire [63:0] card_num;
wire [8:0] input_money;
wire [31:0] snack_num;
wire [31:0] price;

wire out_valid;
wire [8:0] out_change;

initial begin
  `ifdef RTL
    $fsdbDumpfile("SSC.fsdb");
	$fsdbDumpvars(0,"+mda");
    $fsdbDumpvars();
  `endif
  `ifdef GATE
    $sdf_annotate("SSC_SYN.sdf", DUT_SSC);
    $fsdbDumpfile("SSC_SYN.fsdb");
	$fsdbDumpvars(0,"+mda");
    $fsdbDumpvars();    
  `endif
end

SSC DUT_SSC(
  .card_num(card_num),
  .input_money(input_money),
  .snack_num(snack_num),
  .price(price),

  .out_valid(out_valid),
  .out_change(out_change)
);

PATTERN My_PATTERN(
  .card_num(card_num),
  .input_money(input_money),
  .snack_num(snack_num),
  .price(price),

  .out_valid(out_valid),
  .out_change(out_change)
);
 
endmodule
