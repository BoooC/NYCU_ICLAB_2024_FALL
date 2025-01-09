// ##############################################################
//   You can modify by your own
//   You can modify by your own
//   You can modify by your own
// ##############################################################

module CHIP(
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


input            clk, rst_n, in_valid, in_valid2;
input     [7:0]  image;
input     [7:0]  template;
input     [1:0]  image_size;
input     [2:0]  action;

output           out_valid;
output           out_value;

//==================================================================
// reg & wire
//==================================================================
wire             C_clk;
wire             C_rst_n;
wire             C_in_valid;
wire             C_in_valid2;

wire     [7:0]   C_image;
wire     [7:0]   C_template;
wire     [1:0]   C_image_size;
wire     [2:0]   C_action;

wire             C_out_valid;
wire             C_out_value;

//==================================================================
// CORE
//==================================================================
TMIP CORE(
	// input signals
    .clk(C_clk),
    .rst_n(C_rst_n),
    .in_valid(C_in_valid), 
    .in_valid2(C_in_valid2),
    
    .image(C_image),
    .template(C_template),
    .image_size(C_image_size),
	.action(C_action),
	
    // output signals
    .out_valid(C_out_valid),
    .out_value(C_out_value)
);

//==================================================================
// INPUT PAD
// Syntax: XMD PAD_NAME ( .O(CORE_PORT_NAME), .I(CHIP_PORT_NAME), .PU(1'b0), .PD(1'b0), .SMT(1'b0));
//     Ex: XMD    I_CLK ( .O(C_clk),          .I(clk),            .PU(1'b0), .PD(1'b0), .SMT(1'b0));
//==================================================================
// You need to finish this part
XMD    I_CLK        ( .O(C_clk),            .I(clk),            .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD    I_RST        ( .O(C_rst_n),          .I(rst_n),          .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD    I_IN_VALID   ( .O(C_in_valid),       .I(in_valid),       .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD    I_IN_VALID2  ( .O(C_in_valid2),      .I(in_valid2),      .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD    I_IMAGE0     ( .O(C_image[0]),       .I(image[0]),       .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD    I_IMAGE1     ( .O(C_image[1]),       .I(image[1]),       .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD    I_IMAGE2     ( .O(C_image[2]),       .I(image[2]),       .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD    I_IMAGE3     ( .O(C_image[3]),       .I(image[3]),       .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD    I_IMAGE4     ( .O(C_image[4]),       .I(image[4]),       .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD    I_IMAGE5     ( .O(C_image[5]),       .I(image[5]),       .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD    I_IMAGE6     ( .O(C_image[6]),       .I(image[6]),       .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD    I_IMAGE7     ( .O(C_image[7]),       .I(image[7]),       .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD    I_TEMPLATE0  ( .O(C_template[0]),    .I(template[0]),    .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD    I_TEMPLATE1  ( .O(C_template[1]),    .I(template[1]),    .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD    I_TEMPLATE2  ( .O(C_template[2]),    .I(template[2]),    .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD    I_TEMPLATE3  ( .O(C_template[3]),    .I(template[3]),    .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD    I_TEMPLATE4  ( .O(C_template[4]),    .I(template[4]),    .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD    I_TEMPLATE5  ( .O(C_template[5]),    .I(template[5]),    .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD    I_TEMPLATE6  ( .O(C_template[6]),    .I(template[6]),    .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD    I_TEMPLATE7  ( .O(C_template[7]),    .I(template[7]),    .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD    I_IMAGE_SIZE0( .O(C_image_size[0]),  .I(image_size[0]),  .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD    I_IMAGE_SIZE1( .O(C_image_size[1]),  .I(image_size[1]),  .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD    I_ACTION0    ( .O(C_action[0]),      .I(action[0]),      .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD    I_ACTION1    ( .O(C_action[1]),      .I(action[1]),      .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD    I_ACTION2    ( .O(C_action[2]),      .I(action[2]),      .PU(1'b0), .PD(1'b0), .SMT(1'b0));

//==================================================================
// OUTPUT PAD
// Syntax: YA2GSD PAD_NAME (.I(CORE_PIN_NAME), .O(PAD_PIN_NAME), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0));
//     Ex: YA2GSD  O_VALID (.I(C_out_valid),   .O(out_valid),    .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0));
//==================================================================
// You need to finish this part
YA2GSD  O_VALID (.I(C_out_valid),   .O(out_valid),    .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0));
YA2GSD  O_VALUE (.I(C_out_value),   .O(out_value),    .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0));

//==================================================================
// I/O power 3.3V pads x? (DVDD + DGND)
// Syntax: VCC3IOD/GNDIOD PAD_NAME ();
//    Ex1: VCC3IOD        VDDP0 ();
//    Ex2: GNDIOD         GNDP0 ();
//==================================================================
// You need to finish this part
VCC3IOD     VDDP0 ();
GNDIOD      GNDP0 ();
VCC3IOD     VDDP1 ();
GNDIOD      GNDP1 ();
VCC3IOD     VDDP2 ();
GNDIOD      GNDP2 ();
// VCC3IOD     VDDP3 ();
// GNDIOD      GNDP3 ();

//==================================================================
// Core power 1.8V pads x? (VDD + GND)
// Syntax: VCCKD/GNDKD PAD_NAME ();
//    Ex1: VCCKD       VDDC0 ();
//    Ex2: GNDKD       GNDC0 ();
//==================================================================
// You need to finish this part
VCCKD       VDDC0 ();
GNDKD       GNDC0 ();
VCCKD       VDDC1 ();
GNDKD       GNDC1 ();
// VCCKD       VDDC2 ();
// GNDKD       GNDC2 ();
// VCCKD       VDDC3 ();
// GNDKD       GNDC3 ();

endmodule

