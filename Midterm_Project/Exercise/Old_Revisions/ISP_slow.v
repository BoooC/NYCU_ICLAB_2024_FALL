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
    output [3:0]  awid_s_inf,
    output [31:0] awaddr_s_inf,
    output [2:0]  awsize_s_inf,
    output [1:0]  awburst_s_inf,
    output [7:0]  awlen_s_inf,
    output        awvalid_s_inf,
    // src slave
    input         awready_s_inf,
    // -----------------------------
  
    // axi write data channel 
    // src master
    output [127:0] wdata_s_inf,
    output         wlast_s_inf,
    output         wvalid_s_inf,
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
    input [3:0]    rid_s_inf,
    input [127:0]  rdata_s_inf,
    input [1:0]    rresp_s_inf,     // fix okay
    input          rlast_s_inf,
    input          rvalid_s_inf,
    // master
    output reg        rready_s_inf
    
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
reg in_valid_reg;

reg [3:0] in_pic_no_reg;
reg in_mode_reg;
reg [1:0] in_ratio_mode_reg;

reg [7:0] count;
reg [1:0] channel_count;

reg [2:0] sram_dly_count;;

// auto focus
reg [7:0] first_row_reg [0:5];
reg [7:0] second_row_reg[0:5];

reg [10:0] row_sub_reg [0:4];
reg [10:0] col_sub_reg [0:5];

reg [15:0] row_sum_2_split_reg;
reg [15:0] row_sum_4_split_reg;
reg [15:0] row_sum_6_split_reg;
reg [15:0] col_sum_2_split_reg;
reg [15:0] col_sum_4_split_reg;
reg [15:0] col_sum_6_split_reg;

reg [15:0] row_sum_2_reg;
reg [15:0] row_sum_4_reg;
reg [15:0] row_sum_6_reg;
reg [15:0] col_sum_2_reg;
reg [15:0] col_sum_4_reg;
reg [15:0] col_sum_6_reg;

reg [15:0] sum_2_reg;
reg [15:0] sum_4_reg;
reg [15:0] sum_6_reg;

reg [15:0] focus_reg_2;
reg [15:0] focus_reg_4;
reg [15:0] focus_reg_6;

// DRAM
reg [127:0] DRAM_data_in;

reg r_shake_reg;

// SRAM
reg sram_wr_en;
reg [5:0] sram_addr;
reg [127:0] sram_in_reg;
reg [127:0] sram_out_reg;

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



wire [127:0] sram_out_wire;
wire [7:0] dram_in_gray [0:15];
wire [7:0] sram_in_wire [0:15];

