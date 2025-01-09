module CLK_1_MODULE (
    clk,
    rst_n,
    in_valid,
	in_row,
    in_kernel,
    out_idle,
    handshake_sready,
    handshake_din,

    flag_handshake_to_clk1,
    flag_clk1_to_handshake,

	fifo_empty,
    fifo_rdata,
    fifo_rinc,
    out_valid,
    out_data,

    flag_clk1_to_fifo,
    flag_fifo_to_clk1
);
input clk;
input rst_n;
input in_valid;
input [17:0] in_row;
input [11:0] in_kernel;
input out_idle;
output handshake_sready;
output reg [29:0] handshake_din;

input fifo_empty;
input [7:0] fifo_rdata;
output fifo_rinc;
output reg out_valid;
output reg [7:0] out_data;
// You can use the the custom flag ports for your design
input  flag_handshake_to_clk1;
input  flag_fifo_to_clk1;
output flag_clk1_to_handshake;
output flag_clk1_to_fifo;

localparam IDLE = 2'd0;
localparam DIN  = 2'd1;
localparam DOUT = 2'd2;

reg [1:0] state, next_state;

reg [17:0] in_row_reg    [0:5];
reg [11:0] in_kernel_reg [0:5];

reg [2:0] in_count;
reg [2:0] out_count;

reg fifo_empty_reg1, fifo_empty_reg2;

