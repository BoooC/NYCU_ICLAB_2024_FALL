module Program(input clk, INF.Program_inf inf);
import usertype::*;


typedef enum logic [2:0] {
    IDLE        = 'd0,
    DIN         = 'd1,
    CAL         = 'd2,
    DOUT        = 'd3
} state_type;

state_type state, next_state;

Action action_reg;
Formula_Type formula_reg;
Mode mode_reg;
Date date_reg;
Data_No data_no_reg;
Index index_a_reg, index_b_reg, index_c_reg, index_d_reg;
Data_Dir dram_in, dram_out;

//==================================================================
// reg
//==================================================================
// registers
logic [63:0] dram_buffer;
logic [2:0] index_count;
logic [3:0] formula_count; // check index counter
logic [2:0] update_count; // update counter

logic wait_resp;
logic r_shake_reg;
logic read_dram_done;

// pipelined regs
logic [12:0] add_reg_0, add_reg_1;

logic [11:0] max_reg_0, max_reg_1, max_reg_2;
logic [11:0] min_reg_0, min_reg_1, min_reg_2;

logic [12:0] diff_index_a, diff_index_b, diff_index_c, diff_index_d;

logic [11:0] G_stage_1_max_0, G_stage_1_max_1, G_stage_1_min_0, G_stage_1_min_1;
logic [11:0] G_stage_2_max, G_stage_2_min;

logic [11:0] G_max_reg_0, G_max_reg_1;
logic [11:0] G_min_reg_0, G_min_reg_1;
logic [11:0] G_sort_1, G_sort_2, G_sort_3, G_sort_4;

logic [12:0] G_add_reg_0;
logic [13:0] G_add_reg_1;
logic [13:0] G_add_reg_2;

logic div_out_valid;
logic [11:0] div_out;

logic [10:0] G_weighted_add_reg;
logic [11:0] G_weighted_add_reg_2;

logic [11:0] formula_result;

logic [11:0] G_A, G_B, G_C, G_D;

logic [11:0] Threshold_value;
logic risk_result;

logic signed [13:0] new_index_A, new_index_B, new_index_C, new_index_D;

//==================================================================
// Wires
//==================================================================
// DRAM control
logic start_read;
logic [16:0] read_addr;
assign read_addr  = 17'h10000 + (data_no_reg << 3);

// AXI-4 handshake
logic ar_shake, r_shake, aw_shake, w_shake, b_shake;
assign ar_shake = inf.AR_VALID & inf.AR_READY;
assign r_shake  = inf.R_VALID  & inf.R_READY;
assign aw_shake = inf.AW_VALID & inf.AW_READY;
assign w_shake  = inf.W_VALID  & inf.W_READY;
assign b_shake  = inf.B_VALID  & inf.B_READY;

// warning determine
logic overflow_flag;
logic input_before_dram;
assign overflow_flag    = new_index_A[12] | new_index_B[12] | new_index_C[12] | new_index_D[12];
assign input_before_dram= (date_reg.M < dram_in.M) | ((date_reg.M == dram_in.M) & (date_reg.D < dram_in.D));

logic date_Warn_flag, data_Warn_flag, risk_Warn_flag;
assign date_Warn_flag   = input_before_dram & action_reg != Update & read_dram_done;
assign data_Warn_flag   = overflow_flag & action_reg == Update;
assign risk_Warn_flag   = risk_result & action_reg == Index_Check;

// process done
logic index_count_done, formula_count_done, update_count_done;
logic formula_done, dram_write_done, date_check_done;
assign date_check_done   = r_shake_reg & action_reg == Check_Valid_Date;
assign formula_done      = formula_count_done  & action_reg == Index_Check;

