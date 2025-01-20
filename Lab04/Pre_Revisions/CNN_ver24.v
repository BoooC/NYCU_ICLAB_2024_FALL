//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2023 Fall
//   Lab04 Exercise		: Convolution Neural Network 
//   Author     		: Yu-Chi Lin (a6121461214.st12@nycu.edu.tw)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : CNN.v
//   Module Name : CNN
//   Release version : V1.0 (Release Date: 2024-10)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module CNN(
    //Input Port
    clk,
    rst_n,
    in_valid,
    Img,
    Kernel_ch1,
    Kernel_ch2,
	Weight,
    Opt,

    //Output Port
    out_valid,
    out
    );


// IEEE floating point parameter
parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch_type = 0;
parameter inst_arch = 0;
parameter inst_faithful_round = 0;

//---------------------------------------------------------------------
//   IO PORT
//---------------------------------------------------------------------
input rst_n, clk, in_valid;
input [inst_sig_width+inst_exp_width:0] Img, Kernel_ch1, Kernel_ch2, Weight;
input Opt;

output reg	out_valid;
output reg [inst_sig_width+inst_exp_width:0] out;


//---------------------------------------------------------------------
//   PARAMETER
//---------------------------------------------------------------------
localparam IDLE     = 3'd0;
localparam DIN      = 3'd1; // 4 cycle for the first kernel read done
localparam CONV     = 3'd2; // 75 cycles
localparam POOL     = 3'd3; // 1 cycles
localparam ACT      = 3'd4; 
localparam FC       = 3'd5;
localparam SOFTMAX  = 3'd6;
localparam DOUT     = 3'd7;

// opt
parameter SIGMOID   = 1'b0;
parameter ZERO_PAD  = 1'b0;
parameter TANH      = 1'b1;
parameter REPLIC    = 1'b1;

parameter ZERO_FP32 = 32'b0_00000000_00000000000000000000000;
parameter NUM_NEG   = 32'b1_11111110_11111111111111111111111;

//---------------------------------------------------------------------
//   Reg
//---------------------------------------------------------------------
// FSM state
reg [2:0] state, next_state;

// input buffer
reg opt_reg;
reg [inst_sig_width+inst_exp_width:0] Img_buffer    [0:24]; // only for one channel
reg [inst_sig_width+inst_exp_width:0] kernel_buffer1[0:11];
reg [inst_sig_width+inst_exp_width:0] kernel_buffer2[0:11];
reg [inst_sig_width+inst_exp_width:0] weight_buffer [0:23];

// output buffer
reg [inst_sig_width+inst_exp_width:0] Ofmap_buffer1  [0:35]; // for conv, max pooling, activation, fc, softmax
reg [inst_sig_width+inst_exp_width:0] Ofmap_buffer2  [0:35]; // for conv

// counter
reg [4:0] addr;
reg [5:0] ifmap_addr;
reg [5:0] conv_addr;
reg [1:0] channel_count;

// buffer control
reg kernel_read_done_reg;
reg weight_read_done_reg;
reg opt_read_done_reg;


//---------------------------------------------------------------------
//   Wires
//---------------------------------------------------------------------
wire [inst_sig_width+inst_exp_width:0] ifmap [0:48]; // padding result

// layer result wire
wire [inst_sig_width+inst_exp_width:0] pool_result_1    [0:3];
wire [inst_sig_width+inst_exp_width:0] pool_result_2    [0:3];
wire [inst_sig_width+inst_exp_width:0] flatten_result   [0:7];
wire [inst_sig_width+inst_exp_width:0] act_result       [0:7];
wire [inst_sig_width+inst_exp_width:0] fc_result        [0:2];

// img padding processing
assign ifmap[0]  = (opt_reg == ZERO_PAD) ? ZERO_FP32 : Img_buffer[0];
assign ifmap[1]  = (opt_reg == ZERO_PAD) ? ZERO_FP32 : Img_buffer[0];
assign ifmap[2]  = (opt_reg == ZERO_PAD) ? ZERO_FP32 : Img_buffer[1];
assign ifmap[3]  = (opt_reg == ZERO_PAD) ? ZERO_FP32 : Img_buffer[2];
assign ifmap[4]  = (opt_reg == ZERO_PAD) ? ZERO_FP32 : Img_buffer[3];
assign ifmap[5]  = (opt_reg == ZERO_PAD) ? ZERO_FP32 : Img_buffer[4];
assign ifmap[6]  = (opt_reg == ZERO_PAD) ? ZERO_FP32 : Img_buffer[4];
assign ifmap[7]  = (opt_reg == ZERO_PAD) ? ZERO_FP32 : Img_buffer[0];
assign ifmap[13] = (opt_reg == ZERO_PAD) ? ZERO_FP32 : Img_buffer[4];
assign ifmap[14] = (opt_reg == ZERO_PAD) ? ZERO_FP32 : Img_buffer[5];
assign ifmap[20] = (opt_reg == ZERO_PAD) ? ZERO_FP32 : Img_buffer[9];
assign ifmap[21] = (opt_reg == ZERO_PAD) ? ZERO_FP32 : Img_buffer[10];
assign ifmap[27] = (opt_reg == ZERO_PAD) ? ZERO_FP32 : Img_buffer[14];
assign ifmap[28] = (opt_reg == ZERO_PAD) ? ZERO_FP32 : Img_buffer[15];
assign ifmap[34] = (opt_reg == ZERO_PAD) ? ZERO_FP32 : Img_buffer[19];
assign ifmap[35] = (opt_reg == ZERO_PAD) ? ZERO_FP32 : Img_buffer[20];
assign ifmap[41] = (opt_reg == ZERO_PAD) ? ZERO_FP32 : Img_buffer[24];
assign ifmap[42] = (opt_reg == ZERO_PAD) ? ZERO_FP32 : Img_buffer[20];
assign ifmap[43] = (opt_reg == ZERO_PAD) ? ZERO_FP32 : Img_buffer[20];
assign ifmap[44] = (opt_reg == ZERO_PAD) ? ZERO_FP32 : Img_buffer[21];
assign ifmap[45] = (opt_reg == ZERO_PAD) ? ZERO_FP32 : Img_buffer[22];
assign ifmap[46] = (opt_reg == ZERO_PAD) ? ZERO_FP32 : Img_buffer[23];
assign ifmap[47] = (opt_reg == ZERO_PAD) ? ZERO_FP32 : Img_buffer[24];
assign ifmap[48] = (opt_reg == ZERO_PAD) ? ZERO_FP32 : Img_buffer[24];
assign ifmap[8]  = Img_buffer[0];
assign ifmap[9]  = Img_buffer[1];
assign ifmap[10] = Img_buffer[2];
assign ifmap[11] = Img_buffer[3];
assign ifmap[12] = Img_buffer[4];
assign ifmap[15] = Img_buffer[5];
assign ifmap[16] = Img_buffer[6];
assign ifmap[17] = Img_buffer[7];
assign ifmap[18] = Img_buffer[8];
assign ifmap[19] = Img_buffer[9];
assign ifmap[22] = Img_buffer[10];
assign ifmap[23] = Img_buffer[11];
assign ifmap[24] = Img_buffer[12];
assign ifmap[25] = Img_buffer[13];
assign ifmap[26] = Img_buffer[14];
assign ifmap[29] = Img_buffer[15];
assign ifmap[30] = Img_buffer[16];
assign ifmap[31] = Img_buffer[17];
assign ifmap[32] = Img_buffer[18];
assign ifmap[33] = Img_buffer[19];
assign ifmap[36] = Img_buffer[20];
assign ifmap[37] = Img_buffer[21];
assign ifmap[38] = Img_buffer[22];
assign ifmap[39] = Img_buffer[23];
assign ifmap[40] = Img_buffer[24];

