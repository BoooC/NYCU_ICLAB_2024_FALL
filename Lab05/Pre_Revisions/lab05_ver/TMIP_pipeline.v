module TMIP(
    // input signals
    clk,
    rst_n,
    in_valid, 
    in_valid2,
    
    image,
    template,
    image_size,
	action,
	
    // output signals
    out_valid,
    out_value
    );

input            clk, rst_n;
input            in_valid, in_valid2;

input      [7:0] image;
input      [7:0] template;
input      [1:0] image_size;
input      [2:0] action;

output reg       out_valid;
output reg       out_value;

//==================================================================
// parameter & integer
//==================================================================
parameter IMG_SIZE_4    = 2'd0;
parameter IMG_SIZE_8    = 2'd1;
parameter IMG_SIZE_16   = 2'd2;

parameter ACTION_MAX    = 3'd0; // Grayscale Transformation (Max method)
parameter ACTION_AVG    = 3'd1; // Grayscale Transformation (Average method)
parameter ACTION_WGT    = 3'd2; // Grayscale Transformation (Weighted method)
parameter ACTION_POOL   = 3'd3; // Max Pooling
parameter ACTION_NEG    = 3'd4; // Negative
parameter ACTION_HOR    = 3'd5; // Horizontal Flip 
parameter ACTION_FILTER = 3'd6; // Image Filter 
parameter ACTION_CONV   = 3'd7; // Cross Correlation


localparam IDLE     = 'd0;
localparam READ_PAT = 'd1;
localparam WAIT_ACT = 'd2;
localparam READ_ACT = 'd3;
localparam CAL      = 'd4;
localparam PRE_DOUT = 'd5;
localparam DOUT     = 'd6;

integer i;


//==================================================================
// reg & wire
//==================================================================
reg [2:0] state, next_state;

reg [7:0] image_reg     [0:2];
reg [7:0] template_reg  [0:8];
reg [2:0] action_reg    [0:7];
reg [1:0] image_size_reg;

reg in_valid_reg;

reg [7:0] image_size_num;

reg [7:0] gray_max [0:3];
reg [7:0] gray_avg [0:3];
reg [7:0] gray_wgt [0:3];


reg [3:0] template_count;
reg [1:0] RGB_count;
reg [7:0] img_addr;
reg [3:0] action_addr; // 3~8

reg [2:0] set_count;

reg [5:0] sram_img_addr; // 0~63
reg [31:0] SRAM_out_reg, SRAM_out_reg2, SRAM_out_reg3;


reg [19:0] out_reg;

reg RGB_count_done_reg, RGB_count_done_reg2;



reg [19:0] conv_out_reg;
reg [4:0] out_ptr;

reg [4:0] out_count;

reg [31:0] conv_in;
reg conv_in_valid;
wire conv_in_req;

reg [1:0] conv_img_size;
wire [19:0] conv_out;
wire conv_out_valid;
wire conv_out_req = out_count == 'd0;
wire conv_out_done;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_count <= 'd0;
    end
    else if(conv_out_valid | state == PRE_DOUT)begin
        out_count <= (out_count == 'd19) ? 'd0 : (out_count + 'd1);
    end
end

// SRAM
wire [5:0] sram_img_size = (image_size_reg == IMG_SIZE_4) ? 6'd3 : (image_size_reg == IMG_SIZE_8) ? 6'd15 : 6'd63;
wire sram_img_addr_done  = sram_img_addr == sram_img_size;

wire sram_img_write_flag = (RGB_count_done_reg2) & (img_addr[1:0] == 2'b00); // img_addr % 4 == 0


wire [31:0] sram_max_out;
wire [31:0] sram_avg_out;
wire [31:0] sram_wgt_out;


wire RGB_count_done = RGB_count == 2'd2;
wire img_addr_done  = img_addr == image_size_num;


reg [2:0] pre_load_count;



wire [1:0] img_size_out_1, img_size_out_2, img_size_out_3, img_size_out_4, img_size_out_5, img_size_out_6;
wire [31:0] data_out_1, data_out_2, data_out_3, data_out_4, data_out_5, data_out_6;
wire data_out_valid_1, data_out_valid_2, data_out_valid_3, data_out_valid_4, data_out_valid_5, data_out_valid_6;
wire data_out_req_1, data_out_req_2, data_out_req_3, data_out_req4, data_out_req_5, data_out_req_6;
wire data_in_req_1;



// FSM control
wire out_ready = 1'b0;
wire cal_done = 1'b0;
wire dout_done = 1'b0;
wire set_done = set_count == 3'd7;

//==================================================================
// design
//==================================================================
// next state logic
always @(*) begin
    case(state)
        IDLE     : next_state = in_valid        ? READ_PAT  : IDLE;
        READ_PAT : next_state = ~in_valid       ? WAIT_ACT  : READ_PAT;
        WAIT_ACT : next_state = in_valid2       ? READ_ACT  : WAIT_ACT;
        READ_ACT : next_state = ~in_valid2      ? CAL       : READ_ACT;
        CAL      : next_state = conv_out_valid  ? PRE_DOUT  : CAL;
        PRE_DOUT : next_state = conv_out_done   ? DOUT      : PRE_DOUT;
        DOUT     : next_state = set_done        ? IDLE      : WAIT_ACT;
        default  : next_state = IDLE;
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

// input reg
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        image_reg[0] <= 8'd0;
        image_reg[1] <= 8'd0;
        image_reg[2] <= 8'd0;
    end
    else if(in_valid) begin
        image_reg[RGB_count] <= image;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0 ; i < 9 ; i = i + 1) begin
            template_reg[i] <= 8'd0;
        end
    end
    else if(in_valid & template_count < 'd9) begin
        template_reg[template_count] <= template;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0 ; i < 8 ; i = i + 1) begin
            action_reg[i] <= 3'd0;
        end
    end
    else if(in_valid2) begin
        action_reg[action_addr] <= action;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        image_size_reg <= 2'd0;
    end
    else if(in_valid & ~in_valid_reg) begin
        image_size_reg <= image_size;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        in_valid_reg <= 1'b0;
    end
    else begin
        in_valid_reg <= in_valid;
    end
end



always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        image_size_num <= 'd0;
    end
    else if(in_valid & RGB_count == 2'd0 & img_addr == 'd0) begin
        case(image_size)
            IMG_SIZE_4  : image_size_num <= 'd15;
            IMG_SIZE_8  : image_size_num <= 'd63;
            IMG_SIZE_16 : image_size_num <= 'd255;
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        RGB_count_done_reg <= 1'b0;
        RGB_count_done_reg2 <= 1'b0;
    end
    else begin
        RGB_count_done_reg <= RGB_count_done;
        RGB_count_done_reg2 <= RGB_count_done_reg;
    end
end


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0 ; i < 4 ; i = i + 1) begin
            gray_max[i] <= 8'd0;
            gray_avg[i] <= 8'd0;
            gray_wgt[i] <= 8'd0;
        end
    end
    else if(RGB_count_done_reg) begin
        gray_max[img_addr[1:0]] <= (image_reg[0] >= image_reg[1] & image_reg[0] >= image_reg[2]) ? image_reg[0] : 
                                  (image_reg[1] >= image_reg[0] & image_reg[1] >= image_reg[2]) ? image_reg[1] : image_reg[2];
        gray_avg[img_addr[1:0]] <= (image_reg[0] + image_reg[1] + image_reg[2]) / 3;
        gray_wgt[img_addr[1:0]] <= (image_reg[0] >> 2) + (image_reg[1] >> 1) + (image_reg[2] >> 2);
    end
end



// counter
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        RGB_count <= 2'd0;
    end
    else if(in_valid) begin
        RGB_count <= RGB_count_done ? 2'd0 : (RGB_count + 2'd1);
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        img_addr <= 'd0;
    end
    else if(RGB_count_done_reg) begin
        img_addr <= img_addr_done ? 'd0 : (img_addr + 'd1);
    end
