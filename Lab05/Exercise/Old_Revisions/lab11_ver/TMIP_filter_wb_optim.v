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

// action
localparam POOL  		= 'd3;
localparam NEGATIVE   	= 'd4;
localparam HORIZON 		= 'd5;
localparam FILTER		= 'd6;
localparam CONV  		= 'd7;

// state
localparam IDLE		= 'd0;
localparam READ_IMG = 'd1;
localparam READ_ACT = 'd2;
localparam DOUT     = 'd8; 
localparam DONE 	= 'd9;

integer i, j;

//==================================================================
// reg
//==================================================================
// FSM state
reg [4:0] state, next_state;

// input reg
reg in_valid_reg;
reg [1:0] image_size_reg;
reg [1:0] image_size_temp;
reg [7:0] template_reg [0:8];  
reg [2:0] action_reg [0:7];

// gray
reg [7:0] max_temp;
reg [9:0] avg_temp;
reg [7:0] wgt_temp;

// shift reg
reg [7:0] gray_max_temp [0:3];
reg [7:0] gray_avg_reg [0:3];
reg [7:0] gray_wgt_reg [0:3];

// counter
reg [1:0] RGB_count;
reg [1:0] SRAM_192_32_in_count;
reg [3:0] template_count;
reg [3:0] action_idx;
reg [3:0] current_action_idx;

reg wb_flag; // wire
reg [7:0] wb_addr;
reg [7:0] rd_addr;

reg [2:0] set_count;
reg [4:0] wait_conv_out_count;
reg [8:0] cal_count;


reg SRAM_192_32_read_done;


// max pooling
reg [7:0] pool_temp [0:3];
reg [7:0] pool_reg  [0:3];

// filter
reg [7:0] SRAM_out_buffer [0:2][0:3];
reg [7:0] window [0:2][0:4];
reg [7:0] filter_result_reg [0:2][0:3];

// skip action flag
reg neg_flag, flip_flag;

// output
reg [19:0] conv_temp;
reg [19:0] conv_out_reg;
reg conv_sram_stop_flag_reg;
//==================================================================
// SRAM
//==================================================================
reg SRAM_64X32_WE, SRAM_192X32_WE;
reg [5:0] SRAM_64X32_addr;
reg [7:0] SRAM_192X32_addr;
reg [31:0] SRAM_64X32_data_in_reg, SRAM_192X32_data_in_reg;
wire [31:0] SRAM_64X32_data_out, SRAM_192X32_data_out;
reg [31:0] SRAM_64X32_data_out_reg, SRAM_192X32_data_out_reg;

//==================================================================
// Wire
//==================================================================
wire [7:0] SRAM_192X32_out_decode [0:3];
wire [7:0] SRAM_64X32_in_decode   [0:3];
wire [7:0] SRAM_64X32_out_decode  [0:3];

assign SRAM_192X32_out_decode[0] = SRAM_192X32_data_out_reg[31:24];
assign SRAM_192X32_out_decode[1] = SRAM_192X32_data_out_reg[23:16];
assign SRAM_192X32_out_decode[2] = SRAM_192X32_data_out_reg[15:8];
assign SRAM_192X32_out_decode[3] = SRAM_192X32_data_out_reg[7:0];
assign SRAM_64X32_in_decode[0] 	 = SRAM_64X32_data_in_reg[31:24];
assign SRAM_64X32_in_decode[1] 	 = SRAM_64X32_data_in_reg[23:16];
assign SRAM_64X32_in_decode[2] 	 = SRAM_64X32_data_in_reg[15:8];
assign SRAM_64X32_in_decode[3] 	 = SRAM_64X32_data_in_reg[7:0];
assign SRAM_64X32_out_decode[0]  = SRAM_64X32_data_out_reg[31:24];
assign SRAM_64X32_out_decode[1]  = SRAM_64X32_data_out_reg[23:16];
assign SRAM_64X32_out_decode[2]  = SRAM_64X32_data_out_reg[15:8];
assign SRAM_64X32_out_decode[3]  = SRAM_64X32_data_out_reg[7:0];

wire [7:0] SRAM_out_sel [0:3];
wire [7:0] SRAM_out_flip[0:3];
wire [7:0] SRAM_out 	[0:3];
assign SRAM_out_sel[0] = !SRAM_192_32_read_done ? SRAM_192X32_out_decode[0] : SRAM_64X32_out_decode[0];
assign SRAM_out_sel[1] = !SRAM_192_32_read_done ? SRAM_192X32_out_decode[1] : SRAM_64X32_out_decode[1];
assign SRAM_out_sel[2] = !SRAM_192_32_read_done ? SRAM_192X32_out_decode[2] : SRAM_64X32_out_decode[2];
assign SRAM_out_sel[3] = !SRAM_192_32_read_done ? SRAM_192X32_out_decode[3] : SRAM_64X32_out_decode[3];

assign SRAM_out_flip[0] = (flip_flag & state == CONV) ? SRAM_out_sel[3] : SRAM_out_sel[0];
assign SRAM_out_flip[1] = (flip_flag & state == CONV) ? SRAM_out_sel[2] : SRAM_out_sel[1];
assign SRAM_out_flip[2] = (flip_flag & state == CONV) ? SRAM_out_sel[1] : SRAM_out_sel[2];
assign SRAM_out_flip[3] = (flip_flag & state == CONV) ? SRAM_out_sel[0] : SRAM_out_sel[3];

assign SRAM_out[0] = neg_flag ? ~SRAM_out_flip[0] : SRAM_out_flip[0];
assign SRAM_out[1] = neg_flag ? ~SRAM_out_flip[1] : SRAM_out_flip[1];
assign SRAM_out[2] = neg_flag ? ~SRAM_out_flip[2] : SRAM_out_flip[2];
assign SRAM_out[3] = neg_flag ? ~SRAM_out_flip[3] : SRAM_out_flip[3];


// filter
wire [7:0] median_in [0:8];
wire [7:0] median_result;
assign median_in[0] = window[0][0]; assign median_in[1] = window[0][1]; assign median_in[2] = window[0][2];
assign median_in[3] = window[1][0]; assign median_in[4] = window[1][1]; assign median_in[5] = window[1][2];
assign median_in[6] = window[2][0]; assign median_in[7] = window[2][1]; assign median_in[8] = window[2][2];

