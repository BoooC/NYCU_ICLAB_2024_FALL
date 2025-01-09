module ISP(
    // Input Signals
    input               clk,
    input               rst_n,
    input               in_valid,
    input       [3:0]   in_pic_no,
    input               in_mode,
    input       [1:0]   in_ratio_mode,

    // Output Signals
    output reg          out_valid,
    output reg  [7:0]   out_data,
    
    // DRAM Signals
    // axi write address channel
    // src master
    output reg  [3:0]   awid_s_inf,       // fix
    output reg  [31:0]  awaddr_s_inf,
    output reg  [2:0]   awsize_s_inf,     // fix
    output reg  [1:0]   awburst_s_inf,    // fix
    output reg  [7:0]   awlen_s_inf,
    output reg          awvalid_s_inf,
    // src slave
    input               awready_s_inf,
    // -----------------------------
 
    // axi write data channel 
    // src master
    output reg  [127:0] wdata_s_inf,
    output reg          wlast_s_inf,
    output reg          wvalid_s_inf,
    // src slave
    input               wready_s_inf,
  
    // axi write response channel 
    // src slave
    input       [3:0]   bid_s_inf,
    input       [1:0]   bresp_s_inf,
    input               bvalid_s_inf,
    // src master 
    output reg          bready_s_inf,
    // -----------------------------
  
    // axi read address channel 
    // src master
    output reg  [3:0]   arid_s_inf,     // fix
    output reg  [31:0]  araddr_s_inf,
    output reg  [7:0]   arlen_s_inf,    // fix
    output reg  [2:0]   arsize_s_inf,   // fix
    output reg  [1:0]   arburst_s_inf,  // fix
    output reg          arvalid_s_inf,
    // src slave
    input               arready_s_inf,
    // -----------------------------
  
    // axi read data channel 
    // slave
    input       [3:0]   rid_s_inf,
    input       [127:0] rdata_s_inf,
    input       [1:0]   rresp_s_inf,     // fix okay
    input               rlast_s_inf,
    input               rvalid_s_inf,
    // master
    output reg          rready_s_inf
    
);

//==================================================================
// parameter & integer
//==================================================================
parameter AUTO_FOCUS_MODE   = 1'b0;
parameter EXPOSURE_MODE     = 1'b1;

// one-hot encoding
localparam IDLE         = 6'b000000;
localparam DIN_WAIT     = 6'b000001;
localparam DIN          = 6'b000010;
localparam READ_DRAM    = 6'b000100;
localparam AUTO_FOCUS   = 6'b001000;
localparam EXPOSURE     = 6'b010000;
localparam DOUT         = 6'b100000;

// localparam IDLE         = 'd0;
// localparam DIN_WAIT     = 'd1;
// localparam DIN          = 'd2;
// localparam READ_DRAM    = 'd3;
// localparam AUTO_FOCUS   = 'd4;
// localparam EXPOSURE     = 'd5;
// localparam DOUT         = 'd6;

//==================================================================
// reg
//==================================================================
// FSM state
reg [5:0] state, next_state;

// input reg
reg in_valid_reg;
reg in_mode_reg;
reg [3:0] in_pic_no_reg;
reg [1:0] in_ratio_mode_reg;
reg [6:0] gray_data_reg [0:5];

// counter
reg [5:0] in_count;
reg [1:0] channel_count;
reg [1:0] wdata_dly_count;
reg [2:0] exposure_count;
reg [3:0] focus_count;
reg [4:0] focus_pipe_count;

// auto focus
reg [7:0]  center_buffer [0:35];
reg [7:0]  focus_sub_in_1_reg  [0:5];
reg [7:0]  focus_sub_in_2_reg  [0:5];
reg [7:0]  focus_add_stage_1_reg [0:5];
reg [8:0]  focus_add_stage_2_reg [0:2];
reg [9:0]  focus_add_stage_3_reg [0:1];
reg [10:0] focus_add_stage_4_reg;
reg [9:0]  diff_acc_reg_2;
reg [12:0] diff_acc_reg_4;
reg [13:0] diff_acc_reg_6;
reg [7:0]  focus_reg_2;
reg [8:0]  focus_reg_4;
reg [8:0]  focus_reg_6;
reg [1:0]  focus_out_reg;
reg [1:0]  focus_restore;

// auto exposure
reg [6:0]  adj_gray_data_reg[0:15];
reg [7:0]  add_center_in_reg[0:5];
reg [6:0]  add_gray_in_reg  [0:5];
reg [7:0]  exp_add_stage_1_reg  [7:0];
reg [8:0]  exp_add_stage_2_reg  [3:0];
reg [9:0]  exp_add_stage_3_reg  [1:0];
reg [10:0] exp_add_stage_4_reg;
reg [17:0] exposure_acc;
reg [7:0]  exposure_acc_restore;

// pipeline divider
wire div_out_valid;
wire [8:0] div_out;

// record previous reesult
reg [1:0] focus_record      [0:15];
reg [7:0] exposure_record   [0:15];
reg focus_record_flag       [0:15];
reg exposure_record_flag    [0:15];
reg all_zero_flag           [0:15];

reg focus_exist_reg;
reg exposure_exist_reg;
reg current_not_all_zero_flag;
reg direct_out_reg;
reg all_zero_flag_reg;

//==================================================================
// Wires
//==================================================================
/*
// axi write address channel
assign awid_s_inf 		= 0;
assign awsize_s_inf 	= 3'b100;
assign awburst_s_inf 	= 2'b01;
// axi read address channel
assign arid_s_inf 		= 0;
assign arsize_s_inf		= 3'b100;
assign arburst_s_inf	= 2'b01;
// axi write data channel
assign awaddr_s_inf = araddr_s_inf;
assign awlen_s_inf  = 8'd191;
assign bready_s_inf = 1'b1;
*/

// axi start address
// wire [15:0] dram_pic_idx = in_pic_no_reg * 'd3072;
// wire [16:0] dram_pic_start_idx = dram_pic_idx + 'h10000;
reg [16:0] dram_pic_start_idx;
always @(*) begin
    case(in_pic_no_reg)
        'd0  : dram_pic_start_idx = 'h10000;
        'd1  : dram_pic_start_idx = 'h10C00;
        'd2  : dram_pic_start_idx = 'h11800;
        'd3  : dram_pic_start_idx = 'h12400;
        'd4  : dram_pic_start_idx = 'h13000;
        'd5  : dram_pic_start_idx = 'h13C00;
        'd6  : dram_pic_start_idx = 'h14800;
        'd7  : dram_pic_start_idx = 'h15400;
        'd8  : dram_pic_start_idx = 'h16000;
        'd9  : dram_pic_start_idx = 'h16C00;
        'd10 : dram_pic_start_idx = 'h17800;
        'd11 : dram_pic_start_idx = 'h18400;
        'd12 : dram_pic_start_idx = 'h19000;
        'd13 : dram_pic_start_idx = 'h19C00;
        'd14 : dram_pic_start_idx = 'h1A800;
        'd15 : dram_pic_start_idx = 'h1B400;
        default : dram_pic_start_idx = 'h00000;
    endcase
end
wire [8:0]  mid_start_idx = 'd429;

