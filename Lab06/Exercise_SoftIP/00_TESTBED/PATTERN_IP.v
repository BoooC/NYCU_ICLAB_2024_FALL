`define PAT_NUM 1000

module PATTERN #(parameter IP_BIT = 11)(
    //Output Port
    IN_code,
    //Input Port
	OUT_code
);
// ========================================
// Input & Output
// ========================================
output reg [IP_BIT+4-1:0] IN_code;

input [IP_BIT-1:0] OUT_code;

integer patnum = `PAT_NUM;
integer i, i_pat;
integer a;
integer f_in, f_out;

reg [IP_BIT-1:0] golden_result;

initial begin
    f_in  = $fopen("../00_TESTBED/input.txt", "r");
    f_out = $fopen("../00_TESTBED/output.txt", "r");
    if (f_in == 0)  begin $display("Failed to open input.txt");  $finish; end
    if (f_out == 0) begin $display("Failed to open output.txt"); $finish; end
end

initial begin
    for (i_pat = 0; i_pat < patnum; i_pat = i_pat + 1) begin
        input_task;
        wait_out_valid_task;
        check_ans_task;
        $display("\033[0;32mPASS PATTERN NO.%4d\033[m", i_pat);
    end
    YOU_PASS_task;
end

task input_task; begin
    a = $fscanf(f_in, "%b", IN_code);
end endtask

task check_ans_task; begin
    a = $fscanf(f_out, "%b", golden_result);
    if (OUT_code !== golden_result) begin
        $display("************************************************************");  
        $display("                          FAIL!                           ");
        $display(" Expected: %h", golden_result);
        $display(" Received: %h", OUT_code);
        $display("************************************************************");
        #20; $finish;
    end 
    #20;
end endtask

task wait_out_valid_task; begin
    #5;
end endtask

task YOU_PASS_task; begin
    $display("----------------------------------------------------------------------------------------------------------------------");
    $display("                                                  Congratulations!                                                    ");
    $display("                                           You have passed all patterns!                                               ");
    $display("----------------------------------------------------------------------------------------------------------------------");
    #10;
    $finish;
end endtask

endmodule
