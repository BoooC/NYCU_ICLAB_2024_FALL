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

reg [2:0] GEMM_count_x;
reg [2:0] GEMM_count_y;
reg [1:0] GEMM_count_channel;

reg [2:0] QK_count_x;
reg [2:0] QK_count_y;
reg [1:0] QK_count_channel;

reg [5:0] out_count;
reg [2:0] out_count_x;
reg [2:0] out_count_y;

// control
wire count_x_done = count_x == 'd7;
wire count_y_done = count_y == 'd7;
wire count_channel_done = count_channel == 'd3;

wire cal_done 	= (count_x == 'd6) & count_y_done & (count_channel == 'd2);
wire wait_done 	= count_x == 'd0;
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
always @(posedge clk) begin
	if(in_valid) begin
		if (state == IDLE) begin
			in_data_reg[0][0] <= in_data;
		end
		else if (count_y < T_reg & count_channel == 'd0) begin
			in_data_reg[count_y][count_x] <= in_data;
		end
	end
end

always @(posedge clk) begin
	if(in_valid) begin
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

always @(posedge clk) begin
	if(in_valid & count_x == 'd0 & count_y == 'd0 & count_channel == 'd0) begin
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

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		GEMM_count_x <= 'd0;
	end
	else if((count_channel == 'd0 & count_x >= 'd1 & count_y == 'd7) | (count_channel != 'd0)) begin
		GEMM_count_x <= (GEMM_count_x == 'd7) ? 'd0 : (GEMM_count_x + 'd1);
	end
	else if(state == IDLE) begin
		GEMM_count_x <= 'd0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		GEMM_count_y <= 'd0;
	end
	else if(GEMM_count_x == 'd7) begin
		GEMM_count_y <= (GEMM_count_y == 'd7) ? 'd0 : (GEMM_count_y + 'd1);
	end
	else if(state == IDLE) begin
		GEMM_count_y <= 'd0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		GEMM_count_channel <= 'd0;
	end
	else if(count_channel == 'd0 & count_y == 'd7) begin
		GEMM_count_channel <= 'd1;
	end
	else if(GEMM_count_x == 'd7 & GEMM_count_y == 'd7) begin
		GEMM_count_channel <= (GEMM_count_channel == 'd3) ? 'd0 : (GEMM_count_channel + 'd1);
	end
	else if(state == IDLE) begin
		GEMM_count_channel <= 'd0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		QK_count_x <= 'd0;
	end
	else if((GEMM_count_channel == 'd2 & GEMM_count_x >= 'd1 & GEMM_count_y == 'd7) | (GEMM_count_channel == 'd3)) begin
		QK_count_x <= (QK_count_x == 'd7) ? 'd0 : (QK_count_x + 'd1);
	end
	else if(state == IDLE) begin
		QK_count_x <= 'd0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		QK_count_y <= 'd0;
	end
	else if(QK_count_x == 'd7) begin
		QK_count_y <= (QK_count_y == 'd7) ? 'd0 : (QK_count_y + 'd1);
	end
	else if(state == IDLE) begin
		QK_count_y <= 'd0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		QK_count_channel <= 'd0;
	end
	else if(GEMM_count_channel == 'd2 & GEMM_count_x == 'd0 & GEMM_count_y == 'd7) begin
		QK_count_channel <= 'd1;
	end
	else if(state == IDLE) begin
		QK_count_channel <= 'd0;
	end
end


reg signed [7:0] mac_0_in_1, mac_1_in_1, mac_2_in_1, mac_3_in_1, mac_4_in_1, mac_5_in_1, mac_6_in_1, mac_7_in_1;
reg signed [7:0] mac_0_in_2, mac_1_in_2, mac_2_in_2, mac_3_in_2, mac_4_in_2, mac_5_in_2, mac_6_in_2, mac_7_in_2;
reg signed [18:0] mac_0_psum_in, mac_1_psum_in, mac_2_psum_in, mac_3_psum_in, mac_4_psum_in, mac_5_psum_in, mac_6_psum_in, mac_7_psum_in;
wire signed [18:0] mac_0_psum_out, mac_1_psum_out, mac_2_psum_out, mac_3_psum_out, mac_4_psum_out, mac_5_psum_out, mac_6_psum_out, mac_7_psum_out;

reg  signed [18:0] mac_19_0_in_1, mac_19_1_in_1, mac_19_2_in_1, mac_19_3_in_1, mac_19_4_in_1, mac_19_5_in_1, mac_19_6_in_1, mac_19_7_in_1;
reg  signed [18:0] mac_19_0_in_2, mac_19_1_in_2, mac_19_2_in_2, mac_19_3_in_2, mac_19_4_in_2, mac_19_5_in_2, mac_19_6_in_2, mac_19_7_in_2;
reg  signed [40:0] mac_19_0_psum_in, mac_19_1_psum_in, mac_19_2_psum_in, mac_19_3_psum_in, mac_19_4_psum_in, mac_19_5_psum_in, mac_19_6_psum_in, mac_19_7_psum_in;
wire signed [40:0] mac_19_0_psum_out, mac_19_1_psum_out, mac_19_2_psum_out, mac_19_3_psum_out, mac_19_4_psum_out, mac_19_5_psum_out, mac_19_6_psum_out, mac_19_7_psum_out;

MAC MAC_inst_0 (.in_1(mac_0_in_1), .in_2(mac_0_in_2), .psum_in(mac_0_psum_in), .psum_out(mac_0_psum_out));
MAC MAC_inst_1 (.in_1(mac_1_in_1), .in_2(mac_1_in_2), .psum_in(mac_1_psum_in), .psum_out(mac_1_psum_out));
MAC MAC_inst_2 (.in_1(mac_2_in_1), .in_2(mac_2_in_2), .psum_in(mac_2_psum_in), .psum_out(mac_2_psum_out));
MAC MAC_inst_3 (.in_1(mac_3_in_1), .in_2(mac_3_in_2), .psum_in(mac_3_psum_in), .psum_out(mac_3_psum_out));
MAC MAC_inst_4 (.in_1(mac_4_in_1), .in_2(mac_4_in_2), .psum_in(mac_4_psum_in), .psum_out(mac_4_psum_out));
MAC MAC_inst_5 (.in_1(mac_5_in_1), .in_2(mac_5_in_2), .psum_in(mac_5_psum_in), .psum_out(mac_5_psum_out));
MAC MAC_inst_6 (.in_1(mac_6_in_1), .in_2(mac_6_in_2), .psum_in(mac_6_psum_in), .psum_out(mac_6_psum_out));
MAC MAC_inst_7 (.in_1(mac_7_in_1), .in_2(mac_7_in_2), .psum_in(mac_7_psum_in), .psum_out(mac_7_psum_out));

MAC_19 MAC_19_inst_0 (.in_1(mac_19_0_in_1), .in_2(mac_19_0_in_2), .psum_in(mac_19_0_psum_in), .psum_out(mac_19_0_psum_out));
MAC_19 MAC_19_inst_1 (.in_1(mac_19_1_in_1), .in_2(mac_19_1_in_2), .psum_in(mac_19_1_psum_in), .psum_out(mac_19_1_psum_out));
MAC_19 MAC_19_inst_2 (.in_1(mac_19_2_in_1), .in_2(mac_19_2_in_2), .psum_in(mac_19_2_psum_in), .psum_out(mac_19_2_psum_out));
MAC_19 MAC_19_inst_3 (.in_1(mac_19_3_in_1), .in_2(mac_19_3_in_2), .psum_in(mac_19_3_psum_in), .psum_out(mac_19_3_psum_out));
MAC_19 MAC_19_inst_4 (.in_1(mac_19_4_in_1), .in_2(mac_19_4_in_2), .psum_in(mac_19_4_psum_in), .psum_out(mac_19_4_psum_out));
MAC_19 MAC_19_inst_5 (.in_1(mac_19_5_in_1), .in_2(mac_19_5_in_2), .psum_in(mac_19_5_psum_in), .psum_out(mac_19_5_psum_out));
MAC_19 MAC_19_inst_6 (.in_1(mac_19_6_in_1), .in_2(mac_19_6_in_2), .psum_in(mac_19_6_psum_in), .psum_out(mac_19_6_psum_out));
MAC_19 MAC_19_inst_7 (.in_1(mac_19_7_in_1), .in_2(mac_19_7_in_2), .psum_in(mac_19_7_psum_in), .psum_out(mac_19_7_psum_out));

always @(*) begin
	case(GEMM_count_channel)
		'd1 : begin
			mac_0_in_1 = in_data_reg[0][GEMM_count_y];
			mac_1_in_1 = in_data_reg[1][GEMM_count_y];
			mac_2_in_1 = in_data_reg[2][GEMM_count_y];
			mac_3_in_1 = in_data_reg[3][GEMM_count_y];
			mac_4_in_1 = in_data_reg[4][GEMM_count_y];
			mac_5_in_1 = in_data_reg[5][GEMM_count_y];
			mac_6_in_1 = in_data_reg[6][GEMM_count_y];
			mac_7_in_1 = in_data_reg[7][GEMM_count_y];
			mac_0_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_1_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_2_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_3_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_4_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_5_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_6_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_7_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_0_psum_in = Q_matrix[0][GEMM_count_x];
			mac_1_psum_in = Q_matrix[1][GEMM_count_x];
			mac_2_psum_in = Q_matrix[2][GEMM_count_x];
			mac_3_psum_in = Q_matrix[3][GEMM_count_x];
			mac_4_psum_in = Q_matrix[4][GEMM_count_x];
			mac_5_psum_in = Q_matrix[5][GEMM_count_x];
			mac_6_psum_in = Q_matrix[6][GEMM_count_x];
			mac_7_psum_in = Q_matrix[7][GEMM_count_x];
		end
		'd2 : begin
			mac_0_in_1 = in_data_reg[0][GEMM_count_y];
			mac_1_in_1 = in_data_reg[1][GEMM_count_y];
			mac_2_in_1 = in_data_reg[2][GEMM_count_y];
			mac_3_in_1 = in_data_reg[3][GEMM_count_y];
			mac_4_in_1 = in_data_reg[4][GEMM_count_y];
			mac_5_in_1 = in_data_reg[5][GEMM_count_y];
			mac_6_in_1 = in_data_reg[6][GEMM_count_y];
			mac_7_in_1 = in_data_reg[7][GEMM_count_y];
			mac_0_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_1_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_2_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_3_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_4_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_5_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_6_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_7_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_0_psum_in = K_matrix[0][GEMM_count_x];
			mac_1_psum_in = K_matrix[1][GEMM_count_x];
			mac_2_psum_in = K_matrix[2][GEMM_count_x];
			mac_3_psum_in = K_matrix[3][GEMM_count_x];
			mac_4_psum_in = K_matrix[4][GEMM_count_x];
			mac_5_psum_in = K_matrix[5][GEMM_count_x];
			mac_6_psum_in = K_matrix[6][GEMM_count_x];
			mac_7_psum_in = K_matrix[7][GEMM_count_x];
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
	else if(GEMM_count_channel == 'd1) begin
		Q_matrix[0][GEMM_count_x] <= mac_0_psum_out;
		Q_matrix[1][GEMM_count_x] <= mac_1_psum_out;
		Q_matrix[2][GEMM_count_x] <= mac_2_psum_out;
		Q_matrix[3][GEMM_count_x] <= mac_3_psum_out;
		Q_matrix[4][GEMM_count_x] <= mac_4_psum_out;
		Q_matrix[5][GEMM_count_x] <= mac_5_psum_out;
		Q_matrix[6][GEMM_count_x] <= mac_6_psum_out;
		Q_matrix[7][GEMM_count_x] <= mac_7_psum_out;
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
	else if(GEMM_count_channel == 'd2) begin
		K_matrix[0][GEMM_count_x] <= mac_0_psum_out;
		K_matrix[1][GEMM_count_x] <= mac_1_psum_out;
		K_matrix[2][GEMM_count_x] <= mac_2_psum_out;
		K_matrix[3][GEMM_count_x] <= mac_3_psum_out;
		K_matrix[4][GEMM_count_x] <= mac_4_psum_out;
		K_matrix[5][GEMM_count_x] <= mac_5_psum_out;
		K_matrix[6][GEMM_count_x] <= mac_6_psum_out;
		K_matrix[7][GEMM_count_x] <= mac_7_psum_out;
	end
end


reg  signed [7:0]  mac_8_0_in_1_a, mac_8_0_in_2_a, mac_8_0_in_3_a, mac_8_0_in_4_a, mac_8_0_in_5_a, mac_8_0_in_6_a, mac_8_0_in_7_a, mac_8_0_in_8_a;
reg  signed [7:0]  mac_8_0_in_1_b, mac_8_0_in_2_b, mac_8_0_in_3_b, mac_8_0_in_4_b, mac_8_0_in_5_b, mac_8_0_in_6_b, mac_8_0_in_7_b, mac_8_0_in_8_b;
reg  signed [7:0]  mac_8_1_in_1_a, mac_8_1_in_2_a, mac_8_1_in_3_a, mac_8_1_in_4_a, mac_8_1_in_5_a, mac_8_1_in_6_a, mac_8_1_in_7_a, mac_8_1_in_8_a;
reg  signed [7:0]  mac_8_1_in_1_b, mac_8_1_in_2_b, mac_8_1_in_3_b, mac_8_1_in_4_b, mac_8_1_in_5_b, mac_8_1_in_6_b, mac_8_1_in_7_b, mac_8_1_in_8_b;
reg  signed [7:0]  mac_8_2_in_1_a, mac_8_2_in_2_a, mac_8_2_in_3_a, mac_8_2_in_4_a, mac_8_2_in_5_a, mac_8_2_in_6_a, mac_8_2_in_7_a, mac_8_2_in_8_a;
reg  signed [7:0]  mac_8_2_in_1_b, mac_8_2_in_2_b, mac_8_2_in_3_b, mac_8_2_in_4_b, mac_8_2_in_5_b, mac_8_2_in_6_b, mac_8_2_in_7_b, mac_8_2_in_8_b;
reg  signed [7:0]  mac_8_3_in_1_a, mac_8_3_in_2_a, mac_8_3_in_3_a, mac_8_3_in_4_a, mac_8_3_in_5_a, mac_8_3_in_6_a, mac_8_3_in_7_a, mac_8_3_in_8_a;
reg  signed [7:0]  mac_8_3_in_1_b, mac_8_3_in_2_b, mac_8_3_in_3_b, mac_8_3_in_4_b, mac_8_3_in_5_b, mac_8_3_in_6_b, mac_8_3_in_7_b, mac_8_3_in_8_b;
reg  signed [7:0]  mac_8_4_in_1_a, mac_8_4_in_2_a, mac_8_4_in_3_a, mac_8_4_in_4_a, mac_8_4_in_5_a, mac_8_4_in_6_a, mac_8_4_in_7_a, mac_8_4_in_8_a;
reg  signed [7:0]  mac_8_4_in_1_b, mac_8_4_in_2_b, mac_8_4_in_3_b, mac_8_4_in_4_b, mac_8_4_in_5_b, mac_8_4_in_6_b, mac_8_4_in_7_b, mac_8_4_in_8_b;
reg  signed [7:0]  mac_8_5_in_1_a, mac_8_5_in_2_a, mac_8_5_in_3_a, mac_8_5_in_4_a, mac_8_5_in_5_a, mac_8_5_in_6_a, mac_8_5_in_7_a, mac_8_5_in_8_a;
reg  signed [7:0]  mac_8_5_in_1_b, mac_8_5_in_2_b, mac_8_5_in_3_b, mac_8_5_in_4_b, mac_8_5_in_5_b, mac_8_5_in_6_b, mac_8_5_in_7_b, mac_8_5_in_8_b;
reg  signed [7:0]  mac_8_6_in_1_a, mac_8_6_in_2_a, mac_8_6_in_3_a, mac_8_6_in_4_a, mac_8_6_in_5_a, mac_8_6_in_6_a, mac_8_6_in_7_a, mac_8_6_in_8_a;
reg  signed [7:0]  mac_8_6_in_1_b, mac_8_6_in_2_b, mac_8_6_in_3_b, mac_8_6_in_4_b, mac_8_6_in_5_b, mac_8_6_in_6_b, mac_8_6_in_7_b, mac_8_6_in_8_b;
reg  signed [7:0]  mac_8_7_in_1_a, mac_8_7_in_2_a, mac_8_7_in_3_a, mac_8_7_in_4_a, mac_8_7_in_5_a, mac_8_7_in_6_a, mac_8_7_in_7_a, mac_8_7_in_8_a;
reg  signed [7:0]  mac_8_7_in_1_b, mac_8_7_in_2_b, mac_8_7_in_3_b, mac_8_7_in_4_b, mac_8_7_in_5_b, mac_8_7_in_6_b, mac_8_7_in_7_b, mac_8_7_in_8_b;
wire signed [18:0] mac_8_0_out, mac_8_1_out, mac_8_2_out, mac_8_3_out, mac_8_4_out, mac_8_5_out, mac_8_6_out, mac_8_7_out;

MAC_8 MAC_8_inst_0 (
    .in_1_a(mac_8_0_in_1_a), .in_2_a(mac_8_0_in_2_a), .in_3_a(mac_8_0_in_3_a), .in_4_a(mac_8_0_in_4_a), .in_5_a(mac_8_0_in_5_a), .in_6_a(mac_8_0_in_6_a), .in_7_a(mac_8_0_in_7_a), .in_8_a(mac_8_0_in_8_a),
    .in_1_b(mac_8_0_in_1_b), .in_2_b(mac_8_0_in_2_b), .in_3_b(mac_8_0_in_3_b), .in_4_b(mac_8_0_in_4_b), .in_5_b(mac_8_0_in_5_b), .in_6_b(mac_8_0_in_6_b), .in_7_b(mac_8_0_in_7_b), .in_8_b(mac_8_0_in_8_b),
    .result(mac_8_0_out));
MAC_8 MAC_8_inst_1 (
    .in_1_a(mac_8_1_in_1_a), .in_2_a(mac_8_1_in_2_a), .in_3_a(mac_8_1_in_3_a), .in_4_a(mac_8_1_in_4_a), .in_5_a(mac_8_1_in_5_a), .in_6_a(mac_8_1_in_6_a), .in_7_a(mac_8_1_in_7_a), .in_8_a(mac_8_1_in_8_a),
    .in_1_b(mac_8_1_in_1_b), .in_2_b(mac_8_1_in_2_b), .in_3_b(mac_8_1_in_3_b), .in_4_b(mac_8_1_in_4_b), .in_5_b(mac_8_1_in_5_b), .in_6_b(mac_8_1_in_6_b), .in_7_b(mac_8_1_in_7_b), .in_8_b(mac_8_1_in_8_b),
    .result(mac_8_1_out));
MAC_8 MAC_8_inst_2 (
    .in_1_a(mac_8_2_in_1_a), .in_2_a(mac_8_2_in_2_a), .in_3_a(mac_8_2_in_3_a), .in_4_a(mac_8_2_in_4_a), .in_5_a(mac_8_2_in_5_a), .in_6_a(mac_8_2_in_6_a), .in_7_a(mac_8_2_in_7_a), .in_8_a(mac_8_2_in_8_a),
    .in_1_b(mac_8_2_in_1_b), .in_2_b(mac_8_2_in_2_b), .in_3_b(mac_8_2_in_3_b), .in_4_b(mac_8_2_in_4_b), .in_5_b(mac_8_2_in_5_b), .in_6_b(mac_8_2_in_6_b), .in_7_b(mac_8_2_in_7_b), .in_8_b(mac_8_2_in_8_b),
    .result(mac_8_2_out));
MAC_8 MAC_8_inst_3 (
    .in_1_a(mac_8_3_in_1_a), .in_2_a(mac_8_3_in_2_a), .in_3_a(mac_8_3_in_3_a), .in_4_a(mac_8_3_in_4_a), .in_5_a(mac_8_3_in_5_a), .in_6_a(mac_8_3_in_6_a), .in_7_a(mac_8_3_in_7_a), .in_8_a(mac_8_3_in_8_a),
    .in_1_b(mac_8_3_in_1_b), .in_2_b(mac_8_3_in_2_b), .in_3_b(mac_8_3_in_3_b), .in_4_b(mac_8_3_in_4_b), .in_5_b(mac_8_3_in_5_b), .in_6_b(mac_8_3_in_6_b), .in_7_b(mac_8_3_in_7_b), .in_8_b(mac_8_3_in_8_b),
    .result(mac_8_3_out));
MAC_8 MAC_8_inst_4 (
    .in_1_a(mac_8_4_in_1_a), .in_2_a(mac_8_4_in_2_a), .in_3_a(mac_8_4_in_3_a), .in_4_a(mac_8_4_in_4_a), .in_5_a(mac_8_4_in_5_a), .in_6_a(mac_8_4_in_6_a), .in_7_a(mac_8_4_in_7_a), .in_8_a(mac_8_4_in_8_a),
    .in_1_b(mac_8_4_in_1_b), .in_2_b(mac_8_4_in_2_b), .in_3_b(mac_8_4_in_3_b), .in_4_b(mac_8_4_in_4_b), .in_5_b(mac_8_4_in_5_b), .in_6_b(mac_8_4_in_6_b), .in_7_b(mac_8_4_in_7_b), .in_8_b(mac_8_4_in_8_b),
    .result(mac_8_4_out));
MAC_8 MAC_8_inst_5 (
    .in_1_a(mac_8_5_in_1_a), .in_2_a(mac_8_5_in_2_a), .in_3_a(mac_8_5_in_3_a), .in_4_a(mac_8_5_in_4_a), .in_5_a(mac_8_5_in_5_a), .in_6_a(mac_8_5_in_6_a), .in_7_a(mac_8_5_in_7_a), .in_8_a(mac_8_5_in_8_a),
    .in_1_b(mac_8_5_in_1_b), .in_2_b(mac_8_5_in_2_b), .in_3_b(mac_8_5_in_3_b), .in_4_b(mac_8_5_in_4_b), .in_5_b(mac_8_5_in_5_b), .in_6_b(mac_8_5_in_6_b), .in_7_b(mac_8_5_in_7_b), .in_8_b(mac_8_5_in_8_b),
    .result(mac_8_5_out));
MAC_8 MAC_8_inst_6 (
    .in_1_a(mac_8_6_in_1_a), .in_2_a(mac_8_6_in_2_a), .in_3_a(mac_8_6_in_3_a), .in_4_a(mac_8_6_in_4_a), .in_5_a(mac_8_6_in_5_a), .in_6_a(mac_8_6_in_6_a), .in_7_a(mac_8_6_in_7_a), .in_8_a(mac_8_6_in_8_a),
    .in_1_b(mac_8_6_in_1_b), .in_2_b(mac_8_6_in_2_b), .in_3_b(mac_8_6_in_3_b), .in_4_b(mac_8_6_in_4_b), .in_5_b(mac_8_6_in_5_b), .in_6_b(mac_8_6_in_6_b), .in_7_b(mac_8_6_in_7_b), .in_8_b(mac_8_6_in_8_b),
    .result(mac_8_6_out));
MAC_8 MAC_8_inst_7 (
    .in_1_a(mac_8_7_in_1_a), .in_2_a(mac_8_7_in_2_a), .in_3_a(mac_8_7_in_3_a), .in_4_a(mac_8_7_in_4_a), .in_5_a(mac_8_7_in_5_a), .in_6_a(mac_8_7_in_6_a), .in_7_a(mac_8_7_in_7_a), .in_8_a(mac_8_7_in_8_a),
    .in_1_b(mac_8_7_in_1_b), .in_2_b(mac_8_7_in_2_b), .in_3_b(mac_8_7_in_3_b), .in_4_b(mac_8_7_in_4_b), .in_5_b(mac_8_7_in_5_b), .in_6_b(mac_8_7_in_6_b), .in_7_b(mac_8_7_in_7_b), .in_8_b(mac_8_7_in_8_b),
    .result(mac_8_7_out));


always @(*) begin
	if (GEMM_count_channel == 'd3 && GEMM_count_y == 'd0) begin
		mac_8_0_in_1_a = in_data_reg[0][0];
		mac_8_0_in_2_a = in_data_reg[0][1];
		mac_8_0_in_3_a = in_data_reg[0][2];
		mac_8_0_in_4_a = in_data_reg[0][3];
		mac_8_0_in_5_a = in_data_reg[0][4];
		mac_8_0_in_6_a = in_data_reg[0][5];
		mac_8_0_in_7_a = in_data_reg[0][6];
		mac_8_0_in_8_a = in_data_reg[0][7];
		mac_8_1_in_1_a = in_data_reg[1][0];
		mac_8_1_in_2_a = in_data_reg[1][1];
		mac_8_1_in_3_a = in_data_reg[1][2];
		mac_8_1_in_4_a = in_data_reg[1][3];
		mac_8_1_in_5_a = in_data_reg[1][4];
		mac_8_1_in_6_a = in_data_reg[1][5];
		mac_8_1_in_7_a = in_data_reg[1][6];
		mac_8_1_in_8_a = in_data_reg[1][7];
		mac_8_2_in_1_a = in_data_reg[2][0];
		mac_8_2_in_2_a = in_data_reg[2][1];
		mac_8_2_in_3_a = in_data_reg[2][2];
		mac_8_2_in_4_a = in_data_reg[2][3];
		mac_8_2_in_5_a = in_data_reg[2][4];
		mac_8_2_in_6_a = in_data_reg[2][5];
		mac_8_2_in_7_a = in_data_reg[2][6];
		mac_8_2_in_8_a = in_data_reg[2][7];
		mac_8_3_in_1_a = in_data_reg[3][0];
		mac_8_3_in_2_a = in_data_reg[3][1];
		mac_8_3_in_3_a = in_data_reg[3][2];
		mac_8_3_in_4_a = in_data_reg[3][3];
		mac_8_3_in_5_a = in_data_reg[3][4];
		mac_8_3_in_6_a = in_data_reg[3][5];
		mac_8_3_in_7_a = in_data_reg[3][6];
		mac_8_3_in_8_a = in_data_reg[3][7];
		mac_8_4_in_1_a = in_data_reg[4][0];
		mac_8_4_in_2_a = in_data_reg[4][1];
		mac_8_4_in_3_a = in_data_reg[4][2];
		mac_8_4_in_4_a = in_data_reg[4][3];
		mac_8_4_in_5_a = in_data_reg[4][4];
		mac_8_4_in_6_a = in_data_reg[4][5];
		mac_8_4_in_7_a = in_data_reg[4][6];
		mac_8_4_in_8_a = in_data_reg[4][7];
		mac_8_5_in_1_a = in_data_reg[5][0];
		mac_8_5_in_2_a = in_data_reg[5][1];
		mac_8_5_in_3_a = in_data_reg[5][2];
		mac_8_5_in_4_a = in_data_reg[5][3];
		mac_8_5_in_5_a = in_data_reg[5][4];
		mac_8_5_in_6_a = in_data_reg[5][5];
		mac_8_5_in_7_a = in_data_reg[5][6];
		mac_8_5_in_8_a = in_data_reg[5][7];
		mac_8_6_in_1_a = in_data_reg[6][0];
		mac_8_6_in_2_a = in_data_reg[6][1];
		mac_8_6_in_3_a = in_data_reg[6][2];
		mac_8_6_in_4_a = in_data_reg[6][3];
		mac_8_6_in_5_a = in_data_reg[6][4];
		mac_8_6_in_6_a = in_data_reg[6][5];
		mac_8_6_in_7_a = in_data_reg[6][6];
		mac_8_6_in_8_a = in_data_reg[6][7];
		mac_8_7_in_1_a = in_data_reg[7][0];
		mac_8_7_in_2_a = in_data_reg[7][1];
		mac_8_7_in_3_a = in_data_reg[7][2];
		mac_8_7_in_4_a = in_data_reg[7][3];
		mac_8_7_in_5_a = in_data_reg[7][4];
		mac_8_7_in_6_a = in_data_reg[7][5];
		mac_8_7_in_7_a = in_data_reg[7][6];
		mac_8_7_in_8_a = in_data_reg[7][7];

		mac_8_0_in_1_b = weight_reg[0][GEMM_count_x];
		mac_8_0_in_2_b = weight_reg[1][GEMM_count_x];
		mac_8_0_in_3_b = weight_reg[2][GEMM_count_x];
		mac_8_0_in_4_b = weight_reg[3][GEMM_count_x];
		mac_8_0_in_5_b = weight_reg[4][GEMM_count_x];
		mac_8_0_in_6_b = weight_reg[5][GEMM_count_x];
		mac_8_0_in_7_b = weight_reg[6][GEMM_count_x];
		mac_8_0_in_8_b = weight_reg[7][GEMM_count_x];
		mac_8_1_in_1_b = weight_reg[0][GEMM_count_x];
		mac_8_1_in_2_b = weight_reg[1][GEMM_count_x];
		mac_8_1_in_3_b = weight_reg[2][GEMM_count_x];
		mac_8_1_in_4_b = weight_reg[3][GEMM_count_x];
		mac_8_1_in_5_b = weight_reg[4][GEMM_count_x];
		mac_8_1_in_6_b = weight_reg[5][GEMM_count_x];
		mac_8_1_in_7_b = weight_reg[6][GEMM_count_x];
		mac_8_1_in_8_b = weight_reg[7][GEMM_count_x];
		mac_8_2_in_1_b = weight_reg[0][GEMM_count_x];
		mac_8_2_in_2_b = weight_reg[1][GEMM_count_x];
		mac_8_2_in_3_b = weight_reg[2][GEMM_count_x];
		mac_8_2_in_4_b = weight_reg[3][GEMM_count_x];
		mac_8_2_in_5_b = weight_reg[4][GEMM_count_x];
		mac_8_2_in_6_b = weight_reg[5][GEMM_count_x];
		mac_8_2_in_7_b = weight_reg[6][GEMM_count_x];
		mac_8_2_in_8_b = weight_reg[7][GEMM_count_x];
		mac_8_3_in_1_b = weight_reg[0][GEMM_count_x];
		mac_8_3_in_2_b = weight_reg[1][GEMM_count_x];
		mac_8_3_in_3_b = weight_reg[2][GEMM_count_x];
		mac_8_3_in_4_b = weight_reg[3][GEMM_count_x];
		mac_8_3_in_5_b = weight_reg[4][GEMM_count_x];
		mac_8_3_in_6_b = weight_reg[5][GEMM_count_x];
		mac_8_3_in_7_b = weight_reg[6][GEMM_count_x];
		mac_8_3_in_8_b = weight_reg[7][GEMM_count_x];
		mac_8_4_in_1_b = weight_reg[0][GEMM_count_x];
		mac_8_4_in_2_b = weight_reg[1][GEMM_count_x];
		mac_8_4_in_3_b = weight_reg[2][GEMM_count_x];
		mac_8_4_in_4_b = weight_reg[3][GEMM_count_x];
		mac_8_4_in_5_b = weight_reg[4][GEMM_count_x];
		mac_8_4_in_6_b = weight_reg[5][GEMM_count_x];
		mac_8_4_in_7_b = weight_reg[6][GEMM_count_x];
		mac_8_4_in_8_b = weight_reg[7][GEMM_count_x];
		mac_8_5_in_1_b = weight_reg[0][GEMM_count_x];
		mac_8_5_in_2_b = weight_reg[1][GEMM_count_x];
		mac_8_5_in_3_b = weight_reg[2][GEMM_count_x];
		mac_8_5_in_4_b = weight_reg[3][GEMM_count_x];
		mac_8_5_in_5_b = weight_reg[4][GEMM_count_x];
		mac_8_5_in_6_b = weight_reg[5][GEMM_count_x];
		mac_8_5_in_7_b = weight_reg[6][GEMM_count_x];
		mac_8_5_in_8_b = weight_reg[7][GEMM_count_x];
		mac_8_6_in_1_b = weight_reg[0][GEMM_count_x];
		mac_8_6_in_2_b = weight_reg[1][GEMM_count_x];
		mac_8_6_in_3_b = weight_reg[2][GEMM_count_x];
		mac_8_6_in_4_b = weight_reg[3][GEMM_count_x];
		mac_8_6_in_5_b = weight_reg[4][GEMM_count_x];
		mac_8_6_in_6_b = weight_reg[5][GEMM_count_x];
		mac_8_6_in_7_b = weight_reg[6][GEMM_count_x];
		mac_8_6_in_8_b = weight_reg[7][GEMM_count_x];
		mac_8_7_in_1_b = weight_reg[0][GEMM_count_x];
		mac_8_7_in_2_b = weight_reg[1][GEMM_count_x];
		mac_8_7_in_3_b = weight_reg[2][GEMM_count_x];
		mac_8_7_in_4_b = weight_reg[3][GEMM_count_x];
		mac_8_7_in_5_b = weight_reg[4][GEMM_count_x];
		mac_8_7_in_6_b = weight_reg[5][GEMM_count_x];
		mac_8_7_in_7_b = weight_reg[6][GEMM_count_x];
		mac_8_7_in_8_b = weight_reg[7][GEMM_count_x];
	end
	else begin
		mac_8_0_in_1_a = 'd0;
		mac_8_0_in_2_a = 'd0;
		mac_8_0_in_3_a = 'd0;
		mac_8_0_in_4_a = 'd0;
		mac_8_0_in_5_a = 'd0;
		mac_8_0_in_6_a = 'd0;
		mac_8_0_in_7_a = 'd0;
		mac_8_0_in_8_a = 'd0;
		mac_8_1_in_1_a = 'd0;
		mac_8_1_in_2_a = 'd0;
		mac_8_1_in_3_a = 'd0;
		mac_8_1_in_4_a = 'd0;
		mac_8_1_in_5_a = 'd0;
		mac_8_1_in_6_a = 'd0;
		mac_8_1_in_7_a = 'd0;
		mac_8_1_in_8_a = 'd0;
		mac_8_2_in_1_a = 'd0;
		mac_8_2_in_2_a = 'd0;
		mac_8_2_in_3_a = 'd0;
		mac_8_2_in_4_a = 'd0;
		mac_8_2_in_5_a = 'd0;
		mac_8_2_in_6_a = 'd0;
		mac_8_2_in_7_a = 'd0;
		mac_8_2_in_8_a = 'd0;
		mac_8_3_in_1_a = 'd0;
		mac_8_3_in_2_a = 'd0;
		mac_8_3_in_3_a = 'd0;
		mac_8_3_in_4_a = 'd0;
		mac_8_3_in_5_a = 'd0;
		mac_8_3_in_6_a = 'd0;
		mac_8_3_in_7_a = 'd0;
		mac_8_3_in_8_a = 'd0;
		mac_8_4_in_1_a = 'd0;
		mac_8_4_in_2_a = 'd0;
		mac_8_4_in_3_a = 'd0;
		mac_8_4_in_4_a = 'd0;
		mac_8_4_in_5_a = 'd0;
		mac_8_4_in_6_a = 'd0;
		mac_8_4_in_7_a = 'd0;
		mac_8_4_in_8_a = 'd0;
		mac_8_5_in_1_a = 'd0;
		mac_8_5_in_2_a = 'd0;
		mac_8_5_in_3_a = 'd0;
		mac_8_5_in_4_a = 'd0;
		mac_8_5_in_5_a = 'd0;
		mac_8_5_in_6_a = 'd0;
		mac_8_5_in_7_a = 'd0;
		mac_8_5_in_8_a = 'd0;
		mac_8_6_in_1_a = 'd0;
		mac_8_6_in_2_a = 'd0;
		mac_8_6_in_3_a = 'd0;
		mac_8_6_in_4_a = 'd0;
		mac_8_6_in_5_a = 'd0;
		mac_8_6_in_6_a = 'd0;
		mac_8_6_in_7_a = 'd0;
		mac_8_6_in_8_a = 'd0;
		mac_8_7_in_1_a = 'd0;
		mac_8_7_in_2_a = 'd0;
		mac_8_7_in_3_a = 'd0;
		mac_8_7_in_4_a = 'd0;
		mac_8_7_in_5_a = 'd0;
		mac_8_7_in_6_a = 'd0;
		mac_8_7_in_7_a = 'd0;
		mac_8_7_in_8_a = 'd0;

		mac_8_0_in_1_b = 'd0;
		mac_8_0_in_2_b = 'd0;
		mac_8_0_in_3_b = 'd0;
		mac_8_0_in_4_b = 'd0;
		mac_8_0_in_5_b = 'd0;
		mac_8_0_in_6_b = 'd0;
		mac_8_0_in_7_b = 'd0;
		mac_8_0_in_8_b = 'd0;
		mac_8_1_in_1_b = 'd0;
		mac_8_1_in_2_b = 'd0;
		mac_8_1_in_3_b = 'd0;
		mac_8_1_in_4_b = 'd0;
		mac_8_1_in_5_b = 'd0;
		mac_8_1_in_6_b = 'd0;
		mac_8_1_in_7_b = 'd0;
		mac_8_1_in_8_b = 'd0;
		mac_8_2_in_1_b = 'd0;
		mac_8_2_in_2_b = 'd0;
		mac_8_2_in_3_b = 'd0;
		mac_8_2_in_4_b = 'd0;
		mac_8_2_in_5_b = 'd0;
		mac_8_2_in_6_b = 'd0;
		mac_8_2_in_7_b = 'd0;
		mac_8_2_in_8_b = 'd0;
		mac_8_3_in_1_b = 'd0;
		mac_8_3_in_2_b = 'd0;
		mac_8_3_in_3_b = 'd0;
		mac_8_3_in_4_b = 'd0;
		mac_8_3_in_5_b = 'd0;
		mac_8_3_in_6_b = 'd0;
		mac_8_3_in_7_b = 'd0;
		mac_8_3_in_8_b = 'd0;
		mac_8_4_in_1_b = 'd0;
		mac_8_4_in_2_b = 'd0;
		mac_8_4_in_3_b = 'd0;
		mac_8_4_in_4_b = 'd0;
		mac_8_4_in_5_b = 'd0;
		mac_8_4_in_6_b = 'd0;
		mac_8_4_in_7_b = 'd0;
		mac_8_4_in_8_b = 'd0;
		mac_8_5_in_1_b = 'd0;
		mac_8_5_in_2_b = 'd0;
		mac_8_5_in_3_b = 'd0;
		mac_8_5_in_4_b = 'd0;
		mac_8_5_in_5_b = 'd0;
		mac_8_5_in_6_b = 'd0;
		mac_8_5_in_7_b = 'd0;
		mac_8_5_in_8_b = 'd0;
		mac_8_6_in_1_b = 'd0;
		mac_8_6_in_2_b = 'd0;
		mac_8_6_in_3_b = 'd0;
		mac_8_6_in_4_b = 'd0;
		mac_8_6_in_5_b = 'd0;
		mac_8_6_in_6_b = 'd0;
		mac_8_6_in_7_b = 'd0;
		mac_8_6_in_8_b = 'd0;
		mac_8_7_in_1_b = 'd0;
		mac_8_7_in_2_b = 'd0;
		mac_8_7_in_3_b = 'd0;
		mac_8_7_in_4_b = 'd0;
		mac_8_7_in_5_b = 'd0;
		mac_8_7_in_6_b = 'd0;
		mac_8_7_in_7_b = 'd0;
		mac_8_7_in_8_b = 'd0;
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
	else if(GEMM_count_channel == 'd3 & GEMM_count_y == 'd0) begin
		V_matrix[0][GEMM_count_x] <= mac_8_0_out;
		V_matrix[1][GEMM_count_x] <= mac_8_1_out;
		V_matrix[2][GEMM_count_x] <= mac_8_2_out;
		V_matrix[3][GEMM_count_x] <= mac_8_3_out;
		V_matrix[4][GEMM_count_x] <= mac_8_4_out;
		V_matrix[5][GEMM_count_x] <= mac_8_5_out;
		V_matrix[6][GEMM_count_x] <= mac_8_6_out;
		V_matrix[7][GEMM_count_x] <= mac_8_7_out;
	end
end


always @(*) begin
	case(QK_count_channel)
		'd1 : begin
			mac_19_0_in_1 = Q_matrix[QK_count_y][QK_count_x];
			mac_19_1_in_1 = Q_matrix[QK_count_y][QK_count_x];
			mac_19_2_in_1 = Q_matrix[QK_count_y][QK_count_x];
			mac_19_3_in_1 = Q_matrix[QK_count_y][QK_count_x];
			mac_19_4_in_1 = Q_matrix[QK_count_y][QK_count_x];
			mac_19_5_in_1 = Q_matrix[QK_count_y][QK_count_x];
			mac_19_6_in_1 = Q_matrix[QK_count_y][QK_count_x];
			mac_19_7_in_1 = Q_matrix[QK_count_y][QK_count_x];
			mac_19_0_in_2 = K_matrix[0][QK_count_x];
			mac_19_1_in_2 = K_matrix[1][QK_count_x];
			mac_19_2_in_2 = K_matrix[2][QK_count_x];
			mac_19_3_in_2 = K_matrix[3][QK_count_x];
			mac_19_4_in_2 = K_matrix[4][QK_count_x];
			mac_19_5_in_2 = K_matrix[5][QK_count_x];
			mac_19_6_in_2 = K_matrix[6][QK_count_x];
			mac_19_7_in_2 = K_matrix[7][QK_count_x];
			mac_19_0_psum_in = QK_matrix[QK_count_y][0];
			mac_19_1_psum_in = QK_matrix[QK_count_y][1];
			mac_19_2_psum_in = QK_matrix[QK_count_y][2];
			mac_19_3_psum_in = QK_matrix[QK_count_y][3];
			mac_19_4_psum_in = QK_matrix[QK_count_y][4];
			mac_19_5_psum_in = QK_matrix[QK_count_y][5];
			mac_19_6_psum_in = QK_matrix[QK_count_y][6];
			mac_19_7_psum_in = QK_matrix[QK_count_y][7];
		end
		default : begin
			mac_19_0_in_1 = 'd0;
			mac_19_1_in_1 = 'd0;
			mac_19_2_in_1 = 'd0;
			mac_19_3_in_1 = 'd0;
			mac_19_4_in_1 = 'd0;
			mac_19_5_in_1 = 'd0;
			mac_19_6_in_1 = 'd0;
			mac_19_7_in_1 = 'd0;
			mac_19_0_in_2 = 'd0;
			mac_19_1_in_2 = 'd0;
			mac_19_2_in_2 = 'd0;
			mac_19_3_in_2 = 'd0;
			mac_19_4_in_2 = 'd0;
			mac_19_5_in_2 = 'd0;
			mac_19_6_in_2 = 'd0;
			mac_19_7_in_2 = 'd0;
			mac_19_0_psum_in = 'd0;
			mac_19_1_psum_in = 'd0;
			mac_19_2_psum_in = 'd0;
			mac_19_3_psum_in = 'd0;
			mac_19_4_psum_in = 'd0;
			mac_19_5_psum_in = 'd0;
			mac_19_6_psum_in = 'd0;
			mac_19_7_psum_in = 'd0;
		end
	endcase
end

// Q * K
wire signed [40:0] QK_result [0:7];
assign QK_result[0] = mac_19_0_psum_out;
assign QK_result[1] = mac_19_1_psum_out;
assign QK_result[2] = mac_19_2_psum_out;
assign QK_result[3] = mac_19_3_psum_out;
assign QK_result[4] = mac_19_4_psum_out;
assign QK_result[5] = mac_19_5_psum_out;
assign QK_result[6] = mac_19_6_psum_out;
assign QK_result[7] = mac_19_7_psum_out;

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
	else if(QK_count_channel == 'd1) begin
		QK_matrix[QK_count_y][0] <= (QK_count_x == 'd7) ? (QK_result[0][40] ? 'd0 : (QK_result[0] / 'd3)) : QK_result[0];
		QK_matrix[QK_count_y][1] <= (QK_count_x == 'd7) ? (QK_result[1][40] ? 'd0 : (QK_result[1] / 'd3)) : QK_result[1];
		QK_matrix[QK_count_y][2] <= (QK_count_x == 'd7) ? (QK_result[2][40] ? 'd0 : (QK_result[2] / 'd3)) : QK_result[2];
		QK_matrix[QK_count_y][3] <= (QK_count_x == 'd7) ? (QK_result[3][40] ? 'd0 : (QK_result[3] / 'd3)) : QK_result[3];
		QK_matrix[QK_count_y][4] <= (QK_count_x == 'd7) ? (QK_result[4][40] ? 'd0 : (QK_result[4] / 'd3)) : QK_result[4];
		QK_matrix[QK_count_y][5] <= (QK_count_x == 'd7) ? (QK_result[5][40] ? 'd0 : (QK_result[5] / 'd3)) : QK_result[5];
		QK_matrix[QK_count_y][6] <= (QK_count_x == 'd7) ? (QK_result[6][40] ? 'd0 : (QK_result[6] / 'd3)) : QK_result[6];
		QK_matrix[QK_count_y][7] <= (QK_count_x == 'd7) ? (QK_result[7][40] ? 'd0 : (QK_result[7] / 'd3)) : QK_result[7];
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

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		out_count_x <= 'd0;
	end
	else if(state == DOUT | state == WAIT) begin
		out_count_x <= (out_count_x == 'd7) ? 'd0 : (out_count_x + 'd1);
	end
	else if(state == IDLE) begin
		out_count_x <= 'd0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		out_count_y <= 'd0;
	end
	else if(out_count_x == 'd7) begin
		out_count_y <= (out_count_y == 'd7) ? 'd0 : (out_count_y + 'd1);
	end
	else if(state == IDLE) begin
		out_count_y <= 'd0;
	end
end


reg  signed [40:0] mult_0_in_1, mult_1_in_1, mult_2_in_1, mult_3_in_1, mult_4_in_1, mult_5_in_1, mult_6_in_1, mult_7_in_1;
reg  signed [18:0] mult_0_in_2, mult_1_in_2, mult_2_in_2, mult_3_in_2, mult_4_in_2, mult_5_in_2, mult_6_in_2, mult_7_in_2;
wire signed [59:0] mult_0_out, mult_1_out, mult_2_out, mult_3_out, mult_4_out, mult_5_out, mult_6_out, mult_7_out;

mult_41x19 mult_41x19_inst_0 (.in_1(mult_0_in_1), .in_2(mult_0_in_2), .product(mult_0_out));
mult_41x19 mult_41x19_inst_1 (.in_1(mult_1_in_1), .in_2(mult_1_in_2), .product(mult_1_out));
mult_41x19 mult_41x19_inst_2 (.in_1(mult_2_in_1), .in_2(mult_2_in_2), .product(mult_2_out));
mult_41x19 mult_41x19_inst_3 (.in_1(mult_3_in_1), .in_2(mult_3_in_2), .product(mult_3_out));
mult_41x19 mult_41x19_inst_4 (.in_1(mult_4_in_1), .in_2(mult_4_in_2), .product(mult_4_out));
mult_41x19 mult_41x19_inst_5 (.in_1(mult_5_in_1), .in_2(mult_5_in_2), .product(mult_5_out));
mult_41x19 mult_41x19_inst_6 (.in_1(mult_6_in_1), .in_2(mult_6_in_2), .product(mult_6_out));
mult_41x19 mult_41x19_inst_7 (.in_1(mult_7_in_1), .in_2(mult_7_in_2), .product(mult_7_out));


always @(*) begin
	if (state == WAIT | state == DOUT) begin
		mult_0_in_1 = QK_matrix[out_count_y][0];
		mult_0_in_2 = V_matrix[0][out_count_x];
	end
	else begin
		mult_0_in_1 = 'd0;
		mult_0_in_2 = 'd0;
	end
end

always @(*) begin
	if ((state == WAIT | state == DOUT) & (T_reg != 'd1)) begin
		mult_1_in_1 = QK_matrix[out_count_y][1];
		mult_2_in_1 = QK_matrix[out_count_y][2];
		mult_3_in_1 = QK_matrix[out_count_y][3];
		mult_1_in_2 = V_matrix[1][out_count_x];
		mult_2_in_2 = V_matrix[2][out_count_x];
		mult_3_in_2 = V_matrix[3][out_count_x];
	end
	else begin
		mult_1_in_1 = 'd0;
		mult_2_in_1 = 'd0;
		mult_3_in_1 = 'd0;
		mult_1_in_2 = 'd0;
		mult_2_in_2 = 'd0;
		mult_3_in_2 = 'd0;
	end
end

always @(*) begin
	if ((state == WAIT | state == DOUT) & (T_reg != 'd1) & (T_reg != 'd4)) begin
		mult_4_in_1 = QK_matrix[out_count_y][4];
		mult_5_in_1 = QK_matrix[out_count_y][5];
		mult_6_in_1 = QK_matrix[out_count_y][6];
		mult_7_in_1 = QK_matrix[out_count_y][7];
		mult_4_in_2 = V_matrix[4][out_count_x];
		mult_5_in_2 = V_matrix[5][out_count_x];
		mult_6_in_2 = V_matrix[6][out_count_x];
		mult_7_in_2 = V_matrix[7][out_count_x];
	end
	else begin
		mult_4_in_1 = 'd0;
		mult_5_in_1 = 'd0;
		mult_6_in_1 = 'd0;
		mult_7_in_1 = 'd0;
		mult_4_in_2 = 'd0;
		mult_5_in_2 = 'd0;
		mult_6_in_2 = 'd0;
		mult_7_in_2 = 'd0;
	end
end



always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for(i=0; i<8; i=i+1) begin
			P_reg[i] <= 'd0;
		end
	end
	else if (state == WAIT | state == DOUT) begin
		P_reg[0] <= mult_0_out;
		P_reg[1] <= mult_1_out;
		P_reg[2] <= mult_2_out;
		P_reg[3] <= mult_3_out;
		P_reg[4] <= mult_4_out;
		P_reg[5] <= mult_5_out;
		P_reg[6] <= mult_6_out;
		P_reg[7] <= mult_7_out;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		out_reg <= 'd0;
	end
	else begin
		out_reg <= (T_reg == 'd8) ? (P_reg[0] + P_reg[1] + P_reg[2] + P_reg[3] + P_reg[4] + P_reg[5] + P_reg[6] + P_reg[7]) : 
				   (T_reg == 'd4) ? (P_reg[0] + P_reg[1] + P_reg[2] + P_reg[3]) : P_reg[0];
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


module MAC_19(
	input signed [18:0] in_1,
	input signed [18:0] in_2,
	input signed [40:0] psum_in,
	output signed [40:0] psum_out
);

assign psum_out = psum_in + (in_1 * in_2);

endmodule


module mult_41x19 (
	input signed [40:0] in_1,
	input signed [18:0] in_2,
	output signed [59:0] product
);

assign product = in_1 * in_2;

endmodule


module MAC_8 (
	input signed [7:0] in_1_a, in_2_a, in_3_a, in_4_a, in_5_a, in_6_a, in_7_a, in_8_a,
	input signed [7:0] in_1_b, in_2_b, in_3_b, in_4_b, in_5_b, in_6_b, in_7_b, in_8_b,
	output signed [18:0] result
);

assign result = in_1_a * in_1_b + in_2_a * in_2_b + in_3_a * in_3_b + in_4_a * in_4_b + 
				in_5_a * in_5_b + in_6_a * in_6_b + in_7_a * in_7_b + in_8_a * in_8_b;

endmodule


