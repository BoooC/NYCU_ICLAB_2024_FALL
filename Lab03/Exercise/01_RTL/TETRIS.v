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
parameter MAP_WIDTH 	= 6;
parameter MAP_GROUND 	= 1;
parameter MAP_CEILING 	= 3;

// shape
parameter SQUARE	= 3'd0;
parameter LINE_V  	= 3'd1;
parameter LINE_H  	= 3'd2;
parameter L_INV 	= 3'd3;
parameter L_HORI	= 3'd4;
parameter L_NORM	= 3'd5;
parameter S_VERT	= 3'd6;
parameter S_NORM	= 3'd7;

// state
localparam IDLE 	= 1'd0;
localparam CLEAR 	= 1'd1;

integer i, j, k;
//---------------------------------------------------------------------
//   REG DECLARATION
//---------------------------------------------------------------------
reg state, next_state;
reg [0:MAP_WIDTH-1] map [MAP_HEIGHT-1+MAP_GROUND+MAP_CEILING:1];

// counters
reg [3:0] 	round_num;
reg [2:0] 	score_count;
//---------------------------------------------------------------------
//   WIRE DECLARATION
//---------------------------------------------------------------------
wire [2:0] 	x_arr 		[0:3];
wire 		overlap 	[1:12];
reg 		x_is_obj 	[0:3][0:3];	// mask
wire 		row_full 	[1:12];

