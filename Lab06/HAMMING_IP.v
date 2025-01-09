//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//    (C) Copyright System Integration and Silicon Implementation Laboratory
//    All Right Reserved
//		Date		: 2024/10
//		Version		: v1.0
//   	File Name   : HAMMING_IP.v
//   	Module Name : HAMMING_IP
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################
module HAMMING_IP #(parameter IP_BIT = 11) (
    // Input signals
    IN_code,
    // Output signals
    OUT_code
);

// ===============================================================
// Input & Output
// ===============================================================
input [IP_BIT+4-1:0] IN_code;
output [IP_BIT-1:0]  OUT_code;

// ===============================================================
// Design
// ===============================================================
genvar i, j;

wire [IP_BIT+4:1] in_reverse;
wire [3:0] xor_in [1:IP_BIT+4];
wire [3:0] xor_accum [1:IP_BIT+4];
wire [3:0] xor_result = xor_accum[IP_BIT+4];
wire [IP_BIT+4:1] out_wire;
wire [IP_BIT-1:0] out_temp_wire;

assign xor_accum[1] = xor_in[1];

assign out_wire[1] = in_reverse[1];  // check
assign out_wire[2] = in_reverse[2];  // check
assign out_wire[4] = in_reverse[4];  // check
assign out_wire[8] = in_reverse[8];  // check

assign out_temp_wire[0] = out_wire[3];
assign out_temp_wire[1] = out_wire[5];
assign out_temp_wire[2] = out_wire[6];
assign out_temp_wire[3] = out_wire[7];

generate
    for (i = 1; i <= IP_BIT+4; i = i + 1) begin : reverse_loop
        assign in_reverse[i] = IN_code[IP_BIT+4-i];
    end
endgenerate

generate
    for (i = 1; i <= IP_BIT+4; i = i + 1) begin : xor_in_gen
        assign xor_in[i] = in_reverse[i] ? i[3:0] : 4'd0;
    end
endgenerate

generate
    for (i = 2; i <= IP_BIT+4; i = i + 1) begin : xor_accum_gen
        assign xor_accum[i] = xor_accum[i-1] ^ xor_in[i];
    end
endgenerate

generate
    for (i = 1; i <= IP_BIT+4; i = i + 1) begin : out_wire_gen
        if (i != 1 && i != 2 && i != 4 && i != 8) begin
            assign out_wire[i] = (xor_result == i[3:0]) ? ~in_reverse[i] : in_reverse[i];
        end
    end
endgenerate

generate
    for (i = 9; i <= IP_BIT+4; i = i + 1) begin : out_temp_wire_gen
        assign out_temp_wire[i-5] = out_wire[i];
    end
endgenerate

generate
    for (i = 0; i < IP_BIT; i = i + 1) begin : out_gen
        assign OUT_code[i] = out_temp_wire[IP_BIT-1-i];
    end
endgenerate


