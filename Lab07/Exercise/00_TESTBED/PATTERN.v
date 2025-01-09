`ifdef RTL
	`define CYCLE_TIME_clk1 47.1
	`define CYCLE_TIME_clk2 10.1
`endif
`ifdef GATE
	`define CYCLE_TIME_clk1 47.1
	`define CYCLE_TIME_clk2 10.1
`endif

module PATTERN(
	clk1,
	clk2,
	rst_n,
	in_valid,
	in_row,
	in_kernel,
	out_valid,
	out_data
);

output reg clk1, clk2;
output reg rst_n;
output reg in_valid;
output reg [17:0] in_row;
output reg [11:0] in_kernel;

input out_valid;
input [7:0] out_data;


//================================================================
// parameters & integer
//================================================================
integer patnum = `PAT_NUM;
integer i_pat, a;
integer f_in_row, f_in_kernel, f_out;
integer pat_idx;
integer latency;
integer total_latency;
integer out_num;
integer i;
integer SEED = 5487;

//================================================================
// wire & registers 
//================================================================
reg [17:0]	in_row_reg;
reg [11:0]	in_kernel_reg;
reg [7:0]	golden_result;

//================================================================
// clock
//================================================================
real CYCLE_clk1 = `CYCLE_TIME_clk1;
real CYCLE_clk2 = `CYCLE_TIME_clk2;
initial	clk1 = 0;
initial	clk2 = 0;
always	#(CYCLE_clk1/2.0) clk1 = ~clk1;
always	#(CYCLE_clk2/2.0) clk2 = ~clk2;

//================================================================
// initial
//================================================================
/* Check for invalid overlap */
always @(*) begin
    if (in_valid && out_valid) begin
        $display("************************************************************");  
        $display("                          FAIL!                           ");    
        $display("*  The out_valid signal cannot overlap with in_valid.   *");
        $display("************************************************************");
        repeat (5) #CYCLE_clk1;
        $finish;            
    end    
end

always @(negedge clk1) begin
    if (out_valid === 1'b0 && out_data !== 'b0) begin
        $display("************************************************************");  
        $display("                          FAIL!                           ");    
        $display("*  The out signal should be zero when out_valid is low.   *");
        $display("************************************************************");
        repeat (5) #CYCLE_clk1;
		$finish;            
    end    
end

// read input and output file
initial begin
    f_in_row   = $fopen("../00_TESTBED/in_row.txt",  "r");
    f_in_kernel   = $fopen("../00_TESTBED/in_kernel.txt",  "r");
    f_out       = $fopen("../00_TESTBED/output.txt", "r");

    if (f_in_row == 0) begin $display("Failed to open in_row.txt");    $finish; end
    if (f_in_kernel == 0) begin $display("Failed to open in_kernel.txt");	$finish; end
    if (f_out == 0)     begin $display("Failed to open output.txt");	$finish; end
end


initial begin
    reset_task;
    for (i_pat = 0; i_pat < patnum; i_pat = i_pat + 1) begin
        input_task;
        wait_out_valid_task;
        check_ans_task;
        $display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32m     Execution CYCLE_clk1: %3d\033[m", i_pat, latency);
    end
    YOU_PASS_task;
end

//================================================================
// task
//================================================================
// Task to reset the system
task reset_task; begin 
    rst_n           = 1'b1;
    in_valid        = 1'b0;
    total_latency   = 0;
    golden_result   = 0;

    force clk1 = 0;
    force clk2 = 0;
    // Apply reset
    #CYCLE_clk1; rst_n = 1'b0; 
    #CYCLE_clk1; rst_n = 1'b1;
    // Check initial conditions
    if (out_data !== 'b0) begin
        $display("************************************************************");  
        $display("                          FAIL!                           ");    
        $display("*  Output signals should be 0 after initial RESET at %8t *", $time);
        $display("************************************************************");
        repeat (2) #CYCLE_clk1;
        $finish;
    end
    #CYCLE_clk1; release clk1;
end endtask

// Task to handle input
task input_task; begin
    repeat(({$random(SEED)} % 3 + 1)) @(negedge clk1);
    // read pattern num
    a = $fscanf(f_in_row,  	"%d", pat_idx);
    a = $fscanf(f_in_kernel,"%d", pat_idx);

    in_valid = 1'b1;
    
    for(i = 0 ; i < 6 ; i = i + 1) begin
        a = $fscanf(f_in_row, 	"%d", in_row_reg);
        a = $fscanf(f_in_kernel,"%d", in_kernel_reg);

        in_row 		= in_row_reg;
        in_kernel 	= in_kernel_reg;

        @(negedge clk1);
        in_data = 'dx;
        in_mode = 'dx;
    end
    in_valid = 1'b0;
end endtask


// Task to wait until out_valid is high
task wait_out_valid_task; begin
    latency = 0;
    while (out_valid !== 1'b1) begin
        latency = latency + 1;
        if (latency == 1000) begin
            $display("********************************************************");     
            $display("                          FAIL!                           ");
            $display("*  The execution latency exceeded 1000 CYCLE_clk1s at %8t   *", $time);
            $display("********************************************************");
            repeat (2) @(negedge clk1);
            $finish;
        end
        @(negedge clk1);
    end
    total_latency = total_latency + latency;
end endtask


// Task to check the answer
task check_ans_task; begin
    out_num = 0;
    a = $fscanf(f_out, "%d", pat_idx);
    while (out_valid === 1) begin
        a = $fscanf(f_out, "%d", golden_result);
        #1
        if (out_data !== golden_result) begin
            $display("************************************************************");  
            $display("                          FAIL!                           ");
            $display(" Expected: %d", golden_result);
            $display(" Received: %d", out_data);
            $display("************************************************************");
            repeat (5) @(negedge clk1);
            $finish;
        end else begin
            @(negedge clk1);
            out_num = out_num + 1;
        end
    end
    // Check if the number of outputs matches the expected count
    if(out_num !== 150) begin
        $display("************************************************************");  
        $display("                          FAIL!                              ");
        $display(" Expected one valid output, but found %d", out_num);
        $display("************************************************************");
        repeat(3) @(negedge clk1);
        $finish;
    end
    golden_result = 0;
end endtask


// Task to indicate all patterns have passed
task YOU_PASS_task; begin
    $display("----------------------------------------------------------------------------------------------------------------------");
    $display("                                                  Congratulations!                                                    ");
    $display("                                           You have passed all patterns!                                               ");
    $display("                                           Your execution CYCLE_clk1s = %5d CYCLE_clk1s                                          ", total_latency);
    $display("                                           Your clock period = %.1f ns                                                 ", CYCLE_clk1);
    $display("                                           Total Latency = %.1f ns                                                    ", total_latency * CYCLE_clk1);
    $display("----------------------------------------------------------------------------------------------------------------------");
    repeat (2) @(negedge clk1);
    $finish;
end endtask

endmodule
