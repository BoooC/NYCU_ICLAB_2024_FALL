`timescale 1ns/1ps

`include "Usertype.sv"
`include "INF.sv"
`include "PATTERN.sv"
`include "../00_TESTBED/pseudo_DRAM.svp"

`ifdef RTL
  `include "Program.sv"
  `define CYCLE_TIME 15.0
`endif

`ifdef GATE
  `include "Program_SYN.v"
  `include "Program_Wrapper.sv"
  `define CYCLE_TIME 15.0
`endif

module TESTBED;
  
parameter simulation_cycle = `CYCLE_TIME;
  reg  SystemClock;

  INF             inf();
  PATTERN         test_p(.clk(SystemClock), .inf(inf.PATTERN));
  pseudo_DRAM     dram_r(.clk(SystemClock), .inf(inf.DRAM)); 

  `ifdef RTL
	Program      dut_p(.clk(SystemClock), .inf(inf.Program_inf) );
  `endif
  
  `ifdef GATE
	Program_svsim     dut_p(.clk(SystemClock), .inf(inf.Program_inf) );
  `endif  
 //------ Generate Clock ------------
  initial begin
    SystemClock = 0;
	#30
    forever begin
      #(simulation_cycle/2.0)
        SystemClock = ~SystemClock;
    end
  end

//------ Dump FSDB File ------------  
initial begin
  `ifdef RTL
    $fsdbDumpfile("Program.fsdb");
    $fsdbDumpvars(0,"+all");
    $fsdbDumpSVA;
  `elsif GATE
    $fsdbDumpfile("Program_SYN.fsdb");  
    $sdf_annotate("Program_SYN.sdf",dut_p.Program);      
    $fsdbDumpvars(0,"+all");
  `endif
end

endmodule