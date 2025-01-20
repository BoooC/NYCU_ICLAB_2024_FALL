module Program(input clk, INF.Program_inf inf);
import usertype::*;

//==================================================================
// reg
//==================================================================
// state
state_type state, next_state;

// input reg
Action          action_reg;
Formula_Type    formula_reg;
Mode            mode_reg;
Date            date_reg;
Data_No         data_no_reg;
Index           index_a_reg, index_b_reg, index_c_reg, index_d_reg;
Data_Dir        dram_in, dram_out;
logic [63:0]    dram_buffer;

// counter
logic [2:0] index_count;    // input index
logic [4:0] formula_count;  // check index
logic [1:0] update_count;   // update

// control
logic wait_resp;
logic r_shake_reg;
logic read_dram_done;

// sub-module
logic [11:0] add_in_1;
logic [13:0] add_in_2;
logic [13:0] add_out;

logic [11:0] sort_in1, sort_in2, sort_in3, sort_in4;
logic [11:0] sort_out1, sort_out2, sort_out3, sort_out4;

logic div_in_valid;
logic div_out_valid;
logic [11:0] div_out;

// update
logic signed [13:0] new_index_A, new_index_B, new_index_C, new_index_D;

// formula pipelined regs
logic [13:0] add_out_reg;
logic [11:0] diff_max_min;
logic [12:0] diff_index_a, diff_index_b, diff_index_c, diff_index_d;
logic [11:0] G_A, G_B, G_C, G_D;

logic [11:0] formula_result;
logic [11:0] Threshold_value;
logic risk_result;

//==================================================================
// Wire
//==================================================================
// DRAM control
logic start_read;
logic [16:0] read_addr;
//assign read_addr  = 17'h10000 + (data_no_reg << 3);
assign read_addr  = {5'h10, 1'd0, data_no_reg, 3'd0};

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
logic date_Warn_flag, data_Warn_flag, risk_Warn_flag;
assign overflow_flag    = new_index_A[13] | new_index_B[13] | new_index_C[13] | new_index_D[13] | new_index_A[12] | new_index_B[12] | new_index_C[12] | new_index_D[12];
assign input_before_dram= (date_reg.M < dram_in.M) | ((date_reg.M == dram_in.M) & (date_reg.D < dram_in.D));
assign date_Warn_flag   = action_reg != Update      & input_before_dram & read_dram_done;
assign data_Warn_flag   = action_reg == Update      & overflow_flag;
assign risk_Warn_flag   = action_reg == Index_Check & risk_result;

// process done
logic index_count_done;
logic formula_count_done, update_count_done;
logic formula_done, date_check_done;
assign index_count_done  = index_count  == 'd4;
assign update_count_done = update_count == 'd2;
assign date_check_done   = action_reg == Check_Valid_Date   & r_shake_reg;
assign formula_done      = action_reg == Index_Check        & formula_count_done;

// FSM control
logic cal_done;
assign cal_done = formula_done | update_count_done | date_check_done;

//==================================================================
// FSM
//==================================================================
// next state logic
always_comb begin
    case (state)
        IDLE    : next_state = cal_done ? DOUT : IDLE;
        DOUT    : next_state = IDLE;
        default : next_state = IDLE;
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

always_ff @(posedge clk or negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        formula_reg <= 'd0;
    end
    else if (inf.formula_valid) begin
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
    else if (aw_shake) begin
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
    else if (!wait_resp & start_read & action_reg == Update) begin
        inf.AW_VALID <= 1'b1;
    end
end

always_ff @(posedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) begin
        inf.AW_ADDR <= 'd0;
    end 
    else if (!wait_resp & start_read) begin
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

always_ff @(posedge clk) begin
    if (update_count_done) begin
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
    dram_out.M       = date_reg.M;
    dram_out.D       = date_reg.D;
    dram_out.Index_D = new_index_D[13] ? 12'd0 : (new_index_D[12] ? 12'd4095 : new_index_D[11:0]);
    dram_out.Index_C = new_index_C[13] ? 12'd0 : (new_index_C[12] ? 12'd4095 : new_index_C[11:0]);
    dram_out.Index_B = new_index_B[13] ? 12'd0 : (new_index_B[12] ? 12'd4095 : new_index_B[11:0]);
    dram_out.Index_A = new_index_A[13] ? 12'd0 : (new_index_A[12] ? 12'd4095 : new_index_A[11:0]);
end