// x_arr position
assign x_arr[0] = position;
assign x_arr[1] = (position > 3'd4) ? 3'd5 : (position + 3'd1);
assign x_arr[2] = (position > 3'd3) ? 3'd5 : (position + 3'd2);
assign x_arr[3] = (position > 3'd2) ? 3'd5 : (position + 3'd3);

// shape encoding
always @(*) begin
	case(tetrominoes)
		SQUARE	: begin 
			x_is_obj[3][0] = 0;
			x_is_obj[2][0] = 0; x_is_obj[2][1] = 0;
			x_is_obj[1][0] = 1; x_is_obj[1][1] = 1; x_is_obj[1][2] = 0;
			x_is_obj[0][0] = 1; x_is_obj[0][1] = 1; x_is_obj[0][2] = 0; x_is_obj[0][3] = 0; 
		end
		LINE_V	: begin 
			x_is_obj[3][0] = 1;
			x_is_obj[2][0] = 1; x_is_obj[2][1] = 0;
			x_is_obj[1][0] = 1; x_is_obj[1][1] = 0; x_is_obj[1][2] = 0;
			x_is_obj[0][0] = 1; x_is_obj[0][1] = 0; x_is_obj[0][2] = 0; x_is_obj[0][3] = 0; 
		end
		LINE_H	: begin 
			x_is_obj[3][0] = 0;
			x_is_obj[2][0] = 0; x_is_obj[2][1] = 0;
			x_is_obj[1][0] = 0; x_is_obj[1][1] = 0; x_is_obj[1][2] = 0;
			x_is_obj[0][0] = 1; x_is_obj[0][1] = 1; x_is_obj[0][2] = 1; x_is_obj[0][3] = 1; 
		end
		L_INV 	: begin 
			x_is_obj[3][0] = 0; 
			x_is_obj[2][0] = 1; x_is_obj[2][1] = 1; 
			x_is_obj[1][0] = 0; x_is_obj[1][1] = 1; x_is_obj[1][2] = 0;
			x_is_obj[0][0] = 0; x_is_obj[0][1] = 1; x_is_obj[0][2] = 0; x_is_obj[0][3] = 0; 
		end
		L_HORI	: begin 
			x_is_obj[3][0] = 0;
			x_is_obj[2][0] = 0; x_is_obj[2][1] = 0;
			x_is_obj[1][0] = 1; x_is_obj[1][1] = 1; x_is_obj[1][2] = 1;
			x_is_obj[0][0] = 1; x_is_obj[0][1] = 0; x_is_obj[0][2] = 0; x_is_obj[0][3] = 0; 
		end
		L_NORM	: begin 
			x_is_obj[3][0] = 1;
			x_is_obj[2][0] = 1; x_is_obj[2][1] = 0;
			x_is_obj[1][0] = 1; x_is_obj[1][1] = 0; x_is_obj[1][2] = 0;
			x_is_obj[0][0] = 1; x_is_obj[0][1] = 1; x_is_obj[0][2] = 0; x_is_obj[0][3] = 0; 
		end
		S_VERT	: begin 
			x_is_obj[3][0] = 0;
			x_is_obj[2][0] = 1; x_is_obj[2][1] = 0;
			x_is_obj[1][0] = 1; x_is_obj[1][1] = 1; x_is_obj[1][2] = 0;
			x_is_obj[0][0] = 0; x_is_obj[0][1] = 1; x_is_obj[0][2] = 0; x_is_obj[0][3] = 0; 
		end
		S_NORM	: begin 
			x_is_obj[3][0] = 0;
			x_is_obj[2][0] = 0; x_is_obj[2][1] = 0;
			x_is_obj[1][0] = 0; x_is_obj[1][1] = 1; x_is_obj[1][2] = 1;
			x_is_obj[0][0] = 1; x_is_obj[0][1] = 1; x_is_obj[0][2] = 0; x_is_obj[0][3] = 0; 
		end
		default	: begin 
			x_is_obj[3][0] = 0;
			x_is_obj[2][0] = 0; x_is_obj[2][1] = 0;
			x_is_obj[1][0] = 0; x_is_obj[1][1] = 0; x_is_obj[1][2] = 0;
			x_is_obj[0][0] = 0; x_is_obj[0][1] = 0; x_is_obj[0][2] = 0; x_is_obj[0][3] = 0; 
		end
	endcase
end

// find is_overlap for each row
genvar i_gen;
generate
    for (i_gen = 0; i_gen < MAP_HEIGHT; i_gen = i_gen + 1) begin: is_overlap_generate
        is_overlap is_overlap_inst (
            .map_12(map[4+i_gen][x_arr[0]]),
            .map_8 (map[3+i_gen][x_arr[0]]), .map_9(map[3+i_gen][x_arr[1]]),
            .map_4 (map[2+i_gen][x_arr[0]]), .map_5(map[2+i_gen][x_arr[1]]), .map_6(map[2+i_gen][x_arr[2]]),
            .map_0 (map[1+i_gen][x_arr[0]]), .map_1(map[1+i_gen][x_arr[1]]), .map_2(map[1+i_gen][x_arr[2]]), .map_3(map[1+i_gen][x_arr[3]]),

            .x_12(x_is_obj[3][0]),
            .x_8 (x_is_obj[2][0]), .x_9(x_is_obj[2][1]),
            .x_4 (x_is_obj[1][0]), .x_5(x_is_obj[1][1]), .x_6(x_is_obj[1][2]),
            .x_0 (x_is_obj[0][0]), .x_1(x_is_obj[0][1]), .x_2(x_is_obj[0][2]), .x_3(x_is_obj[0][3]),

            .is_overlap(overlap[1+i_gen])
        );
    end
endgenerate

assign row_full[1]  = &map[1];
assign row_full[2]  = &map[2];
assign row_full[3]  = &map[3];
assign row_full[4]  = &map[4];
assign row_full[5]  = &map[5];
assign row_full[6]  = &map[6];
assign row_full[7]  = &map[7];
assign row_full[8]  = &map[8];
assign row_full[9]  = &map[9];
assign row_full[10] = &map[10];
assign row_full[11] = &map[11];
assign row_full[12] = &map[12];

wire is_full = 	row_full[1] | row_full[2]  | row_full[3]  | row_full[4] | 
				row_full[5] | row_full[6]  | row_full[7]  | row_full[8] | 
				row_full[9] | row_full[10] | row_full[11] | row_full[12];

// drop y position
wire [3:0] put_row_1 =	overlap[12] ? 4'd13 : overlap[11] ? 4'd12 : overlap[10] ? 4'd11 : overlap[9] ? 4'd10 : 
						overlap[8] 	? 4'd9 	: overlap[7]  ? 4'd8  : overlap[6]  ? 4'd7  : overlap[5] ? 4'd6	 : 
					   	overlap[4] 	? 4'd5	: overlap[3]  ? 4'd4  : overlap[2]  ? 4'd3  : overlap[1] ? 4'd2  : 4'd1;

wire [3:0] put_row_2 = put_row_1 + 'd1;
wire [3:0] put_row_3 = put_row_2 + 'd1;
wire [3:0] put_row_4 = put_row_3 + 'd1;

// control
wire over_ceiling 	= map[MAP_HEIGHT+1][0] | map[MAP_HEIGHT+1][1] | map[MAP_HEIGHT+1][2] | map[MAP_HEIGHT+1][3] | map[MAP_HEIGHT+1][4] | map[MAP_HEIGHT+1][5];
wire direct_out		= (state == CLEAR) & (~is_full);

//---------------------------------------------------------------------
//   DESIGN
//---------------------------------------------------------------------
// next state logic
always @(*) begin
	if(in_valid | is_full) begin
		next_state = CLEAR;
	end
	else begin
		next_state = IDLE;
	end
	//case(state)
	//	IDLE 	: next_state = in_valid	? CLEAR : IDLE;
	//	CLEAR	: next_state = is_full 	? CLEAR : IDLE;
	//	default : next_state = IDLE;
	//endcase
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

// counter
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		round_num <= 4'd0;
	end
	else if (direct_out) begin
		round_num <= fail ? 4'd0 : (round_num + 4'd1);
	end
end

// map logic
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for(i = 1 ; i < (MAP_HEIGHT + MAP_GROUND + MAP_CEILING) ; i = i + 1) begin
			for(j = 0 ; j < MAP_WIDTH ; j = j + 1) begin
				map[i][j] <= 1'b0;
			end
		end
	end
	else if(tetris_valid) begin
		for(i = 1 ; i < (MAP_HEIGHT + MAP_GROUND + MAP_CEILING) ; i = i + 1) begin
			for(j = 0 ; j < MAP_WIDTH ; j = j + 1) begin
				map[i][j] <= 1'b0;
			end
		end
	end
	else if(in_valid) begin
		for(i = 1 ; i < (MAP_HEIGHT + MAP_GROUND + MAP_CEILING) ; i = i + 1) begin
			for(j = 0 ; j < MAP_WIDTH ; j = j + 1) begin
				map[i][j] <= map[i][j];
			end
		end
		case(tetrominoes)
			SQUARE : begin
				map[put_row_2][x_arr[0]] <= 1'b1;	
				map[put_row_2][x_arr[1]] <= 1'b1;
				map[put_row_1][x_arr[0]] <= 1'b1;	
				map[put_row_1][x_arr[1]] <= 1'b1;
			end
			LINE_V : begin
				map[put_row_4][x_arr[0]] <= 1'b1;	
				map[put_row_3][x_arr[0]] <= 1'b1;
				map[put_row_2][x_arr[0]] <= 1'b1;	
				map[put_row_1][x_arr[0]] <= 1'b1;
			end
			LINE_H : begin
				map[put_row_1][x_arr[3]] <= 1'b1;	
				map[put_row_1][x_arr[2]] <= 1'b1;
				map[put_row_1][x_arr[1]] <= 1'b1;	
				map[put_row_1][x_arr[0]] <= 1'b1;
			end
			L_INV  : begin
				map[put_row_3][x_arr[0]] <= 1'b1;	
				map[put_row_3][x_arr[1]] <= 1'b1;
				map[put_row_2][x_arr[1]] <= 1'b1;	
				map[put_row_1][x_arr[1]] <= 1'b1;
			end
			L_HORI : begin
				map[put_row_2][x_arr[2]] <= 1'b1;	
				map[put_row_2][x_arr[1]] <= 1'b1;
				map[put_row_2][x_arr[0]] <= 1'b1;	
				map[put_row_1][x_arr[0]] <= 1'b1;
			end
			L_NORM : begin
				map[put_row_3][x_arr[0]] <= 1'b1;	
				map[put_row_2][x_arr[0]] <= 1'b1;
				map[put_row_1][x_arr[0]] <= 1'b1;	
				map[put_row_1][x_arr[1]] <= 1'b1;
			end
			S_VERT : begin
				map[put_row_3][x_arr[0]] <= 1'b1;	
				map[put_row_2][x_arr[0]] <= 1'b1;
				map[put_row_2][x_arr[1]] <= 1'b1;	
				map[put_row_1][x_arr[1]] <= 1'b1;
			end
			S_NORM : begin
				map[put_row_2][x_arr[2]] <= 1'b1;	
				map[put_row_2][x_arr[1]] <= 1'b1;
				map[put_row_1][x_arr[1]] <= 1'b1;	
				map[put_row_1][x_arr[0]] <= 1'b1;
			end
		endcase
	end
	else if(state == CLEAR & is_full) begin
		for (k = 1; k < (MAP_HEIGHT + 1); k = k + 1) begin
			if (row_full[k]) begin
				for (i = k + 1; i < (MAP_HEIGHT + MAP_GROUND + MAP_CEILING) ; i = i + 1) begin
					map[i-1] <= map[i];
				end
				for (j = 0; j < MAP_WIDTH; j = j + 1) begin
					map[MAP_HEIGHT + MAP_CEILING] <= 6'd0;
				end
			end
		end
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		score_count <= 3'd0;
	end
	else if (state == CLEAR & is_full) begin
		score_count <= score_count + 3'd1;
	end
	else if (tetris_valid) begin
		score_count <= 3'd0;
	end
end

//---------------------------------------------------------------------
//   OUTPUT
//---------------------------------------------------------------------
always @(*) begin
	if (direct_out) begin
		score_valid = 1'b1;
	end
	else begin
		score_valid = 1'b0;
	end
end

always @(*) begin
	if(score_valid) begin
		score = score_count;
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
	if (direct_out & (round_num == 4'd15 | over_ceiling)) begin
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


module is_overlap (
	input map_0, map_1, map_2, map_3, map_4, map_5, map_6, map_8, map_9, map_12,
	input x_0, x_1, x_2, x_3, x_4, x_5, x_6, x_8, x_9, x_12,
	output is_overlap
);

assign is_overlap = (x_0  & map_0) | (x_1 & map_1) | (x_2 & map_2) | (x_3 & map_3) |
                    (x_4  & map_4) | (x_5 & map_5) | (x_6 & map_6) |
                    (x_8  & map_8) | (x_9 & map_9) |
                    (x_12 & map_12);

endmodule
