/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : T-2022.03
// Date      : Fri Jan 10 13:04:45 2025
/////////////////////////////////////////////////////////////


module BB ( clk, rst_n, in_valid, inning, half, action, out_valid, score_A, 
        score_B, result );
  input [1:0] inning;
  input [2:0] action;
  output [7:0] score_A;
  output [7:0] score_B;
  output [1:0] result;
  input clk, rst_n, in_valid, half;
  output out_valid;
  wire   final_continue_reg, out_valid_reg, n96, n97, n98, n99, n100, n101,
         n102, n103, n104, n105, n106, n107, n108, n127, n128, n129, n130,
         n131, n132, n133, n134, n135, n136, n137, n138, n139, n140, n141,
         n142, n143, n144, n145, n146, n147, n148, n149, n150, n151, n152,
         n153, n154, n155, n156, n157, n158, n159, n160, n161, n162, n163,
         n164, n165, n166, n167, n168, n169, n170, n171, n172, n173, n174,
         n175, n176, n177, n178, n179, n180, n181, n182, n183, n184, n185,
         n186, n187, n188, n189, n190, n191, n192, n193, n194, n195, n196,
         n197, n198, n199, n200, n201, n202, n203, n204, n205, n206, n207,
         n208, n209, n210, n211, n212, n213, n214, n215, n216, n217, n218,
         n219, n220;
  wire   [1:0] out_count;
  wire   [2:0] Base;

  DFFHQX1 out_count_reg_0_ ( .D(n105), .CK(clk), .Q(out_count[0]) );
  DFFHQX1 Base_reg_0_ ( .D(n107), .CK(clk), .Q(Base[0]) );
  DFFHQX1 out_count_reg_1_ ( .D(n106), .CK(clk), .Q(out_count[1]) );
  DFFHQX1 Base_reg_2_ ( .D(n98), .CK(clk), .Q(Base[2]) );
  DFFHQX1 final_continue_reg_reg ( .D(n96), .CK(clk), .Q(final_continue_reg)
         );
  DFFTRX1 out_valid_reg_reg ( .D(final_continue_reg), .RN(n213), .CK(clk), .Q(
        out_valid_reg) );
  DFFX1 Base_reg_1_ ( .D(n99), .CK(clk), .Q(Base[1]), .QN(n220) );
  DFFRX1 score_reg_reg_0_ ( .D(n104), .CK(clk), .RN(rst_n), .Q(score_B[0]), 
        .QN(n214) );
  DFFRX1 score_reg_reg_1_ ( .D(n103), .CK(clk), .RN(rst_n), .Q(score_B[1]), 
        .QN(n217) );
  DFFRX1 score_reg_reg_2_ ( .D(n102), .CK(clk), .RN(rst_n), .Q(score_B[2]), 
        .QN(n219) );
  DFFRX1 score_temp_reg_3_ ( .D(n97), .CK(clk), .RN(rst_n), .Q(score_A[3]) );
  DFFRX1 score_temp_reg_0_ ( .D(n108), .CK(clk), .RN(rst_n), .Q(score_A[0]), 
        .QN(n215) );
  DFFRX1 score_temp_reg_1_ ( .D(n101), .CK(clk), .RN(rst_n), .Q(score_A[1]), 
        .QN(n216) );
  DFFRX1 score_temp_reg_2_ ( .D(n100), .CK(clk), .RN(rst_n), .Q(score_A[2]), 
        .QN(n218) );
  NOR2XL U116 ( .A(action[2]), .B(n191), .Y(n135) );
  NOR2XL U117 ( .A(n135), .B(n204), .Y(n151) );
  NOR2XL U118 ( .A(n184), .B(n174), .Y(n180) );
  NOR2XL U119 ( .A(n220), .B(n161), .Y(n168) );
  NOR2XL U120 ( .A(n173), .B(n172), .Y(n182) );
  NOR2XL U121 ( .A(n133), .B(n132), .Y(n142) );
  NOR2X1 U122 ( .A(n171), .B(n158), .Y(n163) );
  NOR2X1 U123 ( .A(n152), .B(n151), .Y(n173) );
  NOR2X1 U124 ( .A(n151), .B(n143), .Y(n196) );
  NOR2X1 U125 ( .A(n205), .B(n147), .Y(n189) );
  NOR2X1 U126 ( .A(n136), .B(n205), .Y(n152) );
  NOR2X1 U127 ( .A(n136), .B(action[2]), .Y(n149) );
  INVXL U128 ( .A(1'b1), .Y(score_B[3]) );
  INVXL U130 ( .A(1'b1), .Y(score_B[4]) );
  INVXL U132 ( .A(1'b1), .Y(score_B[5]) );
  INVXL U134 ( .A(1'b1), .Y(score_B[6]) );
  INVXL U136 ( .A(1'b1), .Y(score_B[7]) );
  INVXL U138 ( .A(1'b1), .Y(score_A[4]) );
  INVXL U140 ( .A(1'b1), .Y(score_A[5]) );
  INVXL U142 ( .A(1'b1), .Y(score_A[6]) );
  INVXL U144 ( .A(1'b1), .Y(score_A[7]) );
  OAI211XL U146 ( .A0(n220), .A1(n202), .B0(n208), .C0(n143), .Y(n146) );
  INVXL U147 ( .A(n152), .Y(n133) );
  AOI21XL U148 ( .A0(n190), .A1(out_count[0]), .B0(out_count[1]), .Y(n132) );
  AOI211XL U149 ( .A0(n183), .A1(n176), .B0(n203), .C0(n171), .Y(n184) );
  INVXL U150 ( .A(n164), .Y(n178) );
  INVXL U151 ( .A(n145), .Y(n185) );
  OAI21XL U152 ( .A0(n208), .A1(n144), .B0(n146), .Y(n145) );
  NAND2XL U153 ( .A(n208), .B(n146), .Y(n187) );
  NAND2XL U154 ( .A(n142), .B(n210), .Y(n188) );
  NOR3XL U155 ( .A(final_continue_reg), .B(out_valid), .C(n200), .Y(n208) );
  INVXL U156 ( .A(n142), .Y(n212) );
  INVXL U157 ( .A(action[0]), .Y(n150) );
  OAI32XL U158 ( .A0(n204), .A1(n191), .A2(action[2]), .B0(n198), .B1(
        out_count[1]), .Y(n164) );
  NOR3XL U159 ( .A(Base[0]), .B(n200), .C(n159), .Y(n199) );
  INVXL U160 ( .A(n140), .Y(n190) );
  NAND2XL U161 ( .A(n150), .B(Base[0]), .Y(n140) );
  NAND2XL U162 ( .A(in_valid), .B(n212), .Y(n200) );
  AND2XL U163 ( .A(out_count[0]), .B(n189), .Y(n193) );
  OR2XL U164 ( .A(n216), .B(n206), .Y(n169) );
  NOR2X1 U165 ( .A(n148), .B(n153), .Y(n175) );
  NAND2XL U166 ( .A(Base[0]), .B(n165), .Y(n148) );
  INVXL U167 ( .A(n159), .Y(n143) );
  NOR2X1 U168 ( .A(action[0]), .B(action[1]), .Y(n147) );
  NAND2XL U169 ( .A(score_A[1]), .B(n217), .Y(n128) );
  AOI22XL U170 ( .A0(score_B[2]), .A1(n218), .B0(n128), .B1(n127), .Y(n130) );
  OAI22XL U171 ( .A0(score_A[0]), .A1(n214), .B0(score_A[1]), .B1(n217), .Y(
        n127) );
  MXI2XL U172 ( .A(n218), .B(score_A[2]), .S0(n169), .Y(n172) );
  XOR2XL U173 ( .A(n167), .B(n168), .Y(n153) );
  OAI2BB1XL U174 ( .A0N(n216), .A1N(n206), .B0(n169), .Y(n167) );
  AOI21XL U175 ( .A0(n148), .A1(n153), .B0(n175), .Y(n183) );
  NAND2XL U176 ( .A(n160), .B(n158), .Y(n174) );
  AOI21XL U177 ( .A0(n220), .A1(n161), .B0(n168), .Y(n165) );
  NAND2BXL U178 ( .AN(n203), .B(n171), .Y(n160) );
  NAND2XL U179 ( .A(n205), .B(n147), .Y(n159) );
  OAI21XL U180 ( .A0(score_A[0]), .A1(Base[2]), .B0(n206), .Y(n161) );
  OAI2BB1XL U181 ( .A0N(n150), .A1N(n191), .B0(n149), .Y(n158) );
  OAI21XL U182 ( .A0(Base[0]), .A1(n165), .B0(n148), .Y(n171) );
  NAND2XL U183 ( .A(action[0]), .B(n136), .Y(n204) );
  NAND2XL U184 ( .A(score_A[0]), .B(Base[2]), .Y(n206) );
  NAND2XL U185 ( .A(Base[2]), .B(Base[0]), .Y(n202) );
  NAND2XL U186 ( .A(action[2]), .B(n147), .Y(n203) );
  NAND2XL U187 ( .A(rst_n), .B(out_valid_reg), .Y(n210) );
  NAND2XL U188 ( .A(n212), .B(n210), .Y(n144) );
  NAND2XL U189 ( .A(n150), .B(n149), .Y(n198) );
  INVXL U190 ( .A(action[2]), .Y(n205) );
  INVXL U191 ( .A(action[1]), .Y(n136) );
  NAND2XL U192 ( .A(action[0]), .B(n152), .Y(n194) );
  AOI211XL U193 ( .A0(score_A[2]), .A1(n219), .B0(score_A[3]), .C0(n130), .Y(
        result[0]) );
  AOI2BB1XL U194 ( .A0N(n215), .A1N(score_B[0]), .B0(n131), .Y(result[1]) );
  NAND4XL U195 ( .A(rst_n), .B(n130), .C(n129), .D(n128), .Y(n131) );
  AOI2BB1XL U196 ( .A0N(n218), .A1N(score_B[2]), .B0(score_A[3]), .Y(n129) );
  OAI222XL U197 ( .A0(n219), .A1(n188), .B0(n187), .B1(n186), .C0(n218), .C1(
        n185), .Y(n100) );
  AOI211XL U198 ( .A0(n184), .A1(n183), .B0(n182), .C0(n181), .Y(n186) );
  OAI22XL U199 ( .A0(n180), .A1(n179), .B0(n178), .B1(n177), .Y(n181) );
  OAI222XL U200 ( .A0(n217), .A1(n188), .B0(n216), .B1(n185), .C0(n187), .C1(
        n157), .Y(n101) );
  AOI211XL U201 ( .A0(n183), .A1(n174), .B0(n156), .C0(n155), .Y(n157) );
  OAI21XL U202 ( .A0(n173), .A1(n167), .B0(n159), .Y(n156) );
  OAI32XL U203 ( .A0(n154), .A1(n203), .A2(n171), .B0(n178), .B1(n153), .Y(
        n155) );
  OAI222XL U204 ( .A0(n214), .A1(n188), .B0(n215), .B1(n185), .C0(n187), .C1(
        n166), .Y(n108) );
  AOI211XL U205 ( .A0(n165), .A1(n164), .B0(n163), .C0(n162), .Y(n166) );
  OAI211XL U206 ( .A0(n173), .A1(n161), .B0(n160), .C0(n159), .Y(n162) );
  OAI2BB1XL U207 ( .A0N(score_A[3]), .A1N(n210), .B0(n209), .Y(n97) );
  NAND4XL U208 ( .A(score_A[2]), .B(score_A[1]), .C(n208), .D(n207), .Y(n209)
         );
  OAI33XL U209 ( .A0(n206), .A1(n205), .A2(n204), .B0(n203), .B1(n202), .B2(
        score_A[0]), .Y(n207) );
  OAI22XL U210 ( .A0(n218), .A1(n212), .B0(n219), .B1(n144), .Y(n102) );
  OAI22XL U211 ( .A0(n216), .A1(n212), .B0(n144), .B1(n217), .Y(n103) );
  OAI22XL U212 ( .A0(n215), .A1(n212), .B0(n144), .B1(n214), .Y(n104) );
  OAI2BB2XL U213 ( .B0(n201), .B1(n200), .A0N(Base[1]), .A1N(n199), .Y(n99) );
  NOR2BXL U214 ( .AN(n198), .B(n197), .Y(n201) );
  OAI22XL U215 ( .A0(n196), .A1(n195), .B0(n220), .B1(n194), .Y(n197) );
  OAI2BB2XL U216 ( .B0(n212), .B1(n211), .A0N(final_continue_reg), .A1N(
        in_valid), .Y(n96) );
  OAI211XL U217 ( .A0(half), .A1(result[0]), .B0(inning[0]), .C0(inning[1]), 
        .Y(n211) );
  OAI31XL U218 ( .A0(n199), .A1(n139), .A2(n200), .B0(n138), .Y(n98) );
  NAND2XL U219 ( .A(n199), .B(Base[2]), .Y(n138) );
  OAI2BB1XL U220 ( .A0N(n150), .A1N(n152), .B0(n196), .Y(n137) );
  OAI21XL U221 ( .A0(n190), .A1(out_count[0]), .B0(n189), .Y(n192) );
  OAI31XL U222 ( .A0(n200), .A1(n195), .A2(n194), .B0(n134), .Y(n107) );
  NAND3XL U223 ( .A(in_valid), .B(n136), .C(n205), .Y(n134) );
  NOR3XL U224 ( .A(n193), .B(n141), .C(n200), .Y(n105) );
  AOI21XL U225 ( .A0(n140), .A1(n189), .B0(out_count[0]), .Y(n141) );
  XOR2XL U226 ( .A(n170), .B(n172), .Y(n177) );
  INVXL U227 ( .A(n210), .Y(out_valid) );
  INVXL U228 ( .A(in_valid), .Y(n213) );
  INVXL U229 ( .A(Base[0]), .Y(n195) );
  INVXL U230 ( .A(out_count[1]), .Y(n191) );
  AOI222XL U231 ( .A0(n137), .A1(Base[1]), .B0(action[0]), .B1(n149), .C0(n164), .C1(Base[0]), .Y(n139) );
  INVXL U232 ( .A(n153), .Y(n154) );
  NOR2BXL U233 ( .AN(n168), .B(n167), .Y(n170) );
  INVXL U234 ( .A(n177), .Y(n176) );
  OAI2BB2XL U235 ( .B0(n176), .B1(n175), .A0N(n176), .A1N(n175), .Y(n179) );
  AOI221XL U236 ( .A0(n193), .A1(out_count[1]), .B0(n192), .B1(n191), .C0(n200), .Y(n106) );
endmodule

