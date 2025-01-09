`define CYCLE_TIME 20.0
`define PAT_NUM    10000

module PATTERN(
    // Output signals
    clk,
	rst_n,
	in_valid,
    in_data, 
	in_mode,
    // Input signals
    out_valid, 
	out_data
);

// ========================================
// Input & Output
// ========================================
output reg clk, rst_n, in_valid;
output reg [8:0] in_mode;
output reg [14:0] in_data;

input out_valid;
input [206:0] out_data;

//---------------------------------------------------------------------
//   PARAMETER & INTEGER DECLARATION
//---------------------------------------------------------------------
integer patnum = `PAT_NUM;
integer i_pat, a;
integer f_in_data, f_in_mode, f_out;
integer pat_idx;
integer latency;
integer total_latency;
integer out_num;
integer i;
integer SEED = 5487;


//---------------------------------------------------------------------
//   REG & WIRE DECLARATION
//---------------------------------------------------------------------
reg [14:0]      in_data_reg;
reg [8:0]       in_mode_reg;
reg [206:0]     golden_result;

//---------------------------------------------------------------------
//  SIMULATION
//---------------------------------------------------------------------
real CYCLE = `CYCLE_TIME;
always #(CYCLE/2.0) clk = ~clk;



/* Check for invalid overlap */
always @(*) begin
    if (in_valid && out_valid) begin
        $display("************************************************************");  
        $display("                          FAIL!                           ");    
        $display("*  The out_valid signal cannot overlap with in_valid.   *");
        $display("************************************************************");
        repeat (5) #CYCLE;
        $finish;            
    end    
end


always @(negedge clk) begin
    if (out_valid === 1'b0 && out_data !== 'b0) begin
        $display("************************************************************");  
        $display("                          FAIL!                           ");    
        $display("*  The out signal should be zero when out_valid is low.   *");
        $display("************************************************************");
        repeat (5) #CYCLE;
		$finish;            
    end    
end

// read input and output file
initial begin
    f_in_data   = $fopen("../00_TESTBED/input.txt",  "r");
    f_in_mode   = $fopen("../00_TESTBED/input_mode.txt",  "r");
    f_out       = $fopen("../00_TESTBED/output.txt", "r");

    if (f_in_data == 0) begin $display("Failed to open input.txt");    $finish; end
    if (f_in_mode == 0) begin $display("Failed to open input_mode.txt");    $finish; end
    if (f_out == 0)     begin $display("Failed to open output.txt");        $finish; end
end


initial begin
    reset_task;
    for (i_pat = 0; i_pat < patnum; i_pat = i_pat + 1) begin
        input_task;
        wait_out_valid_task;
        check_ans_task;
        $display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32m     Execution Cycle: %3d\033[m", i_pat, latency);
    end
    YOU_PASS_task;
end



// Task to reset the system
task reset_task; begin 
    rst_n           = 1'b1;
    in_valid        = 1'b0;
    total_latency   = 0;
    golden_result   = 0;

    force clk = 0;
    // Apply reset
    #CYCLE; rst_n = 1'b0; 
    #CYCLE; rst_n = 1'b1;
    // Check initial conditions
    if (out_data !== 'b0) begin
        $display("************************************************************");  
        $display("                          FAIL!                           ");    
        $display("*  Output signals should be 0 after initial RESET at %8t *", $time);
        $display("************************************************************");
        repeat (2) #CYCLE;
        $finish;
    end
    #CYCLE; release clk;
end endtask

parameter MATRIX_SIZE_4 = 9'b011001100;
parameter MATRIX_SIZE_3 = 9'b100001100;
parameter MATRIX_SIZE_2 = 9'b010101000;
// Task to handle input
task input_task; begin
    repeat(({$random(SEED)} % 3 + 2)) @(negedge clk);
    // read pattern num
    a = $fscanf(f_in_data,  "%b", pat_idx);
    a = $fscanf(f_in_mode,  "%b", pat_idx);

    in_valid = 1'b1;
    
    for(i = 0 ; i < 16 ; i = i + 1) begin
        a = $fscanf(f_in_data, "%b", in_data_reg);
        in_data = in_data_reg;

        if(i == 0)  a = $fscanf(f_in_mode, "%b", in_mode_reg);
        if(i == 0)  in_mode = in_mode_reg;
        else        in_mode = 'bx;

        @(negedge clk);
        in_data = 'bx;
        in_mode = 'bx;
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
            $display("*  The execution latency exceeded 1000 cycles at %8t   *", $time);
            $display("********************************************************");
            repeat (2) @(negedge clk);
            $finish;
        end
        @(negedge clk);
    end
    total_latency = total_latency + latency;
end endtask


// Task to check the answer
task check_ans_task; begin
    out_num = 0;
    a = $fscanf(f_out, "%b", pat_idx);
    while (out_valid === 1) begin
        a = $fscanf(f_out, "%b", golden_result);
        #1
        if (out_data !== golden_result) begin
            $display("************************************************************");  
            $display("                          FAIL!                           ");
            $display(" Expected: %b", golden_result);
            $display(" Received: %b", out_data);
            $display("************************************************************");
            repeat (5) @(negedge clk);
            $finish;
        end else begin
            @(negedge clk);
            out_num = out_num + 1;
        end
    end
    // Check if the number of outputs matches the expected count
    if(out_num !== 1) begin
        $display("************************************************************");  
        $display("                          FAIL!                              ");
        $display(" Expected one valid output, but found %d", out_num);
        $display("************************************************************");
        repeat(3) @(negedge clk);
        $finish;
    end
    golden_result = 0;
end endtask


// Task to indicate all patterns have passed
task YOU_PASS_task; begin
    $display("----------------------------------------------------------------------------------------------------------------------");
    $display("                                                  Congratulations!                                                    ");
    $display("                                           You have passed all patterns!                                               ");
    $display("                                           Your execution cycles = %5d cycles                                          ", total_latency);
    $display("                                           Your clock period = %.1f ns                                                 ", CYCLE);
    $display("                                           Total Latency = %.1f ns                                                    ", total_latency * CYCLE);
    $display("----------------------------------------------------------------------------------------------------------------------");
    repeat (2) @(negedge clk);
    $finish;
end endtask

endmodule
