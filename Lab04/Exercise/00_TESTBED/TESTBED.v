//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2024 Fall
//   Lab04 Exercise		: Convolution Neural Network
//   Author     		: Yu-Chi Lin (a6121461214.st12@nycu.edu.tw)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : TESETBED.v
//   Module Name : TESETBED
//   Release version : V1.0 (Release Date: 2024-10)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

`timescale 1ns/10ps

`include "PATTERN.v"

`ifdef RTL
  `include "CNN.v"
`endif
`ifdef GATE
  `include "CNN_SYN.v"
`endif

	  		  	
module TESTBED;

wire          clk, rst_n, in_valid;
wire  [31:0]  Img;
wire  [31:0]  Kernel_ch1;
wire  [31:0]  Kernel_ch2;
wire  [31:0]  Weight;
wire          Opt;
wire          out_valid;
wire  [31:0]  out;


initial begin
  `ifdef RTL
    $fsdbDumpfile("CNN.fsdb");
	  $fsdbDumpvars(0,"+mda");
    $fsdbDumpvars();
  `endif
  `ifdef GATE
    $sdf_annotate("CNN_SYN.sdf", u_CNN);
    $fsdbDumpfile("CNN_SYN.fsdb");
    $fsdbDumpvars();    
  `endif
end

`ifdef RTL
CNN u_CNN(
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
    .Img(Img),
    .Kernel_ch1(Kernel_ch1),
    .Kernel_ch2(Kernel_ch2),
    .Weight(Weight),
    .Opt(Opt),
    .out_valid(out_valid),
    .out(out)
    );
`endif

`ifdef GATE
CNN u_CNN(
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
    .Img(Img),
    .Kernel_ch1(Kernel_ch1),
    .Kernel_ch2(Kernel_ch2),
    .Weight(Weight),
    .Opt(Opt),
    .out_valid(out_valid),
    .out(out)
    );
`endif

PATTERN u_PATTERN(
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
    .Img(Img),
    .Kernel_ch1(Kernel_ch1),
    .Kernel_ch2(Kernel_ch2),
    .Weight(Weight),
    .Opt(Opt),
    .out_valid(out_valid),
    .out(out)
    );
  
 
endmodule