// conv
wire conv_sram_stop_flag = (state == CONV) ? ((image_size_temp == 'd0) ? (cal_count < 'd2 | wait_conv_out_count == 'd7) : (cal_count < 'd3 | wait_conv_out_count == 'd7)) : 1'b1;

wire [2:0] next_action = action_reg[current_action_idx+1];

wire new_flip_flag 	= (state == HORIZON) ? ~flip_flag : flip_flag;
wire wr_out_done	= wait_conv_out_count == 'd19;

wire read_act_done 	= action_idx == 'd2; // !in_valid2;
wire read_img_done 	= (image_size_reg == 'd2)  ? (SRAM_192X32_addr == 'd191) : (image_size_reg == 'd1)  ? (SRAM_192X32_addr == 'd143) : (SRAM_192X32_addr == 'd131);
wire pool_done 		= (image_size_temp == 'd2) ? (cal_count == 'd84)  		 : (image_size_temp == 'd1) ? (cal_count == 'd24) 	  	  : 1'b1;
wire filter_done 	= (image_size_temp == 'd2) ? (cal_count == 'd266) 		 : (image_size_temp == 'd1) ? (cal_count == 'd74) 	  	  : (cal_count == 'd27);
wire conv_done 		= (image_size_temp == 'd2) ? (cal_count == 'd259 & wr_out_done) : (image_size_temp == 'd1) ? (cal_count == 'd67 & wr_out_done) : (cal_count == 'd19 & wr_out_done);
wire set_done 		= set_count == 'd7;


//==================================================================
// design
//==================================================================
// next state logic
always @(*) begin
    case(state)
        IDLE        : next_state = in_valid     ? READ_IMG : in_valid2 ? READ_ACT : IDLE;
        READ_IMG    : next_state = read_img_done? (in_valid2 ? READ_ACT : IDLE) : READ_IMG;
        READ_ACT    : next_state = read_act_done? next_action : READ_ACT;
        POOL 		: next_state = pool_done    ? next_action : POOL;
		FILTER 		: next_state = filter_done 	? next_action : FILTER;
		NEGATIVE 	: next_state = next_action;
		HORIZON		: next_state = next_action;
		CONV 		: next_state = conv_done 	? DOUT : CONV;
        DOUT        : next_state = set_done     ? DONE : IDLE;
		DONE		: next_state = IDLE;
        default  	: next_state = IDLE;
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
always @(posedge clk) begin
    in_valid_reg <= in_valid;
end

always @(posedge clk) begin
    if(in_valid & template_count == 'd0) begin
        image_size_reg <= image_size;
    end
end

always @(posedge clk) begin
    if(state == READ_ACT) begin
        image_size_temp <= image_size_reg;
    end
    else if(state == POOL & pool_done) begin
        image_size_temp <= (image_size_temp == 'd0) ? 'd0 : (image_size_temp - 'd1);
    end
end

always @(posedge clk)begin
	if (in_valid & template_count < 'd9) begin
		template_reg [template_count] <= template;
	end
end

always @(posedge clk)  begin
	if (in_valid2) begin
		action_reg[action_idx] <= action;
	end
end

// counter
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		template_count <= 'd0; 
	end
	else if (in_valid) begin
		template_count <= (template_count == 'd9) ? template_count : (template_count + 'd1);
	end
	else begin
		template_count <= 'd0; 
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		action_idx <= 'd0; 
	end
	else if (in_valid2) begin
		action_idx <= action_idx + 'd1;
	end
	else if(state == DOUT) begin
		action_idx <= 'd0; 
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		current_action_idx <= 'd0; 
	end
	else if ((read_act_done & state==READ_ACT) | (pool_done & state == POOL) | (filter_done & state == FILTER) | (state == HORIZON) | (state == NEGATIVE)) begin
		current_action_idx <= current_action_idx + 'd1;
	end
	else if(state == DOUT) begin
		current_action_idx <= 'd0; 
	end
end


always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		RGB_count <= 'd0; 
	end
	else if (in_valid | state == READ_IMG) begin
		RGB_count <= (RGB_count == 'd2) ? 'd0 : (RGB_count + 'd1);
	end
	else begin
		RGB_count <= 'd0; 
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		SRAM_192_32_in_count <= 'd0; 
	end
	else if (state == DONE) begin
		SRAM_192_32_in_count <= 'd0; 
	end
	else if (RGB_count == 'd2) begin
		SRAM_192_32_in_count <= (SRAM_192_32_in_count == 'd3) ? 'd0 : (SRAM_192_32_in_count + 'd1);
	end
end

// gray temp
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		max_temp <= 'd0; 
	end
	else if (in_valid) begin
        if (RGB_count == 'd2) begin
            max_temp <= 'd0;
        end
        else begin
            max_temp <= (max_temp > image) ? max_temp : image;
        end
	end
end
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		avg_temp <= 'd0; 
	end
	else if (in_valid) begin
        if (RGB_count == 'd0) begin
            avg_temp <= image;
        end
        else begin
            avg_temp <= avg_temp + image;
        end
	end
end
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		wgt_temp <= 'd0; 
	end
	else if (in_valid) begin
        case(RGB_count)
            'd0 : wgt_temp <= image >> 2;
            'd1 : wgt_temp <= wgt_temp + (image >> 1);
            'd2 : wgt_temp <= 'd0;
        endcase
	end
end

// Shift reg
always @(posedge clk) begin
	if (in_valid & RGB_count == 'd2) begin
        gray_max_temp[0] <= (max_temp > image) ? max_temp : image;
		gray_max_temp[1] <= gray_max_temp[0];
		gray_max_temp[2] <= gray_max_temp[1];
		gray_max_temp[3] <= gray_max_temp[2];
	end
end
always @(posedge clk) begin
	if ((in_valid | in_valid_reg) & RGB_count == 'd0) begin
        gray_avg_reg[0] <= avg_temp / 'd3;
		gray_avg_reg[1] <= gray_avg_reg[0];
		gray_avg_reg[2] <= gray_avg_reg[1];
		gray_avg_reg[3] <= gray_avg_reg[2];
	end
end
always @(posedge clk) begin
	if (in_valid & RGB_count == 'd2) begin
        gray_wgt_reg[0] <= wgt_temp + (image >> 2);
		gray_wgt_reg[1] <= gray_wgt_reg[0];
		gray_wgt_reg[2] <= gray_wgt_reg[1];
		gray_wgt_reg[3] <= gray_wgt_reg[2];
	end
end


// SRAM_192X32 write
reg start_write_flag;
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		start_write_flag <= 1'b0; 
	end
	else if(SRAM_192_32_in_count == 'd3) begin
        start_write_flag <= 1'b1;
	end
    else if(state == DONE) begin
        start_write_flag <= 1'b0; 
    end
end

always @(posedge clk) begin
	if(SRAM_192_32_in_count == 'd0 & start_write_flag) begin
        case(RGB_count)
		    'd0 : SRAM_192X32_data_in_reg <= {gray_max_temp[3], gray_max_temp[2], gray_max_temp[1], gray_max_temp[0]};
		    'd1 : SRAM_192X32_data_in_reg <= {gray_avg_reg[3], gray_avg_reg[2], gray_avg_reg[1], gray_avg_reg[0]};
		    'd2 : SRAM_192X32_data_in_reg <= {gray_wgt_reg[3], gray_wgt_reg[2], gray_wgt_reg[1], gray_wgt_reg[0]};
        endcase
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		SRAM_192X32_addr <= 'd127; 
	end
	else if(state == DONE) begin
        SRAM_192X32_addr <= 'd127;
	end
	else if(SRAM_192_32_in_count == 'd0 & start_write_flag) begin
        case(RGB_count)
		    'd0 : SRAM_192X32_addr <= SRAM_192X32_addr - 'd127;
		    'd1 : SRAM_192X32_addr <= SRAM_192X32_addr + 'd64;
		    'd2 : SRAM_192X32_addr <= SRAM_192X32_addr + 'd64;
        endcase
	end
	else if(state == POOL) begin
		case(image_size_temp)
			'd1 : begin
				case(cal_count % 'd5)
					'd4 : SRAM_192X32_addr <= (action_reg[0] << 6) + rd_addr + 'd0;
					'd0 : SRAM_192X32_addr <= (action_reg[0] << 6) + rd_addr + 'd2;
					'd1 : SRAM_192X32_addr <= (action_reg[0] << 6) + rd_addr + 'd1;
					'd2 : SRAM_192X32_addr <= (action_reg[0] << 6) + rd_addr + 'd3;
					'd3 : SRAM_192X32_addr <= (action_reg[0] << 6) + wb_addr;
				endcase
			end
			'd2 : begin
				case(cal_count % 'd5)
					'd4 : SRAM_192X32_addr <= (action_reg[0] << 6) + rd_addr + 'd0;
					'd0 : SRAM_192X32_addr <= (action_reg[0] << 6) + rd_addr + 'd4;
					'd1 : SRAM_192X32_addr <= (action_reg[0] << 6) + rd_addr + 'd1;
					'd2 : SRAM_192X32_addr <= (action_reg[0] << 6) + rd_addr + 'd5;
					'd3 : SRAM_192X32_addr <= (action_reg[0] << 6) + wb_addr;
				endcase
			end
		endcase
	end
	else if(state == FILTER | state == CONV) begin
		if(conv_sram_stop_flag) begin
			case(image_size_temp)
				'd0 : begin
					case(cal_count)
						'd0  : SRAM_192X32_addr <= (action_reg[0] << 6) + rd_addr + 'd1;		// 1
						default : begin
							case(cal_count % 'd4)
								'd2 : SRAM_192X32_addr <= (action_reg[0] << 6) + rd_addr + 'd0;
								'd3 : SRAM_192X32_addr <= (action_reg[0] << 6) + rd_addr + 'd1;
								'd0 : SRAM_192X32_addr <= (action_reg[0] << 6) + rd_addr + 'd2;
							endcase
						end
					endcase
				end
				'd1 : begin
					case(cal_count)
						'd0  : SRAM_192X32_addr <= (state == CONV & flip_flag) ? ((action_reg[0] << 6) + rd_addr + 'd2) : ((action_reg[0] << 6) + rd_addr + 'd2);		// 2
						'd1  : SRAM_192X32_addr <= (state == CONV & flip_flag) ? ((action_reg[0] << 6) + rd_addr - 'd1) : ((action_reg[0] << 6) + rd_addr + 'd1);		// 1
						'd2  : SRAM_192X32_addr <= (state == CONV & flip_flag) ? ((action_reg[0] << 6) + rd_addr + 'd1) : ((action_reg[0] << 6) + rd_addr + 'd3);		// 3
						default : begin
							case(cal_count % 'd4)
								'd1 : SRAM_192X32_addr <= (action_reg[0] << 6) + rd_addr + 'd0;
								'd2 : SRAM_192X32_addr <= (action_reg[0] << 6) + rd_addr + 'd2;
								'd3 : SRAM_192X32_addr <= (action_reg[0] << 6) + rd_addr + 'd4;
							endcase
						end
					endcase
				end
				'd2 : begin
					case(cal_count)
						'd0  : SRAM_192X32_addr <= (state == CONV & flip_flag) ? ((action_reg[0] << 6) + rd_addr + 'd4) : ((action_reg[0] << 6) + rd_addr + 'd4);	// 4
						'd1  : SRAM_192X32_addr <= (state == CONV & flip_flag) ? ((action_reg[0] << 6) + rd_addr - 'd1) : ((action_reg[0] << 6) + rd_addr + 'd1);	// 1
						'd2  : SRAM_192X32_addr <= (state == CONV & flip_flag) ? ((action_reg[0] << 6) + rd_addr + 'd3) : ((action_reg[0] << 6) + rd_addr + 'd5);	// 5
						'd3  : SRAM_192X32_addr <= (action_reg[0] << 6) + 'd0;				// x
						'd4  : SRAM_192X32_addr <= (action_reg[0] << 6) + 'd0;				// x
						'd5  : SRAM_192X32_addr <= (state == CONV & flip_flag) ? ((action_reg[0] << 6) + rd_addr - 'd2) : ((action_reg[0] << 6) + rd_addr + 'd2);	// 2
						'd6  : SRAM_192X32_addr <= (state == CONV & flip_flag) ? ((action_reg[0] << 6) + rd_addr + 'd2) : ((action_reg[0] << 6) + rd_addr + 'd6);	// 6
						'd7  : SRAM_192X32_addr <= (action_reg[0] << 6) + 'd0;				// x
						'd8  : SRAM_192X32_addr <= (action_reg[0] << 6) + 'd0;				// x
						'd9  : SRAM_192X32_addr <= (state == CONV & flip_flag) ? ((action_reg[0] << 6) + rd_addr - 'd3) : ((action_reg[0] << 6) + rd_addr + 'd3);	// 3
						'd10 : SRAM_192X32_addr <= (state == CONV & flip_flag) ? ((action_reg[0] << 6) + rd_addr + 'd1) : ((action_reg[0] << 6) + rd_addr + 'd7);	// 7
						'd11 : SRAM_192X32_addr <= (action_reg[0] << 6) + 'd0;				// x
						'd12 : SRAM_192X32_addr <= (action_reg[0] << 6) + 'd0;				// x
						default : begin
							case(cal_count % 'd4)
								'd1 : SRAM_192X32_addr <= (cal_count >= 'd251) ? 'd0 : ((action_reg[0] << 6) + rd_addr + 'd0);
								'd2 : SRAM_192X32_addr <= (cal_count >= 'd251) ? 'd0 : ((action_reg[0] << 6) + rd_addr + 'd4);
								'd3 : SRAM_192X32_addr <= (cal_count >= 'd239) ? ((action_reg[0] << 6) + rd_addr + 'd4) : ((action_reg[0] << 6) + rd_addr + 'd8);
								'd0 : SRAM_192X32_addr <= 'd0;
							endcase
						end
					endcase
				end
			endcase
		end
	end
	else if(action_idx > 0) begin
		if(next_action == CONV & new_flip_flag) begin
			SRAM_192X32_addr <= (image_size_temp == 'd2 & state != POOL) ? ((action_reg[0] << 6) + 'd3) : ((image_size_temp == 'd1 & state != POOL) | (image_size_temp == 'd2 & state == POOL)) ? ((action_reg[0] << 6) + 'd1) : (action_reg[0] << 6);
		end
		else begin
			SRAM_192X32_addr <= action_reg[0] << 6;
		end
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		SRAM_192X32_WE <= 1'b0;
	end
	else if(SRAM_192_32_in_count == 'd0 & start_write_flag) begin
        SRAM_192X32_WE <= 1'b1;
	end
    else begin
        SRAM_192X32_WE <= 1'b0;
    end
end

// SRAM out reg
always @(posedge clk) begin
	if(conv_sram_stop_flag_reg) begin
        SRAM_64X32_data_out_reg <= SRAM_64X32_data_out;
    end
end

always @(posedge clk) begin
	if(conv_sram_stop_flag_reg) begin
        SRAM_192X32_data_out_reg <= SRAM_192X32_data_out;
    end
end


always @(*) begin
	if(state == POOL) begin
       	wb_flag = (cal_count > 'd4)  & (cal_count % 'd5 == 'd3);
	end
	else if(state == FILTER) begin
		case(image_size_temp)
			'd0 : wb_flag = ((cal_count > 'd15) & (cal_count % 'd4 == 'd1)) | (cal_count == 'd26);
			'd1 : wb_flag = ((cal_count > 'd15) & (cal_count % 'd4 == 'd0)) | (cal_count == 'd73);
			'd2 : wb_flag = ((cal_count > 'd15) & (cal_count % 'd4 == 'd0)) | (cal_count == 'd265);
			default : wb_flag = 1'b0;
		endcase
	end
    else begin
        wb_flag = 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		wb_addr <= 'd0;
	end
    else if(state == POOL) begin
		if(pool_done) begin
        	wb_addr <= 'd0;
		end
		else if(wb_flag) begin
			wb_addr <= wb_addr + 'd1;
		end
    end
    else if(state == FILTER) begin
		if(filter_done) begin
        	wb_addr <= 'd0;
		end
		else if(wb_flag) begin
			wb_addr <= wb_addr + 'd1;
		end
    end
	else if(read_act_done) begin
        wb_addr <= 'd0;
    end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		rd_addr <= 'd0;
	end
    else if(state == HORIZON | state == NEGATIVE) begin
		if(next_action == CONV & new_flip_flag) begin
			rd_addr <= (image_size_temp == 'd2 & state != POOL) ? 'd3 : ((image_size_temp == 'd1 & state != POOL) | (image_size_temp == 'd2 & state == POOL)) ? 'd1 : 'd0;
		end
		else begin
        	rd_addr <= 'd0;
		end
    end
    else if(state == POOL) begin
		if(pool_done) begin
			if(next_action == CONV & new_flip_flag) begin
				rd_addr <= (image_size_temp == 'd2 & state != POOL) ? 'd3 : ((image_size_temp == 'd1 & state != POOL) | (image_size_temp == 'd2 & state == POOL)) ? 'd1 : 'd0;
			end
			else begin
        		rd_addr <= 'd0;
			end
		end
		else begin
			case(image_size_temp)
				'd1 : rd_addr <= (cal_count % 'd5 == 'd3) ? (rd_addr + 'd4) : rd_addr;
				'd2 : rd_addr <= (cal_count >= 'd78) ? 'd0 : (cal_count % 'd10 == 'd3) ? (rd_addr + 'd2) : (cal_count % 'd10 == 'd8) ? (rd_addr + 'd6) : rd_addr;
			endcase
		end
    end
    else if(state == FILTER) begin
		if(filter_done) begin
        	if(next_action == CONV & new_flip_flag) begin
				rd_addr <= (image_size_temp == 'd2 & state != POOL) ? 'd3 : ((image_size_temp == 'd1 & state != POOL) | (image_size_temp == 'd2 & state == POOL)) ? 'd1 : 'd0;
			end
			else begin
        		rd_addr <= 'd0;
			end
		end
		else begin
			case(image_size_temp)
				'd0 : rd_addr <= ((cal_count >= 'd5) & (cal_count % 'd4 == 'd1)) ? (rd_addr + 'd1) : rd_addr;
				'd1 : rd_addr <= ((cal_count >= 'd8) & (cal_count % 'd4 == 'd0)) ? (rd_addr + 'd1) : rd_addr;
				'd2 : rd_addr <= ((cal_count >= 'd16) & (cal_count <= 'd250) & ((cal_count % 'd16 == 'd0) | (cal_count % 'd16 == 'd4) | (cal_count % 'd16 == 'd8) | (cal_count % 'd16 == 'd12))) ? (rd_addr + 'd1) : rd_addr;
			endcase
		end
    end
    else if(state == CONV) begin
		if(conv_sram_stop_flag_reg) begin
			if(flip_flag) begin
				case(image_size_temp)
					'd0 : rd_addr <= ((cal_count >= 'd5) & (cal_count % 'd4 == 'd1)) ? (rd_addr + 'd1) : rd_addr;
					'd1 : rd_addr <= (cal_count >= 'd8) ? ((cal_count % 'd8 == 'd0) ? (rd_addr - 'd1) : (cal_count % 'd8 == 'd4) ? (rd_addr + 'd3) : rd_addr) : rd_addr;
					'd2 : rd_addr <= ((cal_count < 'd16) | (cal_count > 'd250)) ? rd_addr : 
									 ((cal_count % 'd16 == 'd0) | (cal_count % 'd16 == 'd4) | (cal_count % 'd16 == 'd8)) ? (rd_addr - 'd1) : 
									 (cal_count % 'd16 == 'd12) ? (rd_addr + 'd7) : rd_addr;
				endcase
			end
			else begin
				case(image_size_temp)
					'd0 : rd_addr <= ((cal_count >= 'd5) & (cal_count % 'd4 == 'd1)) ? (rd_addr + 'd1) : rd_addr;
					'd1 : rd_addr <= ((cal_count >= 'd8) & (cal_count % 'd4 == 'd0)) ? (rd_addr + 'd1) : rd_addr;
					'd2 : rd_addr <= ((cal_count < 'd16) | (cal_count > 'd250)) ? rd_addr : ((cal_count % 'd16 == 'd0) | (cal_count % 'd16 == 'd4) | (cal_count % 'd16 == 'd8) | (cal_count % 'd16 == 'd12)) ? (rd_addr + 'd1) : rd_addr;
				endcase
			end
		end
    end
	else if(read_act_done) begin
        rd_addr <= 'd0;
    end
end


// SRAM 64X32
always @(posedge clk) begin
	if(state == POOL) begin
        SRAM_64X32_data_in_reg <= {pool_reg[0], pool_reg[1], pool_reg[2], pool_reg[3]};
    end
    else begin
        SRAM_64X32_data_in_reg <= {filter_result_reg[2][0], filter_result_reg[2][1], filter_result_reg[2][2], filter_result_reg[2][3]};
    end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		SRAM_64X32_addr <= 'd0;
	end
	else if((state == POOL & pool_done) | (state == FILTER & filter_done) | (state == HORIZON) | (state == NEGATIVE)) begin
		if(next_action == CONV & new_flip_flag) begin
			SRAM_64X32_addr <= (image_size_temp == 'd2 & state != POOL) ? 'd3 : ((image_size_temp == 'd1 & state != POOL) | (image_size_temp == 'd2 & state == POOL)) ? 'd1 : 'd0;
		end
		else begin
			SRAM_64X32_addr <= 'd0;
		end
	end
	else if(state == POOL) begin
		case(image_size_temp)
			'd1 : begin
				case(cal_count % 'd5)
					'd4 : SRAM_64X32_addr <= rd_addr + 'd0;
					'd0 : SRAM_64X32_addr <= rd_addr + 'd2;
					'd1 : SRAM_64X32_addr <= rd_addr + 'd1;
					'd2 : SRAM_64X32_addr <= rd_addr + 'd3;
					'd3 : SRAM_64X32_addr <= wb_addr;
				endcase
			end
			'd2 : begin
				case(cal_count % 'd5)
					'd4 : SRAM_64X32_addr <= rd_addr + 'd0;
					'd0 : SRAM_64X32_addr <= rd_addr + 'd4;
					'd1 : SRAM_64X32_addr <= rd_addr + 'd1;
					'd2 : SRAM_64X32_addr <= rd_addr + 'd5;
					'd3 : SRAM_64X32_addr <= wb_addr;
				endcase
			end
		endcase
	end
	else if((state == FILTER) | (state == CONV & conv_sram_stop_flag)) begin
		case(image_size_temp)
			'd0 : begin
				case(cal_count)
					'd0  : SRAM_64X32_addr <= rd_addr + 'd1;	// 1
					'd26 : SRAM_64X32_addr <= (state == FILTER) ? wb_addr : (rd_addr + 'd0);
					default : begin
						case(cal_count % 'd4)
							'd2 : SRAM_64X32_addr <= rd_addr + 'd0;
							'd3 : SRAM_64X32_addr <= rd_addr + 'd1;
							'd0 : SRAM_64X32_addr <= rd_addr + 'd2;
							'd1 : SRAM_64X32_addr <= wb_addr;
						endcase
					end
				endcase
			end
			'd1 : begin
				case(cal_count)
					'd0  : SRAM_64X32_addr <= (flip_flag & state == CONV) ? (rd_addr + 'd2) : (rd_addr + 'd2);	// 2
					'd1  : SRAM_64X32_addr <= (flip_flag & state == CONV) ? (rd_addr - 'd1) : (rd_addr + 'd1);	// 1
					'd2  : SRAM_64X32_addr <= (flip_flag & state == CONV) ? (rd_addr + 'd1) : (rd_addr + 'd3);	// 3
					'd3  : SRAM_64X32_addr <= wb_addr;			// x
					'd4  : SRAM_64X32_addr <= wb_addr;			// x
					'd73 : SRAM_64X32_addr <= (state == FILTER) ? wb_addr : (rd_addr + 'd0);
					default : begin
						case(cal_count % 'd4)
							'd1 : SRAM_64X32_addr <= rd_addr + 'd0;
							'd2 : SRAM_64X32_addr <= rd_addr + 'd2;
							'd3 : SRAM_64X32_addr <= rd_addr + 'd4;
							'd0 : SRAM_64X32_addr <= wb_addr;
						endcase
					end
				endcase
			end
			'd2 : begin
				case(cal_count)
					'd0  : SRAM_64X32_addr <= (flip_flag & state == CONV) ? (rd_addr + 'd4) : (rd_addr + 'd4);	// 4
					'd1  : SRAM_64X32_addr <= (flip_flag & state == CONV) ? (rd_addr - 'd1) : (rd_addr + 'd1);	// 1
					'd2  : SRAM_64X32_addr <= (flip_flag & state == CONV) ? (rd_addr + 'd3) : (rd_addr + 'd5);	// 5
					'd3  : SRAM_64X32_addr <= wb_addr;			// x
					'd4  : SRAM_64X32_addr <= wb_addr;			// x
					'd5  : SRAM_64X32_addr <= (flip_flag & state == CONV) ? (rd_addr - 'd2) : (rd_addr + 'd2);	// 2
					'd6  : SRAM_64X32_addr <= (flip_flag & state == CONV) ? (rd_addr + 'd2) : (rd_addr + 'd6);	// 6
					'd7  : SRAM_64X32_addr <= wb_addr;			// x
					'd8  : SRAM_64X32_addr <= wb_addr;			// x
					'd9  : SRAM_64X32_addr <= (flip_flag & state == CONV) ? (rd_addr - 'd3) : (rd_addr + 'd3);	// 3
					'd10 : SRAM_64X32_addr <= (flip_flag & state == CONV) ? (rd_addr + 'd1) : (rd_addr + 'd7);	// 7
					'd11 : SRAM_64X32_addr <= wb_addr;			// x
					'd12 : SRAM_64X32_addr <= wb_addr;			// x
					'd265: SRAM_64X32_addr <= (state == FILTER) ? wb_addr : (rd_addr + 'd0);
					default : begin
						case(cal_count % 'd4)
							'd1 : SRAM_64X32_addr <= (cal_count >= 'd251) ? 'd0 : (rd_addr + 'd0);
							'd2 : SRAM_64X32_addr <= (cal_count >= 'd251) ? 'd0 : (rd_addr + 'd4);
							'd3 : SRAM_64X32_addr <= (cal_count >= 'd239) ? (rd_addr + 'd4) : (rd_addr + 'd8);
							'd0 : SRAM_64X32_addr <= wb_addr;
						endcase
					end
				endcase
			end
		endcase
	end
end
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		SRAM_64X32_WE <= 1'b0;
	end
	else if(wb_flag) begin
        SRAM_64X32_WE <= 1'b1;
	end
    else begin
        SRAM_64X32_WE <= 1'b0;
    end
end


// filter
always @(posedge clk) begin
	if((state == FILTER) | (state == CONV & conv_sram_stop_flag_reg)) begin
		case(image_size_temp)
			'd0 : begin
				case(cal_count)
					'd2  : {SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2], SRAM_out_buffer[0][3]} <= {SRAM_out[0], SRAM_out[1], SRAM_out[2], SRAM_out[3]}; 
					'd3  : {SRAM_out_buffer[1][0], SRAM_out_buffer[1][1], SRAM_out_buffer[1][2], SRAM_out_buffer[1][3]} <= {SRAM_out[0], SRAM_out[1], SRAM_out[2], SRAM_out[3]}; // 0,1,x
					'd15 : {SRAM_out_buffer[2][0], SRAM_out_buffer[2][1], SRAM_out_buffer[2][2], SRAM_out_buffer[2][3]} <= (state == CONV) ? 32'd0 : {SRAM_out_buffer[1][0], SRAM_out_buffer[1][1], SRAM_out_buffer[1][2], SRAM_out_buffer[1][3]};
					default : begin
						case(cal_count % 'd4)
							'd1 : {SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2], SRAM_out_buffer[0][3]} <= {SRAM_out[0], SRAM_out[1], SRAM_out[2], SRAM_out[3]};
							'd2 : {SRAM_out_buffer[1][0], SRAM_out_buffer[1][1], SRAM_out_buffer[1][2], SRAM_out_buffer[1][3]} <= {SRAM_out[0], SRAM_out[1], SRAM_out[2], SRAM_out[3]};
							'd3 : {SRAM_out_buffer[2][0], SRAM_out_buffer[2][1], SRAM_out_buffer[2][2], SRAM_out_buffer[2][3]} <= {SRAM_out[0], SRAM_out[1], SRAM_out[2], SRAM_out[3]};
						endcase
					end	
				endcase
			end
			'd1 : begin
				case(cal_count)
					'd2  : {SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2], SRAM_out_buffer[0][3]} <= {SRAM_out[0], SRAM_out[1], SRAM_out[2], SRAM_out[3]}; 
					'd3  : {SRAM_out_buffer[1][0], SRAM_out_buffer[1][1], SRAM_out_buffer[1][2], SRAM_out_buffer[1][3]} <= {SRAM_out[0], SRAM_out[1], SRAM_out[2], SRAM_out[3]}; // 0,2,x
					'd4  : {SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2], SRAM_out_buffer[0][3]} <= {SRAM_out[0], SRAM_out[1], SRAM_out[2], SRAM_out[3]}; 
					'd5  : {SRAM_out_buffer[1][0], SRAM_out_buffer[1][1], SRAM_out_buffer[1][2], SRAM_out_buffer[1][3]} <= {SRAM_out[0], SRAM_out[1], SRAM_out[2], SRAM_out[3]}; // 1,3,x
					'd58, 'd62 : {SRAM_out_buffer[2][0], SRAM_out_buffer[2][1], SRAM_out_buffer[2][2], SRAM_out_buffer[2][3]} <= (state == CONV) ? 32'd0 : {SRAM_out_buffer[1][0], SRAM_out_buffer[1][1], SRAM_out_buffer[1][2], SRAM_out_buffer[1][3]};
					default : begin
						case(cal_count % 'd4)
							'd0 : {SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2], SRAM_out_buffer[0][3]} <= {SRAM_out[0], SRAM_out[1], SRAM_out[2], SRAM_out[3]};
							'd1 : {SRAM_out_buffer[1][0], SRAM_out_buffer[1][1], SRAM_out_buffer[1][2], SRAM_out_buffer[1][3]} <= {SRAM_out[0], SRAM_out[1], SRAM_out[2], SRAM_out[3]};
							'd2 : {SRAM_out_buffer[2][0], SRAM_out_buffer[2][1], SRAM_out_buffer[2][2], SRAM_out_buffer[2][3]} <= {SRAM_out[0], SRAM_out[1], SRAM_out[2], SRAM_out[3]};
						endcase
					end	
				endcase
			end
			'd2 : begin
				case(cal_count)
					'd2  : {SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2], SRAM_out_buffer[0][3]} <= {SRAM_out[0], SRAM_out[1], SRAM_out[2], SRAM_out[3]}; 
					'd3  : {SRAM_out_buffer[1][0], SRAM_out_buffer[1][1], SRAM_out_buffer[1][2], SRAM_out_buffer[1][3]} <= {SRAM_out[0], SRAM_out[1], SRAM_out[2], SRAM_out[3]}; // 0,4,x
					'd4  : {SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2], SRAM_out_buffer[0][3]} <= {SRAM_out[0], SRAM_out[1], SRAM_out[2], SRAM_out[3]}; 
					'd5  : {SRAM_out_buffer[1][0], SRAM_out_buffer[1][1], SRAM_out_buffer[1][2], SRAM_out_buffer[1][3]} <= {SRAM_out[0], SRAM_out[1], SRAM_out[2], SRAM_out[3]}; // 1,5,x
					'd8  : {SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2], SRAM_out_buffer[0][3]} <= {SRAM_out[0], SRAM_out[1], SRAM_out[2], SRAM_out[3]}; 
					'd9  : {SRAM_out_buffer[1][0], SRAM_out_buffer[1][1], SRAM_out_buffer[1][2], SRAM_out_buffer[1][3]} <= {SRAM_out[0], SRAM_out[1], SRAM_out[2], SRAM_out[3]}; // 2,6,x
					'd12 : {SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2], SRAM_out_buffer[0][3]} <= {SRAM_out[0], SRAM_out[1], SRAM_out[2], SRAM_out[3]}; 
					'd13 : {SRAM_out_buffer[1][0], SRAM_out_buffer[1][1], SRAM_out_buffer[1][2], SRAM_out_buffer[1][3]} <= {SRAM_out[0], SRAM_out[1], SRAM_out[2], SRAM_out[3]}; // 3,7,x
					'd242, 'd246, 'd250, 'd254, 'd258 : {SRAM_out_buffer[2][0], SRAM_out_buffer[2][1], SRAM_out_buffer[2][2], SRAM_out_buffer[2][3]} <= (state == CONV) ? 32'd0 : {SRAM_out_buffer[1][0], SRAM_out_buffer[1][1], SRAM_out_buffer[1][2], SRAM_out_buffer[1][3]};
					default : begin
						case(cal_count % 'd4)
							'd0 : {SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2], SRAM_out_buffer[0][3]} <= {SRAM_out[0], SRAM_out[1], SRAM_out[2], SRAM_out[3]};
							'd1 : {SRAM_out_buffer[1][0], SRAM_out_buffer[1][1], SRAM_out_buffer[1][2], SRAM_out_buffer[1][3]} <= {SRAM_out[0], SRAM_out[1], SRAM_out[2], SRAM_out[3]};
							'd2 : {SRAM_out_buffer[2][0], SRAM_out_buffer[2][1], SRAM_out_buffer[2][2], SRAM_out_buffer[2][3]} <= {SRAM_out[0], SRAM_out[1], SRAM_out[2], SRAM_out[3]};
						endcase
					end	
				endcase
			end
		endcase
	end
	else begin
		for (i=0; i<4; i=i+1) begin
			SRAM_out_buffer[0][i] <= SRAM_out_buffer[0][i];
			SRAM_out_buffer[1][i] <= SRAM_out_buffer[1][i];
			SRAM_out_buffer[2][i] <= SRAM_out_buffer[2][i];
		end
	end
end


always @(posedge clk) begin
	if((state == FILTER) | (state == CONV & conv_sram_stop_flag_reg)) begin
		case(image_size_temp)
			'd0 : begin
				case(cal_count)
					'd3 : begin
						{window[0][0], window[0][1], window[0][2], window[0][3], window[0][4]} <= (state == CONV)   ? 32'd0 : {SRAM_out_buffer[0][0], SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2], SRAM_out_buffer[0][3]};
						{window[1][0], window[1][1], window[1][2], window[1][3], window[1][4]} <= {((state == CONV) ? 8'd0  : SRAM_out_buffer[0][0]), SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2], SRAM_out_buffer[0][3]};
						{window[2][0], window[2][1], window[2][2], window[2][3], window[2][4]} <= {((state == CONV) ? 8'd0  : SRAM_out[0]), 	SRAM_out[0],   SRAM_out[1],   SRAM_out[2],   SRAM_out[3]};
					end
					default : begin
						case(cal_count % 'd4)
							'd3  : begin
								{window[0][0], window[0][1], window[0][2], window[0][3], window[0][4]} <= {((state == CONV) ? 8'd0 : SRAM_out_buffer[0][0]), SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2], SRAM_out_buffer[0][3]};
								{window[1][0], window[1][1], window[1][2], window[1][3], window[1][4]} <= {((state == CONV) ? 8'd0 : SRAM_out_buffer[1][0]), SRAM_out_buffer[1][0], SRAM_out_buffer[1][1], SRAM_out_buffer[1][2], SRAM_out_buffer[1][3]};
								{window[2][0], window[2][1], window[2][2], window[2][3], window[2][4]} <= (cal_count == 'd15) ? ((state == CONV) ? 40'd0 : {SRAM_out_buffer[1][0], SRAM_out_buffer[1][0], SRAM_out_buffer[1][1], SRAM_out_buffer[1][2], SRAM_out_buffer[1][3]}) : 
																								{((state == CONV) ? 8'd0  : SRAM_out[0]), 	SRAM_out[0],   SRAM_out[1],   SRAM_out[2],   SRAM_out[3]};
							end
							default : begin
								{window[0][0], window[0][1], window[0][2], window[0][3], window[0][4]} <= {window[0][1], window[0][2], window[0][3], window[0][4], ((state == CONV) ? 8'd0 : window[0][4])};
								{window[1][0], window[1][1], window[1][2], window[1][3], window[1][4]} <= {window[1][1], window[1][2], window[1][3], window[1][4], ((state == CONV) ? 8'd0 : window[1][4])};
								{window[2][0], window[2][1], window[2][2], window[2][3], window[2][4]} <= {window[2][1], window[2][2], window[2][3], window[2][4], ((state == CONV) ? 8'd0 : window[2][4])};
							end
						endcase
					end	
				endcase
			end
			'd1 : begin
				case(cal_count)
					'd3  : begin
						{window[0][0], window[0][1], window[0][2], window[0][3], window[0][4]} <= (state == CONV)   ? 32'd0 : {SRAM_out_buffer[0][0], SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2], SRAM_out_buffer[0][3]};
						{window[1][0], window[1][1], window[1][2], window[1][3], window[1][4]} <= {((state == CONV) ? 8'd0  : SRAM_out_buffer[0][0]), SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2], SRAM_out_buffer[0][3]};
						{window[2][0], window[2][1], window[2][2], window[2][3], window[2][4]} <= {((state == CONV) ? 8'd0  : SRAM_out[0]), 	SRAM_out[0],   SRAM_out[1],   SRAM_out[2],   SRAM_out[3]};
					end
					'd4, 'd5, 'd8, 'd9, 'd10 : begin
						{window[0][0], window[0][1], window[0][2], window[0][3], window[0][4]} <= {window[0][1], window[0][2], window[0][3], window[0][4], ((state == CONV) ? 8'd0 : window[0][4])};
						{window[1][0], window[1][1], window[1][2], window[1][3], window[1][4]} <= {window[1][1], window[1][2], window[1][3], window[1][4], ((state == CONV) ? 8'd0 : window[1][4])};
						{window[2][0], window[2][1], window[2][2], window[2][3], window[2][4]} <= {window[2][1], window[2][2], window[2][3], window[2][4], ((state == CONV) ? 8'd0 : window[2][4])};
					end
					'd6: begin
						{window[0][0], window[0][1], window[0][2], window[0][3], window[0][4]} <= {window[0][1], window[0][2], ((state == CONV) ? 24'd0 : {SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2]})};
						{window[1][0], window[1][1], window[1][2], window[1][3], window[1][4]} <= {window[1][1], window[1][2], SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2]};
						{window[2][0], window[2][1], window[2][2], window[2][3], window[2][4]} <= {window[2][1], window[2][2], SRAM_out_buffer[1][0], SRAM_out_buffer[1][1], SRAM_out_buffer[1][2]};
					end
					'd7 : begin
						{window[0][0], window[0][1], window[0][2], window[0][3], window[0][4]} <= {window[0][1], window[0][2], window[0][3], window[0][4], ((state == CONV) ? 8'd0 : SRAM_out_buffer[0][3])};
						{window[1][0], window[1][1], window[1][2], window[1][3], window[1][4]} <= {window[1][1], window[1][2], window[1][3], window[1][4], SRAM_out_buffer[0][3]};
						{window[2][0], window[2][1], window[2][2], window[2][3], window[2][4]} <= {window[2][1], window[2][2], window[2][3], window[2][4], SRAM_out_buffer[1][3]};
					end
					default : begin
						case(cal_count % 'd8)
							'd3  : begin
								{window[0][0], window[0][1], window[0][2], window[0][3], window[0][4]} <= {((state == CONV) ? 8'd0 : SRAM_out_buffer[0][0]), SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2], SRAM_out_buffer[0][3]};
								{window[1][0], window[1][1], window[1][2], window[1][3], window[1][4]} <= {((state == CONV) ? 8'd0 : SRAM_out_buffer[1][0]), SRAM_out_buffer[1][0], SRAM_out_buffer[1][1], SRAM_out_buffer[1][2], SRAM_out_buffer[1][3]};
								{window[2][0], window[2][1], window[2][2], window[2][3], window[2][4]} <= {((state == CONV) ? 8'd0 : SRAM_out_buffer[2][0]), SRAM_out_buffer[2][0], SRAM_out_buffer[2][1], SRAM_out_buffer[2][2], SRAM_out_buffer[2][3]};
							end
							'd6: begin
								{window[0][0], window[0][1], window[0][2], window[0][3], window[0][4]} <= {window[0][1], window[0][2], SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2]};
								{window[1][0], window[1][1], window[1][2], window[1][3], window[1][4]} <= {window[1][1], window[1][2], SRAM_out_buffer[1][0], SRAM_out_buffer[1][1], SRAM_out_buffer[1][2]};
								{window[2][0], window[2][1], window[2][2], window[2][3], window[2][4]} <= (state == CONV & (cal_count == 'd58 | cal_count == 'd62)) ? 32'd0 : (cal_count == 'd62) ? {window[2][1], window[2][2], SRAM_out_buffer[1][0], SRAM_out_buffer[1][1], SRAM_out_buffer[1][2]} : {window[2][1], window[2][2], SRAM_out[0],	SRAM_out[1],   SRAM_out[2]};
							end
							'd7 : begin
								{window[0][0], window[0][1], window[0][2], window[0][3], window[0][4]} <= {window[0][1], window[0][2], window[0][3], window[0][4], SRAM_out_buffer[0][3]};
								{window[1][0], window[1][1], window[1][2], window[1][3], window[1][4]} <= {window[1][1], window[1][2], window[1][3], window[1][4], SRAM_out_buffer[1][3]};
								{window[2][0], window[2][1], window[2][2], window[2][3], window[2][4]} <= {window[2][1], window[2][2], window[2][3], window[2][4], SRAM_out_buffer[2][3]};
							end
							default : begin
								{window[0][0], window[0][1], window[0][2], window[0][3], window[0][4]} <= {window[0][1], window[0][2], window[0][3], window[0][4], ((state == CONV) ? 8'd0 : window[0][4])};
								{window[1][0], window[1][1], window[1][2], window[1][3], window[1][4]} <= {window[1][1], window[1][2], window[1][3], window[1][4], ((state == CONV) ? 8'd0 : window[1][4])};
								{window[2][0], window[2][1], window[2][2], window[2][3], window[2][4]} <= {window[2][1], window[2][2], window[2][3], window[2][4], ((state == CONV) ? 8'd0 : window[2][4])};
							end
						endcase
					end	
				endcase
			end
			'd2 : begin
				case(cal_count)
					'd3  : begin
						{window[0][0], window[0][1], window[0][2], window[0][3], window[0][4]} <= (state == CONV)   ? 32'd0 : {SRAM_out_buffer[0][0], SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2], SRAM_out_buffer[0][3]};
						{window[1][0], window[1][1], window[1][2], window[1][3], window[1][4]} <= {((state == CONV) ? 8'd0  : SRAM_out_buffer[0][0]), SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2], SRAM_out_buffer[0][3]};
						{window[2][0], window[2][1], window[2][2], window[2][3], window[2][4]} <= {((state == CONV) ? 8'd0  : SRAM_out[0]), 	SRAM_out[0],   SRAM_out[1],   SRAM_out[2],   SRAM_out[3]};
					end
					'd4, 'd5, 'd8, 'd9, 'd12, 'd13, 'd16, 'd17, 'd18 : begin
						{window[0][0], window[0][1], window[0][2], window[0][3], window[0][4]} <= {window[0][1], window[0][2], window[0][3], window[0][4], ((state == CONV) ? 8'd0 : window[0][4])};
						{window[1][0], window[1][1], window[1][2], window[1][3], window[1][4]} <= {window[1][1], window[1][2], window[1][3], window[1][4], ((state == CONV) ? 8'd0 : window[1][4])};
						{window[2][0], window[2][1], window[2][2], window[2][3], window[2][4]} <= {window[2][1], window[2][2], window[2][3], window[2][4], ((state == CONV) ? 8'd0 : window[2][4])};
					end
					'd6, 'd10, 'd14 : begin
						{window[0][0], window[0][1], window[0][2], window[0][3], window[0][4]} <= {window[0][1], window[0][2], ((state == CONV) ? 24'd0 : {SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2]})};
						{window[1][0], window[1][1], window[1][2], window[1][3], window[1][4]} <= {window[1][1], window[1][2], SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2]};
						{window[2][0], window[2][1], window[2][2], window[2][3], window[2][4]} <= {window[2][1], window[2][2], SRAM_out_buffer[1][0], SRAM_out_buffer[1][1], SRAM_out_buffer[1][2]};
					end
					'd7, 'd11, 'd15  : begin
						{window[0][0], window[0][1], window[0][2], window[0][3], window[0][4]} <= {window[0][1], window[0][2], window[0][3], window[0][4], ((state == CONV) ? 8'd0 : SRAM_out_buffer[0][3])};
						{window[1][0], window[1][1], window[1][2], window[1][3], window[1][4]} <= {window[1][1], window[1][2], window[1][3], window[1][4], SRAM_out_buffer[0][3]};
						{window[2][0], window[2][1], window[2][2], window[2][3], window[2][4]} <= {window[2][1], window[2][2], window[2][3], window[2][4], SRAM_out_buffer[1][3]};
					end
					default : begin
						case(cal_count % 'd16)
							'd3 : begin
								{window[0][0], window[0][1], window[0][2], window[0][3], window[0][4]} <= {((state == CONV) ? 8'd0 : SRAM_out_buffer[0][0]), SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2], SRAM_out_buffer[0][3]};
								{window[1][0], window[1][1], window[1][2], window[1][3], window[1][4]} <= {((state == CONV) ? 8'd0 : SRAM_out_buffer[1][0]), SRAM_out_buffer[1][0], SRAM_out_buffer[1][1], SRAM_out_buffer[1][2], SRAM_out_buffer[1][3]};
								{window[2][0], window[2][1], window[2][2], window[2][3], window[2][4]} <= {((state == CONV) ? 8'd0 : SRAM_out_buffer[2][0]), SRAM_out_buffer[2][0], SRAM_out_buffer[2][1], SRAM_out_buffer[2][2], SRAM_out_buffer[2][3]};
							end
							'd6, 'd10, 'd14 : begin
								{window[0][0], window[0][1], window[0][2], window[0][3], window[0][4]} <= {window[0][1], window[0][2], SRAM_out_buffer[0][0], SRAM_out_buffer[0][1], SRAM_out_buffer[0][2]};
								{window[1][0], window[1][1], window[1][2], window[1][3], window[1][4]} <= {window[1][1], window[1][2], SRAM_out_buffer[1][0], SRAM_out_buffer[1][1], SRAM_out_buffer[1][2]};
								{window[2][0], window[2][1], window[2][2], window[2][3], window[2][4]} <= (state == CONV & (cal_count == 'd246 | cal_count == 'd250 | cal_count == 'd254)) ? 32'd0 : {window[2][1], window[2][2], SRAM_out[0],	SRAM_out[1],   SRAM_out[2]};
							end
							'd0 : begin
								{window[0][0], window[0][1], window[0][2], window[0][3], window[0][4]} <= {window[0][1], window[0][2], window[0][3], window[0][4], ((state == CONV) ? 8'd0 : window[0][4])};
								{window[1][0], window[1][1], window[1][2], window[1][3], window[1][4]} <= {window[1][1], window[1][2], window[1][3], window[1][4], ((state == CONV) ? 8'd0 : window[1][4])};
								{window[2][0], window[2][1], window[2][2], window[2][3], window[2][4]} <= {window[2][1], window[2][2], window[2][3], window[2][4], ((state == CONV) ? 8'd0 : window[2][4])};
							end
							default : begin
								{window[0][0], window[0][1], window[0][2], window[0][3], window[0][4]} <= {window[0][1], window[0][2], window[0][3], window[0][4], SRAM_out_buffer[0][3]};
								{window[1][0], window[1][1], window[1][2], window[1][3], window[1][4]} <= {window[1][1], window[1][2], window[1][3], window[1][4], SRAM_out_buffer[1][3]};
								{window[2][0], window[2][1], window[2][2], window[2][3], window[2][4]} <= {window[2][1], window[2][2], window[2][3], window[2][4], SRAM_out_buffer[2][3]};
							end
						endcase
					end	
				endcase
			end
		endcase
	end
	else begin
		for (i=0; i<5; i=i+1) begin
			window[0][i] <= window[0][i];
			window[1][i] <= window[1][i];
			window[2][i] <= window[2][i];
		end
	end
end

always @(posedge clk) begin
	if(state == FILTER) begin
		case(image_size_temp)
			'd0 : begin
				if(cal_count == 'd25) begin
					for (i=0; i<4; i=i+1) begin
						filter_result_reg[1][i] <= filter_result_reg[0][i];
						filter_result_reg[2][i] <= filter_result_reg[1][i];
					end
				end
				else begin
					case(cal_count % 'd4)
						'd3 : begin
							filter_result_reg[0][0] <= median_result;
							for (i=0; i<4; i=i+1) begin
								filter_result_reg[1][i] <= filter_result_reg[0][i];
								filter_result_reg[2][i] <= filter_result_reg[1][i];
							end
						end
						'd0 : filter_result_reg[0][1] <= median_result;
						'd1 : filter_result_reg[0][2] <= median_result;
						'd2 : filter_result_reg[0][3] <= median_result;
					endcase
				end
			end
			'd1 : begin
				if(cal_count == 'd72) begin
					for (i=0; i<4; i=i+1) begin
						filter_result_reg[1][i] <= filter_result_reg[0][i];
						filter_result_reg[2][i] <= filter_result_reg[1][i];
					end
				end
				else begin
					case(cal_count % 'd4)
						'd3 : begin
							filter_result_reg[0][0] <= median_result;
							for (i=0; i<4; i=i+1) begin
								filter_result_reg[1][i] <= filter_result_reg[0][i];
								filter_result_reg[2][i] <= filter_result_reg[1][i];
							end
						end
						'd0 : filter_result_reg[0][1] <= median_result;
						'd1 : filter_result_reg[0][2] <= median_result;
						'd2 : filter_result_reg[0][3] <= median_result;
					endcase
				end
			end
			'd2 : begin
				if(cal_count == 'd264) begin
					for (i=0; i<4; i=i+1) begin
						filter_result_reg[1][i] <= filter_result_reg[0][i];
						filter_result_reg[2][i] <= filter_result_reg[1][i];
					end
				end
				else begin
					case(cal_count % 'd4)
						'd3 : begin
							filter_result_reg[0][0] <= median_result;
							for (i=0; i<4; i=i+1) begin
								filter_result_reg[1][i] <= filter_result_reg[0][i];
								filter_result_reg[2][i] <= filter_result_reg[1][i];
							end
						end
						'd0 : filter_result_reg[0][1] <= median_result;
						'd1 : filter_result_reg[0][2] <= median_result;
						'd2 : filter_result_reg[0][3] <= median_result;
					endcase
				end
			end
		endcase
    end
	else begin
		for (i=0; i<4; i=i+1) begin
			filter_result_reg[0][i] <= filter_result_reg[0][i];
			filter_result_reg[1][i] <= filter_result_reg[1][i];
			filter_result_reg[2][i] <= filter_result_reg[2][i];
		end
	end
end

// max pooling
wire [7:0] sram_out_max_0 = (SRAM_out[0] > SRAM_out[1]) ? SRAM_out[0] : SRAM_out[1];
wire [7:0] sram_out_max_1 = (SRAM_out[2] > SRAM_out[3]) ? SRAM_out[2] : SRAM_out[3];

always @(posedge clk) begin
	case(cal_count % 'd5)
    	'd2 : begin
			pool_temp[0] <= sram_out_max_0;
    		pool_temp[1] <= sram_out_max_1;
		end
    	'd3 : begin
			pool_temp[0] <= (SRAM_out[0] >= SRAM_out[1] & SRAM_out[0] >= pool_temp[0]) ? SRAM_out[0] : 
							(SRAM_out[1] >= SRAM_out[0] & SRAM_out[1] >= pool_temp[0]) ? SRAM_out[1] : pool_temp[0];
			pool_temp[1] <= (SRAM_out[2] >= SRAM_out[3] & SRAM_out[2] >= pool_temp[1]) ? SRAM_out[2] : 
							(SRAM_out[3] >= SRAM_out[2] & SRAM_out[3] >= pool_temp[1]) ? SRAM_out[3] : pool_temp[1];
		end
    	'd4 : begin
			pool_temp[2] <= sram_out_max_0;
    		pool_temp[3] <= sram_out_max_1;
		end
    	'd0 : begin
			pool_temp[2] <= (SRAM_out[0] >= SRAM_out[1] & SRAM_out[0] >= pool_temp[2]) ? SRAM_out[0] : 
							(SRAM_out[1] >= SRAM_out[0] & SRAM_out[1] >= pool_temp[2]) ? SRAM_out[1] : pool_temp[2];
			pool_temp[3] <= (SRAM_out[2] >= SRAM_out[3] & SRAM_out[2] >= pool_temp[3]) ? SRAM_out[2] : 
							(SRAM_out[3] >= SRAM_out[2] & SRAM_out[3] >= pool_temp[3]) ? SRAM_out[3] : pool_temp[3];
		end
	endcase
end

always @(posedge clk) begin
	if(cal_count % 'd5 == 'd1) begin
		{pool_reg[0], pool_reg[1], pool_reg[2], pool_reg[3]} <= {pool_temp[0], pool_temp[1], pool_temp[2], pool_temp[3]};
    end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		flip_flag <= 1'b0;
	end
    else if(state == HORIZON) begin
		flip_flag <= ~flip_flag;
    end
    else if(state == DOUT) begin
		flip_flag <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		neg_flag <= 1'b0;
	end
    else if(state == NEGATIVE) begin
		neg_flag <= ~neg_flag;
    end
    else if((state == POOL & pool_done & image_size_temp != 'd0) | (state == FILTER & filter_done)) begin
		neg_flag <= 1'b0;
    end
    else if(state == DOUT) begin
		neg_flag <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		SRAM_192_32_read_done <= 1'b0;
	end
    else if((state == POOL & pool_done & image_size_temp != 'd0) | (state == FILTER & filter_done)) begin
		SRAM_192_32_read_done <= 1'b1;
    end
    else if(state == DOUT) begin
		SRAM_192_32_read_done <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		cal_count <= 'd0;
	end
	else if(state == POOL) begin
        cal_count <= pool_done ? 'd0 : (cal_count + 'd1);
	end
	else if(state == FILTER) begin
        cal_count <= filter_done ? 'd0 : (cal_count + 'd1);
	end
	else if(state == CONV) begin
		if(conv_sram_stop_flag) begin
        	cal_count <= conv_done ? 'd0 : (cal_count + 'd1);
		end
	end
    else begin
        cal_count <= 'd0;
    end
end

// conv
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		conv_sram_stop_flag_reg <= 'd0;
	end
	else begin
		conv_sram_stop_flag_reg <= conv_sram_stop_flag;
	end
end


reg [15:0] product;
reg [7:0] ifmap, weight;

always @(*) begin
	case(wait_conv_out_count)
		'd10 : ifmap = window[0][0];
		'd11 : ifmap = window[0][1];
		'd12 : ifmap = window[0][2];
		'd13 : ifmap = window[1][0];
		'd14 : ifmap = window[1][1];
		'd15 : ifmap = window[1][2];
		'd16 : ifmap = window[2][0];
		'd17 : ifmap = window[2][1];
		'd18 : ifmap = window[2][2];
		default : ifmap = 'd0;
	endcase
end

always @(*) begin
	case(wait_conv_out_count)
		'd10 : weight = template_reg[0];
		'd11 : weight = template_reg[1];
		'd12 : weight = template_reg[2];
		'd13 : weight = template_reg[3];
		'd14 : weight = template_reg[4];
		'd15 : weight = template_reg[5];
		'd16 : weight = template_reg[6];
		'd17 : weight = template_reg[7];
		'd18 : weight = template_reg[8];
		default : weight = 'd0;
	endcase
end

always @(posedge clk) begin
	product <= ifmap * weight;
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		conv_temp <= 'd0;
	end
	else if (state == CONV) begin
		conv_temp <= ((wait_conv_out_count >= 'd10 & wait_conv_out_count <= 'd18)) ? (conv_temp + product) : 'd0;
	end
	else if (state == DOUT) begin
		conv_temp <= 'd0;
	end
end

always @(posedge clk) begin
	if (state == CONV & wait_conv_out_count == 'd19) begin
		conv_out_reg <= conv_temp + product;
	end
end
reg [2:0] conv_dly3;
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		conv_dly3 <= 'd0;
	end
	else if (state == DOUT) begin
		conv_dly3 <= 'd0;
	end
	else if (state == CONV) begin
		conv_dly3 <= (conv_dly3 == 'd4) ? 'd4 : (conv_dly3 + 'd1);
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		wait_conv_out_count <= 'd5;
	end
	else if (state == DOUT) begin
		wait_conv_out_count <= 'd5;
	end
	else if (conv_dly3 == 'd3) begin
		wait_conv_out_count <= 'd14;
	end
	else if (state == CONV) begin
		wait_conv_out_count <= (wait_conv_out_count == 'd19) ? 'd0 : (wait_conv_out_count + 'd1);
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		set_count <= 'd0;
	end
	else if (state == DOUT) begin
		set_count <= set_count + 'd1;
	end
	else if (state == DONE) begin
		set_count <= 'd0;
	end
end


// output
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		out_valid <= 1'b0;
	end
	else if(state == DOUT) begin
		out_valid <= 1'b0;
	end
	else if(wait_conv_out_count == 'd0) begin 
		out_valid <= 1'b1;
	end 
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		out_value <= 1'b0;
	end
	else if(state == DOUT) begin
		out_value <= 1'b0;
	end
	else if(wait_conv_out_count == 'd0 | out_valid) begin 
		out_value <= conv_out_reg[19-wait_conv_out_count];
	end
end



find_median find_median_inst (
	.clk	(clk),
	.rst_n	(rst_n),
    .in_0	(median_in[0]), 
	.in_1	(median_in[1]), 
	.in_2	(median_in[2]), 
	.in_3	(median_in[3]), 
	.in_4	(median_in[4]), 
	.in_5	(median_in[5]), 
	.in_6	(median_in[6]), 
	.in_7	(median_in[7]), 
	.in_8	(median_in[8]),
    .median	(median_result)
);

// SRAM
SRAM_192_32 SRAM_192_32_inst (.CLK(clk), .CS(1'b1), .OE(1'b1), .WEB(!SRAM_192X32_WE), .A(SRAM_192X32_addr), .DI(SRAM_192X32_data_in_reg), .DO(SRAM_192X32_data_out));
SRAM_64_32  SRAM_64_32_inst  (.CLK(clk), .CS(1'b1), .OE(1'b1), .WEB(!SRAM_64X32_WE),  .A(SRAM_64X32_addr),  .DI(SRAM_64X32_data_in_reg),  .DO(SRAM_64X32_data_out));


endmodule


module SRAM_192_32 (
    input CLK, CS, OE, WEB,
    input  [7:0]  A,
    input  [31:0] DI,
    output [31:0] DO
);
SRAM_192X32 SRAM_192X32_inst (
    .A0(A[0]),      .A1(A[1]),      .A2(A[2]),      .A3(A[3]),      .A4(A[4]),      .A5(A[5]),      .A6(A[6]),      .A7(A[7]),
    .DO0(DO[0]),    .DO1(DO[1]),    .DO2(DO[2]),    .DO3(DO[3]),    .DO4(DO[4]),    .DO5(DO[5]),    .DO6(DO[6]),    .DO7(DO[7]), 
    .DO8(DO[8]),    .DO9(DO[9]),    .DO10(DO[10]),  .DO11(DO[11]),  .DO12(DO[12]),  .DO13(DO[13]),  .DO14(DO[14]),  .DO15(DO[15]), 
    .DO16(DO[16]),  .DO17(DO[17]),  .DO18(DO[18]),  .DO19(DO[19]),  .DO20(DO[20]),  .DO21(DO[21]),  .DO22(DO[22]),  .DO23(DO[23]), 
    .DO24(DO[24]),  .DO25(DO[25]),  .DO26(DO[26]),  .DO27(DO[27]),  .DO28(DO[28]),  .DO29(DO[29]),  .DO30(DO[30]),  .DO31(DO[31]),
    .DI0(DI[0]),    .DI1(DI[1]),    .DI2(DI[2]),    .DI3(DI[3]),    .DI4(DI[4]),    .DI5(DI[5]),    .DI6(DI[6]),    .DI7(DI[7]), 
    .DI8(DI[8]),    .DI9(DI[9]),    .DI10(DI[10]),  .DI11(DI[11]),  .DI12(DI[12]),  .DI13(DI[13]),  .DI14(DI[14]),  .DI15(DI[15]), 
    .DI16(DI[16]),  .DI17(DI[17]),  .DI18(DI[18]),  .DI19(DI[19]),  .DI20(DI[20]),  .DI21(DI[21]),  .DI22(DI[22]),  .DI23(DI[23]), 
    .DI24(DI[24]),  .DI25(DI[25]),  .DI26(DI[26]),  .DI27(DI[27]),  .DI28(DI[28]),  .DI29(DI[29]),  .DI30(DI[30]),  .DI31(DI[31]),
    .CK(CLK),                    
    .WEB(WEB),                   
    .OE(OE),                     
    .CS(CS)                      
);
endmodule


module SRAM_64_32 (
    input CLK, CS, OE, WEB,
    input [5:0]  A,
    input [31:0] DI,
    output[31:0] DO
);
SRAM_64X32 SRAM_64X32_inst (
    .A0(A[0]),      .A1(A[1]),      .A2(A[2]),      .A3(A[3]),      .A4(A[4]),      .A5(A[5]),
    .DO0(DO[0]),    .DO1(DO[1]),    .DO2(DO[2]),    .DO3(DO[3]),    .DO4(DO[4]),    .DO5(DO[5]),    .DO6(DO[6]),    .DO7(DO[7]), 
    .DO8(DO[8]),    .DO9(DO[9]),    .DO10(DO[10]),  .DO11(DO[11]),  .DO12(DO[12]),  .DO13(DO[13]),  .DO14(DO[14]),  .DO15(DO[15]), 
    .DO16(DO[16]),  .DO17(DO[17]),  .DO18(DO[18]),  .DO19(DO[19]),  .DO20(DO[20]),  .DO21(DO[21]),  .DO22(DO[22]),  .DO23(DO[23]), 
    .DO24(DO[24]),  .DO25(DO[25]),  .DO26(DO[26]),  .DO27(DO[27]),  .DO28(DO[28]),  .DO29(DO[29]),  .DO30(DO[30]),  .DO31(DO[31]),
    .DI0(DI[0]),    .DI1(DI[1]),    .DI2(DI[2]),    .DI3(DI[3]),    .DI4(DI[4]),    .DI5(DI[5]),    .DI6(DI[6]),    .DI7(DI[7]), 
    .DI8(DI[8]),    .DI9(DI[9]),    .DI10(DI[10]),  .DI11(DI[11]),  .DI12(DI[12]),  .DI13(DI[13]),  .DI14(DI[14]),  .DI15(DI[15]), 
    .DI16(DI[16]),  .DI17(DI[17]),  .DI18(DI[18]),  .DI19(DI[19]),  .DI20(DI[20]),  .DI21(DI[21]),  .DI22(DI[22]),  .DI23(DI[23]), 
    .DI24(DI[24]),  .DI25(DI[25]),  .DI26(DI[26]),  .DI27(DI[27]),  .DI28(DI[28]),  .DI29(DI[29]),  .DI30(DI[30]),  .DI31(DI[31]),
    .CK(CLK),                    
    .WEB(WEB),                   
    .OE(OE),                     
    .CS(CS)                      
);
endmodule


module find_median (
	input clk,
	input rst_n,
    input  [7:0] in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8,
    output [7:0] median
);

wire [7:0] min1, mid1, max1;
wire [7:0] min2, mid2, max2;
wire [7:0] min3, mid3, max3;
wire [7:0] max_min, mid_mid, min_max;
wire [7:0] final_mid;

reg [7:0] min1_reg, mid1_reg, max1_reg;
reg [7:0] min2_reg, mid2_reg, max2_reg;
reg [7:0] min3_reg, mid3_reg, max3_reg;
reg [7:0] max_min_reg, mid_mid_reg, min_pool_temp;
reg [7:0] final_mid_reg;

sort_3 sort_3_inst_0 (.a(in_0), 	.b(in_1), 	 .c(in_2),     .min(min1), 		.mid(mid1), 	.max(max1));
sort_3 sort_3_inst_2 (.a(in_3), 	.b(in_4), 	 .c(in_5),     .min(min2), 		.mid(mid2), 	.max(max2));
sort_3 sort_3_inst_3 (.a(in_6), 	.b(in_7), 	 .c(in_8),     .min(min3), 		.mid(mid3), 	.max(max3));

sort_3 sort_3_inst_4 (.a(max1_reg),	.b(max2_reg),.c(max3_reg),	.min(max_min), 	.mid(), 		.max());
sort_3 sort_3_inst_5 (.a(mid1_reg),	.b(mid2_reg),.c(mid3_reg),	.min(), 		.mid(mid_mid), 	.max());
sort_3 sort_3_inst_6 (.a(min1_reg),	.b(min2_reg),.c(min3_reg),	.min(), 		.mid(), 		.max(min_max));

sort_3 sort_3_inst_7 (.a(max_min_reg), .b(mid_mid_reg), .c(min_pool_temp), .min(),.mid(final_mid),.max());

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		min1_reg <= 'd0; mid1_reg <= 'd0; max1_reg <= 'd0;
		min2_reg <= 'd0; mid2_reg <= 'd0; max2_reg <= 'd0;
		min3_reg <= 'd0; mid3_reg <= 'd0; max3_reg <= 'd0;
	end
	else begin 
		min1_reg <= min1; mid1_reg <= mid1; max1_reg <= max1;
		min2_reg <= min2; mid2_reg <= mid2; max2_reg <= max2;
		min3_reg <= min3; mid3_reg <= mid3; max3_reg <= max3;
	end 
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		max_min_reg <= 'd0;
		mid_mid_reg <= 'd0;
		min_pool_temp <= 'd0;
	end
	else begin 
		max_min_reg <= max_min;
		mid_mid_reg <= mid_mid;
		min_pool_temp <= min_max;
	end 
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		final_mid_reg <= 'd0;
	end
	else begin 
		final_mid_reg <= final_mid;
	end 
end

assign median = final_mid_reg;

endmodule

module sort_3 (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    output [7:0] min,
    output [7:0] mid,
    output [7:0] max
);

wire [7:0] max_temp_0 = (a >= b) ? a : b;
wire [7:0] min_temp_0 = (a >= b) ? b : a;

assign max = (max_temp_0 >= c) ? max_temp_0 : c;
assign min = (min_temp_0 <= c) ? min_temp_0 : c;
assign mid = ((a >= b & a <= c) | (a <= b & a >= c)) ? a :
             ((b >= a & b <= c) | (b <= a & b >= c)) ? b : c;

endmodule

