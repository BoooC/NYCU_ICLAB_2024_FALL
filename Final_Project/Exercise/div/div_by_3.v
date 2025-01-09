
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

