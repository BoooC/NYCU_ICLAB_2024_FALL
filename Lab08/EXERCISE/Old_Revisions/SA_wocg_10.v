/**************************************************************************/
// Copyright (c) 2024, OASIS Lab
// MODULE: SA
// FILE NAME: SA_wocg.v
// VERSRION: 1.0
// DATE: Nov 06, 2024
// AUTHOR: Yen-Ning Tung, NYCU AIG
// CODE TYPE: RTL or Behavioral Level (Verilog)
// DESCRIPTION: 2024 Spring IC Lab / Exersise Lab08 / SA_wocg
// MODIFICATION HISTORY:
// Date                 Description
// 
/**************************************************************************/

module SA(
	// Input signals
	clk,
	rst_n,
	in_valid,
	T,
	in_data,
	w_Q,
	w_K,
	w_V,
	// Output signals
	out_valid,
	out_data
);

input clk;
input rst_n;
input in_valid;
input [3:0] T;
input signed [7:0] in_data;
input signed [7:0] w_Q;
input signed [7:0] w_K;
input signed [7:0] w_V;

output reg out_valid;
output reg signed [63:0] out_data;

//==============================================//
//       parameter & integer declaration        //
//==============================================//
localparam IDLE = 'd0;
localparam CAL 	= 'd1;
localparam WAIT = 'd2;
localparam DOUT	= 'd3;


//==============================================//
//           reg & wire declaration             //
//==============================================//
// state
reg [1:0] state, next_state;


// input regs
reg signed [7:0] in_data_reg [0:7][0:7];
reg signed [7:0] weight_reg  [0:7][0:7];
reg [3:0] T_reg;

// after linear
reg signed [18:0] Q_matrix [0:7][0:7];
reg signed [18:0] K_matrix [0:7][0:7];
reg signed [18:0] V_matrix [0:7][0:7];

// Q * K
reg signed [40:0] QK_matrix [0:7][0:7];

reg signed [59:0] P_reg [0:7];
reg signed [60:0] add_stage_1 [0:3];
reg signed [61:0] add_stage_2 [0:1];
reg signed [62:0] out_reg;

// counter
reg [2:0] count_x;
reg [2:0] count_y;
reg [1:0] count_channel;
reg [5:0] out_count;


// control
wire count_x_done = count_x == 'd7;
wire count_y_done = count_y == 'd7;
wire count_channel_done = count_channel == 'd3;

wire cal_done 	= count_x_done & count_channel_done;
wire wait_done 	= count_x == 'd1;
wire dout_done 	= out_count == (T_reg << 3) - 'd1;

//==============================================//
//                  design                      //
//==============================================//
// next state logic
always @(*) begin
	case(state)
		IDLE 	: next_state = in_valid 	? CAL 	: IDLE;
		CAL		: next_state = cal_done 	? WAIT	: CAL;
		WAIT	: next_state = wait_done	? DOUT 	: WAIT;
		DOUT	: next_state = dout_done	? IDLE	: DOUT;
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


