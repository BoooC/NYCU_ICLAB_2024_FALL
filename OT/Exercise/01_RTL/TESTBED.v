`timescale 1ns/1ps

`include "PATTERN.v"
`ifdef RTL
  `include "Ramen.v"
`endif
`ifdef GATE
  `include "Ramen_SYN.v"
`endif
	  		  	
module TESTBED;

wire         clk, rst_n, in_valid, selling;
wire         portion;
wire  [1:0]  ramen_type;

wire         out_valid_order;
wire         out_valid_tot;
wire         success;
wire  [14:0] total_gain;
wire  [27:0] sold_num;

initial begin
  `ifdef RTL
    $fsdbDumpfile("Ramen.fsdb");
    $fsdbDumpvars(0, "+mda");
    $fsdbDumpvars();
  `endif
  `ifdef GATE
    $sdf_annotate("Ramen_SYN.sdf", u_Ramen);
    $fsdbDumpfile("Ramen_SYN.fsdb");
    $fsdbDumpvars(0, "+mda");
    $fsdbDumpvars();    
  `endif
end

`ifdef RTL
Ramen u_Ramen(
    .clk            (   clk          ),
    .rst_n          (   rst_n        ),
    .in_valid       (   in_valid     ),
    .selling        (   selling      ),
    .portion        (   portion      ),
    .ramen_type     (   ramen_type   ),	

    .out_valid_order(   out_valid_order ),
    .out_valid_tot  (   out_valid_tot   ),
    .success        (   success      ),
    .total_gain     (   total_gain   ),
    .sold_num       (   sold_num     )
);
`endif	

`ifdef GATE
Ramen u_Ramen(
    .clk            (   clk          ),
    .rst_n          (   rst_n        ),
    .in_valid       (   in_valid     ),
    .selling        (   selling      ),
    .portion        (   portion      ),
    .ramen_type     (   ramen_type   ),	

    .out_valid_order(   out_valid_order ),
    .out_valid_tot  (   out_valid_tot   ),
    .success        (   success      ),
    .total_gain     (   total_gain   ),
    .sold_num       (   sold_num     )
);
`endif	

PATTERN u_PATTERN(
    .clk            (   clk          ),
    .rst_n          (   rst_n        ),
    .in_valid       (   in_valid     ),
    .selling        (   selling      ),
    .portion        (   portion      ),
    .ramen_type     (   ramen_type   ),	

    .out_valid_order(   out_valid_order ),
    .out_valid_tot  (   out_valid_tot   ),
    .success        (   success      ),
    .total_gain     (   total_gain   ),
    .sold_num       (   sold_num     )
);
  
endmodule
