//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//    (C) Copyright System Integration and Silicon Implementation Laboratory
//    All Right Reserved
//		Date		: 2024/9
//		Version		: v1.0
//   	File Name   : MDC.v
//   	Module Name : MDC
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

//synopsys translate_off
`include "HAMMING_IP.v"
//synopsys translate_on

module MDC(
    // Input signals
    clk,
	rst_n,
	in_valid,
    in_data, 
	in_mode,
    // Output signals
    out_valid, 
	out_data
);

// ===============================================================
// Input & Output Declaration
// ===============================================================
input clk, rst_n, in_valid;
input [8:0] in_mode;
input [14:0] in_data;

output reg out_valid;
output reg [206:0] out_data;

/*
    | a11 a12 a13 a14 |
    | a21 a22 a23 a24 |
D = | a31 a32 a33 a34 |
    | a41 a42 a43 a44 |

D =-a41 * [a32(a13​a24 ​- a14​a23) - a33(a12a24 - a14a22) + a34(a12​a23​ ​- a13​a22)]
   +a42 * [a31(a13​a24 ​- a14​a23) - a33(a11a24 - a14a21) + a34(a11a23 - a13a21)]
   -a43 * [a31(a12a24 - a14a22) - a32(a11a24 - a14a21) + a34(a11a22 - a12a21)]
   +a44 * [a31(a12​a23​ ​- a13​a22) - a32(a11a23 - a13a21) + a33(a11a22 - a12a21)]

a12a21, a13​a21, a14​a21
a11a22, a13​a22, a14​a22
a11a23, a12​a23​, a14​a23
a11a24, a12​a24, a13​a24

a11​a22 ​- a12​a21
a11​a23 ​- a13​a21, a12​a23​ ​- a13​a22
a11​a24 ​- a14​a21, a12​a24 ​- a14​a22, a13​a24 ​- a14​a23

-----------------------------------------------------------------------------

    | a11 a12 a13 a14 |
    | a21 a22 a23 a24 |
D = | a31 a32 a33 a34 |
    | a41 a42 a43 a44 |

D1 = a31(a12a23 ​- a13a22) ​- a32(a11​a23 ​- a13​a21) + a33(a11a22 ​- a12​a21)
D2 = a32(a13a24 ​- a14​a23) ​- a33(a12a24 ​- a14a22​) + a34(a12a23 ​- a13a22)
D3 = a41(a22​a33 ​- a23​a32) ​- a42(a21​a33 ​- a23​a31​) + a43(a21​a32 ​- a22​a31​)
D4 = a42(a23​a34 ​- a24​a33) ​- a43(a22​a34 ​- a24​a32) + a44(a22​a33 ​- a23​a32)

a12​a21, a13​a21
a11a22, a13a22, a14a22​
a11​a23, a12a23, a14​a23
a12a24, a13a24

a22​a31​, a23​a31​
a21​a32, a23​a32, a24​a32
a21​a33, a22​a33, a24​a33
a22​a34, a23​a34

a11a22 ​- a12​a21
a11​a23 ​- a13​a21, a12a23 ​- a13a22
a12a24 ​- a14a22​, a13a24 ​- a14​a23
a21​a32 ​- a22​a31​
a21​a33 ​- a23​a31​, a22​a33 ​- a23​a32
a22​a34 ​- a24​a32, a23​a34 ​- a24​a33


-----------------------------------------------------------------------------
    | a11 a12 a13 a14 |
    | a21 a22 a23 a24 |
D = | a31 a32 a33 a34 |
    | a41 a42 a43 a44 |

D1 = a11a22 - a12a21
D2 = a12a23 - a13a22
D3 = a13a24 - a14a23
D4 = a21a32 - a22a31
D5 = a22a33 - a23a32
D6 = a23a34 - a24a33
D7 = a31a42 - a32a41
D8 = a32a43 - a33a42
D9 = a33a44 - a34a43
*/


//==================================================================
// parameter & integer
//==================================================================
localparam IDLE = 'd0;
localparam DIN  = 'd1;
localparam DOUT = 'd2;

parameter MATRIX_SIZE_2 = 5'b00100;
parameter MATRIX_SIZE_3 = 5'b00110;
parameter MATRIX_SIZE_4 = 5'b10110;

//==================================================================
// reg
//==================================================================
// state
reg [1:0] state, next_state;

// input reg
reg [4:0] in_mode_reg;
reg signed [10:0] matrix_reg [0:7]; // shift reg

// pipeline regs
reg signed [21:0] mult_out_reg          [0:11];
reg signed [22:0] sub_22_out_reg        [0:8];
reg signed [33:0] mult_11x23_out_reg    [0:3];
reg signed [44:0] final_out_reg;

// counter
reg [3:0] count;

//==================================================================
// Wires
//==================================================================
// input decoding
wire [4:0] in_mode_decoded;
wire signed [10:0] in_data_decoded;

// mult & add sharing
reg signed [10:0] mult_11x11_0_in1, mult_11x11_1_in1;
reg signed [10:0] mult_11x11_0_in2, mult_11x11_1_in2;
wire signed [21:0] mult_11x11_0_out, mult_11x11_1_out;

reg signed [21:0] sub_22_0_in1;
reg signed [21:0] sub_22_0_in2;
wire signed [22:0] sub_22_0_out;

reg signed [10:0] mult_11x23_0_in1, mult_11x23_1_in1;
reg signed [22:0] mult_11x23_0_in2, mult_11x23_1_in2;
wire signed [33:0] mult_11x23_0_out, mult_11x23_1_out;

reg signed [10:0] mult_11x34_in1;
reg signed [33:0] mult_11x34_in2;
wire signed [44:0] mult_11x34_out;

reg signed [33:0] add_34_0_in1, add_34_1_in1;
reg signed [33:0] add_34_0_in2, add_34_1_in2;
wire signed [33:0] add_34_0_out, add_34_1_out;

reg signed [44:0] add_45_in1;
reg signed [44:0] add_45_in2;
wire signed [44:0] add_45_out;


//==================================================================
// Design
//==================================================================
// next state logic
always @(*) begin
    case(state)
        IDLE    : next_state = in_valid     ? DIN   : IDLE;
        DIN     : next_state = ~in_valid    ? DOUT  : DIN;
        DOUT    : next_state = IDLE;
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

always @(*) begin
    case(in_mode_reg)
        MATRIX_SIZE_2 : begin
            mult_11x11_0_in2 = matrix_reg[0];
            mult_11x11_1_in2 = matrix_reg[1];
            mult_11x11_0_in1 = matrix_reg[5];
            mult_11x11_1_in1 = matrix_reg[4];
        end
        MATRIX_SIZE_3 : begin
            mult_11x11_0_in2 = matrix_reg[0];
            mult_11x11_1_in2 = matrix_reg[0];
            case(count)
                'd5 : begin
                    mult_11x11_0_in1 = matrix_reg[3];
                    mult_11x11_1_in1 = matrix_reg[2];
                end
                'd6 : begin
                    mult_11x11_0_in1 = matrix_reg[5];
                    mult_11x11_1_in1 = matrix_reg[3];
                end
                'd7 : begin
                    mult_11x11_0_in1 = matrix_reg[6];
                    mult_11x11_1_in1 = matrix_reg[5];
                end
                'd8 : begin
                    mult_11x11_0_in1 = matrix_reg[6];
                    mult_11x11_1_in1 = matrix_reg[5];
                end
                'd9 : begin
                    mult_11x11_0_in1 = matrix_reg[3];
                    mult_11x11_1_in1 = matrix_reg[2];
                end
                'd10: begin
                    mult_11x11_0_in1 = matrix_reg[5];
                    mult_11x11_1_in1 = matrix_reg[3];
                end
                'd11: begin
                    mult_11x11_0_in1 = matrix_reg[6];
                    mult_11x11_1_in1 = matrix_reg[5];
                end
                'd12: begin
                    mult_11x11_0_in1 = matrix_reg[6];
                    mult_11x11_1_in1 = matrix_reg[5];
                end
                default : begin
                    mult_11x11_0_in1 = 'd0;
                    mult_11x11_1_in1 = 'd0;
                end
            endcase
        end
        MATRIX_SIZE_4 : begin
            mult_11x11_0_in2 = matrix_reg[0];
            mult_11x11_1_in2 = matrix_reg[0];
            case(count)
                'd5 : begin
                    mult_11x11_0_in1 = matrix_reg[3];
                    mult_11x11_1_in1 = matrix_reg[2];
                end
                'd6 : begin
                    mult_11x11_0_in1 = matrix_reg[5];
                    mult_11x11_1_in1 = matrix_reg[3];
                end
                'd7 : begin
                    mult_11x11_0_in1 = matrix_reg[6];
                    mult_11x11_1_in1 = matrix_reg[5];
                end
                'd8 : begin
                    mult_11x11_0_in1 = matrix_reg[7];
                    mult_11x11_1_in1 = matrix_reg[6];
                end
                default : begin
                    mult_11x11_0_in1 = 'd0;
                    mult_11x11_1_in1 = 'd0;
                end
            endcase
        end
        default : begin
            mult_11x11_0_in1 = 'd0;
            mult_11x11_0_in2 = 'd0;
            mult_11x11_1_in1 = 'd0;
            mult_11x11_1_in2 = 'd0;
        end
    endcase
end

always @(*) begin
    case(in_mode_reg)
        MATRIX_SIZE_2 : begin
            sub_22_0_in1 = mult_11x11_0_out;
            sub_22_0_in2 = mult_11x11_1_out;
        end
        MATRIX_SIZE_3 : begin
            case(count)
                'd7 : begin
                    sub_22_0_in1 = mult_out_reg[2];
                    sub_22_0_in2 = mult_out_reg[0];
                end
                'd8 : begin
                    sub_22_0_in1 = mult_out_reg[5];
                    sub_22_0_in2 = mult_out_reg[1];
                end
                'd9 : begin
                    sub_22_0_in1 = mult_out_reg[8];
                    sub_22_0_in2 = mult_out_reg[4];
                end
                'd11: begin
                    sub_22_0_in1 = mult_out_reg[0];
                    sub_22_0_in2 = mult_out_reg[10];
                end
                'd12: begin
                    sub_22_0_in1 = mult_out_reg[3];
                    sub_22_0_in2 = mult_out_reg[11];
                end
                'd13: begin
                    sub_22_0_in1 = mult_out_reg[6];
                    sub_22_0_in2 = mult_out_reg[2];
                end
                default : begin
                    sub_22_0_in1 = 'd0;
                    sub_22_0_in2 = 'd0;
                end
            endcase
        end
        MATRIX_SIZE_4 : begin
            case(count)
                'd6 : begin
                    sub_22_0_in1 = mult_11x11_0_out;
                    sub_22_0_in2 = mult_out_reg[0];
                end
                'd7 : begin
                    sub_22_0_in1 = mult_11x11_0_out;
                    sub_22_0_in2 = mult_out_reg[1];
                end
                'd8 : begin
                    sub_22_0_in1 = mult_11x11_1_out;
                    sub_22_0_in2 = mult_out_reg[5];
                end
                'd9 : begin
                    sub_22_0_in1 = mult_out_reg[9];
                    sub_22_0_in2 = mult_out_reg[2];
                end
                default : begin
                    sub_22_0_in1 = 'd0;
                    sub_22_0_in2 = 'd0;
                end
            endcase
        end
        default : begin
            sub_22_0_in1 = 'd0;
            sub_22_0_in2 = 'd0;
        end
    endcase
end

always @(*) begin
    case(in_mode_reg)
        MATRIX_SIZE_2 : begin
            mult_11x23_0_in1 = 'd0;
            mult_11x23_0_in2 = 'd0;
            mult_11x23_1_in1 = 'd0;
            mult_11x23_1_in2 = 'd0;
        end
        MATRIX_SIZE_3 : begin
            case(count)
                'd9 : begin
                    mult_11x23_0_in1 = matrix_reg[0];
                    mult_11x23_0_in2 = sub_22_out_reg[2];
                    mult_11x23_1_in1 = 'd0;
                    mult_11x23_1_in2 = 'd0;
                end
                'd10 : begin
                    mult_11x23_0_in1 = matrix_reg[0];
                    mult_11x23_0_in2 = sub_22_out_reg[1];
                    mult_11x23_1_in1 = matrix_reg[0];
                    mult_11x23_1_in2 = sub_22_out_reg[4];
                end
                'd11 : begin
                    mult_11x23_0_in1 = matrix_reg[0];
                    mult_11x23_0_in2 = sub_22_out_reg[0];
                    mult_11x23_1_in1 = matrix_reg[0];
                    mult_11x23_1_in2 = sub_22_out_reg[3];
                end
                'd12 : begin
                    mult_11x23_0_in1 = 'd0;
                    mult_11x23_0_in2 = 'd0;
                    mult_11x23_1_in1 = matrix_reg[0];
                    mult_11x23_1_in2 = sub_22_out_reg[2];
                end
                'd13: begin
                    mult_11x23_0_in1 = matrix_reg[0];
                    mult_11x23_0_in2 = sub_22_out_reg[3];
                    mult_11x23_1_in1 = 'd0;
                    mult_11x23_1_in2 = 'd0;
                end
                'd14 : begin
                    mult_11x23_0_in1 = matrix_reg[0];
                    mult_11x23_0_in2 = sub_22_out_reg[1];
                    mult_11x23_1_in1 = matrix_reg[0];
                    mult_11x23_1_in2 = sub_22_out_reg[5];
                end
                'd15 : begin
                    mult_11x23_0_in1 = matrix_reg[0];
                    mult_11x23_0_in2 = sub_22_out_reg[0];
                    mult_11x23_1_in1 = matrix_reg[0];
                    mult_11x23_1_in2 = sub_22_out_reg[4];
                end
                'd0 : begin
                    mult_11x23_0_in1 = 'd0;
                    mult_11x23_0_in2 = 'd0;
                    mult_11x23_1_in1 = matrix_reg[0];
                    mult_11x23_1_in2 = sub_22_out_reg[3];
                end
                default : begin
                    mult_11x23_0_in1 = 'd0;
                    mult_11x23_0_in2 = 'd0;
                    mult_11x23_1_in1 = 'd0;
                    mult_11x23_1_in2 = 'd0;
                end
            endcase
        end
        MATRIX_SIZE_4 : begin
            case(count)
                'd9 : begin
                    mult_11x23_0_in1 = matrix_reg[0];
                    mult_11x23_0_in2 = sub_22_out_reg[5];
                    mult_11x23_1_in1 = matrix_reg[0];
                    mult_11x23_1_in2 = sub_22_out_reg[4];
                end
                'd10 : begin
                    mult_11x23_0_in1 = matrix_reg[0];
                    mult_11x23_0_in2 = sub_22_out_reg[5];
                    mult_11x23_1_in1 = matrix_reg[0];
                    mult_11x23_1_in2 = sub_22_out_reg[3];
                end
                'd11 : begin
                    mult_11x23_0_in1 = matrix_reg[0];
                    mult_11x23_0_in2 = sub_22_out_reg[4];
                    mult_11x23_1_in1 = matrix_reg[0];
                    mult_11x23_1_in2 = sub_22_out_reg[3];
                end
                'd12 : begin
                    mult_11x23_0_in1 = matrix_reg[0];
                    mult_11x23_0_in2 = sub_22_out_reg[2];
                    mult_11x23_1_in1 = matrix_reg[0];
                    mult_11x23_1_in2 = sub_22_out_reg[1];
                end
                default : begin
                    mult_11x23_0_in1 = 'd0;
                    mult_11x23_0_in2 = 'd0;
                    mult_11x23_1_in1 = 'd0;
                    mult_11x23_1_in2 = 'd0;
                end
            endcase
        end
        default : begin
            mult_11x23_0_in1 = 'd0;
            mult_11x23_0_in2 = 'd0;
            mult_11x23_1_in1 = 'd0;
            mult_11x23_1_in2 = 'd0;
        end
    endcase
end

always @(*) begin
    case(in_mode_reg)
        MATRIX_SIZE_2 : begin
            mult_11x34_in1 = 'd0;
            mult_11x34_in2 = 'd0;
        end
        MATRIX_SIZE_3 : begin
            case(count)
                'd5 : begin
                    mult_11x34_in1 = 'd0;
                    mult_11x34_in2 = matrix_reg[0];
                end
                'd6 : begin
                    mult_11x34_in1 = matrix_reg[2];
                    mult_11x34_in2 = matrix_reg[0];
                end
                'd7 : begin
                    mult_11x34_in1 = matrix_reg[3];
                    mult_11x34_in2 = matrix_reg[0];
                end
                'd8 : begin
                    mult_11x34_in1 = 'd0;
                    mult_11x34_in2 = matrix_reg[0];
                end
                'd9 : begin
                    mult_11x34_in1 = 'd0;
                    mult_11x34_in2 = matrix_reg[0];
                end
                'd10: begin
                    mult_11x34_in1 = matrix_reg[2];
                    mult_11x34_in2 = matrix_reg[0];
                end
                'd11: begin
                    mult_11x34_in1 = matrix_reg[3];
                    mult_11x34_in2 = matrix_reg[0];
                end
                'd12: begin
                    mult_11x34_in1 = 'd0;
                    mult_11x34_in2 = matrix_reg[0];
                end
                default : begin
                    mult_11x34_in1 = 'd0;
                    mult_11x34_in2 = 'd0;
                end
            endcase
        end
        MATRIX_SIZE_4 : begin
            case(count)
                'd5 : begin
                    mult_11x34_in1 = matrix_reg[1];
                    mult_11x34_in2 = matrix_reg[0];
                end
                'd6 : begin
                    mult_11x34_in1 = matrix_reg[2];
                    mult_11x34_in2 = matrix_reg[0];
                end
                'd7 : begin
                    mult_11x34_in1 = matrix_reg[3];
                    mult_11x34_in2 = matrix_reg[0];
                end
                'd8 : begin
                    mult_11x34_in1 = matrix_reg[5];
                    mult_11x34_in2 = matrix_reg[0];
                end
                'd9 : begin
                    mult_11x34_in1 = matrix_reg[0];
                    mult_11x34_in2 = sub_22_out_reg[2];
                end
                'd10 : begin
                    mult_11x34_in1 = matrix_reg[0];
                    mult_11x34_in2 = sub_22_out_reg[1];
                end
                'd11 : begin
                    mult_11x34_in1 = matrix_reg[0];
                    mult_11x34_in2 = sub_22_out_reg[0];
                end
                'd12 : begin
                    mult_11x34_in1 = matrix_reg[0];
                    mult_11x34_in2 = sub_22_out_reg[0];
                end
                'd13 : begin
                    mult_11x34_in1 = matrix_reg[0];
                    mult_11x34_in2 = mult_11x23_out_reg[0];
                end
                'd14 : begin
                    mult_11x34_in1 = matrix_reg[0];
                    mult_11x34_in2 = mult_11x23_out_reg[1];
                end
                'd15 : begin
                    mult_11x34_in1 = matrix_reg[0];
                    mult_11x34_in2 = mult_11x23_out_reg[2];
                end
                'd0 : begin
                    mult_11x34_in1 = matrix_reg[0];
                    mult_11x34_in2 = mult_11x23_out_reg[3];
                end
                default : begin
                    mult_11x34_in1 = 'd0;
                    mult_11x34_in2 = 'd0;
                end
            endcase
        end
        default : begin
            mult_11x34_in1 = 'd0;
            mult_11x34_in2 = 'd0;
        end
    endcase
end


always @(*) begin
    case(in_mode_reg)
        MATRIX_SIZE_2 : begin
            add_34_0_in1 = 'd0;
            add_34_0_in2 = 'd0;
            add_34_1_in1 = 'd0;
            add_34_1_in2 = 'd0;
        end
        MATRIX_SIZE_3 : begin
            case(count)
                'd10 : begin
                    add_34_0_in1 = mult_11x23_out_reg[0];
                    add_34_0_in2 = ~mult_11x23_0_out + 'd1;
                    add_34_1_in1 = 'd0;
                    add_34_1_in2 = 'd0;
                end
                'd11 : begin
                    add_34_0_in1 = mult_11x23_out_reg[0];
                    add_34_0_in2 = mult_11x23_0_out;
                    add_34_1_in1 = mult_11x23_out_reg[1];
                    add_34_1_in2 = ~mult_11x23_1_out + 'd1;
                end
                'd12 : begin
                    add_34_0_in1 = 'd0;
                    add_34_0_in2 = 'd0;
                    add_34_1_in1 = mult_11x23_out_reg[1];
                    add_34_1_in2 = mult_11x23_1_out;
                end
                'd14 : begin
                    add_34_0_in1 = mult_11x23_out_reg[2];
                    add_34_0_in2 = ~mult_11x23_0_out + 'd1;
                    add_34_1_in1 = 'd0;
                    add_34_1_in2 = 'd0;
                end
                'd15 : begin
                    add_34_0_in1 = mult_11x23_out_reg[2];
                    add_34_0_in2 = mult_11x23_0_out;
                    add_34_1_in1 = mult_11x23_out_reg[3];
                    add_34_1_in2 = ~mult_11x23_1_out + 'd1;
                end
                'd15 : begin
                    add_34_0_in1 = 'd0;
                    add_34_0_in2 = 'd0;
                    add_34_1_in1 = mult_11x23_out_reg[3];
                    add_34_1_in2 = mult_11x23_1_out;
                end
                'd0 : begin
                    add_34_0_in1 = 'd0;
                    add_34_0_in2 = 'd0;
                    add_34_1_in1 = mult_11x23_out_reg[3];
                    add_34_1_in2 = mult_11x23_1_out;
                end
                default : begin
                    add_34_0_in1 = 'd0;
                    add_34_0_in2 = 'd0;
                    add_34_1_in1 = 'd0;
                    add_34_1_in2 = 'd0;
                end
            endcase
        end
        MATRIX_SIZE_4 : begin
            case(count)
                'd10 : begin
                    add_34_0_in1 = mult_11x23_out_reg[2];
                    add_34_0_in2 = ~mult_11x23_1_out + 'd1;
                    add_34_1_in1 = mult_11x23_out_reg[3];
                    add_34_1_in2 = ~mult_11x34_out + 'd1;
                end
                'd11 : begin
                    add_34_0_in1 = mult_11x23_out_reg[0];
                    add_34_0_in2 = ~mult_11x23_0_out + 'd1;
                    add_34_1_in1 = mult_11x23_out_reg[1];
                    add_34_1_in2 = ~mult_11x23_1_out + 'd1;
                end
                'd12 : begin
                    add_34_0_in1 = mult_11x23_out_reg[0];
                    add_34_0_in2 = mult_11x23_0_out;
                    add_34_1_in1 = mult_11x23_out_reg[1];
                    add_34_1_in2 = mult_11x23_1_out;
                end
                default : begin
                    add_34_0_in1 = 'd0;
                    add_34_0_in2 = 'd0;
                    add_34_1_in1 = 'd0;
                    add_34_1_in2 = 'd0;
                end
            endcase
        end
        default : begin
            add_34_0_in1 = 'd0;
            add_34_0_in2 = 'd0;
            add_34_1_in1 = 'd0;
            add_34_1_in2 = 'd0;
        end
    endcase
end

always @(*) begin
    case(in_mode_reg)
        MATRIX_SIZE_2 : begin
            add_45_in1 = 'd0;
            add_45_in2 = 'd0;
        end
        MATRIX_SIZE_3 : begin
            case(count)
                'd7 : begin
                    add_45_in1 = 'd0;
                    add_45_in2 = 'd0;
                end
                'd8 : begin
                    add_45_in1 = mult_out_reg[6];
                    add_45_in2 = $signed(-mult_out_reg[3]);
                end
                'd9 : begin
                    add_45_in1 = mult_out_reg[9];
                    add_45_in2 = $signed(-mult_out_reg[7]);
                end
                'd11: begin
                    add_45_in1 = 'd0;
                    add_45_in2 = 'd0;
                end
                'd12: begin
                    add_45_in1 = mult_out_reg[4];
                    add_45_in2 = $signed(-mult_out_reg[1]);
                end
                'd13: begin
                    add_45_in1 = mult_out_reg[7];
                    add_45_in2 = $signed(-mult_out_reg[5]);
                end
                default : begin
                    add_45_in1 = 'd0;
                    add_45_in2 = 'd0;
                end
            endcase
        end
        MATRIX_SIZE_4 : begin
            case(count)
                'd6 : begin
                    add_45_in1 = 'd0;
                    add_45_in2 = 'd0;
                end
                'd7 : begin
                    add_45_in1 = mult_11x11_1_out;
                    add_45_in2 = $signed(-mult_out_reg[4]);
                end
                'd8 : begin
                    add_45_in1 = mult_11x34_out;
                    add_45_in2 = $signed(-mult_out_reg[8]);
                end
                'd9 : begin
                    add_45_in1 = 'd0;
                    add_45_in2 = 'd0;
                end

                'd11 : begin
                    add_45_in1 = mult_11x23_out_reg[3];
                    add_45_in2 = mult_11x34_out;
                end
                'd12 : begin
                    add_45_in1 = mult_11x23_out_reg[2];
                    add_45_in2 = mult_11x34_out;
                end
                'd13 : begin
                    add_45_in1 = 'd0;
                    add_45_in2 = ~mult_11x34_out + 'd1;
                end
                'd14 : begin
                    add_45_in1 = final_out_reg;
                    add_45_in2 = mult_11x34_out;
                end
                'd15 : begin
                    add_45_in1 = final_out_reg;
                    add_45_in2 = ~mult_11x34_out + 'd1;
                end
                'd0 : begin
                    add_45_in1 = final_out_reg;
                    add_45_in2 = mult_11x34_out;
                end
                default : begin
                    add_45_in1 = 'd0;
                    add_45_in2 = 'd0;
                end
            endcase
        end
        default : begin
            add_45_in1 = 'd0;
            add_45_in2 = 'd0;
        end
    endcase
end

// input buffer
always @(posedge clk) begin
    if (in_valid & count == 'd0) begin
        in_mode_reg <= in_mode_decoded;
    end
end

always @(posedge clk) begin
    if (in_valid) begin
        matrix_reg[0] <= in_data_decoded;
        matrix_reg[1] <= matrix_reg[0];
        matrix_reg[2] <= matrix_reg[1];
        matrix_reg[3] <= matrix_reg[2];
        matrix_reg[4] <= matrix_reg[3];
        matrix_reg[5] <= matrix_reg[4];
        matrix_reg[6] <= matrix_reg[5];
        matrix_reg[7] <= matrix_reg[6];
    end
end

// pipelined regs
always @(posedge clk) begin
    case(in_mode_reg)
        MATRIX_SIZE_2 : begin
            case(count)
                'd6 : sub_22_out_reg[0] <= sub_22_0_out;
                'd7 : sub_22_out_reg[1] <= sub_22_0_out;
                'd8 : sub_22_out_reg[2] <= sub_22_0_out;
                'd10: sub_22_out_reg[3] <= sub_22_0_out;
                'd11: sub_22_out_reg[4] <= sub_22_0_out;
                'd12: sub_22_out_reg[5] <= sub_22_0_out;
                'd14: sub_22_out_reg[6] <= sub_22_0_out;
                'd15: sub_22_out_reg[7] <= sub_22_0_out;
                'd0 : sub_22_out_reg[8] <= sub_22_0_out;
            endcase
        end
        MATRIX_SIZE_3 : begin
            case(count)
                'd7 : begin
                    sub_22_out_reg[0] <= sub_22_0_out;
                end
                'd8 : begin
                    sub_22_out_reg[1] <= sub_22_0_out;
                    sub_22_out_reg[2] <= add_45_out;
                end
                'd9 : begin
                    sub_22_out_reg[3] <= sub_22_0_out;
                    sub_22_out_reg[4] <= add_45_out;
                end
                'd11: begin
                    sub_22_out_reg[0] <= sub_22_0_out;
                end
                'd12: begin
                    sub_22_out_reg[1] <= sub_22_0_out;
                    sub_22_out_reg[3] <= add_45_out;
                end
                'd13: begin
                    sub_22_out_reg[4] <= sub_22_0_out;
                    sub_22_out_reg[5] <= add_45_out;
                end
            endcase
        end
        MATRIX_SIZE_4 : begin
            case(count)
                'd6 : begin
                    sub_22_out_reg[0] <= sub_22_0_out;
                end
                'd7 : begin
                    sub_22_out_reg[1] <= sub_22_0_out;
                    sub_22_out_reg[2] <= add_45_out;
                end
                'd8 : begin
                    sub_22_out_reg[4] <= sub_22_0_out;
                    sub_22_out_reg[5] <= add_45_out;
                end
                'd9 : begin
                    sub_22_out_reg[3] <= sub_22_0_out;
                end
            endcase
        end
    endcase
end

always @(posedge clk) begin
    case(in_mode_reg)
        MATRIX_SIZE_3 : begin
            case(count)
                'd5 : begin
                    mult_out_reg[0] <= mult_11x11_0_out;
                    mult_out_reg[1] <= mult_11x11_1_out;
                end
                'd6 : begin
                    mult_out_reg[2] <= mult_11x11_0_out;
                    mult_out_reg[3] <= mult_11x11_1_out;
                    mult_out_reg[4] <= mult_11x34_out;
                end
                'd7 : begin
                    mult_out_reg[5] <= mult_11x11_0_out;
                    mult_out_reg[6] <= mult_11x11_1_out;
                    mult_out_reg[7] <= mult_11x34_out;
                end
                'd8 : begin
                    mult_out_reg[8] <= mult_11x11_0_out;
                    mult_out_reg[9] <= mult_11x11_1_out;
                end
                'd9 : begin
                    mult_out_reg[10] <= mult_11x11_0_out;
                    mult_out_reg[11] <= mult_11x11_1_out;
                end
                'd10: begin
                    mult_out_reg[0] <= mult_11x11_0_out;
                    mult_out_reg[1] <= mult_11x11_1_out;
                    mult_out_reg[2] <= mult_11x34_out;
                end
                'd11: begin
                    mult_out_reg[3] <= mult_11x11_0_out;
                    mult_out_reg[4] <= mult_11x11_1_out;
                    mult_out_reg[5] <= mult_11x34_out;
                end
                'd12: begin
                    mult_out_reg[6] <= mult_11x11_0_out;
                    mult_out_reg[7] <= mult_11x11_1_out;
                end
            endcase
        end
        MATRIX_SIZE_4 : begin
            case(count)
                'd5 : begin
                    mult_out_reg[0] <= mult_11x11_0_out;
                    mult_out_reg[1] <= mult_11x11_1_out;
                    mult_out_reg[2] <= mult_11x34_out;
                end
                'd6 : begin
                    mult_out_reg[3] <= mult_11x11_0_out;
                    mult_out_reg[4] <= mult_11x11_1_out;
                    mult_out_reg[5] <= mult_11x34_out;
                end
                'd7 : begin
                    mult_out_reg[6] <= mult_11x11_0_out;
                    mult_out_reg[7] <= mult_11x11_1_out;
                    mult_out_reg[8] <= mult_11x34_out;
                end
                'd8 : begin
                    mult_out_reg[9] <= mult_11x11_0_out;
                    mult_out_reg[10]<= mult_11x11_1_out;
                    mult_out_reg[11]<= mult_11x34_out;
                end
            endcase
        end
    endcase
end

always @(posedge clk) begin
    case(in_mode_reg)
        MATRIX_SIZE_3 : begin
            case(count)
                'd9 : begin
                    mult_11x23_out_reg[0] <= mult_11x23_0_out;
                    mult_11x23_out_reg[1] <= 'd0;
                end
                'd10 : begin
                    mult_11x23_out_reg[0] <= add_34_0_out;
                    mult_11x23_out_reg[1] <= mult_11x23_1_out;
                end
                'd11 : begin
                    mult_11x23_out_reg[0] <= add_34_0_out;
                    mult_11x23_out_reg[1] <= add_34_1_out;
                end
                'd12 : begin
                    mult_11x23_out_reg[0] <= mult_11x23_out_reg[0];
                    mult_11x23_out_reg[1] <= add_34_1_out;
                end
                'd13: begin
                    mult_11x23_out_reg[2] <= mult_11x23_0_out;
                    mult_11x23_out_reg[3] <= 'd0;
                end
                'd14 : begin
                    mult_11x23_out_reg[2] <= add_34_0_out;
                    mult_11x23_out_reg[3] <= mult_11x23_1_out;
                end
                'd15 : begin
                    mult_11x23_out_reg[2] <= add_34_0_out;
                    mult_11x23_out_reg[3] <= add_34_1_out;
                end
                'd0 : begin
                    mult_11x23_out_reg[2] <= mult_11x23_out_reg[2];
                    mult_11x23_out_reg[3] <= add_34_1_out;
                end
            endcase
        end
        MATRIX_SIZE_4 : begin
            case(count)
                'd9 : begin
                    mult_11x23_out_reg[0] <= 'd0;
                    mult_11x23_out_reg[1] <= mult_11x23_0_out;
                    mult_11x23_out_reg[2] <= mult_11x23_1_out;
                    mult_11x23_out_reg[3] <= mult_11x34_out;
                end
                'd10 : begin
                    mult_11x23_out_reg[0] <= mult_11x23_0_out;
                    mult_11x23_out_reg[1] <= mult_11x23_out_reg[1];
                    mult_11x23_out_reg[2] <= add_34_0_out;
                    mult_11x23_out_reg[3] <= add_34_1_out;
                end
                'd11 : begin
                    mult_11x23_out_reg[0] <= add_34_0_out;
                    mult_11x23_out_reg[1] <= add_34_1_out;
                    mult_11x23_out_reg[2] <= mult_11x23_out_reg[2];
                    mult_11x23_out_reg[3] <= add_45_out;
                end
                'd12 : begin
                    mult_11x23_out_reg[0] <= add_34_0_out;
                    mult_11x23_out_reg[1] <= add_34_1_out;
                    mult_11x23_out_reg[2] <= add_45_out;
                    mult_11x23_out_reg[3] <= mult_11x23_out_reg[3];
                end
            endcase
        end
    endcase
end

always @(posedge clk) begin
    final_out_reg <= add_45_out;
end


// counter
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		count <= 'd0;
	end
	else if (in_valid | state == DIN) begin
		count <= count + 'd1;
	end
	else if (state == DOUT) begin
		count <= 'd0;
	end
end

// output
reg signed [206:0] final_out_signed;
always @(*) begin
    case(in_mode_reg)
        MATRIX_SIZE_2 : final_out_signed = {sub_22_out_reg[0], sub_22_out_reg[1], sub_22_out_reg[2], sub_22_out_reg[3], sub_22_out_reg[4], sub_22_out_reg[5], sub_22_out_reg[6], sub_22_out_reg[7], sub_22_out_reg[8]};
        MATRIX_SIZE_3 : final_out_signed = {3'd0, {17{mult_11x23_out_reg[0][33]}}, mult_11x23_out_reg[0], {17{mult_11x23_out_reg[1][33]}}, mult_11x23_out_reg[1], {17{mult_11x23_out_reg[2][33]}}, mult_11x23_out_reg[2], {17{mult_11x23_out_reg[3][33]}}, mult_11x23_out_reg[3]};
        MATRIX_SIZE_4 : final_out_signed = {{162{final_out_reg[44]}}, final_out_reg};
        default : final_out_signed = 'd0;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out_valid <= 1'b0;
    end
    else if(state == DIN & count == 'd0) begin
        out_valid <= 1'b1;
    end
    else begin
        out_valid <= 1'b0;
    end
end

always @(*) begin
    if (out_valid) begin
        out_data = final_out_signed;
    end
    else begin
        out_data = 'd0;
    end
end

// IP
HAMMING_IP #(.IP_BIT(5))  HAMMING_IP_mode (.IN_code(in_mode), .OUT_code(in_mode_decoded));
HAMMING_IP #(.IP_BIT(11)) HAMMING_IP_data (.IN_code(in_data), .OUT_code(in_data_decoded));

// mult & add
mult_11x11 mult_11x11_0 (.in1(mult_11x11_0_in1), .in2(mult_11x11_0_in2), .result(mult_11x11_0_out));
mult_11x11 mult_11x11_1 (.in1(mult_11x11_1_in1), .in2(mult_11x11_1_in2), .result(mult_11x11_1_out));

sub_22 sub_22_0 (.in1(sub_22_0_in1), .in2(sub_22_0_in2), .result(sub_22_0_out));

mult_11x23 mult_11x23_0 (.in1(mult_11x23_0_in1), .in2(mult_11x23_0_in2), .result(mult_11x23_0_out));
mult_11x23 mult_11x23_1 (.in1(mult_11x23_1_in1), .in2(mult_11x23_1_in2), .result(mult_11x23_1_out));

mult_11x34 mult_11x34_0 (.in1(mult_11x34_in1), .in2(mult_11x34_in2), .result(mult_11x34_out));

add_34 add_34_0 (.in1(add_34_0_in1), .in2(add_34_0_in2), .result(add_34_0_out));
add_34 add_34_1 (.in1(add_34_1_in1), .in2(add_34_1_in2), .result(add_34_1_out));

add_45 add_45_0 (.in1(add_45_in1), .in2(add_45_in2), .result (add_45_out));

endmodule


module mult_11x11 (
    input signed [10:0] in1, in2,
    output signed [21:0] result
);

assign result = in1 * in2;

endmodule


module mult_11x23 (
    input signed [10:0] in1, 
    input signed [22:0] in2,
    output signed [33:0] result
);

assign result = in1 * in2;

endmodule


module mult_11x34 (
    input  signed [10:0] in1, 
    input  signed [33:0] in2,
    output signed [44:0] result
);

assign result = in1 * in2;

endmodule


module sub_22 (
    input  signed [21:0] in1, in2,
    output signed [22:0] result
);

assign result = in1 - in2;

endmodule


module add_34 (
    input  signed [33:0] in1, 
    input  signed [33:0] in2,
    output signed [33:0] result
);

assign result = in1 + in2;

endmodule


module add_45 (
    input  signed [44:0] in1, 
    input  signed [44:0] in2,
    output signed [44:0] result
);

assign result = in1 + in2;

endmodule