// input regs
integer i, j;
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for(i=0; i<8; i=i+1) begin
			for(j=0; j<8; j=j+1) begin
				in_data_reg[i][j] <= 'd0;
			end
		end
	end
	else if(in_valid) begin
		if (state == IDLE) begin
			in_data_reg[0][0] <= in_data;
		end
		else if (count_y < T_reg & count_channel == 'd0) begin
			in_data_reg[count_y][count_x] <= in_data;
		end
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for(i=0; i<8; i=i+1) begin
			for(j=0; j<8; j=j+1) begin
				weight_reg[i][j] <= 'd0;
			end
		end
	end
	else if(in_valid) begin
		if(count_channel == 'd0) begin
			weight_reg[count_y][count_x] <= w_Q;
		end
		else if(count_channel == 'd1) begin
			weight_reg[count_y][count_x] <= w_K;
		end
		else if(count_channel == 'd2) begin
			weight_reg[count_y][count_x] <= w_V;
		end
	end
	else if(state == IDLE) begin
		for(i=0; i<8; i=i+1) begin
			for(j=0; j<8; j=j+1) begin
				weight_reg[i][j] <= 'd0;
			end
		end
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		T_reg <= 'd0;
	end
	else if(in_valid & count_x == 'd0 & count_y == 'd0 & count_channel == 'd0) begin
		T_reg <= T;
	end
	else if(state == IDLE) begin
		T_reg <= 'd0;
	end
end

// counter
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		count_x <= 'd0;
	end
	else if(in_valid | state == CAL) begin
		count_x <= count_x_done ? 'd0 : (count_x + 'd1);
	end
	else if(state == WAIT | state == DOUT) begin
		count_x <= count_x_done ? 'd0 : (count_x + 'd1);
	end
	else if(state == IDLE) begin
		count_x <= 'd0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		count_y <= 'd0;
	end
	else if(count_x_done) begin
		count_y <= count_y_done ? 'd0 : (count_y + 'd1);
	end
	else if(state == IDLE) begin
		count_y <= 'd0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		count_channel <= 'd0;
	end
	else if(count_x_done & count_y_done) begin
		count_channel <= count_channel_done ? 'd0 : (count_channel + 'd1);
	end
	else if(state == IDLE) begin
		count_channel <= 'd0;
	end
end


reg signed [7:0] mac_0_in_1, mac_1_in_1, mac_2_in_1, mac_3_in_1, mac_4_in_1, mac_5_in_1, mac_6_in_1, mac_7_in_1;
reg signed [7:0] mac_0_in_2, mac_1_in_2, mac_2_in_2, mac_3_in_2, mac_4_in_2, mac_5_in_2, mac_6_in_2, mac_7_in_2;
reg signed [18:0] mac_0_psum_in, mac_1_psum_in, mac_2_psum_in, mac_3_psum_in, mac_4_psum_in, mac_5_psum_in, mac_6_psum_in, mac_7_psum_in;
wire signed [18:0] mac_0_psum_out, mac_1_psum_out, mac_2_psum_out, mac_3_psum_out, mac_4_psum_out, mac_5_psum_out, mac_6_psum_out, mac_7_psum_out;

MAC MAC_inst_0 (.in_1(mac_0_in_1), .in_2(mac_0_in_2), .psum_in(mac_0_psum_in), .psum_out(mac_0_psum_out));
MAC MAC_inst_1 (.in_1(mac_1_in_1), .in_2(mac_1_in_2), .psum_in(mac_1_psum_in), .psum_out(mac_1_psum_out));
MAC MAC_inst_2 (.in_1(mac_2_in_1), .in_2(mac_2_in_2), .psum_in(mac_2_psum_in), .psum_out(mac_2_psum_out));
MAC MAC_inst_3 (.in_1(mac_3_in_1), .in_2(mac_3_in_2), .psum_in(mac_3_psum_in), .psum_out(mac_3_psum_out));
MAC MAC_inst_4 (.in_1(mac_4_in_1), .in_2(mac_4_in_2), .psum_in(mac_4_psum_in), .psum_out(mac_4_psum_out));
MAC MAC_inst_5 (.in_1(mac_5_in_1), .in_2(mac_5_in_2), .psum_in(mac_5_psum_in), .psum_out(mac_5_psum_out));
MAC MAC_inst_6 (.in_1(mac_6_in_1), .in_2(mac_6_in_2), .psum_in(mac_6_psum_in), .psum_out(mac_6_psum_out));
MAC MAC_inst_7 (.in_1(mac_7_in_1), .in_2(mac_7_in_2), .psum_in(mac_7_psum_in), .psum_out(mac_7_psum_out));

always @(*) begin
	case(count_channel)
		'd1 : begin
			mac_0_in_1 = in_data_reg[0][count_y];
			mac_1_in_1 = in_data_reg[1][count_y];
			mac_2_in_1 = in_data_reg[2][count_y];
			mac_3_in_1 = in_data_reg[3][count_y];
			mac_4_in_1 = in_data_reg[4][count_y];
			mac_5_in_1 = in_data_reg[5][count_y];
			mac_6_in_1 = in_data_reg[6][count_y];
			mac_7_in_1 = in_data_reg[7][count_y];
			mac_0_in_2 = weight_reg[count_y][count_x];
			mac_1_in_2 = weight_reg[count_y][count_x];
			mac_2_in_2 = weight_reg[count_y][count_x];
			mac_3_in_2 = weight_reg[count_y][count_x];
			mac_4_in_2 = weight_reg[count_y][count_x];
			mac_5_in_2 = weight_reg[count_y][count_x];
			mac_6_in_2 = weight_reg[count_y][count_x];
			mac_7_in_2 = weight_reg[count_y][count_x];
			mac_0_psum_in = Q_matrix[0][count_x];
			mac_1_psum_in = Q_matrix[1][count_x];
			mac_2_psum_in = Q_matrix[2][count_x];
			mac_3_psum_in = Q_matrix[3][count_x];
			mac_4_psum_in = Q_matrix[4][count_x];
			mac_5_psum_in = Q_matrix[5][count_x];
			mac_6_psum_in = Q_matrix[6][count_x];
			mac_7_psum_in = Q_matrix[7][count_x];
		end
		'd2 : begin
			mac_0_in_1 = in_data_reg[0][count_y];
			mac_1_in_1 = in_data_reg[1][count_y];
			mac_2_in_1 = in_data_reg[2][count_y];
			mac_3_in_1 = in_data_reg[3][count_y];
			mac_4_in_1 = in_data_reg[4][count_y];
			mac_5_in_1 = in_data_reg[5][count_y];
			mac_6_in_1 = in_data_reg[6][count_y];
			mac_7_in_1 = in_data_reg[7][count_y];
			mac_0_in_2 = weight_reg[count_y][count_x];
			mac_1_in_2 = weight_reg[count_y][count_x];
			mac_2_in_2 = weight_reg[count_y][count_x];
			mac_3_in_2 = weight_reg[count_y][count_x];
			mac_4_in_2 = weight_reg[count_y][count_x];
			mac_5_in_2 = weight_reg[count_y][count_x];
			mac_6_in_2 = weight_reg[count_y][count_x];
			mac_7_in_2 = weight_reg[count_y][count_x];
			mac_0_psum_in = K_matrix[0][count_x];
			mac_1_psum_in = K_matrix[1][count_x];
			mac_2_psum_in = K_matrix[2][count_x];
			mac_3_psum_in = K_matrix[3][count_x];
			mac_4_psum_in = K_matrix[4][count_x];
			mac_5_psum_in = K_matrix[5][count_x];
			mac_6_psum_in = K_matrix[6][count_x];
			mac_7_psum_in = K_matrix[7][count_x];
		end
		'd3 : begin
			mac_0_in_1 = in_data_reg[0][count_x];
			mac_1_in_1 = in_data_reg[0][count_x];
			mac_2_in_1 = in_data_reg[0][count_x];
			mac_3_in_1 = in_data_reg[0][count_x];
			mac_4_in_1 = in_data_reg[0][count_x];
			mac_5_in_1 = in_data_reg[0][count_x];
			mac_6_in_1 = in_data_reg[0][count_x];
			mac_7_in_1 = in_data_reg[0][count_x];
			mac_0_in_2 = weight_reg[count_x][0];
			mac_1_in_2 = weight_reg[count_x][1];
			mac_2_in_2 = weight_reg[count_x][2];
			mac_3_in_2 = weight_reg[count_x][3];
			mac_4_in_2 = weight_reg[count_x][4];
			mac_5_in_2 = weight_reg[count_x][5];
			mac_6_in_2 = weight_reg[count_x][6];
			mac_7_in_2 = weight_reg[count_x][7];
			mac_0_psum_in = V_matrix[0][0];
			mac_1_psum_in = V_matrix[0][1];
			mac_2_psum_in = V_matrix[0][2];
			mac_3_psum_in = V_matrix[0][3];
			mac_4_psum_in = V_matrix[0][4];
			mac_5_psum_in = V_matrix[0][5];
			mac_6_psum_in = V_matrix[0][6];
			mac_7_psum_in = V_matrix[0][7];
		end
		default : begin
			mac_0_in_1 = 'd0;
			mac_1_in_1 = 'd0;
			mac_2_in_1 = 'd0;
			mac_3_in_1 = 'd0;
			mac_4_in_1 = 'd0;
			mac_5_in_1 = 'd0;
			mac_6_in_1 = 'd0;
			mac_7_in_1 = 'd0;
			mac_0_in_2 = 'd0;
			mac_1_in_2 = 'd0;
			mac_2_in_2 = 'd0;
			mac_3_in_2 = 'd0;
			mac_4_in_2 = 'd0;
			mac_5_in_2 = 'd0;
			mac_6_in_2 = 'd0;
			mac_7_in_2 = 'd0;
			mac_0_psum_in = 'd0;
			mac_1_psum_in = 'd0;
			mac_2_psum_in = 'd0;
			mac_3_psum_in = 'd0;
			mac_4_psum_in = 'd0;
			mac_5_psum_in = 'd0;
			mac_6_psum_in = 'd0;
			mac_7_psum_in = 'd0;
		end
	endcase
end



// Q, K, V matrix calculation
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for(i=0; i<8; i=i+1) begin
			for(j=0; j<8; j=j+1) begin
				Q_matrix[i][j] <= 'd0;
			end
		end
	end
	else if(state == IDLE) begin
		for(i=0; i<8; i=i+1) begin
			for(j=0; j<8; j=j+1) begin
				Q_matrix[i][j] <= 'd0;
			end
		end
	end
	else if(count_channel == 'd1) begin
		Q_matrix[0][count_x] <= mac_0_psum_out;
		Q_matrix[1][count_x] <= mac_1_psum_out;
		Q_matrix[2][count_x] <= mac_2_psum_out;
		Q_matrix[3][count_x] <= mac_3_psum_out;
		Q_matrix[4][count_x] <= mac_4_psum_out;
		Q_matrix[5][count_x] <= mac_5_psum_out;
		Q_matrix[6][count_x] <= mac_6_psum_out;
		Q_matrix[7][count_x] <= mac_7_psum_out;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for(i=0; i<8; i=i+1) begin
			for(j=0; j<8; j=j+1) begin
				K_matrix[i][j] <= 'd0;
			end
		end
	end
	else if(state == IDLE) begin
		for(i=0; i<8; i=i+1) begin
			for(j=0; j<8; j=j+1) begin
				K_matrix[i][j] <= 'd0;
			end
		end
	end
	else if(count_channel == 'd2) begin
		K_matrix[0][count_x] <= mac_0_psum_out;
		K_matrix[1][count_x] <= mac_1_psum_out;
		K_matrix[2][count_x] <= mac_2_psum_out;
		K_matrix[3][count_x] <= mac_3_psum_out;
		K_matrix[4][count_x] <= mac_4_psum_out;
		K_matrix[5][count_x] <= mac_5_psum_out;
		K_matrix[6][count_x] <= mac_6_psum_out;
		K_matrix[7][count_x] <= mac_7_psum_out;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for(i=0; i<8; i=i+1) begin
			for(j=0; j<8; j=j+1) begin
				V_matrix[i][j] <= 'd0;
			end
		end
	end
	else if(state == IDLE) begin
		for(i=0; i<8; i=i+1) begin
			for(j=0; j<8; j=j+1) begin
				V_matrix[i][j] <= 'd0;
			end
		end
	end
	else if(count_channel == 'd3 & count_y == 'd0) begin
		V_matrix[0][0] <= mac_0_psum_out;
		V_matrix[0][1] <= mac_1_psum_out;
		V_matrix[0][2] <= mac_2_psum_out;
		V_matrix[0][3] <= mac_3_psum_out;
		V_matrix[0][4] <= mac_4_psum_out;
		V_matrix[0][5] <= mac_5_psum_out;
		V_matrix[0][6] <= mac_6_psum_out;
		V_matrix[0][7] <= mac_7_psum_out;
		V_matrix[1][0] <= V_matrix[1][0] + (in_data_reg[1][count_x] * weight_reg[count_x][0]);
		V_matrix[1][1] <= V_matrix[1][1] + (in_data_reg[1][count_x] * weight_reg[count_x][1]);
		V_matrix[1][2] <= V_matrix[1][2] + (in_data_reg[1][count_x] * weight_reg[count_x][2]);
		V_matrix[1][3] <= V_matrix[1][3] + (in_data_reg[1][count_x] * weight_reg[count_x][3]);
		V_matrix[1][4] <= V_matrix[1][4] + (in_data_reg[1][count_x] * weight_reg[count_x][4]);
		V_matrix[1][5] <= V_matrix[1][5] + (in_data_reg[1][count_x] * weight_reg[count_x][5]);
		V_matrix[1][6] <= V_matrix[1][6] + (in_data_reg[1][count_x] * weight_reg[count_x][6]);
		V_matrix[1][7] <= V_matrix[1][7] + (in_data_reg[1][count_x] * weight_reg[count_x][7]);
		V_matrix[2][0] <= V_matrix[2][0] + (in_data_reg[2][count_x] * weight_reg[count_x][0]);
		V_matrix[2][1] <= V_matrix[2][1] + (in_data_reg[2][count_x] * weight_reg[count_x][1]);
		V_matrix[2][2] <= V_matrix[2][2] + (in_data_reg[2][count_x] * weight_reg[count_x][2]);
		V_matrix[2][3] <= V_matrix[2][3] + (in_data_reg[2][count_x] * weight_reg[count_x][3]);
		V_matrix[2][4] <= V_matrix[2][4] + (in_data_reg[2][count_x] * weight_reg[count_x][4]);
		V_matrix[2][5] <= V_matrix[2][5] + (in_data_reg[2][count_x] * weight_reg[count_x][5]);
		V_matrix[2][6] <= V_matrix[2][6] + (in_data_reg[2][count_x] * weight_reg[count_x][6]);
		V_matrix[2][7] <= V_matrix[2][7] + (in_data_reg[2][count_x] * weight_reg[count_x][7]);
		V_matrix[3][0] <= V_matrix[3][0] + (in_data_reg[3][count_x] * weight_reg[count_x][0]);
		V_matrix[3][1] <= V_matrix[3][1] + (in_data_reg[3][count_x] * weight_reg[count_x][1]);
		V_matrix[3][2] <= V_matrix[3][2] + (in_data_reg[3][count_x] * weight_reg[count_x][2]);
		V_matrix[3][3] <= V_matrix[3][3] + (in_data_reg[3][count_x] * weight_reg[count_x][3]);
		V_matrix[3][4] <= V_matrix[3][4] + (in_data_reg[3][count_x] * weight_reg[count_x][4]);
		V_matrix[3][5] <= V_matrix[3][5] + (in_data_reg[3][count_x] * weight_reg[count_x][5]);
		V_matrix[3][6] <= V_matrix[3][6] + (in_data_reg[3][count_x] * weight_reg[count_x][6]);
		V_matrix[3][7] <= V_matrix[3][7] + (in_data_reg[3][count_x] * weight_reg[count_x][7]);
		V_matrix[4][0] <= V_matrix[4][0] + (in_data_reg[4][count_x] * weight_reg[count_x][0]);
		V_matrix[4][1] <= V_matrix[4][1] + (in_data_reg[4][count_x] * weight_reg[count_x][1]);
		V_matrix[4][2] <= V_matrix[4][2] + (in_data_reg[4][count_x] * weight_reg[count_x][2]);
		V_matrix[4][3] <= V_matrix[4][3] + (in_data_reg[4][count_x] * weight_reg[count_x][3]);
		V_matrix[4][4] <= V_matrix[4][4] + (in_data_reg[4][count_x] * weight_reg[count_x][4]);
		V_matrix[4][5] <= V_matrix[4][5] + (in_data_reg[4][count_x] * weight_reg[count_x][5]);
		V_matrix[4][6] <= V_matrix[4][6] + (in_data_reg[4][count_x] * weight_reg[count_x][6]);
		V_matrix[4][7] <= V_matrix[4][7] + (in_data_reg[4][count_x] * weight_reg[count_x][7]);
		V_matrix[5][0] <= V_matrix[5][0] + (in_data_reg[5][count_x] * weight_reg[count_x][0]);
		V_matrix[5][1] <= V_matrix[5][1] + (in_data_reg[5][count_x] * weight_reg[count_x][1]);
		V_matrix[5][2] <= V_matrix[5][2] + (in_data_reg[5][count_x] * weight_reg[count_x][2]);
		V_matrix[5][3] <= V_matrix[5][3] + (in_data_reg[5][count_x] * weight_reg[count_x][3]);
		V_matrix[5][4] <= V_matrix[5][4] + (in_data_reg[5][count_x] * weight_reg[count_x][4]);
		V_matrix[5][5] <= V_matrix[5][5] + (in_data_reg[5][count_x] * weight_reg[count_x][5]);
		V_matrix[5][6] <= V_matrix[5][6] + (in_data_reg[5][count_x] * weight_reg[count_x][6]);
		V_matrix[5][7] <= V_matrix[5][7] + (in_data_reg[5][count_x] * weight_reg[count_x][7]);
		V_matrix[6][0] <= V_matrix[6][0] + (in_data_reg[6][count_x] * weight_reg[count_x][0]);
		V_matrix[6][1] <= V_matrix[6][1] + (in_data_reg[6][count_x] * weight_reg[count_x][1]);
		V_matrix[6][2] <= V_matrix[6][2] + (in_data_reg[6][count_x] * weight_reg[count_x][2]);
		V_matrix[6][3] <= V_matrix[6][3] + (in_data_reg[6][count_x] * weight_reg[count_x][3]);
		V_matrix[6][4] <= V_matrix[6][4] + (in_data_reg[6][count_x] * weight_reg[count_x][4]);
		V_matrix[6][5] <= V_matrix[6][5] + (in_data_reg[6][count_x] * weight_reg[count_x][5]);
		V_matrix[6][6] <= V_matrix[6][6] + (in_data_reg[6][count_x] * weight_reg[count_x][6]);
		V_matrix[6][7] <= V_matrix[6][7] + (in_data_reg[6][count_x] * weight_reg[count_x][7]);
		V_matrix[7][0] <= V_matrix[7][0] + (in_data_reg[7][count_x] * weight_reg[count_x][0]);
		V_matrix[7][1] <= V_matrix[7][1] + (in_data_reg[7][count_x] * weight_reg[count_x][1]);
		V_matrix[7][2] <= V_matrix[7][2] + (in_data_reg[7][count_x] * weight_reg[count_x][2]);
		V_matrix[7][3] <= V_matrix[7][3] + (in_data_reg[7][count_x] * weight_reg[count_x][3]);
		V_matrix[7][4] <= V_matrix[7][4] + (in_data_reg[7][count_x] * weight_reg[count_x][4]);
		V_matrix[7][5] <= V_matrix[7][5] + (in_data_reg[7][count_x] * weight_reg[count_x][5]);
		V_matrix[7][6] <= V_matrix[7][6] + (in_data_reg[7][count_x] * weight_reg[count_x][6]);
		V_matrix[7][7] <= V_matrix[7][7] + (in_data_reg[7][count_x] * weight_reg[count_x][7]);
	end
end


// Q * K
wire signed [40:0] QK_result [0:7];
assign QK_result[0] = QK_matrix[count_y][0] + (Q_matrix[count_y][count_x] * K_matrix[0][count_x]);
assign QK_result[1] = QK_matrix[count_y][1] + (Q_matrix[count_y][count_x] * K_matrix[1][count_x]);
assign QK_result[2] = QK_matrix[count_y][2] + (Q_matrix[count_y][count_x] * K_matrix[2][count_x]);
assign QK_result[3] = QK_matrix[count_y][3] + (Q_matrix[count_y][count_x] * K_matrix[3][count_x]);
assign QK_result[4] = QK_matrix[count_y][4] + (Q_matrix[count_y][count_x] * K_matrix[4][count_x]);
assign QK_result[5] = QK_matrix[count_y][5] + (Q_matrix[count_y][count_x] * K_matrix[5][count_x]);
assign QK_result[6] = QK_matrix[count_y][6] + (Q_matrix[count_y][count_x] * K_matrix[6][count_x]);
assign QK_result[7] = QK_matrix[count_y][7] + (Q_matrix[count_y][count_x] * K_matrix[7][count_x]);

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for(i=0; i<8; i=i+1) begin
			for(j=0; j<8; j=j+1) begin
				QK_matrix[i][j] <= 'd0;
			end
		end
	end
	else if(state == IDLE) begin
		for(i=0; i<8; i=i+1) begin
			for(j=0; j<8; j=j+1) begin
				QK_matrix[i][j] <= 'd0;
			end
		end
	end
	else if(count_channel == 'd3) begin
		QK_matrix[count_y][0] <= count_x_done ? (QK_result[0][40] ? 'd0 : (QK_result[0] / 'd3)) : QK_result[0];
		QK_matrix[count_y][1] <= count_x_done ? (QK_result[1][40] ? 'd0 : (QK_result[1] / 'd3)) : QK_result[1];
		QK_matrix[count_y][2] <= count_x_done ? (QK_result[2][40] ? 'd0 : (QK_result[2] / 'd3)) : QK_result[2];
		QK_matrix[count_y][3] <= count_x_done ? (QK_result[3][40] ? 'd0 : (QK_result[3] / 'd3)) : QK_result[3];
		QK_matrix[count_y][4] <= count_x_done ? (QK_result[4][40] ? 'd0 : (QK_result[4] / 'd3)) : QK_result[4];
		QK_matrix[count_y][5] <= count_x_done ? (QK_result[5][40] ? 'd0 : (QK_result[5] / 'd3)) : QK_result[5];
		QK_matrix[count_y][6] <= count_x_done ? (QK_result[6][40] ? 'd0 : (QK_result[6] / 'd3)) : QK_result[6];
		QK_matrix[count_y][7] <= count_x_done ? (QK_result[7][40] ? 'd0 : (QK_result[7] / 'd3)) : QK_result[7];
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		out_count <= 'd0;
	end
	else if(state == DOUT) begin
		out_count <= dout_done ? 'd0 : (out_count + 'd1);
	end
