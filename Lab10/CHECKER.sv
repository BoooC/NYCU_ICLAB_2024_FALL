/*
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
NYCU Institute of Electronic
2023 Autumn IC Design Laboratory 
Lab10: SystemVerilog Coverage & Assertion
File Name   : CHECKER.sv
Module Name : CHECKER
Release version : v1.0 (Release Date: Nov-2023)
Author : Jui-Huang Tsai (erictsai.10@nycu.edu.tw)
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/

`include "Usertype.sv"
module Checker(input clk, INF.CHECKER inf);
import usertype::*;

class Formula_and_mode;
    Formula_Type f_type;
    Mode f_mode;
endclass

Formula_and_mode fm_info = new();

always_comb begin
    if(inf.formula_valid)
        fm_info.f_type = inf.D.d_formula[0];
    if(inf.mode_valid)
        fm_info.f_mode = inf.D.d_mode[0];
end

// At least number
parameter   FORMULA_NUM     = 150;
parameter   MODE_NUM        = 150;
parameter   WARN_NUM        = 50;
parameter   ACTION_NUM      = 300;
parameter   INDEX_NUM       = 1;
parameter   AUTO_BIN_MAX    = 32;

//================================================================
// Coverage SPEC
//================================================================
// Each case of Formula_Type should be select at least 150 times.
covergroup SPEC1 @(posedge clk iff (inf.formula_valid));
    option.per_instance = 1;
    option.at_least = FORMULA_NUM;
    coverpoint fm_info.f_type {
        bins b_formula_type[] = {[Formula_A : Formula_H]};
    }
endgroup

// Each case of Mode should be select at least 150 times.
covergroup SPEC2 @(posedge clk iff (inf.mode_valid));
    option.per_instance = 1;
    option.at_least = MODE_NUM;
    coverpoint fm_info.f_mode {
        bins b_mode[] = {[Insensitive : Sensitive]};
    }
endgroup

// Create a cross bin for the SPEC1 and SPEC2. Each combination should be selected at least 150 times. (Formula_A,B,C,D,E,F,G,H) x (Insensitive, Normal, Sensitive)
covergroup SPEC3 @(posedge clk iff (inf.mode_valid));
    option.per_instance = 1;
    option.at_least = MODE_NUM;
    cross fm_info.f_type, fm_info.f_mode;
endgroup

// Output signal inf.warn_msg should be “No_Warn”, “Date_Warn”, “Data_Warn“,”Risk_Warn, each at least 50 times. (Sample the value when inf.out_valid is high)
covergroup SPEC4 @(posedge clk iff (inf.out_valid));
    option.per_instance = 1;
    option.at_least = WARN_NUM;
    coverpoint inf.warn_msg{
        bins b_warn_msg [] = {[No_Warn : Data_Warn]};
    }
endgroup

// Create the transitions bin for the inf.D.act[0] signal from [Index_Check:Check_Valid_Date] to [Index_Check:Check_Valid_Date]. Each transition should be hit at least 300 times. (sample the value at posedge clk iff inf.sel_action_valid) 
covergroup SPEC5 @(posedge clk iff (inf.sel_action_valid));
    option.per_instance = 1;
    option.at_least = ACTION_NUM;
    coverpoint inf.D.d_act[0]{
        bins b_act [] = ([Index_Check:Check_Valid_Date] => [Index_Check:Check_Valid_Date]);
    }
endgroup

// Create a covergroup for variation of Update action with auto_bin_max = 32, and each bin have to hit at least one time. 
covergroup SPEC6 @(posedge clk iff (inf.index_valid));
    option.per_instance = 1;
    option.at_least = 1;
    coverpoint inf.D.d_index[0]{
        option.auto_bin_max = AUTO_BIN_MAX;
    }
endgroup

SPEC1 cov_spec1 = new();
SPEC2 cov_spec2 = new();
SPEC3 cov_spec3 = new();
SPEC4 cov_spec4 = new();
SPEC5 cov_spec5 = new();
SPEC6 cov_spec6 = new();

//================================================================
// ASSERTION
//================================================================
// Assertion 1. All outputs signals (Program.sv) should be zero after reset.
property ASSERT_1; @(posedge inf.rst_n) 1 |-> @(posedge clk) 
    (inf.out_valid === 0 & inf.complete === 0 & inf.warn_msg  === 0 &
    inf.AR_VALID   === 0 & inf.AR_ADDR  === 0 & 
    inf.AW_VALID   === 0 & inf.AW_ADDR  === 0 &
    inf.R_READY    === 0 & 
    inf.W_VALID    === 0 & inf.W_DATA   === 0 &
    inf.B_READY    === 0);
endproperty

// Assertion 2. Latency should be less than 1000 cycles for each operation.
property ASSERT_2_Index_Check;
    @(posedge clk) (inf.sel_action_valid === 1 & inf.D.d_act[0] === Index_Check) ##[1:4] inf.formula_valid ##[1:4] inf.mode_valid ##[1:4] inf.date_valid ##[1:4] inf.data_no_valid |-> ##[1:999] inf.out_valid;
endproperty

property ASSERT_2_Update;
    @(posedge clk) (inf.sel_action_valid === 1 & inf.D.d_act[0] === Update) ##[1:4] inf.date_valid ##[1:4] inf.data_no_valid ##[1:4] (inf.index_valid[->4]) |-> ##[1:999] inf.out_valid;
endproperty

property ASSERT_2_Check_Valid_Date;
    @(posedge clk) (inf.sel_action_valid === 1 & inf.D.d_act[0] === Check_Valid_Date) ##[1:4] inf.date_valid ##[1:4] inf.data_no_valid |-> ##[1:999] inf.out_valid;
endproperty

// Assertion 3. If action is completed (complete=1), warn_msg should be 2’b0 (No_Warn).
property ASSERT_3;
    @(negedge clk) ((inf.out_valid !== 0) & (inf.complete === 1)) |-> inf.warn_msg === No_Warn; 
endproperty

// Assertion 4. Next input valid will be valid 1-4 cycles after previous input valid fall. 
property ASSERT_4_Index_Check;
    @(posedge clk) (inf.sel_action_valid === 1 & inf.D.d_act[0] === Index_Check) |-> ##[1:4] inf.formula_valid  ##[1:4] inf.mode_valid  ##[1:4] inf.date_valid  ##[1:4] inf.data_no_valid; 
endproperty

property ASSERT_4_Update;
    @(posedge clk) (inf.sel_action_valid === 1 & inf.D.d_act[0] === Update) |-> ##[1:4] inf.date_valid ##[1:4] inf.data_no_valid ##[1:4] inf.index_valid ##[1:4] inf.index_valid ##[1:4] inf.index_valid ##[1:4] inf.index_valid; 
endproperty

property ASSERT_4_Check_Valid_Date;
    @(posedge clk) (inf.sel_action_valid === 1 & inf.D.d_act[0] === Check_Valid_Date) |-> ##[1:4] inf.date_valid ##[1:4] inf.data_no_valid; 
endproperty

// Assertion 5. All input valid signals won’t overlap with each other.
property ASSERT_5_action;
    @(posedge clk) (inf.sel_action_valid === 1) |-> !(inf.formula_valid || inf.mode_valid || inf.date_valid || inf.data_no_valid || inf.index_valid); 
endproperty

property ASSERT_5_formula;
    @(posedge clk) (inf.formula_valid === 1) |-> !(inf.sel_action_valid || inf.mode_valid || inf.date_valid || inf.data_no_valid || inf.index_valid); 
endproperty

property ASSERT_5_mode;
    @(posedge clk) (inf.mode_valid === 1) |-> !(inf.formula_valid || inf.sel_action_valid || inf.date_valid || inf.data_no_valid || inf.index_valid); 
endproperty

property ASSERT_5_date;
    @(posedge clk) (inf.date_valid === 1) |-> !(inf.formula_valid || inf.mode_valid || inf.sel_action_valid || inf.data_no_valid || inf.index_valid); 
endproperty

property ASSERT_5_data_no;
    @(posedge clk) (inf.data_no_valid === 1) |-> !(inf.formula_valid || inf.mode_valid || inf.date_valid || inf.sel_action_valid || inf.index_valid); 
endproperty

property ASSERT_5_index;
    @(posedge clk) (inf.index_valid === 1) |-> !(inf.formula_valid || inf.mode_valid || inf.date_valid || inf.data_no_valid || inf.sel_action_valid); 
endproperty

// Assertion 6. Out_valid can only be high for exactly one cycle.
property ASSERT_6;
    @(posedge clk) (inf.out_valid !== 0) |=> !inf.out_valid; 
endproperty

// Assertion 7. Next operation will be valid 1-4 cycles after out_valid fall.
property ASSERT_7;
    @(negedge clk) (inf.out_valid === 1) |=> ##[1:4] inf.sel_action_valid; 
endproperty

// Assertion 8. The input date from pattern should adhere to the real calendar. (ex: 2/29, 3/0, 4/31, 13/1 are illegal cases)  
property ASSERT_8_MONTH;
    @(posedge clk) (inf.date_valid === 1) |-> inf.D.d_date[0].M inside {[1:12]}; 
endproperty

property ASSERT_8_DAY_28;
    @(posedge clk) ((inf.date_valid === 1) & inf.D.d_date[0].M === 2) |-> inf.D.d_date[0].D inside {[1:28]}; 
endproperty

property ASSERT_8_DAY_30;
    @(posedge clk) ((inf.date_valid === 1) & (inf.D.d_date[0].M === 4 || inf.D.d_date[0].M === 6 || inf.D.d_date[0].M === 9 || inf.D.d_date[0].M === 11)) |-> inf.D.d_date[0].D inside {[1:30]}; 
endproperty

property ASSERT_8_DAY_31;
    @(posedge clk) ((inf.date_valid === 1) & (inf.D.d_date[0].M === 1 || inf.D.d_date[0].M === 3 || inf.D.d_date[0].M === 5 || inf.D.d_date[0].M === 7 || inf.D.d_date[0].M === 8 || inf.D.d_date[0].M === 10 || inf.D.d_date[0].M === 12)) |-> inf.D.d_date[0].D inside {[1:31]}; 
endproperty

// Assertion 9. The AR_VALID signal should not overlap with the AW_VALID signal. 
property ASSERT_9;
    @(posedge clk) (inf.AR_VALID === 1) |-> !(inf.AW_VALID);
endproperty

// display
reg[9*8:1] txt_red_prefix = "\033[0;31m";
reg[9*8:1] reset_color    = "\033[1;0m";
assert property(ASSERT_1)                   else begin $display("%0s", txt_red_prefix); $display(" Assertion 1 is violated "); $display("%0s", reset_color); $fatal; end
assert property(ASSERT_2_Index_Check)       else begin $display("%0s", txt_red_prefix); $display(" Assertion 2 is violated "); $display("%0s", reset_color); $fatal; end
assert property(ASSERT_2_Update)            else begin $display("%0s", txt_red_prefix); $display(" Assertion 2 is violated "); $display("%0s", reset_color); $fatal; end
assert property(ASSERT_2_Check_Valid_Date)  else begin $display("%0s", txt_red_prefix); $display(" Assertion 2 is violated "); $display("%0s", reset_color); $fatal; end
assert property(ASSERT_3)                   else begin $display("%0s", txt_red_prefix); $display(" Assertion 3 is violated "); $display("%0s", reset_color); $fatal; end
assert property(ASSERT_4_Index_Check)       else begin $display("%0s", txt_red_prefix); $display(" Assertion 4 is violated "); $display("%0s", reset_color); $fatal; end
assert property(ASSERT_4_Update)            else begin $display("%0s", txt_red_prefix); $display(" Assertion 4 is violated "); $display("%0s", reset_color); $fatal; end
assert property(ASSERT_4_Check_Valid_Date)  else begin $display("%0s", txt_red_prefix); $display(" Assertion 4 is violated "); $display("%0s", reset_color); $fatal; end
assert property(ASSERT_5_action)            else begin $display("%0s", txt_red_prefix); $display(" Assertion 5 is violated "); $display("%0s", reset_color); $fatal; end
assert property(ASSERT_5_formula)           else begin $display("%0s", txt_red_prefix); $display(" Assertion 5 is violated "); $display("%0s", reset_color); $fatal; end
assert property(ASSERT_5_mode)              else begin $display("%0s", txt_red_prefix); $display(" Assertion 5 is violated "); $display("%0s", reset_color); $fatal; end
assert property(ASSERT_5_date)              else begin $display("%0s", txt_red_prefix); $display(" Assertion 5 is violated "); $display("%0s", reset_color); $fatal; end
assert property(ASSERT_5_data_no)           else begin $display("%0s", txt_red_prefix); $display(" Assertion 5 is violated "); $display("%0s", reset_color); $fatal; end
assert property(ASSERT_5_index)             else begin $display("%0s", txt_red_prefix); $display(" Assertion 5 is violated "); $display("%0s", reset_color); $fatal; end
assert property(ASSERT_6)                   else begin $display("%0s", txt_red_prefix); $display(" Assertion 6 is violated "); $display("%0s", reset_color); $fatal; end
assert property(ASSERT_7)                   else begin $display("%0s", txt_red_prefix); $display(" Assertion 7 is violated "); $display("%0s", reset_color); $fatal; end
assert property(ASSERT_8_MONTH)             else begin $display("%0s", txt_red_prefix); $display(" Assertion 8 is violated "); $display("%0s", reset_color); $fatal; end
assert property(ASSERT_8_DAY_28)            else begin $display("%0s", txt_red_prefix); $display(" Assertion 8 is violated "); $display("%0s", reset_color); $fatal; end
assert property(ASSERT_8_DAY_30)            else begin $display("%0s", txt_red_prefix); $display(" Assertion 8 is violated "); $display("%0s", reset_color); $fatal; end
assert property(ASSERT_8_DAY_31)            else begin $display("%0s", txt_red_prefix); $display(" Assertion 8 is violated "); $display("%0s", reset_color); $fatal; end
assert property(ASSERT_9)                   else begin $display("%0s", txt_red_prefix); $display(" Assertion 9 is violated "); $display("%0s", reset_color); $fatal; end

endmodule
