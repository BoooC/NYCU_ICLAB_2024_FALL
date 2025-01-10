`ifndef SYNTHESIS

//
// This is an automatically generated file from 
// dc_shell Version T-2022.03 -- Feb 22, 2022
//

// For simulation only. Do not modify.
module Program_svsim(input clk, INF.Program_inf inf);


  Program Program( {>>{ clk }}, {>>{ inf.rst_n }}, 
        {>>{ inf.sel_action_valid }}, {>>{ inf.formula_valid }}, 
        {>>{ inf.mode_valid }}, {>>{ inf.date_valid }}, 
        {>>{ inf.data_no_valid }}, {>>{ inf.index_valid }}, {>>{ inf.D }}, 
        {>>{ inf.AR_READY }}, {>>{ inf.R_VALID }}, {>>{ inf.R_RESP }}, 
        {>>{ inf.R_DATA }}, {>>{ inf.AW_READY }}, {>>{ inf.W_READY }}, 
        {>>{ inf.B_VALID }}, {>>{ inf.B_RESP }}, {>>{ inf.out_valid }}, 
        {>>{ inf.warn_msg }}, {>>{ inf.complete }}, {>>{ inf.AR_VALID }}, 
        {>>{ inf.AR_ADDR }}, {>>{ inf.R_READY }}, {>>{ inf.AW_VALID }}, 
        {>>{ inf.AW_ADDR }}, {>>{ inf.W_VALID }}, {>>{ inf.W_DATA }}, 
        {>>{ inf.B_READY }} );
endmodule
`endif