end

wire [2:0] pre_count_y = (count_y == 'd0) ? 'd7 : (count_y - 'd1);
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for(i=0; i<8; i=i+1) begin
			P_reg[i] <= 'd0;
		end
	end
	else begin
		P_reg[0] <= (QK_matrix[pre_count_y][0] * V_matrix[0][count_x]);
		P_reg[1] <= (QK_matrix[pre_count_y][1] * V_matrix[1][count_x]);
		P_reg[2] <= (QK_matrix[pre_count_y][2] * V_matrix[2][count_x]);
		P_reg[3] <= (QK_matrix[pre_count_y][3] * V_matrix[3][count_x]);
		P_reg[4] <= (QK_matrix[pre_count_y][4] * V_matrix[4][count_x]);
		P_reg[5] <= (QK_matrix[pre_count_y][5] * V_matrix[5][count_x]);
		P_reg[6] <= (QK_matrix[pre_count_y][6] * V_matrix[6][count_x]);
		P_reg[7] <= (QK_matrix[pre_count_y][7] * V_matrix[7][count_x]);
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		out_reg <= 'd0;
	end
	else begin
		out_reg <= P_reg[0] + P_reg[1] + P_reg[2] + P_reg[3] + P_reg[4] + P_reg[5] + P_reg[6] + P_reg[7];
	end
end

// output
always @(*) begin
	if(state == DOUT) begin
		out_valid = 1'b1;
	end
	else begin
		out_valid = 1'b0;
	end
end

always @(*) begin
	if(out_valid) begin
		out_data = out_reg;
	end
	else begin
		out_data = 'd0;
	end
end

endmodule


module MAC(
	input signed [7:0] in_1,
	input signed [7:0] in_2,
	input signed [18:0] psum_in,
	output signed [18:0] psum_out
);

assign psum_out = psum_in + (in_1 * in_2);

endmodule

