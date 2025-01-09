module BB(
    //Input Ports
    input clk,
    input rst_n,
    input in_valid,
    input [1:0] inning,   // Current inning number
    input half,           // 0: top of the inning, 1: bottom of the inning
    input [2:0] action,   // Action code

    //Output Ports
    output reg out_valid,  // Result output valid
    output reg [7:0] score_A,  // Score of team A (guest team)
    output reg [7:0] score_B,  // Score of team B (home team)
    output reg [1:0] result    // 0: Team A wins, 1: Team B wins, 2: Darw
);

//==============================================//
//             Parameter and Integer            //
//==============================================//
// Action
parameter WALK          = 3'd0;
parameter SINGLE        = 3'd1;
parameter DOUBLE        = 3'd2;
parameter TRIPLE        = 3'd3;
parameter HOME_RUN      = 3'd4;
parameter BUNT          = 3'd5;
parameter GROUND_BALL   = 3'd6;
parameter FLY_BALL      = 3'd7;

//==============================================//
//               reg declaration                //
//==============================================//
reg [1:0] out_count;    // record current out num
reg [2:0] Base;         // 3B, 2B, 1B 
reg [2:0] score_reg;    // for each half
reg [3:0] score_temp;   // for each half
reg final_continue_reg;
reg out_valid_reg;

//==============================================//
//                wire declaration              //
//==============================================//
wire half_finish_wire   = (action == GROUND_BALL & (out_count[1] | (out_count[0] & Base[0]))) | (action == FLY_BALL & out_count[1]);
wire final_half_wire    = (inning == 2'd3) & (half == 1'b1);
wire game_over_wire     = half_finish_wire & final_half_wire;
wire final_continue_wire= (inning == 2'd3) & (half == 1'b0) & half_finish_wire & (score_temp < score_reg); 

//==============================================//
//                  Base state                  //
//==============================================//
always @(posedge clk) begin
    if(~half_finish_wire & in_valid) begin
        case (action)
            WALK        : Base <= ~Base[0]      ? {Base[2], Base[1], 1'b1} : {Base[1], Base[0], 1'b1};
            SINGLE      : Base <= out_count[1]  ? {Base[0], 1'b0,    1'b1} : {Base[1], Base[0], 1'b1};
            DOUBLE      : Base <= out_count[1]  ? {1'b0,    1'b1,    1'b0} : {Base[0], 1'b1,    1'b0};
            TRIPLE      : Base <= {1'b1, 1'b0, 1'b0};
            HOME_RUN    : Base <= {1'b0, 1'b0, 1'b0};
            BUNT        : Base <= {Base[1], Base[0], 1'b0};
            GROUND_BALL : Base <= {Base[1], 1'b0,    1'b0};
            FLY_BALL    : Base <= {1'b0, Base[1], Base[0]};
        endcase
    end
    else begin
        Base <= 3'b000;
    end
end

//==============================================//
//                Number of outs                //
//==============================================//
always @(posedge clk) begin
    if (~half_finish_wire & in_valid) begin
        case(action) 
            GROUND_BALL : begin
                case(out_count)
                    2'd0 : out_count <= Base[0] ? 2'd2 : (out_count + 2'd1);
                    2'd1 : out_count <= out_count + 2'd1;
                endcase
            end
            BUNT, FLY_BALL : out_count <= out_count + 2'd1;
            default : out_count <= out_count;
        endcase
    end
    else begin
        out_count <= 2'd0;
    end
end

//==============================================//
//                     Score                    //
//==============================================//
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        score_temp <= 4'd0;
    end
    else if(out_valid) begin
        score_temp <= 4'd0;
    end
    else if(half_finish_wire) begin
        score_temp[2:0] <= score_reg;
    end
    else if(in_valid & ~final_continue_reg) begin
        case (action)
            WALK        : score_temp[2:0] <= (&Base)      ? 3'd3 : score_temp;
            SINGLE      : score_temp[2:0] <= out_count[1] ? (score_temp + Base[2] + Base[1])           : (score_temp + Base[2]);
            DOUBLE      : score_temp[2:0] <= out_count[1] ? (score_temp + Base[2] + Base[1] + Base[0]) : (score_temp + Base[2] + Base[1]);
            TRIPLE      : score_temp[2:0] <= score_temp + Base[2] + Base[1] + Base[0];
            HOME_RUN    : begin
                score_temp[2:0] <= score_temp + Base[2] + Base[1] + Base[0] + 3'd1;
                score_temp[3]   <= (score_temp[2:0] == 3'b110 & Base[2] & Base[0]) ? 1'b1 : score_temp[3];
            end
            BUNT        : begin 
                score_temp[2:0] <= score_temp + Base[2]; 
                score_temp[3]   <= (score_temp[2:0] == 3'b111 & Base[2]) ? 1'b1 : score_temp[3];
            end
            GROUND_BALL : score_temp[2:0] <= score_temp + Base[2];
            FLY_BALL    : score_temp[2:0] <= score_temp + Base[2];
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        score_reg <= 3'd0;
    end
    else if(half_finish_wire) begin
        score_reg <= score_temp[2:0];
    end
    else if(out_valid) begin
        score_reg <= 3'd0;
    end
end

always @(posedge clk) begin
    if(final_continue_wire | game_over_wire) begin  // final_continue_reg <==> game_over_reg
        final_continue_reg <= 1'b1;
    end
    else if(~in_valid) begin
        final_continue_reg <= 1'b0;
    end
end

always @(posedge clk) begin
    out_valid_reg <= final_continue_reg & ~in_valid; // final_continue_reg <==> game_over_reg
end


//==============================================//
//                Output Block                  //
//==============================================//
// remove output regs
always @(*) begin
    score_A = score_temp;
    score_B = score_reg;
end

always @(*) begin
    case(1)
        (score_temp > score_reg) : result = 2'd0;
        (score_temp < score_reg) : result = 2'd1;
        (score_temp == score_reg): result = {rst_n, 1'b0};
        default : result = 2'd0;
    endcase
end

always @(*) begin
    out_valid = out_valid_reg & rst_n;
end

endmodule
