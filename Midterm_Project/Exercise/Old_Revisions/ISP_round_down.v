module ISP(
    // Input Signals
    input clk,
    input rst_n,
    input in_valid,
    input [3:0] in_pic_no,
    input       in_mode,
    input [1:0] in_ratio_mode,

    // Output Signals
    output reg      out_valid,
    output reg [7:0] out_data,
    
    // DRAM Signals
    // axi write address channel
    // src master
    output [3:0]  awid_s_inf,       // fix
    output [31:0] awaddr_s_inf,
    output [2:0]  awsize_s_inf,     // fix
    output [1:0]  awburst_s_inf,    // fix
    output [7:0]  awlen_s_inf,
    output reg    awvalid_s_inf,
    // src slave
    input         awready_s_inf,
    // -----------------------------
 
    // axi write data channel 
    // src master
    output reg [127:0] wdata_s_inf,
    output reg         wlast_s_inf,
    output reg         wvalid_s_inf,
    // src slave
    input          wready_s_inf,
  
    // axi write response channel 
    // src slave
    input [3:0]    bid_s_inf,
    input [1:0]    bresp_s_inf,
    input          bvalid_s_inf,
    // src master 
    output         bready_s_inf,
    // -----------------------------
  
    // axi read address channel 
    // src master
    output      [3:0]   arid_s_inf,     // fix
    output reg  [31:0]  araddr_s_inf,
    output reg  [7:0]   arlen_s_inf,    // fix
    output      [2:0]   arsize_s_inf,   // fix
    output      [1:0]   arburst_s_inf,  // fix
    output reg          arvalid_s_inf,
    // src slave
    input          arready_s_inf,
    // -----------------------------
  
    // axi read data channel 
    // slave
    input [3:0]     rid_s_inf,
    input [127:0]   rdata_s_inf,
    input [1:0]     rresp_s_inf,     // fix okay
    input           rlast_s_inf,
    input           rvalid_s_inf,
    // master
    output reg      rready_s_inf
    
);

//==================================================================
// parameter & integer
//==================================================================
parameter AUTO_FOCUS_MODE   = 1'b0;
parameter EXPOSURE_MODE     = 1'b1;

localparam IDLE         = 'd0;
localparam DIN          = 'd1;
localparam READ_DRAM    = 'd2;
localparam AUTO_FOCUS   = 'd3;
localparam EXPOSURE     = 'd4;
localparam WRITE_DRAM   = 'd5;
localparam DOUT         = 'd6;


//==================================================================
// reg
//==================================================================
reg [2:0] state, next_state;

// input reg
reg in_valid_reg;
reg in_mode_reg;
reg [3:0] in_pic_no_reg;
reg [1:0] in_ratio_mode_reg;

// counter
reg [5:0] count;
reg [1:0] channel_count;
reg [1:0] wdata_dly_count;

reg row_flag;
reg [1:0] focus_count;
reg [1:0] exposure_count;

// auto focus
reg [7:0]  center_buffer [0:35];
reg [5:0]  diff_idx;
reg [7:0]  diff_reg;
reg [9:0]  diff_acc_reg_2;
reg [12:0] diff_acc_reg_4;
reg [13:0] diff_acc_reg_6;
reg [7:0]  focus_reg_2;
reg [12:0] focus_reg_4;
reg [13:0] focus_reg_6;

reg [1:0] focus_record [0:15];

// auto exposure
reg [6:0]  dram_in_gray_reg [0:15];
reg [7:0]  add_stage_1_reg  [7:0];
reg [8:0]  add_stage_2_reg  [3:0];
reg [9:0]  add_stage_3_reg  [1:0];
reg [10:0] add_stage_4_reg;
reg [17:0] exposure_acc;

// output
reg [1:0] out_data_reg;

//==================================================================
// Wires
//==================================================================
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

wire [15:0] dram_pic_idx = in_pic_no_reg * 'd3072;
wire [16:0] dram_pic_start_idx = dram_pic_idx + 'h10000;
wire [9:0]  mid_start_idx = 'd429+'d1+'d32;

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

wire [7:0] dram_in_adj  [0:15];
wire [6:0] dram_in_gray [0:15];
wire [6:0] gray_data    [0:5];