// debug
wire [7:0] dram_in_dec  [0:15];
wire [7:0] dram_out_dec [0:15];
assign dram_in_dec[0]  = rdata_s_inf[7:0];
assign dram_in_dec[1]  = rdata_s_inf[15:8];
assign dram_in_dec[2]  = rdata_s_inf[23:16];
assign dram_in_dec[3]  = rdata_s_inf[31:24];
assign dram_in_dec[4]  = rdata_s_inf[39:32];
assign dram_in_dec[5]  = rdata_s_inf[47:40];
assign dram_in_dec[6]  = rdata_s_inf[55:48];
assign dram_in_dec[7]  = rdata_s_inf[63:56];
assign dram_in_dec[8]  = rdata_s_inf[71:64];
assign dram_in_dec[9]  = rdata_s_inf[79:72];
assign dram_in_dec[10] = rdata_s_inf[87:80];
assign dram_in_dec[11] = rdata_s_inf[95:88];
assign dram_in_dec[12] = rdata_s_inf[103:96];
assign dram_in_dec[13] = rdata_s_inf[111:104];
assign dram_in_dec[14] = rdata_s_inf[119:112];
assign dram_in_dec[15] = rdata_s_inf[127:120];
assign dram_out_dec[0] = wdata_s_inf[7:0];
assign dram_out_dec[1] = wdata_s_inf[15:8];
assign dram_out_dec[2] = wdata_s_inf[23:16];
assign dram_out_dec[3] = wdata_s_inf[31:24];
assign dram_out_dec[4] = wdata_s_inf[39:32];
assign dram_out_dec[5] = wdata_s_inf[47:40];
assign dram_out_dec[6] = wdata_s_inf[55:48];
assign dram_out_dec[7] = wdata_s_inf[63:56];
assign dram_out_dec[8] = wdata_s_inf[71:64];
assign dram_out_dec[9] = wdata_s_inf[79:72];
assign dram_out_dec[10]= wdata_s_inf[87:80];
assign dram_out_dec[11]= wdata_s_inf[95:88];
assign dram_out_dec[12]= wdata_s_inf[103:96];
assign dram_out_dec[13]= wdata_s_inf[111:104];
assign dram_out_dec[14]= wdata_s_inf[119:112];
assign dram_out_dec[15]= wdata_s_inf[127:120];

// input processing
wire [7:0] dram_in_adj  [0:15];
wire [6:0] adj_gray_data[0:15];
wire [6:0] gray_data    [0:5];

