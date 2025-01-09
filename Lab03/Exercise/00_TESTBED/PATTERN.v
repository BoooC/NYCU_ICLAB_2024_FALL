/**************************************************************************/
// Copyright (c) 2024, OASIS Lab
// MODULE: PATTERN
// FILE NAME: PATTERN.v
// VERSRION: 1.0
// DATE: August 15, 2024
// AUTHOR: Yu-Hsuan Hsu, NYCU IEE
// DESCRIPTION: ICLAB2024FALL / LAB3 / PATTERN
// MODIFICATION HISTORY:
// Date                 Description
// 
/**************************************************************************/

`define CYCLE_TIME 4.0  // Cycle time in nanoseconds
`define PAT_NUM 1000    // Number of patterns
module PATTERN(
	//OUTPUT
	rst_n,
	clk,
	in_valid,
	tetrominoes,
	position,
	//INPUT
	tetris_valid,
	score_valid,
	fail,
	score,
	tetris
);

//---------------------------------------------------------------------
//   PORT DECLARATION          
//---------------------------------------------------------------------
output reg			rst_n, clk, in_valid;
output reg	[2:0]	tetrominoes;
output reg  [2:0]	position;
input 				tetris_valid, score_valid, fail;
input 		[3:0]	score;
input		[71:0]	tetris;
//---------------------------------------------------------------------
//   PARAMETER & INTEGER DECLARATION
//---------------------------------------------------------------------
real CYCLE = `CYCLE_TIME;

parameter tetro_num = 16;
integer patnum = `PAT_NUM;
integer total_patnum, group_number;

integer ret_val;
integer latency;
integer total_latency = 0;
integer local_latency;
integer i_pat, i_tetro;
integer f_in, f_out;
integer out_num_score, out_num_tetris;
integer skip_group;

//---------------------------------------------------------------------
//   REG & WIRE DECLARATION
//---------------------------------------------------------------------
reg	[2:0]	tetrominoes_reg;
reg [2:0]	position_reg;

reg [3:0]  	golden_score;
reg [71:0] 	golden_tetris;
reg 	 	golden_fail;

reg score_valid_reg, tetris_valid_reg;
reg [2:0] tetrominoes_array [0:tetro_num-1];  // Array to store 16 tetrominoes
reg [2:0] position_array 	[0:tetro_num-1];  // Array to store 16 positions
reg [3:0] shape [3:0][0:3];
reg [1:0] map 	[15:0][0:5]; // The 6x12 map, row 0 is always filled with 1, row 12 ~ row 15 are dead zone

integer row, col;
integer row_filled;
integer tetromino_height, tetromino_width;

//---------------------------------------------------------------------
//  CLOCK
//---------------------------------------------------------------------
always #(CYCLE/2.0) clk = ~clk;

//---------------------------------------------------------------------
//  SIMULATION
//---------------------------------------------------------------------
always @(negedge clk) begin
    if ((score_valid === 1'b0 && (score !== 'b0 | fail !== 1'b0 | tetris_valid !== 1'b0)) | (tetris_valid === 1'b0 && tetris !== 'b0)) begin
        $display("**************************************************");
        $display("                    SPEC-5 FAIL                   ");
        $display("**************************************************");
        //repeat (5) #CYCLE;
		$finish;            
    end    
end