// ofmap buffer sharing
assign flatten_result[0] = Ofmap_buffer1[0];
assign flatten_result[1] = Ofmap_buffer1[1];
assign flatten_result[2] = Ofmap_buffer1[2];
assign flatten_result[3] = Ofmap_buffer1[3];
assign flatten_result[4] = Ofmap_buffer2[0];
assign flatten_result[5] = Ofmap_buffer2[1];
assign flatten_result[6] = Ofmap_buffer2[2];
assign flatten_result[7] = Ofmap_buffer2[3];

assign act_result[0] = Ofmap_buffer1[0];
assign act_result[1] = Ofmap_buffer1[1];
assign act_result[2] = Ofmap_buffer1[2];
assign act_result[3] = Ofmap_buffer1[3];
assign act_result[4] = Ofmap_buffer1[4];
assign act_result[5] = Ofmap_buffer1[5];
assign act_result[6] = Ofmap_buffer1[6];
assign act_result[7] = Ofmap_buffer1[7];

assign fc_result[0] = Ofmap_buffer1[0];
assign fc_result[1] = Ofmap_buffer1[1];
assign fc_result[2] = Ofmap_buffer1[2];

// state control
localparam MAC_PIPE_STAGE = 'd4;
wire in_done    = addr == 'd2 + MAC_PIPE_STAGE;
wire conv_done  = conv_addr == 6'd29 & channel_count == 2'd2;
wire pool_done  = 1'b1;
wire act_done   = addr == 'd12;
wire fc_done    = addr == 'd6;
wire soft_done  = addr == 'd6;

// counter control
wire conv_addr_done  = conv_addr  == 'd29;
wire ifmap_addr_done = ifmap_addr == 'd41;
wire ifmap_addr_skip = ifmap_addr == 'd12 | ifmap_addr == 'd19 | ifmap_addr == 'd26 | ifmap_addr == 'd33;

// PE Control
wire ifmap_addr_skip2= ((channel_count == 0) & (ifmap_addr == 'd8 | ifmap_addr == 'd10)) | 
                       ((channel_count == 1) & (ifmap_addr == 'd8)) | ((channel_count == 2) & (ifmap_addr == 'd8));

wire ifmap_bottom   = ifmap_addr == 'd36 | ifmap_addr == 'd37 | ifmap_addr == 'd38 | ifmap_addr == 'd39 | ifmap_addr == 'd40 | ifmap_addr == 'd41;

wire conv_addr_side = (channel_count == 'd0 & (conv_addr == 'd0 | conv_addr == 'd2 | conv_addr == 'd4)) | 
                      (channel_count == 'd1 & (conv_addr == 'd0 | conv_addr == 'd2 | conv_addr == 'd4)) | 
                      (channel_count == 'd2 & conv_addr == 'd0) |
                      (conv_addr == 'd4 | conv_addr == 'd10 | conv_addr == 'd16 | conv_addr == 'd22);

wire conv_addr_bottom= conv_addr == 'd24 | conv_addr == 'd25 | conv_addr == 'd26 | conv_addr == 'd27 | conv_addr == 'd28 | conv_addr == 'd29;

