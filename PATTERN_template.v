`define CYCLE_TIME 10.0 // Cycle time in nanoseconds
`define PAT_NUM 99      // Number of patterns
`define MAX_LATENCY 100 // Max latency for each pattern
`define OUT_NUM 3       // The number of output for each pattern

module PATTERN(
    // Input Ports
    clk,
    rst_n,
    in_valid, 
    in_1, 
    in_2, 
    out_valid, 
    out_1, 
    out_2, 
);

//---------------------------------------------------------------------
//   PORT DECLARATION          
//---------------------------------------------------------------------
// Output Registers
output reg clk, rst_n;
output reg in_valid;
output reg [] in_1;
output reg [] in_2;

// Input Signals
input out_valid;
input [] out_1;
input [] out_2;

//---------------------------------------------------------------------
//   PARAMETER & INTEGER DECLARATION
//---------------------------------------------------------------------
/* Parameters and Integers */
integer patnum = `PAT_NUM;
integer i_pat, a;
integer f_in_1, f_in_2;
integer f_out_1, f_out_2;
integer latency;
integer total_latency;
integer i;
integer out_num;


//---------------------------------------------------------------------
//   REG & WIRE DECLARATION
//---------------------------------------------------------------------
reg  []  in_1_reg;
reg  []  in_2_reg;
reg  []  golden_out_1;
reg  []  golden_out_2;


//---------------------------------------------------------------------
//  CLOCK
//---------------------------------------------------------------------
/* Define clock cycle */
real CYCLE = `CYCLE_TIME;
always #(CYCLE/2.0) clk = ~clk;


//---------------------------------------------------------------------
//  SIMULATION
//---------------------------------------------------------------------
/* Check for invalid overlap */
always @(*) begin
    if (in_valid && out_valid) begin
        $display("************************************************************");  
        $display("                          FAIL!                           ");    
        $display("*  The out_valid signal cannot overlap with in_valid.   *");
        $display("************************************************************");
        $finish;            
    end    
end

/* Check output value when out_valid is low */
always @(negedge clk) begin
    if (out_valid === 1'b0 && out !== 'b0) begin
        $display("************************************************************");  
        $display("                          FAIL!                           ");    
        $display("*  The out signal should be zero when out_valid is low.   *");
        $display("************************************************************");
        repeat (5) #CYCLE;
		$finish;            
    end    
end

/* read input and output files */
initial begin
    // Open input and output files
    f_in_1  = $fopen("../00_TESTBED/input1.txt", "r");
    f_in_2  = $fopen("../00_TESTBED/input2.txt", "r");
    f_out_1 = $fopen("../00_TESTBED/output1.txt", "r");
    f_out_2 = $fopen("../00_TESTBED/output2.txt", "r");

    if (f_in_1 == 0)    begin $display("Failed to open in_1_file.txt");     $finish; end
    if (f_in_2 == 0)    begin $display("Failed to open in_2_file.txt");     $finish; end
    if (f_out_1 == 0)   begin $display("Failed to open out_1_file.txt");    $finish; end
    if (f_out_2 == 0)   begin $display("Failed to open out_2_file.txt");    $finish; end
end

/* execution */
initial begin
    // Initialize signals
    reset_task;

    // Iterate through each pattern
    for (i_pat = 0; i_pat < patnum; i_pat = i_pat + 1) begin
        input_task;
        wait_out_valid_task;
        check_ans_task;
        $display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32m     Execution Cycle: %3d\033[m", i_pat, latency);
    end

    // All patterns passed
    YOU_PASS_task;
end


// Task to reset the system
task reset_task; begin 
    rst_n           = 1'b1;
    in_valid        = 1'b0;
    total_latency   = 0;
    golden_out_1    = 0;
    golden_out_2    = 0;

    force clk = 0;

    // Apply reset
    #CYCLE; rst_n = 1'b0; 
    #CYCLE; rst_n = 1'b1;
    // Check initial conditions
    if (out_1 !== 'b0 || out_2 !== 'b0) begin
        $display("************************************************************");  
        $display("                          FAIL!                           ");    
        $display("*  Output signals should be 0 after initial RESET at %8t *", $time);
        $display("************************************************************");
        repeat (2) #CYCLE;
        $finish;
    end
    #CYCLE; release clk;
end endtask


// Task to handle input
task input_task; begin
    repeat (5) @(negedge clk);
    a = $fscanf(f_in, "%s", in_1);
    a = $fscanf(f_in, "%s", in_2);
        
    in_valid = 1'b1;
    for(i = 0 ; i <  ; i = i + 1) begin
        a = $fscanf(f_in_1, "%h", in_1_reg);
        a = $fscanf(f_in_2, "%h", in_2_reg);

        in_1 = in_1_reg;
        in_2 = in_2_reg;
        
        @(negedge clk);
        in_1    = 'bx;
        in_2    = 'bx;
    end
    in_valid = 1'b0;
end endtask


// Task to wait until out_valid is high
task wait_out_valid_task; begin
    latency = 0;
    while (out_valid !== 1'b1) begin
        latency = latency + 1;
        if (latency == `MAX_LATENCY) begin
            $display("********************************************************");     
            $display("                          FAIL!                           ");
            $display("*  The execution latency exceeded %d cycles at %8t   *", `MAX_LATENCY, $time);
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
    // Initialize output count
    out_num = 0;
    
    a = $fscanf(f_out_1, "%s", golden_result1);
    a = $fscanf(f_out_2, "%s", golden_result2);
    
    // Only perform checks when out_valid is high
    while (out_valid === 1) begin
        a = $fscanf(f_out_1, "%s", golden_result1);
        a = $fscanf(f_out_2, "%s", golden_result2);

        // Compare expected and received values
        if (out_1 !== golden_result1 || out_2 !== golden_result2) begin
            $display("************************************************************");  
            $display("                          FAIL!                           ");
            $display(" Expected:  = %d, = %d", golden_result1, golden_result2);
            $display(" Received:  = %d, = %d", out_1, out_2);
            $display("************************************************************");
            repeat (9) @(negedge clk);
            $finish;
        end else begin
            @(negedge clk);
            out_num = out_num + 1;
        end
    end

    // Check if the number of outputs matches the expected count
    if(out_num !== `OUT_NUM) begin
        $display("************************************************************");  
        $display("                          FAIL!                              ");
        $display(" Expected one valid output, but found %d", out_num);
        $display("************************************************************");
        repeat(9) @(negedge clk);
        $finish;
    end
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
