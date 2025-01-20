//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2024 Fall
//   Lab01 Exercise		: Snack Shopping Calculator
//   Author     		  : Yu-Hsiang Wang
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : SSC.v
//   Module Name : SSC
//   Release version : V1.0 (Release Date: 2024-09)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module SSC(
    // Input signals
    card_num,
    input_money,
    snack_num,
    price, 
    // Output signals
    out_valid,
    out_change
);

//================================================================
//   INPUT AND OUTPUT DECLARATION                         
//================================================================
input [63:0] card_num;
input [8:0] input_money;
input [31:0] snack_num;
input [31:0] price;
output out_valid;
output [8:0] out_change;    

//================================================================
//   SUBMODULE INSTANTIATION                         
//================================================================
Find_out_valid Find_out_valid_inst (
    .card_num   (card_num   ), 
    .out_valid  (out_valid  )
);
Find_out_change Find_out_change_inst (
    .card_num   (card_num   ),
    .input_money(input_money),
    .snack_num  (snack_num  ),
    .price      (price      ),
    .out_valid  (out_valid  ),
    .out_change (out_change )
);
endmodule


module Find_out_valid (
    input  [63:0] card_num,
    output        out_valid
);
//================================================================
//    Wire & Registers 
//================================================================
wire        [3:0]   card_num_even       [0:7]; 
wire        [3:0]   card_num_odd        [0:7];
wire        [4:0]   card_num_odd_mult_2 [0:7];
wire        [3:0]   card_num_odd_final  [0:7];
wire        [7:0]   sum;
//================================================================
//    DESIGN
//================================================================
assign card_num_even[0] = card_num[3:0];    assign card_num_odd [0] = card_num[7:4];
assign card_num_even[1] = card_num[11:8];   assign card_num_odd [1] = card_num[15:12];
assign card_num_even[2] = card_num[19:16];  assign card_num_odd [2] = card_num[23:20];
assign card_num_even[3] = card_num[27:24];  assign card_num_odd [3] = card_num[31:28];
assign card_num_even[4] = card_num[35:32];  assign card_num_odd [4] = card_num[39:36];
assign card_num_even[5] = card_num[43:40];  assign card_num_odd [5] = card_num[47:44];
assign card_num_even[6] = card_num[51:48];  assign card_num_odd [6] = card_num[55:52];
assign card_num_even[7] = card_num[59:56];  assign card_num_odd [7] = card_num[63:60];

assign card_num_odd_mult_2[0] = card_num_odd[0] << 1;
assign card_num_odd_mult_2[1] = card_num_odd[1] << 1;
assign card_num_odd_mult_2[2] = card_num_odd[2] << 1;
assign card_num_odd_mult_2[3] = card_num_odd[3] << 1;
assign card_num_odd_mult_2[4] = card_num_odd[4] << 1;
assign card_num_odd_mult_2[5] = card_num_odd[5] << 1;
assign card_num_odd_mult_2[6] = card_num_odd[6] << 1;
assign card_num_odd_mult_2[7] = card_num_odd[7] << 1;

