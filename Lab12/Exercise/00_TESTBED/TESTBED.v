/**************************************************************************/
// Copyright (c) 2023, SI2 Lab
// MODULE: TESTBED
// FILE NAME: TESTBED.v
// VERSRION: 1.0
// DATE: July 5, 2023
// AUTHOR: SHAO-HUA LIEN, NYCU IEE
// CODE TYPE: RTL or Behavioral Level (Verilog)
// 
/**************************************************************************/

`timescale 1ns/1ps

// PATTERN
`include "PATTERN.v"
// DESIGN
`ifdef RTL
	`include "TETRIS.v"
`elsif GATE
	`include "TETRIS_SYN.v"
`elsif POST
	`include "CHIP.v"
`endif

module TESTBED();

wire 			rst_n, clk, in_valid;
wire 	[2:0]	tetrominoes;
wire	[2:0]	position;
wire			tetris_valid, score_valid, fail;
wire	[3:0]	score;
wire	[71:0]	tetris;

initial begin
 	`ifdef RTL
    	$fsdbDumpfile("TETRIS.fsdb");
		$fsdbDumpvars(0,"+mda");
	`elsif GATE
		$fsdbDumpfile("TETRIS_SYN.fsdb");
		$fsdbDumpvars(0,"+mda");
		$sdf_annotate("TETRIS_SYN.sdf",I_TETRIS); 
	`elsif POST
		$fsdbDumpfile("CHIP_POST.fsdb");
		$fsdbDumpvars(0,"+mda"); 
		$sdf_annotate("CHIP.sdf",u_CHIP);
	`endif
end

`ifdef RTL
TETRIS I_TETRIS(
	.rst_n(rst_n),
	.clk(clk),
	.in_valid(in_valid),
	.tetrominoes(tetrominoes),
	.position(position),
	.tetris_valid(tetris_valid),
	.score_valid(score_valid),
	.fail(fail),
	.score(score),
	.tetris(tetris)
);
`elsif GATE
TETRIS I_TETRIS(
	.rst_n(rst_n),
	.clk(clk),
	.in_valid(in_valid),
	.tetrominoes(tetrominoes),
	.position(position),
	.tetris_valid(tetris_valid),
	.score_valid(score_valid),
	.fail(fail),
	.score(score),
	.tetris(tetris)
);
`elsif POST
CHIP u_CHIP(
  .rst_n(rst_n),
	.clk(clk),
	.in_valid(in_valid),
	.tetrominoes(tetrominoes),
	.position(position),
	.tetris_valid(tetris_valid),
	.score_valid(score_valid),
	.fail(fail),
	.score(score),
	.tetris(tetris)
);
`endif

PATTERN I_PATTERN(
  .rst_n(rst_n),
	.clk(clk),
	.in_valid(in_valid),
	.tetrominoes(tetrominoes),
	.position(position),
	.tetris_valid(tetris_valid),
	.score_valid(score_valid),
	.fail(fail),
	.score(score),
	.tetris(tetris)
);

endmodule
