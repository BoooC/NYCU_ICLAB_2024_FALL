`define CYCLE_TIME 10 // Cycle time in nanoseconds
`define PAT_NUM 99    // Number of patterns

module PATTERN(
    // Input Ports
    clk,
    rst_n,
    in_valid,
    inning,
    half,
    action,

    // Output Ports
    out_valid,
    score_A,
    score_B,
    result
);

    // Output Registers
    output reg clk, rst_n, in_valid;
    output reg [1:0] inning; // Indicates the current inning
    output reg half;         // 0: Top half, 1: Bottom half
    output reg [2:0] action; // Action code

    // Input Signals
    input out_valid;
    input [7:0] score_A;
    input [7:0] score_B;
    input [1:0] result; // 0: Team A wins, 1: Team B wins, 2: Draw

    /* Define clock cycle */
    real CYCLE = `CYCLE_TIME;
    always #(CYCLE/2.0) clk = ~clk;

    /* Parameters and Integers */
    integer patnum = `PAT_NUM;
    integer i_pat, a;
    integer f_in, f_out;
    integer latency;
    integer total_latency;

    /* Register Declarations */
    reg [7:0] golden_score_A, golden_score_B;
    reg [1:0] golden_result;

    reg [31:0] action_value; // Increased width to handle larger match numbers if needed
    reg [1:0] current_inning;
    reg current_half;
    integer out_num;

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

    initial begin
        // Open input and output files
        f_in  = $fopen("../00_TESTBED/input.txt", "r");
        // f_in  = $fopen("../00_TESTBED/input_v2.txt", "r");
        if (f_in == 0) begin
            $display("Failed to open input.txt");
            $finish;
        end

        f_out = $fopen("../00_TESTBED/output.txt", "r");
        // f_out = $fopen("../00_TESTBED/output_v2.txt", "r");
        if (f_out == 0) begin
            $display("Failed to open output.txt");
            $finish;
        end
        
        // Initialize signals
        reset_task;

        // Iterate through each pattern
        for (i_pat = 0; i_pat < patnum; i_pat = i_pat + 1) begin
            input_task;
            wait_out_valid_task;
            check_ans_task;
            $display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32mExecution Cycle: %3d, \033[0;33mScore: %d-%d,\033[m %s", i_pat + 1, latency, 
            golden_score_A, golden_score_B, (golden_result == 2'b00) ? "Team A wins" : (golden_result == 2'b01) ? "Team B wins" : "Draw");

        end
        
        // All patterns passed
        YOU_PASS_task;
    end

    // Task to reset the system
    task reset_task; begin 
        rst_n = 1'b1;
        in_valid = 1'b0;
        inning = 2'bxx;
        half = 1'bx;
        action = 3'bxxx;
        total_latency = 0;

        force clk = 0;

        // Apply reset
        #CYCLE; rst_n = 1'b0; 
        #CYCLE; rst_n = 1'b1;
        
        // Check initial conditions
        if (out_valid !== 1'b0 || score_A !== 8'b0 || score_B !== 8'b0 || result !== 2'b00) begin
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
        repeat (10) @(negedge clk);
        while (!$feof(f_in)) begin
            a = $fscanf(f_in, "%s", action_value);
            // $display("action_value = %s", action_value);
            
            // Handle match number lines
            if ((action_value[15:8] == "#" && i_pat < 9) || (action_value[23:16] == "#" && i_pat >= 9)) begin
                // If the line is a match number, skip it
                continue;
            end 
            // Handle bottom half
            else if (action_value[15:8] == "+") begin
                current_half = 1'b1;
                current_inning = action_value[7:0] - "0"; // Set current inning
            end 
            // Handle top half
            else if (action_value[15:8] == "-") begin
                current_half = 1'b0;
                current_inning = action_value[7:0] - "0"; // Set current inning
            end 
            // Handle end of match
            else if (action_value == "===") begin
                // Reset signals and wait
                in_valid = 1'b0;
                inning = 2'bxx;
                half = 1'bx;
                action = 3'bxxx;
                @(negedge clk);
                break;
            end 
            // Handle action codes
            else begin
                // Convert action_value to integer
                action_value = action_value[7:0] - "0"; 
                in_valid = 1'b1;
                inning = current_inning;  // Set current inning
                half = current_half;      // Set half (top/bottom)
                action = action_value;    // Set action code
                @(negedge clk);           // Wait for clock's negative edge
            end
        end

        // Reset signals after processing
        in_valid = 1'b0;
        inning = 2'bxx;
        half = 1'bx;
        action = 3'bxxx;
    end endtask

    // Task to wait until out_valid is high
    task wait_out_valid_task; begin
        latency = 1;
        while (out_valid !== 1'b1) begin
            latency = latency + 1;
            if (latency == 100) begin
                $display("********************************************************");     
                $display("                          FAIL!                           ");
                $display("*  The execution latency exceeded 100 cycles at %8t   *", $time);
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
        reg [31:0] match_id;
        
        // Initialize output count
        out_num = 0;
        
        // Skip match number line
        a = $fscanf(f_out, "%s", match_id);
        
        // Only perform checks when out_valid is high
        while (out_valid === 1) begin
            a = $fscanf(f_out, "%d", golden_score_A);
            a = $fscanf(f_out, "%d", golden_score_B);
            a = $fscanf(f_out, "%d", golden_result);

            // Compare expected and received values
            if (score_A !== golden_score_A || score_B !== golden_score_B || result !== golden_result) begin
                $display("************************************************************");  
                $display("                          FAIL!                           ");
                $display(" Expected: Score_A = %d, Score_B = %d, Result = %d", golden_score_A, golden_score_B, golden_result);
                $display(" Received: Score_A = %d, Score_B = %d, Result = %d", score_A, score_B, result);
                $display("************************************************************");
                repeat (9) @(negedge clk);
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