`timescale 1ns/1ps
`include "PATTERN.v"

`ifdef RTL
`include "CONV_TOP.v"
`elsif GATE
`include "CONV_TOP_SYN.v"
`endif

module TESTBED();


wire	    clk1, clk2;
wire        rst_n;
wire        in_valid;
wire [17:0] in_row;
wire [11:0] in_kernel;
wire 	    out_valid;
wire [7:0] out_data;

initial begin
  `ifdef RTL
    $fsdbDumpfile("CONV_TOP.fsdb");
	$fsdbDumpvars(0,"+mda");
  `elsif GATE
    //$fsdbDumpfile("CONV_TOP.fsdb");
	$sdf_annotate("CONV_TOP_SYN_pt.sdf",I_CONV,,,"maximum");      
	//$fsdbDumpvars(0,"+mda");
  `endif
end

CONV_TOP I_CONV
(
  // Input signals
	.clk1(clk1),
	.clk2(clk2),
	.rst_n(rst_n),
	.in_valid(in_valid),
	.in_row(in_row),
	.in_kernel(in_kernel),
  // Output signals
	.out_valid(out_valid),
	.out_data(out_data)
);


PATTERN I_PATTERN
(
  // Output signals
	.clk1(clk1),
	.clk2(clk2),
	.rst_n(rst_n),
	.in_valid(in_valid),
	.in_row(in_row),
	.in_kernel(in_kernel),
  // Input signals
	.out_valid(out_valid),
	.out_data(out_data)
);

endmodule