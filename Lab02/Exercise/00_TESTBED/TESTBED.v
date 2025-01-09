`timescale 1ns/1ps

`include "PATTERN.v"
`ifdef RTL
  `include "BB.v"
`endif
`ifdef GATE
  `include "BB_SYN.v"
`endif
	  		  	
module TESTBED;

wire         clk, rst_n, in_valid;
wire  [1:0]  inning;
wire         half;
wire  [2:0]  action;

wire         out_valid;
wire  [7:0]  score_A, score_B;
wire  [1:0]  result;

initial begin
  `ifdef RTL
    $fsdbDumpfile("BB.fsdb");
    $fsdbDumpvars(0, "+mda");
    $fsdbDumpvars();
  `endif
  `ifdef GATE
    $sdf_annotate("BB_SYN.sdf", u_BB);
    $fsdbDumpfile("BB_SYN.fsdb");
    $fsdbDumpvars(0, "+mda");
    $fsdbDumpvars();    
  `endif
end

`ifdef RTL
BB u_BB(
    .clk            (   clk          ),
    .rst_n          (   rst_n        ),
    .in_valid       (   in_valid     ),
    .inning         (   inning       ),
    .half           (   half         ),	
    .action         (   action       ),

    .out_valid      (   out_valid    ),
    .score_A        (   score_A      ),
    .score_B        (   score_B      ),
    .result         (   result       )
);
`endif	

`ifdef GATE
BB u_BB(
    .clk            (   clk          ),
    .rst_n          (   rst_n        ),
    .in_valid       (   in_valid     ),
    .inning         (   inning       ),
    .half           (   half         ),	
    .action         (   action       ),

    .out_valid      (   out_valid    ),
    .score_A        (   score_A      ),
    .score_B        (   score_B      ),
    .result         (   result       )
);
`endif	

PATTERN u_PATTERN(
    .clk            (   clk          ),
    .rst_n          (   rst_n        ),
    .in_valid       (   in_valid     ),
    .inning         (   inning       ),
    .half           (   half         ),	
    .action         (   action       ),

    .out_valid      (   out_valid    ),
    .score_A        (   score_A      ),
    .score_B        (   score_B      ),
    .result         (   result       )
);
  
endmodule