assign card_num_odd_final[0] = (card_num_odd[0] > 4'd4) ? (card_num_odd_mult_2[0] - 5'd9) : card_num_odd_mult_2[0];
assign card_num_odd_final[1] = (card_num_odd[1] > 4'd4) ? (card_num_odd_mult_2[1] - 5'd9) : card_num_odd_mult_2[1];
assign card_num_odd_final[2] = (card_num_odd[2] > 4'd4) ? (card_num_odd_mult_2[2] - 5'd9) : card_num_odd_mult_2[2];
assign card_num_odd_final[3] = (card_num_odd[3] > 4'd4) ? (card_num_odd_mult_2[3] - 5'd9) : card_num_odd_mult_2[3];
assign card_num_odd_final[4] = (card_num_odd[4] > 4'd4) ? (card_num_odd_mult_2[4] - 5'd9) : card_num_odd_mult_2[4];
assign card_num_odd_final[5] = (card_num_odd[5] > 4'd4) ? (card_num_odd_mult_2[5] - 5'd9) : card_num_odd_mult_2[5];
assign card_num_odd_final[6] = (card_num_odd[6] > 4'd4) ? (card_num_odd_mult_2[6] - 5'd9) : card_num_odd_mult_2[6];
assign card_num_odd_final[7] = (card_num_odd[7] > 4'd4) ? (card_num_odd_mult_2[7] - 5'd9) : card_num_odd_mult_2[7];
/*
// LUT
MULT_ADJ MULT_ADJ_1  (.in(card_num_odd[0]), .out(card_num_odd_final[0]));
MULT_ADJ MULT_ADJ_3  (.in(card_num_odd[1]), .out(card_num_odd_final[1]));
MULT_ADJ MULT_ADJ_5  (.in(card_num_odd[2]), .out(card_num_odd_final[2]));
MULT_ADJ MULT_ADJ_7  (.in(card_num_odd[3]), .out(card_num_odd_final[3]));
MULT_ADJ MULT_ADJ_9  (.in(card_num_odd[4]), .out(card_num_odd_final[4]));
MULT_ADJ MULT_ADJ_11 (.in(card_num_odd[5]), .out(card_num_odd_final[5]));
MULT_ADJ MULT_ADJ_13 (.in(card_num_odd[6]), .out(card_num_odd_final[6]));
MULT_ADJ MULT_ADJ_15 (.in(card_num_odd[7]), .out(card_num_odd_final[7]));
*/
assign sum = card_num_even[0] + card_num_even[1] + card_num_even[2] + card_num_even[3] + 
             card_num_even[4] + card_num_even[5] + card_num_even[6] + card_num_even[7] +
             card_num_odd_final[0] + card_num_odd_final[1] + card_num_odd_final[2] + card_num_odd_final[3] +
             card_num_odd_final[4] + card_num_odd_final[5] + card_num_odd_final[6] + card_num_odd_final[7];

