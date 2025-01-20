
module shift_divided_by_3 (
    input  clk,
    input  rst_n,
    input  in_valid,
    input  [13:0] data_in,
    //output reg out_valid,
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
    else if(count != 'd13) begin
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
/*
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
*/

endmodule
