/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : T-2022.03
// Date      : Sat Oct 26 15:07:29 2024
/////////////////////////////////////////////////////////////


module Ramen ( clk, rst_n, in_valid, selling, portion, ramen_type, 
        out_valid_order, success, out_valid_tot, sold_num, total_gain );
  input [1:0] ramen_type;
  output [27:0] sold_num;
  output [14:0] total_gain;
  input clk, rst_n, in_valid, selling, portion;
  output out_valid_order, success, out_valid_tot;
  wire   selling_reg, portion_reg, portion_lack_flag_reg, N1141, N1248, N1249,
         N1250, N1251, N1252, N1253, N1254, N1255, N1256, N1257, N1258, N1259,
         N1260, N1261, N1262, N1263, N1264, N1265, N1266, N1267, N1268, N1269,
         N1270, N1271, N1272, N1273, N1274, N1275, N1277, N1278, N1279, N1280,
         N1281, N1282, N1283, N1284, N1285, N1286, N1287, N1288, N1289, N1290,
         C52_DATA2_4, C52_DATA2_5, C52_DATA2_6, C52_DATA2_7, C51_DATA2_1,
         C51_DATA2_2, C51_DATA2_3, C51_DATA2_4, C51_DATA2_5, C50_DATA2_1,
         C50_DATA2_2, C50_DATA2_3, C50_DATA2_4, C50_DATA2_5, C49_DATA2_2,
         C49_DATA2_3, C49_DATA2_4, C49_DATA2_5, C49_DATA2_6, C49_DATA2_7,
         C48_DATA2_2, C48_DATA2_3, C48_DATA2_4, C48_DATA2_5, C48_DATA2_6,
         C48_DATA2_7, C48_DATA2_8, C48_DATA2_9, n265, n266, n267, n268, n269,
         n270, n271, n272, n273, n274, n275, n276, n277, n278, n279, n280,
         n281, n282, n283, n284, n285, n286, n287, n288, n289, n290, n291,
         n292, n293, n294, n295, n296, n297, n298, n299, n300, n301, n302,
         n303, n304, n305, n306, n307, n308, n309, n310, n312, n313, n314,
         n315, n316, n317, n318, n319, n320, n321, n322, n323, n324, n325,
         n326, n328, n329, n330, n331, n332, n333, n334, n335, n336, n337,
         n338, n339, n340, n341, n342, n343, n344, n345, n346, n347, n348,
         n349, n350, n351, n352, n353, n354, n355, n356, n357, n358, n359,
         n360, n361, n362, n363, n364, n365, n366, n367, n368, n369, n370,
         n371, n372, n373, n375, DP_OP_256J1_122_7686_n81,
         DP_OP_256J1_122_7686_n80, DP_OP_256J1_122_7686_n79,
         DP_OP_256J1_122_7686_n75, DP_OP_256J1_122_7686_n74,
         DP_OP_256J1_122_7686_n67, DP_OP_256J1_122_7686_n66,
         DP_OP_256J1_122_7686_n65, DP_OP_256J1_122_7686_n64,
         DP_OP_256J1_122_7686_n58, DP_OP_256J1_122_7686_n56,
         DP_OP_256J1_122_7686_n55, DP_OP_256J1_122_7686_n53,
         DP_OP_256J1_122_7686_n52, DP_OP_256J1_122_7686_n51,
         DP_OP_256J1_122_7686_n48, DP_OP_256J1_122_7686_n47,
         DP_OP_256J1_122_7686_n46, DP_OP_256J1_122_7686_n45,
         DP_OP_256J1_122_7686_n44, DP_OP_256J1_122_7686_n41,
         DP_OP_256J1_122_7686_n39, DP_OP_256J1_122_7686_n38,
         DP_OP_256J1_122_7686_n37, DP_OP_256J1_122_7686_n34,
         DP_OP_256J1_122_7686_n33, DP_OP_256J1_122_7686_n32,
         DP_OP_256J1_122_7686_n31, DP_OP_256J1_122_7686_n30,
         DP_OP_256J1_122_7686_n29, DP_OP_256J1_122_7686_n28,
         DP_OP_256J1_122_7686_n27, DP_OP_256J1_122_7686_n26,
         DP_OP_256J1_122_7686_n25, DP_OP_256J1_122_7686_n24,
         DP_OP_256J1_122_7686_n23, DP_OP_256J1_122_7686_n22,
         DP_OP_256J1_122_7686_n19, DP_OP_256J1_122_7686_n18,
         DP_OP_256J1_122_7686_n17, DP_OP_188J1_123_5758_n23,
         DP_OP_188J1_123_5758_n21, DP_OP_188J1_123_5758_n14,
         DP_OP_188J1_123_5758_n13, DP_OP_188J1_123_5758_n12,
         DP_OP_188J1_123_5758_n11, DP_OP_188J1_123_5758_n10,
         DP_OP_188J1_123_5758_n9, DP_OP_188J1_123_5758_n8,
         DP_OP_188J1_123_5758_n7, DP_OP_188J1_123_5758_n6,
         DP_OP_207J1_128_6357_n20, DP_OP_207J1_128_6357_n19,
         DP_OP_207J1_128_6357_n14, DP_OP_207J1_128_6357_n13,
         DP_OP_207J1_128_6357_n12, DP_OP_207J1_128_6357_n11,
         DP_OP_207J1_128_6357_n10, DP_OP_207J1_128_6357_n9,
         DP_OP_207J1_128_6357_n8, DP_OP_220J1_133_6885_n15,
         DP_OP_220J1_133_6885_n14, DP_OP_220J1_133_6885_n13,
         DP_OP_220J1_133_6885_n12, DP_OP_220J1_133_6885_n11,
         DP_OP_220J1_133_6885_n10, DP_OP_233J1_138_6117_n15,
         DP_OP_233J1_138_6117_n14, DP_OP_233J1_138_6117_n13,
         DP_OP_233J1_138_6117_n12, DP_OP_233J1_138_6117_n11,
         DP_OP_233J1_138_6117_n10, DP_OP_256J1_143_8148_n12,
         DP_OP_256J1_143_8148_n11, DP_OP_256J1_143_8148_n10,
         DP_OP_256J1_143_8148_n9, DP_OP_256J1_143_8148_n8, intadd_0_A_6_,
         intadd_0_A_5_, intadd_0_A_4_, intadd_0_A_3_, intadd_0_A_2_,
         intadd_0_A_1_, intadd_0_A_0_, intadd_0_B_6_, intadd_0_B_5_,
         intadd_0_B_4_, intadd_0_B_3_, intadd_0_B_2_, intadd_0_B_1_,
         intadd_0_CI, intadd_0_SUM_6_, intadd_0_SUM_5_, intadd_0_SUM_4_,
         intadd_0_SUM_3_, intadd_0_SUM_2_, intadd_0_SUM_1_, intadd_0_SUM_0_,
         intadd_0_n7, intadd_0_n6, intadd_0_n5, intadd_0_n4, intadd_0_n3,
         intadd_0_n2, intadd_0_n1, intadd_1_CI, intadd_1_SUM_2_,
         intadd_1_SUM_1_, intadd_1_SUM_0_, intadd_1_n6, intadd_1_n5,
         intadd_1_n4, intadd_1_n3, intadd_1_n2, intadd_1_n1, intadd_2_CI,
         intadd_2_SUM_5_, intadd_2_SUM_2_, intadd_2_SUM_1_, intadd_2_SUM_0_,
         intadd_2_n6, intadd_2_n5, intadd_2_n4, intadd_2_n3, intadd_2_n2,
         intadd_2_n1, n389, n390, n393, n394, n395, n396, n397, n398, n399,
         n400, n401, n402, n403, n404, n405, n406, n407, n408, n409, n410,
         n411, n412, n413, n414, n415, n416, n417, n418, n419, n420, n421,
         n422, n423, n424, n425, n426, n427, n428, n429, n430, n431, n432,
         n433, n434, n435, n436, n437, n438, n439, n440, n441, n442, n443,
         n444, n445, n446, n447, n448, n449, n450, n451, n452, n453, n454,
         n455, n456, n457, n458, n459, n460, n461, n462, n463, n464, n465,
         n466, n467, n468, n469, n470, n471, n472, n473, n474, n475, n476,
         n477, n478, n479, n480, n481, n482, n483, n484, n485, n486, n487,
         n488, n489, n490, n491, n492, n493, n494, n495, n496, n497, n498,
         n499, n500, n501, n502, n503, n504, n505, n506, n507, n508, n509,
         n510, n511, n512, n513, n514, n515, n516, n517, n518, n519, n520,
         n521, n522, n523, n524, n525, n526, n527, n528, n529, n530, n531,
         n532, n533, n534, n535, n536, n537, n538, n539, n540, n541, n542,
         n543, n544, n545, n546, n547, n548, n549, n550, n551, n552, n553,
         n554, n555, n556, n557, n558, n559, n560, n561, n562, n563, n564,
         n565, n566, n567, n568, n569, n570, n571, n572, n573, n574, n575,
         n576, n577, n578, n579, n580, n581, n582, n583, n584, n585, n586,
         n587, n588, n589, n590, n591, n592, n593, n594, n595, n596, n597,
         n598, n599, n600, n601, n602, n603, n604, n605, n606, n607, n608,
         n609, n610, n611, n612, n613, n614, n615, n616, n617, n618, n619,
         n620, n621, n622, n623, n624, n625, n626, n627, n628, n629, n630,
         n631, n632, n633, n634, n635, n636, n637, n638, n639, n640, n641,
         n642, n643, n644, n645, n646, n647, n648, n649, n650, n651, n652,
         n653, n654, n655, n656, n657, n658, n659, n660, n661, n662, n663,
         n664, n665, n666, n667, n668, n669, n670, n671, n672, n673, n674,
         n675, n676, n677, n678, n679, n680, n681, n682, n683, n684, n685,
         n686, n687, n688, n689, n690, n691, n692, n693, n694, n695, n696,
         n697, n698, n699, n700, n701, n702, n703, n704, n705, n706, n707,
         n708, n709, n710, n711, n712, n713, n714, n715, n716, n717, n718,
         n719, n720, n721, n722, n723, n724, n725, n726, n727, n728, n729,
         n730, n731, n732, n733, n734, n735, n736, n737, n738, n739, n740,
         n741, n742, n743, n744, n745, n746, n747, n748, n749, n750, n751,
         n752, n753, n754, n755, n756, n757, n758, n759, n760, n761, n762,
         n763, n764, n765, n766, n767, n768, n769, n770, n771, n772, n773,
         n774, n775, n776, n777, n778, n779, n780, n781, n782, n783, n784,
         n785, n786, n787, n788, n789, n790, n791, n792, n793, n794, n795,
         n796, n797, n798, n799, n800, n801, n802, n803, n804, n805, n806,
         n807, n808, n809, n810, n811, n812, n813, n814, n815, n816, n817,
         n818, n819, n820, n821, n822, n823, n824, n825, n826, n827, n828,
         n829, n830, n831, n832, n833, n834, n835, n836, n837, n838, n839,
         n840, n841, n842, n843, n844, n845, n846, n847, n848, n849, n850,
         n851, n852, n853, n854, n855, n856, n857, n858, n859, n860, n861,
         n862, n863, n864, n865, n866, n867, n868, n869, n870, n871, n872,
         n873, n874, n875, n876, n877, n878, n879, n880, n881, n882, n883,
         n884, n885, n886, n887;
  wire   [1:0] state;
  wire   [1:0] next_state;
  wire   [1:0] ramen_type_reg;
  wire   [15:1] cur_noodle;
  wire   [15:1] cur_broth;
  wire   [15:1] cur_t_soup;
  wire   [15:0] cur_sause;
  wire   [15:0] cur_miso;
  wire   [6:0] T_count;
  wire   [6:0] TS_count;
  wire   [6:0] M_count;
  wire   [6:0] MS_count;

  DFFRHQXL state_reg_0_ ( .D(next_state[0]), .CK(clk), .RN(n394), .Q(state[0])
         );
  DFFRHQXL state_reg_1_ ( .D(next_state[1]), .CK(clk), .RN(n390), .Q(state[1])
         );
  DFFRHQXL cur_sause_reg_15_ ( .D(n328), .CK(clk), .RN(n394), .Q(cur_sause[15]) );
  DFFRHQXL cur_sause_reg_14_ ( .D(n329), .CK(clk), .RN(n390), .Q(cur_sause[14]) );
  DFFRHQXL cur_sause_reg_13_ ( .D(n330), .CK(clk), .RN(n390), .Q(cur_sause[13]) );
  DFFRHQXL cur_sause_reg_12_ ( .D(n331), .CK(clk), .RN(n390), .Q(cur_sause[12]) );
  DFFRHQXL cur_sause_reg_11_ ( .D(n332), .CK(clk), .RN(n491), .Q(cur_sause[11]) );
  DFFRHQXL cur_sause_reg_9_ ( .D(n334), .CK(clk), .RN(n491), .Q(cur_sause[9])
         );
  DFFRHQXL cur_sause_reg_5_ ( .D(n338), .CK(clk), .RN(n394), .Q(cur_sause[5])
         );
  DFFRHQXL cur_sause_reg_1_ ( .D(n342), .CK(clk), .RN(n394), .Q(cur_sause[1])
         );
  DFFRHQXL cur_sause_reg_0_ ( .D(n343), .CK(clk), .RN(n394), .Q(cur_sause[0])
         );
  DFFRHQXL cur_noodle_reg_15_ ( .D(n359), .CK(clk), .RN(n491), .Q(
        cur_noodle[15]) );
  DFFRHQXL cur_noodle_reg_14_ ( .D(n360), .CK(clk), .RN(n394), .Q(
        cur_noodle[14]) );
  DFFRHQXL cur_noodle_reg_12_ ( .D(n362), .CK(clk), .RN(n491), .Q(
        cur_noodle[12]) );
  DFFRHQXL cur_noodle_reg_8_ ( .D(n366), .CK(clk), .RN(n394), .Q(cur_noodle[8]) );
  DFFRHQXL cur_noodle_reg_4_ ( .D(n370), .CK(clk), .RN(n394), .Q(cur_noodle[4]) );
  DFFRHQXL cur_noodle_reg_3_ ( .D(n371), .CK(clk), .RN(n394), .Q(cur_noodle[3]) );
  DFFRHQXL cur_noodle_reg_2_ ( .D(n372), .CK(clk), .RN(n390), .Q(cur_noodle[2]) );
  DFFRHQXL cur_broth_reg_14_ ( .D(n297), .CK(clk), .RN(n394), .Q(cur_broth[14]) );
  DFFRHQXL cur_broth_reg_12_ ( .D(n299), .CK(clk), .RN(rst_n), .Q(
        cur_broth[12]) );
  DFFRHQXL cur_broth_reg_11_ ( .D(n300), .CK(clk), .RN(rst_n), .Q(
        cur_broth[11]) );
  DFFRHQXL cur_broth_reg_10_ ( .D(n301), .CK(clk), .RN(rst_n), .Q(
        cur_broth[10]) );
  DFFRHQXL cur_broth_reg_9_ ( .D(n302), .CK(clk), .RN(rst_n), .Q(cur_broth[9])
         );
  DFFRHQXL cur_broth_reg_8_ ( .D(n303), .CK(clk), .RN(rst_n), .Q(cur_broth[8])
         );
  DFFRHQXL cur_broth_reg_7_ ( .D(n304), .CK(clk), .RN(rst_n), .Q(cur_broth[7])
         );
  DFFRHQXL cur_broth_reg_6_ ( .D(n305), .CK(clk), .RN(n394), .Q(cur_broth[6])
         );
  DFFRHQXL cur_broth_reg_4_ ( .D(n307), .CK(clk), .RN(n394), .Q(cur_broth[4])
         );
  DFFRHQXL cur_broth_reg_2_ ( .D(n309), .CK(clk), .RN(n394), .Q(cur_broth[2])
         );
  DFFRHQXL cur_broth_reg_1_ ( .D(n310), .CK(clk), .RN(n394), .Q(cur_broth[1])
         );
  DFFRHQXL cur_t_soup_reg_15_ ( .D(n312), .CK(clk), .RN(n394), .Q(
        cur_t_soup[15]) );
  DFFRHQXL cur_t_soup_reg_14_ ( .D(n313), .CK(clk), .RN(n394), .Q(
        cur_t_soup[14]) );
  DFFRHQXL cur_t_soup_reg_12_ ( .D(n315), .CK(clk), .RN(n390), .Q(
        cur_t_soup[12]) );
  DFFRHQXL cur_t_soup_reg_11_ ( .D(n316), .CK(clk), .RN(n491), .Q(
        cur_t_soup[11]) );
  DFFRHQXL cur_t_soup_reg_10_ ( .D(n317), .CK(clk), .RN(n491), .Q(
        cur_t_soup[10]) );
  DFFRHQXL cur_t_soup_reg_7_ ( .D(n320), .CK(clk), .RN(n491), .Q(cur_t_soup[7]) );
  DFFRHQXL cur_t_soup_reg_6_ ( .D(n321), .CK(clk), .RN(n393), .Q(cur_t_soup[6]) );
  DFFRHQXL cur_t_soup_reg_4_ ( .D(n323), .CK(clk), .RN(n394), .Q(cur_t_soup[4]) );
  DFFRHQXL cur_t_soup_reg_2_ ( .D(n325), .CK(clk), .RN(n394), .Q(cur_t_soup[2]) );
  DFFRHQXL cur_t_soup_reg_1_ ( .D(n326), .CK(clk), .RN(n394), .Q(cur_t_soup[1]) );
  DFFRHQXL cur_miso_reg_15_ ( .D(n344), .CK(clk), .RN(n394), .Q(cur_miso[15])
         );
  DFFRHQXL cur_miso_reg_14_ ( .D(n345), .CK(clk), .RN(n390), .Q(cur_miso[14])
         );
  DFFRHQXL cur_miso_reg_13_ ( .D(n346), .CK(clk), .RN(n390), .Q(cur_miso[13])
         );
  DFFRHQXL cur_miso_reg_12_ ( .D(n347), .CK(clk), .RN(n491), .Q(cur_miso[12])
         );
  DFFRHQXL cur_miso_reg_11_ ( .D(n348), .CK(clk), .RN(n491), .Q(cur_miso[11])
         );
  DFFRHQXL cur_miso_reg_10_ ( .D(n349), .CK(clk), .RN(n491), .Q(cur_miso[10])
         );
  DFFRHQXL cur_miso_reg_4_ ( .D(n355), .CK(clk), .RN(n394), .Q(cur_miso[4]) );
  DFFRHQXL cur_miso_reg_2_ ( .D(n357), .CK(clk), .RN(n394), .Q(cur_miso[2]) );
  DFFRHQXL cur_miso_reg_1_ ( .D(n358), .CK(clk), .RN(n394), .Q(cur_miso[1]) );
  DFFRHQXL cur_miso_reg_0_ ( .D(n375), .CK(clk), .RN(n394), .Q(cur_miso[0]) );
  DFFRHQXL selling_reg_reg ( .D(selling), .CK(clk), .RN(n390), .Q(selling_reg)
         );
  DFFRHQXL MS_count_reg_0_ ( .D(n294), .CK(clk), .RN(n390), .Q(MS_count[0]) );
  DFFRHQXL MS_count_reg_1_ ( .D(n293), .CK(clk), .RN(n390), .Q(MS_count[1]) );
  DFFRHQXL MS_count_reg_2_ ( .D(n292), .CK(clk), .RN(n390), .Q(MS_count[2]) );
  DFFRHQXL MS_count_reg_3_ ( .D(n291), .CK(clk), .RN(n390), .Q(MS_count[3]) );
  DFFRHQXL MS_count_reg_4_ ( .D(n290), .CK(clk), .RN(n390), .Q(MS_count[4]) );
  DFFRHQXL MS_count_reg_5_ ( .D(n289), .CK(clk), .RN(n390), .Q(MS_count[5]) );
  DFFRHQXL MS_count_reg_6_ ( .D(n288), .CK(clk), .RN(n390), .Q(MS_count[6]) );
  DFFRHQXL M_count_reg_0_ ( .D(n287), .CK(clk), .RN(n390), .Q(M_count[0]) );
  DFFRHQXL M_count_reg_1_ ( .D(n286), .CK(clk), .RN(n390), .Q(M_count[1]) );
  DFFRHQXL M_count_reg_2_ ( .D(n285), .CK(clk), .RN(n390), .Q(M_count[2]) );
  DFFRHQXL M_count_reg_3_ ( .D(n284), .CK(clk), .RN(n390), .Q(M_count[3]) );
  DFFRHQXL M_count_reg_4_ ( .D(n283), .CK(clk), .RN(n390), .Q(M_count[4]) );
  DFFRHQXL M_count_reg_5_ ( .D(n282), .CK(clk), .RN(n390), .Q(M_count[5]) );
  DFFRHQXL M_count_reg_6_ ( .D(n281), .CK(clk), .RN(n390), .Q(M_count[6]) );
  DFFRHQXL TS_count_reg_0_ ( .D(n280), .CK(clk), .RN(n390), .Q(TS_count[0]) );
  DFFRHQXL TS_count_reg_1_ ( .D(n279), .CK(clk), .RN(n390), .Q(TS_count[1]) );
  DFFRHQXL TS_count_reg_2_ ( .D(n278), .CK(clk), .RN(n390), .Q(TS_count[2]) );
  DFFRHQXL TS_count_reg_3_ ( .D(n277), .CK(clk), .RN(n390), .Q(TS_count[3]) );
  DFFRHQXL TS_count_reg_4_ ( .D(n276), .CK(clk), .RN(n390), .Q(TS_count[4]) );
  DFFRHQXL TS_count_reg_5_ ( .D(n275), .CK(clk), .RN(n390), .Q(TS_count[5]) );
  DFFRHQXL TS_count_reg_6_ ( .D(n274), .CK(clk), .RN(n390), .Q(TS_count[6]) );
  DFFRHQXL T_count_reg_1_ ( .D(n295), .CK(clk), .RN(n390), .Q(T_count[1]) );
  DFFRHQXL T_count_reg_0_ ( .D(n273), .CK(clk), .RN(n390), .Q(T_count[0]) );
  DFFRHQXL T_count_reg_2_ ( .D(n272), .CK(clk), .RN(n390), .Q(T_count[2]) );
  DFFRHQXL T_count_reg_3_ ( .D(n271), .CK(clk), .RN(n390), .Q(T_count[3]) );
  DFFRHQXL T_count_reg_4_ ( .D(n270), .CK(clk), .RN(n390), .Q(T_count[4]) );
  DFFRHQXL T_count_reg_5_ ( .D(n269), .CK(clk), .RN(n390), .Q(T_count[5]) );
  DFFRHQXL T_count_reg_6_ ( .D(n268), .CK(clk), .RN(n390), .Q(T_count[6]) );
  DFFRHQXL portion_lack_flag_reg_reg ( .D(n856), .CK(clk), .RN(n390), .Q(
        portion_lack_flag_reg) );
  DFFRHQXL ramen_type_reg_reg_1_ ( .D(n267), .CK(clk), .RN(n390), .Q(
        ramen_type_reg[1]) );
  DFFRHQXL ramen_type_reg_reg_0_ ( .D(n266), .CK(clk), .RN(n390), .Q(
        ramen_type_reg[0]) );
  DFFRHQXL portion_reg_reg ( .D(n265), .CK(clk), .RN(n390), .Q(portion_reg) );
  CMPR42X1 DP_OP_256J1_122_7686_U34 ( .A(DP_OP_256J1_122_7686_n55), .B(
        DP_OP_256J1_122_7686_n58), .C(DP_OP_256J1_122_7686_n67), .D(
        DP_OP_256J1_122_7686_n81), .ICI(DP_OP_256J1_122_7686_n56), .S(
        DP_OP_256J1_122_7686_n53), .ICO(DP_OP_256J1_122_7686_n51), .CO(
        DP_OP_256J1_122_7686_n52) );
  CMPR42X1 DP_OP_256J1_122_7686_U31 ( .A(DP_OP_256J1_122_7686_n48), .B(
        DP_OP_256J1_122_7686_n51), .C(DP_OP_256J1_122_7686_n66), .D(
        DP_OP_256J1_122_7686_n80), .ICI(intadd_2_n1), .S(
        DP_OP_256J1_122_7686_n46), .ICO(DP_OP_256J1_122_7686_n44), .CO(
        DP_OP_256J1_122_7686_n45) );
  CMPR42X1 DP_OP_256J1_122_7686_U28 ( .A(DP_OP_256J1_122_7686_n47), .B(
        DP_OP_256J1_122_7686_n41), .C(DP_OP_256J1_122_7686_n44), .D(
        DP_OP_256J1_122_7686_n65), .ICI(DP_OP_256J1_122_7686_n79), .S(
        DP_OP_256J1_122_7686_n39), .ICO(DP_OP_256J1_122_7686_n37), .CO(
        DP_OP_256J1_122_7686_n38) );
  CMPR42X1 DP_OP_256J1_122_7686_U25 ( .A(DP_OP_256J1_122_7686_n81), .B(
        DP_OP_256J1_122_7686_n34), .C(DP_OP_256J1_122_7686_n64), .D(
        intadd_1_n1), .ICI(DP_OP_256J1_122_7686_n37), .S(
        DP_OP_256J1_122_7686_n32), .ICO(DP_OP_256J1_122_7686_n30), .CO(
        DP_OP_256J1_122_7686_n31) );
  CMPR42X1 DP_OP_256J1_122_7686_U22 ( .A(DP_OP_256J1_122_7686_n81), .B(
        DP_OP_256J1_122_7686_n29), .C(DP_OP_256J1_122_7686_n80), .D(
        DP_OP_256J1_122_7686_n33), .ICI(DP_OP_256J1_122_7686_n30), .S(
        DP_OP_256J1_122_7686_n28), .ICO(DP_OP_256J1_122_7686_n26), .CO(
        DP_OP_256J1_122_7686_n27) );
  CMPR42X1 DP_OP_256J1_122_7686_U20 ( .A(DP_OP_256J1_122_7686_n75), .B(
        DP_OP_256J1_122_7686_n25), .C(DP_OP_256J1_122_7686_n80), .D(
        DP_OP_256J1_122_7686_n26), .ICI(DP_OP_256J1_122_7686_n79), .S(
        DP_OP_256J1_122_7686_n24), .ICO(DP_OP_256J1_122_7686_n22), .CO(
        DP_OP_256J1_122_7686_n23) );
  CMPR42X1 DP_OP_256J1_122_7686_U18 ( .A(DP_OP_256J1_122_7686_n25), .B(
        DP_OP_256J1_122_7686_n74), .C(intadd_1_n1), .D(
        DP_OP_256J1_122_7686_n22), .ICI(DP_OP_256J1_122_7686_n79), .S(
        DP_OP_256J1_122_7686_n19), .ICO(DP_OP_256J1_122_7686_n17), .CO(
        DP_OP_256J1_122_7686_n18) );
  DFFRHQXL success_reg ( .D(N1141), .CK(clk), .RN(n390), .Q(success) );
  DFFRHQXL total_gain_reg_14_ ( .D(N1290), .CK(clk), .RN(n390), .Q(
        total_gain[14]) );
  DFFRHQXL total_gain_reg_13_ ( .D(N1289), .CK(clk), .RN(n390), .Q(
        total_gain[13]) );
  DFFRHQXL total_gain_reg_12_ ( .D(N1288), .CK(clk), .RN(n390), .Q(
        total_gain[12]) );
  DFFRHQXL total_gain_reg_11_ ( .D(N1287), .CK(clk), .RN(n390), .Q(
        total_gain[11]) );
  DFFRHQXL total_gain_reg_10_ ( .D(N1286), .CK(clk), .RN(n390), .Q(
        total_gain[10]) );
  DFFRHQXL total_gain_reg_9_ ( .D(N1285), .CK(clk), .RN(n390), .Q(
        total_gain[9]) );
  DFFRHQXL total_gain_reg_8_ ( .D(N1284), .CK(clk), .RN(rst_n), .Q(
        total_gain[8]) );
  DFFRHQXL total_gain_reg_7_ ( .D(N1283), .CK(clk), .RN(n394), .Q(
        total_gain[7]) );
  DFFRHQXL total_gain_reg_6_ ( .D(N1282), .CK(clk), .RN(n394), .Q(
        total_gain[6]) );
  DFFRHQXL total_gain_reg_5_ ( .D(N1281), .CK(clk), .RN(n394), .Q(
        total_gain[5]) );
  DFFRHQXL total_gain_reg_4_ ( .D(N1280), .CK(clk), .RN(n390), .Q(
        total_gain[4]) );
  DFFRHQXL total_gain_reg_3_ ( .D(N1279), .CK(clk), .RN(n394), .Q(
        total_gain[3]) );
  DFFRHQXL total_gain_reg_2_ ( .D(N1278), .CK(clk), .RN(n394), .Q(
        total_gain[2]) );
  DFFRHQXL total_gain_reg_1_ ( .D(N1277), .CK(clk), .RN(n394), .Q(
        total_gain[1]) );
  DFFRHQXL out_valid_tot_reg ( .D(n857), .CK(clk), .RN(n390), .Q(out_valid_tot) );
  DFFRHQXL sold_num_reg_27_ ( .D(N1275), .CK(clk), .RN(n394), .Q(sold_num[27])
         );
  DFFRHQXL sold_num_reg_26_ ( .D(N1274), .CK(clk), .RN(n394), .Q(sold_num[26])
         );
  DFFRHQXL sold_num_reg_14_ ( .D(N1262), .CK(clk), .RN(n390), .Q(sold_num[14])
         );
  DFFRHQXL sold_num_reg_13_ ( .D(N1261), .CK(clk), .RN(n390), .Q(sold_num[13])
         );
  DFFRHQXL sold_num_reg_12_ ( .D(N1260), .CK(clk), .RN(n390), .Q(sold_num[12])
         );
  DFFRHQXL sold_num_reg_11_ ( .D(N1259), .CK(clk), .RN(n390), .Q(sold_num[11])
         );
  DFFRHQXL sold_num_reg_10_ ( .D(N1258), .CK(clk), .RN(n390), .Q(sold_num[10])
         );
  DFFRHQXL sold_num_reg_9_ ( .D(N1257), .CK(clk), .RN(n390), .Q(sold_num[9])
         );
  ADDFXL intadd_1_U6 ( .A(M_count[2]), .B(T_count[2]), .CI(intadd_1_n6), .CO(
        intadd_1_n5), .S(intadd_1_SUM_1_) );
  ADDFXL intadd_1_U5 ( .A(M_count[3]), .B(T_count[3]), .CI(intadd_1_n5), .CO(
        intadd_1_n4), .S(intadd_1_SUM_2_) );
  ADDFXL intadd_1_U4 ( .A(M_count[4]), .B(T_count[4]), .CI(intadd_1_n4), .CO(
        intadd_1_n3), .S(DP_OP_256J1_122_7686_n81) );
  ADDFXL intadd_1_U3 ( .A(M_count[5]), .B(T_count[5]), .CI(intadd_1_n3), .CO(
        intadd_1_n2), .S(DP_OP_256J1_122_7686_n80) );
  ADDFXL intadd_1_U2 ( .A(M_count[6]), .B(T_count[6]), .CI(intadd_1_n2), .CO(
        intadd_1_n1), .S(DP_OP_256J1_122_7686_n79) );
  ADDFXL intadd_2_U2 ( .A(MS_count[6]), .B(TS_count[6]), .CI(intadd_2_n2), 
        .CO(intadd_2_n1), .S(intadd_2_SUM_5_) );
  ADDFXL intadd_2_U3 ( .A(MS_count[5]), .B(TS_count[5]), .CI(intadd_2_n3), 
        .CO(intadd_2_n2), .S(DP_OP_256J1_122_7686_n74) );
  ADDFXL intadd_1_U7 ( .A(M_count[1]), .B(T_count[1]), .CI(intadd_1_CI), .CO(
        intadd_1_n6), .S(intadd_1_SUM_0_) );
  ADDFXL intadd_2_U4 ( .A(MS_count[4]), .B(TS_count[4]), .CI(intadd_2_n4), 
        .CO(intadd_2_n3), .S(DP_OP_256J1_122_7686_n75) );
  ADDFXL intadd_2_U5 ( .A(MS_count[3]), .B(TS_count[3]), .CI(intadd_2_n5), 
        .CO(intadd_2_n4), .S(intadd_2_SUM_2_) );
  ADDFXL intadd_2_U6 ( .A(MS_count[2]), .B(TS_count[2]), .CI(intadd_2_n6), 
        .CO(intadd_2_n5), .S(intadd_2_SUM_1_) );
  ADDFXL intadd_2_U7 ( .A(MS_count[1]), .B(TS_count[1]), .CI(intadd_2_CI), 
        .CO(intadd_2_n6), .S(intadd_2_SUM_0_) );
  ADDFXL DP_OP_256J1_143_8148_U19 ( .A(n873), .B(cur_noodle[4]), .CI(
        DP_OP_256J1_143_8148_n12), .CO(DP_OP_256J1_143_8148_n11), .S(
        C52_DATA2_4) );
  ADDFXL DP_OP_188J1_123_5758_U12 ( .A(n881), .B(cur_broth[9]), .CI(
        DP_OP_188J1_123_5758_n7), .CO(DP_OP_188J1_123_5758_n6), .S(C48_DATA2_9) );
  ADDFXL DP_OP_188J1_123_5758_U13 ( .A(n875), .B(cur_broth[8]), .CI(
        DP_OP_188J1_123_5758_n8), .CO(DP_OP_188J1_123_5758_n7), .S(C48_DATA2_8) );
  ADDFXL DP_OP_188J1_123_5758_U14 ( .A(n869), .B(cur_broth[7]), .CI(
        DP_OP_188J1_123_5758_n9), .CO(DP_OP_188J1_123_5758_n8), .S(C48_DATA2_7) );
  ADDFXL DP_OP_188J1_123_5758_U15 ( .A(n880), .B(cur_broth[6]), .CI(
        DP_OP_188J1_123_5758_n10), .CO(DP_OP_188J1_123_5758_n9), .S(
        C48_DATA2_6) );
  ADDFXL DP_OP_188J1_123_5758_U17 ( .A(DP_OP_188J1_123_5758_n21), .B(
        cur_broth[4]), .CI(DP_OP_188J1_123_5758_n12), .CO(
        DP_OP_188J1_123_5758_n11), .S(C48_DATA2_4) );
  ADDFXL DP_OP_188J1_123_5758_U19 ( .A(DP_OP_188J1_123_5758_n23), .B(
        cur_broth[2]), .CI(DP_OP_188J1_123_5758_n14), .CO(
        DP_OP_188J1_123_5758_n13), .S(C48_DATA2_2) );
  ADDFXL DP_OP_207J1_128_6357_U20 ( .A(DP_OP_207J1_128_6357_n20), .B(
        cur_t_soup[3]), .CI(DP_OP_207J1_128_6357_n13), .CO(
        DP_OP_207J1_128_6357_n12), .S(C49_DATA2_3) );
  ADDFXL DP_OP_207J1_128_6357_U18 ( .A(n877), .B(cur_t_soup[5]), .CI(
        DP_OP_207J1_128_6357_n11), .CO(DP_OP_207J1_128_6357_n10), .S(
        C49_DATA2_5) );
  ADDFXL DP_OP_207J1_128_6357_U16 ( .A(n874), .B(cur_t_soup[7]), .CI(
        DP_OP_207J1_128_6357_n9), .CO(DP_OP_207J1_128_6357_n8), .S(C49_DATA2_7) );
  ADDFXL DP_OP_188J1_123_5758_U18 ( .A(n862), .B(cur_broth[3]), .CI(
        DP_OP_188J1_123_5758_n13), .CO(DP_OP_188J1_123_5758_n12), .S(
        C48_DATA2_3) );
  ADDFXL DP_OP_256J1_143_8148_U18 ( .A(n871), .B(cur_noodle[5]), .CI(
        DP_OP_256J1_143_8148_n11), .CO(DP_OP_256J1_143_8148_n10), .S(
        C52_DATA2_5) );
  ADDFXL DP_OP_188J1_123_5758_U16 ( .A(DP_OP_188J1_123_5758_n23), .B(
        cur_broth[5]), .CI(DP_OP_188J1_123_5758_n11), .CO(
        DP_OP_188J1_123_5758_n10), .S(C48_DATA2_5) );
  ADDFXL DP_OP_233J1_138_6117_U22 ( .A(n866), .B(cur_miso[3]), .CI(
        DP_OP_233J1_138_6117_n13), .CO(DP_OP_233J1_138_6117_n12), .S(
        C51_DATA2_3) );
  ADDFXL DP_OP_207J1_128_6357_U21 ( .A(n861), .B(cur_t_soup[2]), .CI(
        DP_OP_207J1_128_6357_n14), .CO(DP_OP_207J1_128_6357_n13), .S(
        C49_DATA2_2) );
  ADDFXL DP_OP_207J1_128_6357_U17 ( .A(n870), .B(cur_t_soup[6]), .CI(
        DP_OP_207J1_128_6357_n10), .CO(DP_OP_207J1_128_6357_n9), .S(
        C49_DATA2_6) );
  ADDFXL DP_OP_207J1_128_6357_U19 ( .A(DP_OP_207J1_128_6357_n19), .B(
        cur_t_soup[4]), .CI(DP_OP_207J1_128_6357_n12), .CO(
        DP_OP_207J1_128_6357_n11), .S(C49_DATA2_4) );
  ADDFXL DP_OP_220J1_133_6885_U23 ( .A(n863), .B(cur_sause[2]), .CI(
        DP_OP_220J1_133_6885_n14), .CO(DP_OP_220J1_133_6885_n13), .S(
        C50_DATA2_2) );
  ADDFXL DP_OP_233J1_138_6117_U21 ( .A(n868), .B(cur_miso[4]), .CI(
        DP_OP_233J1_138_6117_n12), .CO(DP_OP_233J1_138_6117_n11), .S(
        C51_DATA2_4) );
  ADDFXL DP_OP_233J1_138_6117_U23 ( .A(n864), .B(cur_miso[2]), .CI(
        DP_OP_233J1_138_6117_n14), .CO(DP_OP_233J1_138_6117_n13), .S(
        C51_DATA2_2) );
  ADDFXL DP_OP_233J1_138_6117_U24 ( .A(n859), .B(cur_miso[1]), .CI(
        DP_OP_233J1_138_6117_n15), .CO(DP_OP_233J1_138_6117_n14), .S(
        C51_DATA2_1) );
  ADDFXL DP_OP_220J1_133_6885_U24 ( .A(n860), .B(cur_sause[1]), .CI(
        DP_OP_220J1_133_6885_n15), .CO(DP_OP_220J1_133_6885_n14), .S(
        C50_DATA2_1) );
  ADDFXL DP_OP_220J1_133_6885_U20 ( .A(n872), .B(cur_sause[5]), .CI(
        DP_OP_220J1_133_6885_n11), .CO(DP_OP_220J1_133_6885_n10), .S(
        C50_DATA2_5) );
  ADDFXL DP_OP_256J1_143_8148_U16 ( .A(n873), .B(cur_noodle[7]), .CI(
        DP_OP_256J1_143_8148_n9), .CO(DP_OP_256J1_143_8148_n8), .S(C52_DATA2_7) );
  ADDFXL DP_OP_256J1_143_8148_U17 ( .A(n871), .B(cur_noodle[6]), .CI(
        DP_OP_256J1_143_8148_n10), .CO(DP_OP_256J1_143_8148_n9), .S(
        C52_DATA2_6) );
  ADDFXL DP_OP_220J1_133_6885_U21 ( .A(n867), .B(cur_sause[4]), .CI(
        DP_OP_220J1_133_6885_n12), .CO(DP_OP_220J1_133_6885_n11), .S(
        C50_DATA2_4) );
  ADDFXL DP_OP_220J1_133_6885_U22 ( .A(n865), .B(cur_sause[3]), .CI(
        DP_OP_220J1_133_6885_n13), .CO(DP_OP_220J1_133_6885_n12), .S(
        C50_DATA2_3) );
  ADDFXL intadd_0_U7 ( .A(intadd_0_A_1_), .B(intadd_0_B_1_), .CI(intadd_0_n7), 
        .CO(intadd_0_n6), .S(intadd_0_SUM_1_) );
  ADDFXL intadd_0_U8 ( .A(intadd_0_A_0_), .B(DP_OP_256J1_122_7686_n65), .CI(
        intadd_0_CI), .CO(intadd_0_n7), .S(intadd_0_SUM_0_) );
  DFFSX1 out_valid_order_reg ( .D(n858), .CK(clk), .SN(n393), .QN(
        out_valid_order) );
  DFFRX1 cur_noodle_reg_1_ ( .D(n373), .CK(clk), .RN(n491), .Q(cur_noodle[1]), 
        .QN(n876) );
  DFFSX1 cur_noodle_reg_6_ ( .D(n368), .CK(clk), .SN(n394), .Q(cur_noodle[6]), 
        .QN(n882) );
  DFFSX1 cur_sause_reg_3_ ( .D(n340), .CK(clk), .SN(n393), .Q(cur_sause[3]), 
        .QN(n884) );
  DFFSX1 cur_miso_reg_3_ ( .D(n356), .CK(clk), .SN(n394), .Q(cur_miso[3]), 
        .QN(n878) );
  DFFSX1 cur_noodle_reg_5_ ( .D(n369), .CK(clk), .SN(n394), .Q(cur_noodle[5])
         );
  DFFSX1 cur_broth_reg_5_ ( .D(n306), .CK(clk), .SN(n393), .Q(cur_broth[5]) );
  DFFSX1 cur_broth_reg_3_ ( .D(n308), .CK(clk), .SN(n394), .Q(cur_broth[3]) );
  DFFSX1 cur_sause_reg_2_ ( .D(n341), .CK(clk), .SN(n393), .Q(cur_sause[2]) );
  DFFSX1 cur_noodle_reg_7_ ( .D(n367), .CK(clk), .SN(n393), .Q(cur_noodle[7]), 
        .QN(n883) );
  DFFSX1 cur_t_soup_reg_3_ ( .D(n324), .CK(clk), .SN(n394), .Q(cur_t_soup[3]), 
        .QN(n887) );
  DFFSX1 cur_t_soup_reg_5_ ( .D(n322), .CK(clk), .SN(n394), .Q(cur_t_soup[5]), 
        .QN(n879) );
  DFFSX1 cur_sause_reg_4_ ( .D(n339), .CK(clk), .SN(n393), .Q(cur_sause[4]), 
        .QN(n885) );
  DFFSX1 cur_noodle_reg_9_ ( .D(n365), .CK(clk), .SN(n393), .Q(cur_noodle[9])
         );
  DFFSX1 cur_miso_reg_5_ ( .D(n354), .CK(clk), .SN(n394), .Q(cur_miso[5]), 
        .QN(n886) );
  DFFSX1 cur_noodle_reg_10_ ( .D(n364), .CK(clk), .SN(n393), .Q(cur_noodle[10]) );
  DFFSX1 cur_miso_reg_6_ ( .D(n353), .CK(clk), .SN(n393), .Q(cur_miso[6]) );
  DFFSX1 cur_sause_reg_6_ ( .D(n337), .CK(clk), .SN(n393), .Q(cur_sause[6]) );
  DFFSX1 cur_noodle_reg_11_ ( .D(n363), .CK(clk), .SN(n393), .Q(cur_noodle[11]) );
  DFFSX1 cur_miso_reg_7_ ( .D(n352), .CK(clk), .SN(n394), .Q(cur_miso[7]) );
  DFFSX1 cur_sause_reg_7_ ( .D(n336), .CK(clk), .SN(n393), .Q(cur_sause[7]) );
  DFFSX1 cur_miso_reg_8_ ( .D(n351), .CK(clk), .SN(n393), .Q(cur_miso[8]) );
  DFFSX1 cur_sause_reg_8_ ( .D(n335), .CK(clk), .SN(rst_n), .Q(cur_sause[8])
         );
  DFFSX1 cur_t_soup_reg_8_ ( .D(n319), .CK(clk), .SN(n394), .Q(cur_t_soup[8])
         );
  DFFSX1 cur_miso_reg_9_ ( .D(n350), .CK(clk), .SN(n393), .Q(cur_miso[9]) );
  DFFSX1 cur_noodle_reg_13_ ( .D(n361), .CK(clk), .SN(n393), .Q(cur_noodle[13]) );
  DFFSX1 cur_t_soup_reg_9_ ( .D(n318), .CK(clk), .SN(n394), .Q(cur_t_soup[9])
         );
  DFFSX1 cur_sause_reg_10_ ( .D(n333), .CK(clk), .SN(n393), .Q(cur_sause[10])
         );
  DFFSX1 cur_t_soup_reg_13_ ( .D(n314), .CK(clk), .SN(n394), .Q(cur_t_soup[13]) );
  DFFSX1 cur_broth_reg_13_ ( .D(n298), .CK(clk), .SN(n393), .Q(cur_broth[13])
         );
  DFFSX1 cur_broth_reg_15_ ( .D(n296), .CK(clk), .SN(n394), .Q(cur_broth[15])
         );
  DFFRHQXL sold_num_reg_21_ ( .D(N1269), .CK(clk), .RN(rst_n), .Q(sold_num[21]) );
  DFFRHQXL sold_num_reg_6_ ( .D(N1254), .CK(clk), .RN(n393), .Q(sold_num[6])
         );
  DFFRHQXL sold_num_reg_0_ ( .D(N1248), .CK(clk), .RN(n390), .Q(sold_num[0])
         );
  ADDFXL intadd_0_U5 ( .A(intadd_0_A_3_), .B(intadd_0_B_3_), .CI(intadd_0_n5), 
        .CO(intadd_0_n4), .S(intadd_0_SUM_3_) );
  ADDFXL DP_OP_233J1_138_6117_U20 ( .A(n881), .B(cur_miso[5]), .CI(
        DP_OP_233J1_138_6117_n11), .CO(DP_OP_233J1_138_6117_n10), .S(
        C51_DATA2_5) );
  DFFRHQXL sold_num_reg_25_ ( .D(N1273), .CK(clk), .RN(n393), .Q(sold_num[25])
         );
  DFFRHQXL sold_num_reg_24_ ( .D(N1272), .CK(clk), .RN(n393), .Q(sold_num[24])
         );
  DFFRHQXL sold_num_reg_23_ ( .D(N1271), .CK(clk), .RN(n393), .Q(sold_num[23])
         );
  DFFRHQXL sold_num_reg_22_ ( .D(N1270), .CK(clk), .RN(n390), .Q(sold_num[22])
         );
  DFFRHQXL sold_num_reg_20_ ( .D(N1268), .CK(clk), .RN(n393), .Q(sold_num[20])
         );
  DFFRHQXL sold_num_reg_19_ ( .D(N1267), .CK(clk), .RN(n393), .Q(sold_num[19])
         );
  DFFRHQXL sold_num_reg_18_ ( .D(N1266), .CK(clk), .RN(n393), .Q(sold_num[18])
         );
  DFFRHQXL sold_num_reg_17_ ( .D(N1265), .CK(clk), .RN(n393), .Q(sold_num[17])
         );
  DFFRHQXL sold_num_reg_16_ ( .D(N1264), .CK(clk), .RN(n393), .Q(sold_num[16])
         );
  DFFRHQXL sold_num_reg_15_ ( .D(N1263), .CK(clk), .RN(n393), .Q(sold_num[15])
         );
  DFFRHQXL sold_num_reg_8_ ( .D(N1256), .CK(clk), .RN(n393), .Q(sold_num[8])
         );
  DFFRHQXL sold_num_reg_7_ ( .D(N1255), .CK(clk), .RN(n393), .Q(sold_num[7])
         );
  DFFRHQXL sold_num_reg_5_ ( .D(N1253), .CK(clk), .RN(n393), .Q(sold_num[5])
         );
  DFFRHQXL sold_num_reg_4_ ( .D(N1252), .CK(clk), .RN(n393), .Q(sold_num[4])
         );
  DFFRHQXL sold_num_reg_3_ ( .D(N1251), .CK(clk), .RN(n393), .Q(sold_num[3])
         );
  DFFRHQXL sold_num_reg_2_ ( .D(N1250), .CK(clk), .RN(n390), .Q(sold_num[2])
         );
  DFFRHQXL sold_num_reg_1_ ( .D(N1249), .CK(clk), .RN(n393), .Q(sold_num[1])
         );
  ADDFXL intadd_0_U4 ( .A(intadd_0_A_4_), .B(intadd_0_B_4_), .CI(intadd_0_n4), 
        .CO(intadd_0_n3), .S(intadd_0_SUM_4_) );
  ADDFXL intadd_0_U2 ( .A(intadd_0_A_6_), .B(intadd_0_B_6_), .CI(intadd_0_n2), 
        .CO(intadd_0_n1), .S(intadd_0_SUM_6_) );
  ADDFXL intadd_0_U6 ( .A(intadd_0_A_2_), .B(intadd_0_B_2_), .CI(intadd_0_n6), 
        .CO(intadd_0_n5), .S(intadd_0_SUM_2_) );
  ADDFXL intadd_0_U3 ( .A(intadd_0_A_5_), .B(intadd_0_B_5_), .CI(intadd_0_n3), 
        .CO(intadd_0_n2), .S(intadd_0_SUM_5_) );
  NOR2XL U440 ( .A(cur_sause[1]), .B(cur_sause[2]), .Y(n460) );
  NOR2XL U441 ( .A(n812), .B(n822), .Y(intadd_1_CI) );
  NOR2XL U442 ( .A(cur_miso[11]), .B(cur_miso[9]), .Y(n429) );
  NOR2XL U443 ( .A(n799), .B(n583), .Y(n490) );
  NOR2XL U444 ( .A(intadd_2_SUM_2_), .B(n794), .Y(DP_OP_256J1_122_7686_n58) );
  NOR2XL U445 ( .A(cur_t_soup[7]), .B(n445), .Y(n424) );
  NOR2XL U446 ( .A(n807), .B(n817), .Y(intadd_2_CI) );
  NOR2XL U447 ( .A(n493), .B(n479), .Y(n796) );
  NOR2XL U448 ( .A(n471), .B(n453), .Y(n474) );
  NOR2XL U449 ( .A(n856), .B(n477), .Y(n624) );
  NOR2XL U450 ( .A(n798), .B(selling), .Y(n772) );
  NOR2XL U451 ( .A(n796), .B(intadd_2_SUM_2_), .Y(DP_OP_256J1_122_7686_n25) );
  NOR2XL U452 ( .A(n824), .B(n544), .Y(n538) );
  NOR2XL U453 ( .A(n814), .B(n555), .Y(n556) );
  NOR2XL U454 ( .A(n724), .B(n621), .Y(n861) );
  NOR2XL U455 ( .A(n623), .B(n622), .Y(n874) );
  NOR2XL U456 ( .A(n619), .B(n618), .Y(n869) );
  NOR2XL U457 ( .A(n772), .B(n659), .Y(n655) );
  NOR2XL U458 ( .A(n799), .B(n581), .Y(n580) );
  NOR2XL U459 ( .A(intadd_0_n1), .B(n604), .Y(n603) );
  NOR2XL U460 ( .A(state[1]), .B(n569), .Y(n572) );
  NOR2XL U461 ( .A(n823), .B(n548), .Y(n855) );
  NOR2XL U462 ( .A(n850), .B(n848), .Y(n524) );
  NOR2XL U463 ( .A(n843), .B(n841), .Y(n554) );
  NOR2XL U464 ( .A(M_count[1]), .B(n568), .Y(n840) );
  NOR2XL U465 ( .A(MS_count[3]), .B(n537), .Y(n836) );
  NOR2XL U466 ( .A(n591), .B(n584), .Y(n697) );
  NOR2XL U467 ( .A(n856), .B(n551), .Y(n791) );
  NOR2XL U468 ( .A(n585), .B(n584), .Y(n659) );
  NOR2XL U469 ( .A(n808), .B(n826), .Y(N1250) );
  NOR2XL U470 ( .A(n823), .B(n826), .Y(N1271) );
  NOR2XL U471 ( .A(n813), .B(n826), .Y(N1257) );
  NOR2XL U472 ( .A(n827), .B(n826), .Y(N1275) );
  NOR2XL U473 ( .A(portion_lack_flag_reg), .B(n858), .Y(N1141) );
  INVX1 U474 ( .A(n857), .Y(n826) );
  BUFXL U475 ( .A(n491), .Y(n393) );
  INVXL U476 ( .A(n491), .Y(n389) );
  OR2XL U477 ( .A(n709), .B(cur_t_soup[12]), .Y(n706) );
  OR2XL U478 ( .A(n643), .B(cur_sause[10]), .Y(n640) );
  OR2XL U479 ( .A(n677), .B(cur_miso[10]), .Y(n674) );
  OR2XL U480 ( .A(n729), .B(cur_t_soup[11]), .Y(n709) );
  OR2XL U481 ( .A(n712), .B(cur_t_soup[10]), .Y(n729) );
  OR2XL U482 ( .A(n680), .B(cur_miso[9]), .Y(n677) );
  OR2XL U483 ( .A(n646), .B(cur_sause[9]), .Y(n643) );
  OR2XL U484 ( .A(n775), .B(cur_broth[12]), .Y(n771) );
  OR2XL U485 ( .A(n715), .B(cur_t_soup[9]), .Y(n712) );
  OR2XL U486 ( .A(n778), .B(cur_broth[11]), .Y(n775) );
  OR2XL U487 ( .A(n683), .B(cur_miso[8]), .Y(n680) );
  OR2XL U488 ( .A(n649), .B(cur_sause[8]), .Y(n646) );
  OR2XL U489 ( .A(DP_OP_188J1_123_5758_n6), .B(cur_broth[10]), .Y(n778) );
  OR2XL U490 ( .A(DP_OP_207J1_128_6357_n8), .B(cur_t_soup[8]), .Y(n715) );
  OR2XL U491 ( .A(n652), .B(cur_sause[7]), .Y(n649) );
  OR2XL U492 ( .A(DP_OP_233J1_138_6117_n10), .B(cur_miso[6]), .Y(n686) );
  OR2XL U493 ( .A(DP_OP_220J1_133_6885_n10), .B(cur_sause[6]), .Y(n652) );
  NOR2X1 U494 ( .A(intadd_0_SUM_6_), .B(n826), .Y(N1289) );
  NOR2X1 U495 ( .A(intadd_0_SUM_5_), .B(n826), .Y(N1288) );
  NOR2X1 U496 ( .A(intadd_0_SUM_4_), .B(n826), .Y(N1287) );
  NOR2X1 U497 ( .A(M_count[3]), .B(n568), .Y(n843) );
  NOR2X1 U498 ( .A(intadd_0_SUM_3_), .B(n826), .Y(N1286) );
  NOR2X1 U499 ( .A(intadd_0_SUM_2_), .B(n826), .Y(N1285) );
  AND3XL U500 ( .A(n881), .B(n626), .C(n617), .Y(n868) );
  OR2XL U501 ( .A(n623), .B(n620), .Y(n724) );
  AND2XL U502 ( .A(n881), .B(n880), .Y(n873) );
  NOR2X1 U503 ( .A(n625), .B(n624), .Y(n875) );
  NOR2X1 U504 ( .A(T_count[3]), .B(n549), .Y(n854) );
  NOR2X1 U505 ( .A(TS_count[1]), .B(n532), .Y(n847) );
  NOR2X1 U506 ( .A(MS_count[1]), .B(n537), .Y(n833) );
  NOR2X1 U507 ( .A(TS_count[3]), .B(n532), .Y(n850) );
  NOR2X1 U508 ( .A(intadd_0_SUM_1_), .B(n826), .Y(N1284) );
  NOR2X1 U509 ( .A(n791), .B(n772), .Y(n781) );
  NOR2X1 U510 ( .A(n615), .B(n614), .Y(n622) );
  NOR2X1 U511 ( .A(n615), .B(n605), .Y(n618) );
  NOR2X1 U512 ( .A(n505), .B(n791), .Y(n550) );
  NOR2X1 U513 ( .A(intadd_0_SUM_0_), .B(n826), .Y(N1283) );
  NOR2X1 U514 ( .A(n484), .B(n478), .Y(n620) );
  NAND2XL U515 ( .A(n504), .B(n473), .Y(n856) );
  NOR2X1 U516 ( .A(n806), .B(n503), .Y(n502) );
  NOR2X1 U517 ( .A(n804), .B(n826), .Y(N1280) );
  NOR2X1 U518 ( .A(n826), .B(n800), .Y(N1278) );
  NOR2X1 U519 ( .A(n583), .B(n794), .Y(n582) );
  NOR2X1 U520 ( .A(cur_miso[4]), .B(n422), .Y(n423) );
  AOI2BB1XL U521 ( .A0N(n419), .A1N(n785), .B0(n418), .Y(n472) );
  NOR2X1 U522 ( .A(n822), .B(n826), .Y(N1269) );
  NOR2X1 U523 ( .A(n824), .B(n826), .Y(N1273) );
  NOR2X1 U524 ( .A(n825), .B(n826), .Y(N1274) );
  NOR2X1 U525 ( .A(n814), .B(n826), .Y(N1259) );
  NOR2X1 U526 ( .A(n807), .B(n826), .Y(N1248) );
  NOR2X1 U527 ( .A(n811), .B(n826), .Y(N1254) );
  NOR2X1 U528 ( .A(n817), .B(n826), .Y(N1262) );
  NOR2X1 U529 ( .A(n816), .B(n826), .Y(N1261) );
  NOR2X1 U530 ( .A(n815), .B(n826), .Y(N1260) );
  NOR2X1 U531 ( .A(n810), .B(n826), .Y(N1253) );
  NOR2X1 U532 ( .A(n826), .B(n799), .Y(N1277) );
  NOR2X1 U533 ( .A(n821), .B(n826), .Y(N1268) );
  NOR2X1 U534 ( .A(n809), .B(n826), .Y(N1252) );
  NOR2X1 U535 ( .A(n812), .B(n826), .Y(N1255) );
  NOR2X1 U536 ( .A(n819), .B(n826), .Y(N1266) );
  NOR2X1 U537 ( .A(n818), .B(n826), .Y(N1264) );
  NOR2X1 U538 ( .A(n820), .B(n826), .Y(N1267) );
  NOR2X1 U539 ( .A(n440), .B(cur_broth[9]), .Y(n436) );
  AND2XL U540 ( .A(n429), .B(n428), .Y(n444) );
  NOR2X1 U541 ( .A(n885), .B(n458), .Y(n469) );
  NOR2X1 U542 ( .A(n585), .B(ramen_type_reg[1]), .Y(n506) );
  NOR2X1 U543 ( .A(state[1]), .B(n561), .Y(n797) );
  BUFXL U544 ( .A(n491), .Y(n394) );
  INVXL U545 ( .A(n389), .Y(n390) );
  NOR2X1 U546 ( .A(ramen_type_reg[1]), .B(portion_reg), .Y(n485) );
  NOR2X1 U547 ( .A(ramen_type_reg[1]), .B(ramen_type_reg[0]), .Y(n612) );
  OR4XL U548 ( .A(cur_broth[13]), .B(cur_broth[15]), .C(cur_broth[14]), .D(
        cur_broth[10]), .Y(n417) );
  BUFXL U549 ( .A(rst_n), .Y(n491) );
  INVXL U550 ( .A(1'b1), .Y(total_gain[0]) );
  AND2XL U552 ( .A(ramen_type_reg[1]), .B(ramen_type_reg[0]), .Y(n507) );
  AOI21XL U553 ( .A0(n493), .A1(n479), .B0(n796), .Y(n482) );
  NAND2XL U554 ( .A(n486), .B(n485), .Y(n488) );
  INVXL U555 ( .A(n624), .Y(n617) );
  NAND2XL U556 ( .A(n611), .B(ramen_type_reg[1]), .Y(n478) );
  NAND2XL U557 ( .A(n484), .B(n475), .Y(n625) );
  NAND2XL U558 ( .A(n474), .B(n612), .Y(n475) );
  INVXL U559 ( .A(n620), .Y(n627) );
  NAND2XL U560 ( .A(n487), .B(n507), .Y(n626) );
  INVXL U561 ( .A(intadd_1_SUM_0_), .Y(n583) );
  INVXL U562 ( .A(intadd_2_SUM_1_), .Y(n493) );
  AOI22XL U563 ( .A0(M_count[0]), .A1(n822), .B0(T_count[0]), .B1(n812), .Y(
        n794) );
  INVXL U564 ( .A(intadd_2_n1), .Y(DP_OP_256J1_122_7686_n64) );
  INVXL U565 ( .A(intadd_2_SUM_5_), .Y(DP_OP_256J1_122_7686_n65) );
  OAI21XL U566 ( .A0(n856), .A1(n613), .B0(n872), .Y(n623) );
  NAND2XL U567 ( .A(n612), .B(n611), .Y(n613) );
  NAND2BXL U568 ( .AN(ramen_type_reg[0]), .B(ramen_type_reg[1]), .Y(n605) );
  NAND2XL U569 ( .A(n625), .B(portion_reg), .Y(n880) );
  AND2XL U570 ( .A(n627), .B(n488), .Y(n863) );
  OR2XL U571 ( .A(n615), .B(n489), .Y(n872) );
  INVXL U572 ( .A(n506), .Y(n489) );
  AND2XL U573 ( .A(n881), .B(n616), .Y(n862) );
  AND2XL U574 ( .A(n864), .B(n626), .Y(n866) );
  AOI22XL U575 ( .A0(MS_count[0]), .A1(n817), .B0(TS_count[0]), .B1(n807), .Y(
        n799) );
  OR2XL U576 ( .A(n671), .B(cur_miso[12]), .Y(n668) );
  OR2XL U577 ( .A(n668), .B(cur_miso[13]), .Y(n665) );
  AOI2BB1XL U578 ( .A0N(n592), .A1N(n591), .B0(n772), .Y(n691) );
  NOR3XL U579 ( .A(n621), .B(n620), .C(n622), .Y(n870) );
  OR2XL U580 ( .A(n706), .B(cur_t_soup[13]), .Y(n703) );
  AOI21XL U581 ( .A0(n791), .A1(n605), .B0(n772), .Y(n730) );
  INVXL U582 ( .A(n618), .Y(n881) );
  NAND2XL U583 ( .A(n876), .B(n609), .Y(n758) );
  INVXL U584 ( .A(n873), .Y(n609) );
  AND2XL U585 ( .A(cur_noodle[2]), .B(n758), .Y(n762) );
  AND2XL U586 ( .A(n627), .B(n626), .Y(n694) );
  OR2XL U587 ( .A(n637), .B(cur_sause[12]), .Y(n634) );
  OR2XL U588 ( .A(n634), .B(cur_sause[13]), .Y(n631) );
  NOR3XL U589 ( .A(cur_miso[14]), .B(cur_miso[10]), .C(n397), .Y(n428) );
  NAND2XL U590 ( .A(cur_broth[8]), .B(cur_broth[7]), .Y(n435) );
  NAND3XL U591 ( .A(cur_miso[3]), .B(cur_miso[1]), .C(cur_miso[2]), .Y(n430)
         );
  NOR3XL U592 ( .A(cur_miso[6]), .B(cur_miso[8]), .C(cur_miso[7]), .Y(n443) );
  NAND2XL U593 ( .A(n401), .B(n400), .Y(n445) );
  NOR4XL U594 ( .A(cur_t_soup[11]), .B(cur_t_soup[10]), .C(cur_t_soup[9]), .D(
        cur_t_soup[8]), .Y(n401) );
  NOR4XL U595 ( .A(cur_t_soup[15]), .B(cur_t_soup[14]), .C(cur_t_soup[13]), 
        .D(cur_t_soup[12]), .Y(n400) );
  OR3XL U596 ( .A(cur_broth[12]), .B(cur_broth[11]), .C(n417), .Y(n440) );
  NOR3XL U597 ( .A(cur_broth[4]), .B(cur_broth[5]), .C(cur_broth[6]), .Y(n439)
         );
  INVXL U598 ( .A(n445), .Y(n449) );
  AOI21XL U599 ( .A0(n799), .A1(n583), .B0(n490), .Y(n495) );
  INVXL U600 ( .A(intadd_2_SUM_2_), .Y(n803) );
  AOI21XL U601 ( .A0(n583), .A1(n794), .B0(n582), .Y(DP_OP_256J1_122_7686_n55)
         );
  OAI2BB1XL U602 ( .A0N(intadd_2_SUM_2_), .A1N(n796), .B0(n795), .Y(
        DP_OP_256J1_122_7686_n29) );
  NOR3XL U603 ( .A(cur_t_soup[5]), .B(cur_t_soup[4]), .C(cur_t_soup[3]), .Y(
        n450) );
  AOI31XL U604 ( .A0(n444), .A1(n443), .A2(n442), .B0(n464), .Y(n454) );
  OAI211XL U605 ( .A0(cur_miso[3]), .A1(n437), .B0(cur_miso[5]), .C0(
        cur_miso[4]), .Y(n442) );
  NAND2XL U606 ( .A(n698), .B(n693), .Y(n437) );
  AND2XL U607 ( .A(n627), .B(n617), .Y(n864) );
  NAND2XL U608 ( .A(n880), .B(n617), .Y(n619) );
  OR2XL U609 ( .A(n743), .B(cur_noodle[12]), .Y(n740) );
  OR2XL U610 ( .A(n686), .B(cur_miso[7]), .Y(n683) );
  OR2XL U611 ( .A(n749), .B(cur_noodle[10]), .Y(n746) );
  OR2XL U612 ( .A(n752), .B(cur_noodle[9]), .Y(n749) );
  OR2XL U613 ( .A(DP_OP_256J1_143_8148_n8), .B(cur_noodle[8]), .Y(n752) );
  AND2XL U614 ( .A(n877), .B(n872), .Y(n867) );
  INVXL U615 ( .A(n772), .Y(n608) );
  INVXL U616 ( .A(n794), .Y(n577) );
  INVXL U617 ( .A(intadd_1_SUM_1_), .Y(n497) );
  INVXL U618 ( .A(DP_OP_256J1_122_7686_n25), .Y(n795) );
  MXI2XL U619 ( .A(DP_OP_256J1_122_7686_n65), .B(intadd_2_SUM_5_), .S0(
        DP_OP_256J1_122_7686_n18), .Y(n600) );
  XOR2XL U620 ( .A(intadd_1_n1), .B(DP_OP_256J1_122_7686_n17), .Y(n601) );
  OR2XL U621 ( .A(n674), .B(cur_miso[11]), .Y(n671) );
  NAND2XL U622 ( .A(n727), .B(n724), .Y(DP_OP_207J1_128_6357_n14) );
  NAND2XL U623 ( .A(n790), .B(n618), .Y(DP_OP_188J1_123_5758_n14) );
  OR2XL U624 ( .A(n771), .B(cur_broth[13]), .Y(n768) );
  NAND2XL U625 ( .A(n764), .B(n610), .Y(DP_OP_256J1_143_8148_n12) );
  INVXL U626 ( .A(n762), .Y(n610) );
  INVXL U627 ( .A(n781), .Y(n793) );
  OR2XL U628 ( .A(n746), .B(cur_noodle[11]), .Y(n743) );
  OR2XL U629 ( .A(n740), .B(cur_noodle[13]), .Y(n737) );
  OR2XL U630 ( .A(n694), .B(cur_sause[0]), .Y(DP_OP_220J1_133_6885_n15) );
  AND2XL U631 ( .A(n863), .B(n872), .Y(n860) );
  INVXL U632 ( .A(n655), .Y(n661) );
  OR2XL U633 ( .A(n640), .B(cur_sause[11]), .Y(n637) );
  OAI2BB1XL U634 ( .A0N(n697), .A1N(n667), .B0(n666), .Y(n345) );
  NAND2XL U635 ( .A(n691), .B(cur_miso[14]), .Y(n666) );
  OAI2BB1XL U636 ( .A0N(n733), .A1N(n705), .B0(n704), .Y(n313) );
  NAND2XL U637 ( .A(n730), .B(cur_t_soup[14]), .Y(n704) );
  OAI2BB1XL U638 ( .A0N(n659), .A1N(n633), .B0(n632), .Y(n329) );
  NAND2XL U639 ( .A(cur_sause[14]), .B(n655), .Y(n632) );
  INVXL U640 ( .A(n480), .Y(n483) );
  OAI21XL U641 ( .A0(intadd_2_SUM_0_), .A1(n490), .B0(n479), .Y(n480) );
  NAND2XL U642 ( .A(intadd_2_SUM_0_), .B(n490), .Y(n479) );
  OAI211XL U643 ( .A0(n692), .A1(n399), .B0(n443), .C0(n398), .Y(n404) );
  OAI31XL U644 ( .A0(cur_miso[1]), .A1(cur_miso[0]), .A2(cur_miso[2]), .B0(
        cur_miso[3]), .Y(n399) );
  INVXL U645 ( .A(n422), .Y(n398) );
  AOI211XL U646 ( .A0(n460), .A1(n658), .B0(n884), .C0(n885), .Y(n405) );
  NAND2XL U647 ( .A(n886), .B(n444), .Y(n422) );
  NAND2BXL U648 ( .AN(n856), .B(ramen_type_reg[0]), .Y(n484) );
  NAND2BXL U649 ( .AN(n856), .B(portion_reg), .Y(n615) );
  NAND2XL U650 ( .A(n625), .B(n611), .Y(n616) );
  AND2XL U651 ( .A(n616), .B(n617), .Y(n871) );
  OAI31XL U652 ( .A0(cur_noodle[3]), .A1(cur_noodle[4]), .A2(cur_noodle[2]), 
        .B0(cur_noodle[5]), .Y(n406) );
  AOI211XL U653 ( .A0(cur_noodle[4]), .A1(n407), .B0(cur_noodle[6]), .C0(
        cur_noodle[5]), .Y(n410) );
  OAI2BB1XL U654 ( .A0N(cur_noodle[2]), .A1N(cur_noodle[1]), .B0(n764), .Y(
        n407) );
  NOR4XL U655 ( .A(cur_noodle[15]), .B(cur_noodle[14]), .C(cur_noodle[12]), 
        .D(cur_noodle[11]), .Y(n408) );
  NAND2XL U656 ( .A(cur_t_soup[2]), .B(cur_t_soup[1]), .Y(n446) );
  AOI31XL U657 ( .A0(n459), .A1(n452), .A2(n451), .B0(ramen_type_reg[1]), .Y(
        n453) );
  OAI211XL U658 ( .A0(n450), .A1(n721), .B0(n449), .C0(portion_reg), .Y(n451)
         );
  OAI31XL U659 ( .A0(n433), .A1(n432), .A2(n431), .B0(n611), .Y(n434) );
  INVXL U660 ( .A(n443), .Y(n433) );
  OAI211XL U661 ( .A0(n692), .A1(n430), .B0(n429), .C0(n886), .Y(n431) );
  OAI211XL U662 ( .A0(n472), .A1(portion_reg), .B0(n436), .C0(n421), .Y(n452)
         );
  NAND4XL U663 ( .A(cur_broth[4]), .B(cur_broth[5]), .C(cur_broth[6]), .D(n420), .Y(n421) );
  AOI2BB1XL U664 ( .A0N(cur_broth[2]), .A1N(cur_broth[3]), .B0(n435), .Y(n420)
         );
  AOI211XL U665 ( .A0(portion_reg), .A1(n415), .B0(n471), .C0(n414), .Y(n427)
         );
  AOI211XL U666 ( .A0(n413), .A1(cur_sause[0]), .B0(cur_sause[4]), .C0(n468), 
        .Y(n414) );
  OAI211XL U667 ( .A0(n405), .A1(n468), .B0(n404), .C0(n466), .Y(n415) );
  INVXL U668 ( .A(n458), .Y(n413) );
  OAI211XL U669 ( .A0(n696), .A1(n430), .B0(n423), .C0(n443), .Y(n426) );
  AOI21XL U670 ( .A0(n439), .A1(n438), .B0(n786), .Y(n441) );
  OAI21XL U671 ( .A0(cur_broth[2]), .A1(cur_broth[1]), .B0(cur_broth[3]), .Y(
        n438) );
  NAND2XL U672 ( .A(n449), .B(n448), .Y(n459) );
  OAI31XL U673 ( .A0(cur_t_soup[5]), .A1(cur_t_soup[6]), .A2(n447), .B0(
        cur_t_soup[7]), .Y(n448) );
  AOI21XL U674 ( .A0(n887), .A1(n446), .B0(n722), .Y(n447) );
  NAND4BBXL U675 ( .AN(cur_sause[11]), .BN(cur_sause[8]), .C(n396), .D(n395), 
        .Y(n461) );
  NOR4XL U676 ( .A(cur_sause[10]), .B(cur_sause[9]), .C(cur_sause[7]), .D(
        cur_sause[6]), .Y(n395) );
  NOR4XL U677 ( .A(cur_sause[13]), .B(cur_sause[15]), .C(cur_sause[14]), .D(
        cur_sause[12]), .Y(n396) );
  INVXL U678 ( .A(n612), .Y(n614) );
  NAND2XL U679 ( .A(n504), .B(n798), .Y(n592) );
  NAND2XL U680 ( .A(n626), .B(n488), .Y(n621) );
  NAND2XL U681 ( .A(n476), .B(n611), .Y(n477) );
  INVXL U682 ( .A(n605), .Y(n476) );
  INVXL U683 ( .A(n791), .Y(n584) );
  AND2XL U684 ( .A(n863), .B(n626), .Y(n865) );
  MXI2XL U685 ( .A(intadd_2_SUM_0_), .B(n800), .S0(n495), .Y(n801) );
  INVXL U686 ( .A(DP_OP_256J1_122_7686_n75), .Y(DP_OP_256J1_122_7686_n67) );
  INVXL U687 ( .A(intadd_1_SUM_2_), .Y(n498) );
  AOI22XL U688 ( .A0(intadd_2_SUM_2_), .A1(n577), .B0(n794), .B1(n803), .Y(
        n500) );
  INVXL U689 ( .A(DP_OP_256J1_122_7686_n74), .Y(DP_OP_256J1_122_7686_n66) );
  INVXL U690 ( .A(n501), .Y(n805) );
  AOI211XL U691 ( .A0(cur_broth[5]), .A1(n416), .B0(cur_broth[7]), .C0(
        cur_broth[6]), .Y(n419) );
  INVXL U692 ( .A(n436), .Y(n418) );
  OAI2BB1XL U693 ( .A0N(cur_broth[2]), .A1N(cur_broth[3]), .B0(n788), .Y(n416)
         );
  AOI2BB1XL U694 ( .A0N(portion_reg), .A1N(n412), .B0(n411), .Y(n471) );
  OAI211XL U695 ( .A0(n410), .A1(n883), .B0(n409), .C0(n408), .Y(n411) );
  AOI2BB1XL U696 ( .A0N(n882), .A1N(n406), .B0(cur_noodle[7]), .Y(n412) );
  NOR4XL U697 ( .A(cur_noodle[8]), .B(cur_noodle[10]), .C(cur_noodle[9]), .D(
        cur_noodle[13]), .Y(n409) );
  AOI22XL U698 ( .A0(n507), .A1(n457), .B0(n585), .B1(n456), .Y(n504) );
  NAND4XL U699 ( .A(n427), .B(n452), .C(n426), .D(n425), .Y(n457) );
  OAI31XL U700 ( .A0(n455), .A1(n454), .A2(n591), .B0(n474), .Y(n456) );
  AOI32XL U701 ( .A0(n450), .A1(n424), .A2(n446), .B0(n721), .B1(n424), .Y(
        n425) );
  NAND3XL U702 ( .A(cur_sause[3]), .B(cur_sause[1]), .C(cur_sause[2]), .Y(n458) );
  NAND2XL U703 ( .A(n424), .B(n403), .Y(n466) );
  OAI211XL U704 ( .A0(cur_t_soup[2]), .A1(n402), .B0(cur_t_soup[5]), .C0(
        cur_t_soup[6]), .Y(n403) );
  NAND2XL U705 ( .A(n722), .B(n887), .Y(n402) );
  OR2XL U706 ( .A(cur_sause[5]), .B(n461), .Y(n468) );
  OAI31XL U707 ( .A0(n465), .A1(n464), .A2(n463), .B0(portion_reg), .Y(n467)
         );
  AOI31XL U708 ( .A0(cur_sause[5]), .A1(cur_sause[4]), .A2(n462), .B0(n461), 
        .Y(n463) );
  INVXL U709 ( .A(n459), .Y(n465) );
  NAND2XL U710 ( .A(n460), .B(n884), .Y(n462) );
  INVXL U711 ( .A(n549), .Y(n539) );
  INVXL U712 ( .A(n526), .Y(n542) );
  OAI21XL U713 ( .A0(n855), .A1(n549), .B0(n546), .Y(n852) );
  NAND2XL U714 ( .A(n791), .B(n612), .Y(n549) );
  AOI21XL U715 ( .A0(n791), .A1(n614), .B0(n550), .Y(n546) );
  NOR2XL U716 ( .A(T_count[1]), .B(n549), .Y(n830) );
  INVXL U717 ( .A(n532), .Y(n518) );
  NOR2X1 U718 ( .A(n819), .B(n525), .Y(n517) );
  INVXL U719 ( .A(n510), .Y(n521) );
  NOR2X1 U720 ( .A(n818), .B(n531), .Y(n851) );
  OAI21XL U721 ( .A0(n851), .A1(n532), .B0(n529), .Y(n848) );
  NAND2XL U722 ( .A(n506), .B(n791), .Y(n532) );
  AOI2BB1XL U723 ( .A0N(n506), .A1N(n592), .B0(n550), .Y(n529) );
  INVXL U724 ( .A(n568), .Y(n557) );
  INVXL U725 ( .A(n552), .Y(n560) );
  OAI21XL U726 ( .A0(n556), .A1(n568), .B0(n565), .Y(n552) );
  NOR2X1 U727 ( .A(n813), .B(n567), .Y(n844) );
  OAI21XL U728 ( .A0(n844), .A1(n568), .B0(n565), .Y(n841) );
  NAND2XL U729 ( .A(n697), .B(n585), .Y(n568) );
  NAND2XL U730 ( .A(n557), .B(n812), .Y(n564) );
  AOI21XL U731 ( .A0(n791), .A1(n605), .B0(n550), .Y(n565) );
  INVXL U732 ( .A(n537), .Y(n513) );
  NOR2X1 U733 ( .A(n809), .B(n523), .Y(n512) );
  INVXL U734 ( .A(n508), .Y(n516) );
  NOR2X1 U735 ( .A(n808), .B(n536), .Y(n837) );
  OAI21XL U736 ( .A0(n837), .A1(n537), .B0(n534), .Y(n834) );
  NAND2XL U737 ( .A(n507), .B(n791), .Y(n537) );
  AOI2BB1XL U738 ( .A0N(n507), .A1N(n584), .B0(n550), .Y(n534) );
  OR2XL U739 ( .A(n694), .B(cur_miso[0]), .Y(DP_OP_233J1_138_6117_n15) );
  AND2XL U740 ( .A(n864), .B(n881), .Y(n859) );
  AND2XL U741 ( .A(n625), .B(n798), .Y(n733) );
  INVXL U742 ( .A(n619), .Y(DP_OP_188J1_123_5758_n21) );
  INVXL U743 ( .A(n551), .Y(n798) );
  NAND2XL U744 ( .A(state[1]), .B(n561), .Y(n551) );
  NAND2XL U745 ( .A(in_valid), .B(n561), .Y(n569) );
  OAI2BB1XL U746 ( .A0N(n791), .A1N(n767), .B0(n766), .Y(n296) );
  AOI21XL U747 ( .A0(cur_broth[15]), .A1(n781), .B0(n772), .Y(n766) );
  XNOR2XL U748 ( .A(cur_broth[15]), .B(n765), .Y(n767) );
  OR2XL U749 ( .A(n768), .B(cur_broth[14]), .Y(n765) );
  OAI2BB1XL U750 ( .A0N(n791), .A1N(n774), .B0(n773), .Y(n298) );
  AOI21XL U751 ( .A0(n781), .A1(cur_broth[13]), .B0(n772), .Y(n773) );
  XNOR2XL U752 ( .A(cur_broth[13]), .B(n771), .Y(n774) );
  OAI2BB1XL U753 ( .A0N(n733), .A1N(n708), .B0(n707), .Y(n314) );
  AOI21XL U754 ( .A0(n730), .A1(cur_t_soup[13]), .B0(n772), .Y(n707) );
  XNOR2XL U755 ( .A(cur_t_soup[13]), .B(n706), .Y(n708) );
  OAI2BB1XL U756 ( .A0N(n659), .A1N(n645), .B0(n644), .Y(n333) );
  AOI21XL U757 ( .A0(n655), .A1(cur_sause[10]), .B0(n772), .Y(n644) );
  OAI2BB1XL U758 ( .A0N(n733), .A1N(n717), .B0(n716), .Y(n318) );
  AOI21XL U759 ( .A0(n730), .A1(cur_t_soup[9]), .B0(n772), .Y(n716) );
  OAI2BB1XL U760 ( .A0N(n791), .A1N(n742), .B0(n741), .Y(n361) );
  AOI21XL U761 ( .A0(n781), .A1(cur_noodle[13]), .B0(n772), .Y(n741) );
  OAI2BB1XL U762 ( .A0N(n697), .A1N(n682), .B0(n681), .Y(n350) );
  AOI21XL U763 ( .A0(n691), .A1(cur_miso[9]), .B0(n772), .Y(n681) );
  OAI2BB1XL U764 ( .A0N(n733), .A1N(n719), .B0(n718), .Y(n319) );
  AOI21XL U765 ( .A0(n730), .A1(cur_t_soup[8]), .B0(n772), .Y(n718) );
  OAI2BB1XL U766 ( .A0N(n659), .A1N(n651), .B0(n650), .Y(n335) );
  AOI21XL U767 ( .A0(n655), .A1(cur_sause[8]), .B0(n772), .Y(n650) );
  OAI2BB1XL U768 ( .A0N(n691), .A1N(cur_miso[8]), .B0(n685), .Y(n351) );
  AOI21XL U769 ( .A0(n684), .A1(n697), .B0(n772), .Y(n685) );
  OAI2BB1XL U770 ( .A0N(n659), .A1N(n654), .B0(n653), .Y(n336) );
  AOI21XL U771 ( .A0(n655), .A1(cur_sause[7]), .B0(n772), .Y(n653) );
  OAI2BB1XL U772 ( .A0N(cur_miso[7]), .A1N(n691), .B0(n688), .Y(n352) );
  AOI21XL U773 ( .A0(n687), .A1(n697), .B0(n772), .Y(n688) );
  OAI2BB1XL U774 ( .A0N(n791), .A1N(n748), .B0(n747), .Y(n363) );
  AOI21XL U775 ( .A0(n781), .A1(cur_noodle[11]), .B0(n772), .Y(n747) );
  NAND2XL U776 ( .A(n608), .B(n599), .Y(n337) );
  AOI22XL U777 ( .A0(n598), .A1(n659), .B0(n655), .B1(cur_sause[6]), .Y(n599)
         );
  OAI2BB1XL U778 ( .A0N(cur_miso[6]), .A1N(n691), .B0(n690), .Y(n353) );
  AOI21XL U779 ( .A0(n697), .A1(n689), .B0(n772), .Y(n690) );
  OAI2BB1XL U780 ( .A0N(n791), .A1N(n751), .B0(n750), .Y(n364) );
  AOI21XL U781 ( .A0(n781), .A1(cur_noodle[10]), .B0(n772), .Y(n750) );
  OAI211XL U782 ( .A0(n699), .A1(n886), .B0(n608), .C0(n594), .Y(n354) );
  NAND2XL U783 ( .A(C51_DATA2_5), .B(n697), .Y(n594) );
  OAI2BB1XL U784 ( .A0N(n791), .A1N(n754), .B0(n753), .Y(n365) );
  AOI21XL U785 ( .A0(n781), .A1(cur_noodle[9]), .B0(n772), .Y(n753) );
  OAI211XL U786 ( .A0(n659), .A1(n885), .B0(n608), .C0(n587), .Y(n339) );
  NAND2XL U787 ( .A(C50_DATA2_4), .B(n659), .Y(n587) );
  OAI211XL U788 ( .A0(n728), .A1(n879), .B0(n608), .C0(n606), .Y(n322) );
  OAI211XL U789 ( .A0(n728), .A1(n887), .B0(n608), .C0(n607), .Y(n324) );
  OAI211XL U790 ( .A0(n791), .A1(n883), .B0(n589), .C0(n608), .Y(n367) );
  NAND2XL U791 ( .A(C52_DATA2_7), .B(n791), .Y(n589) );
  AOI22XL U792 ( .A0(C50_DATA2_2), .A1(n659), .B0(n655), .B1(cur_sause[2]), 
        .Y(n590) );
  OAI211XL U793 ( .A0(n699), .A1(n878), .B0(n608), .C0(n593), .Y(n356) );
  OAI2BB2XL U794 ( .B0(n793), .B1(n876), .A0N(n791), .A1N(n761), .Y(n373) );
  AND2XL U795 ( .A(MS_count[1]), .B(n857), .Y(N1249) );
  AND2XL U796 ( .A(MS_count[3]), .B(n857), .Y(N1251) );
  AND2XL U797 ( .A(M_count[1]), .B(n857), .Y(N1256) );
  AND2XL U798 ( .A(M_count[3]), .B(n857), .Y(N1258) );
  AND2XL U799 ( .A(TS_count[1]), .B(n857), .Y(N1263) );
  AND2XL U800 ( .A(TS_count[3]), .B(n857), .Y(N1265) );
  AND2XL U801 ( .A(T_count[1]), .B(n857), .Y(N1270) );
  AND2XL U802 ( .A(T_count[3]), .B(n857), .Y(N1272) );
  NOR2X1 U803 ( .A(selling), .B(n505), .Y(n857) );
  AOI211XL U804 ( .A0(n799), .A1(n581), .B0(n826), .C0(n580), .Y(N1279) );
  AOI211XL U805 ( .A0(n576), .A1(n575), .B0(n826), .C0(n574), .Y(N1281) );
  NOR2X1 U806 ( .A(n576), .B(n575), .Y(n574) );
  MXI2XL U807 ( .A(DP_OP_256J1_122_7686_n67), .B(DP_OP_256J1_122_7686_n75), 
        .S0(n573), .Y(n575) );
  AOI211XL U808 ( .A0(n806), .A1(n503), .B0(n826), .C0(n502), .Y(N1282) );
  AOI22XL U809 ( .A0(DP_OP_256J1_122_7686_n74), .A1(n805), .B0(n501), .B1(
        DP_OP_256J1_122_7686_n66), .Y(n503) );
  AOI211XL U810 ( .A0(intadd_0_n1), .A1(n604), .B0(n826), .C0(n603), .Y(N1290)
         );
  MXI2XL U811 ( .A(DP_OP_256J1_122_7686_n25), .B(n795), .S0(n602), .Y(n604) );
  AND2XL U812 ( .A(in_valid), .B(n797), .Y(n563) );
  OAI21XL U813 ( .A0(n585), .A1(n572), .B0(n570), .Y(n266) );
  OAI31XL U814 ( .A0(n472), .A1(n471), .A2(n470), .B0(n506), .Y(n473) );
  OAI211XL U815 ( .A0(n469), .A1(n468), .B0(n467), .C0(n466), .Y(n470) );
  OAI32XL U816 ( .A0(T_count[4]), .A1(n549), .A2(n544), .B0(n543), .B1(n824), 
        .Y(n270) );
  NOR2X1 U817 ( .A(n854), .B(n852), .Y(n543) );
  OAI32XL U818 ( .A0(T_count[2]), .A1(n549), .A2(n548), .B0(n547), .B1(n823), 
        .Y(n272) );
  NOR2X1 U819 ( .A(n830), .B(n828), .Y(n547) );
  OAI2BB1XL U820 ( .A0N(T_count[0]), .A1N(n830), .B0(n829), .Y(n295) );
  OAI32XL U821 ( .A0(TS_count[4]), .A1(n532), .A2(n525), .B0(n524), .B1(n819), 
        .Y(n276) );
  OAI32XL U822 ( .A0(TS_count[2]), .A1(n532), .A2(n531), .B0(n530), .B1(n818), 
        .Y(n278) );
  NOR2X1 U823 ( .A(n847), .B(n845), .Y(n530) );
  OAI32XL U824 ( .A0(M_count[4]), .A1(n568), .A2(n555), .B0(n554), .B1(n814), 
        .Y(n283) );
  OAI32XL U825 ( .A0(M_count[2]), .A1(n568), .A2(n567), .B0(n566), .B1(n813), 
        .Y(n285) );
  NOR2X1 U826 ( .A(n840), .B(n838), .Y(n566) );
  OAI2BB1XL U827 ( .A0N(M_count[0]), .A1N(n840), .B0(n839), .Y(n286) );
  OAI32XL U828 ( .A0(MS_count[4]), .A1(n537), .A2(n523), .B0(n522), .B1(n809), 
        .Y(n290) );
  NOR2X1 U829 ( .A(n836), .B(n834), .Y(n522) );
  OAI32XL U830 ( .A0(MS_count[2]), .A1(n537), .A2(n536), .B0(n535), .B1(n808), 
        .Y(n292) );
  NOR2X1 U831 ( .A(n833), .B(n831), .Y(n535) );
  OAI2BB2XL U832 ( .B0(n699), .B1(n696), .A0N(n697), .A1N(n695), .Y(n375) );
  OAI2BB2XL U833 ( .B0(n699), .B1(n698), .A0N(n697), .A1N(C51_DATA2_1), .Y(
        n358) );
  OAI2BB2XL U834 ( .B0(n699), .B1(n693), .A0N(n697), .A1N(C51_DATA2_2), .Y(
        n357) );
  OAI2BB2XL U835 ( .B0(n699), .B1(n692), .A0N(n697), .A1N(C51_DATA2_4), .Y(
        n355) );
  OAI2BB1XL U836 ( .A0N(n697), .A1N(n679), .B0(n678), .Y(n349) );
  NAND2XL U837 ( .A(n691), .B(cur_miso[10]), .Y(n678) );
  OAI2BB1XL U838 ( .A0N(n697), .A1N(n676), .B0(n675), .Y(n348) );
  NAND2XL U839 ( .A(n691), .B(cur_miso[11]), .Y(n675) );
  OAI2BB1XL U840 ( .A0N(n697), .A1N(n673), .B0(n672), .Y(n347) );
  NAND2XL U841 ( .A(n691), .B(cur_miso[12]), .Y(n672) );
  OAI2BB1XL U842 ( .A0N(n697), .A1N(n670), .B0(n669), .Y(n346) );
  NAND2XL U843 ( .A(n691), .B(cur_miso[13]), .Y(n669) );
  OAI2BB1XL U844 ( .A0N(n697), .A1N(n664), .B0(n663), .Y(n344) );
  NAND2XL U845 ( .A(n691), .B(cur_miso[15]), .Y(n663) );
  OR2XL U846 ( .A(n665), .B(cur_miso[14]), .Y(n662) );
  OAI2BB2XL U847 ( .B0(n728), .B1(n727), .A0N(n733), .A1N(n726), .Y(n326) );
  XNOR2XL U848 ( .A(cur_t_soup[1]), .B(n725), .Y(n726) );
  OAI2BB2XL U849 ( .B0(n728), .B1(n723), .A0N(n733), .A1N(C49_DATA2_2), .Y(
        n325) );
  OAI2BB2XL U850 ( .B0(n728), .B1(n722), .A0N(n733), .A1N(C49_DATA2_4), .Y(
        n323) );
  OAI2BB2XL U851 ( .B0(n728), .B1(n721), .A0N(n733), .A1N(C49_DATA2_6), .Y(
        n321) );
  OAI2BB2XL U852 ( .B0(n728), .B1(n720), .A0N(n733), .A1N(C49_DATA2_7), .Y(
        n320) );
  OAI2BB1XL U853 ( .A0N(n733), .A1N(n714), .B0(n713), .Y(n317) );
  NAND2XL U854 ( .A(n730), .B(cur_t_soup[10]), .Y(n713) );
  OAI2BB1XL U855 ( .A0N(n733), .A1N(n732), .B0(n731), .Y(n316) );
  NAND2XL U856 ( .A(n730), .B(cur_t_soup[11]), .Y(n731) );
  OAI2BB1XL U857 ( .A0N(n733), .A1N(n711), .B0(n710), .Y(n315) );
  NAND2XL U858 ( .A(n730), .B(cur_t_soup[12]), .Y(n710) );
  OAI2BB1XL U859 ( .A0N(n733), .A1N(n702), .B0(n701), .Y(n312) );
  NAND2XL U860 ( .A(n730), .B(cur_t_soup[15]), .Y(n701) );
  OR2XL U861 ( .A(n703), .B(cur_t_soup[14]), .Y(n700) );
  OAI2BB2XL U862 ( .B0(n793), .B1(n790), .A0N(n791), .A1N(n789), .Y(n310) );
  OAI2BB2XL U863 ( .B0(n793), .B1(n792), .A0N(n791), .A1N(C48_DATA2_2), .Y(
        n309) );
  OAI2BB2XL U864 ( .B0(n793), .B1(n788), .A0N(n791), .A1N(C48_DATA2_4), .Y(
        n307) );
  OAI2BB2XL U865 ( .B0(n793), .B1(n787), .A0N(n791), .A1N(C48_DATA2_6), .Y(
        n305) );
  OAI2BB2XL U866 ( .B0(n793), .B1(n786), .A0N(n791), .A1N(C48_DATA2_7), .Y(
        n304) );
  OAI2BB2XL U867 ( .B0(n793), .B1(n785), .A0N(n791), .A1N(C48_DATA2_8), .Y(
        n303) );
  OAI2BB2XL U868 ( .B0(n793), .B1(n784), .A0N(n791), .A1N(C48_DATA2_9), .Y(
        n302) );
  OAI2BB1XL U869 ( .A0N(n791), .A1N(n783), .B0(n782), .Y(n301) );
  NAND2XL U870 ( .A(cur_broth[10]), .B(n781), .Y(n782) );
  OAI2BB1XL U871 ( .A0N(n791), .A1N(n780), .B0(n779), .Y(n300) );
  NAND2XL U872 ( .A(cur_broth[11]), .B(n781), .Y(n779) );
  OAI2BB1XL U873 ( .A0N(n791), .A1N(n777), .B0(n776), .Y(n299) );
  NAND2XL U874 ( .A(cur_broth[12]), .B(n781), .Y(n776) );
  OAI2BB1XL U875 ( .A0N(n791), .A1N(n770), .B0(n769), .Y(n297) );
  NAND2XL U876 ( .A(cur_broth[14]), .B(n781), .Y(n769) );
  OAI2BB2XL U877 ( .B0(n793), .B1(n760), .A0N(n791), .A1N(n759), .Y(n372) );
  OAI2BB2XL U878 ( .B0(n793), .B1(n764), .A0N(n791), .A1N(n763), .Y(n371) );
  OAI2BB2XL U879 ( .B0(n793), .B1(n757), .A0N(n791), .A1N(C52_DATA2_4), .Y(
        n370) );
  OAI2BB2XL U880 ( .B0(n793), .B1(n756), .A0N(n791), .A1N(n755), .Y(n366) );
  OAI2BB1XL U881 ( .A0N(n791), .A1N(n745), .B0(n744), .Y(n362) );
  NAND2XL U882 ( .A(cur_noodle[12]), .B(n781), .Y(n744) );
  OAI2BB1XL U883 ( .A0N(n791), .A1N(n739), .B0(n738), .Y(n360) );
  NAND2XL U884 ( .A(cur_noodle[14]), .B(n781), .Y(n738) );
  OAI2BB1XL U885 ( .A0N(n791), .A1N(n736), .B0(n735), .Y(n359) );
  NAND2XL U886 ( .A(cur_noodle[15]), .B(n781), .Y(n735) );
  XNOR2XL U887 ( .A(cur_noodle[15]), .B(n734), .Y(n736) );
  OR2XL U888 ( .A(n737), .B(cur_noodle[14]), .Y(n734) );
  OAI2BB2XL U889 ( .B0(n661), .B1(n658), .A0N(n659), .A1N(n657), .Y(n343) );
  OAI2BB2XL U890 ( .B0(n661), .B1(n660), .A0N(n659), .A1N(C50_DATA2_1), .Y(
        n342) );
  OAI2BB2XL U891 ( .B0(n661), .B1(n656), .A0N(n659), .A1N(C50_DATA2_5), .Y(
        n338) );
  OAI2BB1XL U892 ( .A0N(n659), .A1N(n648), .B0(n647), .Y(n334) );
  NAND2XL U893 ( .A(cur_sause[9]), .B(n655), .Y(n647) );
  OAI2BB1XL U894 ( .A0N(n659), .A1N(n642), .B0(n641), .Y(n332) );
  NAND2XL U895 ( .A(cur_sause[11]), .B(n655), .Y(n641) );
  OAI2BB1XL U896 ( .A0N(n659), .A1N(n639), .B0(n638), .Y(n331) );
  NAND2XL U897 ( .A(cur_sause[12]), .B(n655), .Y(n638) );
  OAI2BB1XL U898 ( .A0N(n659), .A1N(n636), .B0(n635), .Y(n330) );
  NAND2XL U899 ( .A(cur_sause[13]), .B(n655), .Y(n635) );
  OAI2BB1XL U900 ( .A0N(n659), .A1N(n630), .B0(n629), .Y(n328) );
  NAND2XL U901 ( .A(cur_sause[15]), .B(n655), .Y(n629) );
  OR2XL U902 ( .A(n631), .B(cur_sause[14]), .Y(n628) );
  INVXL U903 ( .A(n492), .Y(DP_OP_256J1_122_7686_n56) );
  ADDFXL U904 ( .A(n500), .B(n499), .CI(n498), .CO(n492), .S(n501) );
  XOR2XL U905 ( .A(n601), .B(n600), .Y(n602) );
  INVXL U906 ( .A(intadd_2_SUM_0_), .Y(n800) );
  INVXL U907 ( .A(n691), .Y(n699) );
  INVXL U908 ( .A(n730), .Y(n728) );
  INVXL U909 ( .A(cur_sause[0]), .Y(n658) );
  INVXL U910 ( .A(cur_miso[4]), .Y(n692) );
  OR3XL U911 ( .A(cur_miso[13]), .B(cur_miso[12]), .C(cur_miso[15]), .Y(n397)
         );
  INVXL U912 ( .A(cur_t_soup[4]), .Y(n722) );
  INVXL U913 ( .A(cur_noodle[3]), .Y(n764) );
  INVXL U914 ( .A(cur_broth[4]), .Y(n788) );
  INVXL U915 ( .A(cur_broth[8]), .Y(n785) );
  INVXL U916 ( .A(cur_miso[0]), .Y(n696) );
  INVXL U917 ( .A(cur_t_soup[6]), .Y(n721) );
  INVXL U918 ( .A(ramen_type_reg[0]), .Y(n585) );
  INVXL U919 ( .A(n428), .Y(n432) );
  INVXL U920 ( .A(portion_reg), .Y(n611) );
  AOI221XL U921 ( .A0(n439), .A1(n436), .B0(n435), .B1(n436), .C0(n434), .Y(
        n455) );
  INVXL U922 ( .A(cur_miso[1]), .Y(n698) );
  INVXL U923 ( .A(cur_miso[2]), .Y(n693) );
  INVXL U924 ( .A(cur_broth[7]), .Y(n786) );
  AOI221XL U925 ( .A0(cur_broth[8]), .A1(cur_broth[9]), .B0(n441), .B1(
        cur_broth[9]), .C0(n440), .Y(n464) );
  INVXL U926 ( .A(ramen_type_reg[1]), .Y(n591) );
  INVXL U927 ( .A(selling_reg), .Y(n505) );
  NAND2XL U928 ( .A(state[1]), .B(state[0]), .Y(n858) );
  INVXL U929 ( .A(TS_count[0]), .Y(n817) );
  INVXL U930 ( .A(MS_count[0]), .Y(n807) );
  ADDFXL U931 ( .A(intadd_1_SUM_2_), .B(n482), .CI(n481), .CO(
        DP_OP_256J1_122_7686_n33), .S(DP_OP_256J1_122_7686_n34) );
  ADDFXL U932 ( .A(intadd_1_SUM_1_), .B(intadd_1_SUM_2_), .CI(n483), .CO(n481), 
        .S(DP_OP_256J1_122_7686_n41) );
  INVXL U933 ( .A(n484), .Y(n486) );
  INVXL U934 ( .A(DP_OP_256J1_122_7686_n32), .Y(intadd_0_B_3_) );
  INVXL U935 ( .A(n615), .Y(n487) );
  INVXL U936 ( .A(n621), .Y(n877) );
  INVXL U937 ( .A(DP_OP_256J1_122_7686_n31), .Y(intadd_0_B_4_) );
  INVXL U938 ( .A(T_count[0]), .Y(n822) );
  INVXL U939 ( .A(M_count[0]), .Y(n812) );
  ADDFXL U940 ( .A(n495), .B(intadd_1_SUM_1_), .CI(n582), .CO(
        DP_OP_256J1_122_7686_n47), .S(DP_OP_256J1_122_7686_n48) );
  INVXL U941 ( .A(DP_OP_256J1_122_7686_n28), .Y(intadd_0_A_4_) );
  INVXL U942 ( .A(DP_OP_256J1_122_7686_n38), .Y(intadd_0_A_3_) );
  INVXL U943 ( .A(DP_OP_256J1_122_7686_n24), .Y(intadd_0_B_5_) );
  INVXL U944 ( .A(DP_OP_256J1_122_7686_n27), .Y(intadd_0_A_5_) );
  INVXL U945 ( .A(DP_OP_256J1_122_7686_n53), .Y(intadd_0_A_0_) );
  INVXL U946 ( .A(DP_OP_256J1_122_7686_n46), .Y(intadd_0_B_1_) );
  INVXL U947 ( .A(DP_OP_256J1_122_7686_n52), .Y(intadd_0_A_1_) );
  INVXL U948 ( .A(DP_OP_256J1_122_7686_n39), .Y(intadd_0_B_2_) );
  INVXL U949 ( .A(DP_OP_256J1_122_7686_n45), .Y(intadd_0_A_2_) );
  INVXL U950 ( .A(DP_OP_256J1_122_7686_n19), .Y(intadd_0_B_6_) );
  INVXL U951 ( .A(DP_OP_256J1_122_7686_n23), .Y(intadd_0_A_6_) );
  AOI222XL U952 ( .A0(intadd_1_SUM_0_), .A1(n799), .B0(intadd_1_SUM_0_), .B1(
        n800), .C0(n799), .C1(n800), .Y(n496) );
  INVXL U953 ( .A(n799), .Y(n494) );
  NAND2XL U954 ( .A(n493), .B(n794), .Y(n579) );
  AOI22XL U955 ( .A0(intadd_2_SUM_1_), .A1(n577), .B0(n494), .B1(n579), .Y(
        n802) );
  ADDFXL U956 ( .A(intadd_2_SUM_1_), .B(n497), .CI(n496), .CO(n499), .S(n573)
         );
  AOI222XL U957 ( .A0(n576), .A1(n573), .B0(n576), .B1(
        DP_OP_256J1_122_7686_n67), .C0(n573), .C1(DP_OP_256J1_122_7686_n67), 
        .Y(n806) );
  INVXL U958 ( .A(state[0]), .Y(n561) );
  NAND2XL U959 ( .A(n518), .B(n817), .Y(n528) );
  OAI21XL U960 ( .A0(n529), .A1(n817), .B0(n528), .Y(n280) );
  NAND2XL U961 ( .A(n513), .B(n807), .Y(n533) );
  OAI21XL U962 ( .A0(n807), .A1(n534), .B0(n533), .Y(n294) );
  NAND2XL U963 ( .A(n539), .B(n822), .Y(n545) );
  OAI21XL U964 ( .A0(n822), .A1(n546), .B0(n545), .Y(n273) );
  INVXL U965 ( .A(MS_count[4]), .Y(n809) );
  INVXL U966 ( .A(MS_count[2]), .Y(n808) );
  NAND2XL U967 ( .A(MS_count[1]), .B(MS_count[0]), .Y(n536) );
  NAND2XL U968 ( .A(MS_count[3]), .B(n837), .Y(n523) );
  OAI21XL U969 ( .A0(n512), .A1(n537), .B0(n534), .Y(n508) );
  INVXL U970 ( .A(MS_count[5]), .Y(n810) );
  NAND2XL U971 ( .A(n513), .B(n810), .Y(n515) );
  INVXL U972 ( .A(n512), .Y(n509) );
  OAI22XL U973 ( .A0(n516), .A1(n810), .B0(n515), .B1(n509), .Y(n289) );
  INVXL U974 ( .A(TS_count[4]), .Y(n819) );
  INVXL U975 ( .A(TS_count[2]), .Y(n818) );
  NAND2XL U976 ( .A(TS_count[1]), .B(TS_count[0]), .Y(n531) );
  NAND2XL U977 ( .A(TS_count[3]), .B(n851), .Y(n525) );
  OAI21XL U978 ( .A0(n517), .A1(n532), .B0(n529), .Y(n510) );
  INVXL U979 ( .A(TS_count[5]), .Y(n820) );
  NAND2XL U980 ( .A(n518), .B(n820), .Y(n520) );
  INVXL U981 ( .A(n517), .Y(n511) );
  OAI22XL U982 ( .A0(n521), .A1(n820), .B0(n520), .B1(n511), .Y(n275) );
  NAND3XL U983 ( .A(n513), .B(MS_count[5]), .C(n512), .Y(n514) );
  INVXL U984 ( .A(MS_count[6]), .Y(n811) );
  AOI32XL U985 ( .A0(n516), .A1(MS_count[6]), .A2(n515), .B0(n514), .B1(n811), 
        .Y(n288) );
  NAND3XL U986 ( .A(n518), .B(TS_count[5]), .C(n517), .Y(n519) );
  INVXL U987 ( .A(TS_count[6]), .Y(n821) );
  AOI32XL U988 ( .A0(n521), .A1(TS_count[6]), .A2(n520), .B0(n519), .B1(n821), 
        .Y(n274) );
  INVXL U989 ( .A(T_count[4]), .Y(n824) );
  INVXL U990 ( .A(T_count[2]), .Y(n823) );
  NAND2XL U991 ( .A(T_count[1]), .B(T_count[0]), .Y(n548) );
  NAND2XL U992 ( .A(T_count[3]), .B(n855), .Y(n544) );
  OAI21XL U993 ( .A0(n538), .A1(n549), .B0(n546), .Y(n526) );
  INVXL U994 ( .A(T_count[5]), .Y(n825) );
  NAND2XL U995 ( .A(n539), .B(n825), .Y(n541) );
  INVXL U996 ( .A(n538), .Y(n527) );
  OAI22XL U997 ( .A0(n542), .A1(n825), .B0(n541), .B1(n527), .Y(n269) );
  NAND2XL U998 ( .A(n529), .B(n528), .Y(n845) );
  NAND2XL U999 ( .A(n534), .B(n533), .Y(n831) );
  NAND3XL U1000 ( .A(n539), .B(T_count[5]), .C(n538), .Y(n540) );
  INVXL U1001 ( .A(T_count[6]), .Y(n827) );
  AOI32XL U1002 ( .A0(n542), .A1(T_count[6]), .A2(n541), .B0(n540), .B1(n827), 
        .Y(n268) );
  NAND2XL U1003 ( .A(n546), .B(n545), .Y(n828) );
  OAI21XL U1004 ( .A0(n812), .A1(n565), .B0(n564), .Y(n287) );
  NAND2XL U1005 ( .A(n551), .B(n569), .Y(next_state[0]) );
  INVXL U1006 ( .A(M_count[4]), .Y(n814) );
  INVXL U1007 ( .A(M_count[2]), .Y(n813) );
  NAND2XL U1008 ( .A(M_count[1]), .B(M_count[0]), .Y(n567) );
  NAND2XL U1009 ( .A(M_count[3]), .B(n844), .Y(n555) );
  INVXL U1010 ( .A(M_count[5]), .Y(n815) );
  NAND2XL U1011 ( .A(n557), .B(n815), .Y(n559) );
  INVXL U1012 ( .A(n556), .Y(n553) );
  OAI22XL U1013 ( .A0(n560), .A1(n815), .B0(n559), .B1(n553), .Y(n282) );
  NAND3XL U1014 ( .A(n557), .B(M_count[5]), .C(n556), .Y(n558) );
  INVXL U1015 ( .A(M_count[6]), .Y(n816) );
  AOI32XL U1016 ( .A0(n560), .A1(M_count[6]), .A2(n559), .B0(n558), .B1(n816), 
        .Y(n281) );
  NAND2XL U1017 ( .A(n563), .B(portion), .Y(n562) );
  OAI21XL U1018 ( .A0(n563), .A1(n611), .B0(n562), .Y(n265) );
  NAND2XL U1019 ( .A(n565), .B(n564), .Y(n838) );
  NAND2XL U1020 ( .A(n572), .B(ramen_type[0]), .Y(n570) );
  NAND2XL U1021 ( .A(n572), .B(ramen_type[1]), .Y(n571) );
  OAI21XL U1022 ( .A0(n591), .A1(n572), .B0(n571), .Y(n267) );
  NAND2XL U1023 ( .A(intadd_2_SUM_1_), .B(n577), .Y(n578) );
  NAND2XL U1024 ( .A(n579), .B(n578), .Y(n581) );
  NAND2XL U1025 ( .A(C50_DATA2_3), .B(n659), .Y(n586) );
  OAI211XL U1026 ( .A0(n659), .A1(n884), .B0(n608), .C0(n586), .Y(n340) );
  NAND2XL U1027 ( .A(C52_DATA2_6), .B(n791), .Y(n588) );
  OAI211XL U1028 ( .A0(n791), .A1(n882), .B0(n608), .C0(n588), .Y(n368) );
  NAND2XL U1029 ( .A(n608), .B(n590), .Y(n341) );
  NAND2XL U1030 ( .A(C51_DATA2_3), .B(n697), .Y(n593) );
  AOI22XL U1031 ( .A0(C48_DATA2_5), .A1(n791), .B0(n781), .B1(cur_broth[5]), 
        .Y(n595) );
  NAND2XL U1032 ( .A(n608), .B(n595), .Y(n306) );
  AOI22XL U1033 ( .A0(C52_DATA2_5), .A1(n791), .B0(n781), .B1(cur_noodle[5]), 
        .Y(n596) );
  NAND2XL U1034 ( .A(n608), .B(n596), .Y(n369) );
  AOI22XL U1035 ( .A0(C48_DATA2_3), .A1(n791), .B0(n781), .B1(cur_broth[3]), 
        .Y(n597) );
  NAND2XL U1036 ( .A(n608), .B(n597), .Y(n308) );
  XNOR2XL U1037 ( .A(cur_sause[6]), .B(DP_OP_220J1_133_6885_n10), .Y(n598) );
  NAND2XL U1038 ( .A(C49_DATA2_5), .B(n733), .Y(n606) );
  NAND2XL U1039 ( .A(C49_DATA2_3), .B(n733), .Y(n607) );
  INVXL U1040 ( .A(cur_broth[1]), .Y(n790) );
  INVXL U1041 ( .A(n625), .Y(DP_OP_188J1_123_5758_n23) );
  INVXL U1042 ( .A(cur_t_soup[1]), .Y(n727) );
  INVXL U1043 ( .A(n622), .Y(DP_OP_207J1_128_6357_n20) );
  INVXL U1044 ( .A(n623), .Y(DP_OP_207J1_128_6357_n19) );
  XNOR2XL U1045 ( .A(cur_sause[15]), .B(n628), .Y(n630) );
  XNOR2XL U1046 ( .A(cur_sause[14]), .B(n631), .Y(n633) );
  XNOR2XL U1047 ( .A(cur_sause[13]), .B(n634), .Y(n636) );
  XNOR2XL U1048 ( .A(cur_sause[12]), .B(n637), .Y(n639) );
  XNOR2XL U1049 ( .A(cur_sause[11]), .B(n640), .Y(n642) );
  XNOR2XL U1050 ( .A(cur_sause[10]), .B(n643), .Y(n645) );
  XNOR2XL U1051 ( .A(cur_sause[9]), .B(n646), .Y(n648) );
  XNOR2XL U1052 ( .A(cur_sause[8]), .B(n649), .Y(n651) );
  XNOR2XL U1053 ( .A(cur_sause[7]), .B(n652), .Y(n654) );
  INVXL U1054 ( .A(cur_sause[5]), .Y(n656) );
  XNOR2XL U1055 ( .A(cur_sause[0]), .B(n694), .Y(n657) );
  INVXL U1056 ( .A(cur_sause[1]), .Y(n660) );
  XNOR2XL U1057 ( .A(cur_miso[15]), .B(n662), .Y(n664) );
  XNOR2XL U1058 ( .A(cur_miso[14]), .B(n665), .Y(n667) );
  XNOR2XL U1059 ( .A(cur_miso[13]), .B(n668), .Y(n670) );
  XNOR2XL U1060 ( .A(cur_miso[12]), .B(n671), .Y(n673) );
  XNOR2XL U1061 ( .A(cur_miso[11]), .B(n674), .Y(n676) );
  XNOR2XL U1062 ( .A(cur_miso[10]), .B(n677), .Y(n679) );
  XNOR2XL U1063 ( .A(cur_miso[9]), .B(n680), .Y(n682) );
  XNOR2XL U1064 ( .A(cur_miso[8]), .B(n683), .Y(n684) );
  XNOR2XL U1065 ( .A(cur_miso[7]), .B(n686), .Y(n687) );
  XNOR2XL U1066 ( .A(cur_miso[6]), .B(DP_OP_233J1_138_6117_n10), .Y(n689) );
  XNOR2XL U1067 ( .A(cur_miso[0]), .B(n694), .Y(n695) );
  XNOR2XL U1068 ( .A(cur_t_soup[15]), .B(n700), .Y(n702) );
  XNOR2XL U1069 ( .A(cur_t_soup[14]), .B(n703), .Y(n705) );
  XNOR2XL U1070 ( .A(cur_t_soup[12]), .B(n709), .Y(n711) );
  XNOR2XL U1071 ( .A(cur_t_soup[10]), .B(n712), .Y(n714) );
  XNOR2XL U1072 ( .A(cur_t_soup[9]), .B(n715), .Y(n717) );
  XNOR2XL U1073 ( .A(cur_t_soup[8]), .B(DP_OP_207J1_128_6357_n8), .Y(n719) );
  INVXL U1074 ( .A(cur_t_soup[7]), .Y(n720) );
  INVXL U1075 ( .A(cur_t_soup[2]), .Y(n723) );
  INVXL U1076 ( .A(n724), .Y(n725) );
  XNOR2XL U1077 ( .A(cur_t_soup[11]), .B(n729), .Y(n732) );
  XNOR2XL U1078 ( .A(cur_noodle[14]), .B(n737), .Y(n739) );
  XNOR2XL U1079 ( .A(cur_noodle[13]), .B(n740), .Y(n742) );
  XNOR2XL U1080 ( .A(cur_noodle[12]), .B(n743), .Y(n745) );
  XNOR2XL U1081 ( .A(cur_noodle[11]), .B(n746), .Y(n748) );
  XNOR2XL U1082 ( .A(cur_noodle[10]), .B(n749), .Y(n751) );
  XNOR2XL U1083 ( .A(cur_noodle[9]), .B(n752), .Y(n754) );
  INVXL U1084 ( .A(cur_noodle[8]), .Y(n756) );
  XNOR2XL U1085 ( .A(cur_noodle[8]), .B(DP_OP_256J1_143_8148_n8), .Y(n755) );
  INVXL U1086 ( .A(cur_noodle[4]), .Y(n757) );
  INVXL U1087 ( .A(cur_noodle[2]), .Y(n760) );
  XOR2XL U1088 ( .A(cur_noodle[2]), .B(n758), .Y(n759) );
  XNOR2XL U1089 ( .A(cur_noodle[1]), .B(n873), .Y(n761) );
  XNOR2XL U1090 ( .A(cur_noodle[3]), .B(n762), .Y(n763) );
  XNOR2XL U1091 ( .A(cur_broth[14]), .B(n768), .Y(n770) );
  XNOR2XL U1092 ( .A(cur_broth[12]), .B(n775), .Y(n777) );
  XNOR2XL U1093 ( .A(cur_broth[11]), .B(n778), .Y(n780) );
  XNOR2XL U1094 ( .A(cur_broth[10]), .B(DP_OP_188J1_123_5758_n6), .Y(n783) );
  INVXL U1095 ( .A(cur_broth[9]), .Y(n784) );
  INVXL U1096 ( .A(cur_broth[6]), .Y(n787) );
  XNOR2XL U1097 ( .A(cur_broth[1]), .B(n881), .Y(n789) );
  INVXL U1098 ( .A(cur_broth[2]), .Y(n792) );
  OR2XL U1099 ( .A(n798), .B(n797), .Y(next_state[1]) );
  ADDFXL U1100 ( .A(n803), .B(n802), .CI(n801), .CO(n576), .S(n804) );
  AOI222XL U1101 ( .A0(DP_OP_256J1_122_7686_n74), .A1(n806), .B0(
        DP_OP_256J1_122_7686_n74), .B1(n805), .C0(n806), .C1(n805), .Y(
        intadd_0_CI) );
  NAND2XL U1102 ( .A(T_count[1]), .B(n828), .Y(n829) );
  NAND2XL U1103 ( .A(MS_count[1]), .B(n831), .Y(n832) );
  OAI2BB1XL U1104 ( .A0N(MS_count[0]), .A1N(n833), .B0(n832), .Y(n293) );
  NAND2XL U1105 ( .A(MS_count[3]), .B(n834), .Y(n835) );
  OAI2BB1XL U1106 ( .A0N(n837), .A1N(n836), .B0(n835), .Y(n291) );
  NAND2XL U1107 ( .A(M_count[1]), .B(n838), .Y(n839) );
  NAND2XL U1108 ( .A(M_count[3]), .B(n841), .Y(n842) );
  OAI2BB1XL U1109 ( .A0N(n844), .A1N(n843), .B0(n842), .Y(n284) );
  NAND2XL U1110 ( .A(TS_count[1]), .B(n845), .Y(n846) );
  OAI2BB1XL U1111 ( .A0N(TS_count[0]), .A1N(n847), .B0(n846), .Y(n279) );
  NAND2XL U1112 ( .A(TS_count[3]), .B(n848), .Y(n849) );
  OAI2BB1XL U1113 ( .A0N(n851), .A1N(n850), .B0(n849), .Y(n277) );
  NAND2XL U1114 ( .A(T_count[3]), .B(n852), .Y(n853) );
  OAI2BB1XL U1115 ( .A0N(n855), .A1N(n854), .B0(n853), .Y(n271) );
endmodule

