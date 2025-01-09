`ifdef RTL
    `define CYCLE_TIME 4.0
`endif
`ifdef GATE
    `define CYCLE_TIME 4.0
`endif
`ifdef POST
    `define CYCLE_TIME 4.0
`endif

module PATTERN(
    // Output signals
    clk,
	rst_n,
	
	in_valid,
	in_valid2,
	
    image,
	template,
	image_size,
	action,

    // Input signals
	out_valid,
	out_value
);

//======================================
//      INPUT & OUTPUT
//======================================
// Output
output reg       clk, rst_n;
output reg       in_valid;
output reg       in_valid2;

output reg [7:0] image;
output reg [7:0] template;
output reg [1:0] image_size;
output reg [2:0] action;

// Input
input out_valid;
input out_value;

//======================================
//      PARAMETERS & VARIABLES
//======================================





endmodule