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

localparam ACTION_POOL  = 'd3;
localparam ACTION_NEG   = 'd4;
localparam ACTION_HORIZ = 'd5;
localparam ACTION_FILTER= 'd6;
localparam ACTION_CONV  = 'd7;

localparam ACTION_NEG_FILTER	= 'd0;
localparam ACTION_FILP_FILTER	= 'd1;

localparam IDLE			= 'd8;
localparam READ_PAT 	= 'd9;
localparam WAIT_ACT 	= 'd10;
localparam READ_ACT 	= 'd11;
localparam ST_in        = 'd12;
localparam ST_out       = 'd13; 
localparam DONE 		= 'd14;

integer i,j;

//==================================================================
// reg
//==================================================================
// FSM state
reg [3:0] state, next_state;

// RGB to Gray scale
reg [7:0] image_reg [0:2];
reg [7:0] gray_max;
reg [7:0] gray_avg;
reg [7:0] gray_wgt;

reg [1:0] RGB_count;
reg [7:0] img_addr;

reg RGB_count_done_reg, RGB_count_done_reg2;

// SRAM
wire [7:0] sram_max_out;
wire [7:0] sram_avg_out;
wire [7:0] sram_wgt_out;
reg [7:0] sram_img_addr;
reg [7:0] SRAM_out_reg;

reg wen_1, wen_2;
reg cen_1, cen_2;

reg [7:0] sram_addr [0:1];

// conv
reg [19:0] conv_temp, conv_out_reg;
reg [4:0]  idx_y, idx_x;

// init write sram control
reg ST_in_dly1, ST_in_dly2;
reg in_valid2_reload;

// action reg
reg [2:0] action_reload;
reg [3:0] action_idx;
reg [3:0] action_num;

reg [2:0] action_reg [0:7]; 
reg [2:0] current_action_idx;

// counter
reg [1:0] pool_idx; 
reg [1:0] wait_pool_count;
reg [4:0] pool_count;
reg [3:0] flip_count, flip_count2;
reg [1:0] pool_ptr; 
reg [3:0] window_idx;
reg [4:0] wait_conv_out_count;
reg [3:0] template_count;

// 8 sets
reg [2:0] set_count;

// find median
reg [7:0] sorted_buffer [1:9];

// SRAM sel
reg SRAM1, SRAM2; 

reg [7:0] pool_temp; 
reg [4:0] count_out; // 0~19 for 20-bit serial output

reg start_reg;

// input reg
reg [7:0] template_reg [0:8];  

// img size
reg read_image_size_flag; 
reg [4:0] img_size_reg; // 0~16
reg [4:0] img_size_temp;
reg [4:0] img_size_decode_reg;

// control
reg read_img_done;
reg filter_sram_write_en;


//==================================================================
// wires
//==================================================================
wire idx_x_done = idx_x == img_size_reg -'d1;
wire idx_y_done = idx_y == img_size_reg -'d1;

reg [7:0] filter_buffer[0:2][0:15];
reg [3:0] filter_count_x; // 0~15
reg [4:0] filter_count_y; // 0~16

reg [7:0] sort_in [1:9];
wire [7:0] median;


find_median find_median_inst_0 (
    .in_0(sort_in[1]), 
	.in_1(sort_in[2]), 
	.in_2(sort_in[3]), 
	.in_3(sort_in[4]), 
	.in_4(sort_in[5]), 
	.in_5(sort_in[6]), 
	.in_6(sort_in[7]), 
	.in_7(sort_in[8]), 
	.in_8(sort_in[9]),
    .median(median)
);

// control
wire RGB_count_done = RGB_count == 2'd2;
wire sram_write_en 	= RGB_count_done_reg2;