assign out_valid = (sum == 8'd0)  | (sum == 8'd10) | (sum == 8'd20) | (sum == 8'd30) | 
                   (sum == 8'd40) | (sum == 8'd50) | (sum == 8'd60) | (sum == 8'd70) | 
                   (sum == 8'd80) | (sum == 8'd90) | (sum == 8'd100)| (sum == 8'd110)| 
                   (sum == 8'd120)| (sum == 8'd130)| (sum == 8'd140);

// assign out_valid = (sum % 'd10) == 4'd0;
/*
reg [3:0] mod;
always @(*) begin
    case(1) // synopsys parallel_case
        (sum < 8'd10) : mod = sum;
        (sum >= 8'd10)  & (sum < 8'd20)  : mod = sum - 8'd10;
        (sum >= 8'd20)  & (sum < 8'd30)  : mod = sum - 8'd20;
        (sum >= 8'd30)  & (sum < 8'd40)  : mod = sum - 8'd30;
        (sum >= 8'd40)  & (sum < 8'd50)  : mod = sum - 8'd40;
        (sum >= 8'd50)  & (sum < 8'd60)  : mod = sum - 8'd50;
        (sum >= 8'd60)  & (sum < 8'd70)  : mod = sum - 8'd60;
        (sum >= 8'd70)  & (sum < 8'd80)  : mod = sum - 8'd70;
        (sum >= 8'd80)  & (sum < 8'd90)  : mod = sum - 8'd80;
        (sum >= 8'd90)  & (sum < 8'd100) : mod = sum - 8'd90;
        (sum >= 8'd100) & (sum < 8'd110) : mod = sum - 8'd100;
        (sum >= 8'd110) & (sum < 8'd120) : mod = sum - 8'd110;
        (sum >= 8'd120) & (sum < 8'd130) : mod = sum - 8'd120;
        (sum >= 8'd130) & (sum < 8'd140) : mod = sum - 8'd130;
        default : mod = sum - 8'd140;
    endcase
end
assign out_valid = mod == 4'd0;
*/
endmodule


module Find_out_change (
    input  [63:0] card_num,
    input  [8:0]  input_money,
    input  [31:0] snack_num,
    input  [31:0] price,
    input         out_valid,
    output [8:0]  out_change
);
//================================================================
//    Wire & Registers 
//================================================================
wire        [7:0]   snack_price         [0:7];
wire        [7:0]   price_sort          [0:7];
wire signed [9:0]   res_money           [0:7];
wire                more_than_input     [0:7];
wire        [8:0]   final_change;
//================================================================
//    DESIGN
//================================================================
assign snack_price[0] = snack_num[31:28] * price[31:28];
assign snack_price[1] = snack_num[27:24] * price[27:24];
assign snack_price[2] = snack_num[23:20] * price[23:20];
assign snack_price[3] = snack_num[19:16] * price[19:16];
assign snack_price[4] = snack_num[15:12] * price[15:12];
assign snack_price[5] = snack_num[11:8]  * price[11:8];
assign snack_price[6] = snack_num[7:4]   * price[7:4];
assign snack_price[7] = snack_num[3:0]   * price[3:0];

// sort
Sort_8 SORT_inst( .in_0(snack_price[0]), .in_1(snack_price[1]), .in_2(snack_price[2]), .in_3(snack_price[3]), 
                  .in_4(snack_price[4]), .in_5(snack_price[5]), .in_6(snack_price[6]), .in_7(snack_price[7]), 
                  .out_0(price_sort[0]), .out_1(price_sort[1]), .out_2(price_sort[2]), .out_3(price_sort[3]), 
                  .out_4(price_sort[4]), .out_5(price_sort[5]), .out_6(price_sort[6]), .out_7(price_sort[7]));

assign res_money[0] = input_money - price_sort[0];
assign res_money[1] = res_money[0] - price_sort[1];
assign res_money[2] = res_money[1] - price_sort[2];
assign res_money[3] = res_money[2] - price_sort[3];
assign res_money[4] = res_money[3] - price_sort[4];
assign res_money[5] = res_money[4] - price_sort[5];
assign res_money[6] = res_money[5] - price_sort[6];
assign res_money[7] = res_money[6] - price_sort[7];

assign more_than_input[0] = res_money[0][9];
assign more_than_input[1] = res_money[1][9] | more_than_input[0];
assign more_than_input[2] = res_money[2][9] | more_than_input[1];
assign more_than_input[3] = res_money[3][9] | more_than_input[2];
assign more_than_input[4] = res_money[4][9] | more_than_input[3];
assign more_than_input[5] = res_money[5][9] | more_than_input[4];
assign more_than_input[6] = res_money[6][9] | more_than_input[5];
assign more_than_input[7] = res_money[7][9] | more_than_input[6];

assign final_change = (~more_than_input[7]) ? res_money[7] : 
                      (~more_than_input[6]) ? res_money[6] : 
                      (~more_than_input[5]) ? res_money[5] : 
                      (~more_than_input[4]) ? res_money[4] : 
                      (~more_than_input[3]) ? res_money[3] : 
                      (~more_than_input[2]) ? res_money[2] : 
                      (~more_than_input[1]) ? res_money[1] : 
                      (~more_than_input[0]) ? res_money[0] : input_money;

assign out_change = out_valid ? final_change : input_money;

endmodule

/*
module MULT_ADJ (
  input      [3:0] in,
  output reg [3:0] out
);

always @(*) begin
    case(in) // synopsys parallel_case
        4'd5 : out = 4'd1;
        4'd6 : out = 4'd3;
        4'd7 : out = 4'd5;
        4'd8 : out = 4'd7;
        4'd9 : out = 4'd9;
        default : out = in << 1;
    endcase
end
endmodule
*/

// 18 comparators
module Sort_8(
    input  [7:0] in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7,
    output reg [7:0] out_1, out_2, out_3, out_4, out_5, out_6,
    output [7:0] out_0, out_7
);

wire [7:0] stage_1_a [0:3], stage_1_b [0:3];
wire [7:0] stage_2_a [0:1], stage_2_b [0:1], stage_2_c [0:1], stage_2_d [0:1];
wire [7:0] stage_3_a [0:1], stage_3_b [0:1];
//wire [7:0] stage_4_a [0:1], stage_4_b [0:1], stage_4_c [0:1];

Sort_4 SORT_A( .in_0(in_0), .in_1(in_1), .in_2(in_2), .in_3(in_3),
               .out_0(stage_1_a[0]), .out_1(stage_1_a[1]), .out_2(stage_1_a[2]), .out_3(stage_1_a[3]));

Sort_4 SORT_B( .in_0(in_4), .in_1(in_5), .in_2(in_6), .in_3(in_7),
               .out_0(stage_1_b[0]), .out_1(stage_1_b[1]), .out_2(stage_1_b[2]), .out_3(stage_1_b[3]));

assign stage_2_a[0] = (stage_1_a[0] > stage_1_b[0]) ? stage_1_a[0] : stage_1_b[0];
assign stage_2_a[1] = (stage_1_a[0] > stage_1_b[0]) ? stage_1_b[0] : stage_1_a[0];
assign stage_2_b[0] = (stage_1_a[1] > stage_1_b[1]) ? stage_1_a[1] : stage_1_b[1];
assign stage_2_b[1] = (stage_1_a[1] > stage_1_b[1]) ? stage_1_b[1] : stage_1_a[1];
assign stage_2_c[0] = (stage_1_a[2] > stage_1_b[2]) ? stage_1_a[2] : stage_1_b[2];
assign stage_2_c[1] = (stage_1_a[2] > stage_1_b[2]) ? stage_1_b[2] : stage_1_a[2];
assign stage_2_d[0] = (stage_1_a[3] > stage_1_b[3]) ? stage_1_a[3] : stage_1_b[3];
assign stage_2_d[1] = (stage_1_a[3] > stage_1_b[3]) ? stage_1_b[3] : stage_1_a[3];

assign stage_3_a[0] = (stage_2_a[1] > stage_2_c[0]) ? stage_2_a[1] : stage_2_c[0];
assign stage_3_a[1] = (stage_2_a[1] > stage_2_c[0]) ? stage_2_c[0] : stage_2_a[1];
assign stage_3_b[0] = (stage_2_b[1] > stage_2_d[0]) ? stage_2_b[1] : stage_2_d[0];
assign stage_3_b[1] = (stage_2_b[1] > stage_2_d[0]) ? stage_2_d[0] : stage_2_b[1];

//assign stage_4_a[0] = (stage_2_b[0] > stage_3_a[0]) ? stage_2_b[0] : stage_3_a[0];
//assign stage_4_a[1] = (stage_2_b[0] > stage_3_a[0]) ? stage_3_a[0] : stage_2_b[0];
//assign stage_4_b[0] = (stage_3_a[1] > stage_3_b[0]) ? stage_3_a[1] : stage_3_b[0];
//assign stage_4_b[1] = (stage_3_a[1] > stage_3_b[0]) ? stage_3_b[0] : stage_3_a[1];
//assign stage_4_c[0] = (stage_2_c[1] > stage_3_b[1]) ? stage_2_c[1] : stage_3_b[1];
//assign stage_4_c[1] = (stage_2_c[1] > stage_3_b[1]) ? stage_3_b[1] : stage_2_c[1];


always @(*) begin
    case(1) // synopsys parallel_case
        (stage_2_b[0] >= stage_2_a[1] & stage_2_b[0] >= stage_2_c[0]) : out_1 = stage_2_b[0];
        (stage_2_a[1] >= stage_2_b[0] & stage_2_a[1] >= stage_2_c[0]) : out_1 = stage_2_a[1];
        default : out_1 = stage_2_c[0];
    endcase
end

always @(*) begin
    case(1) // synopsys parallel_case
        (stage_2_b[0] <= stage_2_a[1] | stage_2_b[0] <= stage_2_c[0]) : out_2 = stage_2_b[0];
        (stage_2_a[1] <= stage_2_b[0] & stage_2_a[1] >= stage_2_c[0]) : out_2 = stage_2_a[1];
        //(stage_2_c[0] <= stage_2_b[0] & stage_2_c[0] >= stage_2_a[1]) : out_2 = stage_2_c[0];
        default : out_2 = stage_2_c[0];
    endcase
end

always @(*) begin
    case(1) // synopsys parallel_case
        (stage_2_a[1] <= stage_2_c[0] & stage_2_a[1] >= stage_2_b[1] & stage_2_a[1] >= stage_2_d[0])    : out_3 = stage_2_a[1];
        ((stage_2_b[1] >= stage_2_a[1] | stage_2_b[1] >= stage_2_c[0]) & stage_2_b[1] >= stage_2_d[0])  : out_3 = stage_2_b[1];
        (stage_2_c[0] <= stage_2_a[1] & stage_2_c[0] >= stage_2_b[1] & stage_2_c[0] >= stage_2_d[0])    : out_3 = stage_2_c[0];
        //((stage_2_d[0] >= stage_2_a[1] | stage_2_d[0] >= stage_2_c[0]) & stage_2_d[0] >= stage_2_b[1])  : out_3 = stage_2_d[0];
        default : out_3 = stage_2_d[0];
    endcase
end

always @(*) begin
    case(1) // synopsys parallel_case
        (stage_2_a[1] <= stage_2_c[0] & (stage_2_a[1] <= stage_2_b[1] | stage_2_a[1] <= stage_2_d[0]))  : out_4 = stage_2_a[1];
        (stage_2_b[1] <= stage_2_a[1] & stage_2_b[1] <= stage_2_c[0] & stage_2_b[1] >= stage_2_d[0])    : out_4 = stage_2_b[1];
        (stage_2_c[0] <= stage_2_a[1] & (stage_2_c[0] <= stage_2_b[1] | stage_2_c[0] <= stage_2_d[0]))  : out_4 = stage_2_c[0];
        //(stage_2_d[0] <= stage_2_a[1] & stage_2_d[0] <= stage_2_c[0] & stage_2_d[0] >= stage_2_b[1])    : out_4 = stage_2_d[0];
        default : out_4 = stage_2_d[0];
    endcase
end

always @(*) begin
    case(1) // synopsys parallel_case
        (stage_1_a[2] <= stage_1_b[2] & (stage_1_a[2] >= stage_2_b[1] | stage_1_a[2] >= stage_2_d[0]))  : out_5 = stage_1_a[2];
        (stage_1_b[2] <= stage_1_a[2] & (stage_1_b[2] >= stage_2_b[1] | stage_1_b[2] >= stage_2_d[0]))  : out_5 = stage_1_b[2];
        (stage_2_b[1] <= stage_2_d[0] & (stage_2_b[1] >= stage_1_a[2] | stage_2_b[1] >= stage_1_b[2]))  : out_5 = stage_2_b[1];
        //(stage_2_d[0] <= stage_2_b[1] & (stage_2_d[0] >= stage_1_a[2] | stage_2_d[0] >= stage_1_b[2]))  : out_5 = stage_2_d[0];
        default : out_5 = stage_2_d[0];
    endcase
end

always @(*) begin
    case(1) // synopsys parallel_case
        (stage_1_a[2] <= stage_1_b[2] & stage_1_a[2] <= stage_2_b[1] & stage_1_a[2] <= stage_2_d[0])  : out_6 = stage_1_a[2];
        (stage_1_b[2] <= stage_1_a[2] & stage_1_b[2] <= stage_2_b[1] & stage_1_b[2] <= stage_2_d[0])  : out_6 = stage_1_b[2];
        (stage_2_b[1] <= stage_2_d[0] & stage_2_b[1] <= stage_1_a[2] & stage_2_b[1] <= stage_1_b[2])  : out_6 = stage_2_b[1];
        //(stage_2_d[0] <= stage_2_b[1] & stage_2_d[0] <= stage_1_a[2] & stage_2_d[0] <= stage_1_b[2])  : out_6 = stage_2_d[0];
        default : out_6 = stage_2_d[0];
    endcase
end

assign out_0 = stage_2_a[0];
//assign out_1 = stage_4_a[0];
//assign out_2 = stage_4_a[1];
//assign out_3 = stage_4_b[0];
//assign out_4 = stage_4_b[1];
//assign out_5 = stage_4_c[0];
//assign out_6 = stage_4_c[1];
assign out_7 = stage_2_d[1];

endmodule

// LUT
module Sort_4(
    input       [7:0] in_0, in_1, in_2, in_3,
    output reg  [7:0] out_0, out_1, out_2, out_3
);

always @(*) begin
    case(1) // synopsys parallel_case
        (in_0 >= in_1 & in_0 >= in_2 & in_0 >= in_3) : out_0 = in_0;
        (in_1 >= in_0 & in_1 >= in_2 & in_1 >= in_3) : out_0 = in_1;
        (in_2 >= in_0 & in_2 >= in_1 & in_2 >= in_3) : out_0 = in_2;
        default : out_0 = in_3;
    endcase
end

always @(*) begin
    case(1) // synopsys parallel_case
        (in_0 >= in_1 & in_0 >= in_2 & in_0 <= in_3) | (in_0 >= in_2 & in_0 >= in_3 & in_0 <= in_1) | (in_0 >= in_1 & in_0 >= in_3 & in_0 <= in_2) : out_1 = in_0;
        (in_1 >= in_0 & in_1 >= in_2 & in_1 <= in_3) | (in_1 >= in_2 & in_1 >= in_3 & in_1 <= in_0) | (in_1 >= in_0 & in_1 >= in_3 & in_1 <= in_2) : out_1 = in_1;
        (in_2 >= in_0 & in_2 >= in_1 & in_2 <= in_3) | (in_2 >= in_1 & in_2 >= in_3 & in_2 <= in_0) | (in_2 >= in_0 & in_2 >= in_3 & in_2 <= in_1) : out_1 = in_2;
        default : out_1 = in_3;
    endcase
end

always @(*) begin
    case(1) // synopsys parallel_case
        (in_0 >= in_1 & in_0 <= in_2 & in_0 <= in_3) | (in_0 >= in_2 & in_0 <= in_1 & in_0 <= in_3) | (in_0 >= in_3 & in_0 <= in_1 & in_0 <= in_2) : out_2 = in_0;
        (in_1 >= in_0 & in_1 <= in_2 & in_1 <= in_3) | (in_1 >= in_2 & in_1 <= in_0 & in_1 <= in_3) | (in_1 >= in_3 & in_1 <= in_0 & in_1 <= in_2) : out_2 = in_1;
        (in_2 >= in_0 & in_2 <= in_1 & in_2 <= in_3) | (in_2 >= in_1 & in_2 <= in_0 & in_2 <= in_3) | (in_2 >= in_3 & in_2 <= in_0 & in_2 <= in_1) : out_2 = in_2;
        default : out_2 = in_3;
    endcase
end

always @(*) begin
    case(1) // synopsys parallel_case
        (in_0 <= in_1 & in_0 <= in_2 & in_0 <= in_3) : out_3 = in_0;
        (in_1 <= in_0 & in_1 <= in_2 & in_1 <= in_3) : out_3 = in_1;
        (in_2 <= in_0 & in_2 <= in_1 & in_2 <= in_3) : out_3 = in_2;
        default : out_3 = in_3;
    endcase
end

endmodule

/*
// 10 comparators
module Sort_4(
    input  [7:0] in_0, in_1, in_2, in_3,
    output [7:0] out_0, out_1, out_2, out_3
);

wire [7:0] temp [0:7];

assign temp[0] = (in_0 > in_1) ? in_0 : in_1;
assign temp[1] = (in_0 > in_1) ? in_1 : in_0;
assign temp[2] = (in_2 > in_3) ? in_2 : in_3;
assign temp[3] = (in_2 > in_3) ? in_3 : in_2;
assign temp[4] = (temp[0] > temp[2]) ? temp[0] : temp[2]; // max
assign temp[5] = (temp[0] > temp[2]) ? temp[2] : temp[0];
assign temp[6] = (temp[1] > temp[3]) ? temp[1] : temp[3];
assign temp[7] = (temp[1] > temp[3]) ? temp[3] : temp[1]; // min

assign out_0 = temp[4];
assign out_1 = (temp[5] > temp[6]) ? temp[5] : temp[6];
assign out_2 = (temp[5] > temp[6]) ? temp[6] : temp[5];
assign out_3 = temp[7];

endmodule
*/
