`define CYCLE_TIME  2.1
`define PAT_NUM     10000
`define SEED        5487
// `include "../00_TESTBED/pseudo_DRAM.sv"
`include "Usertype.sv"

program automatic PATTERN(input clk, INF.PATTERN inf);
import usertype::*;

//---------------------------------------------------------------------
//   PARAMETERS & INTEGER                         
//---------------------------------------------------------------------
parameter DRAM_p_r = "../00_TESTBED/DRAM/dram.dat";

parameter PAT_NUM  = `PAT_NUM;
parameter CLK_TIME = `CYCLE_TIME;

integer N;
integer seed = `SEED;
integer total_lat, lat;
integer i, i_pat;

//---------------------------------------------------------------------
//   LOGIC                         
//---------------------------------------------------------------------	
logic [7:0]  golden_DRAM [((65536+8*256)-1):(65536+0)];  // 256 data

Action       given_action;
Order_Info   given_formula;
Date         given_date;
Data_No      given_data_no;
Index        given_index_A, given_index_B, given_index_C, given_index_D;
Index [11:0] Threshold; // for Index Check
logic signed [13:0] index_A_temp, index_B_temp, index_C_temp, index_D_temp;     // for Update
logic [11:0] golden_result;

// formula
logic [11:0] G_A, G_B, G_C, G_D;
logic [11:0] dram_sorted_1, dram_sorted_2, dram_sorted_3, dram_sorted_4;
logic [11:0] G_sorted_1, G_sorted_2, G_sorted_3, G_sorted_4;

logic [63:0] dram_temp;
Data_Dir     golden_dram;
Warn_Msg     golden_err_msg;
logic        golden_complete;

//---------------------------------------------------------------------
//   CLASS RANDOM                         
//---------------------------------------------------------------------
class random_action;
	randc Action action;

	function new (int seed);
		this.srandom(seed);
	endfunction

	constraint limit{
        action inside{Index_Check, Update, Check_Valid_Date};
    }
endclass

class random_formula;
    randc Order_Info formula;

	function new (int seed);
		this.srandom(seed);
	endfunction

    constraint limit{
        formula.Mode_O inside{Insensitive, Normal, Sensitive};
        (formula.Mode_O == Insensitive) -> formula.Formula_Type_O inside{Formula_A, Formula_B, Formula_C, Formula_D, Formula_E, Formula_F, Formula_G, Formula_H};
        (formula.Mode_O == Normal)      -> formula.Formula_Type_O inside{Formula_A, Formula_B, Formula_C, Formula_D, Formula_E, Formula_F, Formula_G, Formula_H};
        (formula.Mode_O == Sensitive)   -> formula.Formula_Type_O inside{Formula_A, Formula_B, Formula_C, Formula_D, Formula_E, Formula_F, Formula_G, Formula_H};
    }
endclass

class random_date;
	randc Date date;

	function new (int seed);
		this.srandom(seed);
	endfunction

	constraint limit{
		date.M inside{[1:12]};
        (date.M == 1 | date.M == 3 | date.M == 5 | date.M == 7 | date.M == 8 | date.M == 10 | date.M == 12) -> date.D inside{[1:31]};
		(date.M == 4 | date.M == 6 | date.M == 9 | date.M == 11)                                               -> date.D inside{[1:30]};
		(date.M == 2)                                                                                             -> date.D inside{[1:28]};
	}
endclass

class random_data_no;
	randc Data_No data_no;

	function new (int seed);
		this.srandom(seed);
	endfunction

	constraint limit{
		data_no inside{[0:255]};
	}
endclass

class random_data_index;
	randc Index data_index;

	function new (int seed);
		this.srandom(seed);
	endfunction

	constraint limit{
		data_index inside{[0:4095]};
	}
endclass

random_action       r_action;
random_formula      r_formula;
random_date         r_date;
random_data_no      r_data_no;
random_data_index   r_data_index;

//---------------------------------------------------------------------
//   INITIAL                         
//---------------------------------------------------------------------	
initial begin
    r_action    = new(seed);
    r_formula   = new(seed);
    r_date      = new(seed);
    r_data_no   = new(seed);
    r_data_index= new(seed);

    $readmemh(DRAM_p_r, golden_DRAM);
    reset_signal_task;

    for (i_pat=0; i_pat<PAT_NUM; i_pat++) begin
        input_task;
        wait_out_valid_task;
        check_ans_task;

        total_lat += lat;
		$display("\033[0;34mPASS PATTERN NO.%4d, \033[m \033[0;32m Execution Cycle: %3d\033[m", i_pat, lat);
    end
    YOU_PASS_task;
