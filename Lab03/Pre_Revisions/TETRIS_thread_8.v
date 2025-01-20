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
parameter MAP_GROUND 	= 1;
parameter MAP_CEILING 	= 3;

// shape
parameter SQUARE	= 3'd0;  // 2x2
parameter LINE_V  	= 3'd1;  // |
parameter LINE_H  	= 3'd2;  // _
parameter L_INV 	= 3'd3;  // 7
parameter L_HORI	= 3'd4;  // 「
parameter L_NORM	= 3'd5;  // L
parameter S_VERT	= 3'd6;  // ㄣ
parameter S_NORM	= 3'd7;  // S

localparam IDLE 	= 2'd0;
localparam DROP 	= 2'd1;
localparam CLEAR 	= 2'd2;
localparam DOUT 	= 2'd3;

integer i, j, k;

//---------------------------------------------------------------------
//   REG & WIRE DECLARATION
//---------------------------------------------------------------------
reg [1:0] state, next_state;
reg map [MAP_HEIGHT-1+MAP_GROUND+MAP_CEILING:0][0:MAP_WIDHT-1];

reg [2:0] tetrominoes_reg;
reg [2:0] position_reg;

reg [4:0] scan_row;
reg [3:0] round_num;
reg [3:0] score_temp;


wire [2:0] x_0 = position_reg;
wire [2:0] x_1 = (position_reg > 3'd4) ? 3'd5 : (position_reg + 3'd1);
wire [2:0] x_2 = (position_reg > 3'd3) ? 3'd5 : (position_reg + 3'd2);
wire [2:0] x_3 = (position_reg > 3'd2) ? 3'd5 : (position_reg + 3'd3);

wire [4:0] scan_row_d = scan_row + 5'd21;	// - 'd11;
wire [4:0] scan_row_c = scan_row + 5'd22;	// - 'd10;
wire [4:0] scan_row_b = scan_row + 5'd23;	// - 'd9;
wire [4:0] scan_row_a = scan_row + 5'd24;	// - 'd8;
wire [4:0] scan_row_z = scan_row + 5'd25;	// - 'd7;
wire [4:0] scan_row_y = scan_row + 5'd26;	// - 'd6;
wire [4:0] scan_row_x = scan_row + 5'd27;	// - 'd5;
wire [4:0] scan_row_0 = scan_row + 5'd28;	// - 'd4;
wire [4:0] scan_row_1 = scan_row + 5'd29;	// - 'd3;
wire [4:0] scan_row_2 = scan_row + 5'd30;	// - 'd2;
wire [4:0] scan_row_3 = scan_row + 5'd31;	// - 'd1;
wire [4:0] scan_row_4 = scan_row;

reg x_is_obj [0:3][0:3];

wire overlap_0, overlap_1, overlap_2, overlap_3, overlap_4, overlap_5, overlap_6, overlap_7;
is_overlap is_overlap_inst_0 (
	.map_12	(map[scan_row_3][x_0]), .map_13	(map[scan_row_3][x_1]), .map_14	(map[scan_row_3][x_2]), .map_15	(map[scan_row_3][x_3]), 
	.map_8	(map[scan_row_2][x_0]), .map_9	(map[scan_row_2][x_1]), .map_10	(map[scan_row_2][x_2]), .map_11	(map[scan_row_2][x_3]), 
	.map_4	(map[scan_row_1][x_0]), .map_5	(map[scan_row_1][x_1]), .map_6	(map[scan_row_1][x_2]), .map_7	(map[scan_row_1][x_3]), 
	.map_0	(map[scan_row_0][x_0]), .map_1	(map[scan_row_0][x_1]), .map_2	(map[scan_row_0][x_2]), .map_3	(map[scan_row_0][x_3]), 
	
	.x_12	(x_is_obj[3][0]), 		.x_13	(x_is_obj[3][1]), 		.x_14	(x_is_obj[3][2]), 		.x_15	(x_is_obj[3][3]), 
	.x_8	(x_is_obj[2][0]), 		.x_9	(x_is_obj[2][1]), 		.x_10	(x_is_obj[2][2]), 		.x_11	(x_is_obj[2][3]), 
	.x_4	(x_is_obj[1][0]), 		.x_5	(x_is_obj[1][1]), 		.x_6	(x_is_obj[1][2]), 		.x_7	(x_is_obj[1][3]), 
	.x_0	(x_is_obj[0][0]), 		.x_1	(x_is_obj[0][1]), 		.x_2	(x_is_obj[0][2]), 		.x_3	(x_is_obj[0][3]), 
	.is_overlap(overlap_0)
);

is_overlap is_overlap_inst_1
 (
	.map_12	(map[scan_row_2][x_0]), .map_13	(map[scan_row_2][x_1]), .map_14	(map[scan_row_2][x_2]), .map_15	(map[scan_row_2][x_3]), 
	.map_8	(map[scan_row_1][x_0]), .map_9	(map[scan_row_1][x_1]), .map_10	(map[scan_row_1][x_2]), .map_11	(map[scan_row_1][x_3]), 
	.map_4	(map[scan_row_0][x_0]), .map_5	(map[scan_row_0][x_1]), .map_6	(map[scan_row_0][x_2]), .map_7	(map[scan_row_0][x_3]), 
	.map_0	(map[scan_row_x][x_0]), .map_1	(map[scan_row_x][x_1]), .map_2	(map[scan_row_x][x_2]), .map_3	(map[scan_row_x][x_3]), 
	
	.x_12	(x_is_obj[3][0]), 		.x_13	(x_is_obj[3][1]), 		.x_14	(x_is_obj[3][2]), 		.x_15	(x_is_obj[3][3]), 
	.x_8	(x_is_obj[2][0]), 		.x_9	(x_is_obj[2][1]), 		.x_10	(x_is_obj[2][2]), 		.x_11	(x_is_obj[2][3]), 
	.x_4	(x_is_obj[1][0]), 		.x_5	(x_is_obj[1][1]), 		.x_6	(x_is_obj[1][2]), 		.x_7	(x_is_obj[1][3]), 
	.x_0	(x_is_obj[0][0]), 		.x_1	(x_is_obj[0][1]), 		.x_2	(x_is_obj[0][2]), 		.x_3	(x_is_obj[0][3]), 
	.is_overlap(overlap_1)
);

is_overlap is_overlap_inst_2
 (
	.map_12	(map[scan_row_1][x_0]), .map_13	(map[scan_row_1][x_1]), .map_14	(map[scan_row_1][x_2]), .map_15	(map[scan_row_1][x_3]), 
	.map_8	(map[scan_row_0][x_0]), .map_9	(map[scan_row_0][x_1]), .map_10	(map[scan_row_0][x_2]), .map_11	(map[scan_row_0][x_3]), 
	.map_4	(map[scan_row_x][x_0]), .map_5	(map[scan_row_x][x_1]), .map_6	(map[scan_row_x][x_2]), .map_7	(map[scan_row_x][x_3]), 
	.map_0	(map[scan_row_y][x_0]), .map_1	(map[scan_row_y][x_1]), .map_2	(map[scan_row_y][x_2]), .map_3	(map[scan_row_y][x_3]), 
	
	.x_12	(x_is_obj[3][0]), 		.x_13	(x_is_obj[3][1]), 		.x_14	(x_is_obj[3][2]), 		.x_15	(x_is_obj[3][3]), 
	.x_8	(x_is_obj[2][0]), 		.x_9	(x_is_obj[2][1]), 		.x_10	(x_is_obj[2][2]), 		.x_11	(x_is_obj[2][3]), 
	.x_4	(x_is_obj[1][0]), 		.x_5	(x_is_obj[1][1]), 		.x_6	(x_is_obj[1][2]), 		.x_7	(x_is_obj[1][3]), 
	.x_0	(x_is_obj[0][0]), 		.x_1	(x_is_obj[0][1]), 		.x_2	(x_is_obj[0][2]), 		.x_3	(x_is_obj[0][3]), 
	.is_overlap(overlap_2)
);

is_overlap is_overlap_inst_3
 (
	.map_12	(map[scan_row_0][x_0]), .map_13	(map[scan_row_0][x_1]), .map_14	(map[scan_row_0][x_2]), .map_15	(map[scan_row_0][x_3]), 
	.map_8	(map[scan_row_x][x_0]), .map_9	(map[scan_row_x][x_1]), .map_10	(map[scan_row_x][x_2]), .map_11	(map[scan_row_x][x_3]), 
	.map_4	(map[scan_row_y][x_0]), .map_5	(map[scan_row_y][x_1]), .map_6	(map[scan_row_y][x_2]), .map_7	(map[scan_row_y][x_3]), 
	.map_0	(map[scan_row_z][x_0]), .map_1	(map[scan_row_z][x_1]), .map_2	(map[scan_row_z][x_2]), .map_3	(map[scan_row_z][x_3]), 
	
	.x_12	(x_is_obj[3][0]), 		.x_13	(x_is_obj[3][1]), 		.x_14	(x_is_obj[3][2]), 		.x_15	(x_is_obj[3][3]), 
	.x_8	(x_is_obj[2][0]), 		.x_9	(x_is_obj[2][1]), 		.x_10	(x_is_obj[2][2]), 		.x_11	(x_is_obj[2][3]), 
	.x_4	(x_is_obj[1][0]), 		.x_5	(x_is_obj[1][1]), 		.x_6	(x_is_obj[1][2]), 		.x_7	(x_is_obj[1][3]), 
	.x_0	(x_is_obj[0][0]), 		.x_1	(x_is_obj[0][1]), 		.x_2	(x_is_obj[0][2]), 		.x_3	(x_is_obj[0][3]), 
	.is_overlap(overlap_3)
);


is_overlap is_overlap_inst_4
 (
	.map_12	(map[scan_row_x][x_0]), .map_13	(map[scan_row_x][x_1]), .map_14	(map[scan_row_x][x_2]), .map_15	(map[scan_row_x][x_3]), 
	.map_8	(map[scan_row_y][x_0]), .map_9	(map[scan_row_y][x_1]), .map_10	(map[scan_row_y][x_2]), .map_11	(map[scan_row_y][x_3]), 
	.map_4	(map[scan_row_z][x_0]), .map_5	(map[scan_row_z][x_1]), .map_6	(map[scan_row_z][x_2]), .map_7	(map[scan_row_z][x_3]), 
	.map_0	(map[scan_row_a][x_0]), .map_1	(map[scan_row_a][x_1]), .map_2	(map[scan_row_a][x_2]), .map_3	(map[scan_row_a][x_3]), 
	
	.x_12	(x_is_obj[3][0]), 		.x_13	(x_is_obj[3][1]), 		.x_14	(x_is_obj[3][2]), 		.x_15	(x_is_obj[3][3]), 
	.x_8	(x_is_obj[2][0]), 		.x_9	(x_is_obj[2][1]), 		.x_10	(x_is_obj[2][2]), 		.x_11	(x_is_obj[2][3]), 
	.x_4	(x_is_obj[1][0]), 		.x_5	(x_is_obj[1][1]), 		.x_6	(x_is_obj[1][2]), 		.x_7	(x_is_obj[1][3]), 
	.x_0	(x_is_obj[0][0]), 		.x_1	(x_is_obj[0][1]), 		.x_2	(x_is_obj[0][2]), 		.x_3	(x_is_obj[0][3]), 
	.is_overlap(overlap_4)
);


is_overlap is_overlap_inst_5
 (
	.map_12	(map[scan_row_y][x_0]), .map_13	(map[scan_row_y][x_1]), .map_14	(map[scan_row_y][x_2]), .map_15	(map[scan_row_y][x_3]), 
	.map_8	(map[scan_row_z][x_0]), .map_9	(map[scan_row_z][x_1]), .map_10	(map[scan_row_z][x_2]), .map_11	(map[scan_row_z][x_3]), 
	.map_4	(map[scan_row_a][x_0]), .map_5	(map[scan_row_a][x_1]), .map_6	(map[scan_row_a][x_2]), .map_7	(map[scan_row_a][x_3]), 
	.map_0	(map[scan_row_b][x_0]), .map_1	(map[scan_row_b][x_1]), .map_2	(map[scan_row_b][x_2]), .map_3	(map[scan_row_b][x_3]), 
	
	.x_12	(x_is_obj[3][0]), 		.x_13	(x_is_obj[3][1]), 		.x_14	(x_is_obj[3][2]), 		.x_15	(x_is_obj[3][3]), 
	.x_8	(x_is_obj[2][0]), 		.x_9	(x_is_obj[2][1]), 		.x_10	(x_is_obj[2][2]), 		.x_11	(x_is_obj[2][3]), 
	.x_4	(x_is_obj[1][0]), 		.x_5	(x_is_obj[1][1]), 		.x_6	(x_is_obj[1][2]), 		.x_7	(x_is_obj[1][3]), 
	.x_0	(x_is_obj[0][0]), 		.x_1	(x_is_obj[0][1]), 		.x_2	(x_is_obj[0][2]), 		.x_3	(x_is_obj[0][3]), 
	.is_overlap(overlap_5)
);


is_overlap is_overlap_inst_6
 (
	.map_12	(map[scan_row_z][x_0]), .map_13	(map[scan_row_z][x_1]), .map_14	(map[scan_row_z][x_2]), .map_15	(map[scan_row_z][x_3]), 
	.map_8	(map[scan_row_a][x_0]), .map_9	(map[scan_row_a][x_1]), .map_10	(map[scan_row_a][x_2]), .map_11	(map[scan_row_a][x_3]), 
	.map_4	(map[scan_row_b][x_0]), .map_5	(map[scan_row_b][x_1]), .map_6	(map[scan_row_b][x_2]), .map_7	(map[scan_row_b][x_3]), 
	.map_0	(map[scan_row_c][x_0]), .map_1	(map[scan_row_c][x_1]), .map_2	(map[scan_row_c][x_2]), .map_3	(map[scan_row_c][x_3]), 
	
	.x_12	(x_is_obj[3][0]), 		.x_13	(x_is_obj[3][1]), 		.x_14	(x_is_obj[3][2]), 		.x_15	(x_is_obj[3][3]), 
	.x_8	(x_is_obj[2][0]), 		.x_9	(x_is_obj[2][1]), 		.x_10	(x_is_obj[2][2]), 		.x_11	(x_is_obj[2][3]), 
	.x_4	(x_is_obj[1][0]), 		.x_5	(x_is_obj[1][1]), 		.x_6	(x_is_obj[1][2]), 		.x_7	(x_is_obj[1][3]), 
	.x_0	(x_is_obj[0][0]), 		.x_1	(x_is_obj[0][1]), 		.x_2	(x_is_obj[0][2]), 		.x_3	(x_is_obj[0][3]), 
	.is_overlap(overlap_6)
);

is_overlap is_overlap_inst_7
 (
	.map_12	(map[scan_row_a][x_0]), .map_13	(map[scan_row_a][x_1]), .map_14	(map[scan_row_a][x_2]), .map_15	(map[scan_row_a][x_3]), 
	.map_8	(map[scan_row_b][x_0]), .map_9	(map[scan_row_b][x_1]), .map_10	(map[scan_row_b][x_2]), .map_11	(map[scan_row_b][x_3]), 
	.map_4	(map[scan_row_c][x_0]), .map_5	(map[scan_row_c][x_1]), .map_6	(map[scan_row_c][x_2]), .map_7	(map[scan_row_c][x_3]), 
	.map_0	(map[scan_row_d][x_0]), .map_1	(map[scan_row_d][x_1]), .map_2	(map[scan_row_d][x_2]), .map_3	(map[scan_row_d][x_3]), 
	
	.x_12	(x_is_obj[3][0]), 		.x_13	(x_is_obj[3][1]), 		.x_14	(x_is_obj[3][2]), 		.x_15	(x_is_obj[3][3]), 
	.x_8	(x_is_obj[2][0]), 		.x_9	(x_is_obj[2][1]), 		.x_10	(x_is_obj[2][2]), 		.x_11	(x_is_obj[2][3]), 
	.x_4	(x_is_obj[1][0]), 		.x_5	(x_is_obj[1][1]), 		.x_6	(x_is_obj[1][2]), 		.x_7	(x_is_obj[1][3]), 
	.x_0	(x_is_obj[0][0]), 		.x_1	(x_is_obj[0][1]), 		.x_2	(x_is_obj[0][2]), 		.x_3	(x_is_obj[0][3]), 
	.is_overlap(overlap_7)
);


wire row_full [1:12];
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
assign row_full[12] = map[12][0] & map[12][1] & map[12][2] & map[12][3] & map[12][4] & map[12][5];

wire [2:0] full_count = row_full[1] + row_full[2]  + row_full[3]  + row_full[4] + 
						row_full[5] + row_full[6]  + row_full[7]  + row_full[8] + 
						row_full[9] + row_full[10] + row_full[11] + row_full[12];

wire [3:0] put_row_1 = overlap_0 ? scan_row_1 : overlap_1 ? scan_row_0 : overlap_2 ? scan_row_x : overlap_3 ? scan_row_y : overlap_4 ? scan_row_z : overlap_5 ? scan_row_a : overlap_6 ? scan_row_b : scan_row_c;
wire [3:0] put_row_2 = overlap_0 ? scan_row_2 : overlap_1 ? scan_row_1 : overlap_2 ? scan_row_0 : overlap_3 ? scan_row_x : overlap_4 ? scan_row_y : overlap_5 ? scan_row_z : overlap_6 ? scan_row_a : scan_row_b;
wire [3:0] put_row_3 = overlap_0 ? scan_row_3 : overlap_1 ? scan_row_2 : overlap_2 ? scan_row_1 : overlap_3 ? scan_row_0 : overlap_4 ? scan_row_x : overlap_5 ? scan_row_y : overlap_6 ? scan_row_z : scan_row_a;
wire [3:0] put_row_4 = overlap_0 ? scan_row_4 : overlap_1 ? scan_row_3 : overlap_2 ? scan_row_2 : overlap_3 ? scan_row_1 : overlap_4 ? scan_row_0 : overlap_5 ? scan_row_x : overlap_6 ? scan_row_y : scan_row_z;

// control
wire over_ceiling 	= map[13][0] | map[13][1] | map[13][2] | map[13][3] | map[13][4] | map[13][5];
wire overlap_flag 	= overlap_0 | overlap_1 | overlap_2 | overlap_3 | overlap_4 | overlap_5 | overlap_6 | overlap_7;
wire clear_done 	= full_count == 3'd0;

//---------------------------------------------------------------------
//   DESIGN
//---------------------------------------------------------------------
// next state logic
always @(*) begin
	case(state)
		IDLE 	: next_state = in_valid 	? DROP 	: IDLE;
		DROP 	: next_state = overlap_flag ? CLEAR : DROP;
		CLEAR	: next_state = clear_done 	? DOUT 	: CLEAR;
		DOUT 	: next_state = IDLE;
		default : next_state = IDLE;
	endcase
end

// FSM
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		state <= IDLE;
	end
	else begin
		state <= next_state;
	end
end


// input buffer
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		tetrominoes_reg <= 3'd0;
	end
	else if(in_valid) begin
		tetrominoes_reg <= tetrominoes;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		position_reg <= 3'd0;
	end
	else if(in_valid) begin
		position_reg <= position;
	end
end


// counter
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		scan_row <= 'd16;
	end
	else if (state == DROP) begin
		scan_row <= (scan_row == 'd0) ? 'd0 : (scan_row - 'd8);
	end
	else if (state == DOUT) begin
		scan_row <= 'd16;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		round_num <= 4'd0;
	end
	else if (state == DOUT) begin
		round_num <= fail ? 4'd0 : (round_num + 4'd1);
	end
end



// shape encoding
always @(*) begin
	case(tetrominoes_reg)
		SQUARE	: begin 
			x_is_obj[3][0] = 0; x_is_obj[3][1] = 0; x_is_obj[3][2] = 0; x_is_obj[3][3] = 0; 
			x_is_obj[2][0] = 0; x_is_obj[2][1] = 0; x_is_obj[2][2] = 0; x_is_obj[2][3] = 0; 
			x_is_obj[1][0] = 1; x_is_obj[1][1] = 1; x_is_obj[1][2] = 0; x_is_obj[1][3] = 0; 
			x_is_obj[0][0] = 1; x_is_obj[0][1] = 1; x_is_obj[0][2] = 0; x_is_obj[0][3] = 0; 
		end
		LINE_V	: begin 
			x_is_obj[3][0] = 1; x_is_obj[3][1] = 0; x_is_obj[3][2] = 0; x_is_obj[3][3] = 0; 
			x_is_obj[2][0] = 1; x_is_obj[2][1] = 0; x_is_obj[2][2] = 0; x_is_obj[2][3] = 0; 
			x_is_obj[1][0] = 1; x_is_obj[1][1] = 0; x_is_obj[1][2] = 0; x_is_obj[1][3] = 0; 
			x_is_obj[0][0] = 1; x_is_obj[0][1] = 0; x_is_obj[0][2] = 0; x_is_obj[0][3] = 0; 
		end
		LINE_H	: begin 
			x_is_obj[3][0] = 0; x_is_obj[3][1] = 0; x_is_obj[3][2] = 0; x_is_obj[3][3] = 0; 
			x_is_obj[2][0] = 0; x_is_obj[2][1] = 0; x_is_obj[2][2] = 0; x_is_obj[2][3] = 0; 
			x_is_obj[1][0] = 0; x_is_obj[1][1] = 0; x_is_obj[1][2] = 0; x_is_obj[1][3] = 0; 
			x_is_obj[0][0] = 1; x_is_obj[0][1] = 1; x_is_obj[0][2] = 1; x_is_obj[0][3] = 1; 
		end
		L_INV 	: begin 
			x_is_obj[3][0] = 0; x_is_obj[3][1] = 0; x_is_obj[3][2] = 0; x_is_obj[3][3] = 0; 
			x_is_obj[2][0] = 1; x_is_obj[2][1] = 1; x_is_obj[2][2] = 0; x_is_obj[2][3] = 0; 
			x_is_obj[1][0] = 0; x_is_obj[1][1] = 1; x_is_obj[1][2] = 0; x_is_obj[1][3] = 0; 
			x_is_obj[0][0] = 0; x_is_obj[0][1] = 1; x_is_obj[0][2] = 0; x_is_obj[0][3] = 0; 
		end
		L_HORI	: begin 
			x_is_obj[3][0] = 0; x_is_obj[3][1] = 0; x_is_obj[3][2] = 0; x_is_obj[3][3] = 0; 
			x_is_obj[2][0] = 0; x_is_obj[2][1] = 0; x_is_obj[2][2] = 0; x_is_obj[2][3] = 0; 
			x_is_obj[1][0] = 1; x_is_obj[1][1] = 1; x_is_obj[1][2] = 1; x_is_obj[1][3] = 0; 
			x_is_obj[0][0] = 1; x_is_obj[0][1] = 0; x_is_obj[0][2] = 0; x_is_obj[0][3] = 0; 
		end
		L_NORM	: begin 
			x_is_obj[3][0] = 1; x_is_obj[3][1] = 0; x_is_obj[3][2] = 0; x_is_obj[3][3] = 0; 
			x_is_obj[2][0] = 1; x_is_obj[2][1] = 0; x_is_obj[2][2] = 0; x_is_obj[2][3] = 0; 
			x_is_obj[1][0] = 1; x_is_obj[1][1] = 0; x_is_obj[1][2] = 0; x_is_obj[1][3] = 0; 
			x_is_obj[0][0] = 1; x_is_obj[0][1] = 1; x_is_obj[0][2] = 0; x_is_obj[0][3] = 0; 
		end
		S_VERT	: begin 
			x_is_obj[3][0] = 0; x_is_obj[3][1] = 0; x_is_obj[3][2] = 0; x_is_obj[3][3] = 0; 
			x_is_obj[2][0] = 1; x_is_obj[2][1] = 0; x_is_obj[2][2] = 0; x_is_obj[2][3] = 0; 
			x_is_obj[1][0] = 1; x_is_obj[1][1] = 1; x_is_obj[1][2] = 0; x_is_obj[1][3] = 0; 
			x_is_obj[0][0] = 0; x_is_obj[0][1] = 1; x_is_obj[0][2] = 0; x_is_obj[0][3] = 0; 
		end
		S_NORM	: begin 
			x_is_obj[3][0] = 0; x_is_obj[3][1] = 0; x_is_obj[3][2] = 0; x_is_obj[3][3] = 0; 
			x_is_obj[2][0] = 0; x_is_obj[2][1] = 0; x_is_obj[2][2] = 0; x_is_obj[2][3] = 0; 
			x_is_obj[1][0] = 0; x_is_obj[1][1] = 1; x_is_obj[1][2] = 1; x_is_obj[1][3] = 0; 
			x_is_obj[0][0] = 1; x_is_obj[0][1] = 1; x_is_obj[0][2] = 0; x_is_obj[0][3] = 0; 
		end
		default	: begin 
			x_is_obj[3][0] = 0; x_is_obj[3][1] = 0; x_is_obj[3][2] = 0; x_is_obj[3][3] = 0; 
			x_is_obj[2][0] = 0; x_is_obj[2][1] = 0; x_is_obj[2][2] = 0; x_is_obj[2][3] = 0; 
			x_is_obj[1][0] = 0; x_is_obj[1][1] = 0; x_is_obj[1][2] = 0; x_is_obj[1][3] = 0; 
			x_is_obj[0][0] = 0; x_is_obj[0][1] = 0; x_is_obj[0][2] = 0; x_is_obj[0][3] = 0; 
		end
	endcase
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for(i = 1 ; i < (MAP_HEIGHT + MAP_GROUND + MAP_CEILING) ; i = i + 1) begin
			for(j=0; j<MAP_WIDHT; j=j+1) begin
				map[i][j] <= 'd0;
			end
		end
		for(j = 0 ; j < MAP_WIDHT ; j = j + 1) begin
			map[0][j] <= 'd1; // ground
		end
	end
	else if(state == DROP & overlap_flag) begin
		case(tetrominoes_reg)
			SQUARE : begin
				map[put_row_2][x_0] <= 1'b1;	
				map[put_row_2][x_1] <= 1'b1;
				map[put_row_1][x_0] <= 1'b1;	
				map[put_row_1][x_1] <= 1'b1;
			end
			LINE_V : begin
				map[put_row_4][x_0] <= 1'b1;	
				map[put_row_3][x_0] <= 1'b1;
				map[put_row_2][x_0] <= 1'b1;	
				map[put_row_1][x_0] <= 1'b1;
			end
			LINE_H : begin
				map[put_row_1][x_3] <= 1'b1;	
				map[put_row_1][x_2] <= 1'b1;
				map[put_row_1][x_1] <= 1'b1;	
				map[put_row_1][x_0] <= 1'b1;
			end
			L_INV  : begin
				map[put_row_3][x_0] <= 1'b1;	
				map[put_row_3][x_1] <= 1'b1;
				map[put_row_2][x_1] <= 1'b1;	
				map[put_row_1][x_1] <= 1'b1;
			end
			L_HORI : begin
				map[put_row_2][x_2] <= 1'b1;	
				map[put_row_2][x_1] <= 1'b1;
				map[put_row_2][x_0] <= 1'b1;	
				map[put_row_1][x_0] <= 1'b1;
			end
			L_NORM : begin
				map[put_row_3][x_0] <= 1'b1;	
				map[put_row_2][x_0] <= 1'b1;
				map[put_row_1][x_0] <= 1'b1;	
				map[put_row_1][x_1] <= 1'b1;
			end
			S_VERT : begin
				map[put_row_3][x_0] <= 1'b1;	
				map[put_row_2][x_0] <= 1'b1;
				map[put_row_2][x_1] <= 1'b1;	
				map[put_row_1][x_1] <= 1'b1;
			end
			S_NORM : begin
				map[put_row_2][x_2] <= 1'b1;	
				map[put_row_2][x_1] <= 1'b1;
				map[put_row_1][x_1] <= 1'b1;	
				map[put_row_1][x_0] <= 1'b1;
			end
		endcase
	end
	else if(state == CLEAR) begin
		for (k = 1; k < (MAP_HEIGHT + 1); k = k + 1) begin
			if (row_full[k]) begin
				for (i = k + 1; i < (MAP_HEIGHT + MAP_GROUND + MAP_CEILING) ; i = i + 1) begin
					for (j = 0; j < MAP_WIDHT; j = j + 1) begin
						map[i-1][j] <= map[i][j];
					end
				end
				for (j = 0; j < MAP_WIDHT; j = j + 1) begin
					map[MAP_HEIGHT + MAP_CEILING][j] <= 1'b0;
				end
			end
		end
	end
	else if(tetris_valid) begin
		for(i = 1 ; i < (MAP_HEIGHT + MAP_GROUND + MAP_CEILING) ; i = i + 1) begin
			for(j = 0 ; j < MAP_WIDHT ; j = j + 1) begin
				map[i][j] <= 'd0;
			end
		end
		for(j = 0; j < MAP_WIDHT ; j = j + 1) begin
			map[0][j] <= 'd1; // ground
		end
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		score_temp <= 4'd0;
	end
	else if (state == CLEAR & full_count != 'd0) begin
		score_temp <= score_temp + 'd1;
	end
	else if (tetris_valid) begin
		score_temp <= 4'd0;
	end
end

// output
always @(*) begin
	if (state == DOUT) begin
		score_valid = 1'b1;
	end
	else begin
		score_valid = 1'b0;
	end
end

always @(*) begin
	if(score_valid) begin
		score = score_temp;
	end
	else begin
		score = 4'd0;
	end
end

always @(*) begin
	if(score_valid) begin
		fail = over_ceiling;
	end
	else begin
		fail = 1'b0;
	end
end

always @(*) begin
	if (state == DOUT & (round_num == 4'd15 | over_ceiling)) begin
		tetris_valid = 1'b1;
	end
	else begin
		tetris_valid = 1'b0;
	end
end

always @(*) begin
	if(tetris_valid) begin
		tetris = {map[12][5], map[12][4], map[12][3], map[12][2], map[12][1], map[12][0], 
				  map[11][5], map[11][4], map[11][3], map[11][2], map[11][1], map[11][0], 
				  map[10][5], map[10][4], map[10][3], map[10][2], map[10][1], map[10][0], 
				  map[9] [5], map[9] [4], map[9] [3], map[9] [2], map[9] [1], map[9] [0], 
				  map[8] [5], map[8] [4], map[8] [3], map[8] [2], map[8] [1], map[8] [0], 
				  map[7] [5], map[7] [4], map[7] [3], map[7] [2], map[7] [1], map[7] [0], 
				  map[6] [5], map[6] [4], map[6] [3], map[6] [2], map[6] [1], map[6] [0], 
				  map[5] [5], map[5] [4], map[5] [3], map[5] [2], map[5] [1], map[5] [0], 
				  map[4] [5], map[4] [4], map[4] [3], map[4] [2], map[4] [1], map[4] [0], 
				  map[3] [5], map[3] [4], map[3] [3], map[3] [2], map[3] [1], map[3] [0], 
				  map[2] [5], map[2] [4], map[2] [3], map[2] [2], map[2] [1], map[2] [0], 
				  map[1] [5], map[1] [4], map[1] [3], map[1] [2], map[1] [1], map[1] [0]};
	end
	else begin
		tetris = 72'd0;
	end
end

endmodule


module is_overlap(
	input map_0, map_1, map_2, map_3, map_4, map_5, map_6, map_7, map_8, map_9, map_10, map_11, map_12, map_13, map_14, map_15,
	input x_0, x_1, x_2, x_3, x_4, x_5, x_6, x_7, x_8, x_9, x_10, x_11, x_12, x_13, x_14, x_15,
	output is_overlap
);

assign is_overlap = (x_0  & map_0)  | (x_1  & map_1)  | (x_2  & map_2)  | (x_3  & map_3)  |
                    (x_4  & map_4)  | (x_5  & map_5)  | (x_6  & map_6)  | (x_7  & map_7)  |
                    (x_8  & map_8)  | (x_9  & map_9)  | (x_10 & map_10) | (x_11 & map_11) |
                    (x_12 & map_12) | (x_13 & map_13) | (x_14 & map_14) | (x_15 & map_15);

endmodule