wire [4:0] img_size_decode  = (image_size   == 'd0)  ? 5'd4  : (image_size   == 'd1) ? 'd8  : 'd16;
wire [7:0] sram_img_size 	= (img_size_reg == 'd16) ? 'd255 : (img_size_reg == 'd8) ? 'd63 : 'd15;
wire sram_img_addr_done 	= sram_img_addr == sram_img_size;

wire two_ACTION_HORIZ 		= (action_reg[action_num-1] == ACTION_HORIZ) & (action == ACTION_HORIZ);
wire two_negative 			= (action_reg[action_num-1] == ACTION_NEG) & (action == ACTION_NEG);

wire neg_filter 	= (action_reg[action_num-1] == ACTION_NEG) & (action == ACTION_FILTER) | 
					  (action_reg[action_num-1] == ACTION_FILTER) & (action == ACTION_NEG);

wire flip_filter 	= (action_reg[action_num-1] == ACTION_HORIZ) & (action == ACTION_FILTER) | 
					  (action_reg[action_num-1] == ACTION_FILTER) & (action == ACTION_HORIZ);

// SRAM
wire [7:0] SRAM_data_read_1, SRAM_data_read_2; 

wire [7:0] SRAM_read_data = wen_1 ? SRAM_data_read_1 : SRAM_data_read_2; 

wire start = cen_1 & cen_2;


wire action_state = state == ACTION_CONV | state == ACTION_FILTER | state == ACTION_NEG_FILTER | state == ACTION_FILP_FILTER | 
					state == ACTION_POOL | state == ACTION_NEG | state == ACTION_HORIZ;

// action done
wire finish_reload 		= in_valid2_reload & (action_reload == ACTION_CONV);
wire one_row_col_done 		= (flip_count == img_size_reg - 1); 
wire one_row_col_done2 		= (flip_count2 == img_size_reg - 1); 
wire action_pool_done 	= (sram_addr[SRAM2] == 'd63 & img_size_reg == 'd16 & pool_ptr == 'd1 & !start) | 
							  (sram_addr[SRAM2] == 'd15 & img_size_reg ==  'd8 & pool_ptr == 'd1 & !start);  
wire action_neg_done		= (sram_addr[SRAM2] == sram_img_size & ~start_reg & !start);
wire action_horiz_done 		= (sram_addr[SRAM2] == sram_img_size & ~start_reg & !start);
wire action_filter_done		= filter_count_y == img_size_reg+1 & filter_count_x == 'd1;
wire action_flip_filter_done= filter_count_y == img_size_reg+1 & filter_count_x == 'd1;
wire action_conv_done 		= (sram_addr[SRAM2] == sram_img_size  & wait_conv_out_count == 'd0 & !start); 
wire output_done 			= count_out == 'd19; 

reg [7:0] SRAM_data_write_1, SRAM_data_write_2;

wire action_done = 	(state == ACTION_POOL & action_pool_done) 	| 
					(state == ACTION_NEG & action_neg_done) 		| 
					(state == ACTION_HORIZ & action_horiz_done)		| 
					(state == ACTION_FILTER & action_filter_done)	| 
					(state == ACTION_NEG_FILTER & action_filter_done)	| 
					(state == ACTION_FILP_FILTER & action_flip_filter_done)	| 
					(state == ACTION_CONV & action_conv_done);
 
wire [7:0] template_pad [1:9];
assign template_pad[1] = template_reg[4];
assign template_pad[2] = (idx_x_done)              ? 'd0 : template_reg[5];
assign template_pad[3] = (idx_x_done | idx_y_done) ? 'd0 : template_reg[8];
assign template_pad[4] = (idx_y_done)              ? 'd0 : template_reg[7];
assign template_pad[5] = (idx_x == 0 | idx_y_done) ? 'd0 : template_reg[6];
assign template_pad[6] = (idx_x == 0)              ? 'd0 : template_reg[3];
assign template_pad[7] = (idx_x == 0 | idx_y == 0) ? 'd0 : template_reg[0];
assign template_pad[8] = (idx_y == 0)              ? 'd0 : template_reg[1];
assign template_pad[9] = (idx_x_done | idx_y == 0) ? 'd0 : template_reg[2];

//==================================================================
// design
//==================================================================
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        filter_count_x <= 'd0;
    end
    else if(start | start_reg) begin
        filter_count_x <= 'd0;
    end
    else if(state == ACTION_FILTER | state == ACTION_FILP_FILTER | state == ACTION_NEG_FILTER) begin
        filter_count_x <= (filter_count_x == img_size_reg - 'd1) ? 'd0 : (filter_count_x + 'd1);
    end
	else if(action_filter_done | action_flip_filter_done) begin
		filter_count_x <= 'd0;
	end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        filter_count_y <= 'd0;
    end
    else if(start | start_reg) begin
        filter_count_y <= 'd0;
    end
    else if((state == ACTION_FILTER | state == ACTION_FILP_FILTER | state == ACTION_NEG_FILTER) & (filter_count_x == img_size_reg - 'd1)) begin
        filter_count_y <= (filter_count_y == img_size_reg+1) ? 'd0 : (filter_count_y + 'd1);
    end
	else if(action_filter_done | action_flip_filter_done) begin
		filter_count_y <= 'd0;
	end
end


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
		for(i=0; i<3; i=i+1) begin
			for(j=0; j<16; j=j+1) begin
        		filter_buffer[i][j] <= 'd0;
			end
		end
    end
    else if(start | start_reg) begin
        for(i=0; i<3; i=i+1) begin
			for(j=0; j<16; j=j+1) begin
        		filter_buffer[i][j] <= 'd0;
			end
		end
    end
    else if((state == ACTION_FILTER | state == ACTION_FILP_FILTER | state == ACTION_NEG_FILTER)) begin
		if(filter_count_x == 'd0 & filter_count_y >= 'd3 & filter_count_y < img_size_reg) begin
			filter_buffer[0][0] <= filter_buffer[1][0];
			filter_buffer[1][0] <= filter_buffer[2][0];
			filter_buffer[2][0] <= SRAM_read_data;
		end
		else if (filter_count_x == 'd1 & filter_count_y >= 'd3 & filter_count_y < img_size_reg) begin
			filter_buffer[0][1] <= filter_buffer[1][1];
			filter_buffer[1][1] <= filter_buffer[2][1];
			filter_buffer[2][1] <= SRAM_read_data;
		end
		else if (filter_count_x == 'd2 & filter_count_y >= 'd3 & filter_count_y < img_size_reg) begin
			for(i = 2 ; i < 16 ; i = i + 1) begin
				filter_buffer[0][i] <= filter_buffer[1][i];
				filter_buffer[1][i] <= filter_buffer[2][i];
			end
        	filter_buffer[2][2] <= SRAM_read_data;
		end
		else if(filter_count_y >= 'd3 & filter_count_y < img_size_reg) begin
			filter_buffer[2][filter_count_x] <= SRAM_read_data;
		end
		else if(filter_count_y < img_size_reg) begin
			filter_buffer[filter_count_y][filter_count_x] <= SRAM_read_data;
		end
    end
end

//	1 2 3
//	4 5 6 
//	7 8 9
always @(*) begin
	// first row
	if (filter_count_y == 'd1 & filter_count_x == 'd2) begin
		sort_in[1] = filter_buffer[0][0]; sort_in[2] = filter_buffer[0][0]; sort_in[3] = filter_buffer[0][1];
		sort_in[4] = filter_buffer[0][0]; sort_in[5] = filter_buffer[0][0]; sort_in[6] = filter_buffer[0][1];
		sort_in[7] = filter_buffer[1][0]; sort_in[8] = filter_buffer[1][0]; sort_in[9] = filter_buffer[1][1];
	end
	else if (filter_count_y == 'd1 & filter_count_x <= img_size_reg - 'd1) begin
		sort_in[1] = filter_buffer[0][filter_count_x-3]; sort_in[2] = filter_buffer[0][filter_count_x-2]; sort_in[3] = filter_buffer[0][filter_count_x-1];
		sort_in[4] = filter_buffer[0][filter_count_x-3]; sort_in[5] = filter_buffer[0][filter_count_x-2]; sort_in[6] = filter_buffer[0][filter_count_x-1];
		sort_in[7] = filter_buffer[1][filter_count_x-3]; sort_in[8] = filter_buffer[1][filter_count_x-2]; sort_in[9] = filter_buffer[1][filter_count_x-1];
	end
	else if (filter_count_y == 'd2 & filter_count_x == 'd0) begin
		sort_in[1] = filter_buffer[0][img_size_reg-3]; sort_in[2] = filter_buffer[0][img_size_reg-2]; sort_in[3] = filter_buffer[0][img_size_reg-1];
		sort_in[4] = filter_buffer[0][img_size_reg-3]; sort_in[5] = filter_buffer[0][img_size_reg-2]; sort_in[6] = filter_buffer[0][img_size_reg-1];
		sort_in[7] = filter_buffer[1][img_size_reg-3]; sort_in[8] = filter_buffer[1][img_size_reg-2]; sort_in[9] = filter_buffer[1][img_size_reg-1];
	end
	else if (filter_count_y == 'd2 & filter_count_x == 'd1) begin
		sort_in[1] = filter_buffer[0][img_size_reg-2]; sort_in[2] = filter_buffer[0][img_size_reg-1]; sort_in[3] = filter_buffer[0][img_size_reg-1];
		sort_in[4] = filter_buffer[0][img_size_reg-2]; sort_in[5] = filter_buffer[0][img_size_reg-1]; sort_in[6] = filter_buffer[0][img_size_reg-1];
		sort_in[7] = filter_buffer[1][img_size_reg-2]; sort_in[8] = filter_buffer[1][img_size_reg-1]; sort_in[9] = filter_buffer[1][img_size_reg-1];
	end

	// last row
	else if (filter_count_y == img_size_reg & filter_count_x == 'd0) begin
		sort_in[1] = filter_buffer[0][img_size_reg-3]; sort_in[2] = filter_buffer[0][img_size_reg-2]; sort_in[3] = filter_buffer[0][img_size_reg-1];
		sort_in[4] = filter_buffer[1][img_size_reg-3]; sort_in[5] = filter_buffer[1][img_size_reg-2]; sort_in[6] = filter_buffer[1][img_size_reg-1];
		sort_in[7] = filter_buffer[2][img_size_reg-3]; sort_in[8] = filter_buffer[2][img_size_reg-2]; sort_in[9] = filter_buffer[2][img_size_reg-1];
	end
	else if (filter_count_y == img_size_reg & filter_count_x == 'd1) begin
		sort_in[1] = filter_buffer[0][img_size_reg-2]; sort_in[2] = filter_buffer[0][img_size_reg-1]; sort_in[3] = filter_buffer[0][img_size_reg-1];
		sort_in[4] = filter_buffer[1][img_size_reg-2]; sort_in[5] = filter_buffer[1][img_size_reg-1]; sort_in[6] = filter_buffer[1][img_size_reg-1];
		sort_in[7] = filter_buffer[2][img_size_reg-2]; sort_in[8] = filter_buffer[2][img_size_reg-1]; sort_in[9] = filter_buffer[2][img_size_reg-1];
	end
	else if (filter_count_y == img_size_reg & filter_count_x == 'd2) begin
		sort_in[1] = filter_buffer[1][filter_count_x-2]; sort_in[2] = filter_buffer[1][filter_count_x-2]; sort_in[3] = filter_buffer[1][filter_count_x-1];
		sort_in[4] = filter_buffer[2][filter_count_x-2]; sort_in[5] = filter_buffer[2][filter_count_x-2]; sort_in[6] = filter_buffer[2][filter_count_x-1];
		sort_in[7] = filter_buffer[2][filter_count_x-2]; sort_in[8] = filter_buffer[2][filter_count_x-2]; sort_in[9] = filter_buffer[2][filter_count_x-1];
	end
	else if (filter_count_y == img_size_reg) begin
		sort_in[1] = filter_buffer[1][filter_count_x-3]; sort_in[2] = filter_buffer[1][filter_count_x-2]; sort_in[3] = filter_buffer[1][filter_count_x-1];
		sort_in[4] = filter_buffer[2][filter_count_x-3]; sort_in[5] = filter_buffer[2][filter_count_x-2]; sort_in[6] = filter_buffer[2][filter_count_x-1];
		sort_in[7] = filter_buffer[2][filter_count_x-3]; sort_in[8] = filter_buffer[2][filter_count_x-2]; sort_in[9] = filter_buffer[2][filter_count_x-1];
	end
	// special case
	else if ((filter_count_y == img_size_reg+1) & filter_count_x == 'd0) begin
		sort_in[1] = filter_buffer[1][img_size_reg-3]; sort_in[2] = filter_buffer[1][img_size_reg-2]; sort_in[3] = filter_buffer[1][img_size_reg-1];
		sort_in[4] = filter_buffer[2][img_size_reg-3]; sort_in[5] = filter_buffer[2][img_size_reg-2]; sort_in[6] = filter_buffer[2][img_size_reg-1];
		sort_in[7] = filter_buffer[2][img_size_reg-3]; sort_in[8] = filter_buffer[2][img_size_reg-2]; sort_in[9] = filter_buffer[2][img_size_reg-1];
	end
	else if ((filter_count_y == img_size_reg+1) & filter_count_x == 'd1) begin
		sort_in[1] = filter_buffer[1][img_size_reg-2]; sort_in[2] = filter_buffer[1][img_size_reg-1]; sort_in[3] = filter_buffer[1][img_size_reg-1];
		sort_in[4] = filter_buffer[2][img_size_reg-2]; sort_in[5] = filter_buffer[2][img_size_reg-1]; sort_in[6] = filter_buffer[2][img_size_reg-1];
		sort_in[7] = filter_buffer[2][img_size_reg-2]; sort_in[8] = filter_buffer[2][img_size_reg-1]; sort_in[9] = filter_buffer[2][img_size_reg-1];
	end

	// general
	else if (filter_count_x == 'd0) begin
		sort_in[1] = filter_buffer[0][img_size_reg-3]; sort_in[2] = filter_buffer[0][img_size_reg-2]; sort_in[3] = filter_buffer[0][img_size_reg-1];
		sort_in[4] = filter_buffer[1][img_size_reg-3]; sort_in[5] = filter_buffer[1][img_size_reg-2]; sort_in[6] = filter_buffer[1][img_size_reg-1];
		sort_in[7] = filter_buffer[2][img_size_reg-3]; sort_in[8] = filter_buffer[2][img_size_reg-2]; sort_in[9] = filter_buffer[2][img_size_reg-1];
	end
	else if (filter_count_x == 'd1) begin
		sort_in[1] = filter_buffer[0][img_size_reg-2]; sort_in[2] = filter_buffer[0][img_size_reg-1]; sort_in[3] = filter_buffer[0][img_size_reg-1];
		sort_in[4] = filter_buffer[1][img_size_reg-2]; sort_in[5] = filter_buffer[1][img_size_reg-1]; sort_in[6] = filter_buffer[1][img_size_reg-1];
		sort_in[7] = filter_buffer[2][img_size_reg-2]; sort_in[8] = filter_buffer[2][img_size_reg-1]; sort_in[9] = filter_buffer[2][img_size_reg-1];
	end
	else if (filter_count_x == 'd2) begin
		sort_in[1] = filter_buffer[0][filter_count_x-2]; sort_in[2] = filter_buffer[0][filter_count_x-2]; sort_in[3] = filter_buffer[0][filter_count_x-1];
		sort_in[4] = filter_buffer[1][filter_count_x-2]; sort_in[5] = filter_buffer[1][filter_count_x-2]; sort_in[6] = filter_buffer[1][filter_count_x-1];
		sort_in[7] = filter_buffer[2][filter_count_x-2]; sort_in[8] = filter_buffer[2][filter_count_x-2]; sort_in[9] = filter_buffer[2][filter_count_x-1];
	end

	else if (filter_count_y == 'd2 & filter_count_x <= img_size_reg - 'd1) begin
		sort_in[1] = filter_buffer[0][filter_count_x-3]; sort_in[2] = filter_buffer[0][filter_count_x-2]; sort_in[3] = filter_buffer[0][filter_count_x-1];
		sort_in[4] = filter_buffer[1][filter_count_x-3]; sort_in[5] = filter_buffer[1][filter_count_x-2]; sort_in[6] = filter_buffer[1][filter_count_x-1];
		sort_in[7] = filter_buffer[2][filter_count_x-3]; sort_in[8] = filter_buffer[2][filter_count_x-2]; sort_in[9] = filter_buffer[2][filter_count_x-1];
	end

	else begin
		sort_in[1] = filter_buffer[0][filter_count_x-3]; sort_in[2] = filter_buffer[0][filter_count_x-2]; sort_in[3] = filter_buffer[0][filter_count_x-1];
		sort_in[4] = filter_buffer[1][filter_count_x-3]; sort_in[5] = filter_buffer[1][filter_count_x-2]; sort_in[6] = filter_buffer[1][filter_count_x-1];
		sort_in[7] = filter_buffer[2][filter_count_x-3]; sort_in[8] = filter_buffer[2][filter_count_x-2]; sort_in[9] = filter_buffer[2][filter_count_x-1];
	end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        filter_sram_write_en <= 'd0;
    end
    else if(filter_count_y == 'd1 & filter_count_x == 'd1) begin
        filter_sram_write_en <= 1'b1;
    end
    else if(action_flip_filter_done | action_filter_done) begin
        filter_sram_write_en <= 'd0;
    end
end

// sram write data sel
always @(*) begin
	if (ST_in_dly2) begin
		SRAM_data_write_1 = SRAM_out_reg;
	end
	else begin
		case(state)
			ACTION_POOL 	: SRAM_data_write_1 = pool_temp;
			ACTION_NEG		: SRAM_data_write_1 = ~SRAM_data_read_2;
			ACTION_FILTER 	: SRAM_data_write_1 = median;
			ACTION_NEG_FILTER: SRAM_data_write_1 = ~median;
			ACTION_FILP_FILTER:SRAM_data_write_1 = median;
			default 		: SRAM_data_write_1 = SRAM_data_read_2;
		endcase
	end
end

always @(*) begin
	if (ST_in_dly2) begin
		SRAM_data_write_2 = SRAM_out_reg;
	end
	else begin
		case(state)
			ACTION_CONV		: SRAM_data_write_2 = conv_temp;
			ACTION_POOL 	: SRAM_data_write_2 = pool_temp;
			ACTION_NEG		: SRAM_data_write_2 = ~SRAM_data_read_1;
			ACTION_FILTER 	: SRAM_data_write_2 = median;
			ACTION_NEG_FILTER : SRAM_data_write_2 = ~median;
			ACTION_FILP_FILTER: SRAM_data_write_2 = median;
			default 		: SRAM_data_write_2 = SRAM_data_read_1;
		endcase
	end
end


// next state logic
always @(*) begin
    case(state)
        IDLE     		: next_state = in_valid     		? READ_PAT  : IDLE;
        READ_PAT 		: next_state = ~in_valid    		? WAIT_ACT  : READ_PAT;
        WAIT_ACT 		: next_state = in_valid2    		? READ_ACT  : WAIT_ACT;
        READ_ACT 		: next_state = ~in_valid2   		? ST_in     : READ_ACT;

        ST_in 			: next_state = finish_reload 		? (action_num == 'd1 ? ACTION_CONV : action_reg[1]) : ST_in;
		ACTION_POOL 	: next_state = action_pool_done 	? action_reg[current_action_idx+1] : ACTION_POOL;
		ACTION_NEG 		: next_state = action_neg_done 		? action_reg[current_action_idx+1] : ACTION_NEG;
		ACTION_HORIZ	: next_state = action_horiz_done 	? action_reg[current_action_idx+1] : ACTION_HORIZ;
		ACTION_FILTER 	: next_state = action_filter_done 	? action_reg[current_action_idx+1] : ACTION_FILTER;
		ACTION_CONV 	: next_state = action_conv_done 	? ST_out : ACTION_CONV;

		ACTION_NEG_FILTER	: next_state = action_filter_done 		? action_reg[current_action_idx+1] : ACTION_NEG_FILTER;
		ACTION_FILP_FILTER	: next_state = action_flip_filter_done 	? action_reg[current_action_idx+1] : ACTION_FILP_FILTER;

		ST_out			: next_state = output_done 			? ((set_count == 'd7) ? DONE : WAIT_ACT) : ST_out;
		DONE			: next_state = IDLE;
        default  		: next_state = IDLE;
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
        RGB_count_done_reg  <= 1'b0;
        RGB_count_done_reg2 <= 1'b0;
    end
    else begin
        RGB_count_done_reg  <= RGB_count_done;
        RGB_count_done_reg2 <= RGB_count_done_reg;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        gray_max <= 8'd0;
        gray_avg <= 8'd0;
        gray_wgt <= 8'd0;
    end
    else if(RGB_count_done_reg) begin
        gray_max <= (image_reg[0] >= image_reg[1] & image_reg[0] >= image_reg[2]) ? image_reg[0] : 
                    (image_reg[1] >= image_reg[0] & image_reg[1] >= image_reg[2]) ? image_reg[1] : image_reg[2];
        gray_avg <= (image_reg[0] + image_reg[1] + image_reg[2]) / 3;
        gray_wgt <= (image_reg[0] >> 2) + (image_reg[1] >> 1) + (image_reg[2] >> 2);
    end
end


always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		template_count <= 'd0; 
	end
	else if (in_valid) begin
		template_count <= (template_count == 'd9) ? 'd9 : (template_count + 'd1);
	end
	else begin
		template_count <= 'd0; 
	end
end

always @(posedge clk or negedge rst_n)begin
	if (!rst_n) begin
		for (i=0; i<=8; i=i+1) begin
			template_reg[i] <= 'd0;
		end
	end
	else if (in_valid & template_count < 'd9) begin
		template_reg [template_count] <= template;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		img_size_reg <= 'd0;
	end	
	else if (state == ACTION_POOL & action_pool_done) begin
		img_size_reg <= (img_size_reg == 'd16) ? 'd8 : 'd4;
	end
	else if (in_valid & read_image_size_flag) begin
		img_size_reg <= img_size_decode; 
	end
	else if (state == WAIT_ACT) begin
		img_size_reg <= img_size_decode_reg; 
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		img_size_decode_reg <= 'd0;
	end	
	else if (in_valid & read_image_size_flag) begin
		img_size_decode_reg <= img_size_decode; 
	end
end 

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin	
		img_size_temp <= 'd0;
	end
	else if (in_valid)
		img_size_temp <= img_size_reg;
	else if (in_valid2 & action == ACTION_POOL) begin
		img_size_temp <= (img_size_temp == 'd16) ? 'd8 : 'd4;
	end
	else if(state == WAIT_ACT) begin
		img_size_temp <= img_size_reg;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n)begin
		current_action_idx <= 'd1;
	end
	else if (action_done) begin
		current_action_idx <= current_action_idx + 'd1;
	end
	else if (state == ST_out) begin
		current_action_idx <= 'd1;
	end
end

always @(posedge clk or negedge rst_n)  begin
	if (!rst_n) begin
		for (i = 0; i < 8; i = i + 1)begin
			action_reg[i] <= 0;
		end
	end
	else if (in_valid2 & ~(two_ACTION_HORIZ | two_negative)) begin
		if(neg_filter) begin
			action_reg[action_num-'d1] <= ACTION_NEG_FILTER; 
		end
		else if(flip_filter) begin
			action_reg[action_num-'d1] <= ACTION_FILP_FILTER; 
		end
		else begin
			action_reg[action_num] <= action; 
		end
	end
	else if(output_done) begin
		for (i = 0; i < 8; i = i + 1)begin
			action_reg[i] <= 0;
		end
	end
end


always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		action_num <= 'd0;
	end
	else if (in_valid2) begin
		if (img_size_temp == 'd4 & action == ACTION_POOL) begin
			action_num <= action_num;
		end
		else if (flip_filter) begin
			action_num <= action_num;
		end
		else if (neg_filter) begin
			action_num <= action_num;
		end
		else if (action_reg[action_num-1] == ACTION_HORIZ & action == ACTION_HORIZ) begin
			action_num <= action_num - 'd1;
		end
		else if (action_reg[action_num-1] == ACTION_NEG & action == ACTION_NEG) begin
			action_num <= action_num - 'd1;
		end
		else begin
			action_num <= action_num + 'd1;
		end
	end
	else if (output_done) begin
		action_num <= 'd0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		in_valid2_reload <= 1'b0;
	end
	else if (state == ST_in & sram_addr[1] == sram_img_size) begin
		in_valid2_reload <= 1'b1;
	end
	else if(action_idx == action_num) begin
		in_valid2_reload <= 1'b0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		action_reload 		<= 'd0;
		action_idx 			<= 'd1;
	end
	else if (sram_addr[1] == sram_img_size | in_valid2_reload) begin
		action_reload 		<= action_reg[action_idx];
		action_idx 			<= action_idx + 'd1;
	end
	else begin
		action_reload 		<= 'd0;
		action_idx 			<= 'd1;
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
        sram_img_addr <= 8'd0;
    end
    else if(sram_write_en) begin
        sram_img_addr <= sram_img_addr_done ? 8'd0 : (sram_img_addr + 8'd1);
    end
	else if(state == ST_in) begin
		sram_img_addr <= sram_img_addr_done ? 8'd0 : (sram_img_addr + 8'd1);
	end
	else if(output_done) begin
        sram_img_addr <= 8'd0;
    end
end

// read gary sram
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        SRAM_out_reg <= 'd0;
    end
    else begin
        case(action_reg[0])
            ACTION_MAX : SRAM_out_reg <= sram_max_out;
            ACTION_AVG : SRAM_out_reg <= sram_avg_out;
            ACTION_WGT : SRAM_out_reg <= sram_wgt_out;
        endcase
    end
end

// control
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        read_img_done <= 'd0;
    end
    else if(ST_in_dly2 & sram_addr[0] == sram_img_size) begin
        read_img_done <= 'd1;
    end
	else if(output_done) begin
		read_img_done <= 'd0;
	end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ST_in_dly1 <= 'd0;
        ST_in_dly2 <= 'd0;
    end
    else if(sram_addr[0] == sram_img_size | read_img_done) begin
        ST_in_dly1 <= 1'b0;
        ST_in_dly2 <= 1'b0;
    end
	else begin
        ST_in_dly1 <= state == ST_in;
        ST_in_dly2 <= ST_in_dly1;
	end
end

// max pooling
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		pool_ptr <= 'd0;
	end
	else if (cen_1) begin
		pool_ptr <= 'd0;
	end
	else if (state == ACTION_POOL) begin
		pool_ptr  <= pool_ptr + 'd1;
	end
	else begin
		pool_ptr <= 'd0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		pool_temp <= 'd0;
	end
	else if (state == ACTION_POOL) begin
		if (pool_ptr == 1) begin
			pool_temp <= SRAM_read_data;
		end
		else if (SRAM_read_data > pool_temp) begin
			pool_temp <= SRAM_read_data;
		end
	end
end


always @ (posedge clk , negedge rst_n) begin
	if(!rst_n) begin
		pool_idx <= 'd0;
	end
	else if (cen_1) begin
		pool_idx <= 'd0;
	end
	else if (state == ACTION_POOL) begin
		pool_idx <= pool_idx + 'd1;
	end
	else begin
		pool_idx <= 'd0;
	end
end

always @(posedge clk , negedge rst_n) begin	
	if(!rst_n) begin
		wait_pool_count <= 'd0;
	end
	else if (state == ACTION_POOL) begin
		if (cen_1) begin
			wait_pool_count <= 'd0;
		end
		else if (wait_pool_count != 3) begin
			wait_pool_count <= wait_pool_count + 'd1;
		end
		else if (action_pool_done) begin
			wait_pool_count <= 'd0; 
		end
	end
	else begin
		wait_pool_count <= 'd0;
	end
end

always @ (posedge clk , negedge rst_n) begin
	if(!rst_n) begin
		pool_count <= 'd0;
	end
	else if (output_done) begin
		pool_count <= 'd0;
	end
	else if (start) begin
		pool_count <= 'd0;
	end
	else if (pool_count == img_size_reg  & pool_idx == 'd0) begin
		pool_count <= 'd0;
	end
	else if (pool_idx == 'd1 | pool_idx == 'd3) begin
		pool_count <= pool_count + 'd1;
	end
end


// conv result
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)begin
		conv_temp <= 'd0;
	end
	else if (state == ACTION_CONV) begin
		if (wait_conv_out_count == 0) begin
			conv_temp <= 'd0;
        end
		else if (wait_conv_out_count < 'd10 & template_pad[wait_conv_out_count] != 'd0) begin
			conv_temp <= conv_temp + SRAM_read_data * template_pad[wait_conv_out_count]; 
		end
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n)begin
		conv_out_reg <= 'd0;
	end
	else if (state == ACTION_CONV & ~start_reg) begin
		if (wait_conv_out_count == 'd10) begin
			conv_out_reg <= conv_temp;
        end
	end
end
// raster scan order
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		idx_x <= 0;
	end
	else if(start) begin
		idx_x <= 0;
	end
	else if (state == ACTION_FILTER | state == ACTION_NEG_FILTER | state == ACTION_FILP_FILTER) begin
		if (window_idx == 0 & ~start_reg & !start) begin
			idx_x <= (idx_x_done) ? 'd0 : (idx_x + 'd1);
		end
	end	
	else if (state == ACTION_CONV) begin
		if (wait_conv_out_count == 0 & ~start_reg & !start) begin
			idx_x <= (idx_x_done) ? 'd0 : (idx_x + 'd1);
		end
	end	
	else begin
		idx_x <= 'd0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		idx_y <= 0;
	end
	else if(start) begin
		idx_y <= 0;
	end
	else if (state == ACTION_FILTER | state == ACTION_NEG_FILTER | state == ACTION_FILP_FILTER) begin
		if (window_idx == 0 & ~start_reg & !start) begin
			if (idx_x_done) begin
				idx_y <= (idx_y_done) ? 'd0 : (idx_y + 1);
			end
		end
	end
	else if (state == ACTION_CONV) begin
		if (wait_conv_out_count == 0 & ~start_reg & !start) begin
			if (idx_x_done) begin
				idx_y <= (idx_y_done) ? 'd0 : (idx_y + 1);
			end
		end
	end		
	else begin
		idx_y <= 'd0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		wait_conv_out_count <= 'd0;
	end
	else if (state == ACTION_CONV) begin
		if(cen_1) begin
			wait_conv_out_count <= 'd0;
		end
		else begin
			wait_conv_out_count <= (wait_conv_out_count == 'd19) ? 'd0 : (wait_conv_out_count + 'd1);
		end
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		window_idx <= 'd0;
	end
	else if (window_idx == 'd9) begin
		window_idx <= 'd0;
	end
	else if (state == ACTION_FILTER | state == ACTION_NEG_FILTER | state == ACTION_FILP_FILTER) begin
		if (cen_1) begin
			window_idx <= 'd0;
		end
		else begin
			window_idx <= (window_idx == 'd9 | (idx_x != 'd0 & window_idx == 'd3)) ? 'd0 : (window_idx + 'd1);
		end
	end
	else if (state == ACTION_CONV) begin
		if (cen_1) begin
			window_idx <= 'd0;
		end
		else begin
			window_idx <= (window_idx == 'd9) ? 'd0 : (window_idx + 'd1);
		end
	end
	else begin
		window_idx  <= 'd0;
	end
end


always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		flip_count2  <= 'd0;
	end
	else if (cen_1 == 1) begin
		flip_count2  <= 'd0;
	end
	else if(state == ACTION_FILP_FILTER) begin
		if(filter_sram_write_en) begin
			flip_count2  <= (flip_count2 == img_size_reg - 'd1) ? 'd0 : (flip_count2 + 'd1);
		end
	end
	else begin
		flip_count2  <= 'd0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		flip_count  <= 'd0;
	end
	else if (flip_count == img_size_reg - 'd1) begin
		flip_count  <= 'd0;
	end
	else if (cen_1 == 0) begin
		flip_count  <= flip_count + 'd1;
	end
	else begin
		flip_count  <= 'd0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		start_reg <= 'd0;
	end
	else begin 
		start_reg <= start;
	end
end


always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for(i = 1; i < 10; i = i + 1) begin
			sorted_buffer[i] <= 'd0;
		end
	end
	else if (state == ACTION_FILTER | state == ACTION_NEG_FILTER | state == ACTION_FILP_FILTER) begin
		if(idx_x == 'd0) begin
			case(window_idx)
				'd1 : sorted_buffer[5] <= wen_1 ? SRAM_data_read_1 : SRAM_data_read_2;
				'd2 : sorted_buffer[6] <= wen_1 ? SRAM_data_read_1 : SRAM_data_read_2;
				'd3 : sorted_buffer[9] <= wen_1 ? SRAM_data_read_1 : SRAM_data_read_2;
				'd4 : sorted_buffer[8] <= wen_1 ? SRAM_data_read_1 : SRAM_data_read_2;
				'd5 : sorted_buffer[7] <= wen_1 ? SRAM_data_read_1 : SRAM_data_read_2;
				'd6 : sorted_buffer[4] <= wen_1 ? SRAM_data_read_1 : SRAM_data_read_2;
				'd7 : sorted_buffer[1] <= wen_1 ? SRAM_data_read_1 : SRAM_data_read_2;
				'd8 : sorted_buffer[2] <= wen_1 ? SRAM_data_read_1 : SRAM_data_read_2;
				'd9 : sorted_buffer[3] <= wen_1 ? SRAM_data_read_1 : SRAM_data_read_2;
			endcase
		end
		else begin
			case(window_idx)
				'd1 : begin
					sorted_buffer[1] <= wen_1 ? SRAM_data_read_1 : SRAM_data_read_2;
					
					sorted_buffer[4] <= sorted_buffer[1];
					sorted_buffer[5] <= sorted_buffer[2];
					sorted_buffer[6] <= sorted_buffer[3];
					sorted_buffer[7] <= sorted_buffer[4];
					sorted_buffer[8] <= sorted_buffer[5];
					sorted_buffer[9] <= sorted_buffer[6];
				end
				'd2 : sorted_buffer[2] <= wen_1 ? SRAM_data_read_1 : SRAM_data_read_2;
				'd3 : sorted_buffer[3] <= wen_1 ? SRAM_data_read_1 : SRAM_data_read_2;
			endcase
		end
	end
end



// sram addr
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
	    sram_addr[0] <= 'd0;
	    sram_addr[1] <= 'd0;
	end
	else if (ST_in_dly2) begin
		sram_addr[0] <= (sram_addr[0] == sram_img_size) ? 'd0 : (sram_addr[0] + 'd1);  
		sram_addr[1] <= (sram_addr[1] == sram_img_size) ? 'd0 : (sram_addr[1] + 'd1);   
	end
	else begin
		case(state)
			ACTION_CONV : begin
				if (start) begin	
					sram_addr[0] <= 'd0;
					sram_addr[1] <= 'd0;
				end
				else begin
					// write addr
					if (wait_conv_out_count == 0 & ~start_reg & !start) begin
						sram_addr[SRAM2] <= sram_addr[SRAM2] + 'd1;
					end
					// read addr
					case(wait_conv_out_count)
						'd0 : sram_addr[SRAM1] <= sram_addr[SRAM1] + 'd1; 
						'd1 : sram_addr[SRAM1] <= sram_addr[SRAM1] + img_size_reg;
						'd2 : sram_addr[SRAM1] <= sram_addr[SRAM1] - 'd1;
						'd3 : sram_addr[SRAM1] <= sram_addr[SRAM1] - 'd1;
						'd4 : sram_addr[SRAM1] <= sram_addr[SRAM1] - img_size_reg;
						'd5 : sram_addr[SRAM1] <= sram_addr[SRAM1] - img_size_reg;
						'd6 : sram_addr[SRAM1] <= sram_addr[SRAM1] + 'd1; 
						'd7 : sram_addr[SRAM1] <= sram_addr[SRAM1] + 'd1; 
						'd8 : sram_addr[SRAM1] <= sram_addr[SRAM1] + img_size_reg;
					endcase
				end
			end
			ACTION_FILP_FILTER : begin
				if (start) begin	
					sram_addr[SRAM1] <= img_size_reg - 'd1;
					sram_addr[SRAM2] <= 'd0;
				end
				else begin
					// write addr
					if (filter_sram_write_en) begin 
						if (one_row_col_done2) begin	
							sram_addr[SRAM2] <= sram_addr[SRAM2] + (img_size_reg << 1) - 'd1;
						end
						else begin					
							sram_addr[SRAM2] <= sram_addr[SRAM2] - 'd1;
						end
					end
					// read addr
					sram_addr[SRAM1] <= sram_addr[SRAM1] + 'd1;
				end
			end
			ACTION_FILTER, ACTION_NEG_FILTER : begin
				if (start) begin	
					sram_addr[0] <= 'd0;
					sram_addr[1] <= 'd0;
				end
				else begin
					// write addr
					if (filter_sram_write_en) begin 
						sram_addr[SRAM2] <= sram_addr[SRAM2] + 'd1;
					end
					// read addr
					sram_addr[SRAM1] <= sram_addr[SRAM1] + 'd1;
				end
			end
			ACTION_POOL : begin
				if (start) begin
					sram_addr[0] <= 'd0;
					sram_addr[1] <= 'd0;
				end
				else begin
					// write addr
					if (pool_idx == 1 & wait_pool_count==3) begin
						sram_addr[SRAM2] <= sram_addr[SRAM2] + 'd1;
					end
					// read addr
					if (pool_idx == 3 & pool_count == img_size_reg - 'd1) begin
						sram_addr[SRAM1] <= sram_addr[SRAM1] + (img_size_reg + 'd1);
					end
					else begin
						case(pool_idx)
							'd0 : sram_addr[SRAM1] <= sram_addr[SRAM1] + img_size_reg;
							'd1 : sram_addr[SRAM1] <= sram_addr[SRAM1] + 'd1;
							'd2 : sram_addr[SRAM1] <= sram_addr[SRAM1] - img_size_reg;
							'd3 : sram_addr[SRAM1] <= sram_addr[SRAM1] + 'd1;
						endcase
					end
				end
			end
			ACTION_NEG : begin
				if (start) begin
					sram_addr[SRAM1] <= 'd255;
					sram_addr[SRAM2] <= 'd0;
				end
				else begin
					sram_addr[SRAM1] <= sram_addr[SRAM1] + 'd1;
					sram_addr[SRAM2] <= sram_addr[SRAM2] + 'd1;
				end
			end
			ACTION_HORIZ : begin
				if (start) begin
					sram_addr[SRAM2] <= img_size_reg - 'd1;
					sram_addr[SRAM1] <= 'd0;
				end
				else begin
					// write addr
					if (~start_reg) begin 	
						sram_addr[SRAM2] <= sram_addr[SRAM2] + 'd1;
					end
					// read addr
					if (one_row_col_done) begin	
						sram_addr[SRAM1] <= sram_addr[SRAM1] + (img_size_reg << 1) - 'd1;
					end
					else begin					
						sram_addr[SRAM1] <= sram_addr[SRAM1] - 'd1;
					end
				end
			end
			ST_out : begin
				if (start) begin
					sram_addr[0] <= 'd0;							
					sram_addr[1] <= 'd0;  
				end
				else if (output_done) begin
					sram_addr[0] <= 'd0;
					sram_addr[1] <= 'd0;
				end
				else begin
					sram_addr[1] <= sram_addr[1] + 'b1;
				end
			end
		endcase
	end	
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
	    SRAM1 <= 'd0;
	    SRAM2 <= 'd1;
	end
	else if (in_valid2_reload) begin
		SRAM1 <= 'd0;
		SRAM2 <= 'd1;
	end
	else if(action_state & start) begin
		SRAM1 <= SRAM2;
		SRAM2 <= SRAM1; 
	end
	else if(state == ST_out & output_done) begin
		SRAM1 <= 'd0;
		SRAM2 <= 'd1;
	end
end


always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
	    wen_1 <= 'd0;
	    wen_2 <= 'd0;
	end
	else if (in_valid2_reload) begin
		wen_1 <= 'd1;  
		wen_2 <= 'd0;
	end
	else if(action_state & start) begin
		wen_1 <= ~wen_1;
		wen_2 <= ~wen_2;
	end
	else if(state == ST_out) begin
		if (start) begin
			wen_1 <= 'd0;
			wen_2 <= 'd1;
		end
		else if (output_done) begin
			wen_1 <= 'd0;
			wen_2 <= 'd0;
		end
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
	    cen_1 <= 'd0;
	    cen_2 <= 'd0;
	end
	else if (ST_in_dly2 & action_horiz_done) begin
		cen_1 <= 'd1;
		cen_2 <= 'd1;
	end
	else if(action_state | state == ST_out) begin
		if(start) begin
			cen_1 <= 'd0;									
			cen_2 <= 'd0;
		end
		else if(action_done) begin
			cen_1 <= 'd1;
			cen_2 <= 'd1;
		end
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		read_image_size_flag <= 'd1;
	end
	else if (in_valid) begin
		read_image_size_flag <= 'd0;
	end
	else if (state == DONE) begin
		read_image_size_flag <= 'd1;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		set_count <= 'd0;
	end
	else if(state == ST_out & output_done) begin
		set_count <= set_count + 'd1;
	end
	else if(state == DONE) begin
		set_count <= 'd0;
	end
end


// output
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		out_valid <= 1'b0;
	end
	else if(state == ST_out & count_out == 'd19) begin
		out_valid <= 1'b0;
	end
	else if(wait_conv_out_count == 'd10) begin 
		out_valid <= 1'b1;
	end 
end

always @(*) begin
	if(out_valid) begin 
		out_value = conv_out_reg[19-count_out];
	end 
	else begin
		out_value = 1'b0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		count_out <= 'd0;
	end
	else if(out_valid) begin 
		count_out <= (count_out == 'd19) ? 'd0 :( count_out +'d1);
	end 
end

// SRAM
SRAM_256_8  U_SRAM_1  (.CLK(clk), .CS(1'b1), .OE(1'b1), .WEB(wen_1 | cen_1), .A(sram_addr[0]), .DI(SRAM_data_write_1), .DO(SRAM_data_read_1)); // 256 words  /  16 bit
SRAM_256_8  U_SRAM_2  (.CLK(clk), .CS(1'b1), .OE(1'b1), .WEB(wen_2 | cen_2), .A(sram_addr[1]), .DI(SRAM_data_write_2), .DO(SRAM_data_read_2)); // 256 words  /  16 bit

SRAM_256_8 SRAM_IMG_MAX (.CLK(clk), .CS(1'b1), .OE(1'b1), .WEB(~RGB_count_done_reg2), .A(sram_img_addr), .DI(gray_max), .DO(sram_max_out)); // 256 words  /  8 bit
SRAM_256_8 SRAM_IMG_AVG (.CLK(clk), .CS(1'b1), .OE(1'b1), .WEB(~RGB_count_done_reg2), .A(sram_img_addr), .DI(gray_avg), .DO(sram_avg_out)); // 256 words  /  8 bit
SRAM_256_8 SRAM_IMG_WGT (.CLK(clk), .CS(1'b1), .OE(1'b1), .WEB(~RGB_count_done_reg2), .A(sram_img_addr), .DI(gray_wgt), .DO(sram_wgt_out)); // 256 words  /  8 bit


endmodule


module SRAM_256_8 (
    input CLK, CS, OE, WEB,
    input [7:0] A,
    input [7:0] DI,
    output[7:0] DO
);
SRAM_256X8 SRAM_256X8_inst (
    .A0(A[0]), .A1(A[1]), .A2(A[2]), .A3(A[3]), .A4(A[4]), .A5(A[5]), .A6(A[6]), .A7(A[7]),
    .DO0(DO[0]), .DO1(DO[1]), .DO2(DO[2]), .DO3(DO[3]), .DO4(DO[4]), .DO5(DO[5]), .DO6(DO[6]), .DO7(DO[7]),
    .DI0(DI[0]), .DI1(DI[1]), .DI2(DI[2]), .DI3(DI[3]), .DI4(DI[4]), .DI5(DI[5]), .DI6(DI[6]), .DI7(DI[7]),
    .CK(CLK),
    .WEB(WEB),
    .OE(OE), 
    .CS(CS)
);
endmodule


module find_median(
    input  [7:0] in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8,
    output [7:0] median
);

wire [7:0] min1, mid1, max1;
wire [7:0] min2, mid2, max2;
wire [7:0] min3, mid3, max3;
wire [7:0] max_min, mid_mid, min_max;
wire [7:0] final_mid;

sort_3 sort_3_inst_0 (.a(in_0), 	.b(in_1), 	 .c(in_2),     .min(min1), 		.mid(mid1), 	.max(max1));
sort_3 sort_3_inst_2 (.a(in_3), 	.b(in_4), 	 .c(in_5),     .min(min2), 		.mid(mid2), 	.max(max2));
sort_3 sort_3_inst_3 (.a(in_6), 	.b(in_7), 	 .c(in_8),     .min(min3), 		.mid(mid3), 	.max(max3));

sort_3 sort_3_inst_4 (.a(max1), 	.b(max2),	 .c(max3), 	  .min(max_min), 	.mid(), 		.max());
sort_3 sort_3_inst_5 (.a(mid1), 	.b(mid2),	 .c(mid3), 	  .min(), 			.mid(mid_mid), 	.max());
sort_3 sort_3_inst_6 (.a(min1), 	.b(min2),	 .c(min3), 	  .min(), 			.mid(), 		.max(min_max));

sort_3 sort_3_inst_7 (.a(max_min), .b(mid_mid), .c(min_max), .min(), 			.mid(final_mid),.max());

assign median = final_mid;

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

