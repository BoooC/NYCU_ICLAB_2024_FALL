module Handshake_syn #(parameter WIDTH=8) (
    sclk,
    dclk,
    rst_n,
    sready,
    din,
    dbusy,
    sidle,
    dvalid,
    dout,

    flag_handshake_to_clk1,
    flag_clk1_to_handshake,

    flag_handshake_to_clk2,
    flag_clk2_to_handshake
);

input sclk, dclk;
input rst_n;
input sready;
input [WIDTH-1:0] din;
input dbusy;
output sidle;
output reg dvalid;
output reg [WIDTH-1:0] dout;

// You can change the input / output of the custom flag ports
input  flag_clk1_to_handshake;
input  flag_clk2_to_handshake;
output flag_handshake_to_clk1;
output flag_handshake_to_clk2;

// Remember:
//   Don't modify the signal name
reg sreq;
wire dreq;
reg dack;
wire sack;

NDFF_syn U_NDFF_req(.D(sreq), .Q(dreq), .clk(dclk), .rst_n(rst_n));
NDFF_syn U_NDFF_ack(.D(dack), .Q(sack), .clk(sclk), .rst_n(rst_n));

wire dout_shake = !dack & dreq & !dbusy;

// src
assign sidle = !sreq & !sack;

always @(posedge sclk or negedge rst_n) begin
    if(!rst_n)begin
        sreq <= 1'b0;
    end
    else if(sready & !sack)begin
        sreq <= 1'b1;
    end
    else if(sack)begin
        sreq <= 1'b0;
    end
    else begin
        sreq <= sreq;
    end
end

// dst
always @(posedge dclk or negedge rst_n) begin
    if(!rst_n)begin
        dack <= 1'b0;
    end
    else if(dreq & !dbusy)begin
        dack <= 1'b1;
    end
    else if(!dreq)begin
        dack <= 1'b0;
    end
    else begin
        dack <= dack;
    end
end

always @(posedge dclk or negedge rst_n) begin
    if(!rst_n)begin
        dvalid <= 1'b0;
    end
    else if(dout_shake)begin
        dvalid <= 1'b1;
    end
    else begin
        dvalid <= 1'b0;
    end
end

always @(posedge dclk or negedge rst_n) begin
    if(!rst_n)begin
        dout <= 'd0;
    end
    else if(dout_shake)begin
        dout <= din;
    end
    else begin
        dout <= dout;
    end
end

endmodule