assign fifo_rinc = ~fifo_empty;
assign handshake_sready = (in_count != 'd6) ? 1'b0 : out_idle;

wire in_done  = in_count  > 'd5;
wire out_done = out_count > 'd5;

// next state logic
always @(*) begin
    case (state)
        IDLE    : next_state = in_valid ?   DIN   : IDLE;
        DIN     : next_state = in_done  ?   DOUT  : DIN;
        DOUT    : next_state = out_done ?   IDLE  : DOUT;
        default : next_state = IDLE;
    endcase
end

//FSM
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
    if(in_valid) begin 
        in_row_reg[in_count]    <= in_row;
        in_kernel_reg[in_count] <= in_kernel;
    end
end

// counter
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        in_count <= 'd0;
    end
    else if(in_valid) begin
        in_count <= in_count + 'd1;
    end
    else if(state == IDLE) begin
        in_count <= 'd0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_count <= 'd0;
    end
    else if(state == DOUT & handshake_sready & (in_count == 'd6)) begin
        out_count <= out_count + 'd1;
    end
    else if(state == IDLE) begin
        out_count <= 'd0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        handshake_din <= 'd0;
    end
    else if(handshake_sready & state == DOUT) begin
        handshake_din <= {in_row_reg[out_count], in_kernel_reg[out_count]};
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        fifo_empty_reg1 <= 1'b1;
        fifo_empty_reg2 <= 1'b1;
    end
    else begin
        fifo_empty_reg1 <= fifo_empty;
        fifo_empty_reg2 <= fifo_empty_reg1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_valid <= 1'b0;
    end
    else if(~fifo_empty_reg2) begin
        out_valid <= 1'b1;
    end 
    else begin
        out_valid <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        out_data <= 'd0;
    end 
    else if(!fifo_empty_reg2) begin
        out_data <= fifo_rdata;
    end 
    else begin
        out_data <= 'd0;
    end
end

endmodule



module CLK_2_MODULE (
    clk,
    rst_n,
    in_valid,
    fifo_full,
    in_data,
    out_valid,
    out_data,
    busy,

    flag_handshake_to_clk2,
    flag_clk2_to_handshake,
    flag_fifo_to_clk2,
    flag_clk2_to_fifo
);

input clk;
input rst_n;
input in_valid;
input fifo_full;
input [29:0] in_data;
output reg out_valid;
output reg [7:0] out_data;
output reg busy;

// You can use the the custom flag ports for your design
input  flag_handshake_to_clk2;
input  flag_fifo_to_clk2;
output flag_clk2_to_handshake;
output flag_clk2_to_fifo;


localparam IDLE = 2'd0;
localparam DIN  = 2'd1;
localparam DOUT = 2'd2;

reg [1:0] state, next_state;


reg in_valid_reg, in_valid_pulse;
reg [5:0] in_count;
reg [8:0] out_count;

reg [2:0] ifmap_reg     [0:5][0:5];
reg [2:0] kernel_reg    [0:3][0:5];

reg [2:0] ifmap_x, ifmap_y;
reg [2:0] kernel_idx;
reg [7:0] ofmap_reg;

wire [2:0] ifmap    [0:3];
wire [2:0] weight   [0:3];
wire [7:0] ofmap;

assign ifmap[0] = ifmap_reg[ifmap_x][ifmap_y];
assign ifmap[1] = ifmap_reg[ifmap_x+1][ifmap_y];
assign ifmap[2] = ifmap_reg[ifmap_x][ifmap_y+1];
assign ifmap[3] = ifmap_reg[ifmap_x+1][ifmap_y+1];

assign weight[0] = kernel_reg[0][kernel_idx];
assign weight[1] = kernel_reg[1][kernel_idx];
assign weight[2] = kernel_reg[2][kernel_idx];
assign weight[3] = kernel_reg[3][kernel_idx];

assign ofmap = ifmap[0]*weight[0] + ifmap[1]*weight[1] + ifmap[2]*weight[2] + ifmap[3]*weight[3];

wire start_output_flag = ifmap_x != 'd0 | ifmap_y != 'd0;

wire in_done    = in_count > 'd5;
wire out_done   = out_count == 'd150 & !fifo_full;

// next state logic
always @(*) begin
    case (state)
        IDLE    : next_state = in_valid_pulse   ?   DIN   : IDLE;
        DIN     : next_state = in_done          ?   DOUT  : DIN;
        DOUT    : next_state = out_done         ?   IDLE  : DOUT;
        default : next_state = IDLE;
    endcase
end

//FSM
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= IDLE;
    end
    else begin
        state <= next_state;
    end
end


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        busy <= 1'b0;
    end
    else if(in_count == 'd6 & out_count != 'd150) begin
        busy <= 1'b1;
    end
    else if(out_done) begin
        busy <= 1'b0;
    end
end


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        in_valid_reg <= 1'b0;
    end
    else begin
        in_valid_reg <= in_valid;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        in_valid_pulse <= 1'b0;
    end
    else if (!in_valid & in_valid_reg) begin
        in_valid_pulse <= 1'b1;
    end
    else begin
        in_valid_pulse <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        in_count <= 'd0;
    end
    else if (in_valid_pulse & state == DIN) begin
        in_count <= (in_count == 'd16) ? 'd16 : (in_count + 'd1);
    end
    else if(out_count == 'd150) begin
        in_count <= 'd0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_count <= 'd0;
    end
    else if (state == IDLE) begin
        out_count <= 'd0;
    end
    else if(busy & !fifo_full) begin
        out_count <= (out_count == 'd150) ? 'd0 : (out_count + 'd1);
    end
end


integer i;
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i=i; i<6; i=i+1) begin
            ifmap_reg   [0][i] <= 'd0;
            ifmap_reg   [1][i] <= 'd0;
            ifmap_reg   [2][i] <= 'd0;
            ifmap_reg   [3][i] <= 'd0;
            ifmap_reg   [4][i] <= 'd0;
            ifmap_reg   [5][i] <= 'd0;
            kernel_reg  [0][i] <= 'd0;
            kernel_reg  [1][i] <= 'd0;
            kernel_reg  [2][i] <= 'd0;
            kernel_reg  [3][i] <= 'd0;
        end
    end
    else if(in_valid_pulse & state == DIN) begin
        kernel_reg  [0][in_count] <= in_data[2:0];
        kernel_reg  [1][in_count] <= in_data[5:3];
        kernel_reg  [2][in_count] <= in_data[8:6];
        kernel_reg  [3][in_count] <= in_data[11:9];
        ifmap_reg   [0][in_count] <= in_data[14:12];
        ifmap_reg   [1][in_count] <= in_data[17:15];
        ifmap_reg   [2][in_count] <= in_data[20:18];
        ifmap_reg   [3][in_count] <= in_data[23:21];
        ifmap_reg   [4][in_count] <= in_data[26:24];
        ifmap_reg   [5][in_count] <= in_data[29:27];
    end
    else if(state == IDLE) begin
        for(i=i; i<6; i=i+1) begin
            ifmap_reg   [0][i] <= 'd0;
            ifmap_reg   [1][i] <= 'd0;
            ifmap_reg   [2][i] <= 'd0;
            ifmap_reg   [3][i] <= 'd0;
            ifmap_reg   [4][i] <= 'd0;
            ifmap_reg   [5][i] <= 'd0;
            kernel_reg  [0][i] <= 'd0;
            kernel_reg  [1][i] <= 'd0;
            kernel_reg  [2][i] <= 'd0;
            kernel_reg  [3][i] <= 'd0;
        end
    end
end


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ifmap_x <= 'd0;
    end
    else if(state == IDLE) begin
        ifmap_x <= 'd0;
    end
    else if(!fifo_full & in_count == 'd6) begin
        ifmap_x <= (ifmap_x == 'd4) ? 'd0 : (ifmap_x + 'd1);
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ifmap_y <= 'd0;
    end
    else if(state == IDLE) begin
        ifmap_y <= 'd0;
    end
    else if(!fifo_full & in_count == 'd6 & (ifmap_x == 'd4)) begin
        ifmap_y <= (ifmap_y == 'd4) ? 'd0 : (ifmap_y + 'd1);
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        kernel_idx <= 'd0;
    end
    else if(state == IDLE) begin
        kernel_idx <= 'd0;
    end
    else if(!fifo_full & in_count == 'd6 & (ifmap_x == 'd4) & (ifmap_y == 'd4)) begin
        kernel_idx <= (kernel_idx == 'd5) ? 'd0 : (kernel_idx + 'd1);
    end
end


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ofmap_reg <= 'd0;
    end
    else if (!fifo_full) begin
        ofmap_reg <= ofmap;
    end
end


always @(*) begin
    if (busy & out_count < 'd150 & !fifo_full) begin
        out_valid = 1'b1;
    end
    else begin
        out_valid = 1'b0;
    end
end

always @(*) begin
    if(busy & out_count < 'd150 & !fifo_full) begin
        out_data = ofmap_reg;
    end
    else begin
        out_data = 'd0;
    end
end

endmodule