assign dram_in_adj[0]  = (rdata_s_inf[7]   & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[7:0]     << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[1]  = (rdata_s_inf[15]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[15:8]    << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[2]  = (rdata_s_inf[23]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[23:16]   << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[3]  = (rdata_s_inf[31]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[31:24]   << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[4]  = (rdata_s_inf[39]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[39:32]   << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[5]  = (rdata_s_inf[47]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[47:40]   << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[6]  = (rdata_s_inf[55]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[55:48]   << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[7]  = (rdata_s_inf[63]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[63:56]   << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[8]  = (rdata_s_inf[71]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[71:64]   << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[9]  = (rdata_s_inf[79]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[79:72]   << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[10] = (rdata_s_inf[87]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[87:80]   << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[11] = (rdata_s_inf[95]  & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[95:88]   << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[12] = (rdata_s_inf[103] & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[103:96]  << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[13] = (rdata_s_inf[111] & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[111:104] << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[14] = (rdata_s_inf[119] & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[119:112] << 1) >> ('d3 - in_ratio_mode_reg));
assign dram_in_adj[15] = (rdata_s_inf[127] & in_ratio_mode_reg == 'd3) ? 'd255 : ((rdata_s_inf[127:120] << 1) >> ('d3 - in_ratio_mode_reg));

assign dram_in_gray[0]  = (channel_count == 'd1) ? (dram_in_adj[0]  >> 1) : (dram_in_adj[0]  >> 2);
assign dram_in_gray[1]  = (channel_count == 'd1) ? (dram_in_adj[1]  >> 1) : (dram_in_adj[1]  >> 2);
assign dram_in_gray[2]  = (channel_count == 'd1) ? (dram_in_adj[2]  >> 1) : (dram_in_adj[2]  >> 2);
assign dram_in_gray[3]  = (channel_count == 'd1) ? (dram_in_adj[3]  >> 1) : (dram_in_adj[3]  >> 2);
assign dram_in_gray[4]  = (channel_count == 'd1) ? (dram_in_adj[4]  >> 1) : (dram_in_adj[4]  >> 2);
assign dram_in_gray[5]  = (channel_count == 'd1) ? (dram_in_adj[5]  >> 1) : (dram_in_adj[5]  >> 2);
assign dram_in_gray[6]  = (channel_count == 'd1) ? (dram_in_adj[6]  >> 1) : (dram_in_adj[6]  >> 2);
assign dram_in_gray[7]  = (channel_count == 'd1) ? (dram_in_adj[7]  >> 1) : (dram_in_adj[7]  >> 2);
assign dram_in_gray[8]  = (channel_count == 'd1) ? (dram_in_adj[8]  >> 1) : (dram_in_adj[8]  >> 2);
assign dram_in_gray[9]  = (channel_count == 'd1) ? (dram_in_adj[9]  >> 1) : (dram_in_adj[9]  >> 2);
assign dram_in_gray[10] = (channel_count == 'd1) ? (dram_in_adj[10] >> 1) : (dram_in_adj[10] >> 2);
assign dram_in_gray[11] = (channel_count == 'd1) ? (dram_in_adj[11] >> 1) : (dram_in_adj[11] >> 2);
assign dram_in_gray[12] = (channel_count == 'd1) ? (dram_in_adj[12] >> 1) : (dram_in_adj[12] >> 2);
assign dram_in_gray[13] = (channel_count == 'd1) ? (dram_in_adj[13] >> 1) : (dram_in_adj[13] >> 2);
assign dram_in_gray[14] = (channel_count == 'd1) ? (dram_in_adj[14] >> 1) : (dram_in_adj[14] >> 2);
assign dram_in_gray[15] = (channel_count == 'd1) ? (dram_in_adj[15] >> 1) : (dram_in_adj[15] >> 2);

assign gray_data[0] = (channel_count == 'd1) ? (rdata_s_inf[7:0]   >> 'd1) : (rdata_s_inf[7:0]   >> 'd2);
assign gray_data[1] = (channel_count == 'd1) ? (rdata_s_inf[15:8]  >> 'd1) : (rdata_s_inf[15:8]  >> 'd2);
assign gray_data[2] = (channel_count == 'd1) ? (rdata_s_inf[23:16] >> 'd1) : (rdata_s_inf[23:16] >> 'd2);
assign gray_data[3] = (channel_count == 'd1) ? (rdata_s_inf[31:24] >> 'd1) : (rdata_s_inf[31:24] >> 'd2);
assign gray_data[4] = (channel_count == 'd1) ? (rdata_s_inf[39:32] >> 'd1) : (rdata_s_inf[39:32] >> 'd2);
assign gray_data[5] = (channel_count == 'd1) ? (rdata_s_inf[47:40] >> 'd1) : (rdata_s_inf[47:40] >> 'd2);

// focus
wire [7:0] diff_in_1 = center_buffer[diff_idx];
wire [7:0] diff_in_2 = row_flag ? center_buffer[diff_idx+1] : center_buffer[diff_idx+6];
wire [7:0] diff_wire = (diff_in_1 > diff_in_2) ? (diff_in_1 - diff_in_2) : (diff_in_2 - diff_in_1);

wire [9:0]  focus_wire_2 = diff_acc_reg_2;
wire [12:0] focus_wire_4 = diff_acc_reg_4 + diff_acc_reg_2;
wire [13:0] focus_wire_6 = diff_acc_reg_6 + diff_acc_reg_4 + diff_acc_reg_2;

// handshake
wire ar_shake   = arvalid_s_inf & arready_s_inf;
wire r_shake    = rvalid_s_inf  & rready_s_inf;
wire aw_shake   = awvalid_s_inf & awready_s_inf;
wire w_shake    = wvalid_s_inf  & wready_s_inf;

// control
wire read_dram_done = (in_mode_reg == AUTO_FOCUS_MODE) ? (channel_count == 'd2 & count == 'd14) : (channel_count == 'd2 & count == 'd63);
wire focus_in_done  = (diff_idx == 'd31) & !row_flag;
wire focus_done     = focus_count == 'd2;
wire exposure_done  = exposure_count == 'd3;

//==================================================================
// Design
//==================================================================
// next state logic
always @(*) begin
    case(state)
        IDLE        : next_state = in_valid         ? DIN       : IDLE;
        DIN         : next_state = READ_DRAM;
        READ_DRAM   : next_state = ~read_dram_done  ? READ_DRAM : (in_mode_reg == AUTO_FOCUS_MODE ? AUTO_FOCUS : EXPOSURE);
        AUTO_FOCUS  : next_state = focus_done       ? DOUT      : AUTO_FOCUS;
        EXPOSURE    : next_state = exposure_done    ? WRITE_DRAM: EXPOSURE;
        WRITE_DRAM  : next_state = DOUT;
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
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        in_pic_no_reg <= 'd0;
    end
    else if(in_valid) begin
        in_pic_no_reg <= in_pic_no;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        in_mode_reg <= 'd0;
    end
    else if(in_valid) begin
        in_mode_reg <= in_mode;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        in_ratio_mode_reg <= 'd0;
    end
    else if(in_valid & in_mode == EXPOSURE_MODE) begin
        in_ratio_mode_reg <= in_ratio_mode;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        in_valid_reg <= 'd0;
    end
    else begin
        in_valid_reg <= in_valid;
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
        araddr_s_inf <= 32'h10000;
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
    else if(in_valid_reg) begin
        arvalid_s_inf <= 1'b1;
    end
    else if(ar_shake) begin
        arvalid_s_inf <= 1'b0;
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
    else if(in_valid) begin
        if(in_mode == EXPOSURE_MODE) begin
            awvalid_s_inf <= 1'b1;
        end
    end
end

// DRAM data write
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        wdata_dly_count <= 'd0;
    end
    else if(state == DOUT) begin
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
    else if(r_shake & in_mode_reg == EXPOSURE_MODE) begin
        wvalid_s_inf <= 'd1;
    end
    else if(wdata_dly_count == 'd3) begin
        wvalid_s_inf <= 'd0;
    end
    else if(in_valid) begin
        if(in_mode == EXPOSURE_MODE) begin
            wvalid_s_inf <= 'd1;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        wdata_s_inf <= 'd0;
    end
    else if(r_shake) begin
        wdata_s_inf <= {dram_in_adj[15], dram_in_adj[14], dram_in_adj[13], dram_in_adj[12], 
                        dram_in_adj[11], dram_in_adj[10], dram_in_adj[9],  dram_in_adj[8], 
                        dram_in_adj[7],  dram_in_adj[6],  dram_in_adj[5],  dram_in_adj[4], 
                        dram_in_adj[3],  dram_in_adj[2],  dram_in_adj[1],  dram_in_adj[0]};
    end
    else begin
        wdata_s_inf <= 'd0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        wlast_s_inf <= 'd0;
    end
    else if(channel_count == 'd2 & count == 'd63) begin
        wlast_s_inf <= 'd1;
    end
    else begin
        wlast_s_inf <= 'd0;
    end
end

// counters
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        count <= 'd0;
    end
    else if(r_shake) begin
        count <= (count == 'd63) ? 'd0 : (count + 'd1);
    end
    else if(state == DOUT) begin
        count <= 'd0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        channel_count <= 'd0;
    end
    else if(state == DOUT) begin
        channel_count <= 'd0;
    end
    else if(count == 'd63) begin
        channel_count <= channel_count + 'd1;
    end
end

// Buffer
integer i;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i=0; i<36; i=i+1) begin
            center_buffer[i] <= 'd0;
        end
    end
    else if(state == DOUT) begin
        for(i=0; i<36; i=i+1) begin
            center_buffer[i] <= 'd0;
        end
    end
    else if(~count[0] & (count < 'd11)) begin
        center_buffer[0 + (count>>1)*6] <= center_buffer[0 + (count>>1)*6] + gray_data[0];
        center_buffer[1 + (count>>1)*6] <= center_buffer[1 + (count>>1)*6] + gray_data[1];
        center_buffer[2 + (count>>1)*6] <= center_buffer[2 + (count>>1)*6] + gray_data[2];
        center_buffer[3 + (count>>1)*6] <= center_buffer[3 + (count>>1)*6] + gray_data[3];
        center_buffer[4 + (count>>1)*6] <= center_buffer[4 + (count>>1)*6] + gray_data[4];
        center_buffer[5 + (count>>1)*6] <= center_buffer[5 + (count>>1)*6] + gray_data[5];
    end
end

// control
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        row_flag <= 1'b1;
    end
    else if(state == DOUT) begin
        row_flag <= 1'b1;
    end
    else if (channel_count == 'd2 & diff_idx == 'd34) begin
        row_flag <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        diff_idx <= 'd0;
    end
    else if(state == DOUT) begin
        diff_idx <= 'd0;
    end
    else if(channel_count == 'd2 & count != 'd0) begin
        if(row_flag) begin
            diff_idx <= (diff_idx == 'd34) ? 'd0 : 
                        ((diff_idx == 'd4 | diff_idx == 'd10 | diff_idx == 'd16 | diff_idx == 'd22 | diff_idx == 'd28) ? (diff_idx + 'd2) : (diff_idx + 'd1));
        end
        else begin
            diff_idx <= (diff_idx == 'd31) ? 'd31 : (diff_idx + 'd1);
        end
    end
end

// pipeline
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        diff_reg <= 'd0;
    end
    else if(!(!row_flag & diff_idx > 'd29)) begin
        diff_reg <= diff_wire;
    end
    else if(state == DOUT) begin
        diff_reg <= 'd0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        diff_acc_reg_2 <= 'd0;
        diff_acc_reg_4 <= 'd0;
        diff_acc_reg_6 <= 'd0;
    end
    else if(state == DOUT) begin
        diff_acc_reg_2 <= 'd0;
        diff_acc_reg_4 <= 'd0;
        diff_acc_reg_6 <= 'd0;
    end
    else if(channel_count == 'd2) begin
        if(row_flag) begin
            case(diff_idx)
                'd1, 'd2, 'd3, 'd4, 'd6, 'd7, 'd12, 'd13, 'd18, 'd19, 'd24, 'd25, 'd30, 'd31, 'd32, 'd33, 'd34: begin
                    diff_acc_reg_6 <= diff_acc_reg_6 + diff_reg;
                end
                'd8, 'd9, 'd10, 'd14, 'd16, 'd20, 'd22, 'd26, 'd27, 'd28 : begin
                    diff_acc_reg_4 <= diff_acc_reg_4 + diff_reg;
                end
                'd15, 'd21 : begin
                    diff_acc_reg_2 <= diff_acc_reg_2 + diff_reg;
                end
            endcase
        end
        else begin
            case(diff_idx)
                'd0, 'd1, 'd2, 'd3, 'd4, 'd5, 'd6, 'd7, 'd12, 'd13, 'd18, 'd19, 'd24, 'd25, 'd26, 'd27, 'd28, 'd29, 'd30 : begin
                    diff_acc_reg_6 <= diff_acc_reg_6 + diff_reg;
                end
                'd8, 'd9, 'd10, 'd11, 'd14, 'd17, 'd20, 'd21, 'd22, 'd23 : begin
                    diff_acc_reg_4 <= diff_acc_reg_4 + diff_reg;
                end
                'd15, 'd16 : begin
                    diff_acc_reg_2 <= diff_acc_reg_2 + diff_reg;
                end
            endcase
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        focus_reg_6 <= 'd0;
    end
    else if(focus_in_done) begin
        if(focus_count == 'd0) begin
            focus_reg_6 <= focus_wire_6;
        end
        else if(focus_count == 'd1) begin
            focus_reg_6 <= focus_reg_6 / 'd36;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        focus_reg_4 <= 'd0;
    end
    else if(focus_in_done) begin
        if(focus_count == 'd0) begin
            focus_reg_4 <= focus_wire_4;
        end
        else if(focus_count == 'd1) begin
            focus_reg_4 <= focus_reg_4 >> 'd4;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        focus_reg_2 <= 'd0;
    end
    else if(focus_in_done) begin
        if(focus_count == 'd0) begin
            focus_reg_2 <= diff_acc_reg_2 >> 'd2;
        end
    end
end


// pipeline dly count
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
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i=0; i<16; i=i+1) begin
            dram_in_gray_reg[i] <= 'd0;
        end
    end
    else begin
        for(i=0; i<16; i=i+1) begin
            dram_in_gray_reg[i] <= dram_in_gray[i];
        end
    end
end

// adder tree
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        add_stage_1_reg[0] <= 'd0;
        add_stage_1_reg[1] <= 'd0;
        add_stage_1_reg[2] <= 'd0;
        add_stage_1_reg[3] <= 'd0;
        add_stage_1_reg[4] <= 'd0;
        add_stage_1_reg[5] <= 'd0;
        add_stage_1_reg[6] <= 'd0;
        add_stage_1_reg[7] <= 'd0;
    end
    else begin
        add_stage_1_reg[0] <= dram_in_gray_reg[0]  + dram_in_gray_reg[1];
        add_stage_1_reg[1] <= dram_in_gray_reg[2]  + dram_in_gray_reg[3];
        add_stage_1_reg[2] <= dram_in_gray_reg[4]  + dram_in_gray_reg[5];
        add_stage_1_reg[3] <= dram_in_gray_reg[6]  + dram_in_gray_reg[7];
        add_stage_1_reg[4] <= dram_in_gray_reg[8]  + dram_in_gray_reg[9];
        add_stage_1_reg[5] <= dram_in_gray_reg[10] + dram_in_gray_reg[11];
        add_stage_1_reg[6] <= dram_in_gray_reg[12] + dram_in_gray_reg[13];
        add_stage_1_reg[7] <= dram_in_gray_reg[14] + dram_in_gray_reg[15];
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        add_stage_2_reg[0] <= 'd0;
        add_stage_2_reg[1] <= 'd0;
        add_stage_2_reg[2] <= 'd0;
        add_stage_2_reg[3] <= 'd0;
    end
    else begin
        add_stage_2_reg[0] <= add_stage_1_reg[0]  + add_stage_1_reg[1];
        add_stage_2_reg[1] <= add_stage_1_reg[2]  + add_stage_1_reg[3];
        add_stage_2_reg[2] <= add_stage_1_reg[4]  + add_stage_1_reg[5];
        add_stage_2_reg[3] <= add_stage_1_reg[6]  + add_stage_1_reg[7];
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        add_stage_3_reg[0] <= 'd0;
        add_stage_3_reg[1] <= 'd0;
    end
    else begin
        add_stage_3_reg[0] <= add_stage_2_reg[0]  + add_stage_2_reg[1];
        add_stage_3_reg[1] <= add_stage_2_reg[2]  + add_stage_2_reg[3];
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        add_stage_4_reg <= 'd0;
    end
    else begin
        add_stage_4_reg <= add_stage_3_reg[0] + add_stage_3_reg[1];
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        exposure_acc <= 'd0;
    end
    else if(state == DOUT) begin
        exposure_acc <= 'd0;
    end
    else begin
        exposure_acc <= exposure_acc + add_stage_4_reg;
    end
end

// output
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_data_reg <= 'd0;
    end
    else if(focus_count == 'd2) begin
        out_data_reg <= (focus_reg_2 >= focus_reg_4 & focus_reg_2 >= focus_reg_6) ? 2'd0 : 
                        (focus_reg_4 >= focus_reg_2 & focus_reg_4 >= focus_reg_6) ? 2'd1 : 2'd2;
    end
end

always @(*) begin
    if(state == DOUT) begin
        out_valid = 1'b1;
    end
    else begin
        out_valid = 1'b0;
    end
end

always @(*) begin
    if(state == DOUT) begin
        out_data = (in_mode_reg == AUTO_FOCUS_MODE) ? out_data_reg : (exposure_acc >> 'd10);
    end
    else begin
        out_data = 'd0;
    end
end

endmodule
