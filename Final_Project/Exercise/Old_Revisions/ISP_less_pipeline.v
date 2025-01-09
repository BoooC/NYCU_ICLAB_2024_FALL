module ISP(
    // Input Signals
    input               clk,
    input               rst_n,
    input               in_valid,
    input       [3:0]   in_pic_no,
    input       [1:0]   in_mode,
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
parameter AUTO_FOCUS_MODE   = 'd0;
parameter EXPOSURE_MODE     = 'd1;
parameter AVG_MODE          = 'd2;

// one-hot encoding
localparam IDLE         = 6'b000000;
localparam DIN          = 6'b000001;
localparam DIN_WAIT1    = 6'b000010;
localparam DIN_WAIT2    = 6'b000100;
localparam READ_DRAM    = 6'b001000;
localparam EXPOSURE     = 6'b010000;
localparam DOUT         = 6'b100000;

//==================================================================
// reg
//==================================================================
// FSM state
reg [5:0] state, next_state;

// input reg
reg in_valid_reg;
reg [1:0] in_mode_reg;
reg [3:0] in_pic_no_reg;
reg [1:0] in_ratio_mode_reg;
reg [7:0] rdata_reg [0:15];

reg focus_mode_reg;
reg exposure_mode_reg;
reg avg_mode_reg;

// counter
reg [5:0] in_count;
reg [1:0] channel_count;
reg [1:0] wdata_dly_count;
reg [4:0] exposure_count;
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
reg [7:0]  add_center_in_reg[0:2];
reg [6:0]  add_gray_in_reg  [0:2];
reg [7:0]  exp_add_stage_1_reg  [7:0];
reg [8:0]  exp_add_stage_2_reg  [3:0];
reg [9:0]  exp_add_stage_3_reg  [1:0];
reg [10:0] exp_add_stage_4_reg;
reg [17:0] exposure_acc;
reg [7:0]  exposure_acc_restore;

// max min avg
reg [7:0] comp_in [0:15];

reg [7:0] max_stage_1 [0:7];
reg [7:0] max_stage_2 [0:3];
reg [7:0] max_stage_3 [0:1];
reg [7:0] max_stage_4;
reg [7:0] max_temp;

reg [7:0] min_stage_1 [0:7];
reg [7:0] min_stage_2 [0:3];
reg [7:0] min_stage_3 [0:1];
reg [7:0] min_stage_4;
reg [7:0] min_temp;

reg [9:0] max_sum;
reg [9:0] min_sum;
reg [6:0] max_min_avg_result;
reg [6:0] avg_restore;

// pipeline divider
wire div_out_valid;
wire [8:0] div_out;

wire max_div_out_valid;
wire min_div_out_valid;
wire [7:0] max_div_out;
wire [7:0] min_div_out;

// record previous reesult
reg [1:0] focus_record      [0:15];
reg [7:0] exposure_record   [0:15];
reg [6:0] avg_record        [0:15];
reg focus_record_flag       [0:15];
reg exposure_record_flag    [0:15];
reg avg_record_flag         [0:15];

reg [3:0] current_img_size;
reg [3:0] next_img_size;
reg [3:0] img_size_reg      [0:15]; // 8:255, 7:127, 6:63, 5:31, 4:15, 3:7, 2:3, 1:1, 0:0

reg all_zero_flag;
reg direct_out_reg;

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

assign dram_in_adj[0]   = (focus_mode_reg) ? (rdata_s_inf[7:0]    ) : ((rdata_s_inf[7]   & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[7:0]     << 1) >> ('d3 - in_ratio_mode_reg)));
assign dram_in_adj[1]   = (focus_mode_reg) ? (rdata_s_inf[15:8]   ) : ((rdata_s_inf[15]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[15:8]    << 1) >> ('d3 - in_ratio_mode_reg)));
assign dram_in_adj[2]   = (focus_mode_reg) ? (rdata_s_inf[23:16]  ) : ((rdata_s_inf[23]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[23:16]   << 1) >> ('d3 - in_ratio_mode_reg)));
assign dram_in_adj[3]   = (focus_mode_reg) ? (rdata_s_inf[31:24]  ) : ((rdata_s_inf[31]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[31:24]   << 1) >> ('d3 - in_ratio_mode_reg)));
assign dram_in_adj[4]   = (focus_mode_reg) ? (rdata_s_inf[39:32]  ) : ((rdata_s_inf[39]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[39:32]   << 1) >> ('d3 - in_ratio_mode_reg)));
assign dram_in_adj[5]   = (focus_mode_reg) ? (rdata_s_inf[47:40]  ) : ((rdata_s_inf[47]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[47:40]   << 1) >> ('d3 - in_ratio_mode_reg)));
assign dram_in_adj[6]   = (focus_mode_reg) ? (rdata_s_inf[55:48]  ) : ((rdata_s_inf[55]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[55:48]   << 1) >> ('d3 - in_ratio_mode_reg)));
assign dram_in_adj[7]   = (focus_mode_reg) ? (rdata_s_inf[63:56]  ) : ((rdata_s_inf[63]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[63:56]   << 1) >> ('d3 - in_ratio_mode_reg)));
assign dram_in_adj[8]   = (focus_mode_reg) ? (rdata_s_inf[71:64]  ) : ((rdata_s_inf[71]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[71:64]   << 1) >> ('d3 - in_ratio_mode_reg)));
assign dram_in_adj[9]   = (focus_mode_reg) ? (rdata_s_inf[79:72]  ) : ((rdata_s_inf[79]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[79:72]   << 1) >> ('d3 - in_ratio_mode_reg)));
assign dram_in_adj[10]  = (focus_mode_reg) ? (rdata_s_inf[87:80]  ) : ((rdata_s_inf[87]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[87:80]   << 1) >> ('d3 - in_ratio_mode_reg)));
assign dram_in_adj[11]  = (focus_mode_reg) ? (rdata_s_inf[95:88]  ) : ((rdata_s_inf[95]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[95:88]   << 1) >> ('d3 - in_ratio_mode_reg)));
assign dram_in_adj[12]  = (focus_mode_reg) ? (rdata_s_inf[103:96] ) : ((rdata_s_inf[103] & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[103:96]  << 1) >> ('d3 - in_ratio_mode_reg)));
assign dram_in_adj[13]  = (focus_mode_reg) ? (rdata_s_inf[111:104]) : ((rdata_s_inf[111] & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[111:104] << 1) >> ('d3 - in_ratio_mode_reg)));
assign dram_in_adj[14]  = (focus_mode_reg) ? (rdata_s_inf[119:112]) : ((rdata_s_inf[119] & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[119:112] << 1) >> ('d3 - in_ratio_mode_reg)));
assign dram_in_adj[15]  = (focus_mode_reg) ? (rdata_s_inf[127:120]) : ((rdata_s_inf[127] & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[127:120] << 1) >> ('d3 - in_ratio_mode_reg)));

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

// handshake
wire ar_shake   = arvalid_s_inf & arready_s_inf;
wire r_shake    = rvalid_s_inf  & rready_s_inf;
wire aw_shake   = awvalid_s_inf & awready_s_inf;
wire w_shake    = wvalid_s_inf  & wready_s_inf;
wire b_shake    = bvalid_s_inf  & bready_s_inf;

// skip signals
wire focus_exist    = focus_record_flag[in_pic_no_reg] & focus_mode_reg;
wire exposure_exist = exposure_record_flag[in_pic_no_reg] & exposure_mode_reg & (in_ratio_mode_reg == 'd2);
wire avg_exist      = avg_record_flag[in_pic_no_reg] & avg_mode_reg;

// control
wire horiz_flag     = focus_pipe_count < 'd11;
wire read_dram_done = channel_count == 'd2 & in_count == 'd63;
wire focus_in_done  = focus_pipe_count == 'd22;
wire focus_done     = channel_count == 'd3;
wire exposure_done  = exposure_count == 'd31;
wire direct_out     = focus_exist | exposure_exist | avg_exist;

//==================================================================
// Design
//==================================================================
// next state logic
always @(*) begin
    case(state)
        IDLE        : next_state = in_valid         ? DIN  : IDLE;
        DIN         : next_state = DIN_WAIT1;
        DIN_WAIT1   : next_state = (current_img_size == 'd0) ? IDLE : DIN_WAIT2;
        DIN_WAIT2   : next_state = direct_out_reg | all_zero_flag   ? DOUT      : READ_DRAM;
        READ_DRAM   : next_state = read_dram_done   ? EXPOSURE  : READ_DRAM;
        EXPOSURE    : next_state = max_div_out_valid? DOUT      : EXPOSURE;
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
        focus_mode_reg <= 'd0;
    end
    else if(in_valid) begin
        focus_mode_reg <= in_mode == AUTO_FOCUS_MODE;
    end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        exposure_mode_reg <= 'd0;
    end
    else if(in_valid) begin
        exposure_mode_reg <= in_mode == EXPOSURE_MODE;
    end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        avg_mode_reg <= 'd0;
    end
    else if(in_valid) begin
        avg_mode_reg <= in_mode == AVG_MODE;
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
        arlen_s_inf <= 'd191;
    end
    else if(state == DOUT) begin
        arlen_s_inf <= 'd0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        araddr_s_inf <= 'd0;
    end
    else begin
        araddr_s_inf <= dram_pic_start_idx;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        arvalid_s_inf <= 1'b0;
    end
    else if(state == DIN_WAIT2 & ~(direct_out_reg | all_zero_flag)) begin
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
    else if(state == DIN_WAIT2 & ~(direct_out_reg | all_zero_flag) & exposure_mode_reg) begin
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
    else if(rvalid_s_inf & exposure_mode_reg) begin // r_shake
        wvalid_s_inf <= 'd1;
    end
    else if(wdata_dly_count == 'd3) begin
        wvalid_s_inf <= 'd0;
    end
    else if(in_valid_reg & exposure_mode_reg) begin // in_valid_reg & ~direct_out & exposure_mode_reg
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

// always @(posedge clk or negedge rst_n) begin
//     if(!rst_n) begin
//         bready_s_inf <= 'd0;
//     end
//     else if(aw_shake) begin
//         bready_s_inf <= 'd1;
//     end
//     else if(bvalid_s_inf) begin
//         bready_s_inf <= 'd0;
//     end
// end

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
    if(in_count[0]) begin
        add_gray_in_reg[0] <= adj_gray_data_reg[13];
        add_gray_in_reg[1] <= adj_gray_data_reg[14];
        add_gray_in_reg[2] <= adj_gray_data_reg[15];
    end
    else begin
        add_gray_in_reg[0] <= adj_gray_data_reg[0];
        add_gray_in_reg[1] <= adj_gray_data_reg[1];
        add_gray_in_reg[2] <= adj_gray_data_reg[2];
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
    else if(in_count >= 'd28 & in_count <= 'd39) begin
        center_buffer[33] <= center_buffer[0] + add_gray_in_reg[0];
        center_buffer[34] <= center_buffer[1] + add_gray_in_reg[1];
        center_buffer[35] <= center_buffer[2] + add_gray_in_reg[2];
        for(i=0; i<31; i=i+3) begin
            center_buffer[i+0] <= center_buffer[i+3];
            center_buffer[i+1] <= center_buffer[i+4];
            center_buffer[i+2] <= center_buffer[i+5];
        end
    end
    else if(focus_pipe_count > 'd11) begin
        for(i=0; i<25; i=i+6) begin
            center_buffer[i+0] <= center_buffer[i+6];
            center_buffer[i+1] <= center_buffer[i+7];
            center_buffer[i+2] <= center_buffer[i+8];
            center_buffer[i+3] <= center_buffer[i+9];
            center_buffer[i+4] <= center_buffer[i+10];
            center_buffer[i+5] <= center_buffer[i+11];
        end
    end
end

// auto focus pipeline
always @(posedge clk) begin
    case (focus_pipe_count)
        'd1, 'd3, 'd5, 'd7, 'd9, 'd11: begin
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
        'd12, 'd13, 'd14, 'd15, 'd15, 'd16: begin
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
    if(focus_pipe_count > 'd0) begin
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
    else begin
        focus_add_stage_1_reg[0] <= 'd0;
        focus_add_stage_1_reg[1] <= 'd0;
        focus_add_stage_1_reg[2] <= 'd0;
        focus_add_stage_1_reg[3] <= 'd0;
        focus_add_stage_1_reg[4] <= 'd0;
        focus_add_stage_1_reg[5] <= 'd0;
    end
end

// adder tree
always @(posedge clk) begin
    focus_add_stage_2_reg[0] <= focus_add_stage_1_reg[0] + focus_add_stage_1_reg[5];
    focus_add_stage_2_reg[1] <= focus_add_stage_1_reg[1] + focus_add_stage_1_reg[4];
    focus_add_stage_2_reg[2] <= focus_add_stage_1_reg[2] + focus_add_stage_1_reg[3];
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
    else if (focus_pipe_count == 'd8 | focus_pipe_count == 'd10 | focus_pipe_count == 'd17) begin
        diff_acc_reg_2 <= diff_acc_reg_2 + focus_add_stage_2_reg[2];
    end
end

always @(posedge clk) begin
    if(state == IDLE) begin
        diff_acc_reg_4 <= 'd0;
    end
    else if (focus_pipe_count == 'd7 | focus_pipe_count == 'd9 | focus_pipe_count == 'd11 | focus_pipe_count == 'd13 | 
             focus_pipe_count == 'd17 | focus_pipe_count == 'd18 | focus_pipe_count == 'd19) begin
        diff_acc_reg_4 <= diff_acc_reg_4 + focus_add_stage_3_reg[0];
    end
end

always @(posedge clk) begin
    if(state == IDLE | state == DIN) begin
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
    else if(focus_in_done & (channel_count == 'd2 & in_count == 'd63)) begin
        focus_reg_6 <= div_out;
    end
    else begin
        focus_reg_6 <= focus_reg_6;
    end
end

always @(posedge clk) begin
    if(focus_pipe_count == 'd22) begin
        focus_reg_4 <= diff_acc_reg_4 >> 'd4;
    end
    else begin
        focus_reg_4 <= focus_reg_4;
    end
end

always @(posedge clk) begin
    if(focus_pipe_count == 'd22) begin
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
    else if(state == DOUT & !direct_out_reg) begin
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
    else if(state == DOUT & !direct_out_reg) begin
        exposure_record[in_pic_no_reg] <= exposure_acc >> 'd10;
        exposure_record_flag[in_pic_no_reg] <= 1'b1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i=0; i<16; i=i+1) begin
            avg_record[i] <= 'd0;
            avg_record_flag[i] <= 1'b0;
        end
    end
    else if(state == DOUT & !direct_out_reg) begin
        avg_record[in_pic_no_reg] <= max_min_avg_result;
        avg_record_flag[in_pic_no_reg] <= 1'b1;
    end
end

// record image all pixel zero
always @(posedge clk) begin
    if(in_valid_reg) begin
        current_img_size <= img_size_reg[in_pic_no_reg];
    end
end

always @(*) begin
    if(state == DIN_WAIT1 & exposure_mode_reg) begin
        case(in_ratio_mode_reg)
            'd0: next_img_size = (current_img_size == 'd1 | current_img_size == 'd0) ? 'd0 : (current_img_size - 'd2);
            'd1: next_img_size = (current_img_size == 'd0) ? 'd0 : (current_img_size - 'd1);
            'd2: next_img_size = current_img_size;
            'd3: next_img_size = (current_img_size == 'd8) ? 'd8 : (current_img_size == 'd0) ? 'd0 : (current_img_size + 'd1);
            default: next_img_size = current_img_size;
        endcase
    end
    else begin
        next_img_size = current_img_size;
    end
end 

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i=0; i<16; i=i+1) begin
            img_size_reg[i] <= 'd8;
        end
    end
    else if(state == DIN_WAIT1) begin
        img_size_reg[in_pic_no_reg] <= next_img_size;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        all_zero_flag <= 1'b0;
    end
    else if(state == DIN_WAIT1) begin
        all_zero_flag <= next_img_size == 'd0;
    end
end

// control skip state
always @(posedge clk) begin
    focus_restore        <= focus_record    [in_pic_no_reg];
    exposure_acc_restore <= exposure_record [in_pic_no_reg];
    avg_restore          <= avg_record      [in_pic_no_reg];
end

// pipeline counter
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        focus_pipe_count <= 'd0;
    end
    else if(state == DOUT) begin
        focus_pipe_count <= 'd0;
    end
    else if(channel_count == 'd2 & in_count > 'd28) begin
        focus_pipe_count <= (focus_pipe_count == 'd22) ? 'd22 : (focus_pipe_count + 'd1);
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
    if(state == READ_DRAM | state == EXPOSURE) begin
        exp_add_stage_4_reg <= exp_add_stage_3_reg[0] + exp_add_stage_3_reg[1];
    end
    else begin
        exp_add_stage_4_reg <= 'd0;
    end
end

always @(posedge clk) begin
    if(state == IDLE) begin
        exposure_acc <= 'd0;
    end
    else begin
        exposure_acc <= exposure_acc + exp_add_stage_4_reg;
    end
end

// min max avg
always @(posedge clk) begin
    rdata_reg[0]  <= rdata_s_inf[7:0];
    rdata_reg[1]  <= rdata_s_inf[15:8];
    rdata_reg[2]  <= rdata_s_inf[23:16];
    rdata_reg[3]  <= rdata_s_inf[31:24];
    rdata_reg[4]  <= rdata_s_inf[39:32];
    rdata_reg[5]  <= rdata_s_inf[47:40];
    rdata_reg[6]  <= rdata_s_inf[55:48];
    rdata_reg[7]  <= rdata_s_inf[63:56];
    rdata_reg[8]  <= rdata_s_inf[71:64];
    rdata_reg[9]  <= rdata_s_inf[79:72];
    rdata_reg[10] <= rdata_s_inf[87:80];
    rdata_reg[11] <= rdata_s_inf[95:88];
    rdata_reg[12] <= rdata_s_inf[103:96];
    rdata_reg[13] <= rdata_s_inf[111:104];
    rdata_reg[14] <= rdata_s_inf[119:112];
    rdata_reg[15] <= rdata_s_inf[127:120];
end

always @(*) begin
    comp_in[0]  = exposure_mode_reg ? wdata_s_inf[7:0]     : rdata_reg[0];
    comp_in[1]  = exposure_mode_reg ? wdata_s_inf[15:8]    : rdata_reg[1];
    comp_in[2]  = exposure_mode_reg ? wdata_s_inf[23:16]   : rdata_reg[2];
    comp_in[3]  = exposure_mode_reg ? wdata_s_inf[31:24]   : rdata_reg[3];
    comp_in[4]  = exposure_mode_reg ? wdata_s_inf[39:32]   : rdata_reg[4];
    comp_in[5]  = exposure_mode_reg ? wdata_s_inf[47:40]   : rdata_reg[5];
    comp_in[6]  = exposure_mode_reg ? wdata_s_inf[55:48]   : rdata_reg[6];
    comp_in[7]  = exposure_mode_reg ? wdata_s_inf[63:56]   : rdata_reg[7];
    comp_in[8]  = exposure_mode_reg ? wdata_s_inf[71:64]   : rdata_reg[8];
    comp_in[9]  = exposure_mode_reg ? wdata_s_inf[79:72]   : rdata_reg[9];
    comp_in[10] = exposure_mode_reg ? wdata_s_inf[87:80]   : rdata_reg[10];
    comp_in[11] = exposure_mode_reg ? wdata_s_inf[95:88]   : rdata_reg[11];
    comp_in[12] = exposure_mode_reg ? wdata_s_inf[103:96]  : rdata_reg[12];
    comp_in[13] = exposure_mode_reg ? wdata_s_inf[111:104] : rdata_reg[13];
    comp_in[14] = exposure_mode_reg ? wdata_s_inf[119:112] : rdata_reg[14];
    comp_in[15] = exposure_mode_reg ? wdata_s_inf[127:120] : rdata_reg[15];
end

wire comp_0_1   = comp_in[0]  > comp_in[1];
wire comp_2_3   = comp_in[2]  > comp_in[3];
wire comp_4_5   = comp_in[4]  > comp_in[5];
wire comp_6_7   = comp_in[6]  > comp_in[7];
wire comp_8_9   = comp_in[8]  > comp_in[9];
wire comp_10_11 = comp_in[10] > comp_in[11];
wire comp_12_13 = comp_in[12] > comp_in[13];
wire comp_14_15 = comp_in[14] > comp_in[15];


always @(posedge clk) begin
    max_stage_1[0] <= comp_0_1   ? comp_in[0]  : comp_in[1];
    max_stage_1[1] <= comp_2_3   ? comp_in[2]  : comp_in[3];
    max_stage_1[2] <= comp_4_5   ? comp_in[4]  : comp_in[5];
    max_stage_1[3] <= comp_6_7   ? comp_in[6]  : comp_in[7];
    max_stage_1[4] <= comp_8_9   ? comp_in[8]  : comp_in[9];
    max_stage_1[5] <= comp_10_11 ? comp_in[10] : comp_in[11];
    max_stage_1[6] <= comp_12_13 ? comp_in[12] : comp_in[13];
    max_stage_1[7] <= comp_14_15 ? comp_in[14] : comp_in[15];
end

always @(posedge clk) begin
    max_stage_2[0] <= (max_stage_1[0]  > max_stage_1[1])  ? max_stage_1[0]  : max_stage_1[1];
    max_stage_2[1] <= (max_stage_1[2]  > max_stage_1[3])  ? max_stage_1[2]  : max_stage_1[3];
    max_stage_2[2] <= (max_stage_1[4]  > max_stage_1[5])  ? max_stage_1[4]  : max_stage_1[5];
    max_stage_2[3] <= (max_stage_1[6]  > max_stage_1[7])  ? max_stage_1[6]  : max_stage_1[7];
end

always @(posedge clk) begin
    max_stage_3[0] <= (max_stage_2[0]  > max_stage_2[1])  ? max_stage_2[0]  : max_stage_2[1];
    max_stage_3[1] <= (max_stage_2[2]  > max_stage_2[3])  ? max_stage_2[2]  : max_stage_2[3];
end

always @(posedge clk) begin
    max_stage_4 <= (max_stage_3[0]  > max_stage_3[1])  ? max_stage_3[0]  : max_stage_3[1];
end

always @(posedge clk) begin
    if(in_count == 'd5) begin
        max_temp <= max_stage_4;
    end
    else if(in_count > 'd4 | channel_count != 'd0) begin
        max_temp <= (max_temp > max_stage_4) ? max_temp : max_stage_4;
    end
end

always @(posedge clk) begin
    min_stage_1[0] <= comp_0_1   ? comp_in[1]  : comp_in[0];
    min_stage_1[1] <= comp_2_3   ? comp_in[3]  : comp_in[2];
    min_stage_1[2] <= comp_4_5   ? comp_in[5]  : comp_in[4];
    min_stage_1[3] <= comp_6_7   ? comp_in[7]  : comp_in[6];
    min_stage_1[4] <= comp_8_9   ? comp_in[9]  : comp_in[8];
    min_stage_1[5] <= comp_10_11 ? comp_in[11] : comp_in[10];
    min_stage_1[6] <= comp_12_13 ? comp_in[13] : comp_in[12];
    min_stage_1[7] <= comp_14_15 ? comp_in[15] : comp_in[14];
end

always @(posedge clk) begin
    min_stage_2[0] <= (min_stage_1[0] > min_stage_1[1]) ? min_stage_1[1] : min_stage_1[0];
    min_stage_2[1] <= (min_stage_1[2] > min_stage_1[3]) ? min_stage_1[3] : min_stage_1[2];
    min_stage_2[2] <= (min_stage_1[4] > min_stage_1[5]) ? min_stage_1[5] : min_stage_1[4];
    min_stage_2[3] <= (min_stage_1[6] > min_stage_1[7]) ? min_stage_1[7] : min_stage_1[6];
end

always @(posedge clk) begin
    min_stage_3[0] <= (min_stage_2[0] > min_stage_2[1]) ? min_stage_2[1] : min_stage_2[0];
    min_stage_3[1] <= (min_stage_2[2] > min_stage_2[3]) ? min_stage_2[3] : min_stage_2[2];
end

always @(posedge clk) begin
    min_stage_4 <= (min_stage_3[0] > min_stage_3[1])  ? min_stage_3[1] : min_stage_3[0];
end

always @(posedge clk) begin
    if(in_count == 'd5) begin
        min_temp <= min_stage_4;
    end
    else if(in_count > 'd4 | channel_count != 'd0) begin
        min_temp <= (min_temp > min_stage_4) ? min_stage_4 : min_temp;
    end
end

always @(posedge clk or negedge rst_n) begin
     if(!rst_n) begin
        max_sum <= 'd0;
    end
    else if(state == DOUT) begin
        max_sum <= 'd0;
    end
    else if(exposure_count == 'd5 | (in_count == 'd5 & channel_count != 'd0)) begin
        max_sum <= max_temp + max_sum;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        min_sum <= 'd0;
    end
    else if(state == DOUT) begin
        min_sum <= 'd0;
    end
    else if(exposure_count == 'd5 | (in_count == 'd5 & channel_count != 'd0)) begin
        min_sum <= min_temp + min_sum;
    end
end

always @(posedge clk) begin
    if(max_div_out_valid) begin
        max_min_avg_result <= (max_div_out + min_div_out) >> 1;
    end
end

// output
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_valid <= 1'b0;
    end
    else if((state == DIN_WAIT2 & all_zero_flag) | (state == DIN_WAIT1 & current_img_size == 'd0) | (state == DOUT & !all_zero_flag)) begin
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
    else if(state == DOUT & !all_zero_flag) begin
        if(direct_out_reg) begin
            out_data <= focus_mode_reg    ? focus_restore : 
                        exposure_mode_reg ? exposure_acc_restore : avg_restore;
        end
        else begin
            out_data <= focus_mode_reg    ? focus_out_reg : 
                        exposure_mode_reg ? (exposure_acc >> 'd10) : max_min_avg_result;
        end
    end
    else begin
        out_data <= 'd0;
    end
end


divided_by_9 divided_by_9_inst (
    .clk        (clk),
    .rst_n      (rst_n),
    .start      (channel_count == 'd2 & in_count == 'd51),
    .dividend   (diff_acc_reg_6[13:2]),
    .done       (div_out_valid),
    .result     (div_out)
);

shift_divided_by_3 shift_divided_by_3_max (
    .clk        (clk),
    .rst_n      (rst_n),
    .in_valid   (exposure_count == 'd6),
    .data_in    (max_sum),
    .out_valid  (max_div_out_valid),
    .quotient   (max_div_out)
);

shift_divided_by_3 shift_divided_by_3_min (
    .clk        (clk),
    .rst_n      (rst_n),
    .in_valid   (exposure_count == 'd6),
    .data_in    (min_sum),
    .out_valid  (min_div_out_valid),
    .quotient   (min_div_out)
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



module shift_divided_by_3 (
    input  clk,
    input  rst_n,
    input  in_valid,
    input  [9:0] data_in,
    output reg out_valid,
    output reg [7:0] quotient
);
localparam IDLE = 2'b11;

reg [1:0] state, next_state;
reg [3:0] count;
reg [9:0] data_reg;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= IDLE;
    end 
    else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        IDLE : next_state = in_valid ? 2'b00 : IDLE;
        2'b00: next_state = (count == 'd10) ? IDLE : data_reg[9] ? 2'b01 : 2'b00;
        2'b01: next_state = (count == 'd10) ? IDLE : data_reg[9] ? 2'b00 : 2'b10;
        2'b10: next_state = (count == 'd10) ? IDLE : data_reg[9] ? 2'b10 : 2'b01;
        default: next_state = IDLE;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 'd0;
    end 
    else if(state == IDLE) begin
        count <= 'd0;
    end
    else begin
        count <= count + 'd1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_reg <= 'd0;
    end 
    else if(state == IDLE & in_valid) begin
        data_reg <= data_in;
    end
    else begin
        data_reg <= {data_reg[8:0], 1'b0};
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        quotient <= 'd0;
    end 
    else begin
        case(state)
            2'b00, 2'b01, 2'b10: begin
                if(data_reg[9])
                    quotient <= {quotient[7:0], state[1] | state[0]};
                else
                    quotient <= {quotient[7:0], state[1]};
            end
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out_valid <= 1'b0;
    end 
    else if(state == IDLE) begin
        out_valid <= 1'b0;
    end
    else if(count == 'd9) begin
        out_valid <= 1'b1;
    end
    else begin
        out_valid <= 1'b0;
    end
end

endmodule
