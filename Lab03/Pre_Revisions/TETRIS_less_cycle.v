/**************************************************************************/
// Copyright (c) 2024, OASIS Lab
// MODULE: TETRIS
// FILE NAME: TETRIS.v
// VERSRION: 1.0
// DATE: August 15, 2024
// AUTHOR: Yu-Hsuan Hsu, NYCU IEE
// DESCRIPTION: ICLAB2024FALL / LAB3 / TETRIS
// MODIFICATION HISTORY:
// Date                 Description
// 
/**************************************************************************/
module TETRIS (
	//INPUT
	rst_n,
	clk,
	in_valid,
	tetrominoes,
	position,
	//OUTPUT
	tetris_valid,
	score_valid,
	fail,
	score,
	tetris
);

//---------------------------------------------------------------------
//   PORT DECLARATION          
//---------------------------------------------------------------------
input				rst_n, clk, in_valid;
input		[2:0]	tetrominoes;
input		[2:0]	position;
output reg			tetris_valid, score_valid, fail;
output reg	[3:0]	score;
output reg 	[71:0]	tetris;


//---------------------------------------------------------------------
//   PARAMETER & INTEGER DECLARATION
//---------------------------------------------------------------------
parameter MAP_HEIGHT 	= 12;
parameter MAP_WIDHT 	= 6;
integer i, j;

// shape
parameter SQUARE	= 3'd0;  // 2x2
parameter LINE_V  	= 3'd1;  // |
parameter LINE_H  	= 3'd2;  // _
parameter L_INV 	= 3'd3;  // 7
parameter L_HORI	= 3'd4;  // 「
parameter L_NORM	= 3'd5;  // L
parameter S_VERT	= 3'd6;  // ㄣ
parameter S_NORM	= 3'd7;  // S

//---------------------------------------------------------------------
//   REG & WIRE DECLARATION
//---------------------------------------------------------------------
reg map [MAP_HEIGHT-1:0][MAP_WIDHT-1:0];



wire [3:0] top_row [0:5];

wire row_full [0:11];

wire [2:0] x_0 = position;
wire [2:0] x_1 = position + 3'd1;
wire [2:0] x_2 = position + 3'd2;
wire [2:0] x_3 = position + 3'd3;

wire [3:0] x_0_row = top_row[x_0];
wire [3:0] x_1_row = top_row[x_1];
wire [3:0] x_2_row = top_row[x_2];
wire [3:0] x_3_row = top_row[x_3];



assign row_full[0]  = map[0][0]  & map[0][1]  & map[0][2]  & map[0][3]  & map[0][4]  & map[0][5];
assign row_full[1]  = map[1][0]  & map[1][1]  & map[1][2]  & map[1][3]  & map[1][4]  & map[1][5];
assign row_full[2]  = map[2][0]  & map[2][1]  & map[2][2]  & map[2][3]  & map[2][4]  & map[2][5];
assign row_full[3]  = map[3][0]  & map[3][1]  & map[3][2]  & map[3][3]  & map[3][4]  & map[3][5];
assign row_full[4]  = map[4][0]  & map[4][1]  & map[4][2]  & map[4][3]  & map[4][4]  & map[4][5];
assign row_full[5]  = map[5][0]  & map[5][1]  & map[5][2]  & map[5][3]  & map[5][4]  & map[5][5];
assign row_full[6]  = map[6][0]  & map[6][1]  & map[6][2]  & map[6][3]  & map[6][4]  & map[6][5];
assign row_full[7]  = map[7][0]  & map[7][1]  & map[7][2]  & map[7][3]  & map[7][4]  & map[7][5];
assign row_full[8]  = map[8][0]  & map[8][1]  & map[8][2]  & map[8][3]  & map[8][4]  & map[8][5];
assign row_full[9]  = map[9][0]  & map[9][1]  & map[9][2]  & map[9][3]  & map[9][4]  & map[9][5];
assign row_full[10] = map[10][0] & map[10][1] & map[10][2] & map[10][3] & map[10][4] & map[10][5];
assign row_full[11] = map[11][0] & map[11][1] & map[11][2] & map[11][3] & map[11][4] & map[11][5];

//---------------------------------------------------------------------
//   DESIGN
//---------------------------------------------------------------------
genvar i_gen;
generate
    for (i_gen = 0; i_gen < 6; i_gen = i_gen + 1) begin : gen_find_top_row
        find_top_row find_top_row_inst (
            .map_0  (map[0] [i_gen]), 
            .map_1  (map[1] [i_gen]), 
            .map_2  (map[2] [i_gen]), 
            .map_3  (map[3] [i_gen]), 
            .map_4  (map[4] [i_gen]), 
            .map_5  (map[5] [i_gen]), 
            .map_6  (map[6] [i_gen]), 
            .map_7  (map[7] [i_gen]), 
            .map_8  (map[8] [i_gen]), 
            .map_9  (map[9] [i_gen]), 
            .map_10 (map[10][i_gen]), 
            .map_11 (map[11][i_gen]), 
            .top_row(top_row[i_gen])
        );
    end
endgenerate



always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for(i=0; i<MAP_HEIGHT; i=i+1) begin
			for(j=0; j<MAP_WIDHT; j=j+1) begin
				map[i][j] <= 72'd0;
			end
		end
	end
	else if(in_valid) begin
		case(tetrominoes)
			SQUARE : begin
				if (x_0_row >= x_1_row) begin
					map[x_0_row+1][x0] 	<= 1'b1;	map[x_0_row+1][x1] 	<= 1'b1;
					map[x_0_row][x0] 	<= 1'b1;	map[x_0_row][x1] 	<= 1'b1;
				end
				else begin
					map[x_1_row+1][x0] 	<= 1'b1;	map[x_1_row+1][x1] 	<= 1'b1;
					map[x_1_row][x0] 	<= 1'b1;	map[x_1_row][x1] 	<= 1'b1;
				end
			end
			LINE_V : begin
				map[x_0_row+3][x0] 	<= 1'b1;	
				map[x_0_row+2][x0] 	<= 1'b1;
				map[x_0_row+1][x0] 	<= 1'b1;	
				map[x_0_row][x0] 	<= 1'b1;
			end
			LINE_H : begin
				if (x_0_row >= x_1_row) begin
					map[x_0_row+1][x0] 	<= 1'b1;	map[x_0_row+1][x1] 	<= 1'b1;
					map[x_0_row][x0] 	<= 1'b1;	map[x_0_row][x1] 	<= 1'b1;
				end
				else begin
					map[x_1_row+1][x0] 	<= 1'b1;	map[x_1_row+1][x1] 	<= 1'b1;
					map[x_1_row][x0] 	<= 1'b1;	map[x_1_row][x1] 	<= 1'b1;
				end
			end
			L_INV  : 
			L_HORI : 
			L_NORM : 
			S_VERT : 
			S_NORM : 
		endcase
	end
	else begin
		
	end
end









// output









endmodule





module find_top_row (
	input map_0, map_1, map_2, map_3, map_4, map_5, map_6, map_7, map_8, map_9, map_10, map_11, 
	output [3:0] top_row
);

assign top_row = map_11 ? 4'd11 : 
				 map_10 ? 4'd10 : 
				 map_9  ? 4'd9  : 
				 map_8  ? 4'd8  : 
				 map_7  ? 4'd7  : 
				 map_6  ? 4'd6  : 
				 map_5  ? 4'd5  : 
				 map_4  ? 4'd4  : 
				 map_3  ? 4'd3  : 
				 map_2  ? 4'd2  : 
				 map_1  ? 4'd1  : 4'd0;

endmodule