/*
wire [IP_BIT+4:1] in_reverse;
assign in_reverse[1]  = IN_code[14];
assign in_reverse[2]  = IN_code[13];
assign in_reverse[3]  = IN_code[12];
assign in_reverse[4]  = IN_code[11];
assign in_reverse[5]  = IN_code[10];
assign in_reverse[6]  = IN_code[9];
assign in_reverse[7]  = IN_code[8];
assign in_reverse[8]  = IN_code[7];
assign in_reverse[9]  = IN_code[6];
assign in_reverse[10] = IN_code[5];
assign in_reverse[11] = IN_code[4];
assign in_reverse[12] = IN_code[3];
assign in_reverse[13] = IN_code[2];
assign in_reverse[14] = IN_code[1];
assign in_reverse[15] = IN_code[0];

wire [3:0] xor_in [1:IP_BIT+4];
assign xor_in[1]  = in_reverse[1]  ? 4'd1  : 4'd0;
assign xor_in[2]  = in_reverse[2]  ? 4'd2  : 4'd0;
assign xor_in[3]  = in_reverse[3]  ? 4'd3  : 4'd0;
assign xor_in[4]  = in_reverse[4]  ? 4'd4  : 4'd0;
assign xor_in[5]  = in_reverse[5]  ? 4'd5  : 4'd0;
assign xor_in[6]  = in_reverse[6]  ? 4'd6  : 4'd0;
assign xor_in[7]  = in_reverse[7]  ? 4'd7  : 4'd0;
assign xor_in[8]  = in_reverse[8]  ? 4'd8  : 4'd0;
assign xor_in[9]  = in_reverse[9]  ? 4'd9  : 4'd0;
assign xor_in[10] = in_reverse[10] ? 4'd10 : 4'd0;
assign xor_in[11] = in_reverse[11] ? 4'd11 : 4'd0;
assign xor_in[12] = in_reverse[12] ? 4'd12 : 4'd0;
assign xor_in[13] = in_reverse[13] ? 4'd13 : 4'd0;
assign xor_in[14] = in_reverse[14] ? 4'd14 : 4'd0;
assign xor_in[15] = in_reverse[15] ? 4'd15 : 4'd0;

wire [3:0] xor_result;
assign xor_result = xor_in[1]  ^ xor_in[2]  ^ xor_in[3]  ^ xor_in[4]  ^ 
                    xor_in[5]  ^ xor_in[6]  ^ xor_in[7]  ^ xor_in[8]  ^ 
                    xor_in[9]  ^ xor_in[10] ^ xor_in[11] ^ xor_in[12] ^ 
                    xor_in[13] ^ xor_in[14] ^ xor_in[15];

wire [IP_BIT+4:1] out_wire;
assign out_wire[1] = in_reverse[1];  // check
assign out_wire[2] = in_reverse[2];  // check
assign out_wire[4] = in_reverse[4];  // check
assign out_wire[8] = in_reverse[8];  // check

assign out_wire[3]  = (xor_result == 4'd3)  ? ~in_reverse[3]  : in_reverse[3];
assign out_wire[5]  = (xor_result == 4'd5)  ? ~in_reverse[5]  : in_reverse[5];
assign out_wire[6]  = (xor_result == 4'd6)  ? ~in_reverse[6]  : in_reverse[6];
assign out_wire[7]  = (xor_result == 4'd7)  ? ~in_reverse[7]  : in_reverse[7];
assign out_wire[9]  = (xor_result == 4'd9)  ? ~in_reverse[9]  : in_reverse[9];
assign out_wire[10] = (xor_result == 4'd10) ? ~in_reverse[10] : in_reverse[10];
assign out_wire[11] = (xor_result == 4'd11) ? ~in_reverse[11] : in_reverse[11];
assign out_wire[12] = (xor_result == 4'd12) ? ~in_reverse[12] : in_reverse[12];
assign out_wire[13] = (xor_result == 4'd13) ? ~in_reverse[13] : in_reverse[13];
assign out_wire[14] = (xor_result == 4'd14) ? ~in_reverse[14] : in_reverse[14];
assign out_wire[15] = (xor_result == 4'd15) ? ~in_reverse[15] : in_reverse[15];

wire [IP_BIT-1:0] out_temp_wire;
assign out_temp_wire[0]  = out_wire[3];
assign out_temp_wire[1]  = out_wire[5];
assign out_temp_wire[2]  = out_wire[6];
assign out_temp_wire[3]  = out_wire[7];
assign out_temp_wire[4]  = out_wire[9];
assign out_temp_wire[5]  = out_wire[10];
assign out_temp_wire[6]  = out_wire[11];
assign out_temp_wire[7]  = out_wire[12];
assign out_temp_wire[8]  = out_wire[13];
assign out_temp_wire[9]  = out_wire[14];
assign out_temp_wire[10] = out_wire[15];

assign OUT_code[10] = out_temp_wire[0];
assign OUT_code[9]  = out_temp_wire[1];
assign OUT_code[8]  = out_temp_wire[2];
assign OUT_code[7]  = out_temp_wire[3];
assign OUT_code[6]  = out_temp_wire[4];
assign OUT_code[5]  = out_temp_wire[5];
assign OUT_code[4]  = out_temp_wire[6];
assign OUT_code[3]  = out_temp_wire[7];
assign OUT_code[2]  = out_temp_wire[8];
assign OUT_code[1]  = out_temp_wire[9];
assign OUT_code[0]  = out_temp_wire[10];
*/


endmodule

