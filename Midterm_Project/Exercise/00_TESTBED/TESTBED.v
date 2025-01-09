/**************************************************************************/
// Copyright (c) 2024, Si2 Lab
// MODULE: TESTBED
// FILE NAME: TESTBED.v
// VERSRION: 1.0
// DATE: Sep, 2024
// AUTHOR: Jui-Huang Tsai
// CODE TYPE: RTL or Behavioral Level (Verilog)
// DESCRIPTION: 2024 Autumn IC Lab / Midterm Project
// MODIFICATION HISTORY:
// Date                 Description
// 
/**************************************************************************/
`timescale 1ns/10ps

`include "PATTERN.v"
`ifdef RTL
    `include "ISP.v"
`endif
`ifdef GATE
    `include "ISP_SYN.v"
`endif

module TESTBED;

// Inputs
wire        clk, rst_n;
wire        in_valid;
wire [3:0]  in_pic_no;
wire [1:0]  in_ratio_mode;
wire        in_mode;
wire        direction;
wire [12:0] addr_dram;
wire [15:0] addr_sd;

// Outputs
wire        out_valid;
wire  [7:0] out_data; 

// axi write address channel 
// src master
wire [3:0]     awid_s_inf;
wire [31:0]     awaddr_s_inf;
wire [2:0]            awsize_s_inf;
wire [1:0]           awburst_s_inf;
wire [7:0]             awlen_s_inf;
wire                 awvalid_s_inf;
// src slave
wire                 awready_s_inf;
// -----------------------------

// axi write data channel 
// src master
wire [127:0]  wdata_s_inf;
wire                   wlast_s_inf;
wire                  wvalid_s_inf;
// src slave
wire                 wready_s_inf;

// axi write response channel 
// src slave
wire [3:0]     bid_s_inf;
wire  [1:0]            bresp_s_inf;
wire                  bvalid_s_inf;
// src master 
wire                  bready_s_inf;
// -----------------------------

// axi read address channel 
// src master
wire [3:0]     arid_s_inf;
wire [31:0] araddr_s_inf;
wire [7:0]             arlen_s_inf;
wire [2:0]            arsize_s_inf;
wire [1:0]           arburst_s_inf;
wire                 arvalid_s_inf;
// src slave
wire                 arready_s_inf;
// -----------------------------

// axi read data channel 
// slave
wire [3:0]      rid_s_inf;
wire [127:0]  rdata_s_inf;
wire [1:0]             rresp_s_inf;
wire                   rlast_s_inf;
wire                  rvalid_s_inf;
// master
wire                  rready_s_inf;

// DRAM


initial begin
    `ifdef RTL
        $fsdbDumpfile("ISP.fsdb");
        $fsdbDumpvars(0,"+mda");
    `endif
    `ifdef GATE
        $sdf_annotate("ISP_SYN.sdf", u_ISP);
        $fsdbDumpfile("ISP_SYN.fsdb");
        $fsdbDumpvars(0,"+mda"); 
    `endif
end

ISP u_ISP(
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
    .in_pic_no(in_pic_no),
    .in_mode(in_mode),
    .in_ratio_mode(in_ratio_mode),
    .out_valid(out_valid),
    .out_data(out_data),

    // axi write address channel 
    // src master
    .awid_s_inf(awid_s_inf),
    .awaddr_s_inf(awaddr_s_inf),
    .awsize_s_inf(awsize_s_inf),
    .awburst_s_inf(awburst_s_inf),
    .awlen_s_inf(awlen_s_inf),
    .awvalid_s_inf(awvalid_s_inf),

    // src slave
    .awready_s_inf(awready_s_inf),

    // axi write data channel 
    // src master
    .wdata_s_inf(wdata_s_inf),
    .wlast_s_inf(wlast_s_inf),
    .wvalid_s_inf(wvalid_s_inf),
    // src slave
    .wready_s_inf(wready_s_inf),

    // axi write response channel 
    // src slave
    .bid_s_inf(bid_s_inf),
    .bresp_s_inf(bresp_s_inf),
    .bvalid_s_inf(bvalid_s_inf),
    // src master 
    .bready_s_inf(bready_s_inf),

    // axi read address channel 
    // src master
    .arid_s_inf(arid_s_inf),
    .araddr_s_inf(araddr_s_inf),
    .arlen_s_inf(arlen_s_inf),
    .arsize_s_inf(arsize_s_inf),
    .arburst_s_inf(arburst_s_inf),
    .arvalid_s_inf(arvalid_s_inf),
    // src slave
    .arready_s_inf(arready_s_inf),

    // axi read data channel 
    // slave
    .rid_s_inf(rid_s_inf),
    .rdata_s_inf(rdata_s_inf),
    .rresp_s_inf(rresp_s_inf),
    .rlast_s_inf(rlast_s_inf),
    .rvalid_s_inf(rvalid_s_inf),
    // master
    .rready_s_inf(rready_s_inf)
);
    
PATTERN u_PATTERN(
    // Inputs
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
    .in_pic_no(in_pic_no),
    .in_mode(in_mode),
    .in_ratio_mode(in_ratio_mode),
    .out_valid(out_valid),
    .out_data(out_data)
);

pseudo_DRAM u_pseudo_DRAM(
    .clk(clk),
    .rst_n(rst_n),
    
    // axi write address channel 
    // src master
    .awid_s_inf(awid_s_inf),
    .awaddr_s_inf(awaddr_s_inf),
    .awsize_s_inf(awsize_s_inf),
    .awburst_s_inf(awburst_s_inf),
    .awlen_s_inf(awlen_s_inf),
    .awvalid_s_inf(awvalid_s_inf),

    // src slave
    .awready_s_inf(awready_s_inf),

    // axi write data channel 
    // src master
    .wdata_s_inf(wdata_s_inf),
    .wlast_s_inf(wlast_s_inf),
    .wvalid_s_inf(wvalid_s_inf),
    // src slave
    .wready_s_inf(wready_s_inf),

    // axi write response channel 
    // src slave
    .bid_s_inf(bid_s_inf),
    .bresp_s_inf(bresp_s_inf),
    .bvalid_s_inf(bvalid_s_inf),
    // src master 
    .bready_s_inf(bready_s_inf),

    // axi read address channel 
    // src master
    .arid_s_inf(arid_s_inf),
    .araddr_s_inf(araddr_s_inf),
    .arlen_s_inf(arlen_s_inf),
    .arsize_s_inf(arsize_s_inf),
    .arburst_s_inf(arburst_s_inf),
    .arvalid_s_inf(arvalid_s_inf),
    // src slave
    .arready_s_inf(arready_s_inf),

    // axi read data channel 
    // slave
    .rid_s_inf(rid_s_inf),
    .rdata_s_inf(rdata_s_inf),
    .rresp_s_inf(rresp_s_inf),
    .rlast_s_inf(rlast_s_inf),
    .rvalid_s_inf(rvalid_s_inf),
    // master
    .rready_s_inf(rready_s_inf)
);

endmodule