assign dram_in_adj[0]   = (rdata_s_inf[7]   & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[7:0]     << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[1]   = (rdata_s_inf[15]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[15:8]    << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[2]   = (rdata_s_inf[23]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[23:16]   << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[3]   = (rdata_s_inf[31]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[31:24]   << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[4]   = (rdata_s_inf[39]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[39:32]   << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[5]   = (rdata_s_inf[47]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[47:40]   << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[6]   = (rdata_s_inf[55]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[55:48]   << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[7]   = (rdata_s_inf[63]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[63:56]   << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[8]   = (rdata_s_inf[71]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[71:64]   << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[9]   = (rdata_s_inf[79]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[79:72]   << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[10]  = (rdata_s_inf[87]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[87:80]   << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[11]  = (rdata_s_inf[95]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[95:88]   << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[12]  = (rdata_s_inf[103] & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[103:96]  << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[13]  = (rdata_s_inf[111] & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[111:104] << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[14]  = (rdata_s_inf[119] & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[119:112] << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[15]  = (rdata_s_inf[127] & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[127:120] << 1) >> ('d3 - in_ratio_mode_reg));

assign adj_gray_data[0] = dram_in_adj[0]  >> ('d2 - channel_count[0]);
assign adj_gray_data[1] = dram_in_adj[1]  >> ('d2 - channel_count[0]);
assign adj_gray_data[2] = dram_in_adj[2]  >> ('d2 - channel_count[0]);
assign adj_gray_data[3] = dram_in_adj[3]  >> ('d2 - channel_count[0]);
assign adj_gray_data[4] = dram_in_adj[4]  >> ('d2 - channel_count[0]);
assign adj_gray_data[5] = dram_in_adj[5]  >> ('d2 - channel_count[0]);
assign adj_gray_data[6] = dram_in_adj[6]  >> ('d2 - channel_count[0]);
assign adj_gray_data[7] = dram_in_adj[7]  >> ('d2 - channel_count[0]);
assign adj_gray_data[8] = dram_in_adj[8]  >> ('d2 - channel_count[0]);
assign adj_gray_data[9] = dram_in_adj[9]  >> ('d2 - channel_count[0]);
assign adj_gray_data[10]= dram_in_adj[10] >> ('d2 - channel_count[0]);
assign adj_gray_data[11]= dram_in_adj[11] >> ('d2 - channel_count[0]);
assign adj_gray_data[12]= dram_in_adj[12] >> ('d2 - channel_count[0]);
assign adj_gray_data[13]= dram_in_adj[13] >> ('d2 - channel_count[0]);
assign adj_gray_data[14]= dram_in_adj[14] >> ('d2 - channel_count[0]);
assign adj_gray_data[15]= dram_in_adj[15] >> ('d2 - channel_count[0]);

assign gray_data[0] = rdata_s_inf[7:0]   >> ('d2 - channel_count[0]);
assign gray_data[1] = rdata_s_inf[15:8]  >> ('d2 - channel_count[0]);
assign gray_data[2] = rdata_s_inf[23:16] >> ('d2 - channel_count[0]);
assign gray_data[3] = rdata_s_inf[31:24] >> ('d2 - channel_count[0]);
assign gray_data[4] = rdata_s_inf[39:32] >> ('d2 - channel_count[0]);
assign gray_data[5] = rdata_s_inf[47:40] >> ('d2 - channel_count[0]);

// focus
wire [8:0] sub_out_signed [0:5];
wire [7:0] sub_out [0:5];
/*
assign sub_out_signed[0] = focus_sub_in_1_reg[0] - focus_sub_in_2_reg[0];
assign sub_out_signed[1] = focus_sub_in_1_reg[1] - focus_sub_in_2_reg[1];
assign sub_out_signed[2] = focus_sub_in_1_reg[2] - focus_sub_in_2_reg[2];
assign sub_out_signed[3] = focus_sub_in_1_reg[3] - focus_sub_in_2_reg[3];
assign sub_out_signed[4] = focus_sub_in_1_reg[4] - focus_sub_in_2_reg[4];
assign sub_out_signed[5] = focus_sub_in_1_reg[5] - focus_sub_in_2_reg[5];

assign sub_out[0] = sub_out_signed[0][8] ? (~sub_out_signed[0] + 'd1) : sub_out_signed[0];
assign sub_out[1] = sub_out_signed[1][8] ? (~sub_out_signed[1] + 'd1) : sub_out_signed[1];
assign sub_out[2] = sub_out_signed[2][8] ? (~sub_out_signed[2] + 'd1) : sub_out_signed[2];
assign sub_out[3] = sub_out_signed[3][8] ? (~sub_out_signed[3] + 'd1) : sub_out_signed[3];
assign sub_out[4] = sub_out_signed[4][8] ? (~sub_out_signed[4] + 'd1) : sub_out_signed[4];
assign sub_out[5] = sub_out_signed[5][8] ? (~sub_out_signed[5] + 'd1) : sub_out_signed[5];
*/
assign sub_out[0] = (focus_sub_in_1_reg[0] > focus_sub_in_2_reg[0]) ? (focus_sub_in_1_reg[0] - focus_sub_in_2_reg[0]) : (focus_sub_in_2_reg[0] - focus_sub_in_1_reg[0]);
assign sub_out[1] = (focus_sub_in_1_reg[1] > focus_sub_in_2_reg[1]) ? (focus_sub_in_1_reg[1] - focus_sub_in_2_reg[1]) : (focus_sub_in_2_reg[1] - focus_sub_in_1_reg[1]);
assign sub_out[2] = (focus_sub_in_1_reg[2] > focus_sub_in_2_reg[2]) ? (focus_sub_in_1_reg[2] - focus_sub_in_2_reg[2]) : (focus_sub_in_2_reg[2] - focus_sub_in_1_reg[2]);
assign sub_out[3] = (focus_sub_in_1_reg[3] > focus_sub_in_2_reg[3]) ? (focus_sub_in_1_reg[3] - focus_sub_in_2_reg[3]) : (focus_sub_in_2_reg[3] - focus_sub_in_1_reg[3]);
assign sub_out[4] = (focus_sub_in_1_reg[4] > focus_sub_in_2_reg[4]) ? (focus_sub_in_1_reg[4] - focus_sub_in_2_reg[4]) : (focus_sub_in_2_reg[4] - focus_sub_in_1_reg[4]);
assign sub_out[5] = (focus_sub_in_1_reg[5] > focus_sub_in_2_reg[5]) ? (focus_sub_in_1_reg[5] - focus_sub_in_2_reg[5]) : (focus_sub_in_2_reg[5] - focus_sub_in_1_reg[5]);

// exposure
wire [7:0] add_out [0:5];
assign add_out[0] = add_center_in_reg[0] + add_gray_in_reg[0];
assign add_out[1] = add_center_in_reg[1] + add_gray_in_reg[1];
assign add_out[2] = add_center_in_reg[2] + add_gray_in_reg[2];
assign add_out[3] = add_center_in_reg[3] + add_gray_in_reg[3];
assign add_out[4] = add_center_in_reg[4] + add_gray_in_reg[4];
assign add_out[5] = add_center_in_reg[5] + add_gray_in_reg[5];

// handshake
wire ar_shake   = arvalid_s_inf & arready_s_inf;
wire r_shake    = rvalid_s_inf  & rready_s_inf;
wire aw_shake   = awvalid_s_inf & awready_s_inf;
wire w_shake    = wvalid_s_inf  & wready_s_inf;

// skip signals
wire focus_exist    = focus_record_flag[in_pic_no_reg] & (in_mode_reg == AUTO_FOCUS_MODE);
wire exposure_exist = exposure_record_flag[in_pic_no_reg] & (in_mode_reg == EXPOSURE_MODE) & (in_ratio_mode_reg == 'd2);

// control
wire horiz_flag     = focus_pipe_count < 'd7;
wire read_dram_done = (in_mode_reg == AUTO_FOCUS_MODE) ? (channel_count == 'd2 & in_count == 'd14) : (channel_count == 'd2 & in_count == 'd63);
wire focus_in_done  = focus_pipe_count == 'd16;
wire focus_done     = focus_count == 'd13;
wire exposure_done  = exposure_count == 'd4;
wire direct_out     = focus_exist | exposure_exist | all_zero_flag[in_pic_no_reg];

//==================================================================
// Design
//==================================================================
// next state logic
always @(*) begin
    case(state)
        IDLE        : next_state = in_valid         ? DIN_WAIT  : IDLE;
        DIN_WAIT    : next_state = DIN;
        DIN         : next_state = direct_out_reg   ? DOUT      : READ_DRAM;
        READ_DRAM   : next_state = read_dram_done   ? (in_mode_reg == AUTO_FOCUS_MODE ? AUTO_FOCUS : EXPOSURE) : READ_DRAM;
        AUTO_FOCUS  : next_state = focus_done       ? DOUT      : AUTO_FOCUS;
        EXPOSURE    : next_state = exposure_done    ? DOUT      : EXPOSURE;
        DOUT        : next_state = IDLE;
        default     : next_state = IDLE;
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

// input reg
always @(posedge clk) begin
    in_valid_reg <= in_valid;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        in_pic_no_reg <= 'd0;
    end
    else if(in_valid) begin
        in_pic_no_reg <= in_pic_no;
    end
    else begin
        in_pic_no_reg <= in_pic_no_reg;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        in_mode_reg <= 'd0;
    end
    else if(in_valid) begin
        in_mode_reg <= in_mode;
    end
    else begin
        in_mode_reg <= in_mode_reg;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        in_ratio_mode_reg <= 'd0;
    end
    else if(in_valid & in_mode == EXPOSURE_MODE) begin
        in_ratio_mode_reg <= in_ratio_mode;
    end
    else begin
        in_ratio_mode_reg <= in_ratio_mode_reg;
    end
end

always @(posedge clk) begin
    direct_out_reg <= direct_out;
end

// DRAM fixed signals
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        awid_s_inf      <= 'd0;
        awsize_s_inf    <= 'd0;
        awburst_s_inf   <= 'd0;
        arid_s_inf      <= 'd0;
        arsize_s_inf    <= 'd0;
        arburst_s_inf   <= 'd0;
        awaddr_s_inf    <= 'd0;
        awlen_s_inf     <= 'd0;
        bready_s_inf    <= 'd0;
    end
    else begin
        awid_s_inf      <= 'd0;
        awsize_s_inf    <= 3'b100;
        awburst_s_inf   <= 2'b01;
        arid_s_inf      <= 'd0;
        arsize_s_inf    <= 3'b100;
        arburst_s_inf   <= 2'b01;
        awaddr_s_inf    <= araddr_s_inf;
        awlen_s_inf     <= 8'd191;
        bready_s_inf    <= 1'b1;
    end
end

// DRAM address read
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        arlen_s_inf <= 'd0;
    end
    else if(in_valid) begin
        arlen_s_inf <= (in_mode == AUTO_FOCUS_MODE) ? 'd142 : 'd191;
    end
    else if(state == DOUT) begin
        arlen_s_inf <= 'd0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        araddr_s_inf <= 'd0;
    end
    else if (in_mode_reg == AUTO_FOCUS_MODE) begin
        araddr_s_inf <= dram_pic_start_idx + mid_start_idx;
    end
    else begin
        araddr_s_inf <= dram_pic_start_idx;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        arvalid_s_inf <= 1'b0;
    end
    else if(state == DIN & ~direct_out_reg) begin
        arvalid_s_inf <= 1'b1;
    end
    else if(ar_shake) begin
        arvalid_s_inf <= 1'b0;
    end
    else begin
        arvalid_s_inf <= arvalid_s_inf;
    end
end

// DRAM data read
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        rready_s_inf <= 1'b0;
    end
    else if(ar_shake) begin
        rready_s_inf <= 1'b1;
    end
    else if(rlast_s_inf) begin
        rready_s_inf <= 1'b0;
    end
end

// DRAM address write
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        awvalid_s_inf <= 1'b0;
    end
    else if(aw_shake) begin
        awvalid_s_inf <= 1'b0;
    end
    else if(in_valid_reg & ~direct_out & in_mode_reg == EXPOSURE_MODE) begin
        awvalid_s_inf <= 1'b1;
    end
end

// DRAM data write
always @(posedge clk) begin
    if(state == IDLE) begin
        wdata_dly_count <= 'd0;
    end
    else if(aw_shake | wdata_dly_count !='d0) begin
        wdata_dly_count <= (wdata_dly_count == 'd3) ? 'd3 : (wdata_dly_count + 'd1);
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        wvalid_s_inf <= 'd0;
    end
    else if(rvalid_s_inf & in_mode_reg == EXPOSURE_MODE) begin // r_shake
        wvalid_s_inf <= 'd1;
    end
    else if(wdata_dly_count == 'd3) begin
        wvalid_s_inf <= 'd0;
    end
    else if(in_valid_reg & in_mode_reg == EXPOSURE_MODE) begin // in_valid_reg & ~direct_out & in_mode_reg == EXPOSURE_MODE
        wvalid_s_inf <= 'd1;
    end
end

always @(posedge clk) begin
    wdata_s_inf <= {dram_in_adj[15], dram_in_adj[14], dram_in_adj[13], dram_in_adj[12], 
                    dram_in_adj[11], dram_in_adj[10], dram_in_adj[9],  dram_in_adj[8], 
                    dram_in_adj[7],  dram_in_adj[6],  dram_in_adj[5],  dram_in_adj[4], 
                    dram_in_adj[3],  dram_in_adj[2],  dram_in_adj[1],  dram_in_adj[0]};
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        wlast_s_inf <= 'd0;
    end
    else if(channel_count == 'd2 & in_count == 'd63) begin
        wlast_s_inf <= 'd1;
    end
    else begin
        wlast_s_inf <= 'd0;
    end
end

// counters
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        in_count <= 'd0;
    end
    else if(rvalid_s_inf) begin // r_shake
        in_count <= (in_count == 'd63) ? 'd0 : (in_count + 'd1);
    end
    else if(state == DOUT) begin
        in_count <= 'd0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        channel_count <= 'd0;
    end
    else if(state == DOUT) begin
        channel_count <= 'd0;
    end
    else if(in_count == 'd63) begin
        channel_count <= channel_count + 'd1;
    end
end

// Buffer
always @(posedge clk) begin
    if(in_mode_reg == AUTO_FOCUS_MODE) begin
        add_gray_in_reg[0] <= gray_data_reg[0];
        add_gray_in_reg[1] <= gray_data_reg[1];
        add_gray_in_reg[2] <= gray_data_reg[2];
        add_gray_in_reg[3] <= gray_data_reg[3];
        add_gray_in_reg[4] <= gray_data_reg[4];
        add_gray_in_reg[5] <= gray_data_reg[5];
    end
    else begin
        case(in_count)
            'd27, 'd29, 'd31, 'd33, 'd35, 'd37 : begin
                add_gray_in_reg[0] <= adj_gray_data_reg[13];
                add_gray_in_reg[1] <= adj_gray_data_reg[14];
                add_gray_in_reg[2] <= adj_gray_data_reg[15];
                add_gray_in_reg[3] <= 'd0;
                add_gray_in_reg[4] <= 'd0;
                add_gray_in_reg[5] <= 'd0;
            end
            'd28, 'd30, 'd32, 'd34, 'd36, 'd38 : begin
                add_gray_in_reg[0] <= 'd0;
                add_gray_in_reg[1] <= 'd0;
                add_gray_in_reg[2] <= 'd0;
                add_gray_in_reg[3] <= adj_gray_data_reg[0];
                add_gray_in_reg[4] <= adj_gray_data_reg[1];
                add_gray_in_reg[5] <= adj_gray_data_reg[2];
            end
            default : begin
                add_gray_in_reg[0] <= 'd0;
                add_gray_in_reg[1] <= 'd0;
                add_gray_in_reg[2] <= 'd0;
                add_gray_in_reg[3] <= 'd0;
                add_gray_in_reg[4] <= 'd0;
                add_gray_in_reg[5] <= 'd0;
            end
        endcase
    end
end

// exposure result accumulation
always @(posedge clk) begin
    if(in_mode_reg == AUTO_FOCUS_MODE) begin
        case (in_count)
            1: begin
                add_center_in_reg[0] <= center_buffer[0];
                add_center_in_reg[1] <= center_buffer[1];
                add_center_in_reg[2] <= center_buffer[2];
                add_center_in_reg[3] <= center_buffer[3];
                add_center_in_reg[4] <= center_buffer[4];
                add_center_in_reg[5] <= center_buffer[5];
            end
            3: begin
                add_center_in_reg[0] <= center_buffer[6];
                add_center_in_reg[1] <= center_buffer[7];
                add_center_in_reg[2] <= center_buffer[8];
                add_center_in_reg[3] <= center_buffer[9];
                add_center_in_reg[4] <= center_buffer[10];
                add_center_in_reg[5] <= center_buffer[11];
            end
            5: begin
                add_center_in_reg[0] <= center_buffer[12];
                add_center_in_reg[1] <= center_buffer[13];
                add_center_in_reg[2] <= center_buffer[14];
                add_center_in_reg[3] <= center_buffer[15];
                add_center_in_reg[4] <= center_buffer[16];
                add_center_in_reg[5] <= center_buffer[17];
            end
            7: begin
                add_center_in_reg[0] <= center_buffer[18];
                add_center_in_reg[1] <= center_buffer[19];
                add_center_in_reg[2] <= center_buffer[20];
                add_center_in_reg[3] <= center_buffer[21];
                add_center_in_reg[4] <= center_buffer[22];
                add_center_in_reg[5] <= center_buffer[23];
            end
            9: begin
                add_center_in_reg[0] <= center_buffer[24];
                add_center_in_reg[1] <= center_buffer[25];
                add_center_in_reg[2] <= center_buffer[26];
                add_center_in_reg[3] <= center_buffer[27];
                add_center_in_reg[4] <= center_buffer[28];
                add_center_in_reg[5] <= center_buffer[29];
            end
            11: begin
                add_center_in_reg[0] <= center_buffer[30];
                add_center_in_reg[1] <= center_buffer[31];
                add_center_in_reg[2] <= center_buffer[32];
                add_center_in_reg[3] <= center_buffer[33];
                add_center_in_reg[4] <= center_buffer[34];
                add_center_in_reg[5] <= center_buffer[35];
            end
            default: begin
                add_center_in_reg[0] <= 'd0;
                add_center_in_reg[1] <= 'd0;
                add_center_in_reg[2] <= 'd0;
                add_center_in_reg[3] <= 'd0;
                add_center_in_reg[4] <= 'd0;
                add_center_in_reg[5] <= 'd0;
            end
        endcase
    end
    else begin
        case(in_count)
            27: begin
                add_center_in_reg[0] <= center_buffer[0];
                add_center_in_reg[1] <= center_buffer[1];
                add_center_in_reg[2] <= center_buffer[2];
                add_center_in_reg[3] <= 'd0;
                add_center_in_reg[4] <= 'd0;
                add_center_in_reg[5] <= 'd0;
            end
            28: begin
                add_center_in_reg[0] <= 'd0;
                add_center_in_reg[1] <= 'd0;
                add_center_in_reg[2] <= 'd0;
                add_center_in_reg[3] <= center_buffer[3];
                add_center_in_reg[4] <= center_buffer[4];
                add_center_in_reg[5] <= center_buffer[5];
            end
            29: begin
                add_center_in_reg[0] <= center_buffer[6];
                add_center_in_reg[1] <= center_buffer[7];
                add_center_in_reg[2] <= center_buffer[8];
                add_center_in_reg[3] <= 'd0;
                add_center_in_reg[4] <= 'd0;
                add_center_in_reg[5] <= 'd0;
            end
            30: begin
                add_center_in_reg[0] <= 'd0;
                add_center_in_reg[1] <= 'd0;
                add_center_in_reg[2] <= 'd0;
                add_center_in_reg[3] <= center_buffer[9];
                add_center_in_reg[4] <= center_buffer[10];
                add_center_in_reg[5] <= center_buffer[11];
            end
            31: begin
                add_center_in_reg[0] <= center_buffer[12];
                add_center_in_reg[1] <= center_buffer[13];
                add_center_in_reg[2] <= center_buffer[14];
                add_center_in_reg[3] <= 'd0;
                add_center_in_reg[4] <= 'd0;
                add_center_in_reg[5] <= 'd0;
            end
            32: begin
                add_center_in_reg[0] <= 'd0;
                add_center_in_reg[1] <= 'd0;
                add_center_in_reg[2] <= 'd0;
                add_center_in_reg[3] <= center_buffer[15];
                add_center_in_reg[4] <= center_buffer[16];
                add_center_in_reg[5] <= center_buffer[17];
            end
            33: begin
                add_center_in_reg[0] <= center_buffer[18];
                add_center_in_reg[1] <= center_buffer[19];
                add_center_in_reg[2] <= center_buffer[20];
                add_center_in_reg[3] <= 'd0;
                add_center_in_reg[4] <= 'd0;
                add_center_in_reg[5] <= 'd0;
            end
            34: begin
                add_center_in_reg[0] <= 'd0;
                add_center_in_reg[1] <= 'd0;
                add_center_in_reg[2] <= 'd0;
                add_center_in_reg[3] <= center_buffer[21];
                add_center_in_reg[4] <= center_buffer[22];
                add_center_in_reg[5] <= center_buffer[23];
            end
            35: begin
                add_center_in_reg[0] <= center_buffer[24];
                add_center_in_reg[1] <= center_buffer[25];
                add_center_in_reg[2] <= center_buffer[26];
                add_center_in_reg[3] <= 'd0;
                add_center_in_reg[4] <= 'd0;
                add_center_in_reg[5] <= 'd0;
            end
            36: begin
                add_center_in_reg[0] <= 'd0;
                add_center_in_reg[1] <= 'd0;
                add_center_in_reg[2] <= 'd0;
                add_center_in_reg[3] <= center_buffer[27];
                add_center_in_reg[4] <= center_buffer[28];
                add_center_in_reg[5] <= center_buffer[29];
            end
            37: begin
                add_center_in_reg[0] <= center_buffer[30];
                add_center_in_reg[1] <= center_buffer[31];
                add_center_in_reg[2] <= center_buffer[32];
                add_center_in_reg[3] <= 'd0;
                add_center_in_reg[4] <= 'd0;
                add_center_in_reg[5] <= 'd0;
            end
            38: begin
                add_center_in_reg[0] <= 'd0;
                add_center_in_reg[1] <= 'd0;
                add_center_in_reg[2] <= 'd0;
                add_center_in_reg[3] <= center_buffer[33];
                add_center_in_reg[4] <= center_buffer[34];
                add_center_in_reg[5] <= center_buffer[35];
            end
            default : begin
                add_center_in_reg[0] <= 'd0;
                add_center_in_reg[1] <= 'd0;
                add_center_in_reg[2] <= 'd0;
                add_center_in_reg[3] <= 'd0;
                add_center_in_reg[4] <= 'd0;
                add_center_in_reg[5] <= 'd0;
            end
        endcase
    end
end

// focus center 6x6 buffer
integer i;
always @(posedge clk) begin
    if(state == IDLE) begin
        for(i=0; i<36; i=i+1) begin
            center_buffer[i] <= 'd0;
        end
    end
    else if (in_mode_reg == AUTO_FOCUS_MODE) begin
        case (in_count)
            2: begin
                center_buffer[0] <= add_out[0];
                center_buffer[1] <= add_out[1];
                center_buffer[2] <= add_out[2];
                center_buffer[3] <= add_out[3];
                center_buffer[4] <= add_out[4];
                center_buffer[5] <= add_out[5];
            end
            4: begin
                center_buffer[6]  <= add_out[0];
                center_buffer[7]  <= add_out[1];
                center_buffer[8]  <= add_out[2];
                center_buffer[9]  <= add_out[3];
                center_buffer[10] <= add_out[4];
                center_buffer[11] <= add_out[5];
            end
            6: begin
                center_buffer[12] <= add_out[0];
                center_buffer[13] <= add_out[1];
                center_buffer[14] <= add_out[2];
                center_buffer[15] <= add_out[3];
                center_buffer[16] <= add_out[4];
                center_buffer[17] <= add_out[5];
            end
            8: begin
                center_buffer[18] <= add_out[0];
                center_buffer[19] <= add_out[1];
                center_buffer[20] <= add_out[2];
                center_buffer[21] <= add_out[3];
                center_buffer[22] <= add_out[4];
                center_buffer[23] <= add_out[5];
            end
            10: begin
                center_buffer[24] <= add_out[0];
                center_buffer[25] <= add_out[1];
                center_buffer[26] <= add_out[2];
                center_buffer[27] <= add_out[3];
                center_buffer[28] <= add_out[4];
                center_buffer[29] <= add_out[5];
            end
            12: begin
                center_buffer[30] <= add_out[0];
                center_buffer[31] <= add_out[1];
                center_buffer[32] <= add_out[2];
                center_buffer[33] <= add_out[3];
                center_buffer[34] <= add_out[4];
                center_buffer[35] <= add_out[5];
            end
            default: begin
                
            end
        endcase
    end
    else if (in_mode_reg == EXPOSURE_MODE) begin
        case (in_count)
            28: begin
                center_buffer[0] <= add_out[0];
                center_buffer[1] <= add_out[1];
                center_buffer[2] <= add_out[2];
            end
            29: begin
                center_buffer[3] <= add_out[3];
                center_buffer[4] <= add_out[4];
                center_buffer[5] <= add_out[5];
            end
            30: begin
                center_buffer[6] <= add_out[0];
                center_buffer[7] <= add_out[1];
                center_buffer[8] <= add_out[2];
            end
            31: begin
                center_buffer[9]  <= add_out[3];
                center_buffer[10] <= add_out[4];
                center_buffer[11] <= add_out[5];
            end
            32: begin
                center_buffer[12] <= add_out[0];
                center_buffer[13] <= add_out[1];
                center_buffer[14] <= add_out[2];
            end
            33: begin
                center_buffer[15] <= add_out[3];
                center_buffer[16] <= add_out[4];
                center_buffer[17] <= add_out[5];
            end
            34: begin
                center_buffer[18] <= add_out[0];
                center_buffer[19] <= add_out[1];
                center_buffer[20] <= add_out[2];
            end
            35: begin
                center_buffer[21] <= add_out[3];
                center_buffer[22] <= add_out[4];
                center_buffer[23] <= add_out[5];
            end
            36: begin
                center_buffer[24] <= add_out[0];
                center_buffer[25] <= add_out[1];
                center_buffer[26] <= add_out[2];
            end
            37: begin
                center_buffer[27] <= add_out[3];
                center_buffer[28] <= add_out[4];
                center_buffer[29] <= add_out[5];
            end
            38: begin
                center_buffer[30] <= add_out[0];
                center_buffer[31] <= add_out[1];
                center_buffer[32] <= add_out[2];
            end
            39: begin
                center_buffer[33] <= add_out[3];
                center_buffer[34] <= add_out[4];
                center_buffer[35] <= add_out[5];
            end
            default: begin
                
            end
        endcase
    end
end

// auto focus pipeline
always @(posedge clk) begin
    case (focus_pipe_count)
        'd0: begin
            focus_sub_in_1_reg[0] <= center_buffer[0];
            focus_sub_in_1_reg[1] <= center_buffer[1];
            focus_sub_in_1_reg[2] <= center_buffer[2];
            focus_sub_in_1_reg[3] <= center_buffer[3];
            focus_sub_in_1_reg[4] <= center_buffer[4];
            focus_sub_in_2_reg[0] <= center_buffer[1];
            focus_sub_in_2_reg[1] <= center_buffer[2];
            focus_sub_in_2_reg[2] <= center_buffer[3];
            focus_sub_in_2_reg[3] <= center_buffer[4];
            focus_sub_in_2_reg[4] <= center_buffer[5];
            focus_sub_in_1_reg[5] <= 'd0;
            focus_sub_in_2_reg[5] <= 'd0;
        end
        'd1: begin
            focus_sub_in_1_reg[0] <= center_buffer[6];
            focus_sub_in_1_reg[1] <= center_buffer[7];
            focus_sub_in_1_reg[2] <= center_buffer[8];
            focus_sub_in_1_reg[3] <= center_buffer[9];
            focus_sub_in_1_reg[4] <= center_buffer[10];
            focus_sub_in_2_reg[0] <= center_buffer[7];
            focus_sub_in_2_reg[1] <= center_buffer[8];
            focus_sub_in_2_reg[2] <= center_buffer[9];
            focus_sub_in_2_reg[3] <= center_buffer[10];
            focus_sub_in_2_reg[4] <= center_buffer[11];
            focus_sub_in_1_reg[5] <= 'd0;
            focus_sub_in_2_reg[5] <= 'd0;
        end
        'd2: begin
            focus_sub_in_1_reg[0] <= center_buffer[12];
            focus_sub_in_1_reg[1] <= center_buffer[13];
            focus_sub_in_1_reg[2] <= center_buffer[14];
            focus_sub_in_1_reg[3] <= center_buffer[15];
            focus_sub_in_1_reg[4] <= center_buffer[16];
            focus_sub_in_2_reg[0] <= center_buffer[13];
            focus_sub_in_2_reg[1] <= center_buffer[14];
            focus_sub_in_2_reg[2] <= center_buffer[15];
            focus_sub_in_2_reg[3] <= center_buffer[16];
            focus_sub_in_2_reg[4] <= center_buffer[17];
            focus_sub_in_1_reg[5] <= 'd0;
            focus_sub_in_2_reg[5] <= 'd0;
        end
        'd3: begin
            focus_sub_in_1_reg[0] <= center_buffer[18];
            focus_sub_in_1_reg[1] <= center_buffer[19];
            focus_sub_in_1_reg[2] <= center_buffer[20];
            focus_sub_in_1_reg[3] <= center_buffer[21];
            focus_sub_in_1_reg[4] <= center_buffer[22];
            focus_sub_in_2_reg[0] <= center_buffer[19];
            focus_sub_in_2_reg[1] <= center_buffer[20];
            focus_sub_in_2_reg[2] <= center_buffer[21];
            focus_sub_in_2_reg[3] <= center_buffer[22];
            focus_sub_in_2_reg[4] <= center_buffer[23];
            focus_sub_in_1_reg[5] <= 'd0;
            focus_sub_in_2_reg[5] <= 'd0;
        end
        'd4: begin
            focus_sub_in_1_reg[0] <= center_buffer[24];
            focus_sub_in_1_reg[1] <= center_buffer[25];
            focus_sub_in_1_reg[2] <= center_buffer[26];
            focus_sub_in_1_reg[3] <= center_buffer[27];
            focus_sub_in_1_reg[4] <= center_buffer[28];
            focus_sub_in_2_reg[0] <= center_buffer[25];
            focus_sub_in_2_reg[1] <= center_buffer[26];
            focus_sub_in_2_reg[2] <= center_buffer[27];
            focus_sub_in_2_reg[3] <= center_buffer[28];
            focus_sub_in_2_reg[4] <= center_buffer[29];
            focus_sub_in_1_reg[5] <= 'd0;
            focus_sub_in_2_reg[5] <= 'd0;
        end
        'd5: begin
            focus_sub_in_1_reg[0] <= center_buffer[30];
            focus_sub_in_1_reg[1] <= center_buffer[31];
            focus_sub_in_1_reg[2] <= center_buffer[32];
            focus_sub_in_1_reg[3] <= center_buffer[33];
            focus_sub_in_1_reg[4] <= center_buffer[34];
            focus_sub_in_2_reg[0] <= center_buffer[31];
            focus_sub_in_2_reg[1] <= center_buffer[32];
            focus_sub_in_2_reg[2] <= center_buffer[33];
            focus_sub_in_2_reg[3] <= center_buffer[34];
            focus_sub_in_2_reg[4] <= center_buffer[35];
            focus_sub_in_1_reg[5] <= 'd0;
            focus_sub_in_2_reg[5] <= 'd0;
        end
        'd6: begin
            focus_sub_in_1_reg[0] <= center_buffer[0];
            focus_sub_in_1_reg[1] <= center_buffer[1];
            focus_sub_in_1_reg[2] <= center_buffer[2];
            focus_sub_in_1_reg[3] <= center_buffer[3];
            focus_sub_in_1_reg[4] <= center_buffer[4];
            focus_sub_in_1_reg[5] <= center_buffer[5];
            focus_sub_in_2_reg[0] <= center_buffer[6];
            focus_sub_in_2_reg[1] <= center_buffer[7];
            focus_sub_in_2_reg[2] <= center_buffer[8];
            focus_sub_in_2_reg[3] <= center_buffer[9];
            focus_sub_in_2_reg[4] <= center_buffer[10];
            focus_sub_in_2_reg[5] <= center_buffer[11];
        end
        'd7: begin
            focus_sub_in_1_reg[0] <= center_buffer[6];
            focus_sub_in_1_reg[1] <= center_buffer[7];
            focus_sub_in_1_reg[2] <= center_buffer[8];
            focus_sub_in_1_reg[3] <= center_buffer[9];
            focus_sub_in_1_reg[4] <= center_buffer[10];
            focus_sub_in_1_reg[5] <= center_buffer[11];
            focus_sub_in_2_reg[0] <= center_buffer[12];
            focus_sub_in_2_reg[1] <= center_buffer[13];
            focus_sub_in_2_reg[2] <= center_buffer[14];
            focus_sub_in_2_reg[3] <= center_buffer[15];
            focus_sub_in_2_reg[4] <= center_buffer[16];
            focus_sub_in_2_reg[5] <= center_buffer[17];
        end
        'd8: begin
            focus_sub_in_1_reg[0] <= center_buffer[12];
            focus_sub_in_1_reg[1] <= center_buffer[13];
            focus_sub_in_1_reg[2] <= center_buffer[14];
            focus_sub_in_1_reg[3] <= center_buffer[15];
            focus_sub_in_1_reg[4] <= center_buffer[16];
            focus_sub_in_1_reg[5] <= center_buffer[17];
            focus_sub_in_2_reg[0] <= center_buffer[18];
            focus_sub_in_2_reg[1] <= center_buffer[19];
            focus_sub_in_2_reg[2] <= center_buffer[20];
            focus_sub_in_2_reg[3] <= center_buffer[21];
            focus_sub_in_2_reg[4] <= center_buffer[22];
            focus_sub_in_2_reg[5] <= center_buffer[23];
        end
        'd9: begin
            focus_sub_in_1_reg[0] <= center_buffer[18];
            focus_sub_in_1_reg[1] <= center_buffer[19];
            focus_sub_in_1_reg[2] <= center_buffer[20];
            focus_sub_in_1_reg[3] <= center_buffer[21];
            focus_sub_in_1_reg[4] <= center_buffer[22];
            focus_sub_in_1_reg[5] <= center_buffer[23];
            focus_sub_in_2_reg[0] <= center_buffer[24];
            focus_sub_in_2_reg[1] <= center_buffer[25];
            focus_sub_in_2_reg[2] <= center_buffer[26];
            focus_sub_in_2_reg[3] <= center_buffer[27];
            focus_sub_in_2_reg[4] <= center_buffer[28];
            focus_sub_in_2_reg[5] <= center_buffer[29];
        end
        'd10: begin
            focus_sub_in_1_reg[0] <= center_buffer[24];
            focus_sub_in_1_reg[1] <= center_buffer[25];
            focus_sub_in_1_reg[2] <= center_buffer[26];
            focus_sub_in_1_reg[3] <= center_buffer[27];
            focus_sub_in_1_reg[4] <= center_buffer[28];
            focus_sub_in_1_reg[5] <= center_buffer[29];
            focus_sub_in_2_reg[0] <= center_buffer[30];
            focus_sub_in_2_reg[1] <= center_buffer[31];
            focus_sub_in_2_reg[2] <= center_buffer[32];
            focus_sub_in_2_reg[3] <= center_buffer[33];
            focus_sub_in_2_reg[4] <= center_buffer[34];
            focus_sub_in_2_reg[5] <= center_buffer[35];
        end
        default: begin
            focus_sub_in_1_reg[0] <= 'd0;
            focus_sub_in_1_reg[1] <= 'd0;
            focus_sub_in_1_reg[2] <= 'd0;
            focus_sub_in_1_reg[3] <= 'd0;
            focus_sub_in_1_reg[4] <= 'd0;
            focus_sub_in_1_reg[5] <= 'd0;
            focus_sub_in_2_reg[0] <= 'd0;
            focus_sub_in_2_reg[1] <= 'd0;
            focus_sub_in_2_reg[2] <= 'd0;
            focus_sub_in_2_reg[3] <= 'd0;
            focus_sub_in_2_reg[4] <= 'd0;
            focus_sub_in_2_reg[5] <= 'd0;
        end
    endcase
end

always @(posedge clk) begin
    if(horiz_flag) begin
        focus_add_stage_1_reg[0] <= sub_out[0];
        focus_add_stage_1_reg[5] <= sub_out[4];
        focus_add_stage_1_reg[1] <= sub_out[1];
        focus_add_stage_1_reg[4] <= sub_out[3];
        focus_add_stage_1_reg[2] <= sub_out[2];
        focus_add_stage_1_reg[3] <= 'd0;
    end
    else begin
        focus_add_stage_1_reg[0] <= sub_out[0];
        focus_add_stage_1_reg[1] <= sub_out[1];
        focus_add_stage_1_reg[2] <= sub_out[2];
        focus_add_stage_1_reg[3] <= sub_out[3];
        focus_add_stage_1_reg[4] <= sub_out[4];
        focus_add_stage_1_reg[5] <= sub_out[5];
    end
end

// adder tree
always @(posedge clk) begin
    if(focus_pipe_count > 'd1) begin
        focus_add_stage_2_reg[0] <= focus_add_stage_1_reg[0] + focus_add_stage_1_reg[5];
        focus_add_stage_2_reg[1] <= focus_add_stage_1_reg[1] + focus_add_stage_1_reg[4];
        focus_add_stage_2_reg[2] <= focus_add_stage_1_reg[2] + focus_add_stage_1_reg[3];
    end
    else begin
        focus_add_stage_2_reg[0] <= 'd0;
        focus_add_stage_2_reg[1] <= 'd0;
        focus_add_stage_2_reg[2] <= 'd0;
    end
end

always @(posedge clk) begin
    focus_add_stage_3_reg[0] <= focus_add_stage_2_reg[1] + focus_add_stage_2_reg[2];
    focus_add_stage_3_reg[1] <= focus_add_stage_2_reg[0];
end

always @(posedge clk) begin
    focus_add_stage_4_reg    <= focus_add_stage_3_reg[0] + focus_add_stage_3_reg[1];
end

always @(posedge clk) begin
    if(state == IDLE) begin
        diff_acc_reg_2 <= 'd0;
    end
    else if (focus_pipe_count == 'd5 | focus_pipe_count == 'd6 | focus_pipe_count == 'd11) begin
        diff_acc_reg_2 <= diff_acc_reg_2 + focus_add_stage_2_reg[2];
    end
end

always @(posedge clk) begin
    if(state == IDLE) begin
        diff_acc_reg_4 <= 'd0;
    end
    else if (focus_pipe_count == 'd5 | focus_pipe_count == 'd6 | focus_pipe_count == 'd7 | focus_pipe_count == 'd8 | 
             focus_pipe_count == 'd11| focus_pipe_count == 'd12| focus_pipe_count == 'd13) begin
        diff_acc_reg_4 <= diff_acc_reg_4 + focus_add_stage_3_reg[0];
    end
end

always @(posedge clk) begin
    if(state == IDLE) begin
        diff_acc_reg_6 <= 'd0;
    end
    else begin
        diff_acc_reg_6 <= diff_acc_reg_6 + focus_add_stage_4_reg;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        focus_reg_6 <= 'd0;
    end
    else if(focus_in_done & focus_count == 'd12) begin
        focus_reg_6 <= div_out;
    end
    else begin
        focus_reg_6 <= focus_reg_6;
    end
end

always @(posedge clk) begin
    if(focus_pipe_count == 'd16) begin
        focus_reg_4 <= diff_acc_reg_4 >> 'd4;
    end
    else begin
        focus_reg_4 <= focus_reg_4;
    end
end

always @(posedge clk) begin
    if(focus_pipe_count == 'd16) begin
        focus_reg_2 <= diff_acc_reg_2 >> 'd2;
    end
    else begin
        focus_reg_2 <= focus_reg_2;
    end
end

always @(posedge clk) begin
    if(focus_done) begin
        focus_out_reg <= (focus_reg_2 >= focus_reg_4 & focus_reg_2 >= focus_reg_6) ? 2'd0 : 
                         (focus_reg_4 >= focus_reg_2 & focus_reg_4 >= focus_reg_6) ? 2'd1 : 2'd2;
    end
    else if(focus_exist_reg) begin
        focus_out_reg <= focus_restore;
    end
    else begin
        focus_out_reg <= focus_out_reg;
    end
end

// record focus and exposure result
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i=0; i<16; i=i+1) begin
            focus_record[i] <= 'd0;
            focus_record_flag[i] <= 1'b0;
        end
    end
    else if(state == DOUT & !exposure_exist_reg) begin
        focus_record[in_pic_no_reg] <= focus_out_reg;
        focus_record_flag[in_pic_no_reg] <= 1'b1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i=0; i<16; i=i+1) begin
            exposure_record[i] <= 'd0;
            exposure_record_flag[i] <= 1'b0;
        end
    end
    else if(state == DOUT & in_mode_reg == EXPOSURE_MODE & in_ratio_mode_reg != 'd2) begin
        exposure_record[in_pic_no_reg] <= exposure_acc >> 'd10;
        exposure_record_flag[in_pic_no_reg] <= 1'b1;
    end
end

// record image all pixel zero 
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        current_not_all_zero_flag <= 1'b0;
    end
    else if(state == DOUT) begin
        current_not_all_zero_flag <= 1'b0;
    end
    else begin
        current_not_all_zero_flag <= current_not_all_zero_flag | (wdata_s_inf != 'd0);
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i=0; i<16; i=i+1) begin
            all_zero_flag[i] <= 1'b0;
        end
    end
    else if(state == DOUT & !focus_exist_reg & !exposure_exist_reg) begin
        all_zero_flag[in_pic_no_reg] <= !current_not_all_zero_flag;
    end
end

// control skip state
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        focus_exist_reg     <= 1'b0;
        exposure_exist_reg  <= 1'b0;
    end
    else begin
        focus_exist_reg     <= focus_exist;
        exposure_exist_reg  <= exposure_exist;
    end
end

always @(posedge clk) begin
    all_zero_flag_reg    <= all_zero_flag   [in_pic_no_reg];
    focus_restore        <= focus_record    [in_pic_no_reg];
    exposure_acc_restore <= exposure_record [in_pic_no_reg];
end

// pipeline counter
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        focus_count <= 'd0;
    end
    else if (state == DOUT) begin
        focus_count <= 'd0;
    end
    else if (focus_in_done) begin
        focus_count <= focus_count + 'd1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        focus_pipe_count <= 'd0;
    end
    else if(state == DOUT) begin
        focus_pipe_count <= 'd0;
    end
    else if((in_mode_reg == AUTO_FOCUS_MODE & channel_count == 'd2 & in_count > 'd7) | 
            (in_mode_reg == EXPOSURE_MODE   & channel_count == 'd2 & in_count > 'd34)) begin
        focus_pipe_count <= (focus_pipe_count == 'd16) ? 'd16 : (focus_pipe_count + 'd1);
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        exposure_count <= 'd0;
    end
    else if (state == EXPOSURE) begin
        exposure_count <= exposure_count + 'd1;
    end
    else if (state == DOUT) begin
        exposure_count <= 'd0;
    end
end

// exposure pipeline
always @(posedge clk) begin
    for(i=0; i<16; i=i+1) begin
        adj_gray_data_reg[i] <= adj_gray_data[i];
    end
end

always @(posedge clk) begin
    for(i=0; i<6; i=i+1) begin
        gray_data_reg[i] <= gray_data[i];
    end
end

// adder tree
always @(posedge clk) begin
    exp_add_stage_1_reg[0] <= adj_gray_data_reg[0]  + adj_gray_data_reg[1];
    exp_add_stage_1_reg[1] <= adj_gray_data_reg[2]  + adj_gray_data_reg[3];
    exp_add_stage_1_reg[2] <= adj_gray_data_reg[4]  + adj_gray_data_reg[5];
    exp_add_stage_1_reg[3] <= adj_gray_data_reg[6]  + adj_gray_data_reg[7];
    exp_add_stage_1_reg[4] <= adj_gray_data_reg[8]  + adj_gray_data_reg[9];
    exp_add_stage_1_reg[5] <= adj_gray_data_reg[10] + adj_gray_data_reg[11];
    exp_add_stage_1_reg[6] <= adj_gray_data_reg[12] + adj_gray_data_reg[13];
    exp_add_stage_1_reg[7] <= adj_gray_data_reg[14] + adj_gray_data_reg[15];
end

always @(posedge clk) begin
    exp_add_stage_2_reg[0] <= exp_add_stage_1_reg[0] + exp_add_stage_1_reg[1];
    exp_add_stage_2_reg[1] <= exp_add_stage_1_reg[2] + exp_add_stage_1_reg[3];
    exp_add_stage_2_reg[2] <= exp_add_stage_1_reg[4] + exp_add_stage_1_reg[5];
    exp_add_stage_2_reg[3] <= exp_add_stage_1_reg[6] + exp_add_stage_1_reg[7];
end

always @(posedge clk) begin
    exp_add_stage_3_reg[0] <= exp_add_stage_2_reg[0] + exp_add_stage_2_reg[1];
    exp_add_stage_3_reg[1] <= exp_add_stage_2_reg[2] + exp_add_stage_2_reg[3];
end

always @(posedge clk) begin
    exp_add_stage_4_reg    <= exp_add_stage_3_reg[0] + exp_add_stage_3_reg[1];
end

always @(posedge clk) begin
    if(state == IDLE) begin
        exposure_acc <= 'd0;
    end
    else if(exposure_exist_reg & state == DIN) begin
        exposure_acc <= exposure_acc_restore << 'd10;
    end
    else begin
        exposure_acc <= exposure_acc + exp_add_stage_4_reg;
    end
end

// output
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_valid <= 1'b0;
    end
    // else if((state == DIN & all_zero_flag_reg) | (state == DOUT & !all_zero_flag_reg)) begin
    //     out_valid <= 1'b1;
    // end
    else if((state == DIN_WAIT & all_zero_flag[in_pic_no_reg]) | (state == DOUT & !all_zero_flag_reg)) begin
        out_valid <= 1'b1;
    end
    else begin
        out_valid <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_data <= 'd0;
    end
    else if(state == DOUT & !all_zero_flag_reg) begin
        out_data <= (in_mode_reg == AUTO_FOCUS_MODE) ? focus_out_reg : (exposure_acc >> 'd10);
    end
    else begin
        out_data <= 'd0;
    end
end


divided_by_9 divided_by_9_inst (
    .clk        (clk),
    .rst_n      (rst_n),
    .start      (focus_in_done & focus_count == 'd0),
    .dividend   (diff_acc_reg_6[13:2]),
    .done       (div_out_valid),
    .result     (div_out)
);

endmodule


module divided_by_9 (
    input clk,
    input rst_n,
    input start,
    input  [11:0] dividend,
    output done,
    output [8:0] result
);

reg [11:0] quo;
reg [12:0] acc;
reg [3:0] idx;
reg busy;

// accumulation
wire [12:0] sub_acc;
wire [11:0] next_quo;
wire [12:0] next_acc;

assign sub_acc = acc - 'd9;
assign {next_acc, next_quo} = (acc >= 'd9) ? {sub_acc, quo, 1'b1} : ({acc, quo} << 1'b1);

// output
assign done = idx == 'd11;
assign result = next_quo;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        busy <= 1'b0;
    end
    else if (start) begin
        busy <= 1'b1;
    end 
    else if (done) begin
        busy <= 1'b0;
    end
    else begin
        busy <= busy;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        idx <= 'd0;
    end
    else if (done | start) begin
        idx <= 'd0;
    end 
    else if (busy) begin
        idx <= idx + 'd1;
    end
    else begin
        idx <= idx;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        acc <= 'd0;
        quo <= 'd0;
    end
    else if (done) begin
        acc <= 'd0;
        quo <= 'd0;
    end 
    else if (start) begin
        {acc, quo} <= {12'd0, dividend, 1'b0};
    end 
    else if (busy) begin
        {acc, quo} <= {next_acc, next_quo};
    end
    else begin
        acc <= acc;
        quo <= quo;
    end
end

endmodule
