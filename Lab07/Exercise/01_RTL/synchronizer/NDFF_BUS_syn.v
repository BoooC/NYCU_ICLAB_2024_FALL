module NDFF_BUS_syn #(parameter WIDTH = 8) (
    D, Q, clk, rst_n
);

input [WIDTH-1:0] D;
input clk;
input rst_n;  

output [WIDTH-1:0] Q;

genvar ii;

generate 
    for (ii = 0; ii < WIDTH; ii = ii + 1) begin
        NDFF_syn u_NDFF_syn (
            .D(D[ii]), 
            .clk(clk), 
            .rst_n(rst_n),
            .Q(Q[ii])
        );
    end
endgenerate

endmodule