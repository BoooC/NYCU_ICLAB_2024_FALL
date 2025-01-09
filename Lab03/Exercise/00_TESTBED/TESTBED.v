/**************************************************************************/
// Copyright (c) 2024, OASIS Lab
// MODULE: TESTBED
// FILE NAME: TESTBED.v
// VERSRION: 1.0
// DATE: July 26, 2024
// AUTHOR: Yu-Hsuan Hsu, NYCU IEE
// DESCRIPTION: ICLAB2024FALL / LAB3 / TESTBED
// MODIFICATION HISTORY:
// Date                 Description
// 
/**************************************************************************/
`timescale 1ns/10ps

`include "PATTERN.v"
`ifdef RTL
    //`include "TETRIS.v"
	`include "TETRIS_encrypted.v"
`endif
`ifdef GATE
    `include "TETRIS_SYN.v"
`endif

module TESTBED;

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
    `endif
    `ifdef GATE
        $sdf_annotate("TETRIS_SYN.sdf", u_TETRIS);
        $fsdbDumpfile("TETRIS_SYN.fsdb");
        $fsdbDumpvars(0,"+mda"); 
    `endif
end

TETRIS u_TETRIS(
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
    
PATTERN u_PATTERN(
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