end

//---------------------------------------------------------------------
//   TASK                         
//---------------------------------------------------------------------	
task reset_signal_task; 
begin 
    inf.rst_n               = 1;
    inf.sel_action_valid    = 0;
	inf.formula_valid       = 0;
	inf.mode_valid          = 0;
	inf.date_valid          = 0;
	inf.data_no_valid       = 0;
	inf.index_valid         = 0;
    inf.D                   = 'bx;
	total_lat               = 0;

    #5;  inf.rst_n = 0; 
    #20; inf.rst_n = 1;
end 
endtask

// ----------------------------------------- input task --------------------------------------- //
task input_task; begin
    repeat($urandom_range(1, 4)) @(negedge clk); //@(negedge clk)

    give_action;

    if(given_action == Index_Check) begin
        give_formula;
        give_date;
        give_data_no;
        give_data_index;
    end
    else if(given_action == Update) begin
        give_date;
        give_data_no;
        give_data_index;
    end
    else begin
        give_date;
        give_data_no;
    end
end 
endtask

task give_action; begin 
    i = r_action.randomize(); given_action = r_action.action;
	inf.sel_action_valid = 1; inf.D.d_act[0] = given_action;
	@(negedge clk); 
	inf.sel_action_valid = 0;inf.D = 'bx;
end endtask


task give_formula; begin 
    i = r_formula.randomize(); given_formula = r_formula.formula;
	
	repeat($urandom_range(0, 3)) @(negedge clk);
	inf.formula_valid = 1; inf.D.d_formula[0] = given_formula.Formula_Type_O;
	@(negedge clk); 
	inf.formula_valid = 0;inf.D = 'bx;

	repeat($urandom_range(0, 3)) @(negedge clk);
	inf.mode_valid = 1; inf.D.d_mode[0] = given_formula.Mode_O;
	@(negedge clk); 
	inf.mode_valid = 0; inf.D = 'bx;
end endtask


task give_date; begin 
    i = r_date.randomize(); given_date = r_date.date;

	repeat($urandom_range(0, 3)) @(negedge clk);
	inf.date_valid = 1; inf.D.d_date[0] = given_date;
	@(negedge clk); 
	inf.date_valid = 0; inf.D = 'bx;
end endtask


task give_data_no; begin 
    i = r_data_no.randomize(); given_data_no = r_data_no.data_no;
	
	repeat($urandom_range(0, 3)) @(negedge clk);
	inf.data_no_valid = 1; inf.D.d_data_no[0] = given_data_no;
	@(negedge clk); 
	inf.data_no_valid = 0; inf.D = 'bx;
end endtask


task give_data_index; begin 
    i = r_data_index.randomize(); given_index_A = r_data_index.data_index;
    i = r_data_index.randomize(); given_index_B = r_data_index.data_index;
    i = r_data_index.randomize(); given_index_C = r_data_index.data_index;
    i = r_data_index.randomize(); given_index_D = r_data_index.data_index;
	
	inf.index_valid = 1; inf.D.d_index[0] = given_index_A;
	@(negedge clk); 
	inf.index_valid = 0; inf.D = 'bx;
	
	repeat($urandom_range(0, 3)) @(negedge clk);
	inf.index_valid = 1; inf.D.d_index[0] = given_index_B;
	@(negedge clk); 
	inf.index_valid = 0; inf.D = 'bx;
	
	repeat($urandom_range(0, 3)) @(negedge clk);
	inf.index_valid = 1; inf.D.d_index[0] = given_index_C;
	@(negedge clk); 
	inf.index_valid = 0; inf.D = 'bx;
		
	repeat($urandom_range(0, 3)) @(negedge clk);
	inf.index_valid = 1; inf.D.d_index[0] = given_index_D;
	@(negedge clk); 
	inf.index_valid = 0; inf.D = 'bx;
end endtask

// ------------------------------------- wait out_valid task ---------------------------------- //
task wait_out_valid_task; begin
    lat = 0;
    while(inf.out_valid !== 1) begin
        lat += 1;
        if(lat === 1000) 
        begin
            $display("--------------------------------------------------------------------------------------------------------------------------------------------");
            $display("                                                             PATTERN NO.%4d 	                                                              ", i_pat);
            $display("                                             The execution latency should not over 1000 cycles                                              ");
            $display("--------------------------------------------------------------------------------------------------------------------------------------------");
            $finish;
        end
        @(negedge clk);
    end
end endtask