//assign dram_in_gray[0] = (channel_count == 'd1) ? (rdata_s_inf[7:0] >> 1) : (rdata_s_inf[7:0] >> 2);
assign dram_in_gray[0]  = (channel_count == 'd1) ? (rdata_s_inf[7:0]     >> 1) : (rdata_s_inf[7:0]     >> 2);
assign dram_in_gray[1]  = (channel_count == 'd1) ? (rdata_s_inf[15:8]    >> 1) : (rdata_s_inf[15:8]    >> 2);
assign dram_in_gray[2]  = (channel_count == 'd1) ? (rdata_s_inf[23:16]   >> 1) : (rdata_s_inf[23:16]   >> 2);
assign dram_in_gray[3]  = (channel_count == 'd1) ? (rdata_s_inf[31:24]   >> 1) : (rdata_s_inf[31:24]   >> 2);
assign dram_in_gray[4]  = (channel_count == 'd1) ? (rdata_s_inf[39:32]   >> 1) : (rdata_s_inf[39:32]   >> 2);
assign dram_in_gray[5]  = (channel_count == 'd1) ? (rdata_s_inf[47:40]   >> 1) : (rdata_s_inf[47:40]   >> 2);
assign dram_in_gray[6]  = (channel_count == 'd1) ? (rdata_s_inf[55:48]   >> 1) : (rdata_s_inf[55:48]   >> 2);
assign dram_in_gray[7]  = (channel_count == 'd1) ? (rdata_s_inf[63:56]   >> 1) : (rdata_s_inf[63:56]   >> 2);
assign dram_in_gray[8]  = (channel_count == 'd1) ? (rdata_s_inf[71:64]   >> 1) : (rdata_s_inf[71:64]   >> 2);
assign dram_in_gray[9]  = (channel_count == 'd1) ? (rdata_s_inf[79:72]   >> 1) : (rdata_s_inf[79:72]   >> 2);
assign dram_in_gray[10] = (channel_count == 'd1) ? (rdata_s_inf[87:80]   >> 1) : (rdata_s_inf[87:80]   >> 2);
assign dram_in_gray[11] = (channel_count == 'd1) ? (rdata_s_inf[95:88]   >> 1) : (rdata_s_inf[95:88]   >> 2);
assign dram_in_gray[12] = (channel_count == 'd1) ? (rdata_s_inf[103:96]  >> 1) : (rdata_s_inf[103:96]  >> 2);
assign dram_in_gray[13] = (channel_count == 'd1) ? (rdata_s_inf[111:104] >> 1) : (rdata_s_inf[111:104] >> 2);
assign dram_in_gray[14] = (channel_count == 'd1) ? (rdata_s_inf[119:112] >> 1) : (rdata_s_inf[119:112] >> 2);
assign dram_in_gray[15] = (channel_count == 'd1) ? (rdata_s_inf[127:120] >> 1) : (rdata_s_inf[127:120] >> 2);

assign sram_in_wire[0]  = (channel_count == 'd0) ? dram_in_gray[0]  : (sram_out_reg[7:0]     + dram_in_gray[0]);
assign sram_in_wire[1]  = (channel_count == 'd0) ? dram_in_gray[1]  : (sram_out_reg[15:8]    + dram_in_gray[1]);
assign sram_in_wire[2]  = (channel_count == 'd0) ? dram_in_gray[2]  : (sram_out_reg[23:16]   + dram_in_gray[2]);
assign sram_in_wire[3]  = (channel_count == 'd0) ? dram_in_gray[3]  : (sram_out_reg[31:24]   + dram_in_gray[3]);
assign sram_in_wire[4]  = (channel_count == 'd0) ? dram_in_gray[4]  : (sram_out_reg[39:32]   + dram_in_gray[4]);
assign sram_in_wire[5]  = (channel_count == 'd0) ? dram_in_gray[5]  : (sram_out_reg[47:40]   + dram_in_gray[5]);
assign sram_in_wire[6]  = (channel_count == 'd0) ? dram_in_gray[6]  : (sram_out_reg[55:48]   + dram_in_gray[6]);
assign sram_in_wire[7]  = (channel_count == 'd0) ? dram_in_gray[7]  : (sram_out_reg[63:56]   + dram_in_gray[7]);
assign sram_in_wire[8]  = (channel_count == 'd0) ? dram_in_gray[8]  : (sram_out_reg[71:64]   + dram_in_gray[8]);
assign sram_in_wire[9]  = (channel_count == 'd0) ? dram_in_gray[9]  : (sram_out_reg[79:72]   + dram_in_gray[9]);
assign sram_in_wire[10] = (channel_count == 'd0) ? dram_in_gray[10] : (sram_out_reg[87:80]   + dram_in_gray[10]);
assign sram_in_wire[11] = (channel_count == 'd0) ? dram_in_gray[11] : (sram_out_reg[95:88]   + dram_in_gray[11]);
assign sram_in_wire[12] = (channel_count == 'd0) ? dram_in_gray[12] : (sram_out_reg[103:96]  + dram_in_gray[12]);
assign sram_in_wire[13] = (channel_count == 'd0) ? dram_in_gray[13] : (sram_out_reg[111:104] + dram_in_gray[13]);
assign sram_in_wire[14] = (channel_count == 'd0) ? dram_in_gray[14] : (sram_out_reg[119:112] + dram_in_gray[14]);
assign sram_in_wire[15] = (channel_count == 'd0) ? dram_in_gray[15] : (sram_out_reg[127:120] + dram_in_gray[15]);




wire [10:0] row_sub_wire [0:4];
wire [10:0] col_sub_wire [0:5];
assign row_sub_wire[0] = (first_row_reg[0] > first_row_reg[1])  ? (first_row_reg[0] - first_row_reg[1])  : (first_row_reg[1] - first_row_reg[0]);
assign row_sub_wire[1] = (first_row_reg[1] > first_row_reg[2])  ? (first_row_reg[1] - first_row_reg[2])  : (first_row_reg[2] - first_row_reg[1]);
assign row_sub_wire[2] = (first_row_reg[2] > first_row_reg[3])  ? (first_row_reg[2] - first_row_reg[3])  : (first_row_reg[3] - first_row_reg[2]);
assign row_sub_wire[3] = (first_row_reg[3] > first_row_reg[4])  ? (first_row_reg[3] - first_row_reg[4])  : (first_row_reg[4] - first_row_reg[3]);
assign row_sub_wire[4] = (first_row_reg[4] > first_row_reg[5])  ? (first_row_reg[4] - first_row_reg[5])  : (first_row_reg[5] - first_row_reg[4]);
assign col_sub_wire[0] = (first_row_reg[0] > second_row_reg[0]) ? (first_row_reg[0] - second_row_reg[0]) : (second_row_reg[0] - first_row_reg[0]);
assign col_sub_wire[1] = (first_row_reg[1] > second_row_reg[1]) ? (first_row_reg[1] - second_row_reg[1]) : (second_row_reg[1] - first_row_reg[1]);
assign col_sub_wire[2] = (first_row_reg[2] > second_row_reg[2]) ? (first_row_reg[2] - second_row_reg[2]) : (second_row_reg[2] - first_row_reg[2]);
assign col_sub_wire[3] = (first_row_reg[3] > second_row_reg[3]) ? (first_row_reg[3] - second_row_reg[3]) : (second_row_reg[3] - first_row_reg[3]);
assign col_sub_wire[4] = (first_row_reg[4] > second_row_reg[4]) ? (first_row_reg[4] - second_row_reg[4]) : (second_row_reg[4] - first_row_reg[4]);
assign col_sub_wire[5] = (first_row_reg[5] > second_row_reg[5]) ? (first_row_reg[5] - second_row_reg[5]) : (second_row_reg[5] - first_row_reg[5]);

wire [15:0] row_sum_2_split_wire = row_sub_reg[2];
wire [15:0] row_sum_4_split_wire = row_sub_reg[1] + row_sub_reg[3];
wire [15:0] row_sum_6_split_wire = row_sub_reg[0] + row_sub_reg[4];

wire [15:0] col_sum_2_split_wire = col_sub_reg[2] + col_sub_reg[3];
wire [15:0] col_sum_4_split_wire = col_sub_reg[1] + col_sub_reg[4];
wire [15:0] col_sum_6_split_wire = col_sub_reg[0] + col_sub_reg[5];


wire [15:0] row_sum_2_wire = row_sum_2_split_wire;
wire [15:0] row_sum_4_wire = row_sum_2_split_wire + row_sum_4_split_wire;
wire [15:0] row_sum_6_wire = row_sum_2_split_wire + row_sum_4_split_wire + row_sum_6_split_wire;
wire [15:0] col_sum_2_wire = col_sum_2_split_wire;
wire [15:0] col_sum_4_wire = col_sum_2_split_wire + col_sum_4_split_wire;
wire [15:0] col_sum_6_wire = col_sum_2_split_wire + col_sum_4_split_wire + col_sum_6_split_wire;


wire ar_shake   = arvalid_s_inf & arready_s_inf;
wire r_shake    = rvalid_s_inf & rready_s_inf;


wire read_dram_done = count == 'd192;
wire write_dram_done;

wire focus_done;
wire exposure_done;

//==================================================================
// Design
//==================================================================
always @(*) begin
    case(state)
        IDLE        : next_state = in_valid         ? DIN       : IDLE;
        DIN         : next_state = READ_DRAM;
        READ_DRAM   : next_state = ~read_dram_done  ? READ_DRAM : (in_mode_reg == AUTO_FOCUS_MODE ? AUTO_FOCUS : EXPOSURE);
        AUTO_FOCUS  : next_state = focus_done       ? DOUT      : AUTO_FOCUS;
        EXPOSURE    : next_state = exposure_done    ? WRITE_DRAM: EXPOSURE;
        WRITE_DRAM  : next_state = write_dram_done  ? DOUT      : WRITE_DRAM;
        DOUT        : next_state = IDLE;
        default     : next_state = IDLE;
    endcase
end

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




// DRAM read address
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        arlen_s_inf <= 'd0;
    end
    else if(in_valid_reg) begin
        arlen_s_inf <= (in_mode_reg == AUTO_FOCUS_MODE) ? 'd191 : 'd191;
    end
    else if(state == DOUT) begin
        arlen_s_inf <= 'd0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        araddr_s_inf <= 32'h10000;
    end
    else if(in_valid_reg) begin
        if (in_mode_reg == AUTO_FOCUS_MODE) begin
            araddr_s_inf <= araddr_s_inf + in_pic_no_reg * 'd3072 + 'd429;
        end
        else begin
            araddr_s_inf <= araddr_s_inf + in_pic_no_reg * 'd3072;
        end
    end
    else if(ar_shake) begin
        araddr_s_inf <= 32'h10000;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        arvalid_s_inf <= 1'b0;
    end
    else if(in_valid_reg) begin
        arvalid_s_inf <= 1'b1;
    end
    else if(ar_shake) begin // handshake
        arvalid_s_inf <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        rready_s_inf <= 1'b0;
    end
    else if(channel_count == 'd0 & count == 'd63) begin
        rready_s_inf <= 1'b0;
    end
    else if(ar_shake) begin
        rready_s_inf <= 1'b1;
    end
    else if(channel_count == 'd1) begin
        rready_s_inf <= (sram_dly_count == 'd4) ? 1'b1 : 1'b0;
    end
    else if(channel_count == 'd2) begin
        rready_s_inf <= (sram_dly_count == 'd2 | sram_dly_count == 'd3 | sram_dly_count == 'd4) ? 1'b1 : 1'b0;
    end
end


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        r_shake_reg <= 1'b0;
    end
    else begin
        r_shake_reg <= r_shake;
    end
end


reg ch0_reg;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ch0_reg <= 1'b0;
    end
    else begin
        ch0_reg <= channel_count == 'd0;
    end
end

// sram
always @(*) begin
    if(ch0_reg & r_shake_reg) begin
        sram_wr_en = 1'b1;
    end
    else if((channel_count == 'd1 | (channel_count == 'd2 & count == 'd63)) & sram_dly_count == 'd4) begin
        sram_wr_en = 1'b1;
    end
    else begin
        sram_wr_en = 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sram_addr <= 'd0;
    end
    else if(sram_wr_en) begin
        sram_addr <= (sram_addr == 'd63) ? 'd0 : (sram_addr + 'd1);
    end
    else if(channel_count == 'd2) begin
        sram_addr <= (sram_addr == 'd63) ? 'd0 : (sram_addr + 'd1);
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sram_in_reg <= 'd0;
    end
    else begin
        sram_in_reg <= {sram_in_wire[15], sram_in_wire[14], sram_in_wire[13], sram_in_wire[12], 
                        sram_in_wire[11], sram_in_wire[10], sram_in_wire[9],  sram_in_wire[8], 
                        sram_in_wire[7],  sram_in_wire[6],  sram_in_wire[5],  sram_in_wire[4], 
                        sram_in_wire[3],  sram_in_wire[2],  sram_in_wire[1],  sram_in_wire[0]};
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sram_out_reg <= 'd0;
    end
    else begin
        sram_out_reg <= sram_out_wire;
    end
end



always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        count <= 'd0;
    end
    else if(r_shake) begin
        count <= (count == 'd63) ? 'd0 : (count + 'd1);
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sram_dly_count <= 'd0;
    end
    else if(channel_count == 'd2) begin
        sram_dly_count <= (sram_dly_count == 'd4) ? 'd4 : (sram_dly_count + 'd1);
    end
    else if(channel_count != 'd0) begin
        sram_dly_count <= (sram_dly_count == 'd4) ? 'd1 : (sram_dly_count + 'd1);
    end
end





always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        channel_count <= 'd0;
    end
    else if(channel_count == 'd0 & count == 'd63) begin
        channel_count <= 'd1;
    end
    else if(channel_count == 'd1 & count == 'd63 & sram_dly_count == 'd4) begin
        channel_count <= 'd2;
    end
end

integer i;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i=0; i<6; i=i+1) begin
            first_row_reg[i]    <= 'd0;
            second_row_reg[i]   <= 'd0;
        end
    end
    else if(~count[0]) begin
        first_row_reg[0]    <= sram_in_wire[0];
        first_row_reg[1]    <= sram_in_wire[1];
        first_row_reg[2]    <= sram_in_wire[2];
        first_row_reg[3]    <= sram_in_wire[3];
        first_row_reg[4]    <= sram_in_wire[4];
        first_row_reg[5]    <= sram_in_wire[5];
        second_row_reg[0]   <= first_row_reg[0];
        second_row_reg[1]   <= first_row_reg[1];
        second_row_reg[2]   <= first_row_reg[2];
        second_row_reg[3]   <= first_row_reg[3];
        second_row_reg[4]   <= first_row_reg[4];
        second_row_reg[5]   <= first_row_reg[5];
    end
end

// stage-2
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i=0; i<5; i=i+1) begin
            row_sub_reg[i] <= 'd0;
        end
    end
    else begin
        row_sub_reg[0] <= row_sub_wire[0];
        row_sub_reg[1] <= row_sub_wire[1];
        row_sub_reg[2] <= row_sub_wire[2];
        row_sub_reg[3] <= row_sub_wire[3];
        row_sub_reg[4] <= row_sub_wire[4];
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i=0; i<6; i=i+1) begin
            col_sub_reg[i] <= 'd0;
        end
    end
    else begin
        col_sub_reg[0] <= col_sub_wire[0];
        col_sub_reg[1] <= col_sub_wire[1];
        col_sub_reg[2] <= col_sub_wire[2];
        col_sub_reg[3] <= col_sub_wire[3];
        col_sub_reg[4] <= col_sub_wire[4];
        col_sub_reg[5] <= col_sub_wire[5];
    end
end


// stage-3
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        row_sum_2_split_reg <= 'd0;
        row_sum_4_split_reg <= 'd0;
        row_sum_6_split_reg <= 'd0;
        col_sum_2_split_reg <= 'd0;
        col_sum_4_split_reg <= 'd0;
        col_sum_6_split_reg <= 'd0;
    end
    else begin
        row_sum_2_split_reg <= row_sum_2_split_wire;
        row_sum_4_split_reg <= row_sum_4_split_wire;
        row_sum_6_split_reg <= row_sum_6_split_wire;
        col_sum_2_split_reg <= col_sum_2_split_wire;
        col_sum_4_split_reg <= col_sum_4_split_wire;
        col_sum_6_split_reg <= col_sum_6_split_wire;
    end
end

// stage-4
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        row_sum_2_reg <= 'd0;
        row_sum_4_reg <= 'd0;
        row_sum_6_reg <= 'd0;
        col_sum_2_reg <= 'd0;
        col_sum_4_reg <= 'd0;
        col_sum_6_reg <= 'd0;
    end
    else begin
        row_sum_2_reg <= row_sum_2_wire;
        row_sum_4_reg <= row_sum_4_wire;
        row_sum_6_reg <= row_sum_6_wire;
        col_sum_2_reg <= col_sum_2_wire;
        col_sum_4_reg <= col_sum_4_wire;
        col_sum_6_reg <= col_sum_6_wire;
    end
end

// stage-5
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sum_2_reg <= 'd0;
        sum_4_reg <= 'd0;
        sum_6_reg <= 'd0;
    end
    else begin
        sum_2_reg <= row_sum_2_reg + col_sum_2_reg;
        sum_4_reg <= row_sum_4_reg + col_sum_4_reg;
        sum_6_reg <= row_sum_6_reg + col_sum_6_reg;
    end
end


// stage-5
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        focus_reg_6 <= 'd0;
    end
    else if(channel_count == 'd2) begin
        if(count == 'd3) begin
            focus_reg_6 <= focus_reg_6 + row_sum_6_reg;
        end
        else if(count == 'd6 | count == 'd8 | count == 'd10 | count == 'd12 | count == 'd14) begin
            focus_reg_6 <= focus_reg_6 + sum_6_reg;
        end
    end
end


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        focus_reg_4 <= 'd0;
    end
    else if(channel_count == 'd2) begin
        if(count == 'd5) begin
            focus_reg_4 <= focus_reg_4 + row_sum_4_reg;
        end
        else if(count == 'd8 | count == 'd10 | count == 'd12) begin
            focus_reg_4 <= focus_reg_4 + sum_4_reg;
        end
    end
end


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        focus_reg_2 <= 'd0;
    end
    else if(channel_count == 'd2) begin
        if(count == 'd7) begin
            focus_reg_2 <= focus_reg_2 + row_sum_2_reg;
        end
        else if(count == 'd10) begin
            focus_reg_2 <= focus_reg_2 + sum_2_reg;
        end
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
    if(state == DOUT) begin
        out_data ='d0;
    end
    else begin
        out_data ='d0;
    end
end



SRAM_64_128 SRAM_64_128_inst (.CLK(clk), .CS(1'b1), .OE(1'b1), .WEB(!sram_wr_en), .A(sram_addr), .DI(sram_in_reg), .DO(sram_out_wire));

endmodule





module SRAM_64_128 (
    input CLK, CS, OE, WEB,
    input [5:0] A,
    input [127:0] DI,
    output [127:0] DO
);
SRAM_64X128 SRAM_64X128_inst (
    .A0(A[0]), .A1(A[1]), .A2(A[2]), .A3(A[3]), .A4(A[4]), .A5(A[5]),
    .DO0(DO[0]),   .DO1(DO[1]),   .DO2(DO[2]),   .DO3(DO[3]),   .DO4(DO[4]),   .DO5(DO[5]),   .DO6(DO[6]),   .DO7(DO[7]),
    .DO8(DO[8]),   .DO9(DO[9]),   .DO10(DO[10]), .DO11(DO[11]), .DO12(DO[12]), .DO13(DO[13]), .DO14(DO[14]), .DO15(DO[15]),
    .DO16(DO[16]), .DO17(DO[17]), .DO18(DO[18]), .DO19(DO[19]), .DO20(DO[20]), .DO21(DO[21]), .DO22(DO[22]), .DO23(DO[23]),
    .DO24(DO[24]), .DO25(DO[25]), .DO26(DO[26]), .DO27(DO[27]), .DO28(DO[28]), .DO29(DO[29]), .DO30(DO[30]), .DO31(DO[31]),
    .DO32(DO[32]), .DO33(DO[33]), .DO34(DO[34]), .DO35(DO[35]), .DO36(DO[36]), .DO37(DO[37]), .DO38(DO[38]), .DO39(DO[39]),
    .DO40(DO[40]), .DO41(DO[41]), .DO42(DO[42]), .DO43(DO[43]), .DO44(DO[44]), .DO45(DO[45]), .DO46(DO[46]), .DO47(DO[47]),
    .DO48(DO[48]), .DO49(DO[49]), .DO50(DO[50]), .DO51(DO[51]), .DO52(DO[52]), .DO53(DO[53]), .DO54(DO[54]), .DO55(DO[55]),
    .DO56(DO[56]), .DO57(DO[57]), .DO58(DO[58]), .DO59(DO[59]), .DO60(DO[60]), .DO61(DO[61]), .DO62(DO[62]), .DO63(DO[63]),
    .DO64(DO[64]), .DO65(DO[65]), .DO66(DO[66]), .DO67(DO[67]), .DO68(DO[68]), .DO69(DO[69]), .DO70(DO[70]), .DO71(DO[71]),
    .DO72(DO[72]), .DO73(DO[73]), .DO74(DO[74]), .DO75(DO[75]), .DO76(DO[76]), .DO77(DO[77]), .DO78(DO[78]), .DO79(DO[79]),
    .DO80(DO[80]), .DO81(DO[81]), .DO82(DO[82]), .DO83(DO[83]), .DO84(DO[84]), .DO85(DO[85]), .DO86(DO[86]), .DO87(DO[87]),
    .DO88(DO[88]), .DO89(DO[89]), .DO90(DO[90]), .DO91(DO[91]), .DO92(DO[92]), .DO93(DO[93]), .DO94(DO[94]), .DO95(DO[95]),
    .DO96(DO[96]), .DO97(DO[97]), .DO98(DO[98]), .DO99(DO[99]), .DO100(DO[100]), .DO101(DO[101]), .DO102(DO[102]), .DO103(DO[103]),
    .DO104(DO[104]), .DO105(DO[105]), .DO106(DO[106]), .DO107(DO[107]), .DO108(DO[108]), .DO109(DO[109]), .DO110(DO[110]), .DO111(DO[111]),
    .DO112(DO[112]), .DO113(DO[113]), .DO114(DO[114]), .DO115(DO[115]), .DO116(DO[116]), .DO117(DO[117]), .DO118(DO[118]), .DO119(DO[119]),
    .DO120(DO[120]), .DO121(DO[121]), .DO122(DO[122]), .DO123(DO[123]), .DO124(DO[124]), .DO125(DO[125]), .DO126(DO[126]), .DO127(DO[127]),
    .DI0(DI[0]),   .DI1(DI[1]),   .DI2(DI[2]),   .DI3(DI[3]),   .DI4(DI[4]),   .DI5(DI[5]),   .DI6(DI[6]),   .DI7(DI[7]),
    .DI8(DI[8]),   .DI9(DI[9]),   .DI10(DI[10]), .DI11(DI[11]), .DI12(DI[12]), .DI13(DI[13]), .DI14(DI[14]), .DI15(DI[15]),
    .DI16(DI[16]), .DI17(DI[17]), .DI18(DI[18]), .DI19(DI[19]), .DI20(DI[20]), .DI21(DI[21]), .DI22(DI[22]), .DI23(DI[23]),
    .DI24(DI[24]), .DI25(DI[25]), .DI26(DI[26]), .DI27(DI[27]), .DI28(DI[28]), .DI29(DI[29]), .DI30(DI[30]), .DI31(DI[31]),
    .DI32(DI[32]), .DI33(DI[33]), .DI34(DI[34]), .DI35(DI[35]), .DI36(DI[36]), .DI37(DI[37]), .DI38(DI[38]), .DI39(DI[39]),
    .DI40(DI[40]), .DI41(DI[41]), .DI42(DI[42]), .DI43(DI[43]), .DI44(DI[44]), .DI45(DI[45]), .DI46(DI[46]), .DI47(DI[47]),
    .DI48(DI[48]), .DI49(DI[49]), .DI50(DI[50]), .DI51(DI[51]), .DI52(DI[52]), .DI53(DI[53]), .DI54(DI[54]), .DI55(DI[55]),
    .DI56(DI[56]), .DI57(DI[57]), .DI58(DI[58]), .DI59(DI[59]), .DI60(DI[60]), .DI61(DI[61]), .DI62(DI[62]), .DI63(DI[63]),
    .DI64(DI[64]), .DI65(DI[65]), .DI66(DI[66]), .DI67(DI[67]), .DI68(DI[68]), .DI69(DI[69]), .DI70(DI[70]), .DI71(DI[71]),
    .DI72(DI[72]), .DI73(DI[73]), .DI74(DI[74]), .DI75(DI[75]), .DI76(DI[76]), .DI77(DI[77]), .DI78(DI[78]), .DI79(DI[79]),
    .DI80(DI[80]), .DI81(DI[81]), .DI82(DI[82]), .DI83(DI[83]), .DI84(DI[84]), .DI85(DI[85]), .DI86(DI[86]), .DI87(DI[87]),
    .DI88(DI[88]), .DI89(DI[89]), .DI90(DI[90]), .DI91(DI[91]), .DI92(DI[92]), .DI93(DI[93]), .DI94(DI[94]), .DI95(DI[95]),
    .DI96(DI[96]), .DI97(DI[97]), .DI98(DI[98]), .DI99(DI[99]), .DI100(DI[100]), .DI101(DI[101]), .DI102(DI[102]), .DI103(DI[103]),
    .DI104(DI[104]), .DI105(DI[105]), .DI106(DI[106]), .DI107(DI[107]), .DI108(DI[108]), .DI109(DI[109]), .DI110(DI[110]), .DI111(DI[111]),
    .DI112(DI[112]), .DI113(DI[113]), .DI114(DI[114]), .DI115(DI[115]), .DI116(DI[116]), .DI117(DI[117]), .DI118(DI[118]), .DI119(DI[119]),
    .DI120(DI[120]), .DI121(DI[121]), .DI122(DI[122]), .DI123(DI[123]), .DI124(DI[124]), .DI125(DI[125]), .DI126(DI[126]), .DI127(DI[127]),
    .CK(CLK),
    .WEB(WEB),
    .OE(OE),
    .CS(CS)
);
endmodule
