`define PAT_NUM         5400
`define RANDOM_SEED     5487
// `include "../00_TESTBED/pseudo_DRAM.sv"
`include "Usertype.sv"

program automatic PATTERN(input clk, INF.PATTERN inf);
import usertype::*;
//================================================================
// parameters & integer
//================================================================
parameter DRAM_p_r = "../00_TESTBED/DRAM/dram.dat";
parameter MAX_CYCLE=1000;
parameter CLK_TIME = 15;

integer SEED = `RANDOM_SEED;
integer addr;
integer total_lat, lat;
integer i, i_pat;

//================================================================
// wire & registers 
//================================================================
logic [7:0] golden_DRAM [((65536+8*256)-1):(65536+0)];  // 32 box

Action          action_reg;
Formula_Type    formula_reg = 7;
Mode            mode_reg = 0;
Date            date_reg;
Data_No         data_no_reg;
Index           index_A_reg, index_B_reg, index_C_reg, index_D_reg;

// index check
Index [11:0] Threshold;
logic [11:0] golden_result;
logic signed [13:0] index_A_temp, index_B_temp, index_C_temp, index_D_temp;

// formula
logic [11:0] G_A, G_B, G_C, G_D;
logic [11:0] dram_sorted_1, dram_sorted_2, dram_sorted_3, dram_sorted_4;
logic [11:0] G_sorted_1, G_sorted_2, G_sorted_3, G_sorted_4;

logic [63:0] dram_temp;
Data_Dir     golden_dram;
Warn_Msg     golden_warn_msg;
logic        golden_complete;
//================================================================
// Gen random class
//================================================================
class random_formula;
    randc int formula_queue;
    constraint formula_constraint{formula_queue inside {[0:23]};}
endclass