// pipelined formula
always_ff @(posedge clk or negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        add_in_1 <= 'd0;
        add_in_2 <= 'd0;
    end
    else begin
        case(formula_reg)
            Formula_A : begin
                case(formula_count)
                    'd0 : begin
                        add_in_1 <= dram_in.Index_A;
                        add_in_2 <= dram_in.Index_B;
                    end
                    'd2 : begin
                        add_in_1 <= dram_in.Index_C;
                        add_in_2 <= add_out_reg;
                    end
                    'd4 : begin
                        add_in_1 <= dram_in.Index_D;
                        add_in_2 <= add_out_reg;
                    end
                    default : begin
                        add_in_1 <= 'd0;
                        add_in_2 <= add_out_reg;
                    end
                endcase
            end
            Formula_F : begin
                case(formula_count)
                    'd7 : begin
                        add_in_1 <= sort_out4;
                        add_in_2 <= sort_out3;
                    end
                    'd9 : begin
                        add_in_1 <= sort_out2;
                        add_in_2 <= add_out_reg;
                    end
                    default : begin
                        add_in_1 <= 'd0;
                        add_in_2 <= add_out_reg;
                    end
                endcase
            end
            Formula_G : begin
                case(formula_count)
                    'd7 : begin
                        add_in_1 <= sort_out2 >> 2;
                        add_in_2 <= sort_out3 >> 2;
                    end
                    'd9 : begin
                        add_in_1 <= sort_out4 >> 1;
                        add_in_2 <= add_out_reg;
                    end
                    default : begin
                        add_in_1 <= 'd0;
                        add_in_2 <= add_out_reg;
                    end
                endcase
            end
            Formula_H : begin
                case(formula_count)
                    'd2 : begin
                        add_in_1 <= G_A;
                        add_in_2 <= G_B;
                    end
                    'd4 : begin
                        add_in_1 <= G_C;
                        add_in_2 <= add_out_reg;
                    end
                    'd6 : begin
                        add_in_1 <= G_D;
                        add_in_2 <= add_out_reg;
                    end
                    default : begin
                        add_in_1 <= 'd0;
                        add_in_2 <= add_out_reg;
                    end
                endcase
            end
            default : begin
                add_in_1 <= 'd0;
                add_in_2 <= 'd0;
            end
        endcase
    end
end

always_ff @(posedge clk or negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        add_out_reg <= 'd0;
    end
    else begin
        add_out_reg <= add_out;
    end
end

// Sort : I(A) ~ I(D), G(A) ~ G(B)
always_ff @(posedge clk) begin
    sort_in1 <= (formula_reg == Formula_F | formula_reg == Formula_G) ? G_A : dram_in.Index_A;
    sort_in2 <= (formula_reg == Formula_F | formula_reg == Formula_G) ? G_B : dram_in.Index_B;
    sort_in3 <= (formula_reg == Formula_F | formula_reg == Formula_G) ? G_C : dram_in.Index_C;
    sort_in4 <= (formula_reg == Formula_F | formula_reg == Formula_G) ? G_D : dram_in.Index_D;
end

// Formula B
always_ff @(posedge clk) begin
    diff_max_min = sort_out1 - sort_out4;
end

// Compute GA ~ GD
always_ff @(posedge clk) begin
    diff_index_a <= dram_in.Index_A - index_a_reg;
    diff_index_b <= dram_in.Index_B - index_b_reg;
    diff_index_c <= dram_in.Index_C - index_c_reg;
    diff_index_d <= dram_in.Index_D - index_d_reg;
end

always_ff @(posedge clk) begin
    G_A <= diff_index_a[12] ? (~diff_index_a + 'd1) : diff_index_a;
    G_B <= diff_index_b[12] ? (~diff_index_b + 'd1) : diff_index_b;
    G_C <= diff_index_c[12] ? (~diff_index_c + 'd1) : diff_index_c;
    G_D <= diff_index_d[12] ? (~diff_index_d + 'd1) : diff_index_d;
end

always_ff @(posedge clk) begin
    case(formula_reg)
        Formula_A : formula_result <= add_out_reg >> 2;
        Formula_B : formula_result <= diff_max_min;
        Formula_C : formula_result <= sort_out4;
        Formula_D : formula_result <= (dram_in.Index_A[11] | (&dram_in.Index_A[10:0])) + (dram_in.Index_B[11] | (&dram_in.Index_B[10:0])) + (dram_in.Index_C[11] | (&dram_in.Index_C[10:0])) + (dram_in.Index_D[11] | (&dram_in.Index_D[10:0]));// (dram_in.Index_A >= 'd2047) + (dram_in.Index_B >= 'd2047) + (dram_in.Index_C >= 'd2047) + (dram_in.Index_D >= 'd2047);
        Formula_E : formula_result <= !diff_index_a[12] + !diff_index_b[12] + !diff_index_c[12] + !diff_index_d[12]; // (dram_in.Index_A >= index_a_reg) + (dram_in.Index_B >= index_b_reg) + (dram_in.Index_C >= index_c_reg) + (dram_in.Index_D >= index_d_reg);
        Formula_F : formula_result <= div_out; // add_out_reg / 'd3;
        Formula_G : formula_result <= add_out_reg;
        Formula_H : formula_result <= add_out_reg >> 2;
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
    else if (state == DOUT) begin
        update_count <= 'd0;
    end
    else if (read_dram_done & index_count_done & action_reg == Update) begin
        update_count <= update_count_done ? update_count : (update_count + 'd1);
    end
end

always_comb begin
    case(formula_reg)
        Formula_A : formula_count_done = formula_count == 'd7;
        Formula_B : formula_count_done = formula_count == 'd7;
        Formula_C : formula_count_done = formula_count == 'd6;
        Formula_D : formula_count_done = formula_count == 'd1;
        Formula_E : formula_count_done = formula_count == 'd3;
        Formula_F : formula_count_done = div_out_valid; // formula_count == 'd27;
        Formula_G : formula_count_done = formula_count == 'd12;
        Formula_H : formula_count_done = formula_count == 'd9;
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

assign div_in_valid = formula_count == 'd11 & formula_reg == Formula_F & action_reg == Index_Check;
shift_divided_by_3 shift_divided_by_3_inst (
    .clk        (clk),
    .rst_n      (inf.rst_n),
    .in_valid   (div_in_valid),
    .data_in    (add_out_reg),
    .out_valid  (div_out_valid),
    .quotient   (div_out)
);

adder adder_inst (
	.in_1(add_in_1),
    .in_2(add_in_2),
	.out (add_out)
);

Sort_4 Sort_4_inst (
	.clk    (clk),
	.in_1   (sort_in1), 
    .in_2   (sort_in2), 
    .in_3   (sort_in3), 
    .in_4   (sort_in4),
	.out_1  (sort_out1), 
    .out_2  (sort_out2), 
    .out_3  (sort_out3), 
    .out_4  (sort_out4)
);

endmodule


module adder (
	input  [11:0] in_1,
    input  [13:0] in_2,
	output [13:0] out
);
assign out = in_1 + in_2;
endmodule


module shift_divided_by_3 (
    input  clk,
    input  rst_n,
    input  in_valid,
    input  [13:0] data_in,
    output logic out_valid,
    output logic [11:0] quotient
);

logic [1:0] window;
logic [3:0] count;
logic [13:0] data_reg;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        window <= 2'b11;
    end 
    else begin
        case(window)
            2'b11   : window <= in_valid ? 2'b00 : 2'b11;
            2'b00   : window <= (count == 'd14) ? 2'b11 : data_reg[13] ? 2'b01 : 2'b00;
            2'b01   : window <= (count == 'd14) ? 2'b11 : data_reg[13] ? 2'b00 : 2'b10;
            2'b10   : window <= (count == 'd14) ? 2'b11 : data_reg[13] ? 2'b10 : 2'b01;
            default : window <= 2'b11;
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 'd0;
    end 
    else if(window == 2'b11) begin
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
    else if(window == 2'b11 & in_valid) begin
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
        case(window)
            2'b00, 2'b01, 2'b10: begin
                if(data_reg[13])
                    quotient <= {quotient[10:0], window[1] | window[0]};
                else
                    quotient <= {quotient[10:0], window[1]};
            end
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out_valid <= 1'b0;
    end 
    else if(window == 2'b11) begin
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


module Sort_4 (
	input	clk,
	input  [11:0] in_1, in_2, in_3, in_4,
	output logic [11:0] out_1, out_2, out_3, out_4
);

logic in1_gt_in2, in3_gt_in4;
logic g0_gt_g1_max, g0_lt_g1_min;

logic [11:0] stage_1_max_0, stage_1_min_0;
logic [11:0] stage_1_max_1, stage_1_min_1;

always_ff @(posedge clk) begin
    in1_gt_in2 <= in_1 > in_2;
    in3_gt_in4 <= in_3 > in_4;
end

always_ff @(posedge clk) begin
    g0_gt_g1_max <= stage_1_max_0 > stage_1_max_1;
    g0_lt_g1_min <= stage_1_min_0 < stage_1_min_1;
end

always_ff @(posedge clk) begin
    stage_1_max_0 <=  in1_gt_in2 ? in_1 : in_2;
    stage_1_min_0 <= !in1_gt_in2 ? in_1 : in_2;
    stage_1_max_1 <=  in3_gt_in4 ? in_3 : in_4;
    stage_1_min_1 <= !in3_gt_in4 ? in_3 : in_4;
end

always_ff @(posedge clk) begin
    out_1 <=  g0_gt_g1_max ? stage_1_max_0 : stage_1_max_1;
    out_4 <=  g0_lt_g1_min ? stage_1_min_0 : stage_1_min_1;
    out_2 <= !g0_gt_g1_max ? stage_1_max_0 : stage_1_max_1;
    out_3 <= !g0_lt_g1_min ? stage_1_min_0 : stage_1_min_1;
end

endmodule