initial begin
    // Open input files
    f_in  = $fopen("../00_TESTBED/input.txt", "r");
    if (f_in == 0) begin
        $display("Failed to open input.txt");
        $finish;
    end
	
    //f_out = $fopen("../00_TESTBED/output.txt", "r");
    //if (f_out == 0) begin
    //    $display("Failed to open output.txt");
    //    $finish;
    //end
    
	ret_val = $fscanf(f_in, "%d", total_patnum);

    // Initialize signals
    reset_task;

    // Iterate through each pattern
	for (i_pat = 0; i_pat < `PAT_NUM; i_pat = i_pat + 1) begin
    	ret_val = $fscanf(f_in, "%d", patnum);
		skip_group = 0; 
		reset_map;

		for (i_tetro = 0; i_tetro < tetro_num; i_tetro = i_tetro + 1) begin
            ret_val = $fscanf(f_in, "%d %d", tetrominoes_array[i_tetro], position_array[i_tetro]);
        end

		for (i_tetro = 0; i_tetro < tetro_num; i_tetro = i_tetro + 1) begin
			if (skip_group == 1'b0) begin
				input_task(i_tetro);
				golden_calculate;
				wait_out_valid_task;
				check_ans_task;
                $display("PASS SUB-PATTERN NO.%4d,  SUB-Execution Cycle: %3d", i_tetro, latency);
            end
		end
        $display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32m     Execution Cycle: %3d\033[m", i_pat, local_latency);
	end
	$fclose(f_in);

    YOU_PASS_task;
end


task reset_task; begin 
    rst_n 		= 1'b1;
    in_valid 	= 1'b0;
    tetrominoes = 3'bxxx;
    position 	= 3'bxxx;

    force clk = 0;
	
    #CYCLE; rst_n = 1'b0; 
    #CYCLE; rst_n = 1'b1;
	#(100-CYCLE); // check the output signal 100ns after the reset signal is pulled low
    if (tetris_valid !== 1'b0 || score_valid !== 1'b0 || fail !== 1'b0 || score !== 3'b000 || tetris !== 3'b000) begin
        $display("************************************************************");  
		$display("                        SPEC-4 FAIL                         ");
        $display("************************************************************");  
        $display("                          \033[0;31mFAIL!\033[m                           ");    
        $display("*  Output signals should be 0 after initial RESET at %8t *", $time);
        $display("************************************************************");
        //repeat (2) #CYCLE;
        $finish;
    end
	
    #CYCLE; release clk;
end endtask


integer random_1to4;
task input_task(input integer index); begin
    random_1to4 = 1 + {$random} % (4-1+1);
    repeat (random_1to4) @(negedge clk);

	in_valid 		= 1'b1;
    tetrominoes_reg = tetrominoes_array[index];
    position_reg 	= position_array[index];

	tetrominoes = tetrominoes_reg;
    position 	= position_reg;

	@(negedge clk);
    in_valid 	= 1'b0;
    tetrominoes = 3'bxxx;
    position 	= 3'bxxx;
end endtask


reg latency_count_en;
always @(posedge clk) begin
    if(!rst_n)              latency_count_en = 0;
	else if(in_valid)       latency_count_en = 1;
	else if(score_valid)    latency_count_en = 0;
end

always @(posedge clk) begin
	if(!rst_n) latency = 0;
	else if(latency_count_en) latency = latency + 1;
	else latency = 0;
end

always @(posedge clk) begin
	if(!rst_n) local_latency = 0;
	else if(latency_count_en) local_latency = local_latency + 1;
	else if(tetris_valid) local_latency = 0;
end


task wait_out_valid_task; begin
    while (score_valid !== 1'b1) begin
        if (latency == 999) begin
            $display("************************************************************");  
			$display("                        SPEC-6 FAIL                         ");
            $display("************************************************************");  
            $display("************************************************************");  
            $display("                          \033[0;31mFAIL!\033[m                           ");
            $display("*  The execution latency exceeded 1000 cycles at %8t   *", $time);
            $display("************************************************************");  
            //repeat (1) @(negedge clk);
            $finish;
        end
        @(negedge clk);
    end
    total_latency = total_latency + latency;
end endtask

task check_ans_task; begin
	if (score_valid === 1) begin
		if (score !== golden_score || fail !== golden_fail) begin
            $display("************************************************************");
			$display("                    SPEC-7 FAIL                   ");
			$display("************************************************************");  
			$display("                          \033[0;31mFAIL!\033[m                           ");
			$display(" Expected: Score = %d, Fail = %d", golden_score, golden_fail);
			$display(" Received: Score = %d, Fail = %d", score, fail);
			$display("************************************************************");
			//repeat (10) @(negedge clk);
			$finish;
		end 
		else begin
			if (fail === 1'b1) begin
				skip_group = 1;
			end
		end
	end
	if (tetris_valid === 1) begin
        if (tetris !== golden_tetris) begin
            $display("************************************************************");  
			$display("                    SPEC-7 FAIL                   ");
            $display("************************************************************");  
            $display("                          \033[0;31mFAIL!\033[m                           ");
            $display(" Expected: Tetris = %d", golden_tetris);
            $display(" Received: Tetris = %d", tetris);
            $display("************************************************************");
            repeat (10) @(negedge clk);
            $finish;
        end 
    end
end endtask



always @(negedge clk) begin
	score_valid_reg 	<= score_valid;
	tetris_valid_reg 	<= tetris_valid;
	if((score_valid_reg & score_valid) | (tetris_valid_reg & tetris_valid)) begin
        $display("************************************************************");  
		$display("                    SPEC-8 FAIL                   ");
        $display("************************************************************");  
        $display("                          \033[0;31mFAIL!\033[m                              ");
        $display(" Expected one score  valid output, but found %d", out_num_score);
        $display(" Expected one tetris valid output, but found %d", out_num_tetris);
        $display("************************************************************");  
        //repeat(1) @(negedge clk);
        $finish;
	end
end


task reset_map;
    begin
		golden_score 	= 0;
		golden_fail 	= 0;
		golden_tetris 	= 0;

        for (col = 0; col < 6; col = col + 1) begin
            for (row = 0; row < 16; row = row + 1) begin
				if(row == 0) begin
					 map[row][col] = 1;
				end
                else begin
					map[row][col] = 0;
				end
			end
		end
    end
endtask


task define_shape; begin
    case (tetrominoes_reg)
        3'd0: begin // Square (2x2)
            shape[3][0] = 0; shape[3][1] = 0; shape[3][2] = 0; shape[3][3] = 0;
            shape[2][0] = 0; shape[2][1] = 0; shape[2][2] = 0; shape[2][3] = 0;
            shape[1][0] = 1; shape[1][1] = 1; shape[1][2] = 0; shape[1][3] = 0;
            shape[0][0] = 1; shape[0][1] = 1; shape[0][2] = 0; shape[0][3] = 0;
            tetromino_height = 2;
            tetromino_width = 2;
        end
        3'd1: begin // Vertical line (1x4)
            shape[3][0] = 1; shape[3][1] = 0; shape[3][2] = 0; shape[3][3] = 0;
            shape[2][0] = 1; shape[2][1] = 0; shape[2][2] = 0; shape[2][3] = 0;
            shape[1][0] = 1; shape[1][1] = 0; shape[1][2] = 0; shape[1][3] = 0;
            shape[0][0] = 1; shape[0][1] = 0; shape[0][2] = 0; shape[0][3] = 0;
            tetromino_height = 4;
            tetromino_width = 1;
        end
        3'd2: begin // Horizontal line (4x1)
            shape[3][0] = 0; shape[3][1] = 0; shape[3][2] = 0; shape[3][3] = 0;
            shape[2][0] = 0; shape[2][1] = 0; shape[2][2] = 0; shape[2][3] = 0;
            shape[1][0] = 0; shape[1][1] = 0; shape[1][2] = 0; shape[1][3] = 0;
            shape[0][0] = 1; shape[0][1] = 1; shape[0][2] = 1; shape[0][3] = 1;
            tetromino_height = 1;
            tetromino_width = 4;
        end
        3'd3: begin // Reverse L (180 degrees rotated L)
            shape[3][0] = 0; shape[3][1] = 0; shape[3][2] = 0; shape[3][3] = 0;
            shape[2][0] = 1; shape[2][1] = 1; shape[2][2] = 0; shape[2][3] = 0;
            shape[1][0] = 0; shape[1][1] = 1; shape[1][2] = 0; shape[1][3] = 0;
            shape[0][0] = 0; shape[0][1] = 1; shape[0][2] = 0; shape[0][3] = 0;
            tetromino_height = 3;
            tetromino_width = 2;
        end
        3'd4: begin // L lying on its side
            shape[3][0] = 0; shape[3][1] = 0; shape[3][2] = 0; shape[3][3] = 0;
            shape[2][0] = 0; shape[2][1] = 0; shape[2][2] = 0; shape[2][3] = 0;
            shape[1][0] = 1; shape[1][1] = 1; shape[1][2] = 1; shape[1][3] = 0;
            shape[0][0] = 1; shape[0][1] = 0; shape[0][2] = 0; shape[0][3] = 0;
            tetromino_height = 2;
            tetromino_width = 3;
        end
        3'd5: begin // Standard L
            shape[3][0] = 0; shape[3][1] = 0; shape[3][2] = 0; shape[3][3] = 0;
            shape[2][0] = 1; shape[2][1] = 0; shape[2][2] = 0; shape[2][3] = 0;
            shape[1][0] = 1; shape[1][1] = 0; shape[1][2] = 0; shape[1][3] = 0;
            shape[0][0] = 1; shape[0][1] = 1; shape[0][2] = 0; shape[0][3] = 0;
            tetromino_height = 3;
            tetromino_width = 2;
        end
        3'd6: begin // S-shape (rotated)
            shape[3][0] = 0; shape[3][1] = 0; shape[3][2] = 0; shape[3][3] = 0;
            shape[2][0] = 1; shape[2][1] = 0; shape[2][2] = 0; shape[2][3] = 0;
            shape[1][0] = 1; shape[1][1] = 1; shape[1][2] = 0; shape[1][3] = 0;
            shape[0][0] = 0; shape[0][1] = 1; shape[0][2] = 0; shape[0][3] = 0;
            tetromino_height = 3;
            tetromino_width = 2;
        end
        3'd7: begin // Standard S-shape
            shape[3][0] = 0; shape[3][1] = 0; shape[3][2] = 0; shape[3][3] = 0;
            shape[2][0] = 0; shape[2][1] = 0; shape[2][2] = 0; shape[2][3] = 0;
            shape[1][0] = 0; shape[1][1] = 1; shape[1][2] = 1; shape[1][3] = 0;
            shape[0][0] = 1; shape[0][1] = 1; shape[0][2] = 0; shape[0][3] = 0;
            tetromino_height = 2;
            tetromino_width = 3;
        end
    endcase
end endtask


task golden_calculate;
integer x_pos, cleared_rows;
integer row, col, r, c;
integer scan_en, row_filled;
integer y_drop;
integer i, j;
begin
	// Step 1: Reset and determine x position
	define_shape;
    x_pos = position_reg;

    // Step 2: Scan from the bottom of the map upwards to find a valid drop position
    y_drop = -1;
	scan_en = 1;
    for (row = 16 - tetromino_height; row >= 0; row = row - 1) begin
		if(scan_en) begin
			// Check if the shape can fit in the current row without overlapping any existing blocks in the map
			for (r = 0; r < tetromino_height; r = r + 1) begin
				for (c = 0; c < tetromino_width; c = c + 1) begin
					if (shape[r][c] == 1 && map[row + r][x_pos + c] == 1) begin
						scan_en = 0;
					end
				end
			end
			y_drop = row+1;
		end
	end

    // Place the shape onto the map
    for (r = 0; r < tetromino_height+1; r = r + 1) begin
        for (c = 0; c < tetromino_width; c = c + 1) begin
            if (shape[r][c] == 1) begin
                map[y_drop + r][x_pos + c] = 1;
            end
        end
    end

    // Step 3: Check if any row is fully filled and clear it
    cleared_rows = 0;
	for (i = 0 ; i < 4 ; i = i + 1) begin
		for (row = 1; row < 16; row = row + 1) begin
			row_filled = 1;
			for (col = 0; col < 6; col = col + 1) begin
				if (map[row][col] == 0) begin
					row_filled = 0;
				end
			end

			if (row_filled == 1) begin
				cleared_rows = cleared_rows + 1;
				// Shift rows above down by one row
				for (r = row; r < 15; r = r + 1) begin
					for (col = 0; col < 6; col = col + 1) begin
						map[r][col] = map[r + 1][col];
					end
				end
				// Clear the top row after shifting
				for (col = 0; col < 6; col = col + 1) begin
					map[15][col] = 0;
				end
			end
		end
	end
	
    golden_score = golden_score + cleared_rows;

    for (col = 0; col < 6; col = col + 1) begin
        if (map[15][col] == 1 || map[14][col] == 1 || map[13][col] == 1) begin
            golden_fail = 1;
        end
    end

    if (i_tetro == 15 | golden_fail == 1) begin
		golden_tetris = {map[12][5][0], map[12][4][0], map[12][3][0], map[12][2][0], map[12][1][0], map[12][0][0],
                         map[11][5][0], map[11][4][0], map[11][3][0], map[11][2][0], map[11][1][0], map[11][0][0],
                         map[10][5][0], map[10][4][0], map[10][3][0], map[10][2][0], map[10][1][0], map[10][0][0],
                         map[9][5][0], map[9][4][0], map[9][3][0], map[9][2][0], map[9][1][0], map[9][0][0],
                         map[8][5][0], map[8][4][0], map[8][3][0], map[8][2][0], map[8][1][0], map[8][0][0],
                         map[7][5][0], map[7][4][0], map[7][3][0], map[7][2][0], map[7][1][0], map[7][0][0],
                         map[6][5][0], map[6][4][0], map[6][3][0], map[6][2][0], map[6][1][0], map[6][0][0],
                         map[5][5][0], map[5][4][0], map[5][3][0], map[5][2][0], map[5][1][0], map[5][0][0],
                         map[4][5][0], map[4][4][0], map[4][3][0], map[4][2][0], map[4][1][0], map[4][0][0],
                         map[3][5][0], map[3][4][0], map[3][3][0], map[3][2][0], map[3][1][0], map[3][0][0],
                         map[2][5][0], map[2][4][0], map[2][3][0], map[2][2][0], map[2][1][0], map[2][0][0],
                         map[1][5][0], map[1][4][0], map[1][3][0], map[1][2][0], map[1][1][0], map[1][0][0]};
    end 
	else begin
        golden_tetris = 72'd0;
    end
end

endtask

task YOU_PASS_task; begin
    $display("----------------------------------------------------------------------------------------------------------------------");
    $display("                                                  \033[0;32mCongratulations!\033[m                                                    ");
    $display("                                           You have passed all patterns!                                               ");
    $display("                                           Your execution cycles = %5d cycles                                          ", total_latency);
    $display("                                           Your clock period = %.1f ns                                                 ", CYCLE);
    $display("                                           Total Latency = %.1f ns                                                    ", total_latency * CYCLE);
    $display("----------------------------------------------------------------------------------------------------------------------");
    repeat (2) @(negedge clk);
    $finish;
end endtask

endmodule