// --------------------------------------- check ans task ------------------------------------- //
task check_ans_task; begin
    N = 65536 + 8 * given_data_no;
    dram_temp = {golden_DRAM[N+7], golden_DRAM[N+6], golden_DRAM[N+5], golden_DRAM[N+4], golden_DRAM[N+3], golden_DRAM[N+2], golden_DRAM[N+1], golden_DRAM[N]};

	golden_dram.Index_A = dram_temp[63:52];
	golden_dram.Index_B = dram_temp[51:40];
	golden_dram.M       = dram_temp[39:32];
	golden_dram.Index_C = dram_temp[31:20];
	golden_dram.Index_D = dram_temp[19: 8];
	golden_dram.D       = dram_temp[ 7: 0];

	case(given_action)
		Index_Check     : Index_Check_task;
		Update          : Update_task;
		Check_Valid_Date: check_date_task;
	endcase
end endtask 


task sort4 (
    input logic [11:0] in1, in2, in3, in4,
    output logic [11:0] out1, out2, out3, out4);
    logic [11:0] a, b, c, d;
    
    a = in1;
    b = in2;
    c = in3;
    d = in4;
    
    if (a > b) swap(a, b);
    if (c > d) swap(c, d);
    if (a > c) swap(a, c);
    if (b > d) swap(b, d);
    if (b > c) swap(b, c);
    
    out1 = a;
    out2 = b;
    out3 = c;
    out4 = d;
endtask

task swap(inout logic [11:0] x, inout logic [11:0] y);
  logic [11:0] temp;
  temp = x;
  x = y;
  y = temp;
endtask



task Index_Check_task; begin
    case (given_formula.Formula_Type_O)
        Formula_A : Threshold = (given_formula.Mode_O == Insensitive)? 2047 : ((given_formula.Mode_O == Normal)? 1023 : 511);
        Formula_B : Threshold = (given_formula.Mode_O == Insensitive)? 800  : ((given_formula.Mode_O == Normal)? 400  : 200);
        Formula_C : Threshold = (given_formula.Mode_O == Insensitive)? 2047 : ((given_formula.Mode_O == Normal)? 1023 : 511);
        Formula_D : Threshold = (given_formula.Mode_O == Insensitive)? 3    : ((given_formula.Mode_O == Normal)? 2    : 1);
        Formula_E : Threshold = (given_formula.Mode_O == Insensitive)? 3    : ((given_formula.Mode_O == Normal)? 2    : 1);
        Formula_F : Threshold = (given_formula.Mode_O == Insensitive)? 800  : ((given_formula.Mode_O == Normal)? 400  : 200);
        Formula_G : Threshold = (given_formula.Mode_O == Insensitive)? 800  : ((given_formula.Mode_O == Normal)? 400  : 200);
        Formula_H : Threshold = (given_formula.Mode_O == Insensitive)? 800  : ((given_formula.Mode_O == Normal)? 400  : 200);
    endcase

    // G
    G_A = (golden_dram.Index_A > given_index_A) ? (golden_dram.Index_A - given_index_A) : (given_index_A - golden_dram.Index_A);
    G_B = (golden_dram.Index_B > given_index_B) ? (golden_dram.Index_B - given_index_B) : (given_index_B - golden_dram.Index_B);
    G_C = (golden_dram.Index_C > given_index_C) ? (golden_dram.Index_C - given_index_C) : (given_index_C - golden_dram.Index_C);
    G_D = (golden_dram.Index_D > given_index_D) ? (golden_dram.Index_D - given_index_D) : (given_index_D - golden_dram.Index_D);

    // sort dram
    sort4 (golden_dram.Index_A, golden_dram.Index_B, golden_dram.Index_C, golden_dram.Index_D, dram_sorted_4, dram_sorted_3, dram_sorted_2, dram_sorted_1);
    // sort G
    sort4 (G_A, G_B, G_C, G_D, G_sorted_4, G_sorted_3, G_sorted_2, G_sorted_1);

    case (given_formula.Formula_Type_O)
        Formula_A : golden_result = (golden_dram.Index_A + golden_dram.Index_B + golden_dram.Index_C + golden_dram.Index_D) / 4;
        Formula_B : golden_result = dram_sorted_1 - dram_sorted_4;
        Formula_C : golden_result = dram_sorted_4;
        Formula_D : golden_result = (golden_dram.Index_A >= 2047) + (golden_dram.Index_B >= 2047) + (golden_dram.Index_C >= 2047) + (golden_dram.Index_D >= 2047);
        Formula_E : golden_result = (golden_dram.Index_A >= given_index_A) + (golden_dram.Index_B >= given_index_B) + (golden_dram.Index_C >= given_index_C) + (golden_dram.Index_D >= given_index_D);
        Formula_F : golden_result = (G_sorted_2 + G_sorted_3 + G_sorted_4) / 3;
        Formula_G : golden_result = (G_sorted_4 / 2) + (G_sorted_3 / 4) + (G_sorted_2 / 4);
        Formula_H : golden_result = (G_A + G_B + G_C + G_D) / 4;
    endcase

    if(given_date.M < golden_dram.M | (given_date.M === golden_dram.M && given_date.D < golden_dram.D)) begin
        golden_err_msg = Date_Warn;
    end
    else if(golden_result >= Threshold) begin
        golden_err_msg = Risk_Warn;
    end
    else begin
        golden_err_msg = No_Warn;
    end

    golden_complete = golden_err_msg === No_Warn;

    check_task;
