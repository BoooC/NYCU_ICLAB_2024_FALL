module FIFO_syn #(parameter WIDTH=8, parameter WORDS=64) (
    wclk,
    rclk,
    rst_n,
    winc,
    wdata,
    wfull,
    rinc,
    rdata,
    rempty,

    flag_fifo_to_clk2,
    flag_clk2_to_fifo,

    flag_fifo_to_clk1,
	flag_clk1_to_fifo
);

input wclk, rclk;
input rst_n;
input winc;
input [WIDTH-1:0] wdata;
output reg wfull;
input rinc;
output reg [WIDTH-1:0] rdata;
output reg rempty;

// You can change the input / output of the custom flag ports
input  flag_clk1_to_fifo;
input  flag_clk2_to_fifo;
output flag_fifo_to_clk1;
output flag_fifo_to_clk2;

// Remember: 
//   wptr and rptr should be gray coded
//   Don't modify the signal name
reg [$clog2(WORDS):0] wptr;
reg [$clog2(WORDS):0] rptr;

wire [$clog2(WORDS):0] wptr_q;
wire [$clog2(WORDS):0] rptr_q;

// sram
wire [WIDTH-1:0] ram_in = wdata;
wire [WIDTH-1:0] ram_out;

// gray counter
reg [6:0] r_binary_reg;
reg [6:0] w_binary_reg; 

wire [6:0] next_r_binary = r_binary_reg + (rinc & ~rempty);
wire [6:0] next_w_binary = w_binary_reg + (winc & ~wfull);

wire [6:0] next_rptr = (next_r_binary >> 1) ^ next_r_binary; // binary to gray
wire [6:0] next_wptr = (next_w_binary >> 1) ^ next_w_binary; // binary to gray

wire [5:0] r_addr = r_binary_reg[5:0];
wire [5:0] w_addr = w_binary_reg[5:0];

// 2-stage DFF
always @(posedge rclk) begin
    rdata <= ram_out;
end

// decimal counter
always @(posedge rclk or negedge rst_n) begin
    if(!rst_n) begin
        r_binary_reg <= 'd0;
    end
    else begin
        r_binary_reg <= next_r_binary;
    end
end

always @(posedge wclk or negedge rst_n) begin
    if(!rst_n) begin
        w_binary_reg <= 'd0;
    end
    else begin
        w_binary_reg <= next_w_binary;
    end
end

// gray counter
always @(posedge rclk or negedge rst_n) begin
    if(!rst_n) begin
        rptr <= 'd0;
    end
    else begin
        rptr <= next_rptr;
    end
end

always @(posedge wclk or negedge rst_n) begin
    if(!rst_n) begin
        wptr <= 'd0;
    end
    else begin
        wptr <= next_wptr;
    end
end

// state
always @(posedge rclk or negedge rst_n) begin
    if(!rst_n) begin
        rempty <= 1'b1;
    end
    else begin
        rempty <= next_rptr == wptr_q;
    end
end

always @(posedge wclk or negedge rst_n) begin
    if(!rst_n) begin
        wfull <= 1'b0;
    end
    else begin
        wfull <= {~next_wptr[6:5], next_wptr[4:0]} == rptr_q;
    end
end

NDFF_BUS_syn #(.WIDTH(WIDTH-1)) M1(.D(rptr), .Q(rptr_q), .clk(wclk), .rst_n(rst_n));
NDFF_BUS_syn #(.WIDTH(WIDTH-1)) M0(.D(wptr), .Q(wptr_q), .clk(rclk), .rst_n(rst_n));

DUAL_64X8X1BM1 u_dual_sram (
    .CKA(wclk),     .CKB(rclk),
    .WEAN(!winc),   .WEBN(1'b1),
    .CSA(1'b1),     .CSB(1'b1),
    .OEA(1'b1),     .OEB(1'b1),

    .A0(w_addr[0]), .A1(w_addr[1]), .A2(w_addr[2]), .A3(w_addr[3]), .A4(w_addr[4]), .A5(w_addr[5]),
    .B0(r_addr[0]), .B1(r_addr[1]), .B2(r_addr[2]), .B3(r_addr[3]), .B4(r_addr[4]), .B5(r_addr[5]),

    .DIA0(ram_in[0]),   .DIA1(ram_in[1]),   .DIA2(ram_in[2]),   .DIA3(ram_in[3]),    
    .DIA4(ram_in[4]),   .DIA5(ram_in[5]),   .DIA6(ram_in[6]),   .DIA7(ram_in[7]),
    .DIB0(),            .DIB1(),            .DIB2(),            .DIB3(),    
    .DIB4(),            .DIB5(),            .DIB6(),            .DIB7(),

    .DOA0(),            .DOA1(),            .DOA2(),            .DOA3(),
    .DOA4(),            .DOA5(),            .DOA6(),            .DOA7(),
    .DOB0(ram_out[0]),  .DOB1(ram_out[1]),  .DOB2(ram_out[2]),  .DOB3(ram_out[3]),
    .DOB4(ram_out[4]),  .DOB5(ram_out[5]),  .DOB6(ram_out[6]),  .DOB7(ram_out[7])
);

endmodule
