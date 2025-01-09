`include "DESIGN_module.v"
`include "synchronizer/Handshake_syn.v"
`include "synchronizer/FIFO_syn.v"
`include "synchronizer/NDFF_syn.v"
`include "synchronizer/NDFF_BUS_syn.v"

module CONV_TOP (
	// Input signals
	clk1,
	clk2,
	rst_n,
	in_valid,
	in_row,
	in_kernel,
	//  Output signals
	out_valid,
	out_data
);
//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------			
input clk1; 
input clk2;		
input rst_n;
input in_valid;
input [17:0] in_row;
input [11:0] in_kernel;
output out_valid;
output [7:0] out_data; 	

// --------------------------------------------------------------------
//   SIGNAL DECLARATION
// --------------------------------------------------------------------
wire sidle;
wire data_valid_clk1;
wire [29:0] data_clk1;
wire in_data_valid_clk2;
wire [29:0] in_data_clk2;
wire conv_busy;
wire out_data_valid_clk2;
wire [7:0] out_data_clk2;
wire fifo_full;
wire fifo_empty;
wire fifo_rinc;
wire [7:0] fifo_rdata; 

// Custom flags to use if needed
wire flag_handshake_to_clk1;
wire flag_clk1_to_handshake;

wire flag_handshake_to_clk2;
wire flag_clk2_to_handshake;

wire flag_fifo_to_clk2;
wire flag_clk2_to_fifo;

wire flag_fifo_to_clk1;
wire flag_clk1_to_fifo;

CLK_1_MODULE u_input_output (
    .clk (clk1),
    .rst_n (rst_n),
    .in_valid (in_valid),
	.in_row (in_row),
	.in_kernel (in_kernel),
    .out_idle (sidle),
    .handshake_sready (data_valid_clk1),
    .handshake_din (data_clk1),
    .flag_handshake_to_clk1(flag_handshake_to_clk1),
    .flag_clk1_to_handshake(flag_clk1_to_handshake),
	

	.fifo_empty (fifo_empty),
    .fifo_rdata (fifo_rdata),
    .fifo_rinc (fifo_rinc),
    .out_valid (out_valid),
    .out_data (out_data),
    .flag_fifo_to_clk1(flag_fifo_to_clk1),
	.flag_clk1_to_fifo(flag_clk1_to_fifo)
);


Handshake_syn #(30) u_Handshake_syn (
    .sclk (clk1),
    .dclk (clk2),
    .rst_n (rst_n),
    .sready (data_valid_clk1),
    .din (data_clk1),
    .dbusy (conv_busy),
    .sidle (sidle),
    .dvalid (in_data_valid_clk2),
    .dout (in_data_clk2),

    .flag_handshake_to_clk1(flag_handshake_to_clk1),
    .flag_clk1_to_handshake(flag_clk1_to_handshake),

    .flag_handshake_to_clk2(flag_handshake_to_clk2),
    .flag_clk2_to_handshake(flag_clk2_to_handshake)
);

CLK_2_MODULE u_Conv (
	.clk (clk2),
    .rst_n (rst_n),
    .in_valid (in_data_valid_clk2),
    .in_data (in_data_clk2),
	.fifo_full (fifo_full),
    .out_valid (out_data_valid_clk2),
    .out_data (out_data_clk2),
    .busy (conv_busy),

    .flag_handshake_to_clk2(flag_handshake_to_clk2),
    .flag_clk2_to_handshake(flag_clk2_to_handshake),

    .flag_fifo_to_clk2(flag_fifo_to_clk2),
    .flag_clk2_to_fifo(flag_clk2_to_fifo)
);

FIFO_syn #(.WIDTH(8), .WORDS(64)) u_FIFO_syn (
    .wclk (clk2),
    .rclk (clk1),
    .rst_n (rst_n),
    .winc (out_data_valid_clk2),
    .wdata (out_data_clk2),
    .wfull (fifo_full),
    .rinc (fifo_rinc),
    .rdata (fifo_rdata),
    .rempty (fifo_empty),

    .flag_fifo_to_clk2(flag_fifo_to_clk2),
    .flag_clk2_to_fifo(flag_clk2_to_fifo),

    .flag_fifo_to_clk1(flag_fifo_to_clk1),
	.flag_clk1_to_fifo(flag_clk1_to_fifo)
);

endmodule