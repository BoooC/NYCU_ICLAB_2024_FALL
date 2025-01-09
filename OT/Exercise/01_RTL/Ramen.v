module Ramen(
    // Input Registers
    input clk, 
    input rst_n, 
    input in_valid,
    input selling,
    input portion, 
    input [1:0] ramen_type,

    // Output Signals
    output reg out_valid_order,
    output reg success,

    output reg out_valid_tot,
    output reg [27:0] sold_num,
    output reg [14:0] total_gain
);


//==============================================//
//             Parameter and Integer            //
//==============================================//

// ramen_type
parameter TONKOTSU = 0;
parameter TONKOTSU_SOY = 1;
parameter MISO = 2;
parameter MISO_SOY = 3;

// initial ingredient
parameter NOODLE_INIT = 12000;
parameter BROTH_INIT = 41000;
parameter TONKOTSU_SOUP_INIT =  9000;
parameter MISO_INIT = 1000;
parameter SOY_SAUSE_INIT = 1500;

localparam IDLE = 'd0;
localparam DIN  = 'd1;
localparam CAL  = 'd2;
localparam DOUT = 'd3;

//==============================================//
//                 reg declaration              //
//==============================================// 
reg [1:0] state, next_state;

// input reg
reg [1:0] ramen_type_reg;
reg portion_reg;

// ramen count
reg [6:0] T_count;
reg [6:0] TS_count;
reg [6:0] M_count;
reg [6:0] MS_count;

// current ingredient
reg [15:0] cur_noodle;
reg [15:0] cur_broth;
reg [15:0] cur_t_soup;
reg [15:0] cur_miso;
reg [15:0] cur_sause;

// dly
reg portion_lack_flag, portion_lack_flag_reg;
reg selling_reg;

// control
wire cal_done = 1'b1;
wire pat_done = selling_reg & ~selling;

//==============================================//
//                    Design                    //
//==============================================//
// next state logic
always @(*) begin
    case(state)
        IDLE    : next_state = in_valid ? DIN : IDLE;
        DIN     : next_state = CAL;
        CAL     : next_state = cal_done ? DOUT : CAL;
        DOUT    : next_state = IDLE;
        default : next_state = IDLE;
    endcase
end

// FSM
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= IDLE;
    end
    else begin
        state <= next_state;
    end
end

// imput reg
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ramen_type_reg <= 'd0;
    end
    else if(in_valid & state == IDLE) begin
        ramen_type_reg <= ramen_type;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        portion_reg <= 'd0;
    end
    else if(in_valid & state == DIN) begin
        portion_reg <= portion;
    end
end