class random_date;
	randc Date date;
	function new (int seed);
		this.srandom(seed);
	endfunction
	constraint limit{
		date.M inside{[1:12]};
        (date.M == 1 | date.M == 3 | date.M == 5 | date.M == 7 | date.M == 8 | date.M == 10 | date.M == 12) -> date.D inside{[1:31]};
		(date.M == 4 | date.M == 6 | date.M == 9 | date.M == 11)                                            -> date.D inside{[1:30]};
		(date.M == 2)                                                                                       -> date.D inside{[1:28]};
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

random_formula      rand_formula = new();
random_date         rand_date;
random_data_no      rand_data_no;
random_data_index   rand_data_index;

//================================================================
// Initial setting
//================================================================
initial begin
    $readmemh(DRAM_p_r, golden_DRAM);
end

initial begin
    rand_date      = new(SEED);
    rand_data_no   = new(SEED);
    rand_data_index= new(SEED);
end

initial begin
    reset_signal_task;
    for (i_pat=0; i_pat<`PAT_NUM; i_pat++) begin
        input_task;
        wait_out_valid_task;
        cal_ans_task;
        check_ans_task;
        total_lat = total_lat + lat;
		$display("\033[0;34mPASS PATTERN NO.%4d, \033[m \033[0;32m Execution Cycle: %3d\033[m", i_pat, lat);
    end
    YOU_PASS_task;
end

//================================================================
// Task
//================================================================
task reset_signal_task; begin 
    inf.rst_n               = 'd1;
    inf.sel_action_valid    = 'd0;
	inf.formula_valid       = 'd0;
	inf.mode_valid          = 'd0;
	inf.date_valid          = 'd0;
	inf.data_no_valid       = 'd0;
	inf.index_valid         = 'd0;
    inf.D                   = 'dx;
	total_lat               = 'd0;
    #5;  inf.rst_n = 'd0; 
    #20; inf.rst_n = 'd1;
end endtask


integer formula_count = 0;
integer mode_count = 0;
task input_task; begin
    @(negedge clk)
    // action
    inf.sel_action_valid = 1;
    if(i_pat < 2700) begin 
        case(i_pat % 9)
            0: action_reg = Index_Check;
            1: action_reg = Index_Check;
            2: action_reg = Update;
            3: action_reg = Update;
            4: action_reg = Check_Valid_Date;
            5: action_reg = Check_Valid_Date;
            6: action_reg = Index_Check;
            7: action_reg = Check_Valid_Date;
            8: action_reg = Update;
        endcase
    end
    else begin
        action_reg = Index_Check;
    end
    inf.D.d_act[0] = action_reg;
	@(negedge clk); 
	inf.sel_action_valid = 0; inf.D = 'bx;

    if(action_reg == Index_Check) begin
        i = rand_formula.randomize();
        input_formula;
        input_mode;
        input_date;
        input_data_no;
        input_data_index;
        formula_count = (formula_count == 449) ? 0 : (formula_count + 1);
    end
    else if(action_reg == Update) begin
        input_date;
        input_data_no;
        input_data_index;
    end
    else begin
        input_date;
        input_data_no;
    end
end endtask

//================================================================
// input 
//================================================================
task input_formula; begin 
	inf.formula_valid = 1; 
    formula_reg = (formula_count == 449) ? (formula_reg - 1) : formula_reg;
    inf.D.d_formula[0] = formula_reg;
	@(negedge clk); 
	inf.formula_valid = 0;inf.D = 'bx;
end endtask

task input_mode; begin 
	inf.mode_valid = 1; 
    mode_reg =  (formula_count == 149) ? (mode_reg + 1) : 
                (formula_count == 299) ? (mode_reg + 2) : 
                (formula_count == 449) ? 0 : mode_reg;
    inf.D.d_mode[0] = mode_reg;
	@(negedge clk); 
	inf.mode_valid = 0; inf.D = 'bx;
end endtask

task input_date; begin 
    if(action_reg == Index_Check)   date_reg.M = 5;
    else                            date_reg.M = ({$random(SEED)} % 12) + 1;
    if(action_reg == Index_Check)   date_reg.D = 15;
    else                            date_reg.D = ({$random(SEED)} % 28) + 1;
    //i = rand_date.randomize(); date_reg = rand_date.date;
	inf.date_valid = 1; inf.D.d_date[0] = date_reg;
	@(negedge clk); 
	inf.date_valid = 0; inf.D = 'bx;
end endtask

task input_data_no; begin 
    if(i_pat == 0)  begin
        data_no_reg = 167;
    end
    else if(action_reg == Index_Check & i_pat > 150)  begin
        data_no_reg = 0;
    end
    else if(action_reg == Index_Check) begin
        data_no_reg = 1;
    end
    else begin
        data_no_reg = {$random(SEED)} % 254 + 2;
    end
    //i = rand_data_no.randomize(); data_no_reg = rand_data_no.data_no;
	inf.data_no_valid = 1; inf.D.d_data_no[0] = data_no_reg;
	@(negedge clk); 
	inf.data_no_valid = 0; inf.D = 'bx;
end endtask

task input_data_index; begin
    if(action_reg == Index_Check & i_pat < 150)  begin
        index_A_reg = 'd0;
        index_B_reg = 'd0;
        index_C_reg = 'd0;
        index_D_reg = 'd0;
    end
    else begin
        i = rand_data_index.randomize(); index_A_reg = rand_data_index.data_index;
        i = rand_data_index.randomize(); index_B_reg = rand_data_index.data_index;
        i = rand_data_index.randomize(); index_C_reg = rand_data_index.data_index;
        i = rand_data_index.randomize(); index_D_reg = rand_data_index.data_index;
    end
	
	inf.index_valid = 1; inf.D.d_index[0] = index_A_reg;
	@(negedge clk); 
	inf.index_valid = 0; inf.D = 'bx;
	
	inf.index_valid = 1; inf.D.d_index[0] = index_B_reg;
	@(negedge clk); 
	inf.index_valid = 0; inf.D = 'bx;
	
	inf.index_valid = 1; inf.D.d_index[0] = index_C_reg;
	@(negedge clk); 
	inf.index_valid = 0; inf.D = 'bx;
		
	inf.index_valid = 1; inf.D.d_index[0] = index_D_reg;
	@(negedge clk); 
	inf.index_valid = 0; inf.D = 'bx;
end endtask

//================================================================
// WAIT OUT VALID 
//================================================================
task wait_out_valid_task; begin
    lat = 0;
    while(inf.out_valid !== 1) begin
        lat = lat + 1;
        if(lat === 1000) begin
            $display("--------------------------------------------------------------------------------------------------------------------------------------------");
            $display("                                                             PATTERN NO.%4d 	                                                              ", i_pat);
            $display("                                             The execution latency should not over 1000 cycles                                              ");
            $display("--------------------------------------------------------------------------------------------------------------------------------------------");
            $finish;
        end
        @(negedge clk);
    end
end endtask

//================================================================
// CALCULATE ANSWER 
//================================================================
task cal_ans_task; begin
    addr = 65536 + 8 * data_no_reg;
    dram_temp = {golden_DRAM[addr+7], golden_DRAM[addr+6], golden_DRAM[addr+5], golden_DRAM[addr+4], golden_DRAM[addr+3], golden_DRAM[addr+2], golden_DRAM[addr+1], golden_DRAM[addr]};
	golden_dram.Index_A = dram_temp[63:52];
	golden_dram.Index_B = dram_temp[51:40];
	golden_dram.M       = dram_temp[39:32];
	golden_dram.Index_C = dram_temp[31:20];
	golden_dram.Index_D = dram_temp[19:8];
	golden_dram.D       = dram_temp[7:0];

	case(action_reg)
		Index_Check     : Index_check_ans_task;
		Update          : Update_task;
		Check_Valid_Date: check_date_task;
	endcase
end endtask 

task sort4 (
    input  logic [11:0] in1, in2, in3, in4,
    output logic [11:0] out1, out2, out3, out4);
    logic [11:0] a, b, c, d;

    a = in1; b = in2; c = in3; d = in4;
    if (a > b) swap(a, b);
    if (c > d) swap(c, d);
    if (a > c) swap(a, c);
    if (b > d) swap(b, d);
    if (b > c) swap(b, c);
    out1 = a; out2 = b; out3 = c; out4 = d;
endtask

task swap(
    inout logic [11:0] x, 
    inout logic [11:0] y
);
    logic [11:0] temp;
    temp = x;
    x    = y;
    y    = temp;
endtask

task Index_check_ans_task; begin
    case (formula_reg)
        Formula_A : Threshold = (mode_reg == Insensitive)? 2047 : ((mode_reg == Normal)? 1023 : 511);
        Formula_B : Threshold = (mode_reg == Insensitive)? 800  : ((mode_reg == Normal)? 400  : 200);
        Formula_C : Threshold = (mode_reg == Insensitive)? 2047 : ((mode_reg == Normal)? 1023 : 511);
        Formula_D : Threshold = (mode_reg == Insensitive)? 3    : ((mode_reg == Normal)? 2    : 1);
        Formula_E : Threshold = (mode_reg == Insensitive)? 3    : ((mode_reg == Normal)? 2    : 1);
        Formula_F : Threshold = (mode_reg == Insensitive)? 800  : ((mode_reg == Normal)? 400  : 200);
        Formula_G : Threshold = (mode_reg == Insensitive)? 800  : ((mode_reg == Normal)? 400  : 200);
        Formula_H : Threshold = (mode_reg == Insensitive)? 800  : ((mode_reg == Normal)? 400  : 200);
    endcase

    G_A = (golden_dram.Index_A > index_A_reg) ? (golden_dram.Index_A - index_A_reg) : (index_A_reg - golden_dram.Index_A);
    G_B = (golden_dram.Index_B > index_B_reg) ? (golden_dram.Index_B - index_B_reg) : (index_B_reg - golden_dram.Index_B);
    G_C = (golden_dram.Index_C > index_C_reg) ? (golden_dram.Index_C - index_C_reg) : (index_C_reg - golden_dram.Index_C);
    G_D = (golden_dram.Index_D > index_D_reg) ? (golden_dram.Index_D - index_D_reg) : (index_D_reg - golden_dram.Index_D);

    sort4 (golden_dram.Index_A, golden_dram.Index_B, golden_dram.Index_C, golden_dram.Index_D, dram_sorted_4, dram_sorted_3, dram_sorted_2, dram_sorted_1);
    sort4 (G_A, G_B, G_C, G_D, G_sorted_4, G_sorted_3, G_sorted_2, G_sorted_1);

    case (formula_reg)
        Formula_A : golden_result = (golden_dram.Index_A + golden_dram.Index_B + golden_dram.Index_C + golden_dram.Index_D) / 4;
        Formula_B : golden_result = dram_sorted_1 - dram_sorted_4;
        Formula_C : golden_result = dram_sorted_4;
        Formula_D : golden_result = (golden_dram.Index_A >= 2047) + (golden_dram.Index_B >= 2047) + (golden_dram.Index_C >= 2047) + (golden_dram.Index_D >= 2047);
        Formula_E : golden_result = (golden_dram.Index_A >= index_A_reg) + (golden_dram.Index_B >= index_B_reg) + (golden_dram.Index_C >= index_C_reg) + (golden_dram.Index_D >= index_D_reg);
        Formula_F : golden_result = (G_sorted_2 + G_sorted_3 + G_sorted_4) / 3;
        Formula_G : golden_result = (G_sorted_4 / 2) + (G_sorted_3 / 4) + (G_sorted_2 / 4);
        Formula_H : golden_result = (G_A + G_B + G_C + G_D) / 4;
    endcase

    if(date_reg.M < golden_dram.M | (date_reg.M === golden_dram.M && date_reg.D < golden_dram.D)) begin
        golden_warn_msg = Date_Warn;
    end
    else if(golden_result >= Threshold) begin
        golden_warn_msg = Risk_Warn;
    end
    else begin
        golden_warn_msg = No_Warn;
    end

    golden_complete = golden_warn_msg === No_Warn;
end endtask

task Update_task; begin
    index_A_temp = $signed({1'b0, golden_dram.Index_A}) + $signed(index_A_reg);
    index_B_temp = $signed({1'b0, golden_dram.Index_B}) + $signed(index_B_reg);
    index_C_temp = $signed({1'b0, golden_dram.Index_C}) + $signed(index_C_reg);
    index_D_temp = $signed({1'b0, golden_dram.Index_D}) + $signed(index_D_reg);

    if(index_A_temp > 4095 | index_B_temp > 4095 | index_C_temp > 4095 | index_D_temp > 4095 | index_A_temp < 0 | index_B_temp < 0 | index_C_temp < 0 | index_D_temp < 0) begin
       golden_warn_msg = Data_Warn;
    end
    else begin
        golden_warn_msg = No_Warn;
    end

    golden_complete = golden_warn_msg === No_Warn;

    dram_temp[39:32] = date_reg.M;
    dram_temp[ 7: 0] = date_reg.D;
    dram_temp[63:52] = index_A_temp[13] ? 'd0 : (index_A_temp[12] ? 'd4095 : index_A_temp[11:0]);
    dram_temp[51:40] = index_B_temp[13] ? 'd0 : (index_B_temp[12] ? 'd4095 : index_B_temp[11:0]);   
    dram_temp[31:20] = index_C_temp[13] ? 'd0 : (index_C_temp[12] ? 'd4095 : index_C_temp[11:0]);     
    dram_temp[19: 8] = index_D_temp[13] ? 'd0 : (index_D_temp[12] ? 'd4095 : index_D_temp[11:0]);

    {golden_DRAM[addr+7], golden_DRAM[addr+6], golden_DRAM[addr+5], golden_DRAM[addr+4], golden_DRAM[addr+3], golden_DRAM[addr+2], golden_DRAM[addr+1], golden_DRAM[addr]} = dram_temp;
end endtask

task check_date_task; begin
    if(date_reg.M < golden_dram.M | (date_reg.M === golden_dram.M && date_reg.D < golden_dram.D)) begin
        golden_warn_msg = Date_Warn;
    end
    else begin
        golden_warn_msg = No_Warn;
    end

    golden_complete = golden_warn_msg === No_Warn;
end endtask

//================================================================
// CHECK ANSWER 
//================================================================
task check_ans_task; begin
    if((inf.warn_msg !== golden_warn_msg) | (inf.complete !== golden_complete)) begin
        $display(" \033[0;31m ");
        $display(" Wrong Answer ");
        $display(" \033[m ");
        $finish;
    end
end endtask

task YOU_PASS_task; begin
    $display(" \033[0;32m ");
    $display(" Congratulations ");
    $display(" Execution cycles = %5d cycles ", total_lat);
    $display(" \033[m ");
    $finish;
end endtask

endprogram