// FSM control
logic din_done;
logic cal_done;
assign din_done = (action_reg == Check_Valid_Date) ? inf.date_valid : (inf.index_valid & index_count == 'd3);
assign cal_done = date_Warn_flag | formula_done | dram_write_done | w_shake | date_check_done;

//==================================================================
// FSM
//==================================================================
// next state logic
always_comb begin
    case (state)
        IDLE        : next_state = inf.sel_action_valid ? DIN   : IDLE;
        DIN         : next_state = din_done             ? CAL   : DIN;
        CAL         : next_state = cal_done             ? DOUT  : CAL;
        DOUT        : next_state = IDLE;
        default     : next_state = IDLE;
    endcase
end

// FSM
always_ff @(posedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) begin
        state <= IDLE;
    end
    else begin
        state <= next_state;
    end
end

//==================================================================
// input Regs
//==================================================================
always_ff @(posedge clk) begin
    if (inf.sel_action_valid) begin
        action_reg <= inf.D.d_act[0];
    end
end

always_ff @(posedge clk) begin
    if (inf.formula_valid) begin
        formula_reg <= inf.D.d_formula[0];
    end
end

always_ff @(posedge clk) begin
    if (inf.mode_valid) begin
        mode_reg <= inf.D.d_mode[0];
    end
end

always_ff @(posedge clk) begin
    if (inf.date_valid) begin
        date_reg.M <= inf.D.d_date[0][8:5];
        date_reg.D <= inf.D.d_date[0][4:0];
    end
end

always_ff @(posedge clk) begin
    if (inf.data_no_valid) begin
        data_no_reg <= inf.D.d_data_no[0];
    end
end

always_ff @(posedge clk) begin
    if (inf.index_valid) begin
        index_d_reg <= inf.D.d_index[0];
        index_c_reg <= index_d_reg;
        index_b_reg <= index_c_reg;
        index_a_reg <= index_b_reg;
    end
end

//==================================================================
// DRAM control
//==================================================================
always_ff @(posedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) begin
        start_read <= 1'b0;
    end 
    else if (inf.data_no_valid) begin
        start_read <= 1'b1;
    end 
    else if (!wait_resp) begin
        start_read <= 1'b0;
    end
end

always_ff @(posedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) begin
        wait_resp <= 1'b0;
    end
    else if (w_shake) begin
        wait_resp <= 1'b1;
    end
    else if (b_shake) begin
        wait_resp <= 1'b0;
    end
end

always_ff @(posedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) begin
        r_shake_reg <= 1'b0;
    end 
    else begin
        r_shake_reg <= r_shake;
    end
end

always_ff @(posedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) begin
        read_dram_done <= 'd0;
    end
    else if (state == DOUT) begin
        read_dram_done <= 1'b0;
    end
    else if (r_shake) begin
        read_dram_done <= 1'b1;
    end
end

always_ff @(posedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) begin
        dram_write_done <= 1'b0;
    end
    else if (w_shake) begin
        dram_write_done <= 1'b1;
    end
    else if (state == DOUT) begin
        dram_write_done <= 1'b0;
    end
end

//==================================================================
// AXI-4 Lite process
//==================================================================
// DRAM address read
always_ff @(posedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) begin
        inf.AR_VALID <= 1'b0;
    end 
    else if (ar_shake) begin
        inf.AR_VALID <= 1'b0;
    end
    else if (!wait_resp & start_read) begin
        inf.AR_VALID <= 1'b1;
    end 
end

always_ff @(posedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) begin
        inf.AR_ADDR <= 'd0;
    end 
    else if (ar_shake) begin
        inf.AR_ADDR <= 'd0;
    end
    else if (!wait_resp & start_read) begin
        inf.AR_ADDR <= read_addr;
    end
end

// DRAM data read
always_ff @(posedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) begin
        inf.R_READY <= 1'b0;
    end
    else if (ar_shake) begin
        inf.R_READY <= 1'b1;
    end
    else if (r_shake) begin
        inf.R_READY <= 1'b0;
    end
end

always_ff @(posedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) begin
        dram_buffer <= 'd0;
    end
    else if (r_shake) begin
        dram_buffer <= inf.R_DATA;
    end 
end

// DRAM address write
always_ff @(posedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) begin
        inf.AW_VALID <= 1'b0;
    end 
    else if (aw_shake) begin
        inf.AW_VALID <= 1'b0;
    end 
    else if (r_shake & action_reg == Update) begin
        inf.AW_VALID <= 1'b1;
    end
end

always_ff @(posedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) begin
        inf.AW_ADDR <= 'd0;
    end 
    else begin
        inf.AW_ADDR <= read_addr;
    end
end

// DRAM data write
always_ff @(posedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) begin
        inf.W_VALID <= 1'b0;
    end
    else if (w_shake) begin
        inf.W_VALID <= 1'b0;
    end
    else if (update_count_done) begin
        inf.W_VALID <= 1'b1;
    end
end

always_ff @(posedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) begin
        inf.W_DATA <= 'd0;
    end
    else begin
        inf.W_DATA <= {dram_out.Index_A, dram_out.Index_B, 4'd0, dram_out.M, dram_out.Index_C, dram_out.Index_D, 3'd0, dram_out.D};
    end
end

// DRAM write response
always_ff @(posedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) begin
        inf.B_READY <= 1'b0;
    end
    else if (b_shake) begin
        inf.B_READY <= 1'b0;
    end
    else if (aw_shake) begin
        inf.B_READY <= 1'b1;
    end
end

//==================================================================
// pipelined formula calculation
//==================================================================
// dram out decode
always_comb begin
    dram_in.Index_A = dram_buffer[63:52];
    dram_in.Index_B = dram_buffer[51:40];
    dram_in.M       = dram_buffer[39:32];
    dram_in.Index_C = dram_buffer[31:20];
    dram_in.Index_D = dram_buffer[19:8];
    dram_in.D       = dram_buffer[7:0];
end

// Update
always_ff @(posedge clk) begin
    new_index_A <= $signed({1'b0, dram_in.Index_A}) + $signed(index_a_reg);
    new_index_B <= $signed({1'b0, dram_in.Index_B}) + $signed(index_b_reg);
    new_index_C <= $signed({1'b0, dram_in.Index_C}) + $signed(index_c_reg);
    new_index_D <= $signed({1'b0, dram_in.Index_D}) + $signed(index_d_reg);
end

always_comb begin
    dram_out.D       = date_reg.D;
    dram_out.Index_D = (new_index_D > 'd4095) ? 'd4095 : (new_index_D < 'd0) ? 'd0 : new_index_D[11:0];
    dram_out.Index_C = (new_index_C > 'd4095) ? 'd4095 : (new_index_C < 'd0) ? 'd0 : new_index_C[11:0];
    dram_out.M       = date_reg.M;
    dram_out.Index_B = (new_index_B > 'd4095) ? 'd4095 : (new_index_B < 'd0) ? 'd0 : new_index_B[11:0];
    dram_out.Index_A = (new_index_A > 'd4095) ? 'd4095 : (new_index_A < 'd0) ? 'd0 : new_index_A[11:0];
end

// Formula A
logic [13:0] sum;
always_ff @(posedge clk) begin
    add_reg_0 <= dram_in.Index_C + dram_in.Index_D;
    add_reg_1 <= dram_in.Index_A + dram_in.Index_B;
end

always_ff @(posedge clk) begin
    sum <= add_reg_0 + add_reg_1;
end

// Sort : I(A) ~ I(D)
logic A_gt_B, C_gt_D;
logic max_1_gt_max_0, min_1_lt_min_0;
always_ff @(posedge clk) begin
    A_gt_B <= dram_in.Index_A > dram_in.Index_B;
    C_gt_D <= dram_in.Index_C > dram_in.Index_D;
end

always_ff @(posedge clk) begin
    max_1_gt_max_0 <= max_reg_1 > max_reg_0;
    min_1_lt_min_0 <= min_reg_1 < min_reg_0;
end

always_ff @(posedge clk) begin
    max_reg_0 <= C_gt_D  ? dram_in.Index_C : dram_in.Index_D;
    min_reg_0 <= !C_gt_D ? dram_in.Index_C : dram_in.Index_D;
    max_reg_1 <= A_gt_B  ? dram_in.Index_A : dram_in.Index_B;
    min_reg_1 <= !A_gt_B ? dram_in.Index_A : dram_in.Index_B;
    max_reg_2 <= max_1_gt_max_0 ? max_reg_1 : max_reg_0;
    min_reg_2 <= min_1_lt_min_0 ? min_reg_1 : min_reg_0;
end

// Formula B
logic [11:0] diff_max_min;
always_ff @(posedge clk) begin
    diff_max_min = max_reg_2 - min_reg_2;
end

// Compute GA ~ GD
always_ff @(posedge clk) begin
    diff_index_a <= index_a_reg - dram_in.Index_A;
    diff_index_b <= index_b_reg - dram_in.Index_B;
    diff_index_c <= index_c_reg - dram_in.Index_C;
    diff_index_d <= index_d_reg - dram_in.Index_D;
end

always_ff @(posedge clk) begin
    G_A <= diff_index_a[12] ? (~diff_index_a + 'd1) : diff_index_a;
    G_B <= diff_index_b[12] ? (~diff_index_b + 'd1) : diff_index_b;
    G_C <= diff_index_c[12] ? (~diff_index_c + 'd1) : diff_index_c;
    G_D <= diff_index_d[12] ? (~diff_index_d + 'd1) : diff_index_d;
end

// Sort : GA ~ GD
logic GA_gt_GB, GC_gt_GD;
logic G_1_max_0_gt_G_1_max_1_gt;
logic G_1_min_0_gt_G_1_min_1_gt;
always_ff @(posedge clk) begin
    GA_gt_GB <= G_A > G_B;
    GC_gt_GD <= G_C > G_D;
end
always_ff @(posedge clk) begin
    G_1_max_0_gt_G_1_max_1_gt <= G_stage_1_max_0 > G_stage_1_max_1;
    G_1_min_0_gt_G_1_min_1_gt <= G_stage_1_min_0 > G_stage_1_min_1;
end

always_ff @(posedge clk) begin
    G_stage_1_max_0 <= GA_gt_GB ? G_A : G_B;
    G_stage_1_min_0 <= !GA_gt_GB ? G_A : G_B;
    G_stage_1_max_1 <= GC_gt_GD ? G_C : G_D;
    G_stage_1_min_1 <= !GC_gt_GD ? G_C : G_D;
    G_stage_2_max   <= (G_stage_1_max_0 < G_stage_1_max_1) ? G_stage_1_max_0 : G_stage_1_max_1;
    G_stage_2_min   <= (G_stage_1_min_0 < G_stage_1_min_1) ? G_stage_1_min_1 : G_stage_1_min_0;
    G_sort_1 <= G_1_max_0_gt_G_1_max_1_gt ? G_stage_1_max_0 : G_stage_1_max_1;
    G_sort_4 <= G_1_min_0_gt_G_1_min_1_gt ? G_stage_1_min_1 : G_stage_1_min_0;
    G_sort_2 <= G_stage_2_max;
    G_sort_3 <= G_stage_2_min;
end

always_ff @(posedge clk) begin
    G_add_reg_0 <= G_sort_4 + G_sort_3;
    G_add_reg_1 <= G_add_reg_0 + G_sort_2; // G(A) + G(B) + G(C)
    G_add_reg_2 <= G_add_reg_1 + G_sort_1; // G(A) + G(B) + G(C) + G(D)
end

always_ff @(posedge clk) begin
    G_weighted_add_reg <= (G_sort_2 >> 2) + (G_sort_3 >> 2);        // N1/4 + N2/4
    G_weighted_add_reg_2 <= G_weighted_add_reg + (G_sort_4 >> 1);   // N+/2 + N1/4 + N2/4
end

always_ff @(posedge clk) begin
    case(formula_reg)
        Formula_A : formula_result <= sum >> 2;
        Formula_B : formula_result <= diff_max_min;
        Formula_C : formula_result <= min_reg_2;
        Formula_D : formula_result <= (dram_in.Index_A[11] | (&dram_in.Index_A[10:0])) + (dram_in.Index_B[11] | (&dram_in.Index_B[10:0])) + (dram_in.Index_C[11] | (&dram_in.Index_C[10:0])) + (dram_in.Index_D[11] | (&dram_in.Index_D[10:0]));// (dram_in.Index_A >= 'd2047) + (dram_in.Index_B >= 'd2047) + (dram_in.Index_C >= 'd2047) + (dram_in.Index_D >= 'd2047);
        Formula_E : formula_result <= diff_index_a[12] + diff_index_b[12] + diff_index_c[12] + diff_index_d[12];// (dram_in.Index_A >= index_a_reg) + (dram_in.Index_B >= index_b_reg) + (dram_in.Index_C >= index_c_reg) + (dram_in.Index_D >= index_d_reg);
        Formula_F : formula_result <= div_out; // G_add_reg_1 / 'd3;
        Formula_G : formula_result <= G_weighted_add_reg_2;
        Formula_H : formula_result <= G_add_reg_2 >> 2;
        default   : formula_result <= 'd0;
    endcase
end

// Determine threshold
always_ff @(posedge clk) begin
    case(formula_reg)
        Formula_A, Formula_C : begin
            case(mode_reg)
                Insensitive : Threshold_value <= 'd2047;
                Normal      : Threshold_value <= 'd1023;
                Sensitive   : Threshold_value <= 'd511;
            endcase
        end
        Formula_B, Formula_F, Formula_G, Formula_H : begin
            case(mode_reg)
                Insensitive : Threshold_value <= 'd800;
                Normal      : Threshold_value <= 'd400;
                Sensitive   : Threshold_value <= 'd200;
            endcase
        end
        Formula_D, Formula_E : begin
            case(mode_reg)
                Insensitive : Threshold_value <= 'd3;
                Normal      : Threshold_value <= 'd2;
                Sensitive   : Threshold_value <= 'd1;
            endcase
        end
        default : Threshold_value <= 'd0;
    endcase
end

// Determine risk flag
always_ff @(posedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) begin
        risk_result <= 'd0;
    end
    else begin
        risk_result <= formula_result >= Threshold_value;
    end
end

//==================================================================
// Counter
//==================================================================
always_ff @(posedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) begin
        index_count <= 'd0;
    end
    else if (inf.index_valid) begin
        index_count <= index_count_done ? 'd4 : (index_count + 'd1);
    end
    else if (state == DOUT) begin
        index_count <= 'd0;
    end
end

always_ff @(posedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) begin
        formula_count <= 'd0;
    end
    else if (state == DOUT) begin
        formula_count <= 'd0;
    end
    else if (read_dram_done & index_count_done) begin
        formula_count <= formula_count_done ? formula_count : (formula_count + 'd1);
    end
end

always_ff @(posedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) begin
        update_count <= 'd0;
    end
    else if (w_shake | state == DOUT) begin
        update_count <= 'd0;
    end
    else if (read_dram_done & index_count_done & action_reg == Update) begin
        update_count <= update_count_done ? update_count : (update_count + 'd1);
    end
end

assign index_count_done  = index_count  == 'd4;
assign update_count_done = update_count == 'd2;
always_comb begin
    case(formula_reg)
        Formula_A : formula_count_done = formula_count == 'd3;
        Formula_B : formula_count_done = formula_count == 'd10;
        Formula_C : formula_count_done = formula_count == 'd9;
        Formula_D : formula_count_done = formula_count == 'd1;
        Formula_E : formula_count_done = formula_count == 'd3;
        Formula_F : formula_count_done = div_out_valid;
        Formula_G : formula_count_done = formula_count == 'd11;
        Formula_H : formula_count_done = formula_count == 'd10;
        default   : formula_count_done = 'd0;
    endcase
end

//==================================================================
// Output
//==================================================================
always_ff @(posedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) begin
        inf.out_valid <= 1'b0;
    end
    else if (state == DOUT) begin
        inf.out_valid <= 1'b1;
    end
    else begin
        inf.out_valid <= 1'b0;
    end
end

always_ff @(posedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) begin
        inf.warn_msg <= No_Warn;
    end
    else if (state == DOUT) begin
        if (date_Warn_flag) begin
            inf.warn_msg <= Date_Warn;
        end
        else if (data_Warn_flag) begin
            inf.warn_msg <= Data_Warn;
        end
        else if (risk_Warn_flag) begin
            inf.warn_msg <= Risk_Warn;
        end
        else begin
            inf.warn_msg <= No_Warn;
        end
    end
    else begin
        inf.warn_msg <= No_Warn;
    end
end

always_ff @(posedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) begin
        inf.complete <= 1'b0;
    end
    else if (state == DOUT) begin
        inf.complete <= !(date_Warn_flag | data_Warn_flag | risk_Warn_flag);
    end
    else begin
        inf.complete <= 1'b0;
    end
end


// divided_by_3 divided_by_3_inst (
//     .clk        (clk),
//     .rst_n      (inf.rst_n),
//     .start      (formula_count == 'd10 & formula_reg == Formula_F),
//     .dividend   (G_add_reg_1),
//     .valid      (div_out_valid),
//     .result     (div_out)
// );

shift_divided_by_3 shift_divided_by_3_inst (
    .clk        (clk),
    .rst_n      (inf.rst_n),
    .in_valid   (formula_count == 'd10 & formula_reg == Formula_F),
    .data_in    (G_add_reg_1),
    .out_valid  (div_out_valid),
    .quotient   (div_out)
);

endmodule


module shift_divided_by_3 (
    input  clk,
    input  rst_n,
    input  in_valid,
    input  [13:0] data_in,
    output reg out_valid,
    output reg [11:0] quotient
);

localparam IDLE = 2'b11;

reg [1:0] state, next_state;
reg [3:0] count;
reg [13:0] data_reg;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= IDLE;
    end 
    else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        IDLE : next_state = in_valid ? 2'b00 : IDLE;
        2'b00: next_state = (count == 'd14) ? IDLE : data_reg[13] ? 2'b01 : 2'b00;
        2'b01: next_state = (count == 'd14) ? IDLE : data_reg[13] ? 2'b00 : 2'b10;
        2'b10: next_state = (count == 'd14) ? IDLE : data_reg[13] ? 2'b10 : 2'b01;
        default: next_state = IDLE;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 'd0;
    end 
    else if(state == IDLE) begin
        count <= 'd0;
    end
    else begin
        count <= count + 'd1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_reg <= 'd0;
    end 
    else if(state == IDLE & in_valid) begin
        data_reg <= data_in;
    end
    else if(count != 13) begin
        data_reg <= {data_reg[12:0], 1'b0};
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        quotient <= 'd0;
    end 
    else begin
        case(state)
            2'b00, 2'b01, 2'b10: begin
                if(data_reg[13])
                    quotient <= {quotient[10:0], state[1] | state[0]};
                else
                    quotient <= {quotient[10:0], state[1]};
            end
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out_valid <= 1'b0;
    end 
    else if(state == IDLE) begin
        out_valid <= 1'b0;
    end
    else if(count == 'd14) begin
        out_valid <= 1'b1;
    end
    else begin
        out_valid <= 1'b0;
    end
end

endmodule



module divided_by_3 (
    input clk,
    input rst_n,
    input start,
    input  [13:0] dividend,
    output valid,
    output [11:0] result
);

reg [13:0] quo;
reg [14:0] acc;
reg [3:0] idx;
reg busy;

// accumulation
wire [14:0] sub_acc;
wire [13:0] next_quo;
wire [14:0] next_acc;

assign sub_acc = acc - 'd3;
assign {next_acc, next_quo} = (acc >= 'd3) ? {sub_acc, quo, 1'b1} : ({acc, quo} << 1'b1);

// output
assign valid = idx == 'd14;
assign result = next_quo;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        busy <= 1'b0;
    end
    else if (start) begin
        busy <= 1'b1;
    end 
    else if (valid) begin
        busy <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        idx <= 'd0;
    end
    else if (valid | start) begin
        idx <= 'd0;
    end 
    else if (busy) begin
        idx <= idx + 'd1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        acc <= 'd0;
        quo <= 'd0;
    end
    else if (valid) begin
        acc <= 'd0;
        quo <= 'd0;
    end 
    else if (start) begin
        {acc, quo} <= {14'd0, dividend, 1'b0};
    end 
    else if (busy) begin
        {acc, quo} <= {next_acc, next_quo};
    end
end

endmodule

