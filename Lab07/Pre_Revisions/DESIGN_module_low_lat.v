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

//==================================================================
// Regs
//==================================================================
reg [1:0] state, next_state;

reg [17:0] in_row_reg    [0:5];
reg [11:0] in_kernel_reg [0:5];

reg [2:0] in_count;
reg [2:0] out_count;

reg fifo_empty_reg1, fifo_empty_reg2;

//==================================================================
// Wires
//==================================================================
wire in_done  = in_count  == 'd6;
wire out_done = out_count == 'd6;

assign fifo_rinc = ~fifo_empty;
assign handshake_sready = (in_count == 'd0) ? 1'b0 : out_idle;

//==================================================================
// Design
//==================================================================
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
    else if(out_done) begin
        in_count <= 'd0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_count <= 'd0;
    end
    else if(handshake_sready) begin
        out_count <= out_count + 'd1;
    end
    else if(out_done) begin
        out_count <= 'd0;
    end
end

// output
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        handshake_din <= 'd0;
    end
    else if(handshake_sready) begin
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

always @(*) begin
    if(!fifo_empty_reg2) begin
        out_valid = 1'b1;
    end 
    else begin
        out_valid = 1'b0;
    end
end

always @(*) begin
    if(out_valid) begin
        out_data = fifo_rdata;
    end 
    else begin
        out_data = 'd0;
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

//==================================================================
// Regs
//==================================================================
// input regs
reg in_valid_reg;
reg [2:0] ifmap_reg     [0:5][0:5];
reg [2:0] kernel_reg    [0:3][0:5];

// counters
reg [2:0] in_count;
reg [7:0] out_count;

reg [2:0] ifmap_x, ifmap_y; // 0~4
reg [2:0] kernel_idx;       // 0~5

reg acc_count_x;
reg acc_count_y;
reg [7:0] psum_reg;

//==================================================================
// Wires
//==================================================================
// MAC
wire [5:0] product   = ifmap_reg[ifmap_x+acc_count_x][ifmap_y+acc_count_y] * kernel_reg[{acc_count_y, acc_count_x}][kernel_idx];
wire [7:0] psum_wire = psum_reg + product;

// control
wire in_valid_pulse = !in_valid & in_valid_reg;

wire in_done        = in_count == 'd6;
wire out_done       = out_count == 'd150 & !fifo_full;

wire ifmap_x_done   = ifmap_x == 'd4;
wire ifmap_y_done   = ifmap_y == 'd4;
wire kernel_idx_done= kernel_idx == 'd5;
wire acc_count_done = acc_count_x & acc_count_y;

wire cal_en = busy & !fifo_full & acc_count_done;

//==================================================================
// Design
//==================================================================
// input reg
always @(posedge clk) begin
    if(in_valid_pulse) begin
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
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        in_valid_reg <= 1'b0;
    end
    else begin
        in_valid_reg <= in_valid;
    end
end

// control
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        busy <= 1'b0;
    end
    else if(out_done & acc_count_done) begin
        busy <= 1'b0;
    end
    else if(in_count == 'd2) begin
        busy <= (ifmap_y == 'd1) ? 1'b0 : 1'b1;
    end
    else if(in_count == 'd3) begin
        busy <= (ifmap_y == 'd2) ? 1'b0 : 1'b1;
    end
    else if(in_count == 'd4) begin
        busy <= (ifmap_y == 'd3) ? 1'b0 : 1'b1;
    end
    else if(in_count == 'd5) begin
        busy <= (ifmap_y == 'd4) ? 1'b0 : 1'b1;
    end
    else if(in_done) begin
        busy <= 1'b1;
    end
    else begin
        busy <= busy;
    end
end

// counter
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        in_count <= 'd0;
    end
    else if (in_valid_pulse) begin
        in_count <= in_done ? 'd6 : (in_count + 'd1);
    end
    else if(out_done) begin
        in_count <= 'd0;
    end
    else begin
        in_count <= in_count;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_count <= 'd0;
    end
    else if(cal_en) begin
        out_count <= out_done ? 'd0 : (out_count + 'd1);
    end
    else begin
        out_count <= out_count;
    end
end

// buffer counter
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ifmap_x <= 'd0;
    end
    else if(out_done) begin
        ifmap_x <= 'd0;
    end
    else if(cal_en) begin
        ifmap_x <= ifmap_x_done ? 'd0 : (ifmap_x + 'd1);
    end
    else begin
        ifmap_x <= ifmap_x;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ifmap_y <= 'd0;
    end
    else if(out_done) begin
        ifmap_y <= 'd0;
    end
    else if(cal_en & ifmap_x_done) begin
        ifmap_y <= ifmap_y_done ? 'd0 : (ifmap_y + 'd1);
    end
    else begin
        ifmap_y <= ifmap_y;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        kernel_idx <= 'd0;
    end
    else if(out_done) begin
        kernel_idx <= 'd0;
    end
    else if(cal_en & ifmap_x_done & ifmap_y_done) begin
        kernel_idx <= kernel_idx + 'd1;
    end
    else begin
        kernel_idx <= kernel_idx;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        acc_count_x <= 'd0;
    end
    else if(busy) begin
        acc_count_x <= ~acc_count_x;
    end
    else begin
        acc_count_x <= acc_count_x;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        acc_count_y <= 1'b0;
    end
    else if(busy & acc_count_x) begin
        acc_count_y <= ~acc_count_y;
    end
    else begin
        acc_count_y <= acc_count_y;
    end
end

// CONV
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        psum_reg <= 'd0;
    end
    else if (busy) begin
        if(!acc_count_x & !acc_count_y) begin
            psum_reg <= product;
        end
        else begin
            psum_reg <= psum_wire;
        end
    end
    else begin
        psum_reg <= psum_reg;
    end
end


// output
always @(*) begin
    if (cal_en & !out_done) begin
        out_valid = 1'b1;
    end
    else begin
        out_valid = 1'b0;
    end
end

always @(*) begin
    out_data = psum_wire;
end

endmodule
