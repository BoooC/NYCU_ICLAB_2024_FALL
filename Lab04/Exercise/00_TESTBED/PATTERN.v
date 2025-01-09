//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2023 Fall
//   Lab04 Exercise		: Convolution Neural Network 
//   Author     		: Yu-Chi Lin (a6121461214.st12@nycu.edu.tw)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : CNN.v
//   Module Name : CNN
//   Release version : V1.0 (Release Date: 2024-10)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

`define CYCLE_TIME      50.0
`define SEED_NUMBER     28825252
`define PATTERN_NUMBER  10000
`define PAT_NUM         3

module PATTERN(
    //Output Port
    clk,
    rst_n,
    in_valid,
    Img,
    Kernel_ch1,
    Kernel_ch2,
	Weight,
    Opt,
    //Input Port
    out_valid,
    out
    );

//---------------------------------------------------------------------
//   PORT DECLARATION          
//---------------------------------------------------------------------
output  reg         clk, rst_n, in_valid;
output  reg [31:0]  Img;
output  reg [31:0]  Kernel_ch1;
output  reg [31:0]  Kernel_ch2;
output  reg [31:0]  Weight;
output  reg         Opt;
input           out_valid;
input   [31:0]  out;

//---------------------------------------------------------------------
//   PARAMETER & INTEGER DECLARATION
//---------------------------------------------------------------------
parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch_type = 0;
parameter inst_arch = 0;

integer patnum = `PAT_NUM;
integer i_pat, a;
integer f_img_in, f_ker_1_in, f_ker_2_in, f_opt_in, f_weight_in, f_out;
integer pat_idx;
integer latency;
integer total_latency;
integer out_num;
integer i;

//---------------------------------------------------------------------
//   REG & WIRE DECLARATION
//---------------------------------------------------------------------
reg [31:0]  f_Img;
reg [31:0]  f_Kernel_ch1;
reg [31:0]  f_Kernel_ch2;
reg [31:0]  f_Weight;
reg         f_Opt;
reg [31:0]  golden_result;



//---------------------------------------------------------------------
//  SIMULATION
//---------------------------------------------------------------------
real CYCLE = `CYCLE_TIME;
always #(CYCLE/2.0) clk = ~clk;

/* Check for invalid overlap */
// SPEC-8
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

// SPEC-7
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


// read input and output file
initial begin
    f_img_in    = $fopen("../00_TESTBED/data/Img.txt", "r");
    f_ker_1_in  = $fopen("../00_TESTBED/data/Kernel_ch1.txt", "r");
    f_ker_2_in  = $fopen("../00_TESTBED/data/Kernel_ch2.txt", "r");
    f_opt_in    = $fopen("../00_TESTBED/data/Opt.txt", "r");
    f_weight_in = $fopen("../00_TESTBED/data/Weight.txt", "r");
    f_out       = $fopen("../00_TESTBED/data/Out.txt", "r");

    if (f_img_in == 0)      begin $display("Failed to open Img.txt");           $finish; end
    if (f_ker_1_in == 0)    begin $display("Failed to open Kernel_ch1.txt");    $finish; end
    if (f_ker_2_in == 0)    begin $display("Failed to open Kernel_ch2.txt");    $finish; end
    if (f_opt_in == 0)      begin $display("Failed to open Opt.txt");           $finish; end
    if (f_weight_in == 0)   begin $display("Failed to open Weight.txt");        $finish; end
    if (f_out == 0)         begin $display("Failed to open Out.txt");           $finish; end
end


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
    golden_result   = 0;

    force clk = 0;

    // Apply reset
    #CYCLE; rst_n = 1'b0; 
    #CYCLE; rst_n = 1'b1;
    // Check initial conditions
    if (out !== 32'b0) begin
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
    // read pattern num
    a = $fscanf(f_img_in,       "%h", pat_idx);
    a = $fscanf(f_ker_1_in,     "%h", pat_idx);
    a = $fscanf(f_ker_2_in,     "%h", pat_idx);
    a = $fscanf(f_opt_in,       "%h", pat_idx);
    a = $fscanf(f_weight_in,    "%h", pat_idx);
    a = $fscanf(f_out,          "%h", pat_idx);
    
    in_valid = 1'b1;
    for(i = 0 ; i < 75 ; i = i + 1) begin
        if(i < 75)  a = $fscanf(f_img_in,   "%h", f_Img);
        if(i < 12)  a = $fscanf(f_ker_1_in, "%h", f_Kernel_ch1);
        if(i < 12)  a = $fscanf(f_ker_2_in, "%h", f_Kernel_ch2);
        if(i == 0)  a = $fscanf(f_opt_in,   "%b", f_Opt);
        if(i < 24)  a = $fscanf(f_weight_in,"%h", f_Weight);

        if(i == 0)  Opt = f_Opt;
        else        Opt = 1'bx;

        if(i < 12)  Kernel_ch1 = f_Kernel_ch1;
        else        Kernel_ch1 = 'bx;

        if(i < 12)  Kernel_ch2 = f_Kernel_ch2;
        else        Kernel_ch2 = 'bx;

        if(i < 24)  Weight = f_Weight;
        else        Weight = 'bx;

        if(i < 75)  Img = f_Img;
        else        Img = 'bx;
        
        @(negedge clk);
        Opt         = 'bx;
        Kernel_ch1  = 'bx;
        Kernel_ch2  = 'bx;
        Weight      = 'bx;
        Img         = 'bx;
    end
    in_valid = 1'b0;
end endtask


// Task to wait until out_valid is high
task wait_out_valid_task; begin
    latency = -1;
    while (out_valid !== 1'b1) begin
        latency = latency + 1;
        if (latency == 200) begin
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
wire [31:0] error_value;
wire [31:0] error_abs = {1'b0, error_value[30:0]};
wire [31:0] max, min;
wire [31:0] NUM_10_M4 = 32'b0_01110001_10001110110111101000000; // 9.46044921875 x 10^(-5)

DW_fp_sub #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
DW_fp_sub_inst_1 ( 
    .a(golden_result), 
    .b(out), 
    .rnd(3'd0), 
    .z(error_value)
);

DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
    U1 ( .a(error_abs), .b(NUM_10_M4), .zctr(1'b1), .z0(max), .z1(min));

task check_ans_task; begin
    out_num = 0;
    // Only perform checks when out_valid is high
    while (out_valid === 1) begin
        a = $fscanf(f_out, "%h", golden_result);
        #1
        if (max !== NUM_10_M4) begin // 0.00001 /////////////
            $display("************************************************************");  
            $display("                          FAIL!                           ");
            $display(" Expected: %h", golden_result);
            $display(" Received: %h", out);
            $display("************************************************************");
            repeat (5) @(negedge clk);
            $finish;
        end else begin
            @(negedge clk);
            out_num = out_num + 1;
        end
    end
    // Check if the number of outputs matches the expected count
    if(out_num !== 3) begin
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