end endtask


task Update_task; begin
    index_A_temp = $signed({1'b0, golden_dram.Index_A}) + $signed(given_index_A);
    index_B_temp = $signed({1'b0, golden_dram.Index_B}) + $signed(given_index_B);
    index_C_temp = $signed({1'b0, golden_dram.Index_C}) + $signed(given_index_C);
    index_D_temp = $signed({1'b0, golden_dram.Index_D}) + $signed(given_index_D);

    if(index_A_temp > 4095 | index_B_temp > 4095 | index_C_temp > 4095 | index_D_temp > 4095 | index_A_temp < 0 | index_B_temp < 0 | index_C_temp < 0 | index_D_temp < 0) begin
       golden_err_msg = Data_Warn;
    end
    else begin
        golden_err_msg = No_Warn;
    end

    golden_complete = golden_err_msg === No_Warn;

    dram_temp[39:32] = given_date.M;
    dram_temp[ 7: 0] = given_date.D;
    dram_temp[63:52] = index_A_temp[13] ? 'd0 : (index_A_temp[12] ? 'd4095 : index_A_temp[11:0]);
    dram_temp[51:40] = index_B_temp[13] ? 'd0 : (index_B_temp[12] ? 'd4095 : index_B_temp[11:0]);   
    dram_temp[31:20] = index_C_temp[13] ? 'd0 : (index_C_temp[12] ? 'd4095 : index_C_temp[11:0]);     
    dram_temp[19: 8] = index_D_temp[13] ? 'd0 : (index_D_temp[12] ? 'd4095 : index_D_temp[11:0]);

    {golden_DRAM[N+7], golden_DRAM[N+6], golden_DRAM[N+5], golden_DRAM[N+4], golden_DRAM[N+3], golden_DRAM[N+2], golden_DRAM[N+1], golden_DRAM[N]} = dram_temp;

    check_task;
end endtask

task check_date_task; begin
    if(given_date.M < golden_dram.M | (given_date.M === golden_dram.M && given_date.D < golden_dram.D)) begin
        golden_err_msg = Date_Warn;
    end
    else begin
        golden_err_msg = No_Warn;
    end

    golden_complete = golden_err_msg === No_Warn;

    check_task;
end endtask

task check_task; begin
    if((inf.warn_msg !== golden_err_msg) | (inf.complete !== golden_complete)) begin
        $display("---------------------------------------------------------------------------------------------------------------------------");
        $display("                                                         PATTERN NO.%4d 	                                                 ", i_pat);
        $display("                                             Golden warn_msg is : %d , complete is : %d                                    ", golden_err_msg, golden_complete);
        $display("                                             Your   warn_msg is : %d , complete is : %d                                    ", inf.warn_msg, inf.complete);
        $display("---------------------------------------------------------------------------------------------------------------------------");
        display_wrong_answer_task;
        $finish;
    end
end endtask

task YOU_PASS_task; begin
    $display("------------------------------------------------------------------------------------------------------------------------------------");
    $display("                                                               \033[0;32mCongratulations\033[m                 						              ");
    $display("                                                         Execution cycles = %5d cycles                                              ", total_lat);
    $display("                                                         Clock period = %.1f ns                                                     ", CLK_TIME);
    $display("                                                         Total Latency = %.1f ns                                                    ", total_lat * CLK_TIME);
    $display("------------------------------------------------------------------------------------------------------------------------------------"); 
    $finish;
end endtask

task display_wrong_answer_task; 
begin
    $display("===================================================");
    $display("                   Wrong Answer                    ");
    $display("===================================================");
    $finish;
end
endtask

endprogram