// determine ingredient is enough
always @(*) begin
    case(ramen_type_reg)
        TONKOTSU    : portion_lack_flag = portion_reg ? (cur_noodle < 'd150 | cur_broth  < 'd500 | cur_t_soup < 'd200) : 
                                                        (cur_noodle < 'd100 | cur_broth  < 'd300 | cur_t_soup < 'd150);
        TONKOTSU_SOY: portion_lack_flag = portion_reg ? (cur_noodle < 'd150 | cur_broth  < 'd650 | cur_t_soup < 'd150 | cur_sause  < 'd50) : 
                                                        (cur_noodle < 'd100 | cur_broth  < 'd300 | cur_t_soup < 'd100 | cur_sause  < 'd30);
        MISO        : portion_lack_flag = portion_reg ? (cur_noodle < 'd150 | cur_broth  < 'd650 | cur_miso   < 'd50) : 
                                                        (cur_noodle < 'd100 | cur_broth  < 'd400 | cur_miso   < 'd30);
        MISO_SOY    : portion_lack_flag = portion_reg ? (cur_noodle < 'd150 | cur_broth  < 'd500 | cur_t_soup < 'd100 | cur_sause  < 'd25 | cur_miso   < 'd25) : 
                                                        (cur_noodle < 'd100 | cur_broth  < 'd300 | cur_t_soup < 'd70  | cur_sause  < 'd15 | cur_miso   < 'd15);
        default     : portion_lack_flag = 1'b0;
    endcase
end

// ramen count
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        T_count     <= 'd0;
        TS_count    <= 'd0;
        M_count     <= 'd0;
        MS_count    <= 'd0;
    end
    else if(state == CAL & ~portion_lack_flag) begin
        T_count     <= (ramen_type_reg == TONKOTSU)     ? (T_count  + 'd1) : T_count;
        TS_count    <= (ramen_type_reg == TONKOTSU_SOY) ? (TS_count + 'd1) : TS_count;
        M_count     <= (ramen_type_reg == MISO)         ? (M_count  + 'd1) : M_count;
        MS_count    <= (ramen_type_reg == MISO_SOY)     ? (MS_count + 'd1) : MS_count;
    end
    else if (~selling_reg) begin
        T_count     <= 'd0;
        TS_count    <= 'd0;
        M_count     <= 'd0;
        MS_count    <= 'd0;
    end
end

// current ingredient
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cur_noodle  <= NOODLE_INIT;
        cur_broth   <= BROTH_INIT;
        cur_t_soup  <= TONKOTSU_SOUP_INIT;
        cur_miso    <= MISO_INIT;
        cur_sause   <= SOY_SAUSE_INIT;
    end
    else if(state == CAL) begin
        case(ramen_type_reg)
            TONKOTSU : begin
                cur_noodle  <= portion_lack_flag ? cur_noodle : portion_reg ? (cur_noodle- 'd150) : (cur_noodle- 'd100);
                cur_broth   <= portion_lack_flag ? cur_broth  : portion_reg ? (cur_broth - 'd500) : (cur_broth - 'd300);
                cur_t_soup  <= portion_lack_flag ? cur_t_soup : portion_reg ? (cur_t_soup- 'd200) : (cur_t_soup- 'd150);
                cur_sause   <= cur_sause;
                cur_miso    <= cur_miso;
            end
            TONKOTSU_SOY : begin
                cur_noodle  <= portion_lack_flag ? cur_noodle : portion_reg ? (cur_noodle- 'd150) : (cur_noodle- 'd100);
                cur_broth   <= portion_lack_flag ? cur_broth  : portion_reg ? (cur_broth - 'd500) : (cur_broth - 'd300);
                cur_t_soup  <= portion_lack_flag ? cur_t_soup : portion_reg ? (cur_t_soup- 'd150) : (cur_t_soup- 'd100);
                cur_sause   <= portion_lack_flag ? cur_sause  : portion_reg ? (cur_sause - 'd50)  : (cur_sause - 'd30);
                cur_miso    <= cur_miso;
            end
            MISO : begin
                cur_noodle  <= portion_lack_flag ? cur_noodle : portion_reg ? (cur_noodle- 'd150) : (cur_noodle- 'd100);
                cur_broth   <= portion_lack_flag ? cur_broth  : portion_reg ? (cur_broth - 'd650) : (cur_broth - 'd400);
                cur_t_soup  <= cur_t_soup;
                cur_sause   <= cur_sause;
                cur_miso    <= portion_lack_flag ? cur_miso   : portion_reg ? (cur_miso - 'd50)  : (cur_miso - 'd30);
            end
            MISO_SOY : begin
                cur_noodle  <= portion_lack_flag ? cur_noodle : portion_reg ? (cur_noodle- 'd150) : (cur_noodle- 'd100);
                cur_broth   <= portion_lack_flag ? cur_broth  : portion_reg ? (cur_broth - 'd500) : (cur_broth - 'd300);
                cur_t_soup  <= portion_lack_flag ? cur_t_soup : portion_reg ? (cur_t_soup- 'd100) : (cur_t_soup- 'd70);
                cur_sause   <= portion_lack_flag ? cur_sause  : portion_reg ? (cur_sause - 'd25)  : (cur_sause - 'd15);
                cur_miso    <= portion_lack_flag ? cur_miso   : portion_reg ? (cur_miso - 'd25)   : (cur_miso - 'd15);
            end
        endcase
    end
    else if (~selling) begin
        cur_noodle  <= NOODLE_INIT;
        cur_broth   <= BROTH_INIT;
        cur_t_soup  <= TONKOTSU_SOUP_INIT;
        cur_miso    <= MISO_INIT;
        cur_sause   <= SOY_SAUSE_INIT;
    end
end

// dly
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        portion_lack_flag_reg <= 'd0;
        selling_reg <= 'd0;
    end
    else begin
        portion_lack_flag_reg <= portion_lack_flag;
        selling_reg <= selling;
    end
end

// output
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_valid_order <= 1'b0;
    end
    else if(state == DOUT) begin
        out_valid_order <= 1'b1;
    end
    else begin
        out_valid_order <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        success <= 'd0;
    end
    else if(state == DOUT) begin
        success <= ~portion_lack_flag_reg;
    end
    else begin
        success <= 'd0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_valid_tot   <= 1'b0;
        sold_num        <= 'd0;
        total_gain      <= 'd0; 
    end
    else if(pat_done) begin
        out_valid_tot   <= 1'b1;
        sold_num        <= {T_count, TS_count, M_count, MS_count};
        total_gain      <= T_count * 200 + TS_count * 250 + M_count * 200 + MS_count * 250;
    end
    else begin
        out_valid_tot   <= 1'b0;
        sold_num        <= 'd0;
        total_gain      <= 'd0; 
    end
end

endmodule