//---------------------------------------------------------------------
// IPs port
//---------------------------------------------------------------------
// PE data in sel
wire [inst_sig_width+inst_exp_width:0] PE_1_ifmap_a = (state == CONV | state == DIN) ? ifmap[ifmap_addr-'d8] : act_result[0];
wire [inst_sig_width+inst_exp_width:0] PE_1_ifmap_b = (state == CONV | state == DIN) ? ifmap[ifmap_addr-'d7] : act_result[1];
wire [inst_sig_width+inst_exp_width:0] PE_1_ifmap_c = (state == CONV | state == DIN) ? ifmap[ifmap_addr-'d1] : act_result[2];
wire [inst_sig_width+inst_exp_width:0] PE_1_ifmap_d = (state == CONV | state == DIN) ? ifmap[ifmap_addr-'d0] : act_result[3];
wire [inst_sig_width+inst_exp_width:0] PE_2_ifmap_a = (state == CONV | state == DIN) ? ifmap[ifmap_addr-'d8] : act_result[4];
wire [inst_sig_width+inst_exp_width:0] PE_2_ifmap_b = (state == CONV | state == DIN) ? ifmap[ifmap_addr-'d7] : act_result[5];
wire [inst_sig_width+inst_exp_width:0] PE_2_ifmap_c = (state == CONV | state == DIN) ? ifmap[ifmap_addr-'d1] : act_result[6];
wire [inst_sig_width+inst_exp_width:0] PE_2_ifmap_d = (state == CONV | state == DIN) ? ifmap[ifmap_addr-'d0] : act_result[7];
wire [inst_sig_width+inst_exp_width:0] PE_3_ifmap_a = ifmap_bottom ? ifmap[ifmap_addr-'d1] : ifmap[ifmap_addr-'d7];
wire [inst_sig_width+inst_exp_width:0] PE_3_ifmap_b = ifmap_bottom ? ifmap[ifmap_addr+'d0] : ifmap[ifmap_addr-'d6];
wire [inst_sig_width+inst_exp_width:0] PE_3_ifmap_c = ifmap_bottom ? ifmap[ifmap_addr+'d6] : ifmap[ifmap_addr+'d0];
wire [inst_sig_width+inst_exp_width:0] PE_3_ifmap_d = ifmap_bottom ? ifmap[ifmap_addr+'d7] : ifmap[ifmap_addr+'d1];
wire [inst_sig_width+inst_exp_width:0] PE_4_ifmap_a = ifmap_bottom ? ifmap[ifmap_addr-'d1] : ifmap[ifmap_addr-'d7];
wire [inst_sig_width+inst_exp_width:0] PE_4_ifmap_b = ifmap_bottom ? ifmap[ifmap_addr+'d0] : ifmap[ifmap_addr-'d6];
wire [inst_sig_width+inst_exp_width:0] PE_4_ifmap_c = ifmap_bottom ? ifmap[ifmap_addr+'d6] : ifmap[ifmap_addr+'d0];
wire [inst_sig_width+inst_exp_width:0] PE_4_ifmap_d = ifmap_bottom ? ifmap[ifmap_addr+'d7] : ifmap[ifmap_addr+'d1];

wire [inst_sig_width+inst_exp_width:0] PE_1_weight_a = (state == CONV | state == DIN) ? kernel_buffer1[0] : weight_buffer[0];
wire [inst_sig_width+inst_exp_width:0] PE_1_weight_b = (state == CONV | state == DIN) ? kernel_buffer1[1] : weight_buffer[1];
wire [inst_sig_width+inst_exp_width:0] PE_1_weight_c = (state == CONV | state == DIN) ? kernel_buffer1[2] : weight_buffer[2];
wire [inst_sig_width+inst_exp_width:0] PE_1_weight_d = (state == CONV | state == DIN) ? kernel_buffer1[3] : weight_buffer[3];
wire [inst_sig_width+inst_exp_width:0] PE_2_weight_a = (state == CONV | state == DIN) ? kernel_buffer2[0] : weight_buffer[4];
wire [inst_sig_width+inst_exp_width:0] PE_2_weight_b = (state == CONV | state == DIN) ? kernel_buffer2[1] : weight_buffer[5];
wire [inst_sig_width+inst_exp_width:0] PE_2_weight_c = (state == CONV | state == DIN) ? kernel_buffer2[2] : weight_buffer[6];
wire [inst_sig_width+inst_exp_width:0] PE_2_weight_d = (state == CONV | state == DIN) ? kernel_buffer2[3] : weight_buffer[7];
wire [inst_sig_width+inst_exp_width:0] PE_3_weight_a = (state == CONV | state == DIN) ? kernel_buffer1[0] : weight_buffer[4];
wire [inst_sig_width+inst_exp_width:0] PE_3_weight_b = (state == CONV | state == DIN) ? kernel_buffer1[1] : weight_buffer[5];
wire [inst_sig_width+inst_exp_width:0] PE_3_weight_c = (state == CONV | state == DIN) ? kernel_buffer1[2] : weight_buffer[6];
wire [inst_sig_width+inst_exp_width:0] PE_3_weight_d = (state == CONV | state == DIN) ? kernel_buffer1[3] : weight_buffer[7];
wire [inst_sig_width+inst_exp_width:0] PE_4_weight_a = (state == CONV | state == DIN) ? kernel_buffer2[0] : weight_buffer[4];
wire [inst_sig_width+inst_exp_width:0] PE_4_weight_b = (state == CONV | state == DIN) ? kernel_buffer2[1] : weight_buffer[5];
wire [inst_sig_width+inst_exp_width:0] PE_4_weight_c = (state == CONV | state == DIN) ? kernel_buffer2[2] : weight_buffer[6];
wire [inst_sig_width+inst_exp_width:0] PE_4_weight_d = (state == CONV | state == DIN) ? kernel_buffer2[3] : weight_buffer[7];

wire [inst_sig_width+inst_exp_width:0] PE_1_out, PE_1_psum_temp_reg;
wire [inst_sig_width+inst_exp_width:0] PE_2_out, PE_2_psum_temp_reg;
wire [inst_sig_width+inst_exp_width:0] PE_3_out, PE_3_psum_temp_reg;
wire [inst_sig_width+inst_exp_width:0] PE_4_out, PE_4_psum_temp_reg;

wire [inst_sig_width+inst_exp_width:0] PE_1_psum_in = (state == CONV | state == DIN) ? Ofmap_buffer1[conv_addr] : 32'd0;
wire [inst_sig_width+inst_exp_width:0] PE_2_psum_in = (state == CONV | state == DIN) ? Ofmap_buffer2[conv_addr] : PE_1_psum_temp_reg;
wire [inst_sig_width+inst_exp_width:0] PE_3_psum_in = conv_addr_side ? Ofmap_buffer1[conv_addr+1] : Ofmap_buffer1[conv_addr+6];
wire [inst_sig_width+inst_exp_width:0] PE_4_psum_in = conv_addr_side ? Ofmap_buffer2[conv_addr+1] : Ofmap_buffer2[conv_addr+6];

// comparator module ports
wire [inst_sig_width+inst_exp_width:0] comp_1_max, comp_2_max, comp_3_max, comp_4_max;

wire comp_1_clear = conv_addr == 'd16 | (state == DOUT);
wire comp_2_clear = conv_addr == 'd19 | (state == DOUT);
wire comp_3_clear = conv_addr == 'd16 | (state == DOUT);
wire comp_4_clear = conv_addr == 'd19 | (state == DOUT);

// comparator data in sel
wire left_in_flag = conv_addr == 'd0 | conv_addr == 'd1 | conv_addr == 'd2 |
                    conv_addr == 'd6 | conv_addr == 'd7 | conv_addr == 'd8 |
                    conv_addr == 'd12| conv_addr == 'd13| conv_addr == 'd14|
                    conv_addr == 'd18| conv_addr == 'd19| conv_addr == 'd20|
                    conv_addr == 'd24| conv_addr == 'd25| conv_addr == 'd26|
                    conv_addr == 'd30| conv_addr == 'd31| conv_addr == 'd32;

wire right_in_flag= conv_addr == 'd3 | conv_addr == 'd4 | conv_addr == 'd5 |
                    conv_addr == 'd9 | conv_addr == 'd10| conv_addr == 'd11|
                    conv_addr == 'd15| conv_addr == 'd16| conv_addr == 'd17|
                    conv_addr == 'd21| conv_addr == 'd22| conv_addr == 'd23|
                    conv_addr == 'd27| conv_addr == 'd28| conv_addr == 'd29|
                    conv_addr == 'd33| conv_addr == 'd34| conv_addr == 'd35;

wire comp_l_en = left_in_flag  & (channel_count == 'd2);
wire comp_r_en = right_in_flag & (channel_count == 'd2);

wire comp_1_en = comp_l_en;
wire comp_2_en = comp_r_en;
wire comp_3_en = comp_l_en;
wire comp_4_en = comp_r_en;

wire [inst_sig_width+inst_exp_width:0] comp_1_in_1 = PE_1_out;
wire [inst_sig_width+inst_exp_width:0] comp_2_in_1 = PE_1_out;
wire [inst_sig_width+inst_exp_width:0] comp_3_in_1 = PE_2_out;
wire [inst_sig_width+inst_exp_width:0] comp_4_in_1 = PE_2_out;

wire [inst_sig_width+inst_exp_width:0] comp_1_in_2 = (conv_addr_side | conv_addr_bottom) ? PE_3_out : NUM_NEG;
wire [inst_sig_width+inst_exp_width:0] comp_2_in_2 = (conv_addr_side | conv_addr_bottom) ? PE_3_out : NUM_NEG;
wire [inst_sig_width+inst_exp_width:0] comp_3_in_2 = (conv_addr_side | conv_addr_bottom) ? PE_4_out : NUM_NEG;
wire [inst_sig_width+inst_exp_width:0] comp_4_in_2 = (conv_addr_side | conv_addr_bottom) ? PE_4_out : NUM_NEG;

// activation or softmax
reg [inst_sig_width+inst_exp_width:0] flatten_in;
wire [inst_sig_width+inst_exp_width:0] act_out;
wire mode = (state == SOFTMAX) | (state == FC);

// activation or softmax data in sel
always @(*) begin
    if(mode) begin // softmax
        case(addr)
            'd4 : flatten_in = fc_result[0];
            'd5 : flatten_in = fc_result[1];
            'd6 : flatten_in = fc_result[2];
            default : flatten_in = 'd0;
        endcase
    end
    else begin  // activation
        case(addr)
            'd0 : flatten_in = flatten_result[0];
            'd1 : flatten_in = flatten_result[1];
            'd2 : flatten_in = flatten_result[4];
            'd3 : flatten_in = flatten_result[5];
            'd4 : flatten_in = flatten_result[2];
            'd5 : flatten_in = flatten_result[6];
            'd6 : flatten_in = flatten_result[3];
            'd7 : flatten_in = flatten_result[7];
            default : flatten_in = 'd0;
        endcase
    end
end

//---------------------------------------------------------------------
// IPs
//---------------------------------------------------------------------
// processing element
PE #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
PE_inst_0 (
    .clk(clk),
    .ifmap_0        (PE_1_ifmap_a),
    .ifmap_1        (PE_1_ifmap_b),
    .ifmap_2        (PE_1_ifmap_c),
    .ifmap_3        (PE_1_ifmap_d),
    .weight_0       (PE_1_weight_a),
    .weight_1       (PE_1_weight_b),
    .weight_2       (PE_1_weight_c),
    .weight_3       (PE_1_weight_d),
    .psum_in        (PE_1_psum_in),
    .psum_temp_reg  (PE_1_psum_temp_reg),
    .psum_out       (PE_1_out)
);

PE #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
PE_inst_1 (
    .clk(clk),
    .ifmap_0        (PE_2_ifmap_a),
    .ifmap_1        (PE_2_ifmap_b),
    .ifmap_2        (PE_2_ifmap_c),
    .ifmap_3        (PE_2_ifmap_d),
    .weight_0       (PE_2_weight_a),
    .weight_1       (PE_2_weight_b),
    .weight_2       (PE_2_weight_c),
    .weight_3       (PE_2_weight_d),
    .psum_in        (PE_2_psum_in),
    .psum_temp_reg  (PE_2_psum_temp_reg),
    .psum_out       (PE_2_out)
);

PE #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
PE_inst_2 (
    .clk(clk),
    .ifmap_0        (PE_3_ifmap_a),
    .ifmap_1        (PE_3_ifmap_b),
    .ifmap_2        (PE_3_ifmap_c),
    .ifmap_3        (PE_3_ifmap_d),
    .weight_0       (PE_3_weight_a),
    .weight_1       (PE_3_weight_b),
    .weight_2       (PE_3_weight_c),
    .weight_3       (PE_3_weight_d),
    .psum_in        (PE_3_psum_in),
    .psum_temp_reg  (PE_3_psum_temp_reg),
    .psum_out       (PE_3_out)
);

PE #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
PE_inst_3 (
    .clk(clk),
    .ifmap_0        (PE_4_ifmap_a),
    .ifmap_1        (PE_4_ifmap_b),
    .ifmap_2        (PE_4_ifmap_c),
    .ifmap_3        (PE_4_ifmap_d),
    .weight_0       (PE_4_weight_a),
    .weight_1       (PE_4_weight_b),
    .weight_2       (PE_4_weight_c),
    .weight_3       (PE_4_weight_d),
    .psum_in        (PE_4_psum_in),
    .psum_temp_reg  (PE_4_psum_temp_reg),
    .psum_out       (PE_4_out)
);

// for kernel 0, left map
DW_COMP #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
DW_COMP_inst_1_left (
    .clk    (clk),
    .rst_n  (rst_n),
    .clear  (comp_1_clear),
    .en     (comp_1_en),
    .in_1   (comp_1_in_1),
    .in_2   (comp_1_in_2),
    .max_reg(comp_1_max)
);

// for kernel 0, right map
DW_COMP #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
DW_COMP_inst_1_right (
    .clk    (clk),
    .rst_n  (rst_n),
    .clear  (comp_2_clear),
    .en     (comp_2_en),
    .in_1   (comp_2_in_1),
    .in_2   (comp_2_in_2),
    .max_reg(comp_2_max)
);

// for kernel 1, left map
DW_COMP #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
DW_COMP_inst_2_left (
    .clk    (clk),
    .rst_n  (rst_n),
    .clear  (comp_3_clear),
    .en     (comp_3_en),
    .in_1   (comp_3_in_1),
    .in_2   (comp_3_in_2),
    .max_reg(comp_3_max)
);

// for kernel 1, right map
DW_COMP #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
DW_COMP_inst_2_right (
    .clk    (clk),
    .rst_n  (rst_n),
    .clear  (comp_4_clear),
    .en     (comp_4_en),
    .in_1   (comp_4_in_1),
    .in_2   (comp_4_in_2),
    .max_reg(comp_4_max)
);

// activation or softmax
DW_ACT_SOFTMAX #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch, inst_faithful_round)
DW_ACT_SOFTMAX_inst
(   .clk    (clk),
    .rst_n  (rst_n),
    .opt    (opt_reg),
    .mode   (mode),
    .addr   (addr),
    .flatten(flatten_in),
    .act_out(act_out)
);

//---------------------------------------------------------------------
// FSM
//---------------------------------------------------------------------
// next state logic
always @(*) begin
    case (state)
        IDLE    : next_state = in_valid     ? DIN       : IDLE;
        DIN     : next_state = in_done      ? CONV      : DIN;
        CONV    : next_state = conv_done    ? POOL      : CONV;
        POOL    : next_state = pool_done    ? ACT       : POOL;
        ACT     : next_state = act_done     ? FC        : ACT;
        FC      : next_state = fc_done      ? SOFTMAX   : FC;
        SOFTMAX : next_state = soft_done    ? DOUT      : SOFTMAX;
        DOUT    : next_state = IDLE;
        default : next_state = IDLE;
    endcase
end

// FMS
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= IDLE;
    end
    else begin
        state <= next_state;
    end
end

//---------------------------------------------------------------------
// Input Buffer
//---------------------------------------------------------------------
integer i;
always @(posedge clk) begin
    if(in_valid) begin
        Img_buffer[addr] <= Img;
    end
    else if(state == DOUT) begin
        for(i = 0 ; i < 25 ; i = i + 1) begin
            Img_buffer[i] <= 32'd0;
        end
    end
    else begin
         for(i = 0 ; i < 25 ; i = i + 1) begin
            Img_buffer[i] <= Img_buffer[i];
        end
    end
end

always @(posedge clk) begin
    if(in_valid & ~kernel_read_done_reg) begin
        kernel_buffer1[addr] <= Kernel_ch1;
        kernel_buffer2[addr] <= Kernel_ch2;
    end
    else if(ifmap_addr_done) begin
        for(i = 0 ; i < 4; i = i + 1) begin
            kernel_buffer1[i]   <= kernel_buffer1[i+4];
            kernel_buffer2[i]   <= kernel_buffer2[i+4];
            kernel_buffer1[i+4] <= kernel_buffer1[i+8];
            kernel_buffer2[i+4] <= kernel_buffer2[i+8];
        end
    end
    else if(state == DOUT) begin
        for(i = 0 ; i < 12 ; i = i + 1) begin
            kernel_buffer1[i] <= 32'd0;
            kernel_buffer2[i] <= 32'd0;
        end
    end
end

always @(posedge clk) begin
    if(in_valid & ~weight_read_done_reg) begin
        weight_buffer[addr] <= Weight;
    end
    else if(state == FC) begin
        for(i = 0 ; i < 8; i = i + 1) begin
            weight_buffer[i]   <= weight_buffer[i+8];
            weight_buffer[i+8] <= weight_buffer[i+16];
        end
    end
    else if(state == DOUT) begin
        for(i = 0 ; i < 24 ; i = i + 1) begin
            weight_buffer[i] <= 32'd0;
        end
    end
end

always @(posedge clk) begin
    if(in_valid & ~opt_read_done_reg) begin
        opt_reg <= Opt;
    end
end

//---------------------------------------------------------------------
// Ofmap Buffer
//---------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0 ; i < 36 ; i = i + 1) begin
            Ofmap_buffer1[i] <= 32'd0;
        end
    end
    else begin
        case(state)
            CONV : begin
                Ofmap_buffer1[conv_addr] <= PE_1_out;
                Ofmap_buffer1[conv_addr+1] <= conv_addr_side   ? PE_3_out : Ofmap_buffer1[conv_addr+1]; // side
                Ofmap_buffer1[conv_addr+6] <= conv_addr_bottom ? PE_3_out : Ofmap_buffer1[conv_addr+6]; // bottom
                if(channel_count == 2'd2) begin
                    case(conv_addr)
                        'd16 : Ofmap_buffer1[0] <= comp_1_max;
                        'd19 : Ofmap_buffer1[1] <= comp_2_max;
                        'd27 : Ofmap_buffer1[2] <= comp_1_max;
                    endcase
                end
            end
            POOL : begin
                Ofmap_buffer1[0] <= act_out;
                Ofmap_buffer1[3] <= comp_2_max;
            end
            ACT : begin
                case(addr)
                    'd6  : Ofmap_buffer1[1] <= act_out;
                    'd7  : Ofmap_buffer1[4] <= act_out;
                    'd8  : Ofmap_buffer1[5] <= act_out;
                    'd9  : Ofmap_buffer1[2] <= act_out;
                    'd10 : Ofmap_buffer1[6] <= act_out;
                    'd11 : Ofmap_buffer1[3] <= act_out;
                    'd12 : Ofmap_buffer1[7] <= act_out;
                endcase
            end
            FC : begin
                case(addr)
                    'd3  : Ofmap_buffer1[0] <= PE_2_out;
                    'd4  : Ofmap_buffer1[1] <= PE_2_out;
                    'd5  : Ofmap_buffer1[2] <= PE_2_out;
                endcase
            end
            DOUT : begin
                for(i = 0 ; i < 36 ; i = i + 1) begin
                    Ofmap_buffer1[i] <= 32'd0;
                end
            end
            default : begin
                for(i = 0 ; i < 36 ; i = i + 1) begin
                    Ofmap_buffer1[i] <= Ofmap_buffer1[i];
                end
            end
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0 ; i < 36 ; i = i + 1) begin
            Ofmap_buffer2[i] <= 32'd0;
        end
    end
    else begin
        case(state)
            CONV : begin
                Ofmap_buffer2[conv_addr] <= PE_2_out;
                Ofmap_buffer2[conv_addr+1] <= conv_addr_side   ? PE_4_out : Ofmap_buffer2[conv_addr+1];
                Ofmap_buffer2[conv_addr+6] <= conv_addr_bottom ? PE_4_out : Ofmap_buffer2[conv_addr+6];
                if(channel_count == 2'd2) begin
                    case(conv_addr)
                        'd16 : Ofmap_buffer2[0] <= comp_3_max;
                        'd19 : Ofmap_buffer2[1] <= comp_4_max;
                        'd27 : Ofmap_buffer2[2] <= comp_3_max;
                    endcase
                end
            end
            POOL : begin
                Ofmap_buffer2[3] <= comp_4_max;
            end
            DOUT : begin
                for(i = 0 ; i < 36 ; i = i + 1) begin
                    Ofmap_buffer2[i] <= 32'd0;
                end
            end
            default : begin
                for(i = 0 ; i < 36 ; i = i + 1) begin
                    Ofmap_buffer2[i] <= Ofmap_buffer2[i];
                end
            end
        endcase
    end
end

//---------------------------------------------------------------------
// Counter
//---------------------------------------------------------------------
// global counter
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        addr <= 'd0;
    end
    else if(in_valid) begin
        addr <= (addr == 'd24) ? 'd0 : (addr + 'd1);
    end
    else begin
        case(state)
            CONV    : addr <= addr + 'd1;
            POOL    : addr <= addr + 'd1;
            ACT     : addr <= act_done  ? 'd0 : (addr + 'd1);
            FC      : addr <= fc_done   ? 'd0 : (addr + 'd1);
            SOFTMAX : addr <= soft_done ? 'd0 : (addr + 'd1);
            default : addr <= 'd0;
        endcase
    end
end


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        conv_addr <= 6'd0;
    end
    else if(state == CONV) begin
        conv_addr <= conv_addr_done ? 'd0 : 
                     conv_addr_side ? (conv_addr + 'd2) : (conv_addr + 'd1);
    end
    else if(state == POOL)begin
        conv_addr <= 'd0;
    end
end


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ifmap_addr <= 6'd8;
    end
    else if(state == DIN & addr > 'd3) begin
        ifmap_addr <= ifmap_addr_skip  ? (ifmap_addr + 'd3) : (ifmap_addr + 'd2);
    end
    else if(state == CONV) begin
        ifmap_addr <=  ifmap_addr_skip2 ? (ifmap_addr + 'd2) : 
                       ifmap_addr_skip  ? (ifmap_addr + 'd3) : 
                      ~ifmap_addr_done  ? (ifmap_addr + 'd1) : 'd8;
    end
    else if(state == DOUT) begin
        ifmap_addr <= 6'd8;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        channel_count <= 2'd0;
    end
    else if(conv_addr_done) begin
        channel_count <= (channel_count == 'd2) ? 'd0 : (channel_count + 3'd1);
    end
end

//---------------------------------------------------------------------
// Buffer control
//---------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        kernel_read_done_reg <= 1'b0;
    end
    else if(addr == 5'd11) begin
        kernel_read_done_reg <= 1'b1;
    end
    else if(state == DOUT) begin
        kernel_read_done_reg <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        weight_read_done_reg <= 1'b0;
    end
    else if(addr == 5'd23) begin
        weight_read_done_reg <= 1'b1;
    end
    else if(state == DOUT) begin
        weight_read_done_reg <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        opt_read_done_reg <= 1'b0;
    end
    else if(in_valid) begin
        opt_read_done_reg <= 1'b1;
    end
    else if(state == DOUT) begin
        opt_read_done_reg <= 1'b0;
    end
end

//---------------------------------------------------------------------
// Output
//---------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out <= 'd0;
    end
    else if(state == SOFTMAX & addr > 'd3) begin
        out <= act_out;
    end
    else begin
        out <= 'd0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_valid <= 1'b0;
    end
    else if(state == SOFTMAX & addr > 'd3) begin
        out_valid <= 1'b1;
    end
    else begin
        out_valid <= 1'b0;
    end
end

endmodule

// Proccess element (4-stage pipeline)
module PE #(
    parameter inst_sig_width = 23,
    parameter inst_exp_width = 8,
    parameter inst_ieee_compliance = 0
)
(
    input clk,
    input [inst_sig_width+inst_exp_width:0] ifmap_0,
    input [inst_sig_width+inst_exp_width:0] ifmap_1,
    input [inst_sig_width+inst_exp_width:0] ifmap_2,
    input [inst_sig_width+inst_exp_width:0] ifmap_3,

    input [inst_sig_width+inst_exp_width:0] weight_0,
    input [inst_sig_width+inst_exp_width:0] weight_1,
    input [inst_sig_width+inst_exp_width:0] weight_2,
    input [inst_sig_width+inst_exp_width:0] weight_3,
    input [inst_sig_width+inst_exp_width:0] psum_in,

    output reg [inst_sig_width+inst_exp_width:0] psum_temp_reg,
    output[inst_sig_width+inst_exp_width:0] psum_out
);

wire [inst_sig_width+inst_exp_width:0] psum_0, psum_1, psum_2, psum_3, psum_temp;
wire [inst_sig_width+inst_exp_width:0] psum_add0, psum_add1;

// pipeline reg
reg [inst_sig_width+inst_exp_width:0] psum_0_reg, psum_1_reg, psum_2_reg, psum_3_reg;
reg [inst_sig_width+inst_exp_width:0] psum_add0_reg, psum_add1_reg;

//---------------------------------------------------------------------
// IPs
//---------------------------------------------------------------------
// fp mult x4
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
    U0_mult ( .a(ifmap_0), .b(weight_0), .rnd(3'd0), .z(psum_0), .status());

DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
    U1_mult ( .a(ifmap_1), .b(weight_1), .rnd(3'd0), .z(psum_1), .status());

DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
    U2_mult ( .a(ifmap_2), .b(weight_2), .rnd(3'd0), .z(psum_2), .status());

DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
    U3_mult ( .a(ifmap_3), .b(weight_3), .rnd(3'd0), .z(psum_3), .status());

// 3-stage adder tree
// stage-1
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
    U1_add_inst_0 (.a(psum_0_reg), .b(psum_1_reg), .rnd(3'd0),.z(psum_add0), .status());

DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
    U1_add_inst_1 (.a(psum_2_reg), .b(psum_3_reg), .rnd(3'd0),.z(psum_add1), .status());

// stage-2
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
    U1_add_inst_2 (.a(psum_add0_reg), .b(psum_add1_reg), .rnd(3'd0),.z(psum_temp), .status());

// stage-3
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
    U1_add_inst_3 (.a(psum_in), .b(psum_temp_reg), .rnd(3'd0),.z(psum_out), .status());

//---------------------------------------------------------------------
// Pipeline
//---------------------------------------------------------------------
// 4-Stage
always @(posedge clk) begin
    psum_0_reg <= psum_0;
    psum_1_reg <= psum_1;
    psum_2_reg <= psum_2;
    psum_3_reg <= psum_3;

    psum_add0_reg <= psum_add0;
    psum_add1_reg <= psum_add1;

    psum_temp_reg <= psum_temp;
end

endmodule


module DW_COMP #(
    parameter inst_sig_width = 23,
    parameter inst_exp_width = 8,
    parameter inst_ieee_compliance = 0
)
(   input clk,
    input rst_n,
    input clear,
    input en,
    input [inst_sig_width+inst_exp_width:0] in_1,
    input [inst_sig_width+inst_exp_width:0] in_2,
    output reg [inst_sig_width+inst_exp_width:0] max_reg
);

wire [inst_sig_width+inst_exp_width:0] max_temp, max;

DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
    U1 ( .a(in_1), .b(in_2), .zctr(1'b1), .z0(max_temp), .z1());

DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
    U2 ( .a(max_reg), .b(max_temp), .zctr(1'b1), .z0(max), .z1());

 // the most negative value
localparam NUM_NEG = 32'b1_11111110_11111111111111111111111;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        max_reg <= NUM_NEG;
    end
    else if(clear) begin
        max_reg <= NUM_NEG;
    end
    else if(en) begin
        max_reg <= max;
    end
end

endmodule


// 4-stage pipeline
module DW_ACT_SOFTMAX #(
    parameter inst_sig_width = 23,
    parameter inst_exp_width = 8,
    parameter inst_ieee_compliance = 0,
    parameter inst_arch = 0,
    parameter inst_faithful_round = 0
)
(   input clk,
    input rst_n,
    input opt,  // 1 for tanh, 0 for sigmoid
    input mode, // 0 for activation, 1 for softmax
    input [4:0] addr,
    input [inst_sig_width+inst_exp_width:0] flatten,
    output reg [inst_sig_width+inst_exp_width:0] act_out
);

localparam NUM_1 = 32'b0_01111111_00000000000000000000000;  // 1

wire sign_inv = ~flatten[31];

wire [inst_sig_width+inst_exp_width:0] exp_in = {sign_inv, flatten[30:0]};
wire [inst_sig_width+inst_exp_width:0] exp_in_2;        // 2 * flatten

wire [inst_sig_width+inst_exp_width:0] exp_out;         // e^(-a)
wire [inst_sig_width+inst_exp_width:0] exp_out_2;       // e^(-2a)
wire [inst_sig_width+inst_exp_width:0] one_plus_exp;    // 1+e^()
wire [inst_sig_width+inst_exp_width:0] one_minus_exp;   // 1-e^()
wire [inst_sig_width+inst_exp_width:0] act_result;
wire [inst_sig_width+inst_exp_width:0] exp_sum;

// pipeline regs
reg [inst_sig_width+inst_exp_width:0] exp_in_reg;
reg [inst_sig_width+inst_exp_width:0] exp_out_reg;
reg [inst_sig_width+inst_exp_width:0] exp_out_2_reg;
reg [inst_sig_width+inst_exp_width:0] exp_out_reg_1;
reg [inst_sig_width+inst_exp_width:0] exp_out_reg_2;
reg [inst_sig_width+inst_exp_width:0] num_reg, den_reg;


//---------------------------------------------------------------------
// IPs
//---------------------------------------------------------------------
FP_mult_by_2 FP_mult_by_2_inst (
    .num_in(exp_in), 
    .num_out(exp_in_2) 
);

// inst_arch:0(area), 1(speed), 2(default)
DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance, 1) 
DW_fp_exp_inst (
    .a({exp_in_reg[31:8], 8'd0}),
    .z(exp_out)
);

DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
DW_fp_add_inst_1 ( 
    .a(NUM_1), 
    .b(exp_out_reg), 
    .rnd(3'd0), 
    .z(one_plus_exp)
);

DW_fp_sub #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
DW_fp_sub_inst_1 ( 
    .a(NUM_1), 
    .b(exp_out_reg), 
    .rnd(3'd0), 
    .z(one_minus_exp)
);

// reciprocal and mult (2-stage pipelined divider)
FP_div_pipe #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_faithful_round) 
FP_div_pipe_inst ( 
    .clk(clk),
    .rst_n(rst_n),
    .num(num_reg), 
    .den(den_reg), 
    .result(act_result)
);

/*
// combinational FP div
DW_fp_div #(inst_sig_width, inst_exp_width, inst_ieee_compliance) 
DW_fp_div_inst( 
    .a(num_reg), 
    .b(den_reg), 
    .rnd(3'd0), 
    .z(act_result)
);
*/
/*
// 2-stage Pipelined fp div
parameter faithful_round = 0;
parameter op_iso_mode    = 0;
parameter id_width       = 1;
parameter in_reg         = 0;
parameter stages         = 2; // pipeline delay 1
parameter out_reg        = 0;
parameter no_pm          = 0; // enable pipeline
parameter rst_mode       = 0; // async
DW_lp_piped_fp_div #(inst_sig_width, inst_exp_width, inst_ieee_compliance, 
faithful_round, op_iso_mode, id_width, in_reg, stages, out_reg, no_pm, rst_mode)
U1 (.clk            (clk),
    .rst_n          (rst_n),
    .a              (num_reg),
    .b              (den_reg),
    .rnd            (3'd0),
    .z              (act_result),
    //.status         (status_inst),
    .launch         (1'b1),
    .launch_id      (1'd0),
    //.pipe_full      (pipe_full_inst),
    //.pipe_ovf       (pipe_ovf_inst),
    .accept_n       (0)
    //.arrive         (arrive_inst),
    //.arrive_id      (arrive_id_inst),
    //.push_out_n     (push_out_n_inst),
    //.pipe_census    (pipe_census_inst) 
);
*/

wire [31:0] sum_temp;
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
DW_fp_add_inst_2 ( 
    .a(exp_out_reg), 
    .b(exp_out_reg_1), 
    .rnd(3'd0), 
    .z(sum_temp)
);

DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
DW_fp_add_inst_3 ( 
    .a(sum_temp), 
    .b(exp_out_reg_2), 
    .rnd(3'd0), 
    .z(exp_sum)
);

//---------------------------------------------------------------------
// Pipeline
//---------------------------------------------------------------------
// stage-1
always @(posedge clk) begin
    if(mode == 1'b1) begin // softmax
        exp_in_reg <= flatten;
    end
    else if(opt) begin // tanh
        exp_in_reg <= exp_in_2;
    end
    else begin
        exp_in_reg <= exp_in;
    end
end

// stage-2
always @(posedge clk) begin
    exp_out_reg <= exp_out; // delay 0
end

// stage-3 (softmax)
always @(posedge clk) begin
    if(mode) begin
        exp_out_reg_1 <= exp_out_reg; // delay 1
    end
    else begin
        exp_out_reg_1 <= one_plus_exp;
    end
end

// stage-4 (softmax)
always @(posedge clk) begin
    if(mode) begin
        exp_out_reg_2 <= exp_out_reg_1; // delay 2
    end
    else begin
        exp_out_reg_2 <= one_minus_exp;
    end
end

// stage-3 (activation)
always @(posedge clk) begin
    if(mode) begin
        num_reg <= exp_out_reg_2; // delay 3
    end
    else if(opt) begin  // tanh
        num_reg <= one_minus_exp;
    end
    else begin // sigmoid
        num_reg <= NUM_1;
    end
end

// stage-3 (activation)
always @(posedge clk) begin
    if(~mode) begin // tanh, sigmoid
        den_reg <= one_plus_exp;
    end
    else if(addr == 'd1) begin
        den_reg <= exp_sum;
    end
end

// stage-4 (activation)
always @(posedge clk) begin
    act_out <= act_result;
end

endmodule



module FP_mult_by_2(
    input [31:0] num_in,
    output reg [31:0] num_out
);

 wire sign;
 wire [7:0] exponent;
 wire [22:0] mantissa;

 assign sign = num_in[31];
 assign exponent = num_in[30:23];
 assign mantissa = num_in[22:0];

 always @(*) begin
     if (exponent == 8'hFF) begin
         num_out = num_in;
     end 
     else if (num_in[30:0] == 31'b0) begin
         num_out = num_in;
     end 
     else begin
         num_out[31] = sign;
         num_out[30:23] = exponent + 'd1;
         num_out[22:0] = mantissa;
     end
 end

endmodule


// 2-stage pipelined divider
module FP_div_pipe #(
    parameter inst_sig_width = 23,
    parameter inst_exp_width = 8,
    parameter inst_ieee_compliance = 0,
    parameter inst_faithful_round = 0
)
(   input clk,
    input rst_n,
    input [inst_sig_width+inst_exp_width:0] num,
    input [inst_sig_width+inst_exp_width:0] den,
    output [inst_sig_width+inst_exp_width:0] result
);


wire [inst_sig_width+inst_exp_width:0] den_recip;
reg [inst_sig_width+inst_exp_width:0] den_recip_reg;
reg [inst_sig_width+inst_exp_width:0] num_reg;

DW_fp_recip #(inst_sig_width, inst_exp_width, inst_ieee_compliance, 1) 
DW_fp_recip_inst_0 (
   .a      (den),
   .rnd    (3'd0),
   .z      (den_recip)
);

DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
DW_fp_mult_inst_0 ( 
    .a  (num_reg), 
    .b  (den_recip_reg), 
    .rnd(3'd0), 
    .z  (result)
);

always @(posedge clk) begin
    num_reg <= num;
end

always @(posedge clk) begin
    den_recip_reg <= den_recip;
end

endmodule