end


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        template_count <= 'd0;
    end
    else if(in_valid) begin
        template_count <= (template_count == 'd9) ? 'd9 : (template_count + 'd1);
    end
    else if(state == DOUT) begin
        template_count <= 'd0;
    end
end



always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sram_img_addr <= 6'd0;
    end
    else if(sram_img_write_flag) begin
        sram_img_addr <= sram_img_addr_done ? 6'd0 : (sram_img_addr + 6'd1);
    end
    else if(data_in_req_1 & ) begin
        sram_img_addr <= sram_img_addr_done ? sram_img_size : (sram_img_addr + 6'd1);
    end
end



always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        action_addr <= 'd0;
    end
    else if(in_valid2) begin
        action_addr <= action_addr + 'd1;
    end
    else if(state == DOUT) begin
        action_addr <= 'd0;
    end
end


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        set_count <= 3'd0;
    end
    else if(state == DOUT) begin
        set_count <= (set_count == 3'd7) ? 3'd0 : (set_count + 3'd1);
    end
end

wire sram_out_ready = pre_load_count == 'd2;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        SRAM_out_reg <= 32'd0;
    end
    else if (data_in_req_1) begin
        case(action_reg[0])
            ACTION_MAX : SRAM_out_reg <= sram_max_out;
            ACTION_AVG : SRAM_out_reg <= sram_avg_out;
            ACTION_WGT : SRAM_out_reg <= sram_wgt_out;
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        SRAM_out_reg2 <= 32'd0;
        SRAM_out_reg3 <= 32'd0;
    end
    else if (data_in_req_1) begin
        SRAM_out_reg2 <= SRAM_out_reg;
        SRAM_out_reg3 <= SRAM_out_reg2;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        pre_load_count <= 'd0;
    end
    else if(data_in_req_1) begin
        pre_load_count <= (pre_load_count == 'd2) ? 'd2 : (pre_load_count + 'd1);
    end
end



always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_value <= 'd0;
    end
    else if(state == PRE_DOUT) begin
        out_value <= conv_out_reg[out_ptr];
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_valid <= 1'b0;
    end
    else if(state == PRE_DOUT) begin
        out_valid <= 1'b1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_ptr <= 'd0;
    end
    else if(state == PRE_DOUT) begin
        out_ptr <= (out_ptr == 'd19) ? 'd0 : (out_ptr + 'd1);
    end
end




PE PE_layer_1 (
    .clk            (clk),
    .rst_n          (rst_n),
    .data_in        (SRAM_out_reg),
    .data_in_ready  (sram_out_ready),
    .data_in_req    (data_in_req_1),
    .img_size_in    (image_size_reg),
    .action         (action_reg[1]),
    .img_size_out   (img_size_out_1),
    .data_out       (data_out_1),
    .data_out_ready (data_out_valid_1),
    .data_out_req   (action_addr == 'd3 ? conv_in_req : data_out_req_1)
);

PE PE_layer_2 (
    .clk            (clk),
    .rst_n          (rst_n),
    .data_in        (data_out_1),
    .data_in_ready  (data_out_valid_1),
    .data_in_req    (data_out_req_1),
    .img_size_in    (img_size_out_1),
    .action         (action_reg[2]),
    .img_size_out   (img_size_out_2),
    .data_out       (data_out_2),
    .data_out_ready (data_out_valid_2),
    .data_out_req   (action_addr == 'd4 ? conv_in_req : data_out_req_2)
);

PE PE_layer_3 (
    .clk            (clk),
    .rst_n          (rst_n),
    .data_in        (data_out_2),
    .data_in_ready  (data_out_valid_2),
    .data_in_req    (data_out_req_2),
    .img_size_in    (img_size_out_2),
    .action         (action_reg[3]),
    .img_size_out   (img_size_out_3),
    .data_out       (data_out_3),
    .data_out_ready (data_out_valid_3),
    .data_out_req   (action_addr == 'd5 ? conv_in_req : data_out_req_3)
);

PE PE_layer_4 (
    .clk            (clk),
    .rst_n          (rst_n),
    .data_in        (data_out_3),
    .data_in_ready  (data_out_valid_3),
    .data_in_req    (data_out_req_3),
    .img_size_in    (img_size_out_3),
    .action         (action_reg[4]),
    .img_size_out   (img_size_out_4),
    .data_out       (data_out_4),
    .data_out_ready (data_out_valid_4),
    .data_out_req   (action_addr == 'd6 ? conv_in_req : data_out_req_4)
);

PE PE_layer_5 (
    .clk            (clk),
    .rst_n          (rst_n),
    .data_in        (data_out_4),
    .data_in_ready  (data_out_valid_4),
    .data_in_req    (data_out_req_4),
    .img_size_in    (img_size_out_4),
    .action         (action_reg[5]),
    .img_size_out   (img_size_out_5),
    .data_out       (data_out_5),
    .data_out_ready (data_out_valid_5),
    .data_out_req   (action_addr == 'd7 ? conv_in_req : data_out_req_5)
);

PE PE_layer_6 (
    .clk            (clk),
    .rst_n          (rst_n),
    .data_in        (data_out_5),
    .data_in_ready  (data_out_valid_5),
    .data_in_req    (data_out_req_5),
    .img_size_in    (img_size_out_5),
    .action         (action_reg[6]),
    .img_size_out   (img_size_out_6),
    .data_out       (data_out_6),
    .data_out_ready (data_out_valid_6),
    .data_out_req   (conv_in_req)
);


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        conv_out_reg <= 20'd0;
    end
    else if(conv_out_valid & conv_out_req) begin
        conv_out_reg <= conv_out;
    end
end


always @(*) begin
    case(action_addr)
        'd2 : begin
            conv_in         = SRAM_out_reg;
            conv_in_valid   = sram_out_ready;
            conv_img_size   = image_size_reg;
        end
        'd3 : begin
            conv_in         = data_out_1;
            conv_in_valid   = data_out_valid_1;
            conv_img_size   = img_size_out_1;
        end
        'd4 : begin
            conv_in         = data_out_2;
            conv_in_valid   = data_out_valid_2;
            conv_img_size   = img_size_out_2;
        end
        'd5 : begin
            conv_in         = data_out_3;
            conv_in_valid   = data_out_valid_3;
            conv_img_size   = img_size_out_3;
        end
        'd6 : begin
            conv_in         = data_out_4;
            conv_in_valid   = data_out_valid_4;
            conv_img_size   = img_size_out_4;
        end
        'd7 : begin
            conv_in         = data_out_5;
            conv_in_valid   = data_out_valid_5;
            conv_img_size   = img_size_out_5;
        end
        'd8 : begin
            conv_in         = data_out_6;
            conv_in_valid   = data_out_valid_6;
            conv_img_size   = img_size_out_6;
        end
        default : begin
            conv_in         = 'd0;
            conv_in_valid   = 'd0;
            conv_img_size   = 'd0;
        end
    endcase
end

CONV CONV_0 (
    .clk            (clk),            
    .rst_n          (rst_n),
    .data_in        (conv_in),    
    .data_in_ready  (conv_in_valid),        
    .data_in_req    (conv_in_req),        
    .template_0     (template_reg[0]),    
    .template_1     (template_reg[1]),    
    .template_2     (template_reg[2]),    
    .template_3     (template_reg[3]),    
    .template_4     (template_reg[4]),    
    .template_5     (template_reg[5]),    
    .template_6     (template_reg[6]),    
    .template_7     (template_reg[7]),    
    .template_8     (template_reg[8]),    
    .img_size_in    (conv_img_size),        
    .data_out       (conv_out),    
    .data_out_ready (conv_out_valid),        
    .data_out_req   (conv_out_req),
    .out_done       (conv_out_done)
);



SRAM_IMG SRAM_IMG_MAX (
    .CK(clk), .WEB(~sram_img_write_flag), .OE(1'b1), .CS(1'b1),

    .A0(sram_img_addr[0]), .A1(sram_img_addr[1]), .A2(sram_img_addr[2]), .A3(sram_img_addr[3]), .A4(sram_img_addr[4]), .A5(sram_img_addr[5]),
    
    .DI0 (gray_max[3][0]), .DI1 (gray_max[3][1]), .DI2 (gray_max[3][2]), .DI3 (gray_max[3][3]), .DI4 (gray_max[3][4]), .DI5 (gray_max[3][5]), .DI6 (gray_max[3][6]), .DI7 (gray_max[3][7]), 
    .DI8 (gray_max[2][0]), .DI9 (gray_max[2][1]), .DI10(gray_max[2][2]), .DI11(gray_max[2][3]), .DI12(gray_max[2][4]), .DI13(gray_max[2][5]), .DI14(gray_max[2][6]), .DI15(gray_max[2][7]), 
    .DI16(gray_max[1][0]), .DI17(gray_max[1][1]), .DI18(gray_max[1][2]), .DI19(gray_max[1][3]), .DI20(gray_max[1][4]), .DI21(gray_max[1][5]), .DI22(gray_max[1][6]), .DI23(gray_max[1][7]), 
    .DI24(gray_max[0][0]), .DI25(gray_max[0][1]), .DI26(gray_max[0][2]), .DI27(gray_max[0][3]), .DI28(gray_max[0][4]), .DI29(gray_max[0][5]), .DI30(gray_max[0][6]), .DI31(gray_max[0][7]), 
    
    .DO0 (sram_max_out[0]),  .DO1 (sram_max_out[1]),  .DO2 (sram_max_out[2]),  .DO3 (sram_max_out[3]),  .DO4 (sram_max_out[4]),  .DO5 (sram_max_out[5]),  .DO6 (sram_max_out[6]),  .DO7 (sram_max_out[7]), 
    .DO8 (sram_max_out[8]),  .DO9 (sram_max_out[9]),  .DO10(sram_max_out[10]), .DO11(sram_max_out[11]), .DO12(sram_max_out[12]), .DO13(sram_max_out[13]), .DO14(sram_max_out[14]), .DO15(sram_max_out[15]), 
    .DO16(sram_max_out[16]), .DO17(sram_max_out[17]), .DO18(sram_max_out[18]), .DO19(sram_max_out[19]), .DO20(sram_max_out[20]), .DO21(sram_max_out[21]), .DO22(sram_max_out[22]), .DO23(sram_max_out[23]), 
    .DO24(sram_max_out[24]), .DO25(sram_max_out[25]), .DO26(sram_max_out[26]), .DO27(sram_max_out[27]), .DO28(sram_max_out[28]), .DO29(sram_max_out[29]), .DO30(sram_max_out[30]), .DO31(sram_max_out[31])
);

SRAM_IMG SRAM_IMG_AVG (
    .CK(clk), .WEB(~sram_img_write_flag), .OE(1'b1), .CS(1'b1),
    
    .A0(sram_img_addr[0]), .A1(sram_img_addr[1]), .A2(sram_img_addr[2]), .A3(sram_img_addr[3]), .A4(sram_img_addr[4]), .A5(sram_img_addr[5]),
    
    .DI0 (gray_avg[3][0]), .DI1 (gray_avg[3][1]), .DI2 (gray_avg[3][2]), .DI3 (gray_avg[3][3]), .DI4 (gray_avg[3][4]), .DI5 (gray_avg[3][5]), .DI6 (gray_avg[3][6]), .DI7 (gray_avg[3][7]), 
    .DI8 (gray_avg[2][0]), .DI9 (gray_avg[2][1]), .DI10(gray_avg[2][2]), .DI11(gray_avg[2][3]), .DI12(gray_avg[2][4]), .DI13(gray_avg[2][5]), .DI14(gray_avg[2][6]), .DI15(gray_avg[2][7]), 
    .DI16(gray_avg[1][0]), .DI17(gray_avg[1][1]), .DI18(gray_avg[1][2]), .DI19(gray_avg[1][3]), .DI20(gray_avg[1][4]), .DI21(gray_avg[1][5]), .DI22(gray_avg[1][6]), .DI23(gray_avg[1][7]), 
    .DI24(gray_avg[0][0]), .DI25(gray_avg[0][1]), .DI26(gray_avg[0][2]), .DI27(gray_avg[0][3]), .DI28(gray_avg[0][4]), .DI29(gray_avg[0][5]), .DI30(gray_avg[0][6]), .DI31(gray_avg[0][7]), 
    
    .DO0 (sram_avg_out[0]),  .DO1 (sram_avg_out[1]),  .DO2 (sram_avg_out[2]),  .DO3 (sram_avg_out[3]),  .DO4 (sram_avg_out[4]),  .DO5 (sram_avg_out[5]),  .DO6 (sram_avg_out[6]),  .DO7 (sram_avg_out[7]), 
    .DO8 (sram_avg_out[8]),  .DO9 (sram_avg_out[9]),  .DO10(sram_avg_out[10]), .DO11(sram_avg_out[11]), .DO12(sram_avg_out[12]), .DO13(sram_avg_out[13]), .DO14(sram_avg_out[14]), .DO15(sram_avg_out[15]), 
    .DO16(sram_avg_out[16]), .DO17(sram_avg_out[17]), .DO18(sram_avg_out[18]), .DO19(sram_avg_out[19]), .DO20(sram_avg_out[20]), .DO21(sram_avg_out[21]), .DO22(sram_avg_out[22]), .DO23(sram_avg_out[23]), 
    .DO24(sram_avg_out[24]), .DO25(sram_avg_out[25]), .DO26(sram_avg_out[26]), .DO27(sram_avg_out[27]), .DO28(sram_avg_out[28]), .DO29(sram_avg_out[29]), .DO30(sram_avg_out[30]), .DO31(sram_avg_out[31])
);

SRAM_IMG SRAM_IMG_wgt (
    .CK(clk), .WEB(~sram_img_write_flag), .OE(1'b1), .CS(1'b1),
    
    .A0(sram_img_addr[0]), .A1(sram_img_addr[1]), .A2(sram_img_addr[2]), .A3(sram_img_addr[3]), .A4(sram_img_addr[4]), .A5(sram_img_addr[5]),
    
    .DI0 (gray_wgt[3][0]), .DI1 (gray_wgt[3][1]), .DI2 (gray_wgt[3][2]), .DI3 (gray_wgt[3][3]), .DI4 (gray_wgt[3][4]), .DI5 (gray_wgt[3][5]), .DI6 (gray_wgt[3][6]), .DI7 (gray_wgt[3][7]), 
    .DI8 (gray_wgt[2][0]), .DI9 (gray_wgt[2][1]), .DI10(gray_wgt[2][2]), .DI11(gray_wgt[2][3]), .DI12(gray_wgt[2][4]), .DI13(gray_wgt[2][5]), .DI14(gray_wgt[2][6]), .DI15(gray_wgt[2][7]), 
    .DI16(gray_wgt[1][0]), .DI17(gray_wgt[1][1]), .DI18(gray_wgt[1][2]), .DI19(gray_wgt[1][3]), .DI20(gray_wgt[1][4]), .DI21(gray_wgt[1][5]), .DI22(gray_wgt[1][6]), .DI23(gray_wgt[1][7]), 
    .DI24(gray_wgt[0][0]), .DI25(gray_wgt[0][1]), .DI26(gray_wgt[0][2]), .DI27(gray_wgt[0][3]), .DI28(gray_wgt[0][4]), .DI29(gray_wgt[0][5]), .DI30(gray_wgt[0][6]), .DI31(gray_wgt[0][7]), 
    
    .DO0 (sram_wgt_out[0]),  .DO1 (sram_wgt_out[1]),  .DO2 (sram_wgt_out[2]),  .DO3 (sram_wgt_out[3]),  .DO4 (sram_wgt_out[4]),  .DO5 (sram_wgt_out[5]),  .DO6 (sram_wgt_out[6]),  .DO7 (sram_wgt_out[7]), 
    .DO8 (sram_wgt_out[8]),  .DO9 (sram_wgt_out[9]),  .DO10(sram_wgt_out[10]), .DO11(sram_wgt_out[11]), .DO12(sram_wgt_out[12]), .DO13(sram_wgt_out[13]), .DO14(sram_wgt_out[14]), .DO15(sram_wgt_out[15]), 
    .DO16(sram_wgt_out[16]), .DO17(sram_wgt_out[17]), .DO18(sram_wgt_out[18]), .DO19(sram_wgt_out[19]), .DO20(sram_wgt_out[20]), .DO21(sram_wgt_out[21]), .DO22(sram_wgt_out[22]), .DO23(sram_wgt_out[23]), 
    .DO24(sram_wgt_out[24]), .DO25(sram_wgt_out[25]), .DO26(sram_wgt_out[26]), .DO27(sram_wgt_out[27]), .DO28(sram_wgt_out[28]), .DO29(sram_wgt_out[29]), .DO30(sram_wgt_out[30]), .DO31(sram_wgt_out[31])
);


endmodule






module PE (
    input               clk,
    input               rst_n,
    input       [31:0]  data_in,
    input               data_in_ready,
    output reg          data_in_req,

    input       [1:0]   img_size_in,
    input       [2:0]   action,
    
    output      [1:0]   img_size_out,
    output reg  [31:0]  data_out,
    output reg          data_out_ready,
    input               data_out_req
);


parameter IMG_SIZE_4    = 2'd0;
parameter IMG_SIZE_8    = 2'd1;
parameter IMG_SIZE_16   = 2'd2;

parameter ACTION_POOL   = 3'd3; // Max Pooling
parameter ACTION_NEG    = 3'd4; // Negative
parameter ACTION_HOR    = 3'd5; // Horizontal Flip 
parameter ACTION_FILTER = 3'd6; // Image Filter 

assign img_size_out = (action == ACTION_POOL & img_size_in != IMG_SIZE_4) ? (img_size_in - 2'd1) : img_size_in;


// reg [5:0]   sram_in_addr, sram_out_addr;
// reg [31:0]  sram_in_data, sram_out_data;
// reg         sram_in_en, sram_out_en;


reg [7:0] row_temp [0:2][0:15];  // 16*3

reg [7:0] output_buffer [0:15];

reg [1:0] x_count, y_count;
reg [3:0] row_count; // 0~15
reg out_count;
reg data_in_valid_reg;

reg [3:0] scan_x;
reg find_median_flag;

wire [1:0] x_count_max = (img_size_in == IMG_SIZE_4) ? 'd0 : 
                         (img_size_in == IMG_SIZE_8) ? 'd1 : 'd3;

wire [1:0] y_count_max = (action == ACTION_FILTER) ? 'd2 : 
                         (action == ACTION_POOL)   ? 'd1 : 'd0;

wire [3:0] row_count_max = (img_size_in == IMG_SIZE_4) ? 'd3 : 
                           (img_size_in == IMG_SIZE_8) ? 'd7 : 'd15;

wire [7:0] data_in_3 = data_in[7:0];
wire [7:0] data_in_2 = data_in[15:8];
wire [7:0] data_in_1 = data_in[23:16];
wire [7:0] data_in_0 = data_in[31:24];


wire [7:0] median_0, median_1, median_2, median_3, median_4, median_5, median_6, median_7,
           median_8, median_9, median_10,median_11,median_12,median_13,median_14,median_15;

integer i, j;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0 ; i < 3 ; i = i + 1) begin
            for(j = 0 ; j < 16 ; j = j + 1) begin
                row_temp[i][j] <= 8'd0;
            end
        end
    end
    else if(data_in_ready & data_in_req) begin
        case(action)
            ACTION_POOL : begin
                if(y_count == 2'd0) begin
                    if (x_count == 2'd0) begin
                        row_temp[0][0] <= (data_in_0 > data_in_1) ? data_in_0 : data_in_1;
                        row_temp[0][1] <= (data_in_2 > data_in_3) ? data_in_2 : data_in_3;
                    end
                    else if (x_count == 2'd1) begin
                        row_temp[0][2] <= (data_in_0 > data_in_1) ? data_in_0 : data_in_1;
                        row_temp[0][3] <= (data_in_2 > data_in_3) ? data_in_2 : data_in_3;
                    end
                    else if (x_count == 2'd2) begin
                        row_temp[0][4] <= (data_in_0 > data_in_1) ? data_in_0 : data_in_1;
                        row_temp[0][5] <= (data_in_2 > data_in_3) ? data_in_2 : data_in_3;
                    end
                    else if (x_count == 2'd3) begin
                        row_temp[0][6] <= (data_in_0 > data_in_1) ? data_in_0 : data_in_1;
                        row_temp[0][7] <= (data_in_2 > data_in_3) ? data_in_2 : data_in_3;
                    end
                end
                else if(y_count == 2'd1) begin
                    if (x_count == 2'd0) begin
                        row_temp[0][0] <= (data_in_0 > data_in_1 & data_in_0 > row_temp[0][0]) ? data_in_0 : (data_in_1 > data_in_0 & data_in_1 > row_temp[0][0]) ? data_in_1 : row_temp[0][0];
                        row_temp[0][1] <= (data_in_2 > data_in_3 & data_in_2 > row_temp[0][1]) ? data_in_2 : (data_in_3 > data_in_2 & data_in_3 > row_temp[0][1]) ? data_in_3 : row_temp[0][1];
                    end
                    else if (x_count == 2'd1) begin
                        row_temp[0][2] <= (data_in_0 > data_in_1 & data_in_0 > row_temp[0][0]) ? data_in_0 : (data_in_1 > data_in_0 & data_in_1 > row_temp[0][0]) ? data_in_1 : row_temp[0][0];
                        row_temp[0][3] <= (data_in_2 > data_in_3 & data_in_2 > row_temp[0][1]) ? data_in_2 : (data_in_3 > data_in_2 & data_in_3 > row_temp[0][1]) ? data_in_3 : row_temp[0][1];
                    end
                    else if (x_count == 2'd2) begin
                        row_temp[0][4] <= (data_in_0 > data_in_1 & data_in_0 > row_temp[0][0]) ? data_in_0 : (data_in_1 > data_in_0 & data_in_1 > row_temp[0][0]) ? data_in_1 : row_temp[0][0];
                        row_temp[0][5] <= (data_in_2 > data_in_3 & data_in_2 > row_temp[0][1]) ? data_in_2 : (data_in_3 > data_in_2 & data_in_3 > row_temp[0][1]) ? data_in_3 : row_temp[0][1];
                    end
                    else if (x_count == 2'd3) begin
                        row_temp[0][6] <= (data_in_0 > data_in_1 & data_in_0 > row_temp[0][0]) ? data_in_0 : (data_in_1 > data_in_0 & data_in_1 > row_temp[0][0]) ? data_in_1 : row_temp[0][0];
                        row_temp[0][7] <= (data_in_2 > data_in_3 & data_in_2 > row_temp[0][1]) ? data_in_2 : (data_in_3 > data_in_2 & data_in_3 > row_temp[0][1]) ? data_in_3 : row_temp[0][1];
                    end
                end
            end
            ACTION_NEG : begin
                row_temp[0][0] <= ~data_in_0;
                row_temp[0][1] <= ~data_in_1;
                row_temp[0][2] <= ~data_in_2;
                row_temp[0][3] <= ~data_in_3;
            end
            ACTION_HOR : begin
                if (x_count == 2'd0) begin
                    row_temp[0][0] <= data_in_0;
                    row_temp[0][1] <= data_in_1;
                    row_temp[0][2] <= data_in_2;
                    row_temp[0][3] <= data_in_3;    
                end
                else if (x_count == 2'd1) begin
                    row_temp[0][4] <= data_in_0;
                    row_temp[0][5] <= data_in_1;
                    row_temp[0][6] <= data_in_2;
                    row_temp[0][7] <= data_in_3;    
                end
            end
            ACTION_FILTER : begin
                if(row_count < 3) begin
                    row_temp[y_count][0+x_count*4] <= data_in_0;
                    row_temp[y_count][1+x_count*4] <= data_in_1;
                    row_temp[y_count][2+x_count*4] <= data_in_2;
                    row_temp[y_count][3+x_count*4] <= data_in_3;
                end
                else if(row_count == 3) begin
                    row_temp[y_count][0+x_count*4] <= data_in_0;
                    row_temp[y_count][1+x_count*4] <= data_in_1;
                    row_temp[y_count][2+x_count*4] <= data_in_2;
                    row_temp[y_count][3+x_count*4] <= data_in_3;
                end
                else begin
                    row_temp[0][0+x_count*4] <= row_temp[1][0+x_count*4];
                    row_temp[0][1+x_count*4] <= row_temp[1][1+x_count*4];
                    row_temp[0][2+x_count*4] <= row_temp[1][2+x_count*4];
                    row_temp[0][3+x_count*4] <= row_temp[1][3+x_count*4];
                    
                    row_temp[1][0+x_count*4] <= row_temp[2][0+x_count*4];
                    row_temp[1][1+x_count*4] <= row_temp[2][1+x_count*4];
                    row_temp[1][2+x_count*4] <= row_temp[2][2+x_count*4];
                    row_temp[1][3+x_count*4] <= row_temp[2][3+x_count*4];

                    row_temp[2][0+x_count*4] <= data_in_0;
                    row_temp[2][1+x_count*4] <= data_in_1;
                    row_temp[2][2+x_count*4] <= data_in_2;
                    row_temp[2][3+x_count*4] <= data_in_3;
                end
            end
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        x_count <= 2'd0;
    end
    else if((data_in_ready & data_in_req)) begin
        x_count <= (x_count == x_count_max) ? 2'd0 : (x_count + 2'd1);
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        y_count <= 2'd0;
    end
    else if(data_in_ready & data_in_req & x_count == x_count_max) begin
        y_count <= (y_count == y_count_max) ? y_count_max : (y_count + 2'd1);
    end
end

reg cal_start_flag;
wire cal_done;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cal_start_flag <= 1'b0;
    end
    else if((x_count == x_count_max) & (y_count == y_count_max)) begin
        cal_start_flag <= 1'b1;
    end
    else if(cal_done) begin
        cal_start_flag <= 1'b0;
    end
end


reg not_full;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        not_full <= 1'b1;
    end
    else if(data_in_ready & x_count == x_count_max & row_count > 'd0) begin
        not_full <= 1'b0;
    end
    else if(find_median_flag & scan_x == x_count_max) begin
        not_full <= 1'b1;
    end
end

always @(*) begin
    case(action)
        ACTION_POOL     : data_in_req = not_full | data_out_req;
        ACTION_NEG      : data_in_req = not_full | data_out_req;
        ACTION_HOR      : data_in_req = not_full | data_out_req;
        ACTION_FILTER   : data_in_req = not_full | (data_out_req & data_out_ready & ~find_median_flag);
        default : data_in_req = 1'b0;
    endcase
end


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        data_out <= 32'd0;
    end
    else if(data_out_req) begin
        case(action)
            ACTION_POOL : begin
                if (x_count == x_count_max & y_count == y_count_max) begin
                    data_out <= {row_temp[0][3], row_temp[0][2], row_temp[0][1], row_temp[0][0]};
                end
                else if(out_count == 1'b1) begin
                    data_out <= {row_temp[0][4], row_temp[0][5], row_temp[0][6], row_temp[0][7]};
                end
            end
            ACTION_NEG : begin
                if (x_count == x_count_max & y_count == y_count_max) begin
                    data_out <= {row_temp[0][0], row_temp[0][1], row_temp[0][2], row_temp[0][3]};
                end
                else if(out_count == 1'b1) begin
                    data_out <= {row_temp[0][4], row_temp[0][5], row_temp[0][6], row_temp[0][7]};
                end
            end
            ACTION_HOR : begin
                if (x_count == x_count_max & y_count == y_count_max) begin
                    data_out <= {row_temp[0][7], row_temp[0][6], row_temp[0][5], row_temp[0][4]};
                end
                else if(out_count == 1'b1) begin
                    data_out <= {row_temp[0][3], row_temp[0][2], row_temp[0][1], row_temp[0][0]};
                end
            end
            ACTION_FILTER : begin
                if (data_out_req & find_median_flag) begin
                    data_out <= {median_0, median_1, median_2, median_3};
                end
            end
            default : data_out <= 32'd0;
        endcase
    end
end


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        data_out_ready <= 1'b0;
    end
    else if(data_in_valid_reg) begin
        case(action)
            ACTION_POOL : begin
                if (x_count == x_count_max & y_count == y_count_max) begin
                    data_out_ready <= 1'b1;
                end
                else if(out_count == 1'b1) begin
                    data_out_ready <= 1'b1;
                end
                else begin
                    data_out_ready <= 1'b0;
                end
            end
            ACTION_NEG : begin
                if (x_count == x_count_max & y_count == y_count_max) begin
                    data_out_ready <= 1'b1;
                end
                else if(out_count == 1'b1) begin
                    data_out_ready <= 1'b1;
                end
                else begin
                    data_out_ready <= 1'b0;
                end
            end
            ACTION_HOR : begin
                if (x_count == x_count_max & y_count == y_count_max) begin
                    data_out_ready <= 1'b1;
                end
                else if(out_count == 1'b1) begin
                    data_out_ready <= 1'b1;
                end
                else begin
                    data_out_ready <= 1'b0;
                end
            end
            ACTION_FILTER : begin
                if (row_count > 2) begin
                    data_out_ready <= 1'b1;
                end
            end
            default : data_out_ready <= 1'b0;
        endcase
    end
end



always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        row_count <= 4'b0;
    end
    else if(data_in_ready & x_count == x_count_max) begin
        row_count <= (row_count == row_count_max) ? row_count_max : (row_count + 4'd1);
    end
end


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_count <= 1'b0;
    end
    else if(x_count == x_count_max & y_count == y_count_max) begin
        out_count <= 1'b1;
    end
    else begin
        out_count <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        data_in_valid_reg <= 1'b0;
    end
    else begin
        data_in_valid_reg <= data_in_ready;
    end
end

always @(*) begin
    if(!rst_n) begin
        find_median_flag <= 1'b0;
    end
    else if(data_out_req & ~not_full) begin
        find_median_flag <= 1'b1;
    end
    else begin
        find_median_flag <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        scan_x <= 'd0;
    end
    else if(find_median_flag & data_out_req) begin
        scan_x <= (scan_x == x_count_max) ? 'd0 : (scan_x + 'd1);
    end
    else if(not_full) begin
        scan_x <= 'd0;
    end
end

wire [7:0] find_median_0_in_0 = row_temp[0][0];
wire [7:0] find_median_0_in_1 = row_temp[0][0];
wire [7:0] find_median_0_in_2 = row_temp[0][1];
wire [7:0] find_median_0_in_3 = (row_count == 'd0) ? row_temp[0][0] : row_temp[1][0];
wire [7:0] find_median_0_in_4 = (row_count == 'd0) ? row_temp[0][0] : row_temp[1][0];
wire [7:0] find_median_0_in_5 = (row_count == 'd0) ? row_temp[0][1] : row_temp[1][1];
wire [7:0] find_median_0_in_6 = (row_count == 'd0) ? row_temp[1][0] : row_temp[2][0];
wire [7:0] find_median_0_in_7 = (row_count == 'd0) ? row_temp[1][0] : row_temp[2][0];
wire [7:0] find_median_0_in_8 = (row_count == 'd0) ? row_temp[1][1] : row_temp[2][1];


find_median find_median_0 (
    .clk(clk),
    .rst_n(rst_n),
    .in_0(row_temp[0][0]),
    .in_1(row_temp[0][1]),
    .in_2(row_temp[0][2]),
    .in_3(row_temp[1][0]),
    .in_4(row_temp[1][1]),
    .in_5(row_temp[1][2]),
    .in_6(row_temp[2][0]),
    .in_7(row_temp[2][1]),
    .in_8(row_temp[2][2]),
    .median(median_0)
);

find_median find_median_1 (
    .clk(clk),
    .rst_n(rst_n),
    .in_0(row_temp[0][0]),
    .in_1(row_temp[0][1]),
    .in_2(row_temp[0][2]),
    .in_3(row_temp[1][0]),
    .in_4(row_temp[1][1]),
    .in_5(row_temp[1][2]),
    .in_6(row_temp[2][0]),
    .in_7(row_temp[2][1]),
    .in_8(row_temp[2][2]),
    .median(median_0)
);

find_median find_median_2 (
    .clk(clk),
    .rst_n(rst_n),
    .in_0(row_temp[0][0]),
    .in_1(row_temp[0][1]),
    .in_2(row_temp[0][2]),
    .in_3(row_temp[1][0]),
    .in_4(row_temp[1][1]),
    .in_5(row_temp[1][2]),
    .in_6(row_temp[2][0]),
    .in_7(row_temp[2][1]),
    .in_8(row_temp[2][2]),
    .median(median_0)
);

find_median find_median_3 (
    .clk(clk),
    .rst_n(rst_n),
    .in_0(row_temp[0][0]),
    .in_1(row_temp[0][1]),
    .in_2(row_temp[0][2]),
    .in_3(row_temp[1][0]),
    .in_4(row_temp[1][1]),
    .in_5(row_temp[1][2]),
    .in_6(row_temp[2][0]),
    .in_7(row_temp[2][1]),
    .in_8(row_temp[2][2]),
    .median(median_0)
);

/*
// port a for write, port b for read
SRAM_64X32 SRAM_64X32 (
    .CKA(clk), .CKB(clk), .WEAN(~sram_in_en) , .WEBN(1), .CSA(1) , .CSB(1), .OEA(1), .OEB(1),

    .A0(sram_in_addr[0]),  .A1(sram_in_addr[1]),  .A2(sram_in_addr[2]),  .A3(sram_in_addr[3]),  .A4(sram_in_addr[4]),  .A5(sram_in_addr[5]),
    .B0(sram_out_addr[0]), .B1(sram_out_addr[1]), .B2(sram_out_addr[2]), .B3(sram_out_addr[3]), .B4(sram_out_addr[4]), .B5(sram_out_addr[5]),

    .DIA0(sram_in_data[0]),   .DIA1(sram_in_data[1]),   .DIA2(sram_in_data[2]),   .DIA3(sram_in_data[3]), 
    .DIA4(sram_in_data[4]),   .DIA5(sram_in_data[5]),   .DIA6(sram_in_data[6]),   .DIA7(sram_in_data[7]),
    .DIA8(sram_in_data[8]),   .DIA9(sram_in_data[9]),   .DIA10(sram_in_data[10]), .DIA11(sram_in_data[11]), 
    .DIA12(sram_in_data[12]), .DIA13(sram_in_data[13]), .DIA14(sram_in_data[14]), .DIA15(sram_in_data[15]),
    .DIA16(sram_in_data[16]), .DIA17(sram_in_data[17]), .DIA18(sram_in_data[18]), .DIA19(sram_in_data[19]), 
    .DIA20(sram_in_data[20]), .DIA21(sram_in_data[21]), .DIA22(sram_in_data[22]), .DIA23(sram_in_data[23]),
    .DIA24(sram_in_data[24]), .DIA25(sram_in_data[25]), .DIA26(sram_in_data[26]), .DIA27(sram_in_data[27]), 
    .DIA28(sram_in_data[28]), .DIA29(sram_in_data[29]), .DIA30(sram_in_data[30]), .DIA31(sram_in_data[31]),
    
    // DIB0,DIB1,DIB2,DIB3,DIB4,DIB5,DIB6,DIB7,
    // DIB8,DIB9,DIB10,DIB11,DIB12,DIB13,DIB14,DIB15,
    // DIB16,DIB17,DIB18,DIB19,DIB20,DIB21,DIB22,DIB23,
    // DIB24,DIB25,DIB26,DIB27,DIB28,DIB29,DIB30,DIB31,

    // DOA0,DOA1,DOA2,DOA3,DOA4,DOA5,DOA6,DOA7,
    // DOA8,DOA9,DOA10,DOA11,DOA12,DOA13,DOA14,DOA15,
    // DOA16,DOA17,DOA18,DOA19,DOA20,DOA21,DOA22,DOA23,
    // DOA24,DOA25,DOA26,DOA27,DOA28,DOA29,DOA30,DOA31,
    
    .DOB0 (sram_out_data[0]),  .DOB1 (sram_out_data[1]),  .DOB2 (sram_out_data[2]),  .DOB3 (sram_out_data[3]), 
    .DOB4 (sram_out_data[4]),  .DOB5 (sram_out_data[5]),  .DOB6 (sram_out_data[6]),  .DOB7 (sram_out_data[7]),
    .DOB8 (sram_out_data[8]),  .DOB9 (sram_out_data[9]),  .DOB10(sram_out_data[10]), .DOB11(sram_out_data[11]), 
    .DOB12(sram_out_data[12]), .DOB13(sram_out_data[13]), .DOB14(sram_out_data[14]), .DOB15(sram_out_data[15]),
    .DOB16(sram_out_data[16]), .DOB17(sram_out_data[17]), .DOB18(sram_out_data[18]), .DOB19(sram_out_data[19]), 
    .DOB20(sram_out_data[20]), .DOB21(sram_out_data[21]), .DOB22(sram_out_data[22]), .DOB23(sram_out_data[23]),
    .DOB24(sram_out_data[24]), .DOB25(sram_out_data[25]), .DOB26(sram_out_data[26]), .DOB27(sram_out_data[27]), 
    .DOB28(sram_out_data[28]), .DOB29(sram_out_data[29]), .DOB30(sram_out_data[30]), .DOB31(sram_out_data[31])
);
*/

endmodule



module find_median(
    input clk,
    input rst_n,
    input [7:0] in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8, 
    output reg [7:0] median
);

//*******network SORT*********//
wire sort [0:8][0:8];

assign sort[0][0] = 1'b0;
assign sort[0][1] = in_0 > in_1;
assign sort[0][2] = in_0 > in_2;
assign sort[0][3] = in_0 > in_3;
assign sort[0][4] = in_0 > in_4;
assign sort[0][5] = in_0 > in_5;
assign sort[0][6] = in_0 > in_6;
assign sort[0][7] = in_0 > in_7;
assign sort[0][8] = in_0 > in_8;

assign sort[1][0] = ~sort[0][1];
assign sort[1][1] = 1'b0;
assign sort[1][2] = in_1 > in_2;
assign sort[1][3] = in_1 > in_3;
assign sort[1][4] = in_1 > in_4;
assign sort[1][5] = in_1 > in_5;
assign sort[1][6] = in_1 > in_6;
assign sort[1][7] = in_1 > in_7;
assign sort[1][8] = in_1 > in_8;

assign sort[2][0] = ~sort[0][2];
assign sort[2][1] = ~sort[1][2];
assign sort[2][2] = 1'b0;
assign sort[2][3] = in_2 > in_3;
assign sort[2][4] = in_2 > in_4;
assign sort[2][5] = in_2 > in_5;
assign sort[2][6] = in_2 > in_6;
assign sort[2][7] = in_2 > in_7;
assign sort[2][8] = in_2 > in_8;

assign sort[3][0] = ~sort[0][3];
assign sort[3][1] = ~sort[1][3];
assign sort[3][2] = ~sort[2][3];
assign sort[3][3] = 1'b0;
assign sort[3][4] = in_3 > in_4;
assign sort[3][5] = in_3 > in_5;
assign sort[3][6] = in_3 > in_6;
assign sort[3][7] = in_3 > in_7;
assign sort[3][8] = in_3 > in_8;

assign sort[4][0] = ~sort[0][4];
assign sort[4][1] = ~sort[1][4];
assign sort[4][2] = ~sort[2][4];
assign sort[4][3] = ~sort[3][4];
assign sort[4][4] = 1'b0;
assign sort[4][5] = in_4 > in_5;
assign sort[4][6] = in_4 > in_6;
assign sort[4][7] = in_4 > in_7;
assign sort[4][8] = in_4 > in_8;

assign sort[5][0] = ~sort[0][5];
assign sort[5][1] = ~sort[1][5];
assign sort[5][2] = ~sort[2][5];
assign sort[5][3] = ~sort[3][5];
assign sort[5][4] = ~sort[4][5];
assign sort[5][5] = 1'b0;
assign sort[5][6] = in_5 > in_6;
assign sort[5][7] = in_5 > in_7;
assign sort[5][8] = in_5 > in_8;

assign sort[6][0] = ~sort[0][6];
assign sort[6][1] = ~sort[1][6];
assign sort[6][2] = ~sort[2][6];
assign sort[6][3] = ~sort[3][6];
assign sort[6][4] = ~sort[4][6];
assign sort[6][5] = ~sort[5][6];
assign sort[6][6] = 1'b0;
assign sort[6][7] = in_6 > in_7;
assign sort[6][8] = in_6 > in_8;

assign sort[7][0] = ~sort[0][7];
assign sort[7][1] = ~sort[1][7];
assign sort[7][2] = ~sort[2][7];
assign sort[7][3] = ~sort[3][7];
assign sort[7][4] = ~sort[4][7];
assign sort[7][5] = ~sort[5][7];
assign sort[7][6] = ~sort[6][7];
assign sort[7][7] = 1'b0;
assign sort[7][8] = in_7 > in_8;

assign sort[8][0] = ~sort[0][7];
assign sort[8][1] = ~sort[1][7];
assign sort[8][2] = ~sort[2][7];
assign sort[8][3] = ~sort[3][7];
assign sort[8][4] = ~sort[4][7];
assign sort[8][5] = ~sort[5][7];
assign sort[8][6] = ~sort[6][7];
assign sort[8][7] = ~sort[8][7];
assign sort[8][8] = 1'b0;

//add
wire [3:0] sort_acc [0:8];
assign sort_acc[0] = sort[0][1] + sort[0][2] + sort[0][3] + sort[0][4] +sort[0][5] + sort[0][6] + sort[0][7] + sort[0][8];
assign sort_acc[1] = sort[1][0] + sort[1][2] + sort[1][3] + sort[1][4] +sort[1][5] + sort[1][6] + sort[1][7] + sort[1][8];
assign sort_acc[2] = sort[2][0] + sort[2][1] + sort[2][3] + sort[2][4] +sort[2][5] + sort[2][6] + sort[2][7] + sort[2][8];
assign sort_acc[3] = sort[3][0] + sort[3][1] + sort[3][2] + sort[3][4] +sort[3][5] + sort[3][6] + sort[3][7] + sort[3][8];
assign sort_acc[4] = sort[4][0] + sort[4][1] + sort[4][2] + sort[4][3] +sort[4][5] + sort[4][6] + sort[4][7] + sort[4][8];
assign sort_acc[5] = sort[5][0] + sort[5][1] + sort[5][2] + sort[5][3] +sort[5][4] + sort[5][6] + sort[5][7] + sort[5][8];
assign sort_acc[6] = sort[6][0] + sort[6][1] + sort[6][2] + sort[6][3] +sort[6][4] + sort[6][5] + sort[6][7] + sort[6][8];
assign sort_acc[7] = sort[7][0] + sort[7][1] + sort[7][2] + sort[7][3] +sort[7][4] + sort[7][5] + sort[7][6] + sort[7][8];
assign sort_acc[8] = sort[8][0] + sort[8][1] + sort[8][2] + sort[8][3] +sort[8][4] + sort[8][5] + sort[8][6] + sort[8][7];

always @(*) begin
    case(1)
        (sort_acc[0] == 'd4) : median = in_0;
        (sort_acc[1] == 'd4) : median = in_1;
        (sort_acc[2] == 'd4) : median = in_2;
        (sort_acc[3] == 'd4) : median = in_3;
        (sort_acc[4] == 'd4) : median = in_4;
        (sort_acc[5] == 'd4) : median = in_5;
        (sort_acc[6] == 'd4) : median = in_6;
        (sort_acc[7] == 'd4) : median = in_7;
        (sort_acc[8] == 'd4) : median = in_8;
        default : median = 8'd0;
    endcase
end

endmodule





module CONV (
    input               clk,
    input               rst_n,
    input       [31:0]  data_in,
    input               data_in_ready,
    output              data_in_req,

    input       [7:0]   template_0, template_1, template_2, template_3, template_4, 
                        template_5, template_6, template_7, template_8,

    input       [1:0]   img_size_in,
    
    output reg  [19:0]  data_out,
    output reg          data_out_ready,
    input               data_out_req,

    output out_done
);


parameter IMG_SIZE_4    = 2'd0;
parameter IMG_SIZE_8    = 2'd1;
parameter IMG_SIZE_16   = 2'd2;

reg [7:0] row_temp [0:2][0:15];  // 16*3
reg [1:0] x_count, y_count;
reg [3:0] row_count; // 0~15
reg [3:0] out_count;
reg data_in_valid_reg;

reg [3:0] addr_x, addr_y;

reg start_flag;

wire [19:0] ofmap;
wire [1:0] x_count_max = (img_size_in == IMG_SIZE_4) ? 'd0 : 
                         (img_size_in == IMG_SIZE_8) ? 'd1 : 'd3;

wire [1:0] y_count_max = 'd2;

wire [3:0] row_count_max = (img_size_in == IMG_SIZE_4) ? 'd3 : 
                           (img_size_in == IMG_SIZE_8) ? 'd7 : 'd15;

wire [7:0] data_in_3 = data_in[7:0];
wire [7:0] data_in_2 = data_in[15:8];
wire [7:0] data_in_1 = data_in[23:16];
wire [7:0] data_in_0 = data_in[31:24];

wire one_row_out_done = out_count == row_count_max;
assign out_done = addr_x == row_count_max & addr_y == row_count_max & data_out_req;

wire [7:0] padding_result [0:2][0:17];  // 18*3
assign padding_result[0][0]  = 'd0;
assign padding_result[0][1]  = (addr_y == row_count_max) ? row_temp[1][0]  : (addr_y == 'd0) ? 'd0 : row_temp[0][0];
assign padding_result[0][2]  = (addr_y == row_count_max) ? row_temp[1][1]  : (addr_y == 'd0) ? 'd0 : row_temp[0][1];
assign padding_result[0][3]  = (addr_y == row_count_max) ? row_temp[1][2]  : (addr_y == 'd0) ? 'd0 : row_temp[0][2];
assign padding_result[0][4]  = (addr_y == row_count_max) ? row_temp[1][3]  : (addr_y == 'd0) ? 'd0 : row_temp[0][3];
assign padding_result[0][5]  = (addr_y == row_count_max) ? row_temp[1][4]  : (addr_y == 'd0) ? 'd0 : row_temp[0][4];
assign padding_result[0][6]  = (addr_y == row_count_max) ? row_temp[1][5]  : (addr_y == 'd0) ? 'd0 : row_temp[0][5];
assign padding_result[0][7]  = (addr_y == row_count_max) ? row_temp[1][6]  : (addr_y == 'd0) ? 'd0 : row_temp[0][6];
assign padding_result[0][8]  = (addr_y == row_count_max) ? row_temp[1][7]  : (addr_y == 'd0) ? 'd0 : row_temp[0][7];
assign padding_result[0][9]  = (addr_y == row_count_max) ? row_temp[1][8]  : (addr_y == 'd0) ? 'd0 : row_temp[0][8];
assign padding_result[0][10] = (addr_y == row_count_max) ? row_temp[1][9]  : (addr_y == 'd0) ? 'd0 : row_temp[0][9];
assign padding_result[0][11] = (addr_y == row_count_max) ? row_temp[1][10] : (addr_y == 'd0) ? 'd0 : row_temp[0][10];
assign padding_result[0][12] = (addr_y == row_count_max) ? row_temp[1][11] : (addr_y == 'd0) ? 'd0 : row_temp[0][11];
assign padding_result[0][13] = (addr_y == row_count_max) ? row_temp[1][12] : (addr_y == 'd0) ? 'd0 : row_temp[0][12];
assign padding_result[0][14] = (addr_y == row_count_max) ? row_temp[1][13] : (addr_y == 'd0) ? 'd0 : row_temp[0][13];
assign padding_result[0][15] = (addr_y == row_count_max) ? row_temp[1][14] : (addr_y == 'd0) ? 'd0 : row_temp[0][14];
assign padding_result[0][16] = (addr_y == row_count_max) ? row_temp[1][15] : (addr_y == 'd0) ? 'd0 : row_temp[0][15];
assign padding_result[0][17] = 'd0;

assign padding_result[1][0]  = 'd0;
assign padding_result[1][1]  = (addr_y == row_count_max) ? row_temp[2][0]  : (addr_y == 'd0) ? row_temp[0][0]  : row_temp[1][0];
assign padding_result[1][2]  = (addr_y == row_count_max) ? row_temp[2][1]  : (addr_y == 'd0) ? row_temp[0][1]  : row_temp[1][1];
assign padding_result[1][3]  = (addr_y == row_count_max) ? row_temp[2][2]  : (addr_y == 'd0) ? row_temp[0][2]  : row_temp[1][2];
assign padding_result[1][4]  = (addr_y == row_count_max) ? row_temp[2][3]  : (addr_y == 'd0) ? row_temp[0][3]  : row_temp[1][3];
assign padding_result[1][5]  = (addr_y == row_count_max) ? row_temp[2][4]  : (addr_y == 'd0) ? row_temp[0][4]  : row_temp[1][4];
assign padding_result[1][6]  = (addr_y == row_count_max) ? row_temp[2][5]  : (addr_y == 'd0) ? row_temp[0][5]  : row_temp[1][5];
assign padding_result[1][7]  = (addr_y == row_count_max) ? row_temp[2][6]  : (addr_y == 'd0) ? row_temp[0][6]  : row_temp[1][6];
assign padding_result[1][8]  = (addr_y == row_count_max) ? row_temp[2][7]  : (addr_y == 'd0) ? row_temp[0][7]  : row_temp[1][7];
assign padding_result[1][9]  = (addr_y == row_count_max) ? row_temp[2][8]  : (addr_y == 'd0) ? row_temp[0][8]  : row_temp[1][8];
assign padding_result[1][10] = (addr_y == row_count_max) ? row_temp[2][9]  : (addr_y == 'd0) ? row_temp[0][9]  : row_temp[1][9];
assign padding_result[1][11] = (addr_y == row_count_max) ? row_temp[2][10] : (addr_y == 'd0) ? row_temp[0][10] : row_temp[1][10];
assign padding_result[1][12] = (addr_y == row_count_max) ? row_temp[2][11] : (addr_y == 'd0) ? row_temp[0][11] : row_temp[1][11];
assign padding_result[1][13] = (addr_y == row_count_max) ? row_temp[2][12] : (addr_y == 'd0) ? row_temp[0][12] : row_temp[1][12];
assign padding_result[1][14] = (addr_y == row_count_max) ? row_temp[2][13] : (addr_y == 'd0) ? row_temp[0][13] : row_temp[1][13];
assign padding_result[1][15] = (addr_y == row_count_max) ? row_temp[2][14] : (addr_y == 'd0) ? row_temp[0][14] : row_temp[1][14];
assign padding_result[1][16] = (addr_y == row_count_max) ? row_temp[2][15] : (addr_y == 'd0) ? row_temp[0][15] : row_temp[1][15];
assign padding_result[1][17] = 'd0;

assign padding_result[2][0]  = 'd0;
assign padding_result[2][1]  = (addr_y == row_count_max) ? 'd0 : (addr_y == 'd0) ? row_temp[1][0]  : row_temp[2][0];
assign padding_result[2][2]  = (addr_y == row_count_max) ? 'd0 : (addr_y == 'd0) ? row_temp[1][1]  : row_temp[2][1];
assign padding_result[2][3]  = (addr_y == row_count_max) ? 'd0 : (addr_y == 'd0) ? row_temp[1][2]  : row_temp[2][2];
assign padding_result[2][4]  = (addr_y == row_count_max) ? 'd0 : (addr_y == 'd0) ? row_temp[1][3]  : row_temp[2][3];
assign padding_result[2][5]  = (addr_y == row_count_max) ? 'd0 : (addr_y == 'd0) ? row_temp[1][4]  : row_temp[2][4];
assign padding_result[2][6]  = (addr_y == row_count_max) ? 'd0 : (addr_y == 'd0) ? row_temp[1][5]  : row_temp[2][5];
assign padding_result[2][7]  = (addr_y == row_count_max) ? 'd0 : (addr_y == 'd0) ? row_temp[1][6]  : row_temp[2][6];
assign padding_result[2][8]  = (addr_y == row_count_max) ? 'd0 : (addr_y == 'd0) ? row_temp[1][7]  : row_temp[2][7];
assign padding_result[2][9]  = (addr_y == row_count_max) ? 'd0 : (addr_y == 'd0) ? row_temp[1][8]  : row_temp[2][8];
assign padding_result[2][10] = (addr_y == row_count_max) ? 'd0 : (addr_y == 'd0) ? row_temp[1][9]  : row_temp[2][9];
assign padding_result[2][11] = (addr_y == row_count_max) ? 'd0 : (addr_y == 'd0) ? row_temp[1][10] : row_temp[2][10];
assign padding_result[2][12] = (addr_y == row_count_max) ? 'd0 : (addr_y == 'd0) ? row_temp[1][11] : row_temp[2][11];
assign padding_result[2][13] = (addr_y == row_count_max) ? 'd0 : (addr_y == 'd0) ? row_temp[1][12] : row_temp[2][12];
assign padding_result[2][14] = (addr_y == row_count_max) ? 'd0 : (addr_y == 'd0) ? row_temp[1][13] : row_temp[2][13];
assign padding_result[2][15] = (addr_y == row_count_max) ? 'd0 : (addr_y == 'd0) ? row_temp[1][14] : row_temp[2][14];
assign padding_result[2][16] = (addr_y == row_count_max) ? 'd0 : (addr_y == 'd0) ? row_temp[1][15] : row_temp[2][15];
assign padding_result[2][17] = 'd0;

assign data_in_req = (y_count != y_count_max) | (one_row_out_done & data_out_req & (row_count != row_count_max+1));


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        x_count <= 2'd0;
    end
    else if(data_in_ready) begin
        x_count <= (x_count == x_count_max) ? 2'd0 : (x_count + 2'd1);
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        y_count <= 2'd0;
    end
    else if(x_count == x_count_max & data_in_ready) begin
        y_count <= (y_count == y_count_max) ? 2'd2 : (y_count + 2'd1);
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        row_count <= 4'b0;
    end
    else if(data_in_ready & data_in_req & x_count == x_count_max) begin
        row_count <= (row_count == row_count_max+1) ? row_count_max+1 : (row_count + 4'd1);
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_count <= 'd0;
    end
    else if(data_out_req) begin
        out_count <= one_row_out_done ? 'd0 : (out_count + 'd1);
    end
end

always @(*) begin
    if(start_flag & data_out_req) begin
        data_out <= ofmap;
    end
    else begin
        data_out <= 'd0;
    end
end

always @(*) begin
    if(start_flag) begin
        data_out_ready <= 1'b1;
    end
    else begin
        data_out_ready <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        addr_x <= 'd0;
    end
    else if(start_flag & data_out_req) begin
        addr_x <= (addr_x == row_count_max) ? 'd0 : (addr_x + 'd1);
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        addr_y <= 'd0;
    end
    else if(start_flag & addr_x == row_count_max & data_out_req) begin
        addr_y <= (addr_y == row_count_max) ? 'd0 : (addr_y + 'd1);
    end
end


integer i, j;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0 ; i < 3 ; i = i + 1) begin
            for(j = 0 ; j < 16 ; j = j + 1) begin
                row_temp[i][j] <= 8'd0;
            end
        end
    end
    else if(data_in_ready & data_in_req) begin
        if(row_count < 3) begin
            row_temp[y_count][0+x_count*4] <= data_in_0;
            row_temp[y_count][1+x_count*4] <= data_in_1;
            row_temp[y_count][2+x_count*4] <= data_in_2;
            row_temp[y_count][3+x_count*4] <= data_in_3;
        end
        else begin
            row_temp[0][0+x_count*4] <= row_temp[1][0+x_count*4];
            row_temp[0][1+x_count*4] <= row_temp[1][1+x_count*4];
            row_temp[0][2+x_count*4] <= row_temp[1][2+x_count*4];
            row_temp[0][3+x_count*4] <= row_temp[1][3+x_count*4];
            
            row_temp[1][0+x_count*4] <= row_temp[2][0+x_count*4];
            row_temp[1][1+x_count*4] <= row_temp[2][1+x_count*4];
            row_temp[1][2+x_count*4] <= row_temp[2][2+x_count*4];
            row_temp[1][3+x_count*4] <= row_temp[2][3+x_count*4];

            row_temp[2][0+x_count*4] <= data_in_0;
            row_temp[2][1+x_count*4] <= data_in_1;
            row_temp[2][2+x_count*4] <= data_in_2;
            row_temp[2][3+x_count*4] <= data_in_3;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        start_flag <= 1'b0;
    end
    else if(row_count == 'd1 & x_count == x_count_max) begin
        start_flag <= 1'b1;
    end
end


wire [7:0] ifmap_0 = padding_result[0][addr_x+0];
wire [7:0] ifmap_1 = padding_result[0][addr_x+1];
wire [7:0] ifmap_2 = padding_result[0][addr_x+2];
wire [7:0] ifmap_3 = padding_result[1][addr_x+0];
wire [7:0] ifmap_4 = padding_result[1][addr_x+1];
wire [7:0] ifmap_5 = padding_result[1][addr_x+2];
wire [7:0] ifmap_6 = padding_result[2][addr_x+0];
wire [7:0] ifmap_7 = padding_result[2][addr_x+1];
wire [7:0] ifmap_8 = padding_result[2][addr_x+2];


MAC MAC_0(
    .ifmap_0(ifmap_0), 
    .ifmap_1(ifmap_1), 
    .ifmap_2(ifmap_2), 
    .ifmap_3(ifmap_3), 
    .ifmap_4(ifmap_4), 
    .ifmap_5(ifmap_5), 
    .ifmap_6(ifmap_6), 
    .ifmap_7(ifmap_7), 
    .ifmap_8(ifmap_8), 
    .weight_0(template_0), 
    .weight_1(template_1), 
    .weight_2(template_2), 
    .weight_3(template_3), 
    .weight_4(template_4), 
    .weight_5(template_5), 
    .weight_6(template_6), 
    .weight_7(template_7), 
    .weight_8(template_8), 
    .ofmap(ofmap)
);


endmodule


module MAC(
    input [7:0] ifmap_0, ifmap_1, ifmap_2, ifmap_3, ifmap_4, ifmap_5, ifmap_6, ifmap_7, ifmap_8, 
    input [7:0] weight_0, weight_1, weight_2, weight_3, weight_4, weight_5, weight_6, weight_7, weight_8, 
    output [19:0] ofmap
);

wire [15:0] psum_0 = ifmap_0 * weight_0;
wire [15:0] psum_1 = ifmap_1 * weight_1;
wire [15:0] psum_2 = ifmap_2 * weight_2;
wire [15:0] psum_3 = ifmap_3 * weight_3;
wire [15:0] psum_4 = ifmap_4 * weight_4;
wire [15:0] psum_5 = ifmap_5 * weight_5;
wire [15:0] psum_6 = ifmap_6 * weight_6;
wire [15:0] psum_7 = ifmap_7 * weight_7;
wire [15:0] psum_8 = ifmap_8 * weight_8;

assign ofmap = psum_0 + psum_1 + psum_2 + psum_3 + psum_4 + 
               psum_5 + psum_6 + psum_7 + psum_8;

endmodule

