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

// synopsys translate_off
`ifdef RTL
	`include "GATED_OR.v"
`else
	`include "Netlist/GATED_OR_SYN.v"
`endif
// synopsys translate_on

module SA(
    //Input signals
    clk,
    rst_n,
    cg_en,
    in_valid,
    T,
    in_data,
    w_Q,
    w_K,
    w_V,

    //Output signals
    out_valid,
    out_data
);

input clk;
input rst_n;
input in_valid;
input cg_en;
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

integer i, j;

//==============================================//
//           reg & wire declaration             //
//==============================================//
// state
reg [1:0] state, next_state;


// input regs
reg in_data_done;
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

// clock gating
wire sleep_in_data = in_data_done;
wire sleep_weight  = !in_valid & state != IDLE;
wire sleep_Q  = state != IDLE & GEMM_count_channel != 'd1;
wire sleep_K  = state != IDLE & GEMM_count_channel != 'd2;
wire sleep_V  = state != IDLE & (GEMM_count_channel != 'd3 | GEMM_count_y != 'd0);
wire sleep_QK = state != IDLE & QK_count_channel != 'd1;
wire sleep_P  = state != WAIT & state != DOUT;
wire sleep_out_reg = state != WAIT & state != DOUT;

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
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		in_data_done <= 1'b0;
	end
	else if(in_valid & count_x_done & count_y == T_reg-'d1 & count_channel == 'd0) begin
		in_data_done <= 1'b1;
	end
	else if(state == IDLE) begin
		in_data_done <= 1'b0;
	end
	else begin
		in_data_done <= in_data_done;
	end
end

genvar in_VAR_Y, in_VAR_X;
wire CLK_in_data [0:7][0:7];
generate
for(in_VAR_Y=0; in_VAR_Y<8; in_VAR_Y=in_VAR_Y+1) begin
	for(in_VAR_X=0; in_VAR_X<8; in_VAR_X=in_VAR_X+1) begin
		GATED_OR GATED_in_data (.CLOCK(clk), .SLEEP_CTRL(cg_en & sleep_in_data),.RST_N(rst_n), .CLOCK_GATED(CLK_in_data[in_VAR_Y][in_VAR_X]));
		always @(posedge CLK_in_data[in_VAR_Y][in_VAR_X]) begin
			if(!in_data_done) begin
				if(in_VAR_Y == count_y & in_VAR_X == count_x) in_data_reg[in_VAR_Y][in_VAR_X] <= in_data;
			end
			else begin
				if(in_VAR_Y == count_y & in_VAR_X == count_x) in_data_reg[in_VAR_Y][in_VAR_X] <= in_data_reg[in_VAR_Y][in_VAR_X];
			end
		end
	end
end
endgenerate

genvar w_VAR_Y, w_VAR_X;
wire CLK_weight [0:7][0:7];
generate
for(w_VAR_Y=0; w_VAR_Y<8; w_VAR_Y=w_VAR_Y+1) begin
	for(w_VAR_X=0; w_VAR_X<8; w_VAR_X=w_VAR_X+1) begin
		GATED_OR GATED_weight (.CLOCK(clk), .SLEEP_CTRL(cg_en & sleep_weight),.RST_N(rst_n), .CLOCK_GATED(CLK_weight[w_VAR_Y][w_VAR_X]));
		always @(posedge clk or negedge rst_n) begin
			if(!rst_n) begin
				weight_reg[w_VAR_Y][w_VAR_X] <= 'd0;
			end
			else if(in_valid) begin
				case(count_channel)
					'd0 : if(w_VAR_Y == count_y & w_VAR_X == count_x) weight_reg[w_VAR_Y][w_VAR_X] <= w_Q;
					'd1 : if(w_VAR_Y == count_y & w_VAR_X == count_x) weight_reg[w_VAR_Y][w_VAR_X] <= w_K;
					'd2 : if(w_VAR_Y == count_y & w_VAR_X == count_x) weight_reg[w_VAR_Y][w_VAR_X] <= w_V;
					default : weight_reg[w_VAR_Y][w_VAR_X] <= weight_reg[w_VAR_Y][w_VAR_X];
				endcase
			end
			else if(state == IDLE) begin
				weight_reg[w_VAR_Y][w_VAR_X] <= 'd0;
			end
			else begin
				weight_reg[w_VAR_Y][w_VAR_X] <= weight_reg[w_VAR_Y][w_VAR_X];
			end
		end
	end
end
endgenerate

always @(posedge clk) begin
	if(in_valid & state == IDLE) begin
		T_reg <= T;
	end
	else if(state == IDLE) begin
		T_reg <= 'd0;
	end
	else begin
		T_reg <= T_reg;
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


reg  signed [7:0] mac_8b_0_in_1, mac_8b_1_in_1, mac_8b_2_in_1, mac_8b_3_in_1, mac_8b_4_in_1, mac_8b_5_in_1, mac_8b_6_in_1, mac_8b_7_in_1;
reg  signed [7:0] mac_8b_0_in_2, mac_8b_1_in_2, mac_8b_2_in_2, mac_8b_3_in_2, mac_8b_4_in_2, mac_8b_5_in_2, mac_8b_6_in_2, mac_8b_7_in_2;
reg  signed [18:0] mac_8b_0_psum_in, mac_8b_1_psum_in, mac_8b_2_psum_in, mac_8b_3_psum_in, mac_8b_4_psum_in, mac_8b_5_psum_in, mac_8b_6_psum_in, mac_8b_7_psum_in;
wire signed [18:0] mac_8b_0_psum_out, mac_8b_1_psum_out, mac_8b_2_psum_out, mac_8b_3_psum_out, mac_8b_4_psum_out, mac_8b_5_psum_out, mac_8b_6_psum_out, mac_8b_7_psum_out;

reg  signed [18:0] mac_19b_0_in_1, mac_19b_1_in_1, mac_19b_2_in_1, mac_19b_3_in_1, mac_19b_4_in_1, mac_19b_5_in_1, mac_19b_6_in_1, mac_19b_7_in_1;
reg  signed [18:0] mac_19b_0_in_2, mac_19b_1_in_2, mac_19b_2_in_2, mac_19b_3_in_2, mac_19b_4_in_2, mac_19b_5_in_2, mac_19b_6_in_2, mac_19b_7_in_2;
reg  signed [40:0] mac_19b_0_psum_in, mac_19b_1_psum_in, mac_19b_2_psum_in, mac_19b_3_psum_in, mac_19b_4_psum_in, mac_19b_5_psum_in, mac_19b_6_psum_in, mac_19b_7_psum_in;
wire signed [40:0] mac_19b_0_psum_out, mac_19b_1_psum_out, mac_19b_2_psum_out, mac_19b_3_psum_out, mac_19b_4_psum_out, mac_19b_5_psum_out, mac_19b_6_psum_out, mac_19b_7_psum_out;

reg  signed [40:0] mult_0_in_1, mult_1_in_1, mult_2_in_1, mult_3_in_1, mult_4_in_1, mult_5_in_1, mult_6_in_1, mult_7_in_1;
reg  signed [18:0] mult_0_in_2, mult_1_in_2, mult_2_in_2, mult_3_in_2, mult_4_in_2, mult_5_in_2, mult_6_in_2, mult_7_in_2;
wire signed [59:0] mult_0_out, mult_1_out, mult_2_out, mult_3_out, mult_4_out, mult_5_out, mult_6_out, mult_7_out;

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

reg  signed [40:0] relu_div_3_in_0,  relu_div_3_in_1,  relu_div_3_in_2,  relu_div_3_in_3,  relu_div_3_in_4,  relu_div_3_in_5,  relu_div_3_in_6,  relu_div_3_in_7;
wire signed [40:0] relu_div_3_out_0, relu_div_3_out_1, relu_div_3_out_2, relu_div_3_out_3, relu_div_3_out_4, relu_div_3_out_5, relu_div_3_out_6, relu_div_3_out_7;

reg  signed [59:0] add_60_in_0, add_60_in_1, add_60_in_2, add_60_in_3, add_60_in_4, add_60_in_5, add_60_in_6, add_60_in_7;
wire signed [62:0] add_60_out;


// Q * K
wire signed [40:0] QK_result [0:7];
assign QK_result[0] = mac_19b_0_psum_out;
assign QK_result[1] = mac_19b_1_psum_out;
assign QK_result[2] = mac_19b_2_psum_out;
assign QK_result[3] = mac_19b_3_psum_out;
assign QK_result[4] = mac_19b_4_psum_out;
assign QK_result[5] = mac_19b_5_psum_out;
assign QK_result[6] = mac_19b_6_psum_out;
assign QK_result[7] = mac_19b_7_psum_out;

MAC MAC_inst_0 (.in_1(mac_8b_0_in_1), .in_2(mac_8b_0_in_2), .psum_in(mac_8b_0_psum_in), .psum_out(mac_8b_0_psum_out));
MAC MAC_inst_1 (.in_1(mac_8b_1_in_1), .in_2(mac_8b_1_in_2), .psum_in(mac_8b_1_psum_in), .psum_out(mac_8b_1_psum_out));
MAC MAC_inst_2 (.in_1(mac_8b_2_in_1), .in_2(mac_8b_2_in_2), .psum_in(mac_8b_2_psum_in), .psum_out(mac_8b_2_psum_out));
MAC MAC_inst_3 (.in_1(mac_8b_3_in_1), .in_2(mac_8b_3_in_2), .psum_in(mac_8b_3_psum_in), .psum_out(mac_8b_3_psum_out));
MAC MAC_inst_4 (.in_1(mac_8b_4_in_1), .in_2(mac_8b_4_in_2), .psum_in(mac_8b_4_psum_in), .psum_out(mac_8b_4_psum_out));
MAC MAC_inst_5 (.in_1(mac_8b_5_in_1), .in_2(mac_8b_5_in_2), .psum_in(mac_8b_5_psum_in), .psum_out(mac_8b_5_psum_out));
MAC MAC_inst_6 (.in_1(mac_8b_6_in_1), .in_2(mac_8b_6_in_2), .psum_in(mac_8b_6_psum_in), .psum_out(mac_8b_6_psum_out));
MAC MAC_inst_7 (.in_1(mac_8b_7_in_1), .in_2(mac_8b_7_in_2), .psum_in(mac_8b_7_psum_in), .psum_out(mac_8b_7_psum_out));

mac_19b mac_19b_inst_0 (.in_1(mac_19b_0_in_1), .in_2(mac_19b_0_in_2), .psum_in(mac_19b_0_psum_in), .psum_out(mac_19b_0_psum_out));
mac_19b mac_19b_inst_1 (.in_1(mac_19b_1_in_1), .in_2(mac_19b_1_in_2), .psum_in(mac_19b_1_psum_in), .psum_out(mac_19b_1_psum_out));
mac_19b mac_19b_inst_2 (.in_1(mac_19b_2_in_1), .in_2(mac_19b_2_in_2), .psum_in(mac_19b_2_psum_in), .psum_out(mac_19b_2_psum_out));
mac_19b mac_19b_inst_3 (.in_1(mac_19b_3_in_1), .in_2(mac_19b_3_in_2), .psum_in(mac_19b_3_psum_in), .psum_out(mac_19b_3_psum_out));
mac_19b mac_19b_inst_4 (.in_1(mac_19b_4_in_1), .in_2(mac_19b_4_in_2), .psum_in(mac_19b_4_psum_in), .psum_out(mac_19b_4_psum_out));
mac_19b mac_19b_inst_5 (.in_1(mac_19b_5_in_1), .in_2(mac_19b_5_in_2), .psum_in(mac_19b_5_psum_in), .psum_out(mac_19b_5_psum_out));
mac_19b mac_19b_inst_6 (.in_1(mac_19b_6_in_1), .in_2(mac_19b_6_in_2), .psum_in(mac_19b_6_psum_in), .psum_out(mac_19b_6_psum_out));
mac_19b mac_19b_inst_7 (.in_1(mac_19b_7_in_1), .in_2(mac_19b_7_in_2), .psum_in(mac_19b_7_psum_in), .psum_out(mac_19b_7_psum_out));

mult_41x19 mult_41x19_inst_0 (.in_1(mult_0_in_1), .in_2(mult_0_in_2), .product(mult_0_out));
mult_41x19 mult_41x19_inst_1 (.in_1(mult_1_in_1), .in_2(mult_1_in_2), .product(mult_1_out));
mult_41x19 mult_41x19_inst_2 (.in_1(mult_2_in_1), .in_2(mult_2_in_2), .product(mult_2_out));
mult_41x19 mult_41x19_inst_3 (.in_1(mult_3_in_1), .in_2(mult_3_in_2), .product(mult_3_out));
mult_41x19 mult_41x19_inst_4 (.in_1(mult_4_in_1), .in_2(mult_4_in_2), .product(mult_4_out));
mult_41x19 mult_41x19_inst_5 (.in_1(mult_5_in_1), .in_2(mult_5_in_2), .product(mult_5_out));
mult_41x19 mult_41x19_inst_6 (.in_1(mult_6_in_1), .in_2(mult_6_in_2), .product(mult_6_out));
mult_41x19 mult_41x19_inst_7 (.in_1(mult_7_in_1), .in_2(mult_7_in_2), .product(mult_7_out));

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

ReLU_div_3 ReLU_div_3_inst_0 (.in(relu_div_3_in_0), .out(relu_div_3_out_0));
ReLU_div_3 ReLU_div_3_inst_1 (.in(relu_div_3_in_1), .out(relu_div_3_out_1));
ReLU_div_3 ReLU_div_3_inst_2 (.in(relu_div_3_in_2), .out(relu_div_3_out_2));
ReLU_div_3 ReLU_div_3_inst_3 (.in(relu_div_3_in_3), .out(relu_div_3_out_3));
ReLU_div_3 ReLU_div_3_inst_4 (.in(relu_div_3_in_4), .out(relu_div_3_out_4));
ReLU_div_3 ReLU_div_3_inst_5 (.in(relu_div_3_in_5), .out(relu_div_3_out_5));
ReLU_div_3 ReLU_div_3_inst_6 (.in(relu_div_3_in_6), .out(relu_div_3_out_6));
ReLU_div_3 ReLU_div_3_inst_7 (.in(relu_div_3_in_7), .out(relu_div_3_out_7));

add_60 add_60_inst_0 (.in_0(add_60_in_0), .in_1(add_60_in_1), .in_2(add_60_in_2), .in_3(add_60_in_3), .in_4(add_60_in_4), .in_5(add_60_in_5), .in_6(add_60_in_6), .in_7(add_60_in_7), .out(add_60_out));

// data gating
always @(*) begin
	case(GEMM_count_channel)
		'd1 : begin
			mac_8b_0_in_1 = in_data_reg[0][GEMM_count_y];
			mac_8b_1_in_1 = (T_reg != 'd1) ? in_data_reg[1][GEMM_count_y] : 'd0;
			mac_8b_2_in_1 = (T_reg != 'd1) ? in_data_reg[2][GEMM_count_y] : 'd0;
			mac_8b_3_in_1 = (T_reg != 'd1) ? in_data_reg[3][GEMM_count_y] : 'd0;
			mac_8b_4_in_1 = (T_reg == 'd8) ? in_data_reg[4][GEMM_count_y] : 'd0;
			mac_8b_5_in_1 = (T_reg == 'd8) ? in_data_reg[5][GEMM_count_y] : 'd0;
			mac_8b_6_in_1 = (T_reg == 'd8) ? in_data_reg[6][GEMM_count_y] : 'd0;
			mac_8b_7_in_1 = (T_reg == 'd8) ? in_data_reg[7][GEMM_count_y] : 'd0;
			mac_8b_0_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_8b_1_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_8b_2_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_8b_3_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_8b_4_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_8b_5_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_8b_6_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_8b_7_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_8b_0_psum_in = Q_matrix[0][GEMM_count_x];
			mac_8b_1_psum_in = (T_reg != 'd1) ? Q_matrix[1][GEMM_count_x] : 'd0;
			mac_8b_2_psum_in = (T_reg != 'd1) ? Q_matrix[2][GEMM_count_x] : 'd0;
			mac_8b_3_psum_in = (T_reg != 'd1) ? Q_matrix[3][GEMM_count_x] : 'd0;
			mac_8b_4_psum_in = (T_reg == 'd8) ? Q_matrix[4][GEMM_count_x] : 'd0;
			mac_8b_5_psum_in = (T_reg == 'd8) ? Q_matrix[5][GEMM_count_x] : 'd0;
			mac_8b_6_psum_in = (T_reg == 'd8) ? Q_matrix[6][GEMM_count_x] : 'd0;
			mac_8b_7_psum_in = (T_reg == 'd8) ? Q_matrix[7][GEMM_count_x] : 'd0;
		end
		'd2 : begin
			mac_8b_0_in_1 = in_data_reg[0][GEMM_count_y];
			mac_8b_1_in_1 = (T_reg != 'd1) ? in_data_reg[1][GEMM_count_y] : 'd0;
			mac_8b_2_in_1 = (T_reg != 'd1) ? in_data_reg[2][GEMM_count_y] : 'd0;
			mac_8b_3_in_1 = (T_reg != 'd1) ? in_data_reg[3][GEMM_count_y] : 'd0;
			mac_8b_4_in_1 = (T_reg == 'd8) ? in_data_reg[4][GEMM_count_y] : 'd0;
			mac_8b_5_in_1 = (T_reg == 'd8) ? in_data_reg[5][GEMM_count_y] : 'd0;
			mac_8b_6_in_1 = (T_reg == 'd8) ? in_data_reg[6][GEMM_count_y] : 'd0;
			mac_8b_7_in_1 = (T_reg == 'd8) ? in_data_reg[7][GEMM_count_y] : 'd0;
			mac_8b_0_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_8b_1_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_8b_2_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_8b_3_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_8b_4_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_8b_5_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_8b_6_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_8b_7_in_2 = weight_reg[GEMM_count_y][GEMM_count_x];
			mac_8b_0_psum_in = K_matrix[0][GEMM_count_x];
			mac_8b_1_psum_in = (T_reg != 'd1) ? K_matrix[1][GEMM_count_x] : 'd0;
			mac_8b_2_psum_in = (T_reg != 'd1) ? K_matrix[2][GEMM_count_x] : 'd0;
			mac_8b_3_psum_in = (T_reg != 'd1) ? K_matrix[3][GEMM_count_x] : 'd0;
			mac_8b_4_psum_in = (T_reg == 'd8) ? K_matrix[4][GEMM_count_x] : 'd0;
			mac_8b_5_psum_in = (T_reg == 'd8) ? K_matrix[5][GEMM_count_x] : 'd0;
			mac_8b_6_psum_in = (T_reg == 'd8) ? K_matrix[6][GEMM_count_x] : 'd0;
			mac_8b_7_psum_in = (T_reg == 'd8) ? K_matrix[7][GEMM_count_x] : 'd0;
		end
		default : begin
			mac_8b_0_in_1 = 'd0;
			mac_8b_1_in_1 = 'd0;
			mac_8b_2_in_1 = 'd0;
			mac_8b_3_in_1 = 'd0;
			mac_8b_4_in_1 = 'd0;
			mac_8b_5_in_1 = 'd0;
			mac_8b_6_in_1 = 'd0;
			mac_8b_7_in_1 = 'd0;
			mac_8b_0_in_2 = 'd0;
			mac_8b_1_in_2 = 'd0;
			mac_8b_2_in_2 = 'd0;
			mac_8b_3_in_2 = 'd0;
			mac_8b_4_in_2 = 'd0;
			mac_8b_5_in_2 = 'd0;
			mac_8b_6_in_2 = 'd0;
			mac_8b_7_in_2 = 'd0;
			mac_8b_0_psum_in = 'd0;
			mac_8b_1_psum_in = 'd0;
			mac_8b_2_psum_in = 'd0;
			mac_8b_3_psum_in = 'd0;
			mac_8b_4_psum_in = 'd0;
			mac_8b_5_psum_in = 'd0;
			mac_8b_6_psum_in = 'd0;
			mac_8b_7_psum_in = 'd0;
		end
	endcase
end

// zero gating
always @(*) begin
	if (state == WAIT | state == DOUT) begin
		mult_0_in_1 = QK_matrix[out_count_y][0];
		mult_1_in_1 = (T_reg != 'd1) ? QK_matrix[out_count_y][1] : 'd0;
		mult_2_in_1 = (T_reg != 'd1) ? QK_matrix[out_count_y][2] : 'd0;
		mult_3_in_1 = (T_reg != 'd1) ? QK_matrix[out_count_y][3] : 'd0;
		mult_4_in_1 = (T_reg == 'd8) ? QK_matrix[out_count_y][4] : 'd0;
		mult_5_in_1 = (T_reg == 'd8) ? QK_matrix[out_count_y][5] : 'd0;
		mult_6_in_1 = (T_reg == 'd8) ? QK_matrix[out_count_y][6] : 'd0;
		mult_7_in_1 = (T_reg == 'd8) ? QK_matrix[out_count_y][7] : 'd0;
		mult_0_in_2 = (QK_matrix[out_count_y][0] != 'd0) ? V_matrix[0][out_count_x] : 'd0;
		mult_1_in_2 = (T_reg != 'd1 & (QK_matrix[out_count_y][1] != 'd0)) ? V_matrix[1][out_count_x] : 'd0;
		mult_2_in_2 = (T_reg != 'd1 & (QK_matrix[out_count_y][2] != 'd0)) ? V_matrix[2][out_count_x] : 'd0;
		mult_3_in_2 = (T_reg != 'd1 & (QK_matrix[out_count_y][3] != 'd0)) ? V_matrix[3][out_count_x] : 'd0;
		mult_4_in_2 = (T_reg == 'd8 & (QK_matrix[out_count_y][4] != 'd0)) ? V_matrix[4][out_count_x] : 'd0;
		mult_5_in_2 = (T_reg == 'd8 & (QK_matrix[out_count_y][5] != 'd0)) ? V_matrix[5][out_count_x] : 'd0;
		mult_6_in_2 = (T_reg == 'd8 & (QK_matrix[out_count_y][6] != 'd0)) ? V_matrix[6][out_count_x] : 'd0;
		mult_7_in_2 = (T_reg == 'd8 & (QK_matrix[out_count_y][7] != 'd0)) ? V_matrix[7][out_count_x] : 'd0;
	end
	else begin
		mult_0_in_1 = 'd0;
		mult_1_in_1 = 'd0;
		mult_2_in_1 = 'd0;
		mult_3_in_1 = 'd0;
		mult_4_in_1 = 'd0;
		mult_5_in_1 = 'd0;
		mult_6_in_1 = 'd0;
		mult_7_in_1 = 'd0;
		mult_0_in_2 = 'd0;
		mult_1_in_2 = 'd0;
		mult_2_in_2 = 'd0;
		mult_3_in_2 = 'd0;
		mult_4_in_2 = 'd0;
		mult_5_in_2 = 'd0;
		mult_6_in_2 = 'd0;
		mult_7_in_2 = 'd0;
	end
end


always @(*) begin
	if(QK_count_channel == 'd1) begin
		mac_19b_0_in_1 = Q_matrix[QK_count_y][QK_count_x];
		mac_19b_1_in_1 = (T_reg != 'd1) ? Q_matrix[QK_count_y][QK_count_x] : 'd0;
		mac_19b_2_in_1 = (T_reg != 'd1) ? Q_matrix[QK_count_y][QK_count_x] : 'd0;
		mac_19b_3_in_1 = (T_reg != 'd1) ? Q_matrix[QK_count_y][QK_count_x] : 'd0;
		mac_19b_4_in_1 = (T_reg == 'd8) ? Q_matrix[QK_count_y][QK_count_x] : 'd0;
		mac_19b_5_in_1 = (T_reg == 'd8) ? Q_matrix[QK_count_y][QK_count_x] : 'd0;
		mac_19b_6_in_1 = (T_reg == 'd8) ? Q_matrix[QK_count_y][QK_count_x] : 'd0;
		mac_19b_7_in_1 = (T_reg == 'd8) ? Q_matrix[QK_count_y][QK_count_x] : 'd0;
		mac_19b_0_in_2 = K_matrix[0][QK_count_x];
		mac_19b_1_in_2 = (T_reg != 'd1) ? K_matrix[1][QK_count_x] : 'd0;
		mac_19b_2_in_2 = (T_reg != 'd1) ? K_matrix[2][QK_count_x] : 'd0;
		mac_19b_3_in_2 = (T_reg != 'd1) ? K_matrix[3][QK_count_x] : 'd0;
		mac_19b_4_in_2 = (T_reg == 'd8) ? K_matrix[4][QK_count_x] : 'd0;
		mac_19b_5_in_2 = (T_reg == 'd8) ? K_matrix[5][QK_count_x] : 'd0;
		mac_19b_6_in_2 = (T_reg == 'd8) ? K_matrix[6][QK_count_x] : 'd0;
		mac_19b_7_in_2 = (T_reg == 'd8) ? K_matrix[7][QK_count_x] : 'd0;
		mac_19b_0_psum_in = QK_matrix[QK_count_y][0];
		mac_19b_1_psum_in = (T_reg != 'd1) ? QK_matrix[QK_count_y][1] : 'd0;
		mac_19b_2_psum_in = (T_reg != 'd1) ? QK_matrix[QK_count_y][2] : 'd0;
		mac_19b_3_psum_in = (T_reg != 'd1) ? QK_matrix[QK_count_y][3] : 'd0;
		mac_19b_4_psum_in = (T_reg == 'd8) ? QK_matrix[QK_count_y][4] : 'd0;
		mac_19b_5_psum_in = (T_reg == 'd8) ? QK_matrix[QK_count_y][5] : 'd0;
		mac_19b_6_psum_in = (T_reg == 'd8) ? QK_matrix[QK_count_y][6] : 'd0;
		mac_19b_7_psum_in = (T_reg == 'd8) ? QK_matrix[QK_count_y][7] : 'd0;
	end
	else begin
		mac_19b_0_in_1 = 'd0;
		mac_19b_1_in_1 = 'd0;
		mac_19b_2_in_1 = 'd0;
		mac_19b_3_in_1 = 'd0;
		mac_19b_4_in_1 = 'd0;
		mac_19b_5_in_1 = 'd0;
		mac_19b_6_in_1 = 'd0;
		mac_19b_7_in_1 = 'd0;
		mac_19b_0_in_2 = 'd0;
		mac_19b_1_in_2 = 'd0;
		mac_19b_2_in_2 = 'd0;
		mac_19b_3_in_2 = 'd0;
		mac_19b_4_in_2 = 'd0;
		mac_19b_5_in_2 = 'd0;
		mac_19b_6_in_2 = 'd0;
		mac_19b_7_in_2 = 'd0;
		mac_19b_0_psum_in = 'd0;
		mac_19b_1_psum_in = 'd0;
		mac_19b_2_psum_in = 'd0;
		mac_19b_3_psum_in = 'd0;
		mac_19b_4_psum_in = 'd0;
		mac_19b_5_psum_in = 'd0;
		mac_19b_6_psum_in = 'd0;
		mac_19b_7_psum_in = 'd0;
	end
end

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
		mac_8_1_in_1_a = (T_reg != 'd1) ? in_data_reg[1][0] : 'd0;
		mac_8_1_in_2_a = (T_reg != 'd1) ? in_data_reg[1][1] : 'd0;
		mac_8_1_in_3_a = (T_reg != 'd1) ? in_data_reg[1][2] : 'd0;
		mac_8_1_in_4_a = (T_reg != 'd1) ? in_data_reg[1][3] : 'd0;
		mac_8_1_in_5_a = (T_reg != 'd1) ? in_data_reg[1][4] : 'd0;
		mac_8_1_in_6_a = (T_reg != 'd1) ? in_data_reg[1][5] : 'd0;
		mac_8_1_in_7_a = (T_reg != 'd1) ? in_data_reg[1][6] : 'd0;
		mac_8_1_in_8_a = (T_reg != 'd1) ? in_data_reg[1][7] : 'd0;
		mac_8_2_in_1_a = (T_reg != 'd1) ? in_data_reg[2][0] : 'd0;
		mac_8_2_in_2_a = (T_reg != 'd1) ? in_data_reg[2][1] : 'd0;
		mac_8_2_in_3_a = (T_reg != 'd1) ? in_data_reg[2][2] : 'd0;
		mac_8_2_in_4_a = (T_reg != 'd1) ? in_data_reg[2][3] : 'd0;
		mac_8_2_in_5_a = (T_reg != 'd1) ? in_data_reg[2][4] : 'd0;
		mac_8_2_in_6_a = (T_reg != 'd1) ? in_data_reg[2][5] : 'd0;
		mac_8_2_in_7_a = (T_reg != 'd1) ? in_data_reg[2][6] : 'd0;
		mac_8_2_in_8_a = (T_reg != 'd1) ? in_data_reg[2][7] : 'd0;
		mac_8_3_in_1_a = (T_reg != 'd1) ? in_data_reg[3][0] : 'd0;
		mac_8_3_in_2_a = (T_reg != 'd1) ? in_data_reg[3][1] : 'd0;
		mac_8_3_in_3_a = (T_reg != 'd1) ? in_data_reg[3][2] : 'd0;
		mac_8_3_in_4_a = (T_reg != 'd1) ? in_data_reg[3][3] : 'd0;
		mac_8_3_in_5_a = (T_reg != 'd1) ? in_data_reg[3][4] : 'd0;
		mac_8_3_in_6_a = (T_reg != 'd1) ? in_data_reg[3][5] : 'd0;
		mac_8_3_in_7_a = (T_reg != 'd1) ? in_data_reg[3][6] : 'd0;
		mac_8_3_in_8_a = (T_reg != 'd1) ? in_data_reg[3][7] : 'd0;
		mac_8_4_in_1_a = (T_reg == 'd8) ? in_data_reg[4][0] : 'd0;
		mac_8_4_in_2_a = (T_reg == 'd8) ? in_data_reg[4][1] : 'd0;
		mac_8_4_in_3_a = (T_reg == 'd8) ? in_data_reg[4][2] : 'd0;
		mac_8_4_in_4_a = (T_reg == 'd8) ? in_data_reg[4][3] : 'd0;
		mac_8_4_in_5_a = (T_reg == 'd8) ? in_data_reg[4][4] : 'd0;
		mac_8_4_in_6_a = (T_reg == 'd8) ? in_data_reg[4][5] : 'd0;
		mac_8_4_in_7_a = (T_reg == 'd8) ? in_data_reg[4][6] : 'd0;
		mac_8_4_in_8_a = (T_reg == 'd8) ? in_data_reg[4][7] : 'd0;
		mac_8_5_in_1_a = (T_reg == 'd8) ? in_data_reg[5][0] : 'd0;
		mac_8_5_in_2_a = (T_reg == 'd8) ? in_data_reg[5][1] : 'd0;
		mac_8_5_in_3_a = (T_reg == 'd8) ? in_data_reg[5][2] : 'd0;
		mac_8_5_in_4_a = (T_reg == 'd8) ? in_data_reg[5][3] : 'd0;
		mac_8_5_in_5_a = (T_reg == 'd8) ? in_data_reg[5][4] : 'd0;
		mac_8_5_in_6_a = (T_reg == 'd8) ? in_data_reg[5][5] : 'd0;
		mac_8_5_in_7_a = (T_reg == 'd8) ? in_data_reg[5][6] : 'd0;
		mac_8_5_in_8_a = (T_reg == 'd8) ? in_data_reg[5][7] : 'd0;
		mac_8_6_in_1_a = (T_reg == 'd8) ? in_data_reg[6][0] : 'd0;
		mac_8_6_in_2_a = (T_reg == 'd8) ? in_data_reg[6][1] : 'd0;
		mac_8_6_in_3_a = (T_reg == 'd8) ? in_data_reg[6][2] : 'd0;
		mac_8_6_in_4_a = (T_reg == 'd8) ? in_data_reg[6][3] : 'd0;
		mac_8_6_in_5_a = (T_reg == 'd8) ? in_data_reg[6][4] : 'd0;
		mac_8_6_in_6_a = (T_reg == 'd8) ? in_data_reg[6][5] : 'd0;
		mac_8_6_in_7_a = (T_reg == 'd8) ? in_data_reg[6][6] : 'd0;
		mac_8_6_in_8_a = (T_reg == 'd8) ? in_data_reg[6][7] : 'd0;
		mac_8_7_in_1_a = (T_reg == 'd8) ? in_data_reg[7][0] : 'd0;
		mac_8_7_in_2_a = (T_reg == 'd8) ? in_data_reg[7][1] : 'd0;
		mac_8_7_in_3_a = (T_reg == 'd8) ? in_data_reg[7][2] : 'd0;
		mac_8_7_in_4_a = (T_reg == 'd8) ? in_data_reg[7][3] : 'd0;
		mac_8_7_in_5_a = (T_reg == 'd8) ? in_data_reg[7][4] : 'd0;
		mac_8_7_in_6_a = (T_reg == 'd8) ? in_data_reg[7][5] : 'd0;
		mac_8_7_in_7_a = (T_reg == 'd8) ? in_data_reg[7][6] : 'd0;
		mac_8_7_in_8_a = (T_reg == 'd8) ? in_data_reg[7][7] : 'd0;

		mac_8_0_in_1_b = weight_reg[0][GEMM_count_x];
		mac_8_0_in_2_b = weight_reg[1][GEMM_count_x];
		mac_8_0_in_3_b = weight_reg[2][GEMM_count_x];
		mac_8_0_in_4_b = weight_reg[3][GEMM_count_x];
		mac_8_0_in_5_b = weight_reg[4][GEMM_count_x];
		mac_8_0_in_6_b = weight_reg[5][GEMM_count_x];
		mac_8_0_in_7_b = weight_reg[6][GEMM_count_x];
		mac_8_0_in_8_b = weight_reg[7][GEMM_count_x];
		mac_8_1_in_1_b = (T_reg != 'd1) ? weight_reg[0][GEMM_count_x] : 'd0;
		mac_8_1_in_2_b = (T_reg != 'd1) ? weight_reg[1][GEMM_count_x] : 'd0;
		mac_8_1_in_3_b = (T_reg != 'd1) ? weight_reg[2][GEMM_count_x] : 'd0;
		mac_8_1_in_4_b = (T_reg != 'd1) ? weight_reg[3][GEMM_count_x] : 'd0;
		mac_8_1_in_5_b = (T_reg != 'd1) ? weight_reg[4][GEMM_count_x] : 'd0;
		mac_8_1_in_6_b = (T_reg != 'd1) ? weight_reg[5][GEMM_count_x] : 'd0;
		mac_8_1_in_7_b = (T_reg != 'd1) ? weight_reg[6][GEMM_count_x] : 'd0;
		mac_8_1_in_8_b = (T_reg != 'd1) ? weight_reg[7][GEMM_count_x] : 'd0;
		mac_8_2_in_1_b = (T_reg != 'd1) ? weight_reg[0][GEMM_count_x] : 'd0;
		mac_8_2_in_2_b = (T_reg != 'd1) ? weight_reg[1][GEMM_count_x] : 'd0;
		mac_8_2_in_3_b = (T_reg != 'd1) ? weight_reg[2][GEMM_count_x] : 'd0;
		mac_8_2_in_4_b = (T_reg != 'd1) ? weight_reg[3][GEMM_count_x] : 'd0;
		mac_8_2_in_5_b = (T_reg != 'd1) ? weight_reg[4][GEMM_count_x] : 'd0;
		mac_8_2_in_6_b = (T_reg != 'd1) ? weight_reg[5][GEMM_count_x] : 'd0;
		mac_8_2_in_7_b = (T_reg != 'd1) ? weight_reg[6][GEMM_count_x] : 'd0;
		mac_8_2_in_8_b = (T_reg != 'd1) ? weight_reg[7][GEMM_count_x] : 'd0;
		mac_8_3_in_1_b = (T_reg != 'd1) ? weight_reg[0][GEMM_count_x] : 'd0;
		mac_8_3_in_2_b = (T_reg != 'd1) ? weight_reg[1][GEMM_count_x] : 'd0;
		mac_8_3_in_3_b = (T_reg != 'd1) ? weight_reg[2][GEMM_count_x] : 'd0;
		mac_8_3_in_4_b = (T_reg != 'd1) ? weight_reg[3][GEMM_count_x] : 'd0;
		mac_8_3_in_5_b = (T_reg != 'd1) ? weight_reg[4][GEMM_count_x] : 'd0;
		mac_8_3_in_6_b = (T_reg != 'd1) ? weight_reg[5][GEMM_count_x] : 'd0;
		mac_8_3_in_7_b = (T_reg != 'd1) ? weight_reg[6][GEMM_count_x] : 'd0;
		mac_8_3_in_8_b = (T_reg != 'd1) ? weight_reg[7][GEMM_count_x] : 'd0;
		mac_8_4_in_1_b = (T_reg == 'd8) ? weight_reg[0][GEMM_count_x] : 'd0;
		mac_8_4_in_2_b = (T_reg == 'd8) ? weight_reg[1][GEMM_count_x] : 'd0;
		mac_8_4_in_3_b = (T_reg == 'd8) ? weight_reg[2][GEMM_count_x] : 'd0;
		mac_8_4_in_4_b = (T_reg == 'd8) ? weight_reg[3][GEMM_count_x] : 'd0;
		mac_8_4_in_5_b = (T_reg == 'd8) ? weight_reg[4][GEMM_count_x] : 'd0;
		mac_8_4_in_6_b = (T_reg == 'd8) ? weight_reg[5][GEMM_count_x] : 'd0;
		mac_8_4_in_7_b = (T_reg == 'd8) ? weight_reg[6][GEMM_count_x] : 'd0;
		mac_8_4_in_8_b = (T_reg == 'd8) ? weight_reg[7][GEMM_count_x] : 'd0;
		mac_8_5_in_1_b = (T_reg == 'd8) ? weight_reg[0][GEMM_count_x] : 'd0;
		mac_8_5_in_2_b = (T_reg == 'd8) ? weight_reg[1][GEMM_count_x] : 'd0;
		mac_8_5_in_3_b = (T_reg == 'd8) ? weight_reg[2][GEMM_count_x] : 'd0;
		mac_8_5_in_4_b = (T_reg == 'd8) ? weight_reg[3][GEMM_count_x] : 'd0;
		mac_8_5_in_5_b = (T_reg == 'd8) ? weight_reg[4][GEMM_count_x] : 'd0;
		mac_8_5_in_6_b = (T_reg == 'd8) ? weight_reg[5][GEMM_count_x] : 'd0;
		mac_8_5_in_7_b = (T_reg == 'd8) ? weight_reg[6][GEMM_count_x] : 'd0;
		mac_8_5_in_8_b = (T_reg == 'd8) ? weight_reg[7][GEMM_count_x] : 'd0;
		mac_8_6_in_1_b = (T_reg == 'd8) ? weight_reg[0][GEMM_count_x] : 'd0;
		mac_8_6_in_2_b = (T_reg == 'd8) ? weight_reg[1][GEMM_count_x] : 'd0;
		mac_8_6_in_3_b = (T_reg == 'd8) ? weight_reg[2][GEMM_count_x] : 'd0;
		mac_8_6_in_4_b = (T_reg == 'd8) ? weight_reg[3][GEMM_count_x] : 'd0;
		mac_8_6_in_5_b = (T_reg == 'd8) ? weight_reg[4][GEMM_count_x] : 'd0;
		mac_8_6_in_6_b = (T_reg == 'd8) ? weight_reg[5][GEMM_count_x] : 'd0;
		mac_8_6_in_7_b = (T_reg == 'd8) ? weight_reg[6][GEMM_count_x] : 'd0;
		mac_8_6_in_8_b = (T_reg == 'd8) ? weight_reg[7][GEMM_count_x] : 'd0;
		mac_8_7_in_1_b = (T_reg == 'd8) ? weight_reg[0][GEMM_count_x] : 'd0;
		mac_8_7_in_2_b = (T_reg == 'd8) ? weight_reg[1][GEMM_count_x] : 'd0;
		mac_8_7_in_3_b = (T_reg == 'd8) ? weight_reg[2][GEMM_count_x] : 'd0;
		mac_8_7_in_4_b = (T_reg == 'd8) ? weight_reg[3][GEMM_count_x] : 'd0;
		mac_8_7_in_5_b = (T_reg == 'd8) ? weight_reg[4][GEMM_count_x] : 'd0;
		mac_8_7_in_6_b = (T_reg == 'd8) ? weight_reg[5][GEMM_count_x] : 'd0;
		mac_8_7_in_7_b = (T_reg == 'd8) ? weight_reg[6][GEMM_count_x] : 'd0;
		mac_8_7_in_8_b = (T_reg == 'd8) ? weight_reg[7][GEMM_count_x] : 'd0;
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

always @(*) begin
	if (QK_count_channel == 'd1 & QK_count_x == 'd7) begin
		relu_div_3_in_0 = QK_result[0];
		relu_div_3_in_1 = (T_reg != 'd1) ? QK_result[1] : 'd0;
		relu_div_3_in_2 = (T_reg != 'd1) ? QK_result[2] : 'd0;
		relu_div_3_in_3 = (T_reg != 'd1) ? QK_result[3] : 'd0;
		relu_div_3_in_4 = (T_reg == 'd8) ? QK_result[4] : 'd0;
		relu_div_3_in_5 = (T_reg == 'd8) ? QK_result[5] : 'd0;
		relu_div_3_in_6 = (T_reg == 'd8) ? QK_result[6] : 'd0;
		relu_div_3_in_7 = (T_reg == 'd8) ? QK_result[7] : 'd0;
	end
	else begin
		relu_div_3_in_0 = 'd0;
		relu_div_3_in_1 = 'd0;
		relu_div_3_in_2 = 'd0;
		relu_div_3_in_3 = 'd0;
		relu_div_3_in_4 = 'd0;
		relu_div_3_in_5 = 'd0;
		relu_div_3_in_6 = 'd0;
		relu_div_3_in_7 = 'd0;
	end
end


always @(*) begin
	if (state == WAIT | state == DOUT) begin
		add_60_in_0 = P_reg[0];
	end
	else begin
		add_60_in_0 = 'd0;
	end
end

always @(*) begin
	if ((state == WAIT | state == DOUT) & (T_reg != 'd1)) begin
		add_60_in_1 = P_reg[1];
		add_60_in_2 = P_reg[2];
		add_60_in_3 = P_reg[3];
	end
	else begin
		add_60_in_1 = 'd0;
		add_60_in_2 = 'd0;
		add_60_in_3 = 'd0;
	end
end

always @(*) begin
	if ((state == WAIT | state == DOUT) & (T_reg != 'd1 | T_reg != 'd4)) begin
		add_60_in_4 = P_reg[4];
		add_60_in_5 = P_reg[5];
		add_60_in_6 = P_reg[6];
		add_60_in_7 = P_reg[7];
	end
	else begin
		add_60_in_4 = 'd0;
		add_60_in_5 = 'd0;
		add_60_in_6 = 'd0;
		add_60_in_7 = 'd0;
	end
end

// Q, K, V matrix calculation
genvar Q_VAR_Y, Q_VAR_X;
wire CLK_Q [0:7][0:7];
generate
for(Q_VAR_Y=0; Q_VAR_Y<8; Q_VAR_Y=Q_VAR_Y+1) begin
	for(Q_VAR_X=0; Q_VAR_X<8; Q_VAR_X=Q_VAR_X+1) begin
		GATED_OR GATED_Q (.CLOCK(clk), .SLEEP_CTRL(cg_en & sleep_Q), .RST_N(rst_n), .CLOCK_GATED(CLK_Q[Q_VAR_Y][Q_VAR_X]));
		always @(posedge CLK_Q[Q_VAR_Y][Q_VAR_X] or negedge rst_n) begin
			if(!rst_n) begin
				Q_matrix[Q_VAR_Y][Q_VAR_X] <= 'd0;
			end
			else if(state == IDLE) begin
				Q_matrix[Q_VAR_Y][Q_VAR_X] <= 'd0;
			end
			else if(GEMM_count_channel == 'd1) begin
				if(Q_VAR_X == GEMM_count_x) begin
					if(Q_VAR_Y == 0) 		Q_matrix[Q_VAR_Y][Q_VAR_X] <= mac_8b_0_psum_out;
					else if(Q_VAR_Y == 1) Q_matrix[Q_VAR_Y][Q_VAR_X] <= mac_8b_1_psum_out;
					else if(Q_VAR_Y == 2) Q_matrix[Q_VAR_Y][Q_VAR_X] <= mac_8b_2_psum_out;
					else if(Q_VAR_Y == 3) Q_matrix[Q_VAR_Y][Q_VAR_X] <= mac_8b_3_psum_out;
					else if(Q_VAR_Y == 4) Q_matrix[Q_VAR_Y][Q_VAR_X] <= mac_8b_4_psum_out;
					else if(Q_VAR_Y == 5) Q_matrix[Q_VAR_Y][Q_VAR_X] <= mac_8b_5_psum_out;
					else if(Q_VAR_Y == 6) Q_matrix[Q_VAR_Y][Q_VAR_X] <= mac_8b_6_psum_out;
					else if(Q_VAR_Y == 7) Q_matrix[Q_VAR_Y][Q_VAR_X] <= mac_8b_7_psum_out;
				end
			end
		end
	end
end
endgenerate

genvar K_VAR_Y, K_VAR_X;
wire CLK_K [0:7][0:7];
generate
for(K_VAR_Y=0; K_VAR_Y<8; K_VAR_Y=K_VAR_Y+1) begin
	for(K_VAR_X=0; K_VAR_X<8; K_VAR_X=K_VAR_X+1) begin
		GATED_OR GATED_K (.CLOCK(clk), .SLEEP_CTRL(cg_en & sleep_K),.RST_N(rst_n), .CLOCK_GATED(CLK_K[K_VAR_Y][K_VAR_X]));
		always @(posedge CLK_K[K_VAR_Y][K_VAR_X] or negedge rst_n) begin
			if(!rst_n) begin
				K_matrix[K_VAR_Y][K_VAR_X] <= 'd0;
			end
			else if(state == IDLE) begin
				K_matrix[K_VAR_Y][K_VAR_X] <= 'd0;
			end
			else if(GEMM_count_channel == 'd2) begin
				if(K_VAR_X == GEMM_count_x) begin
					if(K_VAR_Y == 0) 		K_matrix[K_VAR_Y][K_VAR_X] <= mac_8b_0_psum_out;
					else if(K_VAR_Y == 1) K_matrix[K_VAR_Y][K_VAR_X] <= mac_8b_1_psum_out;
					else if(K_VAR_Y == 2) K_matrix[K_VAR_Y][K_VAR_X] <= mac_8b_2_psum_out;
					else if(K_VAR_Y == 3) K_matrix[K_VAR_Y][K_VAR_X] <= mac_8b_3_psum_out;
					else if(K_VAR_Y == 4) K_matrix[K_VAR_Y][K_VAR_X] <= mac_8b_4_psum_out;
					else if(K_VAR_Y == 5) K_matrix[K_VAR_Y][K_VAR_X] <= mac_8b_5_psum_out;
					else if(K_VAR_Y == 6) K_matrix[K_VAR_Y][K_VAR_X] <= mac_8b_6_psum_out;
					else if(K_VAR_Y == 7) K_matrix[K_VAR_Y][K_VAR_X] <= mac_8b_7_psum_out;
				end
			end
		end
	end
end
endgenerate

genvar V_VAR_Y, V_VAR_X;
wire CLK_V [0:7][0:7];
generate
for(V_VAR_Y=0; V_VAR_Y<8; V_VAR_Y=V_VAR_Y+1) begin
	for(V_VAR_X=0; V_VAR_X<8; V_VAR_X=V_VAR_X+1) begin
		GATED_OR GATED_K (.CLOCK(clk), .SLEEP_CTRL(cg_en & sleep_V), .RST_N(rst_n), .CLOCK_GATED(CLK_V[V_VAR_Y][V_VAR_X]));
		always @(posedge CLK_V[V_VAR_Y][V_VAR_X] or negedge rst_n) begin
			if(!rst_n) begin
				V_matrix[V_VAR_Y][V_VAR_X] <= 'd0;
			end
			else if(state == IDLE) begin
				V_matrix[V_VAR_Y][V_VAR_X] <= 'd0;
			end
			else if(GEMM_count_channel == 'd3 & GEMM_count_y == 'd0) begin
				if(V_VAR_X == GEMM_count_x) begin
					if(V_VAR_Y == 0) 		V_matrix[V_VAR_Y][V_VAR_X] <= mac_8_0_out;
					else if(V_VAR_Y == 1) V_matrix[V_VAR_Y][V_VAR_X] <= mac_8_1_out;
					else if(V_VAR_Y == 2) V_matrix[V_VAR_Y][V_VAR_X] <= mac_8_2_out;
					else if(V_VAR_Y == 3) V_matrix[V_VAR_Y][V_VAR_X] <= mac_8_3_out;
					else if(V_VAR_Y == 4) V_matrix[V_VAR_Y][V_VAR_X] <= mac_8_4_out;
					else if(V_VAR_Y == 5) V_matrix[V_VAR_Y][V_VAR_X] <= mac_8_5_out;
					else if(V_VAR_Y == 6) V_matrix[V_VAR_Y][V_VAR_X] <= mac_8_6_out;
					else if(V_VAR_Y == 7) V_matrix[V_VAR_Y][V_VAR_X] <= mac_8_7_out;
				end
			end
		end
	end
end
endgenerate

genvar QK_VAR_Y, QK_VAR_X;
wire CLK_QK [0:7][0:7];
generate
for(QK_VAR_Y=0; QK_VAR_Y<8; QK_VAR_Y=QK_VAR_Y+1) begin
	for(QK_VAR_X=0; QK_VAR_X<8; QK_VAR_X=QK_VAR_X+1) begin
		GATED_OR GATED_QK (.CLOCK(clk), .SLEEP_CTRL(cg_en & sleep_QK),.RST_N(rst_n), .CLOCK_GATED(CLK_QK[QK_VAR_Y][QK_VAR_X]));
		always @(posedge CLK_QK[QK_VAR_Y][QK_VAR_X]) begin
			if(state == IDLE) begin
				QK_matrix[QK_VAR_Y][QK_VAR_X] <= 'd0;
			end
			else if(QK_count_channel == 'd1) begin
				if(QK_VAR_Y == QK_count_y) begin
					if(QK_VAR_X == 0) 		QK_matrix[QK_VAR_Y][QK_VAR_X] <= (QK_count_x == 'd7) ? relu_div_3_out_0 : QK_result[0];
					else if(QK_VAR_X == 1) QK_matrix[QK_VAR_Y][QK_VAR_X] <= (QK_count_x == 'd7) ? relu_div_3_out_1 : QK_result[1];
					else if(QK_VAR_X == 2) QK_matrix[QK_VAR_Y][QK_VAR_X] <= (QK_count_x == 'd7) ? relu_div_3_out_2 : QK_result[2];
					else if(QK_VAR_X == 3) QK_matrix[QK_VAR_Y][QK_VAR_X] <= (QK_count_x == 'd7) ? relu_div_3_out_3 : QK_result[3];
					else if(QK_VAR_X == 4) QK_matrix[QK_VAR_Y][QK_VAR_X] <= (QK_count_x == 'd7) ? relu_div_3_out_4 : QK_result[4];
					else if(QK_VAR_X == 5) QK_matrix[QK_VAR_Y][QK_VAR_X] <= (QK_count_x == 'd7) ? relu_div_3_out_5 : QK_result[5];
					else if(QK_VAR_X == 6) QK_matrix[QK_VAR_Y][QK_VAR_X] <= (QK_count_x == 'd7) ? relu_div_3_out_6 : QK_result[6];
					else if(QK_VAR_X == 7) QK_matrix[QK_VAR_Y][QK_VAR_X] <= (QK_count_x == 'd7) ? relu_div_3_out_7 : QK_result[7];
				end
			end
		end
	end
end
endgenerate

genvar P_VAR;
wire CLK_P [0:7];
generate
for(P_VAR=0; P_VAR<8; P_VAR=P_VAR+1) begin
	GATED_OR GATED_P (.CLOCK(clk), .SLEEP_CTRL(cg_en & sleep_P), .RST_N(rst_n), .CLOCK_GATED(CLK_P[P_VAR]));
	always @(posedge CLK_P[P_VAR] or negedge rst_n) begin
		if(!rst_n) begin
			P_reg[P_VAR] <= 'd0;
		end
		else if(state == WAIT | state == DOUT) begin
			if(P_VAR == 0) 	 	P_reg[P_VAR] <= mult_0_out;
			else if(P_VAR == 1) P_reg[P_VAR] <= mult_1_out;
			else if(P_VAR == 2) P_reg[P_VAR] <= mult_2_out;
			else if(P_VAR == 3) P_reg[P_VAR] <= mult_3_out;
			else if(P_VAR == 4) P_reg[P_VAR] <= mult_4_out;
			else if(P_VAR == 5) P_reg[P_VAR] <= mult_5_out;
			else if(P_VAR == 6) P_reg[P_VAR] <= mult_6_out;
			else if(P_VAR == 7) P_reg[P_VAR] <= mult_7_out;
		end
		else begin
			P_reg[P_VAR] <= P_reg[P_VAR];
		end
	end
end
endgenerate


// output process
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

wire CLK_out_reg;
GATED_OR GATED_out_reg (.CLOCK(clk), .SLEEP_CTRL(cg_en & sleep_out_reg), .RST_N(rst_n), .CLOCK_GATED(CLK_out_reg));
always @(posedge CLK_out_reg) begin
	if(state == WAIT | state == DOUT) begin
		out_reg <= (T_reg == 'd8) ? (P_reg[0] + P_reg[1] + P_reg[2] + P_reg[3] + P_reg[4] + P_reg[5] + P_reg[6] + P_reg[7]) : 
				   (T_reg == 'd4) ? (P_reg[0] + P_reg[1] + P_reg[2] + P_reg[3]) : P_reg[0];
		//out_reg <= add_60_out;
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


module mac_19b(
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


module ReLU_div_3 (
	input  signed [40:0] in,
	output signed [40:0] out
);

assign out = in[40] ? 'd0 : (in / 'd3);

endmodule


module add_60 (
	input  signed [59:0] in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7,
	output signed [62:0] out
);

assign out = in_0 + in_1 + in_2 + in_3 + in_4 + in_5 + in_6 + in_7;

endmodule

