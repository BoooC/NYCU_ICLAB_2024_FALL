/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : T-2022.03
// Date      : Fri Jan 10 14:15:33 2025
/////////////////////////////////////////////////////////////


module CONV_TOP ( clk1, clk2, rst_n, in_valid, in_row, in_kernel, out_valid, 
        out_data );
  input [17:0] in_row;
  input [11:0] in_kernel;
  output [7:0] out_data;
  input clk1, clk2, rst_n, in_valid;
  output out_valid;
  wire   fifo_empty, conv_busy, in_data_valid_clk2, fifo_full,
         u_input_output_fifo_empty_reg1, u_input_output__Logic0_,
         u_Handshake_syn_N49, u_Handshake_syn_N48, u_Handshake_syn_N47,
         u_Handshake_syn_N46, u_Handshake_syn_N45, u_Handshake_syn_N44,
         u_Handshake_syn_N43, u_Handshake_syn_N42, u_Handshake_syn_N41,
         u_Handshake_syn_N40, u_Handshake_syn_N39, u_Handshake_syn_N38,
         u_Handshake_syn_N37, u_Handshake_syn_N36, u_Handshake_syn_N35,
         u_Handshake_syn_N34, u_Handshake_syn_N33, u_Handshake_syn_N32,
         u_Handshake_syn_N31, u_Handshake_syn_N30, u_Handshake_syn_N29,
         u_Handshake_syn_N28, u_Handshake_syn_N27, u_Handshake_syn_N26,
         u_Handshake_syn_N25, u_Handshake_syn_N24, u_Handshake_syn_N23,
         u_Handshake_syn_N22, u_Handshake_syn_N21, u_Handshake_syn_N20,
         u_Handshake_syn_N16, u_Handshake_syn_N10, u_Handshake_syn_sack,
         u_Handshake_syn_dack, u_Handshake_syn_dreq, u_Handshake_syn_sreq,
         u_Conv_N358, u_Conv_in_valid_reg, u_Conv_acc_count_y,
         u_Conv_acc_count_x, u_FIFO_syn_N13, u_FIFO_syn_N8, n540, n541, n542,
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
         n884, n885, n886, n887, n888, n889, n890, n891, n892, n893, n894,
         n895, n896, n897, n898, n899, n900, n901, n902, n903, n904, n905,
         n906, n907, n908, n909, n910, n911, n912, n913, n914, n915, n916,
         n917, n918, n919, n920, n921, n922, n923, n924, n925, n926, n927,
         n928, n929, n930, n931, n932, n933, n934, n936, n943, n944, n945,
         n946, n947, n948, n949, n950, n951, n952, n953, n954, n955, n956,
         n957, n958, n959, n960, n961, n962, n963, n964, n965, n966, n967,
         n968, n969, n970, n971, n972, n973, n974, n975, n976, n977, n978,
         n979, n980, n981, n982, n983, n984, n985, n986, n987, n988, n989,
         n990, n991, n992, n993, n994, n995, n996, n997, n998, n999, n1000,
         n1001, n1002, n1003, n1004, n1005, n1006, n1007, n1008, n1009, n1010,
         n1011, n1012, n1013, n1014, n1015, n1016, n1017, n1018, n1019, n1020,
         n1021, n1022, n1023, n1024, n1025, n1026, n1027, n1028, n1029, n1030,
         n1031, n1032, n1033, n1034, n1035, n1036, n1037, n1038, n1039, n1040,
         n1041, n1042, n1043, n1044, n1045, n1046, n1047, n1048, n1049, n1050,
         n1051, n1052, n1053, n1054, n1055, n1056, n1057, n1058, n1059, n1060,
         n1061, n1062, n1063, n1064, n1065, n1066, n1067, n1068, n1069, n1070,
         n1071, n1072, n1073, n1074, n1075, n1076, n1077, n1078, n1079, n1080,
         n1081, n1082, n1083, n1084, n1085, n1086, n1087, n1088, n1089, n1090,
         n1091, n1092, n1093, n1094, n1095, n1096, n1097, n1098, n1099, n1100,
         n1101, n1102, n1103, n1104, n1105, n1106, n1107, n1108, n1109, n1110,
         n1111, n1112, n1113, n1114, n1115, n1116, n1117, n1118, n1119, n1120,
         n1121, n1122, n1123, n1124, n1125, n1126, n1127, n1128, n1129, n1130,
         n1131, n1132, n1133, n1134, n1135, n1136, n1137, n1138, n1139, n1140,
         n1141, n1142, n1143, n1144, n1145, n1146, n1147, n1148, n1149, n1150,
         n1151, n1152, n1153, n1154, n1155, n1156, n1157, n1158, n1159, n1160,
         n1161, n1162, n1163, n1164, n1165, n1166, n1167, n1168, n1169, n1170,
         n1171, n1172, n1173, n1174, n1175, n1176, n1177, n1178, n1179, n1180,
         n1181, n1182, n1183, n1184, n1185, n1186, n1187, n1188, n1189, n1190,
         n1191, n1192, n1193, n1194, n1195, n1196, n1197, n1198, n1199, n1200,
         n1201, n1202, n1203, n1204, n1205, n1206, n1207, n1208, n1209, n1210,
         n1211, n1212, n1213, n1214, n1215, n1216, n1217, n1218, n1219, n1220,
         n1221, n1222, n1223, n1224, n1225, n1226, n1227, n1228, n1229, n1230,
         n1231, n1232, n1233, n1234, n1235, n1236, n1237, n1238, n1239, n1240,
         n1241, n1242, n1243, n1244, n1245, n1246, n1247, n1248, n1249, n1250,
         n1251, n1252, n1253, n1254, n1255, n1256, n1257, n1258, n1259, n1260,
         n1261, n1262, n1263, n1264, n1265, n1266, n1267, n1268, n1269, n1270,
         n1271, n1272, n1273, n1274, n1275, n1276, n1277, n1278, n1279, n1280,
         n1281, n1282, n1283, n1284, n1285, n1286, n1287, n1288, n1289, n1290,
         n1291, n1292, n1293, n1294, n1295, n1296, n1297, n1298, n1299, n1300,
         n1301, n1302, n1303, n1304, n1305, n1306, n1307, n1308, n1309, n1310,
         n1311, n1312, n1313, n1314, n1315, n1316, n1317, n1318, n1319, n1320,
         n1321, n1322, n1323, n1324, n1325, n1326, n1327, n1328, n1329, n1330,
         n1331, n1332, n1333, n1334, n1335, n1336, n1337, n1338, n1339, n1340,
         n1341, n1342, n1343, n1344, n1345, n1346, n1347, n1348, n1349, n1350,
         n1351, n1352, n1353, n1354, n1355, n1356, n1357, n1358, n1359, n1360,
         n1361, n1362, n1363, n1364, n1365, n1366, n1367, n1368, n1369, n1370,
         n1371, n1372, n1373, n1374, n1375, n1376, n1377, n1378, n1379, n1380,
         n1381, n1382, n1383, n1384, n1385, n1386, n1387, n1388, n1389, n1390,
         n1391, n1392, n1393, n1394, n1395, n1396, n1397, n1398, n1399, n1400,
         n1401, n1402, n1403, n1404, n1405, n1406, n1407, n1408, n1409, n1410,
         n1411, n1412, n1413, n1414, n1415, n1416, n1417, n1418, n1419, n1420,
         n1421, n1422, n1423, n1424, n1425, n1426, n1427, n1428, n1429, n1430,
         n1431, n1432, n1433, n1434, n1435, n1436, n1437, n1438, n1439, n1440,
         n1441, n1442, n1443, n1444, n1445, n1446, n1447, n1448, n1449, n1450,
         n1451, n1452, n1453, n1454, n1455, n1456, n1457, n1458, n1459, n1460,
         n1461, n1462, n1463, n1464, n1465, n1466, n1467, n1468, n1469, n1470,
         n1471, n1472, n1473, n1474, n1475, n1476, n1477, n1478, n1479, n1480,
         n1481, n1482, n1483, n1484, n1485, n1486, n1487, n1488, n1489, n1490,
         n1491, n1492, n1493, n1494, n1495, n1496, n1497, n1498, n1499, n1500,
         n1501, n1502, n1503, n1504, n1505, n1506, n1507, n1508, n1509, n1510,
         n1511, n1512, n1513, n1514, n1515, n1516, n1517, n1518, n1519, n1520,
         n1521, n1522, n1523, n1524, n1525, n1526, n1527, n1528, n1529, n1530,
         n1531, n1532, n1533, n1534, n1535, n1536, n1537, n1538, n1539, n1540,
         n1541, n1542, n1543, n1544, n1545, n1546, n1547, n1548, n1549, n1550,
         n1552;
  wire   [29:0] data_clk1;
  wire   [7:0] fifo_rdata;
  wire   [29:0] in_data_clk2;
  wire   [7:0] out_data_clk2;
  wire   [149:0] u_input_output_in_buffer;
  wire   [2:0] u_input_output_out_count;
  wire   [2:0] u_input_output_in_count;
  wire   [7:0] u_Conv_out_count;
  wire   [2:0] u_Conv_in_count;
  wire   [7:0] u_Conv_psum_reg;
  wire   [71:0] u_Conv_kernel_reg;
  wire   [107:0] u_Conv_ifmap_reg;
  wire   [2:0] u_Conv_kernel_idx;
  wire   [2:0] u_Conv_ifmap_y;
  wire   [2:0] u_Conv_ifmap_x;
  wire   [6:0] u_FIFO_syn_rptr_q;
  wire   [6:0] u_FIFO_syn_wptr_q;
  wire   [6:0] u_FIFO_syn_wptr;
  wire   [6:0] u_FIFO_syn_rptr;
  wire   [7:0] u_FIFO_syn_ram_out;
  wire   [5:0] u_FIFO_syn_w_addr;
  wire   [5:0] u_FIFO_syn_r_addr;

  NDFF_syn u_Handshake_syn_U_NDFF_ack ( .D(u_Handshake_syn_dack), .Q(
        u_Handshake_syn_sack), .clk(clk1), .rst_n(n1552) );
  NDFF_syn u_Handshake_syn_U_NDFF_req ( .D(u_Handshake_syn_sreq), .Q(
        u_Handshake_syn_dreq), .clk(clk2), .rst_n(n1552) );
  DUAL_64X8X1BM1 u_FIFO_syn_u_dual_sram ( .A0(u_FIFO_syn_w_addr[0]), .A1(
        u_FIFO_syn_w_addr[1]), .A2(u_FIFO_syn_w_addr[2]), .A3(
        u_FIFO_syn_w_addr[3]), .A4(u_FIFO_syn_w_addr[4]), .A5(
        u_FIFO_syn_w_addr[5]), .B0(u_FIFO_syn_r_addr[0]), .B1(
        u_FIFO_syn_r_addr[1]), .B2(u_FIFO_syn_r_addr[2]), .B3(
        u_FIFO_syn_r_addr[3]), .B4(u_FIFO_syn_r_addr[4]), .B5(
        u_FIFO_syn_r_addr[5]), .CKA(clk2), .CKB(clk1), .CSA(n551), .CSB(n551), 
        .DIA0(out_data_clk2[0]), .DIA1(out_data_clk2[1]), .DIA2(
        out_data_clk2[2]), .DIA3(out_data_clk2[3]), .DIA4(out_data_clk2[4]), 
        .DIA5(out_data_clk2[5]), .DIA6(out_data_clk2[6]), .DIA7(
        out_data_clk2[7]), .DIB0(u_input_output__Logic0_), .DIB1(
        u_input_output__Logic0_), .DIB2(u_input_output__Logic0_), .DIB3(
        u_input_output__Logic0_), .DIB4(u_input_output__Logic0_), .DIB5(
        u_input_output__Logic0_), .DIB6(u_input_output__Logic0_), .DIB7(
        u_input_output__Logic0_), .OEA(n551), .OEB(n551), .WEAN(n943), .WEBN(
        n551), .DOB0(u_FIFO_syn_ram_out[0]), .DOB1(u_FIFO_syn_ram_out[1]), 
        .DOB2(u_FIFO_syn_ram_out[2]), .DOB3(u_FIFO_syn_ram_out[3]), .DOB4(
        u_FIFO_syn_ram_out[4]), .DOB5(u_FIFO_syn_ram_out[5]), .DOB6(
        u_FIFO_syn_ram_out[6]), .DOB7(u_FIFO_syn_ram_out[7]) );
  NDFF_syn u_FIFO_syn_M1_genblk1_6__u_NDFF_syn ( .D(u_FIFO_syn_rptr[6]), .Q(
        u_FIFO_syn_rptr_q[6]), .clk(clk2), .rst_n(n1552) );
  NDFF_syn u_FIFO_syn_M1_genblk1_5__u_NDFF_syn ( .D(u_FIFO_syn_rptr[5]), .Q(
        u_FIFO_syn_rptr_q[5]), .clk(clk2), .rst_n(n1552) );
  NDFF_syn u_FIFO_syn_M1_genblk1_4__u_NDFF_syn ( .D(u_FIFO_syn_rptr[4]), .Q(
        u_FIFO_syn_rptr_q[4]), .clk(clk2), .rst_n(n1552) );
  NDFF_syn u_FIFO_syn_M1_genblk1_3__u_NDFF_syn ( .D(u_FIFO_syn_rptr[3]), .Q(
        u_FIFO_syn_rptr_q[3]), .clk(clk2), .rst_n(n1552) );
  NDFF_syn u_FIFO_syn_M1_genblk1_2__u_NDFF_syn ( .D(u_FIFO_syn_rptr[2]), .Q(
        u_FIFO_syn_rptr_q[2]), .clk(clk2), .rst_n(n1552) );
  NDFF_syn u_FIFO_syn_M1_genblk1_1__u_NDFF_syn ( .D(u_FIFO_syn_rptr[1]), .Q(
        u_FIFO_syn_rptr_q[1]), .clk(clk2), .rst_n(n1552) );
  NDFF_syn u_FIFO_syn_M1_genblk1_0__u_NDFF_syn ( .D(u_FIFO_syn_rptr[0]), .Q(
        u_FIFO_syn_rptr_q[0]), .clk(clk2), .rst_n(n1552) );
  NDFF_syn u_FIFO_syn_M0_genblk1_6__u_NDFF_syn ( .D(u_FIFO_syn_wptr[6]), .Q(
        u_FIFO_syn_wptr_q[6]), .clk(clk1), .rst_n(n1552) );
  NDFF_syn u_FIFO_syn_M0_genblk1_5__u_NDFF_syn ( .D(u_FIFO_syn_wptr[5]), .Q(
        u_FIFO_syn_wptr_q[5]), .clk(clk1), .rst_n(n1552) );
  NDFF_syn u_FIFO_syn_M0_genblk1_4__u_NDFF_syn ( .D(u_FIFO_syn_wptr[4]), .Q(
        u_FIFO_syn_wptr_q[4]), .clk(clk1), .rst_n(n1552) );
  NDFF_syn u_FIFO_syn_M0_genblk1_3__u_NDFF_syn ( .D(u_FIFO_syn_wptr[3]), .Q(
        u_FIFO_syn_wptr_q[3]), .clk(clk1), .rst_n(n1552) );
  NDFF_syn u_FIFO_syn_M0_genblk1_2__u_NDFF_syn ( .D(u_FIFO_syn_wptr[2]), .Q(
        u_FIFO_syn_wptr_q[2]), .clk(clk1), .rst_n(n1552) );
  NDFF_syn u_FIFO_syn_M0_genblk1_1__u_NDFF_syn ( .D(u_FIFO_syn_wptr[1]), .Q(
        u_FIFO_syn_wptr_q[1]), .clk(clk1), .rst_n(n1552) );
  NDFF_syn u_FIFO_syn_M0_genblk1_0__u_NDFF_syn ( .D(u_FIFO_syn_wptr[0]), .Q(
        u_FIFO_syn_wptr_q[0]), .clk(clk1), .rst_n(n1552) );
  QDFFRBS u_Handshake_syn_sreq_reg ( .D(u_Handshake_syn_N10), .CK(clk1), .RB(
        n944), .Q(u_Handshake_syn_sreq) );
  QDFFRBS u_input_output_out_count_reg_0_ ( .D(n1550), .CK(clk1), .RB(n944), 
        .Q(u_input_output_out_count[0]) );
  QDFFRBS u_input_output_out_count_reg_1_ ( .D(n934), .CK(clk1), .RB(n944), 
        .Q(u_input_output_out_count[1]) );
  QDFFRBS u_input_output_out_count_reg_2_ ( .D(n936), .CK(clk1), .RB(n944), 
        .Q(u_input_output_out_count[2]) );
  QDFFRBS u_input_output_in_count_reg_0_ ( .D(n932), .CK(clk1), .RB(n944), .Q(
        u_input_output_in_count[0]) );
  QDFFRBS u_input_output_in_count_reg_1_ ( .D(n933), .CK(clk1), .RB(n944), .Q(
        u_input_output_in_count[1]) );
  QDFFRBS u_input_output_in_count_reg_2_ ( .D(n931), .CK(clk1), .RB(n944), .Q(
        u_input_output_in_count[2]) );
  QDFFRBS u_FIFO_syn_wfull_reg ( .D(u_FIFO_syn_N13), .CK(clk2), .RB(n944), .Q(
        fifo_full) );
  QDFFRBS u_Conv_ifmap_y_reg_2_ ( .D(n737), .CK(clk2), .RB(n944), .Q(
        u_Conv_ifmap_y[2]) );
  QDFFRBS u_Conv_busy_reg ( .D(u_Conv_N358), .CK(clk2), .RB(n944), .Q(
        conv_busy) );
  QDFFRBS u_Handshake_syn_dack_reg ( .D(u_Handshake_syn_N16), .CK(clk2), .RB(
        rst_n), .Q(u_Handshake_syn_dack) );
  QDFFRBS u_Handshake_syn_dout_reg_0_ ( .D(u_Handshake_syn_N20), .CK(clk2), 
        .RB(n944), .Q(in_data_clk2[0]) );
  QDFFRBS u_Handshake_syn_dout_reg_1_ ( .D(u_Handshake_syn_N21), .CK(clk2), 
        .RB(rst_n), .Q(in_data_clk2[1]) );
  QDFFRBS u_Handshake_syn_dout_reg_2_ ( .D(u_Handshake_syn_N22), .CK(clk2), 
        .RB(rst_n), .Q(in_data_clk2[2]) );
  QDFFRBS u_Handshake_syn_dout_reg_3_ ( .D(u_Handshake_syn_N23), .CK(clk2), 
        .RB(n944), .Q(in_data_clk2[3]) );
  QDFFRBS u_Handshake_syn_dout_reg_4_ ( .D(u_Handshake_syn_N24), .CK(clk2), 
        .RB(rst_n), .Q(in_data_clk2[4]) );
  QDFFRBS u_Handshake_syn_dout_reg_5_ ( .D(u_Handshake_syn_N25), .CK(clk2), 
        .RB(n944), .Q(in_data_clk2[5]) );
  QDFFRBS u_Handshake_syn_dout_reg_6_ ( .D(u_Handshake_syn_N26), .CK(clk2), 
        .RB(n944), .Q(in_data_clk2[6]) );
  QDFFRBS u_Handshake_syn_dout_reg_7_ ( .D(u_Handshake_syn_N27), .CK(clk2), 
        .RB(rst_n), .Q(in_data_clk2[7]) );
  QDFFRBS u_Handshake_syn_dout_reg_8_ ( .D(u_Handshake_syn_N28), .CK(clk2), 
        .RB(n944), .Q(in_data_clk2[8]) );
  QDFFRBS u_Handshake_syn_dout_reg_9_ ( .D(u_Handshake_syn_N29), .CK(clk2), 
        .RB(n944), .Q(in_data_clk2[9]) );
  QDFFRBS u_Handshake_syn_dout_reg_10_ ( .D(u_Handshake_syn_N30), .CK(clk2), 
        .RB(n944), .Q(in_data_clk2[10]) );
  QDFFRBS u_Handshake_syn_dout_reg_11_ ( .D(u_Handshake_syn_N31), .CK(clk2), 
        .RB(n944), .Q(in_data_clk2[11]) );
  QDFFRBS u_Handshake_syn_dout_reg_12_ ( .D(u_Handshake_syn_N32), .CK(clk2), 
        .RB(n944), .Q(in_data_clk2[12]) );
  QDFFRBS u_Handshake_syn_dout_reg_13_ ( .D(u_Handshake_syn_N33), .CK(clk2), 
        .RB(n944), .Q(in_data_clk2[13]) );
  QDFFRBS u_Handshake_syn_dout_reg_14_ ( .D(u_Handshake_syn_N34), .CK(clk2), 
        .RB(n944), .Q(in_data_clk2[14]) );
  QDFFRBS u_Handshake_syn_dout_reg_15_ ( .D(u_Handshake_syn_N35), .CK(clk2), 
        .RB(n944), .Q(in_data_clk2[15]) );
  QDFFRBS u_Handshake_syn_dout_reg_16_ ( .D(u_Handshake_syn_N36), .CK(clk2), 
        .RB(n944), .Q(in_data_clk2[16]) );
  QDFFRBS u_Handshake_syn_dout_reg_17_ ( .D(u_Handshake_syn_N37), .CK(clk2), 
        .RB(n944), .Q(in_data_clk2[17]) );
  QDFFRBS u_Handshake_syn_dout_reg_18_ ( .D(u_Handshake_syn_N38), .CK(clk2), 
        .RB(n944), .Q(in_data_clk2[18]) );
  QDFFRBS u_Handshake_syn_dout_reg_19_ ( .D(u_Handshake_syn_N39), .CK(clk2), 
        .RB(n944), .Q(in_data_clk2[19]) );
  QDFFRBS u_Handshake_syn_dout_reg_20_ ( .D(u_Handshake_syn_N40), .CK(clk2), 
        .RB(n944), .Q(in_data_clk2[20]) );
  QDFFRBS u_Handshake_syn_dout_reg_21_ ( .D(u_Handshake_syn_N41), .CK(clk2), 
        .RB(n1552), .Q(in_data_clk2[21]) );
  QDFFRBS u_Handshake_syn_dout_reg_22_ ( .D(u_Handshake_syn_N42), .CK(clk2), 
        .RB(n1552), .Q(in_data_clk2[22]) );
  QDFFRBS u_Handshake_syn_dout_reg_23_ ( .D(u_Handshake_syn_N43), .CK(clk2), 
        .RB(n1552), .Q(in_data_clk2[23]) );
  QDFFRBS u_Handshake_syn_dout_reg_24_ ( .D(u_Handshake_syn_N44), .CK(clk2), 
        .RB(n1552), .Q(in_data_clk2[24]) );
  QDFFRBS u_Handshake_syn_dout_reg_25_ ( .D(u_Handshake_syn_N45), .CK(clk2), 
        .RB(n1552), .Q(in_data_clk2[25]) );
  QDFFRBS u_Handshake_syn_dout_reg_26_ ( .D(u_Handshake_syn_N46), .CK(clk2), 
        .RB(n1552), .Q(in_data_clk2[26]) );
  QDFFRBS u_Handshake_syn_dout_reg_27_ ( .D(u_Handshake_syn_N47), .CK(clk2), 
        .RB(n1552), .Q(in_data_clk2[27]) );
  QDFFRBS u_Handshake_syn_dout_reg_28_ ( .D(u_Handshake_syn_N48), .CK(clk2), 
        .RB(n1552), .Q(in_data_clk2[28]) );
  QDFFRBS u_Handshake_syn_dout_reg_29_ ( .D(u_Handshake_syn_N49), .CK(clk2), 
        .RB(n1552), .Q(in_data_clk2[29]) );
  QDFFRBS u_Handshake_syn_dvalid_reg ( .D(n1214), .CK(clk2), .RB(n1552), .Q(
        in_data_valid_clk2) );
  QDFFRBS u_Conv_in_valid_reg_reg ( .D(in_data_valid_clk2), .CK(clk2), .RB(
        n1552), .Q(u_Conv_in_valid_reg) );
  QDFFRBS u_Conv_in_count_reg_2_ ( .D(n734), .CK(clk2), .RB(n1552), .Q(
        u_Conv_in_count[2]) );
  QDFFRBS u_Conv_in_count_reg_1_ ( .D(n735), .CK(clk2), .RB(n1552), .Q(
        u_Conv_in_count[1]) );
  QDFFRBS u_Conv_out_count_reg_6_ ( .D(n750), .CK(clk2), .RB(n1552), .Q(
        u_Conv_out_count[6]) );
  QDFFRBS u_Conv_out_count_reg_0_ ( .D(n749), .CK(clk2), .RB(n1552), .Q(
        u_Conv_out_count[0]) );
  QDFFRBS u_Conv_out_count_reg_1_ ( .D(n748), .CK(clk2), .RB(n1552), .Q(
        u_Conv_out_count[1]) );
  QDFFRBS u_Conv_out_count_reg_2_ ( .D(n747), .CK(clk2), .RB(n1552), .Q(
        u_Conv_out_count[2]) );
  QDFFRBS u_Conv_out_count_reg_3_ ( .D(n746), .CK(clk2), .RB(n1552), .Q(
        u_Conv_out_count[3]) );
  QDFFRBS u_Conv_out_count_reg_4_ ( .D(n745), .CK(clk2), .RB(n1552), .Q(
        u_Conv_out_count[4]) );
  QDFFRBS u_Conv_out_count_reg_5_ ( .D(n744), .CK(clk2), .RB(n1552), .Q(
        u_Conv_out_count[5]) );
  QDFFRBS u_Conv_out_count_reg_7_ ( .D(n743), .CK(clk2), .RB(n1552), .Q(
        u_Conv_out_count[7]) );
  QDFFRBS u_Conv_ifmap_x_reg_2_ ( .D(n740), .CK(clk2), .RB(n1552), .Q(
        u_Conv_ifmap_x[2]) );
  QDFFRBS u_Conv_ifmap_x_reg_0_ ( .D(n741), .CK(clk2), .RB(n1552), .Q(
        u_Conv_ifmap_x[0]) );
  QDFFRBS u_Conv_ifmap_x_reg_1_ ( .D(n742), .CK(clk2), .RB(n1552), .Q(
        u_Conv_ifmap_x[1]) );
  QDFFRBS u_Conv_ifmap_y_reg_0_ ( .D(n738), .CK(clk2), .RB(n1552), .Q(
        u_Conv_ifmap_y[0]) );
  QDFFRBS u_Conv_ifmap_y_reg_1_ ( .D(n739), .CK(clk2), .RB(n1552), .Q(
        u_Conv_ifmap_y[1]) );
  QDFFRBS u_Conv_kernel_idx_reg_1_ ( .D(n553), .CK(clk2), .RB(n1552), .Q(
        u_Conv_kernel_idx[1]) );
  QDFFRBS u_Conv_kernel_idx_reg_2_ ( .D(n550), .CK(clk2), .RB(n1552), .Q(
        u_Conv_kernel_idx[2]) );
  QDFFRBS u_FIFO_syn_wptr_reg_0_ ( .D(n1539), .CK(clk2), .RB(n1552), .Q(
        u_FIFO_syn_wptr[0]) );
  QDFFRBS u_FIFO_syn_wptr_reg_1_ ( .D(n1538), .CK(clk2), .RB(n1552), .Q(
        u_FIFO_syn_wptr[1]) );
  QDFFRBS u_FIFO_syn_wptr_reg_2_ ( .D(n1537), .CK(clk2), .RB(n1552), .Q(
        u_FIFO_syn_wptr[2]) );
  QDFFRBS u_FIFO_syn_wptr_reg_3_ ( .D(n1542), .CK(clk2), .RB(n1552), .Q(
        u_FIFO_syn_wptr[3]) );
  QDFFRBS u_FIFO_syn_wptr_reg_4_ ( .D(n1541), .CK(clk2), .RB(n1552), .Q(
        u_FIFO_syn_wptr[4]) );
  QDFFRBS u_FIFO_syn_wptr_reg_5_ ( .D(n1536), .CK(clk2), .RB(n1552), .Q(
        u_FIFO_syn_wptr[5]) );
  QDFFRBS u_FIFO_syn_wptr_reg_6_ ( .D(n1540), .CK(clk2), .RB(n1552), .Q(
        u_FIFO_syn_wptr[6]) );
  QDFFRBS u_FIFO_syn_rptr_reg_0_ ( .D(n1545), .CK(clk1), .RB(rst_n), .Q(
        u_FIFO_syn_rptr[0]) );
  QDFFRBS u_FIFO_syn_rptr_reg_1_ ( .D(n1544), .CK(clk1), .RB(n944), .Q(
        u_FIFO_syn_rptr[1]) );
  QDFFRBS u_FIFO_syn_rptr_reg_2_ ( .D(n1546), .CK(clk1), .RB(n944), .Q(
        u_FIFO_syn_rptr[2]) );
  QDFFRBS u_FIFO_syn_rptr_reg_3_ ( .D(n1549), .CK(clk1), .RB(n944), .Q(
        u_FIFO_syn_rptr[3]) );
  QDFFRBS u_FIFO_syn_rptr_reg_4_ ( .D(n1543), .CK(clk1), .RB(n944), .Q(
        u_FIFO_syn_rptr[4]) );
  QDFFRBS u_FIFO_syn_rptr_reg_5_ ( .D(n1547), .CK(clk1), .RB(n944), .Q(
        u_FIFO_syn_rptr[5]) );
  QDFFRBS u_FIFO_syn_rptr_reg_6_ ( .D(n1548), .CK(clk1), .RB(n944), .Q(
        u_FIFO_syn_rptr[6]) );
  QDFFRBS u_FIFO_syn_w_binary_reg_reg_0_ ( .D(n1524), .CK(clk2), .RB(n1552), 
        .Q(u_FIFO_syn_w_addr[0]) );
  QDFFRBS u_FIFO_syn_w_binary_reg_reg_1_ ( .D(n1525), .CK(clk2), .RB(n1552), 
        .Q(u_FIFO_syn_w_addr[1]) );
  QDFFRBS u_FIFO_syn_w_binary_reg_reg_2_ ( .D(n1526), .CK(clk2), .RB(n1552), 
        .Q(u_FIFO_syn_w_addr[2]) );
  QDFFRBS u_FIFO_syn_w_binary_reg_reg_3_ ( .D(n1527), .CK(clk2), .RB(n1552), 
        .Q(u_FIFO_syn_w_addr[3]) );
  QDFFRBS u_FIFO_syn_w_binary_reg_reg_4_ ( .D(n1528), .CK(clk2), .RB(n1552), 
        .Q(u_FIFO_syn_w_addr[4]) );
  QDFFRBS u_FIFO_syn_w_binary_reg_reg_5_ ( .D(n1529), .CK(clk2), .RB(n1552), 
        .Q(u_FIFO_syn_w_addr[5]) );
  QDFFRBS u_FIFO_syn_r_binary_reg_reg_0_ ( .D(n1530), .CK(clk1), .RB(n944), 
        .Q(u_FIFO_syn_r_addr[0]) );
  QDFFRBS u_FIFO_syn_r_binary_reg_reg_1_ ( .D(n1531), .CK(clk1), .RB(n944), 
        .Q(u_FIFO_syn_r_addr[1]) );
  QDFFRBS u_FIFO_syn_r_binary_reg_reg_2_ ( .D(n1532), .CK(clk1), .RB(n944), 
        .Q(u_FIFO_syn_r_addr[2]) );
  QDFFRBS u_FIFO_syn_r_binary_reg_reg_3_ ( .D(n1533), .CK(clk1), .RB(n944), 
        .Q(u_FIFO_syn_r_addr[3]) );
  QDFFRBS u_FIFO_syn_r_binary_reg_reg_4_ ( .D(n1534), .CK(clk1), .RB(n944), 
        .Q(u_FIFO_syn_r_addr[4]) );
  QDFFRBS u_FIFO_syn_r_binary_reg_reg_5_ ( .D(n1535), .CK(clk1), .RB(n944), 
        .Q(u_FIFO_syn_r_addr[5]) );
  QDFFS u_input_output_in_buffer_reg_5__0_ ( .D(n930), .CK(clk1), .Q(
        u_input_output_in_buffer[0]) );
  QDFFS u_input_output_in_buffer_reg_5__29_ ( .D(n929), .CK(clk1), .Q(
        u_input_output_in_buffer[29]) );
  QDFFS u_input_output_in_buffer_reg_5__28_ ( .D(n928), .CK(clk1), .Q(
        u_input_output_in_buffer[28]) );
  QDFFS u_input_output_in_buffer_reg_5__27_ ( .D(n927), .CK(clk1), .Q(
        u_input_output_in_buffer[27]) );
  QDFFS u_input_output_in_buffer_reg_5__26_ ( .D(n926), .CK(clk1), .Q(
        u_input_output_in_buffer[26]) );
  QDFFS u_input_output_in_buffer_reg_5__25_ ( .D(n925), .CK(clk1), .Q(
        u_input_output_in_buffer[25]) );
  QDFFS u_input_output_in_buffer_reg_5__24_ ( .D(n924), .CK(clk1), .Q(
        u_input_output_in_buffer[24]) );
  QDFFS u_input_output_in_buffer_reg_5__23_ ( .D(n923), .CK(clk1), .Q(
        u_input_output_in_buffer[23]) );
  QDFFS u_input_output_in_buffer_reg_5__22_ ( .D(n922), .CK(clk1), .Q(
        u_input_output_in_buffer[22]) );
  QDFFS u_input_output_in_buffer_reg_5__21_ ( .D(n921), .CK(clk1), .Q(
        u_input_output_in_buffer[21]) );
  QDFFS u_input_output_in_buffer_reg_5__20_ ( .D(n920), .CK(clk1), .Q(
        u_input_output_in_buffer[20]) );
  QDFFS u_input_output_in_buffer_reg_5__19_ ( .D(n919), .CK(clk1), .Q(
        u_input_output_in_buffer[19]) );
  QDFFS u_input_output_in_buffer_reg_5__18_ ( .D(n918), .CK(clk1), .Q(
        u_input_output_in_buffer[18]) );
  QDFFS u_input_output_in_buffer_reg_5__17_ ( .D(n917), .CK(clk1), .Q(
        u_input_output_in_buffer[17]) );
  QDFFS u_input_output_in_buffer_reg_5__16_ ( .D(n916), .CK(clk1), .Q(
        u_input_output_in_buffer[16]) );
  QDFFS u_input_output_in_buffer_reg_5__15_ ( .D(n915), .CK(clk1), .Q(
        u_input_output_in_buffer[15]) );
  QDFFS u_input_output_in_buffer_reg_5__14_ ( .D(n914), .CK(clk1), .Q(
        u_input_output_in_buffer[14]) );
  QDFFS u_input_output_in_buffer_reg_5__13_ ( .D(n913), .CK(clk1), .Q(
        u_input_output_in_buffer[13]) );
  QDFFS u_input_output_in_buffer_reg_5__12_ ( .D(n912), .CK(clk1), .Q(
        u_input_output_in_buffer[12]) );
  QDFFS u_input_output_in_buffer_reg_5__11_ ( .D(n911), .CK(clk1), .Q(
        u_input_output_in_buffer[11]) );
  QDFFS u_input_output_in_buffer_reg_5__10_ ( .D(n910), .CK(clk1), .Q(
        u_input_output_in_buffer[10]) );
  QDFFS u_input_output_in_buffer_reg_5__9_ ( .D(n909), .CK(clk1), .Q(
        u_input_output_in_buffer[9]) );
  QDFFS u_input_output_in_buffer_reg_5__8_ ( .D(n908), .CK(clk1), .Q(
        u_input_output_in_buffer[8]) );
  QDFFS u_input_output_in_buffer_reg_5__7_ ( .D(n907), .CK(clk1), .Q(
        u_input_output_in_buffer[7]) );
  QDFFS u_input_output_in_buffer_reg_5__6_ ( .D(n906), .CK(clk1), .Q(
        u_input_output_in_buffer[6]) );
  QDFFS u_input_output_in_buffer_reg_5__5_ ( .D(n905), .CK(clk1), .Q(
        u_input_output_in_buffer[5]) );
  QDFFS u_input_output_in_buffer_reg_5__4_ ( .D(n904), .CK(clk1), .Q(
        u_input_output_in_buffer[4]) );
  QDFFS u_input_output_in_buffer_reg_5__3_ ( .D(n903), .CK(clk1), .Q(
        u_input_output_in_buffer[3]) );
  QDFFS u_input_output_in_buffer_reg_5__2_ ( .D(n902), .CK(clk1), .Q(
        u_input_output_in_buffer[2]) );
  QDFFS u_input_output_in_buffer_reg_5__1_ ( .D(n901), .CK(clk1), .Q(
        u_input_output_in_buffer[1]) );
  QDFFS u_input_output_in_buffer_reg_4__0_ ( .D(n900), .CK(clk1), .Q(
        u_input_output_in_buffer[30]) );
  QDFFS u_input_output_in_buffer_reg_4__29_ ( .D(n899), .CK(clk1), .Q(
        u_input_output_in_buffer[59]) );
  QDFFS u_input_output_in_buffer_reg_4__28_ ( .D(n898), .CK(clk1), .Q(
        u_input_output_in_buffer[58]) );
  QDFFS u_input_output_in_buffer_reg_4__27_ ( .D(n897), .CK(clk1), .Q(
        u_input_output_in_buffer[57]) );
  QDFFS u_input_output_in_buffer_reg_4__26_ ( .D(n896), .CK(clk1), .Q(
        u_input_output_in_buffer[56]) );
  QDFFS u_input_output_in_buffer_reg_4__25_ ( .D(n895), .CK(clk1), .Q(
        u_input_output_in_buffer[55]) );
  QDFFS u_input_output_in_buffer_reg_4__24_ ( .D(n894), .CK(clk1), .Q(
        u_input_output_in_buffer[54]) );
  QDFFS u_input_output_in_buffer_reg_4__23_ ( .D(n893), .CK(clk1), .Q(
        u_input_output_in_buffer[53]) );
  QDFFS u_input_output_in_buffer_reg_4__22_ ( .D(n892), .CK(clk1), .Q(
        u_input_output_in_buffer[52]) );
  QDFFS u_input_output_in_buffer_reg_4__21_ ( .D(n891), .CK(clk1), .Q(
        u_input_output_in_buffer[51]) );
  QDFFS u_input_output_in_buffer_reg_4__20_ ( .D(n890), .CK(clk1), .Q(
        u_input_output_in_buffer[50]) );
  QDFFS u_input_output_in_buffer_reg_4__19_ ( .D(n889), .CK(clk1), .Q(
        u_input_output_in_buffer[49]) );
  QDFFS u_input_output_in_buffer_reg_4__18_ ( .D(n888), .CK(clk1), .Q(
        u_input_output_in_buffer[48]) );
  QDFFS u_input_output_in_buffer_reg_4__17_ ( .D(n887), .CK(clk1), .Q(
        u_input_output_in_buffer[47]) );
  QDFFS u_input_output_in_buffer_reg_4__16_ ( .D(n886), .CK(clk1), .Q(
        u_input_output_in_buffer[46]) );
  QDFFS u_input_output_in_buffer_reg_4__15_ ( .D(n885), .CK(clk1), .Q(
        u_input_output_in_buffer[45]) );
  QDFFS u_input_output_in_buffer_reg_4__14_ ( .D(n884), .CK(clk1), .Q(
        u_input_output_in_buffer[44]) );
  QDFFS u_input_output_in_buffer_reg_4__13_ ( .D(n883), .CK(clk1), .Q(
        u_input_output_in_buffer[43]) );
  QDFFS u_input_output_in_buffer_reg_4__12_ ( .D(n882), .CK(clk1), .Q(
        u_input_output_in_buffer[42]) );
  QDFFS u_input_output_in_buffer_reg_4__11_ ( .D(n881), .CK(clk1), .Q(
        u_input_output_in_buffer[41]) );
  QDFFS u_input_output_in_buffer_reg_4__10_ ( .D(n880), .CK(clk1), .Q(
        u_input_output_in_buffer[40]) );
  QDFFS u_input_output_in_buffer_reg_4__9_ ( .D(n879), .CK(clk1), .Q(
        u_input_output_in_buffer[39]) );
  QDFFS u_input_output_in_buffer_reg_4__8_ ( .D(n878), .CK(clk1), .Q(
        u_input_output_in_buffer[38]) );
  QDFFS u_input_output_in_buffer_reg_4__7_ ( .D(n877), .CK(clk1), .Q(
        u_input_output_in_buffer[37]) );
  QDFFS u_input_output_in_buffer_reg_4__6_ ( .D(n876), .CK(clk1), .Q(
        u_input_output_in_buffer[36]) );
  QDFFS u_input_output_in_buffer_reg_4__5_ ( .D(n875), .CK(clk1), .Q(
        u_input_output_in_buffer[35]) );
  QDFFS u_input_output_in_buffer_reg_4__4_ ( .D(n874), .CK(clk1), .Q(
        u_input_output_in_buffer[34]) );
  QDFFS u_input_output_in_buffer_reg_4__3_ ( .D(n873), .CK(clk1), .Q(
        u_input_output_in_buffer[33]) );
  QDFFS u_input_output_in_buffer_reg_4__2_ ( .D(n872), .CK(clk1), .Q(
        u_input_output_in_buffer[32]) );
  QDFFS u_input_output_in_buffer_reg_4__1_ ( .D(n871), .CK(clk1), .Q(
        u_input_output_in_buffer[31]) );
  QDFFS u_input_output_in_buffer_reg_3__0_ ( .D(n870), .CK(clk1), .Q(
        u_input_output_in_buffer[60]) );
  QDFFS u_input_output_in_buffer_reg_3__29_ ( .D(n869), .CK(clk1), .Q(
        u_input_output_in_buffer[89]) );
  QDFFS u_input_output_in_buffer_reg_3__28_ ( .D(n868), .CK(clk1), .Q(
        u_input_output_in_buffer[88]) );
  QDFFS u_input_output_in_buffer_reg_3__27_ ( .D(n867), .CK(clk1), .Q(
        u_input_output_in_buffer[87]) );
  QDFFS u_input_output_in_buffer_reg_3__26_ ( .D(n866), .CK(clk1), .Q(
        u_input_output_in_buffer[86]) );
  QDFFS u_input_output_in_buffer_reg_3__25_ ( .D(n865), .CK(clk1), .Q(
        u_input_output_in_buffer[85]) );
  QDFFS u_input_output_in_buffer_reg_3__24_ ( .D(n864), .CK(clk1), .Q(
        u_input_output_in_buffer[84]) );
  QDFFS u_input_output_in_buffer_reg_3__23_ ( .D(n863), .CK(clk1), .Q(
        u_input_output_in_buffer[83]) );
  QDFFS u_input_output_in_buffer_reg_3__22_ ( .D(n862), .CK(clk1), .Q(
        u_input_output_in_buffer[82]) );
  QDFFS u_input_output_in_buffer_reg_3__21_ ( .D(n861), .CK(clk1), .Q(
        u_input_output_in_buffer[81]) );
  QDFFS u_input_output_in_buffer_reg_3__20_ ( .D(n860), .CK(clk1), .Q(
        u_input_output_in_buffer[80]) );
  QDFFS u_input_output_in_buffer_reg_3__19_ ( .D(n859), .CK(clk1), .Q(
        u_input_output_in_buffer[79]) );
  QDFFS u_input_output_in_buffer_reg_3__18_ ( .D(n858), .CK(clk1), .Q(
        u_input_output_in_buffer[78]) );
  QDFFS u_input_output_in_buffer_reg_3__17_ ( .D(n857), .CK(clk1), .Q(
        u_input_output_in_buffer[77]) );
  QDFFS u_input_output_in_buffer_reg_3__16_ ( .D(n856), .CK(clk1), .Q(
        u_input_output_in_buffer[76]) );
  QDFFS u_input_output_in_buffer_reg_3__15_ ( .D(n855), .CK(clk1), .Q(
        u_input_output_in_buffer[75]) );
  QDFFS u_input_output_in_buffer_reg_3__14_ ( .D(n854), .CK(clk1), .Q(
        u_input_output_in_buffer[74]) );
  QDFFS u_input_output_in_buffer_reg_3__13_ ( .D(n853), .CK(clk1), .Q(
        u_input_output_in_buffer[73]) );
  QDFFS u_input_output_in_buffer_reg_3__12_ ( .D(n852), .CK(clk1), .Q(
        u_input_output_in_buffer[72]) );
  QDFFS u_input_output_in_buffer_reg_3__11_ ( .D(n851), .CK(clk1), .Q(
        u_input_output_in_buffer[71]) );
  QDFFS u_input_output_in_buffer_reg_3__10_ ( .D(n850), .CK(clk1), .Q(
        u_input_output_in_buffer[70]) );
  QDFFS u_input_output_in_buffer_reg_3__9_ ( .D(n849), .CK(clk1), .Q(
        u_input_output_in_buffer[69]) );
  QDFFS u_input_output_in_buffer_reg_3__8_ ( .D(n848), .CK(clk1), .Q(
        u_input_output_in_buffer[68]) );
  QDFFS u_input_output_in_buffer_reg_3__7_ ( .D(n847), .CK(clk1), .Q(
        u_input_output_in_buffer[67]) );
  QDFFS u_input_output_in_buffer_reg_3__6_ ( .D(n846), .CK(clk1), .Q(
        u_input_output_in_buffer[66]) );
  QDFFS u_input_output_in_buffer_reg_3__5_ ( .D(n845), .CK(clk1), .Q(
        u_input_output_in_buffer[65]) );
  QDFFS u_input_output_in_buffer_reg_3__4_ ( .D(n844), .CK(clk1), .Q(
        u_input_output_in_buffer[64]) );
  QDFFS u_input_output_in_buffer_reg_3__3_ ( .D(n843), .CK(clk1), .Q(
        u_input_output_in_buffer[63]) );
  QDFFS u_input_output_in_buffer_reg_3__2_ ( .D(n842), .CK(clk1), .Q(
        u_input_output_in_buffer[62]) );
  QDFFS u_input_output_in_buffer_reg_3__1_ ( .D(n841), .CK(clk1), .Q(
        u_input_output_in_buffer[61]) );
  QDFFS u_input_output_in_buffer_reg_2__0_ ( .D(n840), .CK(clk1), .Q(
        u_input_output_in_buffer[90]) );
  QDFFS u_input_output_in_buffer_reg_2__29_ ( .D(n839), .CK(clk1), .Q(
        u_input_output_in_buffer[119]) );
  QDFFS u_input_output_in_buffer_reg_2__28_ ( .D(n838), .CK(clk1), .Q(
        u_input_output_in_buffer[118]) );
  QDFFS u_input_output_in_buffer_reg_2__27_ ( .D(n837), .CK(clk1), .Q(
        u_input_output_in_buffer[117]) );
  QDFFS u_input_output_in_buffer_reg_2__26_ ( .D(n836), .CK(clk1), .Q(
        u_input_output_in_buffer[116]) );
  QDFFS u_input_output_in_buffer_reg_2__25_ ( .D(n835), .CK(clk1), .Q(
        u_input_output_in_buffer[115]) );
  QDFFS u_input_output_in_buffer_reg_2__24_ ( .D(n834), .CK(clk1), .Q(
        u_input_output_in_buffer[114]) );
  QDFFS u_input_output_in_buffer_reg_2__23_ ( .D(n833), .CK(clk1), .Q(
        u_input_output_in_buffer[113]) );
  QDFFS u_input_output_in_buffer_reg_2__22_ ( .D(n832), .CK(clk1), .Q(
        u_input_output_in_buffer[112]) );
  QDFFS u_input_output_in_buffer_reg_2__21_ ( .D(n831), .CK(clk1), .Q(
        u_input_output_in_buffer[111]) );
  QDFFS u_input_output_in_buffer_reg_2__20_ ( .D(n830), .CK(clk1), .Q(
        u_input_output_in_buffer[110]) );
  QDFFS u_input_output_in_buffer_reg_2__19_ ( .D(n829), .CK(clk1), .Q(
        u_input_output_in_buffer[109]) );
  QDFFS u_input_output_in_buffer_reg_2__18_ ( .D(n828), .CK(clk1), .Q(
        u_input_output_in_buffer[108]) );
  QDFFS u_input_output_in_buffer_reg_2__17_ ( .D(n827), .CK(clk1), .Q(
        u_input_output_in_buffer[107]) );
  QDFFS u_input_output_in_buffer_reg_2__16_ ( .D(n826), .CK(clk1), .Q(
        u_input_output_in_buffer[106]) );
  QDFFS u_input_output_in_buffer_reg_2__15_ ( .D(n825), .CK(clk1), .Q(
        u_input_output_in_buffer[105]) );
  QDFFS u_input_output_in_buffer_reg_2__14_ ( .D(n824), .CK(clk1), .Q(
        u_input_output_in_buffer[104]) );
  QDFFS u_input_output_in_buffer_reg_2__13_ ( .D(n823), .CK(clk1), .Q(
        u_input_output_in_buffer[103]) );
  QDFFS u_input_output_in_buffer_reg_2__12_ ( .D(n822), .CK(clk1), .Q(
        u_input_output_in_buffer[102]) );
  QDFFS u_input_output_in_buffer_reg_2__11_ ( .D(n821), .CK(clk1), .Q(
        u_input_output_in_buffer[101]) );
  QDFFS u_input_output_in_buffer_reg_2__10_ ( .D(n820), .CK(clk1), .Q(
        u_input_output_in_buffer[100]) );
  QDFFS u_input_output_in_buffer_reg_2__9_ ( .D(n819), .CK(clk1), .Q(
        u_input_output_in_buffer[99]) );
  QDFFS u_input_output_in_buffer_reg_2__8_ ( .D(n818), .CK(clk1), .Q(
        u_input_output_in_buffer[98]) );
  QDFFS u_input_output_in_buffer_reg_2__7_ ( .D(n817), .CK(clk1), .Q(
        u_input_output_in_buffer[97]) );
  QDFFS u_input_output_in_buffer_reg_2__6_ ( .D(n816), .CK(clk1), .Q(
        u_input_output_in_buffer[96]) );
  QDFFS u_input_output_in_buffer_reg_2__5_ ( .D(n815), .CK(clk1), .Q(
        u_input_output_in_buffer[95]) );
  QDFFS u_input_output_in_buffer_reg_2__4_ ( .D(n814), .CK(clk1), .Q(
        u_input_output_in_buffer[94]) );
  QDFFS u_input_output_in_buffer_reg_2__3_ ( .D(n813), .CK(clk1), .Q(
        u_input_output_in_buffer[93]) );
  QDFFS u_input_output_in_buffer_reg_2__2_ ( .D(n812), .CK(clk1), .Q(
        u_input_output_in_buffer[92]) );
  QDFFS u_input_output_in_buffer_reg_2__1_ ( .D(n811), .CK(clk1), .Q(
        u_input_output_in_buffer[91]) );
  QDFFS u_input_output_in_buffer_reg_1__0_ ( .D(n810), .CK(clk1), .Q(
        u_input_output_in_buffer[120]) );
  QDFFS u_input_output_in_buffer_reg_1__29_ ( .D(n809), .CK(clk1), .Q(
        u_input_output_in_buffer[149]) );
  QDFFS u_input_output_in_buffer_reg_1__28_ ( .D(n808), .CK(clk1), .Q(
        u_input_output_in_buffer[148]) );
  QDFFS u_input_output_in_buffer_reg_1__27_ ( .D(n807), .CK(clk1), .Q(
        u_input_output_in_buffer[147]) );
  QDFFS u_input_output_in_buffer_reg_1__26_ ( .D(n806), .CK(clk1), .Q(
        u_input_output_in_buffer[146]) );
  QDFFS u_input_output_in_buffer_reg_1__25_ ( .D(n805), .CK(clk1), .Q(
        u_input_output_in_buffer[145]) );
  QDFFS u_input_output_in_buffer_reg_1__24_ ( .D(n804), .CK(clk1), .Q(
        u_input_output_in_buffer[144]) );
  QDFFS u_input_output_in_buffer_reg_1__23_ ( .D(n803), .CK(clk1), .Q(
        u_input_output_in_buffer[143]) );
  QDFFS u_input_output_in_buffer_reg_1__22_ ( .D(n802), .CK(clk1), .Q(
        u_input_output_in_buffer[142]) );
  QDFFS u_input_output_in_buffer_reg_1__21_ ( .D(n801), .CK(clk1), .Q(
        u_input_output_in_buffer[141]) );
  QDFFS u_input_output_in_buffer_reg_1__20_ ( .D(n800), .CK(clk1), .Q(
        u_input_output_in_buffer[140]) );
  QDFFS u_input_output_in_buffer_reg_1__19_ ( .D(n799), .CK(clk1), .Q(
        u_input_output_in_buffer[139]) );
  QDFFS u_input_output_in_buffer_reg_1__18_ ( .D(n798), .CK(clk1), .Q(
        u_input_output_in_buffer[138]) );
  QDFFS u_input_output_in_buffer_reg_1__17_ ( .D(n797), .CK(clk1), .Q(
        u_input_output_in_buffer[137]) );
  QDFFS u_input_output_in_buffer_reg_1__16_ ( .D(n796), .CK(clk1), .Q(
        u_input_output_in_buffer[136]) );
  QDFFS u_input_output_in_buffer_reg_1__15_ ( .D(n795), .CK(clk1), .Q(
        u_input_output_in_buffer[135]) );
  QDFFS u_input_output_in_buffer_reg_1__14_ ( .D(n794), .CK(clk1), .Q(
        u_input_output_in_buffer[134]) );
  QDFFS u_input_output_in_buffer_reg_1__13_ ( .D(n793), .CK(clk1), .Q(
        u_input_output_in_buffer[133]) );
  QDFFS u_input_output_in_buffer_reg_1__12_ ( .D(n792), .CK(clk1), .Q(
        u_input_output_in_buffer[132]) );
  QDFFS u_input_output_in_buffer_reg_1__11_ ( .D(n791), .CK(clk1), .Q(
        u_input_output_in_buffer[131]) );
  QDFFS u_input_output_in_buffer_reg_1__10_ ( .D(n790), .CK(clk1), .Q(
        u_input_output_in_buffer[130]) );
  QDFFS u_input_output_in_buffer_reg_1__9_ ( .D(n789), .CK(clk1), .Q(
        u_input_output_in_buffer[129]) );
  QDFFS u_input_output_in_buffer_reg_1__8_ ( .D(n788), .CK(clk1), .Q(
        u_input_output_in_buffer[128]) );
  QDFFS u_input_output_in_buffer_reg_1__7_ ( .D(n787), .CK(clk1), .Q(
        u_input_output_in_buffer[127]) );
  QDFFS u_input_output_in_buffer_reg_1__6_ ( .D(n786), .CK(clk1), .Q(
        u_input_output_in_buffer[126]) );
  QDFFS u_input_output_in_buffer_reg_1__5_ ( .D(n785), .CK(clk1), .Q(
        u_input_output_in_buffer[125]) );
  QDFFS u_input_output_in_buffer_reg_1__4_ ( .D(n784), .CK(clk1), .Q(
        u_input_output_in_buffer[124]) );
  QDFFS u_input_output_in_buffer_reg_1__3_ ( .D(n783), .CK(clk1), .Q(
        u_input_output_in_buffer[123]) );
  QDFFS u_input_output_in_buffer_reg_1__2_ ( .D(n782), .CK(clk1), .Q(
        u_input_output_in_buffer[122]) );
  QDFFS u_input_output_in_buffer_reg_1__1_ ( .D(n781), .CK(clk1), .Q(
        u_input_output_in_buffer[121]) );
  QDFFS u_input_output_handshake_din_reg_0_ ( .D(n780), .CK(clk1), .Q(
        data_clk1[0]) );
  QDFFS u_input_output_handshake_din_reg_1_ ( .D(n779), .CK(clk1), .Q(
        data_clk1[1]) );
  QDFFS u_input_output_handshake_din_reg_2_ ( .D(n778), .CK(clk1), .Q(
        data_clk1[2]) );
  QDFFS u_input_output_handshake_din_reg_3_ ( .D(n777), .CK(clk1), .Q(
        data_clk1[3]) );
  QDFFS u_input_output_handshake_din_reg_4_ ( .D(n776), .CK(clk1), .Q(
        data_clk1[4]) );
  QDFFS u_input_output_handshake_din_reg_5_ ( .D(n775), .CK(clk1), .Q(
        data_clk1[5]) );
  QDFFS u_input_output_handshake_din_reg_6_ ( .D(n774), .CK(clk1), .Q(
        data_clk1[6]) );
  QDFFS u_input_output_handshake_din_reg_7_ ( .D(n773), .CK(clk1), .Q(
        data_clk1[7]) );
  QDFFS u_input_output_handshake_din_reg_8_ ( .D(n772), .CK(clk1), .Q(
        data_clk1[8]) );
  QDFFS u_input_output_handshake_din_reg_9_ ( .D(n771), .CK(clk1), .Q(
        data_clk1[9]) );
  QDFFS u_input_output_handshake_din_reg_10_ ( .D(n770), .CK(clk1), .Q(
        data_clk1[10]) );
  QDFFS u_input_output_handshake_din_reg_11_ ( .D(n769), .CK(clk1), .Q(
        data_clk1[11]) );
  QDFFS u_input_output_handshake_din_reg_12_ ( .D(n768), .CK(clk1), .Q(
        data_clk1[12]) );
  QDFFS u_input_output_handshake_din_reg_13_ ( .D(n767), .CK(clk1), .Q(
        data_clk1[13]) );
  QDFFS u_input_output_handshake_din_reg_14_ ( .D(n766), .CK(clk1), .Q(
        data_clk1[14]) );
  QDFFS u_input_output_handshake_din_reg_15_ ( .D(n765), .CK(clk1), .Q(
        data_clk1[15]) );
  QDFFS u_input_output_handshake_din_reg_16_ ( .D(n764), .CK(clk1), .Q(
        data_clk1[16]) );
  QDFFS u_input_output_handshake_din_reg_17_ ( .D(n763), .CK(clk1), .Q(
        data_clk1[17]) );
  QDFFS u_input_output_handshake_din_reg_18_ ( .D(n762), .CK(clk1), .Q(
        data_clk1[18]) );
  QDFFS u_input_output_handshake_din_reg_19_ ( .D(n761), .CK(clk1), .Q(
        data_clk1[19]) );
  QDFFS u_input_output_handshake_din_reg_20_ ( .D(n760), .CK(clk1), .Q(
        data_clk1[20]) );
  QDFFS u_input_output_handshake_din_reg_21_ ( .D(n759), .CK(clk1), .Q(
        data_clk1[21]) );
  QDFFS u_input_output_handshake_din_reg_22_ ( .D(n758), .CK(clk1), .Q(
        data_clk1[22]) );
  QDFFS u_input_output_handshake_din_reg_23_ ( .D(n757), .CK(clk1), .Q(
        data_clk1[23]) );
  QDFFS u_input_output_handshake_din_reg_24_ ( .D(n756), .CK(clk1), .Q(
        data_clk1[24]) );
  QDFFS u_input_output_handshake_din_reg_25_ ( .D(n755), .CK(clk1), .Q(
        data_clk1[25]) );
  QDFFS u_input_output_handshake_din_reg_26_ ( .D(n754), .CK(clk1), .Q(
        data_clk1[26]) );
  QDFFS u_input_output_handshake_din_reg_27_ ( .D(n753), .CK(clk1), .Q(
        data_clk1[27]) );
  QDFFS u_input_output_handshake_din_reg_28_ ( .D(n752), .CK(clk1), .Q(
        data_clk1[28]) );
  QDFFS u_input_output_handshake_din_reg_29_ ( .D(n751), .CK(clk1), .Q(
        data_clk1[29]) );
  QDFFS u_Conv_kernel_reg_reg_0__0__0_ ( .D(n733), .CK(clk2), .Q(
        u_Conv_kernel_reg[69]) );
  QDFFS u_Conv_kernel_reg_reg_0__0__1_ ( .D(n727), .CK(clk2), .Q(
        u_Conv_kernel_reg[70]) );
  QDFFS u_Conv_kernel_reg_reg_0__0__2_ ( .D(n721), .CK(clk2), .Q(
        u_Conv_kernel_reg[71]) );
  QDFFS u_Conv_kernel_reg_reg_1__0__0_ ( .D(n715), .CK(clk2), .Q(
        u_Conv_kernel_reg[51]) );
  QDFFS u_Conv_kernel_reg_reg_1__0__1_ ( .D(n709), .CK(clk2), .Q(
        u_Conv_kernel_reg[52]) );
  QDFFS u_Conv_kernel_reg_reg_1__0__2_ ( .D(n703), .CK(clk2), .Q(
        u_Conv_kernel_reg[53]) );
  QDFFS u_Conv_kernel_reg_reg_2__0__0_ ( .D(n697), .CK(clk2), .Q(
        u_Conv_kernel_reg[33]) );
  QDFFS u_Conv_kernel_reg_reg_2__0__1_ ( .D(n691), .CK(clk2), .Q(
        u_Conv_kernel_reg[34]) );
  QDFFS u_Conv_kernel_reg_reg_2__0__2_ ( .D(n685), .CK(clk2), .Q(
        u_Conv_kernel_reg[35]) );
  QDFFS u_Conv_kernel_reg_reg_3__0__0_ ( .D(n679), .CK(clk2), .Q(
        u_Conv_kernel_reg[15]) );
  QDFFS u_Conv_kernel_reg_reg_3__0__1_ ( .D(n673), .CK(clk2), .Q(
        u_Conv_kernel_reg[16]) );
  QDFFS u_Conv_kernel_reg_reg_3__0__2_ ( .D(n667), .CK(clk2), .Q(
        u_Conv_kernel_reg[17]) );
  QDFFS u_Conv_ifmap_reg_reg_0__0__0_ ( .D(n661), .CK(clk2), .Q(
        u_Conv_ifmap_reg[105]) );
  QDFFS u_Conv_ifmap_reg_reg_0__0__1_ ( .D(n655), .CK(clk2), .Q(
        u_Conv_ifmap_reg[106]) );
  QDFFS u_Conv_ifmap_reg_reg_0__0__2_ ( .D(n649), .CK(clk2), .Q(
        u_Conv_ifmap_reg[107]) );
  QDFFS u_Conv_ifmap_reg_reg_1__0__0_ ( .D(n643), .CK(clk2), .Q(
        u_Conv_ifmap_reg[87]) );
  QDFFS u_Conv_ifmap_reg_reg_1__0__1_ ( .D(n637), .CK(clk2), .Q(
        u_Conv_ifmap_reg[88]) );
  QDFFS u_Conv_ifmap_reg_reg_1__0__2_ ( .D(n631), .CK(clk2), .Q(
        u_Conv_ifmap_reg[89]) );
  QDFFS u_Conv_ifmap_reg_reg_2__0__0_ ( .D(n625), .CK(clk2), .Q(
        u_Conv_ifmap_reg[69]) );
  QDFFS u_Conv_ifmap_reg_reg_2__0__1_ ( .D(n619), .CK(clk2), .Q(
        u_Conv_ifmap_reg[70]) );
  QDFFS u_Conv_ifmap_reg_reg_2__0__2_ ( .D(n613), .CK(clk2), .Q(
        u_Conv_ifmap_reg[71]) );
  QDFFS u_Conv_ifmap_reg_reg_3__0__0_ ( .D(n607), .CK(clk2), .Q(
        u_Conv_ifmap_reg[51]) );
  QDFFS u_Conv_ifmap_reg_reg_3__0__1_ ( .D(n601), .CK(clk2), .Q(
        u_Conv_ifmap_reg[52]) );
  QDFFS u_Conv_ifmap_reg_reg_3__0__2_ ( .D(n595), .CK(clk2), .Q(
        u_Conv_ifmap_reg[53]) );
  QDFFS u_Conv_ifmap_reg_reg_4__0__0_ ( .D(n589), .CK(clk2), .Q(
        u_Conv_ifmap_reg[33]) );
  QDFFS u_Conv_ifmap_reg_reg_4__0__1_ ( .D(n583), .CK(clk2), .Q(
        u_Conv_ifmap_reg[34]) );
  QDFFS u_Conv_ifmap_reg_reg_4__0__2_ ( .D(n577), .CK(clk2), .Q(
        u_Conv_ifmap_reg[35]) );
  QDFFS u_Conv_ifmap_reg_reg_5__0__0_ ( .D(n571), .CK(clk2), .Q(
        u_Conv_ifmap_reg[15]) );
  QDFFS u_Conv_ifmap_reg_reg_5__0__1_ ( .D(n565), .CK(clk2), .Q(
        u_Conv_ifmap_reg[16]) );
  QDFFS u_Conv_ifmap_reg_reg_5__0__2_ ( .D(n559), .CK(clk2), .Q(
        u_Conv_ifmap_reg[17]) );
  QDFFS u_Conv_kernel_reg_reg_0__1__0_ ( .D(n732), .CK(clk2), .Q(
        u_Conv_kernel_reg[66]) );
  QDFFS u_Conv_kernel_reg_reg_0__1__1_ ( .D(n726), .CK(clk2), .Q(
        u_Conv_kernel_reg[67]) );
  QDFFS u_Conv_kernel_reg_reg_0__1__2_ ( .D(n720), .CK(clk2), .Q(
        u_Conv_kernel_reg[68]) );
  QDFFS u_Conv_kernel_reg_reg_1__1__0_ ( .D(n714), .CK(clk2), .Q(
        u_Conv_kernel_reg[48]) );
  QDFFS u_Conv_kernel_reg_reg_1__1__1_ ( .D(n708), .CK(clk2), .Q(
        u_Conv_kernel_reg[49]) );
  QDFFS u_Conv_kernel_reg_reg_1__1__2_ ( .D(n702), .CK(clk2), .Q(
        u_Conv_kernel_reg[50]) );
  QDFFS u_Conv_kernel_reg_reg_2__1__0_ ( .D(n696), .CK(clk2), .Q(
        u_Conv_kernel_reg[30]) );
  QDFFS u_Conv_kernel_reg_reg_2__1__1_ ( .D(n690), .CK(clk2), .Q(
        u_Conv_kernel_reg[31]) );
  QDFFS u_Conv_kernel_reg_reg_2__1__2_ ( .D(n684), .CK(clk2), .Q(
        u_Conv_kernel_reg[32]) );
  QDFFS u_Conv_kernel_reg_reg_3__1__0_ ( .D(n678), .CK(clk2), .Q(
        u_Conv_kernel_reg[12]) );
  QDFFS u_Conv_kernel_reg_reg_3__1__1_ ( .D(n672), .CK(clk2), .Q(
        u_Conv_kernel_reg[13]) );
  QDFFS u_Conv_kernel_reg_reg_3__1__2_ ( .D(n666), .CK(clk2), .Q(
        u_Conv_kernel_reg[14]) );
  QDFFS u_Conv_ifmap_reg_reg_0__1__0_ ( .D(n660), .CK(clk2), .Q(
        u_Conv_ifmap_reg[102]) );
  QDFFS u_Conv_ifmap_reg_reg_0__1__1_ ( .D(n654), .CK(clk2), .Q(
        u_Conv_ifmap_reg[103]) );
  QDFFS u_Conv_ifmap_reg_reg_0__1__2_ ( .D(n648), .CK(clk2), .Q(
        u_Conv_ifmap_reg[104]) );
  QDFFS u_Conv_ifmap_reg_reg_1__1__0_ ( .D(n642), .CK(clk2), .Q(
        u_Conv_ifmap_reg[84]) );
  QDFFS u_Conv_ifmap_reg_reg_1__1__1_ ( .D(n636), .CK(clk2), .Q(
        u_Conv_ifmap_reg[85]) );
  QDFFS u_Conv_ifmap_reg_reg_1__1__2_ ( .D(n630), .CK(clk2), .Q(
        u_Conv_ifmap_reg[86]) );
  QDFFS u_Conv_ifmap_reg_reg_2__1__0_ ( .D(n624), .CK(clk2), .Q(
        u_Conv_ifmap_reg[66]) );
  QDFFS u_Conv_ifmap_reg_reg_2__1__1_ ( .D(n618), .CK(clk2), .Q(
        u_Conv_ifmap_reg[67]) );
  QDFFS u_Conv_ifmap_reg_reg_2__1__2_ ( .D(n612), .CK(clk2), .Q(
        u_Conv_ifmap_reg[68]) );
  QDFFS u_Conv_ifmap_reg_reg_3__1__0_ ( .D(n606), .CK(clk2), .Q(
        u_Conv_ifmap_reg[48]) );
  QDFFS u_Conv_ifmap_reg_reg_3__1__1_ ( .D(n600), .CK(clk2), .Q(
        u_Conv_ifmap_reg[49]) );
  QDFFS u_Conv_ifmap_reg_reg_3__1__2_ ( .D(n594), .CK(clk2), .Q(
        u_Conv_ifmap_reg[50]) );
  QDFFS u_Conv_ifmap_reg_reg_4__1__0_ ( .D(n588), .CK(clk2), .Q(
        u_Conv_ifmap_reg[30]) );
  QDFFS u_Conv_ifmap_reg_reg_4__1__1_ ( .D(n582), .CK(clk2), .Q(
        u_Conv_ifmap_reg[31]) );
  QDFFS u_Conv_ifmap_reg_reg_4__1__2_ ( .D(n576), .CK(clk2), .Q(
        u_Conv_ifmap_reg[32]) );
  QDFFS u_Conv_ifmap_reg_reg_5__1__0_ ( .D(n570), .CK(clk2), .Q(
        u_Conv_ifmap_reg[12]) );
  QDFFS u_Conv_ifmap_reg_reg_5__1__1_ ( .D(n564), .CK(clk2), .Q(
        u_Conv_ifmap_reg[13]) );
  QDFFS u_Conv_ifmap_reg_reg_5__1__2_ ( .D(n558), .CK(clk2), .Q(
        u_Conv_ifmap_reg[14]) );
  QDFFS u_Conv_kernel_reg_reg_0__2__0_ ( .D(n731), .CK(clk2), .Q(
        u_Conv_kernel_reg[63]) );
  QDFFS u_Conv_kernel_reg_reg_0__2__1_ ( .D(n725), .CK(clk2), .Q(
        u_Conv_kernel_reg[64]) );
  QDFFS u_Conv_kernel_reg_reg_0__2__2_ ( .D(n719), .CK(clk2), .Q(
        u_Conv_kernel_reg[65]) );
  QDFFS u_Conv_kernel_reg_reg_1__2__0_ ( .D(n713), .CK(clk2), .Q(
        u_Conv_kernel_reg[45]) );
  QDFFS u_Conv_kernel_reg_reg_1__2__1_ ( .D(n707), .CK(clk2), .Q(
        u_Conv_kernel_reg[46]) );
  QDFFS u_Conv_kernel_reg_reg_1__2__2_ ( .D(n701), .CK(clk2), .Q(
        u_Conv_kernel_reg[47]) );
  QDFFS u_Conv_kernel_reg_reg_2__2__0_ ( .D(n695), .CK(clk2), .Q(
        u_Conv_kernel_reg[27]) );
  QDFFS u_Conv_kernel_reg_reg_2__2__1_ ( .D(n689), .CK(clk2), .Q(
        u_Conv_kernel_reg[28]) );
  QDFFS u_Conv_kernel_reg_reg_2__2__2_ ( .D(n683), .CK(clk2), .Q(
        u_Conv_kernel_reg[29]) );
  QDFFS u_Conv_kernel_reg_reg_3__2__0_ ( .D(n677), .CK(clk2), .Q(
        u_Conv_kernel_reg[9]) );
  QDFFS u_Conv_kernel_reg_reg_3__2__1_ ( .D(n671), .CK(clk2), .Q(
        u_Conv_kernel_reg[10]) );
  QDFFS u_Conv_kernel_reg_reg_3__2__2_ ( .D(n665), .CK(clk2), .Q(
        u_Conv_kernel_reg[11]) );
  QDFFS u_Conv_ifmap_reg_reg_0__2__0_ ( .D(n659), .CK(clk2), .Q(
        u_Conv_ifmap_reg[99]) );
  QDFFS u_Conv_ifmap_reg_reg_0__2__1_ ( .D(n653), .CK(clk2), .Q(
        u_Conv_ifmap_reg[100]) );
  QDFFS u_Conv_ifmap_reg_reg_0__2__2_ ( .D(n647), .CK(clk2), .Q(
        u_Conv_ifmap_reg[101]) );
  QDFFS u_Conv_ifmap_reg_reg_1__2__0_ ( .D(n641), .CK(clk2), .Q(
        u_Conv_ifmap_reg[81]) );
  QDFFS u_Conv_ifmap_reg_reg_1__2__1_ ( .D(n635), .CK(clk2), .Q(
        u_Conv_ifmap_reg[82]) );
  QDFFS u_Conv_ifmap_reg_reg_1__2__2_ ( .D(n629), .CK(clk2), .Q(
        u_Conv_ifmap_reg[83]) );
  QDFFS u_Conv_ifmap_reg_reg_2__2__0_ ( .D(n623), .CK(clk2), .Q(
        u_Conv_ifmap_reg[63]) );
  QDFFS u_Conv_ifmap_reg_reg_2__2__1_ ( .D(n617), .CK(clk2), .Q(
        u_Conv_ifmap_reg[64]) );
  QDFFS u_Conv_ifmap_reg_reg_2__2__2_ ( .D(n611), .CK(clk2), .Q(
        u_Conv_ifmap_reg[65]) );
  QDFFS u_Conv_ifmap_reg_reg_3__2__0_ ( .D(n605), .CK(clk2), .Q(
        u_Conv_ifmap_reg[45]) );
  QDFFS u_Conv_ifmap_reg_reg_3__2__1_ ( .D(n599), .CK(clk2), .Q(
        u_Conv_ifmap_reg[46]) );
  QDFFS u_Conv_ifmap_reg_reg_3__2__2_ ( .D(n593), .CK(clk2), .Q(
        u_Conv_ifmap_reg[47]) );
  QDFFS u_Conv_ifmap_reg_reg_4__2__0_ ( .D(n587), .CK(clk2), .Q(
        u_Conv_ifmap_reg[27]) );
  QDFFS u_Conv_ifmap_reg_reg_4__2__1_ ( .D(n581), .CK(clk2), .Q(
        u_Conv_ifmap_reg[28]) );
  QDFFS u_Conv_ifmap_reg_reg_4__2__2_ ( .D(n575), .CK(clk2), .Q(
        u_Conv_ifmap_reg[29]) );
  QDFFS u_Conv_ifmap_reg_reg_5__2__0_ ( .D(n569), .CK(clk2), .Q(
        u_Conv_ifmap_reg[9]) );
  QDFFS u_Conv_ifmap_reg_reg_5__2__1_ ( .D(n563), .CK(clk2), .Q(
        u_Conv_ifmap_reg[10]) );
  QDFFS u_Conv_ifmap_reg_reg_5__2__2_ ( .D(n557), .CK(clk2), .Q(
        u_Conv_ifmap_reg[11]) );
  QDFFS u_Conv_kernel_reg_reg_0__3__0_ ( .D(n730), .CK(clk2), .Q(
        u_Conv_kernel_reg[60]) );
  QDFFS u_Conv_kernel_reg_reg_0__3__1_ ( .D(n724), .CK(clk2), .Q(
        u_Conv_kernel_reg[61]) );
  QDFFS u_Conv_kernel_reg_reg_0__3__2_ ( .D(n718), .CK(clk2), .Q(
        u_Conv_kernel_reg[62]) );
  QDFFS u_Conv_kernel_reg_reg_1__3__0_ ( .D(n712), .CK(clk2), .Q(
        u_Conv_kernel_reg[42]) );
  QDFFS u_Conv_kernel_reg_reg_1__3__1_ ( .D(n706), .CK(clk2), .Q(
        u_Conv_kernel_reg[43]) );
  QDFFS u_Conv_kernel_reg_reg_1__3__2_ ( .D(n700), .CK(clk2), .Q(
        u_Conv_kernel_reg[44]) );
  QDFFS u_Conv_kernel_reg_reg_2__3__0_ ( .D(n694), .CK(clk2), .Q(
        u_Conv_kernel_reg[24]) );
  QDFFS u_Conv_kernel_reg_reg_2__3__1_ ( .D(n688), .CK(clk2), .Q(
        u_Conv_kernel_reg[25]) );
  QDFFS u_Conv_kernel_reg_reg_2__3__2_ ( .D(n682), .CK(clk2), .Q(
        u_Conv_kernel_reg[26]) );
  QDFFS u_Conv_kernel_reg_reg_3__3__0_ ( .D(n676), .CK(clk2), .Q(
        u_Conv_kernel_reg[6]) );
  QDFFS u_Conv_kernel_reg_reg_3__3__1_ ( .D(n670), .CK(clk2), .Q(
        u_Conv_kernel_reg[7]) );
  QDFFS u_Conv_kernel_reg_reg_3__3__2_ ( .D(n664), .CK(clk2), .Q(
        u_Conv_kernel_reg[8]) );
  QDFFS u_Conv_ifmap_reg_reg_0__3__0_ ( .D(n658), .CK(clk2), .Q(
        u_Conv_ifmap_reg[96]) );
  QDFFS u_Conv_ifmap_reg_reg_0__3__1_ ( .D(n652), .CK(clk2), .Q(
        u_Conv_ifmap_reg[97]) );
  QDFFS u_Conv_ifmap_reg_reg_0__3__2_ ( .D(n646), .CK(clk2), .Q(
        u_Conv_ifmap_reg[98]) );
  QDFFS u_Conv_ifmap_reg_reg_1__3__0_ ( .D(n640), .CK(clk2), .Q(
        u_Conv_ifmap_reg[78]) );
  QDFFS u_Conv_ifmap_reg_reg_1__3__1_ ( .D(n634), .CK(clk2), .Q(
        u_Conv_ifmap_reg[79]) );
  QDFFS u_Conv_ifmap_reg_reg_1__3__2_ ( .D(n628), .CK(clk2), .Q(
        u_Conv_ifmap_reg[80]) );
  QDFFS u_Conv_ifmap_reg_reg_2__3__0_ ( .D(n622), .CK(clk2), .Q(
        u_Conv_ifmap_reg[60]) );
  QDFFS u_Conv_ifmap_reg_reg_2__3__1_ ( .D(n616), .CK(clk2), .Q(
        u_Conv_ifmap_reg[61]) );
  QDFFS u_Conv_ifmap_reg_reg_2__3__2_ ( .D(n610), .CK(clk2), .Q(
        u_Conv_ifmap_reg[62]) );
  QDFFS u_Conv_ifmap_reg_reg_3__3__0_ ( .D(n604), .CK(clk2), .Q(
        u_Conv_ifmap_reg[42]) );
  QDFFS u_Conv_ifmap_reg_reg_3__3__1_ ( .D(n598), .CK(clk2), .Q(
        u_Conv_ifmap_reg[43]) );
  QDFFS u_Conv_ifmap_reg_reg_3__3__2_ ( .D(n592), .CK(clk2), .Q(
        u_Conv_ifmap_reg[44]) );
  QDFFS u_Conv_ifmap_reg_reg_4__3__0_ ( .D(n586), .CK(clk2), .Q(
        u_Conv_ifmap_reg[24]) );
  QDFFS u_Conv_ifmap_reg_reg_4__3__1_ ( .D(n580), .CK(clk2), .Q(
        u_Conv_ifmap_reg[25]) );
  QDFFS u_Conv_ifmap_reg_reg_4__3__2_ ( .D(n574), .CK(clk2), .Q(
        u_Conv_ifmap_reg[26]) );
  QDFFS u_Conv_ifmap_reg_reg_5__3__0_ ( .D(n568), .CK(clk2), .Q(
        u_Conv_ifmap_reg[6]) );
  QDFFS u_Conv_ifmap_reg_reg_5__3__1_ ( .D(n562), .CK(clk2), .Q(
        u_Conv_ifmap_reg[7]) );
  QDFFS u_Conv_ifmap_reg_reg_5__3__2_ ( .D(n556), .CK(clk2), .Q(
        u_Conv_ifmap_reg[8]) );
  QDFFS u_Conv_kernel_reg_reg_0__4__0_ ( .D(n729), .CK(clk2), .Q(
        u_Conv_kernel_reg[57]) );
  QDFFS u_Conv_kernel_reg_reg_0__4__1_ ( .D(n723), .CK(clk2), .Q(
        u_Conv_kernel_reg[58]) );
  QDFFS u_Conv_kernel_reg_reg_0__4__2_ ( .D(n717), .CK(clk2), .Q(
        u_Conv_kernel_reg[59]) );
  QDFFS u_Conv_kernel_reg_reg_1__4__0_ ( .D(n711), .CK(clk2), .Q(
        u_Conv_kernel_reg[39]) );
  QDFFS u_Conv_kernel_reg_reg_1__4__1_ ( .D(n705), .CK(clk2), .Q(
        u_Conv_kernel_reg[40]) );
  QDFFS u_Conv_kernel_reg_reg_1__4__2_ ( .D(n699), .CK(clk2), .Q(
        u_Conv_kernel_reg[41]) );
  QDFFS u_Conv_kernel_reg_reg_2__4__0_ ( .D(n693), .CK(clk2), .Q(
        u_Conv_kernel_reg[21]) );
  QDFFS u_Conv_kernel_reg_reg_2__4__1_ ( .D(n687), .CK(clk2), .Q(
        u_Conv_kernel_reg[22]) );
  QDFFS u_Conv_kernel_reg_reg_2__4__2_ ( .D(n681), .CK(clk2), .Q(
        u_Conv_kernel_reg[23]) );
  QDFFS u_Conv_kernel_reg_reg_3__4__0_ ( .D(n675), .CK(clk2), .Q(
        u_Conv_kernel_reg[3]) );
  QDFFS u_Conv_kernel_reg_reg_3__4__1_ ( .D(n669), .CK(clk2), .Q(
        u_Conv_kernel_reg[4]) );
  QDFFS u_Conv_kernel_reg_reg_3__4__2_ ( .D(n663), .CK(clk2), .Q(
        u_Conv_kernel_reg[5]) );
  QDFFS u_Conv_ifmap_reg_reg_0__4__0_ ( .D(n657), .CK(clk2), .Q(
        u_Conv_ifmap_reg[93]) );
  QDFFS u_Conv_ifmap_reg_reg_0__4__1_ ( .D(n651), .CK(clk2), .Q(
        u_Conv_ifmap_reg[94]) );
  QDFFS u_Conv_ifmap_reg_reg_0__4__2_ ( .D(n645), .CK(clk2), .Q(
        u_Conv_ifmap_reg[95]) );
  QDFFS u_Conv_ifmap_reg_reg_1__4__0_ ( .D(n639), .CK(clk2), .Q(
        u_Conv_ifmap_reg[75]) );
  QDFFS u_Conv_ifmap_reg_reg_1__4__1_ ( .D(n633), .CK(clk2), .Q(
        u_Conv_ifmap_reg[76]) );
  QDFFS u_Conv_ifmap_reg_reg_1__4__2_ ( .D(n627), .CK(clk2), .Q(
        u_Conv_ifmap_reg[77]) );
  QDFFS u_Conv_ifmap_reg_reg_2__4__0_ ( .D(n621), .CK(clk2), .Q(
        u_Conv_ifmap_reg[57]) );
  QDFFS u_Conv_ifmap_reg_reg_2__4__1_ ( .D(n615), .CK(clk2), .Q(
        u_Conv_ifmap_reg[58]) );
  QDFFS u_Conv_ifmap_reg_reg_2__4__2_ ( .D(n609), .CK(clk2), .Q(
        u_Conv_ifmap_reg[59]) );
  QDFFS u_Conv_ifmap_reg_reg_3__4__0_ ( .D(n603), .CK(clk2), .Q(
        u_Conv_ifmap_reg[39]) );
  QDFFS u_Conv_ifmap_reg_reg_3__4__1_ ( .D(n597), .CK(clk2), .Q(
        u_Conv_ifmap_reg[40]) );
  QDFFS u_Conv_ifmap_reg_reg_3__4__2_ ( .D(n591), .CK(clk2), .Q(
        u_Conv_ifmap_reg[41]) );
  QDFFS u_Conv_ifmap_reg_reg_4__4__0_ ( .D(n585), .CK(clk2), .Q(
        u_Conv_ifmap_reg[21]) );
  QDFFS u_Conv_ifmap_reg_reg_4__4__1_ ( .D(n579), .CK(clk2), .Q(
        u_Conv_ifmap_reg[22]) );
  QDFFS u_Conv_ifmap_reg_reg_4__4__2_ ( .D(n573), .CK(clk2), .Q(
        u_Conv_ifmap_reg[23]) );
  QDFFS u_Conv_ifmap_reg_reg_5__4__0_ ( .D(n567), .CK(clk2), .Q(
        u_Conv_ifmap_reg[3]) );
  QDFFS u_Conv_ifmap_reg_reg_5__4__1_ ( .D(n561), .CK(clk2), .Q(
        u_Conv_ifmap_reg[4]) );
  QDFFS u_Conv_ifmap_reg_reg_5__4__2_ ( .D(n555), .CK(clk2), .Q(
        u_Conv_ifmap_reg[5]) );
  QDFFS u_Conv_kernel_reg_reg_0__5__0_ ( .D(n728), .CK(clk2), .Q(
        u_Conv_kernel_reg[54]) );
  QDFFS u_Conv_kernel_reg_reg_0__5__1_ ( .D(n722), .CK(clk2), .Q(
        u_Conv_kernel_reg[55]) );
  QDFFS u_Conv_kernel_reg_reg_0__5__2_ ( .D(n716), .CK(clk2), .Q(
        u_Conv_kernel_reg[56]) );
  QDFFS u_Conv_kernel_reg_reg_1__5__0_ ( .D(n710), .CK(clk2), .Q(
        u_Conv_kernel_reg[36]) );
  QDFFS u_Conv_kernel_reg_reg_1__5__1_ ( .D(n704), .CK(clk2), .Q(
        u_Conv_kernel_reg[37]) );
  QDFFS u_Conv_kernel_reg_reg_1__5__2_ ( .D(n698), .CK(clk2), .Q(
        u_Conv_kernel_reg[38]) );
  QDFFS u_Conv_kernel_reg_reg_2__5__0_ ( .D(n692), .CK(clk2), .Q(
        u_Conv_kernel_reg[18]) );
  QDFFS u_Conv_kernel_reg_reg_2__5__1_ ( .D(n686), .CK(clk2), .Q(
        u_Conv_kernel_reg[19]) );
  QDFFS u_Conv_kernel_reg_reg_2__5__2_ ( .D(n680), .CK(clk2), .Q(
        u_Conv_kernel_reg[20]) );
  QDFFS u_Conv_kernel_reg_reg_3__5__0_ ( .D(n674), .CK(clk2), .Q(
        u_Conv_kernel_reg[0]) );
  QDFFS u_Conv_kernel_reg_reg_3__5__1_ ( .D(n668), .CK(clk2), .Q(
        u_Conv_kernel_reg[1]) );
  QDFFS u_Conv_kernel_reg_reg_3__5__2_ ( .D(n662), .CK(clk2), .Q(
        u_Conv_kernel_reg[2]) );
  QDFFS u_Conv_ifmap_reg_reg_0__5__0_ ( .D(n656), .CK(clk2), .Q(
        u_Conv_ifmap_reg[90]) );
  QDFFS u_Conv_ifmap_reg_reg_0__5__1_ ( .D(n650), .CK(clk2), .Q(
        u_Conv_ifmap_reg[91]) );
  QDFFS u_Conv_ifmap_reg_reg_0__5__2_ ( .D(n644), .CK(clk2), .Q(
        u_Conv_ifmap_reg[92]) );
  QDFFS u_Conv_ifmap_reg_reg_1__5__0_ ( .D(n638), .CK(clk2), .Q(
        u_Conv_ifmap_reg[72]) );
  QDFFS u_Conv_ifmap_reg_reg_1__5__1_ ( .D(n632), .CK(clk2), .Q(
        u_Conv_ifmap_reg[73]) );
  QDFFS u_Conv_ifmap_reg_reg_1__5__2_ ( .D(n626), .CK(clk2), .Q(
        u_Conv_ifmap_reg[74]) );
  QDFFS u_Conv_ifmap_reg_reg_2__5__0_ ( .D(n620), .CK(clk2), .Q(
        u_Conv_ifmap_reg[54]) );
  QDFFS u_Conv_ifmap_reg_reg_2__5__1_ ( .D(n614), .CK(clk2), .Q(
        u_Conv_ifmap_reg[55]) );
  QDFFS u_Conv_ifmap_reg_reg_2__5__2_ ( .D(n608), .CK(clk2), .Q(
        u_Conv_ifmap_reg[56]) );
  QDFFS u_Conv_ifmap_reg_reg_3__5__0_ ( .D(n602), .CK(clk2), .Q(
        u_Conv_ifmap_reg[36]) );
  QDFFS u_Conv_ifmap_reg_reg_3__5__1_ ( .D(n596), .CK(clk2), .Q(
        u_Conv_ifmap_reg[37]) );
  QDFFS u_Conv_ifmap_reg_reg_3__5__2_ ( .D(n590), .CK(clk2), .Q(
        u_Conv_ifmap_reg[38]) );
  QDFFS u_Conv_ifmap_reg_reg_4__5__0_ ( .D(n584), .CK(clk2), .Q(
        u_Conv_ifmap_reg[18]) );
  QDFFS u_Conv_ifmap_reg_reg_4__5__1_ ( .D(n578), .CK(clk2), .Q(
        u_Conv_ifmap_reg[19]) );
  QDFFS u_Conv_ifmap_reg_reg_4__5__2_ ( .D(n572), .CK(clk2), .Q(
        u_Conv_ifmap_reg[20]) );
  QDFFS u_Conv_ifmap_reg_reg_5__5__0_ ( .D(n566), .CK(clk2), .Q(
        u_Conv_ifmap_reg[0]) );
  QDFFS u_Conv_ifmap_reg_reg_5__5__1_ ( .D(n560), .CK(clk2), .Q(
        u_Conv_ifmap_reg[1]) );
  QDFFS u_Conv_ifmap_reg_reg_5__5__2_ ( .D(n554), .CK(clk2), .Q(
        u_Conv_ifmap_reg[2]) );
  QDFFS u_FIFO_syn_rdata_reg_0_ ( .D(u_FIFO_syn_ram_out[0]), .CK(clk1), .Q(
        fifo_rdata[0]) );
  QDFFS u_FIFO_syn_rdata_reg_1_ ( .D(u_FIFO_syn_ram_out[1]), .CK(clk1), .Q(
        fifo_rdata[1]) );
  QDFFS u_FIFO_syn_rdata_reg_2_ ( .D(u_FIFO_syn_ram_out[2]), .CK(clk1), .Q(
        fifo_rdata[2]) );
  QDFFS u_FIFO_syn_rdata_reg_3_ ( .D(u_FIFO_syn_ram_out[3]), .CK(clk1), .Q(
        fifo_rdata[3]) );
  QDFFS u_FIFO_syn_rdata_reg_4_ ( .D(u_FIFO_syn_ram_out[4]), .CK(clk1), .Q(
        fifo_rdata[4]) );
  QDFFS u_FIFO_syn_rdata_reg_5_ ( .D(u_FIFO_syn_ram_out[5]), .CK(clk1), .Q(
        fifo_rdata[5]) );
  QDFFS u_FIFO_syn_rdata_reg_6_ ( .D(u_FIFO_syn_ram_out[6]), .CK(clk1), .Q(
        fifo_rdata[6]) );
  QDFFS u_FIFO_syn_rdata_reg_7_ ( .D(u_FIFO_syn_ram_out[7]), .CK(clk1), .Q(
        fifo_rdata[7]) );
  QDFFRBS u_Conv_acc_count_x_reg ( .D(n549), .CK(clk2), .RB(n1552), .Q(
        u_Conv_acc_count_x) );
  QDFFRBS u_Conv_acc_count_y_reg ( .D(n548), .CK(clk2), .RB(n1552), .Q(
        u_Conv_acc_count_y) );
  QDFFS u_Conv_psum_reg_reg_0_ ( .D(n547), .CK(clk2), .Q(u_Conv_psum_reg[0])
         );
  QDFFS u_Conv_psum_reg_reg_1_ ( .D(n546), .CK(clk2), .Q(u_Conv_psum_reg[1])
         );
  QDFFS u_Conv_psum_reg_reg_2_ ( .D(n545), .CK(clk2), .Q(u_Conv_psum_reg[2])
         );
  QDFFS u_Conv_psum_reg_reg_3_ ( .D(n544), .CK(clk2), .Q(u_Conv_psum_reg[3])
         );
  QDFFS u_Conv_psum_reg_reg_4_ ( .D(n543), .CK(clk2), .Q(u_Conv_psum_reg[4])
         );
  QDFFS u_Conv_psum_reg_reg_5_ ( .D(n542), .CK(clk2), .Q(u_Conv_psum_reg[5])
         );
  QDFFS u_Conv_psum_reg_reg_6_ ( .D(n541), .CK(clk2), .Q(u_Conv_psum_reg[6])
         );
  QDFFS u_Conv_psum_reg_reg_7_ ( .D(n540), .CK(clk2), .Q(u_Conv_psum_reg[7])
         );
  DFFSBN u_FIFO_syn_rempty_reg ( .D(u_FIFO_syn_N8), .CK(clk1), .SB(rst_n), .Q(
        fifo_empty) );
  DFFSBN u_input_output_fifo_empty_reg1_reg ( .D(fifo_empty), .CK(clk1), .SB(
        n944), .Q(u_input_output_fifo_empty_reg1) );
  DFFSBN u_input_output_fifo_empty_reg2_reg ( .D(
        u_input_output_fifo_empty_reg1), .CK(clk1), .SB(n1552), .QB(out_valid)
         );
  QDFFRBN u_Conv_in_count_reg_0_ ( .D(n736), .CK(clk2), .RB(n1552), .Q(
        u_Conv_in_count[0]) );
  QDFFRBN u_Conv_kernel_idx_reg_0_ ( .D(n552), .CK(clk2), .RB(n1552), .Q(
        u_Conv_kernel_idx[0]) );
  NR2P U1016 ( .I1(n1293), .I2(n1412), .O(n1378) );
  INV2 U1017 ( .I(n1247), .O(n1251) );
  ND2P U1018 ( .I1(n1183), .I2(n1199), .O(n1498) );
  NR2P U1019 ( .I1(u_input_output_out_count[0]), .I2(n1291), .O(n1367) );
  NR2P U1020 ( .I1(n1292), .I2(n1291), .O(n1368) );
  NR2P U1021 ( .I1(u_input_output_out_count[0]), .I2(n1290), .O(n1373) );
  NR2P U1022 ( .I1(n1292), .I2(n1290), .O(n1399) );
  ND3P U1023 ( .I1(n1183), .I2(n1200), .I3(n1462), .O(n1503) );
  ND2P U1024 ( .I1(n1181), .I2(n1182), .O(n1284) );
  ND2P U1025 ( .I1(u_input_output_in_count[2]), .I2(n1181), .O(n1249) );
  ND3P U1026 ( .I1(n1465), .I2(n1462), .I3(n1204), .O(n1492) );
  ND3P U1027 ( .I1(u_Conv_in_count[0]), .I2(n1465), .I3(n1204), .O(n1497) );
  ND3P U1028 ( .I1(u_Conv_in_count[2]), .I2(n1465), .I3(n1462), .O(n1499) );
  ND3P U1029 ( .I1(u_Conv_in_count[0]), .I2(u_Conv_in_count[2]), .I3(n1465), 
        .O(n1501) );
  ND3P U1030 ( .I1(u_input_output_in_count[2]), .I2(n1180), .I3(in_valid), .O(
        n1250) );
  AN3B2 U1031 ( .I1(u_Handshake_syn_dreq), .B1(conv_busy), .B2(
        u_Handshake_syn_dack), .O(n1214) );
  BUF2 U1032 ( .I(rst_n), .O(n944) );
  ND3 U1033 ( .I1(u_Conv_acc_count_y), .I2(u_Conv_ifmap_y[0]), .I3(
        u_Conv_ifmap_y[1]), .O(n992) );
  ND2S U1034 ( .I1(n1196), .I2(n1198), .O(n973) );
  ND2S U1035 ( .I1(u_Conv_ifmap_x[2]), .I2(n1008), .O(n994) );
  ND2S U1036 ( .I1(n1028), .I2(n1027), .O(n1104) );
  ND2S U1037 ( .I1(n1023), .I2(n1027), .O(n1108) );
  OR2S U1038 ( .I1(n1028), .I2(n1027), .O(n1118) );
  ND2S U1039 ( .I1(u_Conv_acc_count_y), .I2(u_Conv_ifmap_y[0]), .O(n999) );
  MOAI1S U1040 ( .A1(u_Conv_ifmap_y[2]), .A2(n992), .B1(u_Conv_ifmap_y[2]), 
        .B2(n992), .O(n1091) );
  HA1S U1041 ( .A(n1168), .B(n1167), .C(n1174), .S(n1170) );
  AN2S U1042 ( .I1(n1165), .I2(n1153), .O(n1167) );
  AN2S U1043 ( .I1(n1166), .I2(n1152), .O(n1168) );
  ND2S U1044 ( .I1(n1008), .I2(n1447), .O(n1011) );
  OR2S U1045 ( .I1(n1009), .I2(n1008), .O(n1014) );
  INV1S U1046 ( .I(n1091), .O(n1013) );
  ND2S U1047 ( .I1(n1063), .I2(n1062), .O(n1068) );
  ND2S U1048 ( .I1(n1057), .I2(n1056), .O(n1061) );
  ND2S U1049 ( .I1(n1059), .I2(n1058), .O(n1060) );
  ND3S U1050 ( .I1(n1040), .I2(n1039), .I3(n1038), .O(n1045) );
  ND3S U1051 ( .I1(n1043), .I2(n1042), .I3(n1041), .O(n1044) );
  ND3S U1052 ( .I1(n1048), .I2(n1047), .I3(n1046), .O(n1053) );
  ND2S U1053 ( .I1(n1006), .I2(n1005), .O(n1019) );
  ND2S U1054 ( .I1(n998), .I2(n997), .O(n1003) );
  ND2S U1055 ( .I1(n1001), .I2(n1000), .O(n1002) );
  ND2S U1056 ( .I1(n991), .I2(n990), .O(n1166) );
  ND3S U1057 ( .I1(n979), .I2(n978), .I3(n977), .O(n980) );
  ND3S U1058 ( .I1(n1127), .I2(n1126), .I3(n1125), .O(n1165) );
  HA1S U1059 ( .A(n1155), .B(n1154), .C(n1171), .S(n1160) );
  AN2S U1060 ( .I1(n1153), .I2(n1152), .O(n1154) );
  AN2S U1061 ( .I1(n1166), .I2(n1156), .O(n1155) );
  ND2S U1062 ( .I1(n1151), .I2(n1150), .O(n1157) );
  ND3S U1063 ( .I1(n1133), .I2(n1132), .I3(n1131), .O(n1134) );
  INV1S U1064 ( .I(u_Conv_kernel_idx[0]), .O(n1504) );
  ND2S U1065 ( .I1(n1442), .I2(n1440), .O(n1443) );
  OR2S U1066 ( .I1(n943), .I2(u_Conv_out_count[0]), .O(n1425) );
  OR2S U1067 ( .I1(n957), .I2(n956), .O(n958) );
  ND2S U1068 ( .I1(u_Conv_ifmap_x[0]), .I2(u_Conv_ifmap_x[1]), .O(n995) );
  ND3S U1069 ( .I1(n984), .I2(n983), .I3(n982), .O(n989) );
  ND3S U1070 ( .I1(n976), .I2(n975), .I3(n974), .O(n981) );
  ND2S U1071 ( .I1(n1096), .I2(n1095), .O(n1102) );
  ND3S U1072 ( .I1(n1099), .I2(n1098), .I3(n1097), .O(n1100) );
  ND2S U1073 ( .I1(n1085), .I2(n1084), .O(n1090) );
  ND2S U1074 ( .I1(n1087), .I2(n1086), .O(n1088) );
  ND3S U1075 ( .I1(n1139), .I2(n1138), .I3(n1137), .O(n1149) );
  ND3S U1076 ( .I1(n1146), .I2(n1145), .I3(n1144), .O(n1147) );
  ND3S U1077 ( .I1(n1130), .I2(n1129), .I3(n1128), .O(n1135) );
  ND2S U1078 ( .I1(u_Conv_kernel_idx[1]), .I2(n1198), .O(n972) );
  ND3S U1079 ( .I1(n1083), .I2(n1082), .I3(n1081), .O(n1152) );
  ND2S U1080 ( .I1(n1055), .I2(n1054), .O(n1153) );
  ND3S U1081 ( .I1(n1051), .I2(n1050), .I3(n1049), .O(n1052) );
  ND3S U1082 ( .I1(n1037), .I2(n1036), .I3(n1035), .O(n1156) );
  AN2S U1083 ( .I1(conv_busy), .I2(n1514), .O(n1520) );
  ND2S U1084 ( .I1(u_FIFO_syn_w_addr[2]), .I2(n950), .O(n952) );
  ND2S U1085 ( .I1(u_FIFO_syn_w_addr[0]), .I2(n1446), .O(n948) );
  ND2S U1086 ( .I1(u_FIFO_syn_w_addr[4]), .I2(n954), .O(n956) );
  ND2S U1087 ( .I1(n1463), .I2(n1452), .O(n1458) );
  ND3S U1088 ( .I1(n1446), .I2(n1441), .I3(n1444), .O(n1440) );
  ND2S U1089 ( .I1(n1463), .I2(n1438), .O(n1442) );
  ND2S U1090 ( .I1(u_Conv_out_count[3]), .I2(n1433), .O(n1189) );
  ND2S U1091 ( .I1(u_Conv_out_count[0]), .I2(u_Conv_out_count[1]), .O(n1431)
         );
  ND2S U1092 ( .I1(u_Conv_in_count[1]), .I2(n1204), .O(n1209) );
  OR2S U1093 ( .I1(n1438), .I2(n1444), .O(n1452) );
  ND2S U1094 ( .I1(n1186), .I2(n1206), .O(n1457) );
  AN2S U1095 ( .I1(n1166), .I2(n1165), .O(n1175) );
  AN2S U1096 ( .I1(n1165), .I2(n1157), .O(n1162) );
  HA1S U1097 ( .A(n1159), .B(n1158), .C(n1161), .S(n1516) );
  AN2S U1098 ( .I1(n1153), .I2(n1156), .O(n1158) );
  AN2S U1099 ( .I1(n1157), .I2(n1152), .O(n1159) );
  AN2S U1100 ( .I1(n1157), .I2(n1156), .O(n1515) );
  AO22S U1101 ( .A1(n1523), .A2(u_Conv_psum_reg[7]), .B1(out_data_clk2[7]), 
        .B2(n1522), .O(n540) );
  AO22S U1102 ( .A1(n1523), .A2(u_Conv_psum_reg[6]), .B1(out_data_clk2[6]), 
        .B2(n1522), .O(n541) );
  AO222S U1103 ( .A1(n1523), .A2(u_Conv_psum_reg[5]), .B1(n1522), .B2(
        out_data_clk2[5]), .C1(n1521), .C2(n1520), .O(n542) );
  AO222S U1104 ( .A1(n1523), .A2(u_Conv_psum_reg[4]), .B1(n1522), .B2(
        out_data_clk2[4]), .C1(n1519), .C2(n1520), .O(n543) );
  AO222S U1105 ( .A1(n1523), .A2(u_Conv_psum_reg[3]), .B1(n1522), .B2(
        out_data_clk2[3]), .C1(n1518), .C2(n1520), .O(n544) );
  AO222S U1106 ( .A1(n1523), .A2(u_Conv_psum_reg[2]), .B1(n1522), .B2(
        out_data_clk2[2]), .C1(n1517), .C2(n1520), .O(n545) );
  AO222S U1107 ( .A1(n1523), .A2(u_Conv_psum_reg[1]), .B1(n1522), .B2(
        out_data_clk2[1]), .C1(n1516), .C2(n1520), .O(n546) );
  AO222S U1108 ( .A1(n1523), .A2(u_Conv_psum_reg[0]), .B1(n1520), .B2(n1515), 
        .C1(n1522), .C2(out_data_clk2[0]), .O(n547) );
  OA12S U1109 ( .B1(u_FIFO_syn_w_addr[4]), .B2(n954), .A1(n956), .O(n1528) );
  OA12S U1110 ( .B1(u_FIFO_syn_w_addr[2]), .B2(n950), .A1(n952), .O(n1526) );
  ND2S U1111 ( .I1(u_Conv_kernel_idx[0]), .I2(n1505), .O(n1509) );
  ND2S U1112 ( .I1(n1507), .I2(n1506), .O(n1508) );
  ND2S U1113 ( .I1(n1505), .I2(n1504), .O(n1506) );
  ND2S U1114 ( .I1(n1446), .I2(n1445), .O(n1439) );
  OA12S U1115 ( .B1(u_Conv_out_count[6]), .B2(n943), .A1(n1424), .O(n1192) );
  AO22S U1116 ( .A1(n1437), .A2(u_Conv_out_count[5]), .B1(n1436), .B2(n1435), 
        .O(n744) );
  AO22S U1117 ( .A1(n1434), .A2(u_Conv_out_count[3]), .B1(n1433), .B2(n1432), 
        .O(n746) );
  ND2S U1118 ( .I1(n1428), .I2(n1427), .O(n1430) );
  ND2S U1119 ( .I1(n1429), .I2(u_Conv_out_count[0]), .O(n1426) );
  AO22S U1120 ( .A1(u_Conv_in_count[0]), .A2(n1465), .B1(u_Conv_in_count[1]), 
        .B2(n1466), .O(n735) );
  ND3S U1121 ( .I1(n1218), .I2(n1217), .I3(n1216), .O(n1224) );
  MAOI1S U1122 ( .A1(u_Conv_psum_reg[7]), .A2(n1178), .B1(u_Conv_psum_reg[7]), 
        .B2(n1178), .O(out_data_clk2[7]) );
  HA1S U1123 ( .A(u_Conv_psum_reg[6]), .B(n1177), .C(n1178), .S(
        out_data_clk2[6]) );
  NR2P U1124 ( .I1(u_Conv_kernel_idx[0]), .I2(n972), .O(n1141) );
  NR2P U1125 ( .I1(n1504), .I2(n973), .O(n1142) );
  NR2P U1126 ( .I1(u_Conv_kernel_idx[0]), .I2(n1198), .O(n1194) );
  NR2P U1127 ( .I1(n1014), .I2(n1013), .O(n1116) );
  NR2P U1128 ( .I1(n1504), .I2(n1198), .O(n1140) );
  NR2P U1129 ( .I1(u_Conv_kernel_idx[0]), .I2(n973), .O(n1143) );
  INV1S U1130 ( .I(n943), .O(n1446) );
  ND2P U1131 ( .I1(n1428), .I2(n1463), .O(n943) );
  NR2P U1132 ( .I1(n1504), .I2(n972), .O(n1195) );
  MOAI1S U1133 ( .A1(n1510), .A2(u_Conv_ifmap_x[0]), .B1(n1510), .B2(
        u_Conv_ifmap_x[0]), .O(n1008) );
  ND3S U1134 ( .I1(n987), .I2(n986), .I3(n985), .O(n988) );
  ND3S U1135 ( .I1(n1066), .I2(n1065), .I3(n1064), .O(n1067) );
  ND3S U1136 ( .I1(n1017), .I2(n1016), .I3(n1015), .O(n1018) );
  ND3S U1137 ( .I1(n1385), .I2(n1384), .I3(n1383), .O(n1386) );
  INV1S U1138 ( .I(u_Conv_ifmap_y[0]), .O(n1456) );
  ND3S U1139 ( .I1(n1222), .I2(n1221), .I3(n1220), .O(n1223) );
  TIE0 U1140 ( .O(u_input_output__Logic0_) );
  TIE1 U1141 ( .O(n551) );
  INV1S U1142 ( .I(u_input_output_out_count[0]), .O(n1287) );
  NR2 U1143 ( .I1(u_input_output_in_count[1]), .I2(u_input_output_in_count[0]), 
        .O(n1180) );
  INV1S U1144 ( .I(u_input_output_in_count[2]), .O(n1182) );
  ND2S U1145 ( .I1(n1180), .I2(n1182), .O(n1293) );
  NR2 U1146 ( .I1(u_Handshake_syn_sreq), .I2(u_Handshake_syn_sack), .O(n1289)
         );
  OA12S U1147 ( .B1(in_valid), .B2(n1293), .A1(n1289), .O(n1237) );
  MOAI1S U1148 ( .A1(n1287), .A2(n1237), .B1(n1287), .B2(n1237), .O(n1550) );
  INV1S U1149 ( .I(conv_busy), .O(n1523) );
  INV1S U1150 ( .I(u_Conv_acc_count_y), .O(n1512) );
  INV1S U1151 ( .I(u_Conv_acc_count_x), .O(n1510) );
  NR2 U1152 ( .I1(n1512), .I2(n1510), .O(n1136) );
  INV1S U1153 ( .I(n1136), .O(n1211) );
  NR3 U1154 ( .I1(fifo_full), .I2(n1523), .I3(n1211), .O(n1428) );
  INV1S U1155 ( .I(u_Conv_out_count[4]), .O(n1190) );
  NR3 U1156 ( .I1(u_Conv_out_count[3]), .I2(fifo_full), .I3(n1190), .O(n945)
         );
  ND3S U1157 ( .I1(u_Conv_out_count[7]), .I2(u_Conv_out_count[2]), .I3(n945), 
        .O(n946) );
  NR3 U1158 ( .I1(u_Conv_out_count[0]), .I2(u_Conv_out_count[5]), .I3(n946), 
        .O(n947) );
  INV1S U1159 ( .I(u_Conv_out_count[6]), .O(n1422) );
  ND3S U1160 ( .I1(u_Conv_out_count[1]), .I2(n947), .I3(n1422), .O(n1463) );
  MOAI1S U1161 ( .A1(u_FIFO_syn_w_addr[0]), .A2(n943), .B1(
        u_FIFO_syn_w_addr[0]), .B2(n943), .O(n1524) );
  MOAI1S U1162 ( .A1(u_FIFO_syn_w_addr[1]), .A2(n948), .B1(
        u_FIFO_syn_w_addr[1]), .B2(n948), .O(n1525) );
  INV1S U1163 ( .I(n1525), .O(n951) );
  INV1S U1164 ( .I(u_FIFO_syn_w_addr[1]), .O(n949) );
  MOAI1S U1165 ( .A1(n1524), .A2(n951), .B1(n1524), .B2(n949), .O(n1539) );
  NR2 U1166 ( .I1(n949), .I2(n948), .O(n950) );
  MOAI1S U1167 ( .A1(n951), .A2(u_FIFO_syn_w_addr[2]), .B1(n951), .B2(n1526), 
        .O(n1538) );
  MOAI1S U1168 ( .A1(u_FIFO_syn_w_addr[3]), .A2(n952), .B1(
        u_FIFO_syn_w_addr[3]), .B2(n952), .O(n1527) );
  INV1S U1169 ( .I(n1527), .O(n955) );
  INV1S U1170 ( .I(u_FIFO_syn_w_addr[3]), .O(n953) );
  MOAI1S U1171 ( .A1(n1526), .A2(n955), .B1(n1526), .B2(n953), .O(n1537) );
  NR2 U1172 ( .I1(n953), .I2(n952), .O(n954) );
  MOAI1S U1173 ( .A1(n955), .A2(u_FIFO_syn_w_addr[4]), .B1(n955), .B2(n1528), 
        .O(n1542) );
  MOAI1S U1174 ( .A1(u_FIFO_syn_w_addr[5]), .A2(n956), .B1(
        u_FIFO_syn_w_addr[5]), .B2(n956), .O(n1529) );
  INV1S U1175 ( .I(n1529), .O(n959) );
  INV1S U1176 ( .I(u_FIFO_syn_w_addr[5]), .O(n957) );
  MOAI1S U1177 ( .A1(n1528), .A2(n959), .B1(n1528), .B2(n957), .O(n1541) );
  MOAI1S U1178 ( .A1(u_FIFO_syn_wptr[6]), .A2(n958), .B1(u_FIFO_syn_wptr[6]), 
        .B2(n958), .O(n1540) );
  MOAI1S U1179 ( .A1(n959), .A2(u_FIFO_syn_wptr[6]), .B1(n959), .B2(n1540), 
        .O(n1536) );
  MOAI1S U1180 ( .A1(u_FIFO_syn_r_addr[0]), .A2(fifo_empty), .B1(
        u_FIFO_syn_r_addr[0]), .B2(fifo_empty), .O(n1530) );
  OR2B1S U1181 ( .I1(fifo_empty), .B1(u_FIFO_syn_r_addr[0]), .O(n960) );
  MOAI1S U1182 ( .A1(u_FIFO_syn_r_addr[1]), .A2(n960), .B1(
        u_FIFO_syn_r_addr[1]), .B2(n960), .O(n1531) );
  INV1S U1183 ( .I(n1531), .O(n963) );
  INV1S U1184 ( .I(u_FIFO_syn_r_addr[1]), .O(n961) );
  MOAI1S U1185 ( .A1(n1530), .A2(n963), .B1(n1530), .B2(n961), .O(n1545) );
  NR2 U1186 ( .I1(n961), .I2(n960), .O(n962) );
  ND2S U1187 ( .I1(u_FIFO_syn_r_addr[2]), .I2(n962), .O(n964) );
  OA12S U1188 ( .B1(u_FIFO_syn_r_addr[2]), .B2(n962), .A1(n964), .O(n1532) );
  MOAI1S U1189 ( .A1(n963), .A2(u_FIFO_syn_r_addr[2]), .B1(n963), .B2(n1532), 
        .O(n1544) );
  MOAI1S U1190 ( .A1(u_FIFO_syn_r_addr[3]), .A2(n964), .B1(
        u_FIFO_syn_r_addr[3]), .B2(n964), .O(n1533) );
  INV1S U1191 ( .I(n1533), .O(n967) );
  INV1S U1192 ( .I(u_FIFO_syn_r_addr[3]), .O(n965) );
  MOAI1S U1193 ( .A1(n1532), .A2(n967), .B1(n1532), .B2(n965), .O(n1546) );
  NR2 U1194 ( .I1(n965), .I2(n964), .O(n966) );
  ND2S U1195 ( .I1(u_FIFO_syn_r_addr[4]), .I2(n966), .O(n969) );
  OAI12HS U1196 ( .B1(u_FIFO_syn_r_addr[4]), .B2(n966), .A1(n969), .O(n968) );
  OAI22S U1197 ( .A1(n967), .A2(u_FIFO_syn_r_addr[4]), .B1(n1533), .B2(n968), 
        .O(n1549) );
  INV1S U1198 ( .I(n968), .O(n1534) );
  MOAI1S U1199 ( .A1(u_FIFO_syn_r_addr[5]), .A2(n969), .B1(
        u_FIFO_syn_r_addr[5]), .B2(n969), .O(n1535) );
  INV1S U1200 ( .I(n1535), .O(n971) );
  OAI22S U1201 ( .A1(n968), .A2(u_FIFO_syn_r_addr[5]), .B1(n1534), .B2(n971), 
        .O(n1543) );
  OR2B1S U1202 ( .I1(n969), .B1(u_FIFO_syn_r_addr[5]), .O(n970) );
  MOAI1S U1203 ( .A1(u_FIFO_syn_rptr[6]), .A2(n970), .B1(u_FIFO_syn_rptr[6]), 
        .B2(n970), .O(n1548) );
  MOAI1S U1204 ( .A1(n971), .A2(u_FIFO_syn_rptr[6]), .B1(n971), .B2(n1548), 
        .O(n1547) );
  INV1S U1205 ( .I(u_Conv_kernel_idx[2]), .O(n1198) );
  AOI22S U1206 ( .A1(n1194), .A2(u_Conv_kernel_reg[5]), .B1(n1140), .B2(
        u_Conv_kernel_reg[2]), .O(n976) );
  AOI22S U1207 ( .A1(n1195), .A2(u_Conv_kernel_reg[8]), .B1(n1141), .B2(
        u_Conv_kernel_reg[11]), .O(n975) );
  INV1S U1208 ( .I(u_Conv_kernel_idx[1]), .O(n1196) );
  AOI22S U1209 ( .A1(n1143), .A2(u_Conv_kernel_reg[17]), .B1(n1142), .B2(
        u_Conv_kernel_reg[14]), .O(n974) );
  NR2 U1210 ( .I1(u_Conv_acc_count_y), .I2(u_Conv_acc_count_x), .O(n1514) );
  AOI22S U1211 ( .A1(n1194), .A2(u_Conv_kernel_reg[59]), .B1(n1140), .B2(
        u_Conv_kernel_reg[56]), .O(n979) );
  AOI22S U1212 ( .A1(n1195), .A2(u_Conv_kernel_reg[62]), .B1(n1141), .B2(
        u_Conv_kernel_reg[65]), .O(n978) );
  AOI22S U1213 ( .A1(n1143), .A2(u_Conv_kernel_reg[71]), .B1(n1142), .B2(
        u_Conv_kernel_reg[68]), .O(n977) );
  AOI22S U1214 ( .A1(n1136), .A2(n981), .B1(n1514), .B2(n980), .O(n991) );
  NR2 U1215 ( .I1(u_Conv_acc_count_y), .I2(n1510), .O(n1511) );
  AOI22S U1216 ( .A1(n1194), .A2(u_Conv_kernel_reg[41]), .B1(
        u_Conv_kernel_reg[38]), .B2(n1140), .O(n984) );
  AOI22S U1217 ( .A1(n1195), .A2(u_Conv_kernel_reg[44]), .B1(
        u_Conv_kernel_reg[47]), .B2(n1141), .O(n983) );
  AOI22S U1218 ( .A1(u_Conv_kernel_reg[53]), .A2(n1143), .B1(
        u_Conv_kernel_reg[50]), .B2(n1142), .O(n982) );
  NR2 U1219 ( .I1(u_Conv_acc_count_x), .I2(n1512), .O(n1148) );
  AOI22S U1220 ( .A1(n1194), .A2(u_Conv_kernel_reg[23]), .B1(n1140), .B2(
        u_Conv_kernel_reg[20]), .O(n987) );
  AOI22S U1221 ( .A1(n1195), .A2(u_Conv_kernel_reg[26]), .B1(n1141), .B2(
        u_Conv_kernel_reg[29]), .O(n986) );
  AOI22S U1222 ( .A1(n1143), .A2(u_Conv_kernel_reg[35]), .B1(n1142), .B2(
        u_Conv_kernel_reg[32]), .O(n985) );
  AOI22S U1223 ( .A1(n1511), .A2(n989), .B1(n1148), .B2(n988), .O(n990) );
  AOI22S U1224 ( .A1(n1456), .A2(u_Conv_acc_count_y), .B1(u_Conv_ifmap_y[0]), 
        .B2(n1512), .O(n1028) );
  INV1S U1225 ( .I(n1028), .O(n1023) );
  NR2 U1226 ( .I1(n1023), .I2(n994), .O(n993) );
  NR2 U1227 ( .I1(n1028), .I2(n994), .O(n1092) );
  AOI22S U1228 ( .A1(n993), .A2(u_Conv_ifmap_reg[3]), .B1(n1092), .B2(
        u_Conv_ifmap_reg[0]), .O(n998) );
  MOAI1S U1229 ( .A1(u_Conv_ifmap_x[2]), .A2(n995), .B1(u_Conv_ifmap_x[2]), 
        .B2(n995), .O(n1009) );
  OR2B1S U1230 ( .I1(n1008), .B1(n1009), .O(n996) );
  NR2 U1231 ( .I1(n1028), .I2(n996), .O(n1094) );
  NR2 U1232 ( .I1(n1023), .I2(n996), .O(n1093) );
  AOI22S U1233 ( .A1(n1094), .A2(u_Conv_ifmap_reg[18]), .B1(n1093), .B2(
        u_Conv_ifmap_reg[21]), .O(n997) );
  NR2 U1234 ( .I1(u_Conv_ifmap_y[1]), .I2(n1456), .O(n1450) );
  AOI22S U1235 ( .A1(n1450), .A2(u_Conv_acc_count_y), .B1(n999), .B2(
        u_Conv_ifmap_y[1]), .O(n1004) );
  NR2 U1236 ( .I1(n1004), .I2(u_Conv_ifmap_y[2]), .O(n1089) );
  AOI22S U1237 ( .A1(n993), .A2(u_Conv_ifmap_reg[9]), .B1(n1092), .B2(
        u_Conv_ifmap_reg[6]), .O(n1001) );
  AOI22S U1238 ( .A1(n1094), .A2(u_Conv_ifmap_reg[24]), .B1(n1093), .B2(
        u_Conv_ifmap_reg[27]), .O(n1000) );
  AOI22S U1239 ( .A1(n1091), .A2(n1003), .B1(n1089), .B2(n1002), .O(n1037) );
  ND2 U1240 ( .I1(n1013), .I2(n1004), .O(n1012) );
  INV1S U1241 ( .I(n1012), .O(n1103) );
  AOI22S U1242 ( .A1(n993), .A2(u_Conv_ifmap_reg[15]), .B1(n1092), .B2(
        u_Conv_ifmap_reg[12]), .O(n1006) );
  AOI22S U1243 ( .A1(n1094), .A2(u_Conv_ifmap_reg[30]), .B1(n1093), .B2(
        u_Conv_ifmap_reg[33]), .O(n1005) );
  INV1S U1244 ( .I(u_Conv_ifmap_x[0]), .O(n1441) );
  NR2 U1245 ( .I1(n1510), .I2(n1441), .O(n1007) );
  MOAI1S U1246 ( .A1(u_Conv_ifmap_x[1]), .A2(n1007), .B1(u_Conv_ifmap_x[1]), 
        .B2(n1007), .O(n1027) );
  NR2 U1247 ( .I1(n1023), .I2(n1027), .O(n1101) );
  INV1S U1248 ( .I(u_Conv_ifmap_x[2]), .O(n1447) );
  NR2P U1249 ( .I1(n1013), .I2(n1011), .O(n1115) );
  INV1S U1250 ( .I(n1089), .O(n1010) );
  NR2P U1251 ( .I1(n1011), .I2(n1010), .O(n1114) );
  AOI22S U1252 ( .A1(n1115), .A2(u_Conv_ifmap_reg[39]), .B1(n1114), .B2(
        u_Conv_ifmap_reg[45]), .O(n1017) );
  NR2P U1253 ( .I1(n1014), .I2(n1010), .O(n1113) );
  NR2P U1254 ( .I1(n1012), .I2(n1011), .O(n1112) );
  AOI22S U1255 ( .A1(n1113), .A2(u_Conv_ifmap_reg[63]), .B1(n1112), .B2(
        u_Conv_ifmap_reg[51]), .O(n1016) );
  NR2P U1256 ( .I1(n1014), .I2(n1012), .O(n1117) );
  AOI22S U1257 ( .A1(n1117), .A2(u_Conv_ifmap_reg[69]), .B1(n1116), .B2(
        u_Conv_ifmap_reg[57]), .O(n1015) );
  AOI22S U1258 ( .A1(n1103), .A2(n1019), .B1(n1101), .B2(n1018), .O(n1036) );
  AOI22S U1259 ( .A1(n1113), .A2(u_Conv_ifmap_reg[99]), .B1(n1112), .B2(
        u_Conv_ifmap_reg[87]), .O(n1022) );
  AOI22S U1260 ( .A1(n1115), .A2(u_Conv_ifmap_reg[75]), .B1(n1114), .B2(
        u_Conv_ifmap_reg[81]), .O(n1021) );
  AOI22S U1261 ( .A1(n1117), .A2(u_Conv_ifmap_reg[105]), .B1(n1116), .B2(
        u_Conv_ifmap_reg[93]), .O(n1020) );
  AOI13HS U1262 ( .B1(n1022), .B2(n1021), .B3(n1020), .A1(n1104), .O(n1034) );
  AOI22S U1263 ( .A1(n1113), .A2(u_Conv_ifmap_reg[96]), .B1(n1112), .B2(
        u_Conv_ifmap_reg[84]), .O(n1026) );
  AOI22S U1264 ( .A1(n1115), .A2(u_Conv_ifmap_reg[72]), .B1(n1114), .B2(
        u_Conv_ifmap_reg[78]), .O(n1025) );
  AOI22S U1265 ( .A1(n1117), .A2(u_Conv_ifmap_reg[102]), .B1(n1116), .B2(
        u_Conv_ifmap_reg[90]), .O(n1024) );
  AOI13HS U1266 ( .B1(n1026), .B2(n1025), .B3(n1024), .A1(n1108), .O(n1033) );
  AOI22S U1267 ( .A1(n1113), .A2(u_Conv_ifmap_reg[60]), .B1(n1112), .B2(
        u_Conv_ifmap_reg[48]), .O(n1031) );
  AOI22S U1268 ( .A1(n1115), .A2(u_Conv_ifmap_reg[36]), .B1(n1114), .B2(
        u_Conv_ifmap_reg[42]), .O(n1030) );
  AOI22S U1269 ( .A1(n1117), .A2(u_Conv_ifmap_reg[66]), .B1(n1116), .B2(
        u_Conv_ifmap_reg[54]), .O(n1029) );
  AOI13HS U1270 ( .B1(n1031), .B2(n1030), .B3(n1029), .A1(n1118), .O(n1032) );
  NR3 U1271 ( .I1(n1034), .I2(n1033), .I3(n1032), .O(n1035) );
  AOI22S U1272 ( .A1(n1194), .A2(u_Conv_kernel_reg[4]), .B1(n1140), .B2(
        u_Conv_kernel_reg[1]), .O(n1040) );
  AOI22S U1273 ( .A1(n1195), .A2(u_Conv_kernel_reg[7]), .B1(n1141), .B2(
        u_Conv_kernel_reg[10]), .O(n1039) );
  AOI22S U1274 ( .A1(n1143), .A2(u_Conv_kernel_reg[16]), .B1(n1142), .B2(
        u_Conv_kernel_reg[13]), .O(n1038) );
  AOI22S U1275 ( .A1(n1194), .A2(u_Conv_kernel_reg[58]), .B1(n1140), .B2(
        u_Conv_kernel_reg[55]), .O(n1043) );
  AOI22S U1276 ( .A1(n1195), .A2(u_Conv_kernel_reg[61]), .B1(n1141), .B2(
        u_Conv_kernel_reg[64]), .O(n1042) );
  AOI22S U1277 ( .A1(n1143), .A2(u_Conv_kernel_reg[70]), .B1(n1142), .B2(
        u_Conv_kernel_reg[67]), .O(n1041) );
  AOI22S U1278 ( .A1(n1136), .A2(n1045), .B1(n1514), .B2(n1044), .O(n1055) );
  AOI22S U1279 ( .A1(n1194), .A2(u_Conv_kernel_reg[40]), .B1(n1140), .B2(
        u_Conv_kernel_reg[37]), .O(n1048) );
  AOI22S U1280 ( .A1(n1195), .A2(u_Conv_kernel_reg[43]), .B1(n1141), .B2(
        u_Conv_kernel_reg[46]), .O(n1047) );
  AOI22S U1281 ( .A1(n1143), .A2(u_Conv_kernel_reg[52]), .B1(n1142), .B2(
        u_Conv_kernel_reg[49]), .O(n1046) );
  AOI22S U1282 ( .A1(n1194), .A2(u_Conv_kernel_reg[22]), .B1(n1140), .B2(
        u_Conv_kernel_reg[19]), .O(n1051) );
  AOI22S U1283 ( .A1(n1195), .A2(u_Conv_kernel_reg[25]), .B1(n1141), .B2(
        u_Conv_kernel_reg[28]), .O(n1050) );
  AOI22S U1284 ( .A1(n1143), .A2(u_Conv_kernel_reg[34]), .B1(n1142), .B2(
        u_Conv_kernel_reg[31]), .O(n1049) );
  AOI22S U1285 ( .A1(n1511), .A2(n1053), .B1(n1148), .B2(n1052), .O(n1054) );
  AOI22S U1286 ( .A1(n993), .A2(u_Conv_ifmap_reg[4]), .B1(n1092), .B2(
        u_Conv_ifmap_reg[1]), .O(n1057) );
  AOI22S U1287 ( .A1(n1094), .A2(u_Conv_ifmap_reg[19]), .B1(n1093), .B2(
        u_Conv_ifmap_reg[22]), .O(n1056) );
  AOI22S U1288 ( .A1(n993), .A2(u_Conv_ifmap_reg[10]), .B1(n1092), .B2(
        u_Conv_ifmap_reg[7]), .O(n1059) );
  AOI22S U1289 ( .A1(n1094), .A2(u_Conv_ifmap_reg[25]), .B1(n1093), .B2(
        u_Conv_ifmap_reg[28]), .O(n1058) );
  AOI22S U1290 ( .A1(n1091), .A2(n1061), .B1(n1089), .B2(n1060), .O(n1083) );
  AOI22S U1291 ( .A1(n993), .A2(u_Conv_ifmap_reg[16]), .B1(n1092), .B2(
        u_Conv_ifmap_reg[13]), .O(n1063) );
  AOI22S U1292 ( .A1(n1094), .A2(u_Conv_ifmap_reg[31]), .B1(n1093), .B2(
        u_Conv_ifmap_reg[34]), .O(n1062) );
  AOI22S U1293 ( .A1(n1115), .A2(u_Conv_ifmap_reg[40]), .B1(n1114), .B2(
        u_Conv_ifmap_reg[46]), .O(n1066) );
  AOI22S U1294 ( .A1(n1113), .A2(u_Conv_ifmap_reg[64]), .B1(n1112), .B2(
        u_Conv_ifmap_reg[52]), .O(n1065) );
  AOI22S U1295 ( .A1(n1117), .A2(u_Conv_ifmap_reg[70]), .B1(n1116), .B2(
        u_Conv_ifmap_reg[58]), .O(n1064) );
  AOI22S U1296 ( .A1(n1103), .A2(n1068), .B1(n1101), .B2(n1067), .O(n1082) );
  AOI22S U1297 ( .A1(n1113), .A2(u_Conv_ifmap_reg[100]), .B1(n1112), .B2(
        u_Conv_ifmap_reg[88]), .O(n1071) );
  AOI22S U1298 ( .A1(n1115), .A2(u_Conv_ifmap_reg[76]), .B1(n1114), .B2(
        u_Conv_ifmap_reg[82]), .O(n1070) );
  AOI22S U1299 ( .A1(n1117), .A2(u_Conv_ifmap_reg[106]), .B1(n1116), .B2(
        u_Conv_ifmap_reg[94]), .O(n1069) );
  AOI13HS U1300 ( .B1(n1071), .B2(n1070), .B3(n1069), .A1(n1104), .O(n1080) );
  AOI22S U1301 ( .A1(n1113), .A2(u_Conv_ifmap_reg[97]), .B1(n1112), .B2(
        u_Conv_ifmap_reg[85]), .O(n1074) );
  AOI22S U1302 ( .A1(n1115), .A2(u_Conv_ifmap_reg[73]), .B1(n1114), .B2(
        u_Conv_ifmap_reg[79]), .O(n1073) );
  AOI22S U1303 ( .A1(n1117), .A2(u_Conv_ifmap_reg[103]), .B1(n1116), .B2(
        u_Conv_ifmap_reg[91]), .O(n1072) );
  AOI13HS U1304 ( .B1(n1074), .B2(n1073), .B3(n1072), .A1(n1108), .O(n1079) );
  AOI22S U1305 ( .A1(n1113), .A2(u_Conv_ifmap_reg[61]), .B1(n1112), .B2(
        u_Conv_ifmap_reg[49]), .O(n1077) );
  AOI22S U1306 ( .A1(n1115), .A2(u_Conv_ifmap_reg[37]), .B1(n1114), .B2(
        u_Conv_ifmap_reg[43]), .O(n1076) );
  AOI22S U1307 ( .A1(n1117), .A2(u_Conv_ifmap_reg[67]), .B1(n1116), .B2(
        u_Conv_ifmap_reg[55]), .O(n1075) );
  AOI13HS U1308 ( .B1(n1077), .B2(n1076), .B3(n1075), .A1(n1118), .O(n1078) );
  NR3 U1309 ( .I1(n1080), .I2(n1079), .I3(n1078), .O(n1081) );
  AOI22S U1310 ( .A1(u_Conv_ifmap_reg[5]), .A2(n993), .B1(u_Conv_ifmap_reg[2]), 
        .B2(n1092), .O(n1085) );
  AOI22S U1311 ( .A1(u_Conv_ifmap_reg[20]), .A2(n1094), .B1(
        u_Conv_ifmap_reg[23]), .B2(n1093), .O(n1084) );
  AOI22S U1312 ( .A1(n993), .A2(u_Conv_ifmap_reg[11]), .B1(n1092), .B2(
        u_Conv_ifmap_reg[8]), .O(n1087) );
  AOI22S U1313 ( .A1(n1094), .A2(u_Conv_ifmap_reg[26]), .B1(n1093), .B2(
        u_Conv_ifmap_reg[29]), .O(n1086) );
  AOI22S U1314 ( .A1(n1091), .A2(n1090), .B1(n1089), .B2(n1088), .O(n1127) );
  AOI22S U1315 ( .A1(n993), .A2(u_Conv_ifmap_reg[17]), .B1(n1092), .B2(
        u_Conv_ifmap_reg[14]), .O(n1096) );
  AOI22S U1316 ( .A1(n1094), .A2(u_Conv_ifmap_reg[32]), .B1(n1093), .B2(
        u_Conv_ifmap_reg[35]), .O(n1095) );
  AOI22S U1317 ( .A1(n1115), .A2(u_Conv_ifmap_reg[41]), .B1(n1114), .B2(
        u_Conv_ifmap_reg[47]), .O(n1099) );
  AOI22S U1318 ( .A1(n1113), .A2(u_Conv_ifmap_reg[65]), .B1(n1112), .B2(
        u_Conv_ifmap_reg[53]), .O(n1098) );
  AOI22S U1319 ( .A1(n1117), .A2(u_Conv_ifmap_reg[71]), .B1(n1116), .B2(
        u_Conv_ifmap_reg[59]), .O(n1097) );
  AOI22S U1320 ( .A1(n1103), .A2(n1102), .B1(n1101), .B2(n1100), .O(n1126) );
  AOI22S U1321 ( .A1(u_Conv_ifmap_reg[101]), .A2(n1113), .B1(
        u_Conv_ifmap_reg[89]), .B2(n1112), .O(n1107) );
  AOI22S U1322 ( .A1(u_Conv_ifmap_reg[77]), .A2(n1115), .B1(
        u_Conv_ifmap_reg[83]), .B2(n1114), .O(n1106) );
  AOI22S U1323 ( .A1(u_Conv_ifmap_reg[107]), .A2(n1117), .B1(
        u_Conv_ifmap_reg[95]), .B2(n1116), .O(n1105) );
  AOI13HS U1324 ( .B1(n1107), .B2(n1106), .B3(n1105), .A1(n1104), .O(n1124) );
  AOI22S U1325 ( .A1(n1113), .A2(u_Conv_ifmap_reg[98]), .B1(n1112), .B2(
        u_Conv_ifmap_reg[86]), .O(n1111) );
  AOI22S U1326 ( .A1(n1115), .A2(u_Conv_ifmap_reg[74]), .B1(n1114), .B2(
        u_Conv_ifmap_reg[80]), .O(n1110) );
  AOI22S U1327 ( .A1(n1117), .A2(u_Conv_ifmap_reg[104]), .B1(n1116), .B2(
        u_Conv_ifmap_reg[92]), .O(n1109) );
  AOI13HS U1328 ( .B1(n1111), .B2(n1110), .B3(n1109), .A1(n1108), .O(n1123) );
  AOI22S U1329 ( .A1(n1113), .A2(u_Conv_ifmap_reg[62]), .B1(n1112), .B2(
        u_Conv_ifmap_reg[50]), .O(n1121) );
  AOI22S U1330 ( .A1(n1115), .A2(u_Conv_ifmap_reg[38]), .B1(n1114), .B2(
        u_Conv_ifmap_reg[44]), .O(n1120) );
  AOI22S U1331 ( .A1(n1117), .A2(u_Conv_ifmap_reg[68]), .B1(n1116), .B2(
        u_Conv_ifmap_reg[56]), .O(n1119) );
  AOI13HS U1332 ( .B1(n1121), .B2(n1120), .B3(n1119), .A1(n1118), .O(n1122) );
  NR3 U1333 ( .I1(n1124), .I2(n1123), .I3(n1122), .O(n1125) );
  AOI22S U1334 ( .A1(n1194), .A2(u_Conv_kernel_reg[3]), .B1(n1140), .B2(
        u_Conv_kernel_reg[0]), .O(n1130) );
  AOI22S U1335 ( .A1(n1195), .A2(u_Conv_kernel_reg[6]), .B1(n1141), .B2(
        u_Conv_kernel_reg[9]), .O(n1129) );
  AOI22S U1336 ( .A1(n1143), .A2(u_Conv_kernel_reg[15]), .B1(n1142), .B2(
        u_Conv_kernel_reg[12]), .O(n1128) );
  AOI22S U1337 ( .A1(n1194), .A2(u_Conv_kernel_reg[57]), .B1(n1140), .B2(
        u_Conv_kernel_reg[54]), .O(n1133) );
  AOI22S U1338 ( .A1(n1195), .A2(u_Conv_kernel_reg[60]), .B1(n1141), .B2(
        u_Conv_kernel_reg[63]), .O(n1132) );
  AOI22S U1339 ( .A1(n1143), .A2(u_Conv_kernel_reg[69]), .B1(n1142), .B2(
        u_Conv_kernel_reg[66]), .O(n1131) );
  AOI22S U1340 ( .A1(n1136), .A2(n1135), .B1(n1514), .B2(n1134), .O(n1151) );
  AOI22S U1341 ( .A1(n1194), .A2(u_Conv_kernel_reg[39]), .B1(n1140), .B2(
        u_Conv_kernel_reg[36]), .O(n1139) );
  AOI22S U1342 ( .A1(n1195), .A2(u_Conv_kernel_reg[42]), .B1(n1141), .B2(
        u_Conv_kernel_reg[45]), .O(n1138) );
  AOI22S U1343 ( .A1(n1143), .A2(u_Conv_kernel_reg[51]), .B1(n1142), .B2(
        u_Conv_kernel_reg[48]), .O(n1137) );
  AOI22S U1344 ( .A1(n1194), .A2(u_Conv_kernel_reg[21]), .B1(n1140), .B2(
        u_Conv_kernel_reg[18]), .O(n1146) );
  AOI22S U1345 ( .A1(n1195), .A2(u_Conv_kernel_reg[24]), .B1(n1141), .B2(
        u_Conv_kernel_reg[27]), .O(n1145) );
  AOI22S U1346 ( .A1(n1143), .A2(u_Conv_kernel_reg[33]), .B1(n1142), .B2(
        u_Conv_kernel_reg[30]), .O(n1144) );
  AOI22S U1347 ( .A1(n1511), .A2(n1149), .B1(n1148), .B2(n1147), .O(n1150) );
  FA1S U1348 ( .A(n1162), .B(n1161), .CI(n1160), .CO(n1169), .S(n1517) );
  FA1S U1349 ( .A(u_Conv_psum_reg[2]), .B(n1163), .CI(n1517), .CO(n1172), .S(
        out_data_clk2[2]) );
  FA1S U1350 ( .A(u_Conv_psum_reg[1]), .B(n1164), .CI(n1516), .CO(n1163), .S(
        out_data_clk2[1]) );
  FA1S U1351 ( .A(n1171), .B(n1170), .CI(n1169), .CO(n1173), .S(n1518) );
  FA1S U1352 ( .A(u_Conv_psum_reg[3]), .B(n1518), .CI(n1172), .CO(n1176), .S(
        out_data_clk2[3]) );
  FA1S U1353 ( .A(n1175), .B(n1174), .CI(n1173), .CO(n1521), .S(n1519) );
  FA1S U1354 ( .A(u_Conv_psum_reg[4]), .B(n1519), .CI(n1176), .CO(n1179), .S(
        out_data_clk2[4]) );
  FA1S U1355 ( .A(u_Conv_psum_reg[5]), .B(n1521), .CI(n1179), .CO(n1177), .S(
        out_data_clk2[5]) );
  HA1S U1356 ( .A(u_Conv_psum_reg[0]), .B(n1515), .C(n1164), .S(
        out_data_clk2[0]) );
  BUF2 U1357 ( .I(n944), .O(n1552) );
  INV1S U1358 ( .I(in_row[11]), .O(n1268) );
  MOAI1S U1359 ( .A1(n1250), .A2(n1268), .B1(n1250), .B2(
        u_input_output_in_buffer[53]), .O(n893) );
  INV1S U1360 ( .I(in_row[13]), .O(n1266) );
  MOAI1S U1361 ( .A1(n1250), .A2(n1266), .B1(n1250), .B2(
        u_input_output_in_buffer[55]), .O(n895) );
  INV1S U1362 ( .I(in_row[15]), .O(n1264) );
  MOAI1S U1363 ( .A1(n1250), .A2(n1264), .B1(n1250), .B2(
        u_input_output_in_buffer[57]), .O(n897) );
  INV1S U1364 ( .I(in_row[14]), .O(n1265) );
  MOAI1S U1365 ( .A1(n1250), .A2(n1265), .B1(n1250), .B2(
        u_input_output_in_buffer[56]), .O(n896) );
  INV1S U1366 ( .I(in_kernel[0]), .O(n1262) );
  MOAI1S U1367 ( .A1(n1250), .A2(n1262), .B1(n1250), .B2(
        u_input_output_in_buffer[30]), .O(n900) );
  INV1S U1368 ( .I(in_kernel[3]), .O(n1259) );
  MOAI1S U1369 ( .A1(n1250), .A2(n1259), .B1(n1250), .B2(
        u_input_output_in_buffer[33]), .O(n873) );
  INV1S U1370 ( .I(in_row[12]), .O(n1267) );
  MOAI1S U1371 ( .A1(n1250), .A2(n1267), .B1(n1250), .B2(
        u_input_output_in_buffer[54]), .O(n894) );
  INV1S U1372 ( .I(in_row[16]), .O(n1263) );
  MOAI1S U1373 ( .A1(n1250), .A2(n1263), .B1(n1250), .B2(
        u_input_output_in_buffer[58]), .O(n898) );
  INV1S U1374 ( .I(in_row[0]), .O(n1277) );
  MOAI1S U1375 ( .A1(n1250), .A2(n1277), .B1(n1250), .B2(
        u_input_output_in_buffer[42]), .O(n882) );
  INV1S U1376 ( .I(in_row[1]), .O(n1276) );
  MOAI1S U1377 ( .A1(n1250), .A2(n1276), .B1(n1250), .B2(
        u_input_output_in_buffer[43]), .O(n883) );
  INV1S U1378 ( .I(in_kernel[5]), .O(n1257) );
  MOAI1S U1379 ( .A1(n1250), .A2(n1257), .B1(n1250), .B2(
        u_input_output_in_buffer[35]), .O(n875) );
  INV1S U1380 ( .I(u_input_output_in_count[1]), .O(n1241) );
  ND3S U1381 ( .I1(u_input_output_in_count[0]), .I2(in_valid), .I3(n1241), .O(
        n1240) );
  INV1S U1382 ( .I(n1240), .O(n1181) );
  INV1S U1383 ( .I(in_kernel[4]), .O(n1258) );
  MOAI1S U1384 ( .A1(n1249), .A2(n1258), .B1(n1249), .B2(
        u_input_output_in_buffer[4]), .O(n904) );
  INV1S U1385 ( .I(in_row[2]), .O(n1255) );
  MOAI1S U1386 ( .A1(n1249), .A2(n1255), .B1(n1249), .B2(
        u_input_output_in_buffer[14]), .O(n914) );
  INV1S U1387 ( .I(in_row[17]), .O(n1253) );
  MOAI1S U1388 ( .A1(n1284), .A2(n1253), .B1(n1284), .B2(
        u_input_output_in_buffer[149]), .O(n809) );
  INV1S U1389 ( .I(in_kernel[7]), .O(n1256) );
  MOAI1S U1390 ( .A1(n1284), .A2(n1256), .B1(n1284), .B2(
        u_input_output_in_buffer[127]), .O(n787) );
  INV1S U1391 ( .I(in_row[3]), .O(n1254) );
  MOAI1S U1392 ( .A1(n1284), .A2(n1254), .B1(n1284), .B2(
        u_input_output_in_buffer[135]), .O(n795) );
  INV1S U1393 ( .I(in_kernel[2]), .O(n1260) );
  MOAI1S U1394 ( .A1(n1284), .A2(n1260), .B1(n1284), .B2(
        u_input_output_in_buffer[122]), .O(n782) );
  MOAI1S U1395 ( .A1(n1284), .A2(n1257), .B1(n1284), .B2(
        u_input_output_in_buffer[125]), .O(n785) );
  MOAI1S U1396 ( .A1(n1284), .A2(n1259), .B1(n1284), .B2(
        u_input_output_in_buffer[123]), .O(n783) );
  MOAI1S U1397 ( .A1(n1284), .A2(n1255), .B1(n1284), .B2(
        u_input_output_in_buffer[134]), .O(n794) );
  MOAI1S U1398 ( .A1(n1284), .A2(n1258), .B1(n1284), .B2(
        u_input_output_in_buffer[124]), .O(n784) );
  INV1S U1399 ( .I(u_input_output_in_count[0]), .O(n1242) );
  ND3S U1400 ( .I1(u_input_output_in_count[1]), .I2(in_valid), .I3(n1182), .O(
        n1252) );
  NR2 U1401 ( .I1(n1242), .I2(n1252), .O(n1247) );
  INV1S U1402 ( .I(in_kernel[11]), .O(n1278) );
  MOAI1S U1403 ( .A1(n1251), .A2(n1278), .B1(n1251), .B2(
        u_input_output_in_buffer[71]), .O(n851) );
  MOAI1S U1404 ( .A1(n1251), .A2(n1253), .B1(n1251), .B2(
        u_input_output_in_buffer[89]), .O(n869) );
  MOAI1S U1405 ( .A1(n1251), .A2(n1260), .B1(n1251), .B2(
        u_input_output_in_buffer[62]), .O(n842) );
  MOAI1S U1406 ( .A1(n1251), .A2(n1257), .B1(n1251), .B2(
        u_input_output_in_buffer[65]), .O(n845) );
  MOAI1S U1407 ( .A1(n1251), .A2(n1259), .B1(n1251), .B2(
        u_input_output_in_buffer[63]), .O(n843) );
  MOAI1S U1408 ( .A1(n1251), .A2(n1264), .B1(n1251), .B2(
        u_input_output_in_buffer[87]), .O(n867) );
  MOAI1S U1409 ( .A1(n1251), .A2(n1266), .B1(n1251), .B2(
        u_input_output_in_buffer[85]), .O(n865) );
  MOAI1S U1410 ( .A1(n1251), .A2(n1268), .B1(n1251), .B2(
        u_input_output_in_buffer[83]), .O(n863) );
  MOAI1S U1411 ( .A1(n1251), .A2(n1267), .B1(n1251), .B2(
        u_input_output_in_buffer[84]), .O(n864) );
  MOAI1S U1412 ( .A1(n1251), .A2(n1276), .B1(n1251), .B2(
        u_input_output_in_buffer[73]), .O(n853) );
  MOAI1S U1413 ( .A1(n1251), .A2(n1265), .B1(n1251), .B2(
        u_input_output_in_buffer[86]), .O(n866) );
  MOAI1S U1414 ( .A1(n1251), .A2(n1262), .B1(n1251), .B2(
        u_input_output_in_buffer[60]), .O(n870) );
  MOAI1S U1415 ( .A1(n1251), .A2(n1256), .B1(n1251), .B2(
        u_input_output_in_buffer[67]), .O(n847) );
  MOAI1S U1416 ( .A1(n1251), .A2(n1263), .B1(n1251), .B2(
        u_input_output_in_buffer[88]), .O(n868) );
  INV1S U1417 ( .I(in_data_clk2[6]), .O(n1474) );
  MOAI1S U1418 ( .A1(n1214), .A2(n1474), .B1(n1214), .B2(data_clk1[6]), .O(
        u_Handshake_syn_N26) );
  INV1S U1419 ( .I(in_data_clk2[15]), .O(n1483) );
  MOAI1S U1420 ( .A1(n1214), .A2(n1483), .B1(n1214), .B2(data_clk1[15]), .O(
        u_Handshake_syn_N35) );
  INV1S U1421 ( .I(in_data_clk2[3]), .O(n1471) );
  MOAI1S U1422 ( .A1(n1214), .A2(n1471), .B1(n1214), .B2(data_clk1[3]), .O(
        u_Handshake_syn_N23) );
  INV1S U1423 ( .I(in_data_clk2[17]), .O(n1485) );
  MOAI1S U1424 ( .A1(n1214), .A2(n1485), .B1(n1214), .B2(data_clk1[17]), .O(
        u_Handshake_syn_N37) );
  INV1S U1425 ( .I(in_data_clk2[4]), .O(n1472) );
  MOAI1S U1426 ( .A1(n1214), .A2(n1472), .B1(n1214), .B2(data_clk1[4]), .O(
        u_Handshake_syn_N24) );
  INV1S U1427 ( .I(in_data_clk2[1]), .O(n1469) );
  MOAI1S U1428 ( .A1(n1214), .A2(n1469), .B1(n1214), .B2(data_clk1[1]), .O(
        u_Handshake_syn_N21) );
  INV1S U1429 ( .I(in_data_clk2[20]), .O(n1488) );
  MOAI1S U1430 ( .A1(n1214), .A2(n1488), .B1(n1214), .B2(data_clk1[20]), .O(
        u_Handshake_syn_N40) );
  INV1S U1431 ( .I(in_data_clk2[2]), .O(n1470) );
  MOAI1S U1432 ( .A1(n1214), .A2(n1470), .B1(n1214), .B2(data_clk1[2]), .O(
        u_Handshake_syn_N22) );
  INV1S U1433 ( .I(in_data_clk2[22]), .O(n1490) );
  MOAI1S U1434 ( .A1(n1214), .A2(n1490), .B1(n1214), .B2(data_clk1[22]), .O(
        u_Handshake_syn_N42) );
  INV1S U1435 ( .I(in_data_clk2[23]), .O(n1491) );
  MOAI1S U1436 ( .A1(n1214), .A2(n1491), .B1(n1214), .B2(data_clk1[23]), .O(
        u_Handshake_syn_N43) );
  INV1S U1437 ( .I(in_data_clk2[19]), .O(n1487) );
  MOAI1S U1438 ( .A1(n1214), .A2(n1487), .B1(n1214), .B2(data_clk1[19]), .O(
        u_Handshake_syn_N39) );
  INV1S U1439 ( .I(in_data_clk2[24]), .O(n1493) );
  MOAI1S U1440 ( .A1(n1214), .A2(n1493), .B1(n1214), .B2(data_clk1[24]), .O(
        u_Handshake_syn_N44) );
  INV1S U1441 ( .I(in_data_clk2[21]), .O(n1489) );
  MOAI1S U1442 ( .A1(n1214), .A2(n1489), .B1(n1214), .B2(data_clk1[21]), .O(
        u_Handshake_syn_N41) );
  INV1S U1443 ( .I(in_data_clk2[25]), .O(n1494) );
  MOAI1S U1444 ( .A1(n1214), .A2(n1494), .B1(n1214), .B2(data_clk1[25]), .O(
        u_Handshake_syn_N45) );
  INV1S U1445 ( .I(in_data_clk2[26]), .O(n1495) );
  MOAI1S U1446 ( .A1(n1214), .A2(n1495), .B1(n1214), .B2(data_clk1[26]), .O(
        u_Handshake_syn_N46) );
  INV1S U1447 ( .I(in_data_clk2[16]), .O(n1484) );
  MOAI1S U1448 ( .A1(n1214), .A2(n1484), .B1(n1214), .B2(data_clk1[16]), .O(
        u_Handshake_syn_N36) );
  INV1S U1449 ( .I(in_data_clk2[0]), .O(n1468) );
  MOAI1S U1450 ( .A1(n1214), .A2(n1468), .B1(n1214), .B2(data_clk1[0]), .O(
        u_Handshake_syn_N20) );
  INV1S U1451 ( .I(in_data_clk2[29]), .O(n1502) );
  MOAI1S U1452 ( .A1(n1214), .A2(n1502), .B1(n1214), .B2(data_clk1[29]), .O(
        u_Handshake_syn_N49) );
  INV1S U1453 ( .I(in_data_clk2[28]), .O(n1500) );
  MOAI1S U1454 ( .A1(n1214), .A2(n1500), .B1(n1214), .B2(data_clk1[28]), .O(
        u_Handshake_syn_N48) );
  INV1S U1455 ( .I(in_data_clk2[14]), .O(n1482) );
  MOAI1S U1456 ( .A1(n1214), .A2(n1482), .B1(n1214), .B2(data_clk1[14]), .O(
        u_Handshake_syn_N34) );
  OR2B1S U1457 ( .I1(in_data_valid_clk2), .B1(u_Conv_in_valid_reg), .O(n1464)
         );
  INV1S U1458 ( .I(n1464), .O(n1183) );
  INV1S U1459 ( .I(u_Conv_in_count[0]), .O(n1462) );
  INV1S U1460 ( .I(u_Conv_in_count[2]), .O(n1204) );
  NR2 U1461 ( .I1(n1462), .I2(n1209), .O(n1199) );
  MOAI1S U1462 ( .A1(n1498), .A2(n1482), .B1(n1498), .B2(u_Conv_ifmap_reg[98]), 
        .O(n646) );
  MOAI1S U1463 ( .A1(n1498), .A2(n1489), .B1(n1498), .B2(u_Conv_ifmap_reg[42]), 
        .O(n604) );
  MOAI1S U1464 ( .A1(n1498), .A2(n1483), .B1(n1498), .B2(u_Conv_ifmap_reg[78]), 
        .O(n640) );
  INV1S U1465 ( .I(in_data_clk2[13]), .O(n1481) );
  MOAI1S U1466 ( .A1(n1498), .A2(n1481), .B1(n1498), .B2(u_Conv_ifmap_reg[97]), 
        .O(n652) );
  INV1S U1467 ( .I(in_data_clk2[11]), .O(n1479) );
  MOAI1S U1468 ( .A1(n1498), .A2(n1479), .B1(n1498), .B2(u_Conv_kernel_reg[8]), 
        .O(n664) );
  MOAI1S U1469 ( .A1(n1498), .A2(n1502), .B1(n1498), .B2(u_Conv_ifmap_reg[8]), 
        .O(n556) );
  INV1S U1470 ( .I(in_data_clk2[8]), .O(n1476) );
  MOAI1S U1471 ( .A1(n1498), .A2(n1476), .B1(n1498), .B2(u_Conv_kernel_reg[26]), .O(n682) );
  MOAI1S U1472 ( .A1(n1498), .A2(n1468), .B1(n1498), .B2(u_Conv_kernel_reg[60]), .O(n730) );
  INV1S U1473 ( .I(in_data_clk2[12]), .O(n1480) );
  MOAI1S U1474 ( .A1(n1498), .A2(n1480), .B1(n1498), .B2(u_Conv_ifmap_reg[96]), 
        .O(n658) );
  INV1S U1475 ( .I(n1209), .O(n1200) );
  MOAI1S U1476 ( .A1(n1503), .A2(n1495), .B1(n1503), .B2(u_Conv_ifmap_reg[29]), 
        .O(n575) );
  MOAI1S U1477 ( .A1(n1503), .A2(n1482), .B1(n1503), .B2(u_Conv_ifmap_reg[101]), .O(n647) );
  MOAI1S U1478 ( .A1(n1503), .A2(n1484), .B1(n1503), .B2(u_Conv_ifmap_reg[82]), 
        .O(n635) );
  MOAI1S U1479 ( .A1(n1503), .A2(n1483), .B1(n1503), .B2(u_Conv_ifmap_reg[81]), 
        .O(n641) );
  MOAI1S U1480 ( .A1(n1503), .A2(n1491), .B1(n1503), .B2(u_Conv_ifmap_reg[47]), 
        .O(n593) );
  MOAI1S U1481 ( .A1(n1503), .A2(n1500), .B1(n1503), .B2(u_Conv_ifmap_reg[10]), 
        .O(n563) );
  INV1S U1482 ( .I(in_data_clk2[27]), .O(n1496) );
  MOAI1S U1483 ( .A1(n1503), .A2(n1496), .B1(n1503), .B2(u_Conv_ifmap_reg[9]), 
        .O(n569) );
  MOAI1S U1484 ( .A1(n1503), .A2(n1494), .B1(n1503), .B2(u_Conv_ifmap_reg[28]), 
        .O(n581) );
  MOAI1S U1485 ( .A1(n1503), .A2(n1480), .B1(n1503), .B2(u_Conv_ifmap_reg[99]), 
        .O(n659) );
  MOAI1S U1486 ( .A1(n1503), .A2(n1481), .B1(n1503), .B2(u_Conv_ifmap_reg[100]), .O(n653) );
  MOAI1S U1487 ( .A1(n1503), .A2(n1469), .B1(n1503), .B2(u_Conv_kernel_reg[64]), .O(n725) );
  NR2 U1488 ( .I1(u_Conv_out_count[3]), .I2(n943), .O(n1432) );
  INV1S U1489 ( .I(u_Conv_out_count[2]), .O(n1427) );
  NR2 U1490 ( .I1(n1427), .I2(n1431), .O(n1433) );
  OAI12HS U1491 ( .B1(n1433), .B2(n943), .A1(n1428), .O(n1434) );
  NR2 U1492 ( .I1(n1432), .I2(n1434), .O(n1185) );
  NR2 U1493 ( .I1(n943), .I2(n1189), .O(n1184) );
  MOAI1S U1494 ( .A1(n1190), .A2(n1185), .B1(n1190), .B2(n1184), .O(n745) );
  NR2 U1495 ( .I1(u_Conv_in_count[1]), .I2(n1464), .O(n1465) );
  MOAI1S U1496 ( .A1(n1501), .A2(n1502), .B1(n1501), .B2(u_Conv_ifmap_reg[2]), 
        .O(n554) );
  MOAI1S U1497 ( .A1(n1501), .A2(n1468), .B1(n1501), .B2(u_Conv_kernel_reg[54]), .O(n728) );
  MOAI1S U1498 ( .A1(n1501), .A2(n1470), .B1(n1501), .B2(u_Conv_kernel_reg[56]), .O(n716) );
  MOAI1S U1499 ( .A1(n1501), .A2(n1472), .B1(n1501), .B2(u_Conv_kernel_reg[37]), .O(n704) );
  MOAI1S U1500 ( .A1(n1501), .A2(n1471), .B1(n1501), .B2(u_Conv_kernel_reg[36]), .O(n710) );
  MOAI1S U1501 ( .A1(n1501), .A2(n1487), .B1(n1501), .B2(u_Conv_ifmap_reg[55]), 
        .O(n614) );
  MOAI1S U1502 ( .A1(n1501), .A2(n1496), .B1(n1501), .B2(u_Conv_ifmap_reg[0]), 
        .O(n566) );
  MOAI1S U1503 ( .A1(n1501), .A2(n1485), .B1(n1501), .B2(u_Conv_ifmap_reg[74]), 
        .O(n626) );
  INV1S U1504 ( .I(in_data_clk2[18]), .O(n1486) );
  MOAI1S U1505 ( .A1(n1501), .A2(n1486), .B1(n1501), .B2(u_Conv_ifmap_reg[54]), 
        .O(n620) );
  MOAI1S U1506 ( .A1(n1501), .A2(n1474), .B1(n1501), .B2(u_Conv_kernel_reg[18]), .O(n692) );
  MOAI1S U1507 ( .A1(n1501), .A2(n1489), .B1(n1501), .B2(u_Conv_ifmap_reg[36]), 
        .O(n602) );
  INV1S U1508 ( .I(in_data_clk2[5]), .O(n1473) );
  MOAI1S U1509 ( .A1(n1501), .A2(n1473), .B1(n1501), .B2(u_Conv_kernel_reg[38]), .O(n698) );
  MOAI1S U1510 ( .A1(n1501), .A2(n1494), .B1(n1501), .B2(u_Conv_ifmap_reg[19]), 
        .O(n578) );
  INV1S U1511 ( .I(in_data_clk2[7]), .O(n1475) );
  MOAI1S U1512 ( .A1(n1501), .A2(n1475), .B1(n1501), .B2(u_Conv_kernel_reg[19]), .O(n686) );
  MOAI1S U1513 ( .A1(n1499), .A2(n1474), .B1(n1499), .B2(u_Conv_kernel_reg[21]), .O(n693) );
  MOAI1S U1514 ( .A1(n1499), .A2(n1471), .B1(n1499), .B2(u_Conv_kernel_reg[39]), .O(n711) );
  MOAI1S U1515 ( .A1(n1499), .A2(n1502), .B1(n1499), .B2(u_Conv_ifmap_reg[5]), 
        .O(n555) );
  MOAI1S U1516 ( .A1(n1499), .A2(n1472), .B1(n1499), .B2(u_Conv_kernel_reg[40]), .O(n705) );
  MOAI1S U1517 ( .A1(n1499), .A2(n1475), .B1(n1499), .B2(u_Conv_kernel_reg[22]), .O(n687) );
  MOAI1S U1518 ( .A1(n1499), .A2(n1485), .B1(n1499), .B2(u_Conv_ifmap_reg[77]), 
        .O(n627) );
  MOAI1S U1519 ( .A1(n1499), .A2(n1486), .B1(n1499), .B2(u_Conv_ifmap_reg[57]), 
        .O(n621) );
  MOAI1S U1520 ( .A1(n1499), .A2(n1487), .B1(n1499), .B2(u_Conv_ifmap_reg[58]), 
        .O(n615) );
  MOAI1S U1521 ( .A1(n1499), .A2(n1468), .B1(n1499), .B2(u_Conv_kernel_reg[57]), .O(n729) );
  MOAI1S U1522 ( .A1(n1499), .A2(n1489), .B1(n1499), .B2(u_Conv_ifmap_reg[39]), 
        .O(n603) );
  MOAI1S U1523 ( .A1(n1499), .A2(n1473), .B1(n1499), .B2(u_Conv_kernel_reg[41]), .O(n699) );
  MOAI1S U1524 ( .A1(n1499), .A2(n1494), .B1(n1499), .B2(u_Conv_ifmap_reg[22]), 
        .O(n579) );
  MOAI1S U1525 ( .A1(n1499), .A2(n1470), .B1(n1499), .B2(u_Conv_kernel_reg[59]), .O(n717) );
  MOAI1S U1526 ( .A1(n1499), .A2(n1496), .B1(n1499), .B2(u_Conv_ifmap_reg[3]), 
        .O(n567) );
  MOAI1S U1527 ( .A1(n1499), .A2(n1490), .B1(n1499), .B2(u_Conv_ifmap_reg[40]), 
        .O(n597) );
  MOAI1S U1528 ( .A1(n1497), .A2(n1502), .B1(n1497), .B2(u_Conv_ifmap_reg[14]), 
        .O(n558) );
  MOAI1S U1529 ( .A1(n1497), .A2(n1474), .B1(n1497), .B2(u_Conv_kernel_reg[30]), .O(n696) );
  MOAI1S U1530 ( .A1(n1497), .A2(n1473), .B1(n1497), .B2(u_Conv_kernel_reg[50]), .O(n702) );
  MOAI1S U1531 ( .A1(n1497), .A2(n1472), .B1(n1497), .B2(u_Conv_kernel_reg[49]), .O(n708) );
  MOAI1S U1532 ( .A1(n1497), .A2(n1471), .B1(n1497), .B2(u_Conv_kernel_reg[48]), .O(n714) );
  MOAI1S U1533 ( .A1(n1497), .A2(n1470), .B1(n1497), .B2(u_Conv_kernel_reg[68]), .O(n720) );
  MOAI1S U1534 ( .A1(n1497), .A2(n1468), .B1(n1497), .B2(u_Conv_kernel_reg[66]), .O(n732) );
  MOAI1S U1535 ( .A1(n1497), .A2(n1486), .B1(n1497), .B2(u_Conv_ifmap_reg[66]), 
        .O(n624) );
  MOAI1S U1536 ( .A1(n1497), .A2(n1487), .B1(n1497), .B2(u_Conv_ifmap_reg[67]), 
        .O(n618) );
  MOAI1S U1537 ( .A1(n1497), .A2(n1485), .B1(n1497), .B2(u_Conv_ifmap_reg[86]), 
        .O(n630) );
  MOAI1S U1538 ( .A1(n1497), .A2(n1494), .B1(n1497), .B2(u_Conv_ifmap_reg[31]), 
        .O(n582) );
  MOAI1S U1539 ( .A1(n1497), .A2(n1489), .B1(n1497), .B2(u_Conv_ifmap_reg[48]), 
        .O(n606) );
  MOAI1S U1540 ( .A1(n1497), .A2(n1475), .B1(n1497), .B2(u_Conv_kernel_reg[31]), .O(n690) );
  MOAI1S U1541 ( .A1(n1497), .A2(n1490), .B1(n1497), .B2(u_Conv_ifmap_reg[49]), 
        .O(n600) );
  MOAI1S U1542 ( .A1(n1497), .A2(n1496), .B1(n1497), .B2(u_Conv_ifmap_reg[12]), 
        .O(n570) );
  MOAI1S U1543 ( .A1(n1492), .A2(n1500), .B1(n1492), .B2(u_Conv_ifmap_reg[16]), 
        .O(n565) );
  MOAI1S U1544 ( .A1(n1492), .A2(n1469), .B1(n1492), .B2(u_Conv_kernel_reg[70]), .O(n727) );
  MOAI1S U1545 ( .A1(n1492), .A2(n1491), .B1(n1492), .B2(u_Conv_ifmap_reg[53]), 
        .O(n595) );
  MOAI1S U1546 ( .A1(n1492), .A2(n1495), .B1(n1492), .B2(u_Conv_ifmap_reg[35]), 
        .O(n577) );
  MOAI1S U1547 ( .A1(n1492), .A2(n1496), .B1(n1492), .B2(u_Conv_ifmap_reg[15]), 
        .O(n571) );
  MOAI1S U1548 ( .A1(n1492), .A2(n1473), .B1(n1492), .B2(u_Conv_kernel_reg[53]), .O(n703) );
  MOAI1S U1549 ( .A1(n1492), .A2(n1494), .B1(n1492), .B2(u_Conv_ifmap_reg[34]), 
        .O(n583) );
  MOAI1S U1550 ( .A1(n1492), .A2(n1487), .B1(n1492), .B2(u_Conv_ifmap_reg[70]), 
        .O(n619) );
  MOAI1S U1551 ( .A1(n1492), .A2(n1474), .B1(n1492), .B2(u_Conv_kernel_reg[33]), .O(n697) );
  MOAI1S U1552 ( .A1(n1492), .A2(n1485), .B1(n1492), .B2(u_Conv_ifmap_reg[89]), 
        .O(n631) );
  MOAI1S U1553 ( .A1(n1492), .A2(n1472), .B1(n1492), .B2(u_Conv_kernel_reg[52]), .O(n709) );
  MOAI1S U1554 ( .A1(n1492), .A2(n1502), .B1(n1492), .B2(u_Conv_ifmap_reg[17]), 
        .O(n559) );
  MOAI1S U1555 ( .A1(n1492), .A2(n1489), .B1(n1492), .B2(u_Conv_ifmap_reg[51]), 
        .O(n607) );
  MOAI1S U1556 ( .A1(n1492), .A2(n1471), .B1(n1492), .B2(u_Conv_kernel_reg[51]), .O(n715) );
  MOAI1S U1557 ( .A1(n1492), .A2(n1470), .B1(n1492), .B2(u_Conv_kernel_reg[71]), .O(n721) );
  MOAI1S U1558 ( .A1(n1492), .A2(n1475), .B1(n1492), .B2(u_Conv_kernel_reg[34]), .O(n691) );
  MOAI1S U1559 ( .A1(n1492), .A2(n1468), .B1(n1492), .B2(u_Conv_kernel_reg[69]), .O(n733) );
  MOAI1S U1560 ( .A1(n1492), .A2(n1486), .B1(n1492), .B2(u_Conv_ifmap_reg[69]), 
        .O(n625) );
  INV1S U1561 ( .I(u_Conv_ifmap_x[1]), .O(n1445) );
  ND3S U1562 ( .I1(n1445), .I2(n1441), .I3(u_Conv_ifmap_x[2]), .O(n1444) );
  NR2 U1563 ( .I1(n943), .I2(n1444), .O(n1186) );
  INV1S U1564 ( .I(n1186), .O(n1454) );
  INV1S U1565 ( .I(u_Conv_ifmap_y[2]), .O(n1203) );
  ND3S U1566 ( .I1(u_Conv_ifmap_y[1]), .I2(u_Conv_ifmap_y[0]), .I3(n1203), .O(
        n1205) );
  INV1S U1567 ( .I(u_Conv_ifmap_y[1]), .O(n1453) );
  NR2 U1568 ( .I1(n1456), .I2(n1453), .O(n1187) );
  ND3S U1569 ( .I1(u_Conv_ifmap_y[2]), .I2(n1456), .I3(n1453), .O(n1206) );
  INV1S U1570 ( .I(n1428), .O(n1438) );
  MOAI1S U1571 ( .A1(n1187), .A2(n1457), .B1(n1463), .B2(n1452), .O(n1188) );
  MOAI1S U1572 ( .A1(n1454), .A2(n1205), .B1(u_Conv_ifmap_y[2]), .B2(n1188), 
        .O(n737) );
  INV1S U1573 ( .I(u_Conv_out_count[7]), .O(n1193) );
  NR2 U1574 ( .I1(u_Conv_out_count[5]), .I2(n943), .O(n1436) );
  NR2 U1575 ( .I1(n1190), .I2(n1189), .O(n1435) );
  OAI12HS U1576 ( .B1(n1435), .B2(n943), .A1(n1428), .O(n1437) );
  NR2 U1577 ( .I1(n1436), .I2(n1437), .O(n1424) );
  ND3S U1578 ( .I1(u_Conv_out_count[5]), .I2(n1446), .I3(n1435), .O(n1423) );
  NR2 U1579 ( .I1(n1422), .I2(n1423), .O(n1191) );
  MOAI1S U1580 ( .A1(n1193), .A2(n1192), .B1(n1193), .B2(n1191), .O(n743) );
  OAI12HS U1581 ( .B1(n1206), .B2(n1452), .A1(n1463), .O(n1507) );
  NR2 U1582 ( .I1(n1206), .I2(n1454), .O(n1505) );
  MOAI1S U1583 ( .A1(n1504), .A2(n1507), .B1(n1504), .B2(n1505), .O(n552) );
  AO112S U1584 ( .C1(n1196), .C2(u_Conv_kernel_idx[2]), .A1(n1195), .B1(n1194), 
        .O(n1197) );
  MOAI1S U1585 ( .A1(n1507), .A2(n1198), .B1(n1505), .B2(n1197), .O(n550) );
  OA12S U1586 ( .B1(u_Handshake_syn_dack), .B2(n1523), .A1(
        u_Handshake_syn_dreq), .O(u_Handshake_syn_N16) );
  NR2 U1587 ( .I1(u_Conv_ifmap_y[0]), .I2(n1453), .O(n1451) );
  INV1S U1588 ( .I(n1199), .O(n1202) );
  ND3S U1589 ( .I1(u_Conv_in_count[1]), .I2(u_Conv_in_count[2]), .I3(n1462), 
        .O(n1459) );
  MOAI1S U1590 ( .A1(u_Conv_in_count[1]), .A2(n1204), .B1(n1523), .B2(n1459), 
        .O(n1201) );
  OAI22S U1591 ( .A1(n1451), .A2(n1202), .B1(n1201), .B2(n1200), .O(n1213) );
  OA12S U1592 ( .B1(n1450), .B2(u_Conv_in_count[0]), .A1(n1203), .O(n1210) );
  OR2S U1593 ( .I1(n1204), .I2(u_Conv_in_count[1]), .O(n1208) );
  AOI22S U1594 ( .A1(u_Conv_in_count[0]), .A2(n1206), .B1(n1205), .B2(n1462), 
        .O(n1207) );
  OAI22S U1595 ( .A1(n1210), .A2(n1209), .B1(n1208), .B2(n1207), .O(n1212) );
  OA22S U1596 ( .A1(n1213), .A2(n1212), .B1(n1463), .B2(n1211), .O(u_Conv_N358) );
  MOAI1S U1597 ( .A1(n1214), .A2(n1473), .B1(n1214), .B2(data_clk1[5]), .O(
        u_Handshake_syn_N25) );
  MOAI1S U1598 ( .A1(n1214), .A2(n1475), .B1(n1214), .B2(data_clk1[7]), .O(
        u_Handshake_syn_N27) );
  MOAI1S U1599 ( .A1(n1214), .A2(n1476), .B1(n1214), .B2(data_clk1[8]), .O(
        u_Handshake_syn_N28) );
  INV1S U1600 ( .I(in_data_clk2[9]), .O(n1477) );
  MOAI1S U1601 ( .A1(n1214), .A2(n1477), .B1(n1214), .B2(data_clk1[9]), .O(
        u_Handshake_syn_N29) );
  INV1S U1602 ( .I(in_data_clk2[10]), .O(n1478) );
  MOAI1S U1603 ( .A1(n1214), .A2(n1478), .B1(n1214), .B2(data_clk1[10]), .O(
        u_Handshake_syn_N30) );
  MOAI1S U1604 ( .A1(n1214), .A2(n1479), .B1(n1214), .B2(data_clk1[11]), .O(
        u_Handshake_syn_N31) );
  MOAI1S U1605 ( .A1(n1214), .A2(n1480), .B1(n1214), .B2(data_clk1[12]), .O(
        u_Handshake_syn_N32) );
  MOAI1S U1606 ( .A1(n1214), .A2(n1481), .B1(n1214), .B2(data_clk1[13]), .O(
        u_Handshake_syn_N33) );
  MOAI1S U1607 ( .A1(n1214), .A2(n1486), .B1(n1214), .B2(data_clk1[18]), .O(
        u_Handshake_syn_N38) );
  MOAI1S U1608 ( .A1(n1214), .A2(n1496), .B1(n1214), .B2(data_clk1[27]), .O(
        u_Handshake_syn_N47) );
  NR2 U1609 ( .I1(u_Handshake_syn_sreq), .I2(n1237), .O(n1215) );
  NR2 U1610 ( .I1(u_Handshake_syn_sack), .I2(n1215), .O(u_Handshake_syn_N10)
         );
  AN2S U1611 ( .I1(fifo_rdata[0]), .I2(out_valid), .O(out_data[0]) );
  AN2S U1612 ( .I1(fifo_rdata[1]), .I2(out_valid), .O(out_data[1]) );
  AN2S U1613 ( .I1(fifo_rdata[2]), .I2(out_valid), .O(out_data[2]) );
  AN2S U1614 ( .I1(fifo_rdata[3]), .I2(out_valid), .O(out_data[3]) );
  AN2S U1615 ( .I1(fifo_rdata[4]), .I2(out_valid), .O(out_data[4]) );
  AN2S U1616 ( .I1(fifo_rdata[5]), .I2(out_valid), .O(out_data[5]) );
  AN2S U1617 ( .I1(fifo_rdata[6]), .I2(out_valid), .O(out_data[6]) );
  AN2S U1618 ( .I1(fifo_rdata[7]), .I2(out_valid), .O(out_data[7]) );
  MOAI1S U1619 ( .A1(n1536), .A2(u_FIFO_syn_rptr_q[5]), .B1(n1536), .B2(
        u_FIFO_syn_rptr_q[5]), .O(n1225) );
  MOAI1S U1620 ( .A1(n1537), .A2(u_FIFO_syn_rptr_q[2]), .B1(n1537), .B2(
        u_FIFO_syn_rptr_q[2]), .O(n1218) );
  MOAI1S U1621 ( .A1(n1538), .A2(u_FIFO_syn_rptr_q[1]), .B1(n1538), .B2(
        u_FIFO_syn_rptr_q[1]), .O(n1217) );
  MOAI1S U1622 ( .A1(n1539), .A2(u_FIFO_syn_rptr_q[0]), .B1(n1539), .B2(
        u_FIFO_syn_rptr_q[0]), .O(n1216) );
  INV1S U1623 ( .I(u_FIFO_syn_rptr_q[6]), .O(n1219) );
  MOAI1S U1624 ( .A1(n1219), .A2(n1540), .B1(n1219), .B2(n1540), .O(n1222) );
  MOAI1S U1625 ( .A1(n1541), .A2(u_FIFO_syn_rptr_q[4]), .B1(n1541), .B2(
        u_FIFO_syn_rptr_q[4]), .O(n1221) );
  MOAI1S U1626 ( .A1(n1542), .A2(u_FIFO_syn_rptr_q[3]), .B1(n1542), .B2(
        u_FIFO_syn_rptr_q[3]), .O(n1220) );
  NR3 U1627 ( .I1(n1225), .I2(n1224), .I3(n1223), .O(u_FIFO_syn_N13) );
  MOAI1S U1628 ( .A1(n1543), .A2(u_FIFO_syn_wptr_q[4]), .B1(n1543), .B2(
        u_FIFO_syn_wptr_q[4]), .O(n1234) );
  MOAI1S U1629 ( .A1(n1544), .A2(u_FIFO_syn_wptr_q[1]), .B1(n1544), .B2(
        u_FIFO_syn_wptr_q[1]), .O(n1228) );
  MOAI1S U1630 ( .A1(n1545), .A2(u_FIFO_syn_wptr_q[0]), .B1(n1545), .B2(
        u_FIFO_syn_wptr_q[0]), .O(n1227) );
  MOAI1S U1631 ( .A1(n1546), .A2(u_FIFO_syn_wptr_q[2]), .B1(n1546), .B2(
        u_FIFO_syn_wptr_q[2]), .O(n1226) );
  ND3S U1632 ( .I1(n1228), .I2(n1227), .I3(n1226), .O(n1233) );
  MOAI1S U1633 ( .A1(n1547), .A2(u_FIFO_syn_wptr_q[5]), .B1(n1547), .B2(
        u_FIFO_syn_wptr_q[5]), .O(n1231) );
  MOAI1S U1634 ( .A1(n1548), .A2(u_FIFO_syn_wptr_q[6]), .B1(n1548), .B2(
        u_FIFO_syn_wptr_q[6]), .O(n1230) );
  MOAI1S U1635 ( .A1(n1549), .A2(u_FIFO_syn_wptr_q[3]), .B1(n1549), .B2(
        u_FIFO_syn_wptr_q[3]), .O(n1229) );
  ND3S U1636 ( .I1(n1231), .I2(n1230), .I3(n1229), .O(n1232) );
  AN3B2S U1637 ( .I1(n1234), .B1(n1233), .B2(n1232), .O(u_FIFO_syn_N8) );
  INV1S U1638 ( .I(u_input_output_out_count[1]), .O(n1288) );
  NR2 U1639 ( .I1(n1550), .I2(n1288), .O(n1236) );
  INV1S U1640 ( .I(u_input_output_out_count[2]), .O(n1286) );
  INV2 U1641 ( .I(n1237), .O(n1412) );
  ND2S U1642 ( .I1(n1286), .I2(u_input_output_out_count[0]), .O(n1292) );
  OR2S U1643 ( .I1(n1288), .I2(n1292), .O(n1235) );
  OAI22S U1644 ( .A1(n1236), .A2(n1286), .B1(n1412), .B2(n1235), .O(n936) );
  ND2S U1645 ( .I1(u_input_output_out_count[0]), .I2(n1237), .O(n1239) );
  AOI13HS U1646 ( .B1(u_input_output_out_count[2]), .B2(n1287), .B3(n1412), 
        .A1(n1288), .O(n1238) );
  MOAI1S U1647 ( .A1(n1239), .A2(u_input_output_out_count[1]), .B1(n1239), 
        .B2(n1238), .O(n934) );
  ND3S U1648 ( .I1(u_input_output_out_count[1]), .I2(
        u_input_output_out_count[2]), .I3(n1287), .O(n1243) );
  INV1S U1649 ( .I(in_valid), .O(n1246) );
  OAI22S U1650 ( .A1(in_valid), .A2(n1243), .B1(n1246), .B2(n1242), .O(n1245)
         );
  OAI12HS U1651 ( .B1(n1245), .B2(n1241), .A1(n1240), .O(n933) );
  NR2 U1652 ( .I1(in_valid), .I2(n1242), .O(n1244) );
  MOAI1S U1653 ( .A1(u_input_output_in_count[0]), .A2(n1246), .B1(n1244), .B2(
        n1243), .O(n932) );
  OAI12HS U1654 ( .B1(u_input_output_in_count[1]), .B2(n1246), .A1(n1245), .O(
        n1248) );
  AO12S U1655 ( .B1(u_input_output_in_count[2]), .B2(n1248), .A1(n1247), .O(
        n931) );
  MOAI1S U1656 ( .A1(n1249), .A2(n1262), .B1(n1249), .B2(
        u_input_output_in_buffer[0]), .O(n930) );
  MOAI1S U1657 ( .A1(n1249), .A2(n1253), .B1(n1249), .B2(
        u_input_output_in_buffer[29]), .O(n929) );
  MOAI1S U1658 ( .A1(n1249), .A2(n1263), .B1(n1249), .B2(
        u_input_output_in_buffer[28]), .O(n928) );
  MOAI1S U1659 ( .A1(n1249), .A2(n1264), .B1(n1249), .B2(
        u_input_output_in_buffer[27]), .O(n927) );
  MOAI1S U1660 ( .A1(n1249), .A2(n1265), .B1(n1249), .B2(
        u_input_output_in_buffer[26]), .O(n926) );
  MOAI1S U1661 ( .A1(n1249), .A2(n1266), .B1(n1249), .B2(
        u_input_output_in_buffer[25]), .O(n925) );
  MOAI1S U1662 ( .A1(n1249), .A2(n1267), .B1(n1249), .B2(
        u_input_output_in_buffer[24]), .O(n924) );
  MOAI1S U1663 ( .A1(n1249), .A2(n1268), .B1(n1249), .B2(
        u_input_output_in_buffer[23]), .O(n923) );
  INV1S U1664 ( .I(in_row[10]), .O(n1269) );
  MOAI1S U1665 ( .A1(n1249), .A2(n1269), .B1(n1249), .B2(
        u_input_output_in_buffer[22]), .O(n922) );
  INV1S U1666 ( .I(in_row[9]), .O(n1270) );
  MOAI1S U1667 ( .A1(n1249), .A2(n1270), .B1(n1249), .B2(
        u_input_output_in_buffer[21]), .O(n921) );
  INV1S U1668 ( .I(in_row[8]), .O(n1271) );
  MOAI1S U1669 ( .A1(n1249), .A2(n1271), .B1(n1249), .B2(
        u_input_output_in_buffer[20]), .O(n920) );
  INV1S U1670 ( .I(in_row[7]), .O(n1272) );
  MOAI1S U1671 ( .A1(n1249), .A2(n1272), .B1(n1249), .B2(
        u_input_output_in_buffer[19]), .O(n919) );
  INV1S U1672 ( .I(in_row[6]), .O(n1273) );
  MOAI1S U1673 ( .A1(n1249), .A2(n1273), .B1(n1249), .B2(
        u_input_output_in_buffer[18]), .O(n918) );
  INV1S U1674 ( .I(in_row[5]), .O(n1274) );
  MOAI1S U1675 ( .A1(n1249), .A2(n1274), .B1(n1249), .B2(
        u_input_output_in_buffer[17]), .O(n917) );
  INV1S U1676 ( .I(in_row[4]), .O(n1275) );
  MOAI1S U1677 ( .A1(n1249), .A2(n1275), .B1(n1249), .B2(
        u_input_output_in_buffer[16]), .O(n916) );
  MOAI1S U1678 ( .A1(n1249), .A2(n1254), .B1(n1249), .B2(
        u_input_output_in_buffer[15]), .O(n915) );
  MOAI1S U1679 ( .A1(n1249), .A2(n1276), .B1(n1249), .B2(
        u_input_output_in_buffer[13]), .O(n913) );
  MOAI1S U1680 ( .A1(n1249), .A2(n1277), .B1(n1249), .B2(
        u_input_output_in_buffer[12]), .O(n912) );
  MOAI1S U1681 ( .A1(n1249), .A2(n1278), .B1(n1249), .B2(
        u_input_output_in_buffer[11]), .O(n911) );
  INV1S U1682 ( .I(in_kernel[10]), .O(n1279) );
  MOAI1S U1683 ( .A1(n1249), .A2(n1279), .B1(n1249), .B2(
        u_input_output_in_buffer[10]), .O(n910) );
  INV1S U1684 ( .I(in_kernel[9]), .O(n1280) );
  MOAI1S U1685 ( .A1(n1249), .A2(n1280), .B1(n1249), .B2(
        u_input_output_in_buffer[9]), .O(n909) );
  INV1S U1686 ( .I(in_kernel[8]), .O(n1281) );
  MOAI1S U1687 ( .A1(n1249), .A2(n1281), .B1(n1249), .B2(
        u_input_output_in_buffer[8]), .O(n908) );
  MOAI1S U1688 ( .A1(n1249), .A2(n1256), .B1(n1249), .B2(
        u_input_output_in_buffer[7]), .O(n907) );
  INV1S U1689 ( .I(in_kernel[6]), .O(n1282) );
  MOAI1S U1690 ( .A1(n1249), .A2(n1282), .B1(n1249), .B2(
        u_input_output_in_buffer[6]), .O(n906) );
  MOAI1S U1691 ( .A1(n1249), .A2(n1257), .B1(n1249), .B2(
        u_input_output_in_buffer[5]), .O(n905) );
  MOAI1S U1692 ( .A1(n1249), .A2(n1259), .B1(n1249), .B2(
        u_input_output_in_buffer[3]), .O(n903) );
  MOAI1S U1693 ( .A1(n1249), .A2(n1260), .B1(n1249), .B2(
        u_input_output_in_buffer[2]), .O(n902) );
  INV1S U1694 ( .I(in_kernel[1]), .O(n1283) );
  MOAI1S U1695 ( .A1(n1249), .A2(n1283), .B1(n1249), .B2(
        u_input_output_in_buffer[1]), .O(n901) );
  MOAI1S U1696 ( .A1(n1250), .A2(n1253), .B1(n1250), .B2(
        u_input_output_in_buffer[59]), .O(n899) );
  MOAI1S U1697 ( .A1(n1250), .A2(n1269), .B1(n1250), .B2(
        u_input_output_in_buffer[52]), .O(n892) );
  MOAI1S U1698 ( .A1(n1250), .A2(n1270), .B1(n1250), .B2(
        u_input_output_in_buffer[51]), .O(n891) );
  MOAI1S U1699 ( .A1(n1250), .A2(n1271), .B1(n1250), .B2(
        u_input_output_in_buffer[50]), .O(n890) );
  MOAI1S U1700 ( .A1(n1250), .A2(n1272), .B1(n1250), .B2(
        u_input_output_in_buffer[49]), .O(n889) );
  MOAI1S U1701 ( .A1(n1250), .A2(n1273), .B1(n1250), .B2(
        u_input_output_in_buffer[48]), .O(n888) );
  MOAI1S U1702 ( .A1(n1250), .A2(n1274), .B1(n1250), .B2(
        u_input_output_in_buffer[47]), .O(n887) );
  MOAI1S U1703 ( .A1(n1250), .A2(n1275), .B1(n1250), .B2(
        u_input_output_in_buffer[46]), .O(n886) );
  MOAI1S U1704 ( .A1(n1250), .A2(n1254), .B1(n1250), .B2(
        u_input_output_in_buffer[45]), .O(n885) );
  MOAI1S U1705 ( .A1(n1250), .A2(n1255), .B1(n1250), .B2(
        u_input_output_in_buffer[44]), .O(n884) );
  MOAI1S U1706 ( .A1(n1250), .A2(n1278), .B1(n1250), .B2(
        u_input_output_in_buffer[41]), .O(n881) );
  MOAI1S U1707 ( .A1(n1250), .A2(n1279), .B1(n1250), .B2(
        u_input_output_in_buffer[40]), .O(n880) );
  MOAI1S U1708 ( .A1(n1250), .A2(n1280), .B1(n1250), .B2(
        u_input_output_in_buffer[39]), .O(n879) );
  MOAI1S U1709 ( .A1(n1250), .A2(n1281), .B1(n1250), .B2(
        u_input_output_in_buffer[38]), .O(n878) );
  MOAI1S U1710 ( .A1(n1250), .A2(n1256), .B1(n1250), .B2(
        u_input_output_in_buffer[37]), .O(n877) );
  MOAI1S U1711 ( .A1(n1250), .A2(n1282), .B1(n1250), .B2(
        u_input_output_in_buffer[36]), .O(n876) );
  MOAI1S U1712 ( .A1(n1250), .A2(n1258), .B1(n1250), .B2(
        u_input_output_in_buffer[34]), .O(n874) );
  MOAI1S U1713 ( .A1(n1250), .A2(n1260), .B1(n1250), .B2(
        u_input_output_in_buffer[32]), .O(n872) );
  MOAI1S U1714 ( .A1(n1250), .A2(n1283), .B1(n1250), .B2(
        u_input_output_in_buffer[31]), .O(n871) );
  MOAI1S U1715 ( .A1(n1251), .A2(n1269), .B1(n1251), .B2(
        u_input_output_in_buffer[82]), .O(n862) );
  MOAI1S U1716 ( .A1(n1251), .A2(n1270), .B1(n1251), .B2(
        u_input_output_in_buffer[81]), .O(n861) );
  MOAI1S U1717 ( .A1(n1251), .A2(n1271), .B1(n1251), .B2(
        u_input_output_in_buffer[80]), .O(n860) );
  MOAI1S U1718 ( .A1(n1251), .A2(n1272), .B1(n1251), .B2(
        u_input_output_in_buffer[79]), .O(n859) );
  MOAI1S U1719 ( .A1(n1251), .A2(n1273), .B1(n1251), .B2(
        u_input_output_in_buffer[78]), .O(n858) );
  MOAI1S U1720 ( .A1(n1251), .A2(n1274), .B1(n1251), .B2(
        u_input_output_in_buffer[77]), .O(n857) );
  MOAI1S U1721 ( .A1(n1251), .A2(n1275), .B1(n1251), .B2(
        u_input_output_in_buffer[76]), .O(n856) );
  MOAI1S U1722 ( .A1(n1251), .A2(n1254), .B1(n1251), .B2(
        u_input_output_in_buffer[75]), .O(n855) );
  MOAI1S U1723 ( .A1(n1251), .A2(n1255), .B1(n1251), .B2(
        u_input_output_in_buffer[74]), .O(n854) );
  MOAI1S U1724 ( .A1(n1251), .A2(n1277), .B1(n1251), .B2(
        u_input_output_in_buffer[72]), .O(n852) );
  MOAI1S U1725 ( .A1(n1251), .A2(n1279), .B1(n1251), .B2(
        u_input_output_in_buffer[70]), .O(n850) );
  MOAI1S U1726 ( .A1(n1251), .A2(n1280), .B1(n1251), .B2(
        u_input_output_in_buffer[69]), .O(n849) );
  MOAI1S U1727 ( .A1(n1251), .A2(n1281), .B1(n1251), .B2(
        u_input_output_in_buffer[68]), .O(n848) );
  MOAI1S U1728 ( .A1(n1251), .A2(n1282), .B1(n1251), .B2(
        u_input_output_in_buffer[66]), .O(n846) );
  MOAI1S U1729 ( .A1(n1251), .A2(n1258), .B1(n1251), .B2(
        u_input_output_in_buffer[64]), .O(n844) );
  MOAI1S U1730 ( .A1(n1251), .A2(n1283), .B1(n1251), .B2(
        u_input_output_in_buffer[61]), .O(n841) );
  OR2 U1731 ( .I1(u_input_output_in_count[0]), .I2(n1252), .O(n1261) );
  MOAI1S U1732 ( .A1(n1261), .A2(n1262), .B1(n1261), .B2(
        u_input_output_in_buffer[90]), .O(n840) );
  MOAI1S U1733 ( .A1(n1261), .A2(n1253), .B1(n1261), .B2(
        u_input_output_in_buffer[119]), .O(n839) );
  MOAI1S U1734 ( .A1(n1261), .A2(n1263), .B1(n1261), .B2(
        u_input_output_in_buffer[118]), .O(n838) );
  MOAI1S U1735 ( .A1(n1261), .A2(n1264), .B1(n1261), .B2(
        u_input_output_in_buffer[117]), .O(n837) );
  MOAI1S U1736 ( .A1(n1261), .A2(n1265), .B1(n1261), .B2(
        u_input_output_in_buffer[116]), .O(n836) );
  MOAI1S U1737 ( .A1(n1261), .A2(n1266), .B1(n1261), .B2(
        u_input_output_in_buffer[115]), .O(n835) );
  MOAI1S U1738 ( .A1(n1261), .A2(n1267), .B1(n1261), .B2(
        u_input_output_in_buffer[114]), .O(n834) );
  MOAI1S U1739 ( .A1(n1261), .A2(n1268), .B1(n1261), .B2(
        u_input_output_in_buffer[113]), .O(n833) );
  MOAI1S U1740 ( .A1(n1261), .A2(n1269), .B1(n1261), .B2(
        u_input_output_in_buffer[112]), .O(n832) );
  MOAI1S U1741 ( .A1(n1261), .A2(n1270), .B1(n1261), .B2(
        u_input_output_in_buffer[111]), .O(n831) );
  MOAI1S U1742 ( .A1(n1261), .A2(n1271), .B1(n1261), .B2(
        u_input_output_in_buffer[110]), .O(n830) );
  MOAI1S U1743 ( .A1(n1261), .A2(n1272), .B1(n1261), .B2(
        u_input_output_in_buffer[109]), .O(n829) );
  MOAI1S U1744 ( .A1(n1261), .A2(n1273), .B1(n1261), .B2(
        u_input_output_in_buffer[108]), .O(n828) );
  MOAI1S U1745 ( .A1(n1261), .A2(n1274), .B1(n1261), .B2(
        u_input_output_in_buffer[107]), .O(n827) );
  MOAI1S U1746 ( .A1(n1261), .A2(n1275), .B1(n1261), .B2(
        u_input_output_in_buffer[106]), .O(n826) );
  MOAI1S U1747 ( .A1(n1261), .A2(n1254), .B1(n1261), .B2(
        u_input_output_in_buffer[105]), .O(n825) );
  MOAI1S U1748 ( .A1(n1261), .A2(n1255), .B1(n1261), .B2(
        u_input_output_in_buffer[104]), .O(n824) );
  MOAI1S U1749 ( .A1(n1261), .A2(n1276), .B1(n1261), .B2(
        u_input_output_in_buffer[103]), .O(n823) );
  MOAI1S U1750 ( .A1(n1261), .A2(n1277), .B1(n1261), .B2(
        u_input_output_in_buffer[102]), .O(n822) );
  MOAI1S U1751 ( .A1(n1261), .A2(n1278), .B1(n1261), .B2(
        u_input_output_in_buffer[101]), .O(n821) );
  MOAI1S U1752 ( .A1(n1261), .A2(n1279), .B1(n1261), .B2(
        u_input_output_in_buffer[100]), .O(n820) );
  MOAI1S U1753 ( .A1(n1261), .A2(n1280), .B1(n1261), .B2(
        u_input_output_in_buffer[99]), .O(n819) );
  MOAI1S U1754 ( .A1(n1261), .A2(n1281), .B1(n1261), .B2(
        u_input_output_in_buffer[98]), .O(n818) );
  MOAI1S U1755 ( .A1(n1261), .A2(n1256), .B1(n1261), .B2(
        u_input_output_in_buffer[97]), .O(n817) );
  MOAI1S U1756 ( .A1(n1261), .A2(n1282), .B1(n1261), .B2(
        u_input_output_in_buffer[96]), .O(n816) );
  MOAI1S U1757 ( .A1(n1261), .A2(n1257), .B1(n1261), .B2(
        u_input_output_in_buffer[95]), .O(n815) );
  MOAI1S U1758 ( .A1(n1261), .A2(n1258), .B1(n1261), .B2(
        u_input_output_in_buffer[94]), .O(n814) );
  MOAI1S U1759 ( .A1(n1261), .A2(n1259), .B1(n1261), .B2(
        u_input_output_in_buffer[93]), .O(n813) );
  MOAI1S U1760 ( .A1(n1261), .A2(n1260), .B1(n1261), .B2(
        u_input_output_in_buffer[92]), .O(n812) );
  MOAI1S U1761 ( .A1(n1261), .A2(n1283), .B1(n1261), .B2(
        u_input_output_in_buffer[91]), .O(n811) );
  MOAI1S U1762 ( .A1(n1284), .A2(n1262), .B1(n1284), .B2(
        u_input_output_in_buffer[120]), .O(n810) );
  MOAI1S U1763 ( .A1(n1284), .A2(n1263), .B1(n1284), .B2(
        u_input_output_in_buffer[148]), .O(n808) );
  MOAI1S U1764 ( .A1(n1284), .A2(n1264), .B1(n1284), .B2(
        u_input_output_in_buffer[147]), .O(n807) );
  MOAI1S U1765 ( .A1(n1284), .A2(n1265), .B1(n1284), .B2(
        u_input_output_in_buffer[146]), .O(n806) );
  MOAI1S U1766 ( .A1(n1284), .A2(n1266), .B1(n1284), .B2(
        u_input_output_in_buffer[145]), .O(n805) );
  MOAI1S U1767 ( .A1(n1284), .A2(n1267), .B1(n1284), .B2(
        u_input_output_in_buffer[144]), .O(n804) );
  MOAI1S U1768 ( .A1(n1284), .A2(n1268), .B1(n1284), .B2(
        u_input_output_in_buffer[143]), .O(n803) );
  MOAI1S U1769 ( .A1(n1284), .A2(n1269), .B1(n1284), .B2(
        u_input_output_in_buffer[142]), .O(n802) );
  MOAI1S U1770 ( .A1(n1284), .A2(n1270), .B1(n1284), .B2(
        u_input_output_in_buffer[141]), .O(n801) );
  MOAI1S U1771 ( .A1(n1284), .A2(n1271), .B1(n1284), .B2(
        u_input_output_in_buffer[140]), .O(n800) );
  MOAI1S U1772 ( .A1(n1284), .A2(n1272), .B1(n1284), .B2(
        u_input_output_in_buffer[139]), .O(n799) );
  MOAI1S U1773 ( .A1(n1284), .A2(n1273), .B1(n1284), .B2(
        u_input_output_in_buffer[138]), .O(n798) );
  MOAI1S U1774 ( .A1(n1284), .A2(n1274), .B1(n1284), .B2(
        u_input_output_in_buffer[137]), .O(n797) );
  MOAI1S U1775 ( .A1(n1284), .A2(n1275), .B1(n1284), .B2(
        u_input_output_in_buffer[136]), .O(n796) );
  MOAI1S U1776 ( .A1(n1284), .A2(n1276), .B1(n1284), .B2(
        u_input_output_in_buffer[133]), .O(n793) );
  MOAI1S U1777 ( .A1(n1284), .A2(n1277), .B1(n1284), .B2(
        u_input_output_in_buffer[132]), .O(n792) );
  MOAI1S U1778 ( .A1(n1284), .A2(n1278), .B1(n1284), .B2(
        u_input_output_in_buffer[131]), .O(n791) );
  MOAI1S U1779 ( .A1(n1284), .A2(n1279), .B1(n1284), .B2(
        u_input_output_in_buffer[130]), .O(n790) );
  MOAI1S U1780 ( .A1(n1284), .A2(n1280), .B1(n1284), .B2(
        u_input_output_in_buffer[129]), .O(n789) );
  MOAI1S U1781 ( .A1(n1284), .A2(n1281), .B1(n1284), .B2(
        u_input_output_in_buffer[128]), .O(n788) );
  MOAI1S U1782 ( .A1(n1284), .A2(n1282), .B1(n1284), .B2(
        u_input_output_in_buffer[126]), .O(n786) );
  MOAI1S U1783 ( .A1(n1284), .A2(n1283), .B1(n1284), .B2(
        u_input_output_in_buffer[121]), .O(n781) );
  ND3S U1784 ( .I1(n1289), .I2(u_input_output_out_count[1]), .I3(n1293), .O(
        n1291) );
  ND2S U1785 ( .I1(n1289), .I2(n1293), .O(n1285) );
  NR3 U1786 ( .I1(n1287), .I2(n1286), .I3(n1285), .O(n1362) );
  BUF1 U1787 ( .I(n1362), .O(n1417) );
  AOI22S U1788 ( .A1(u_input_output_in_buffer[0]), .A2(n1417), .B1(
        data_clk1[0]), .B2(n1412), .O(n1296) );
  ND3S U1789 ( .I1(n1289), .I2(n1288), .I3(n1293), .O(n1290) );
  AOI22S U1790 ( .A1(n1399), .A2(u_input_output_in_buffer[120]), .B1(n1373), 
        .B2(u_input_output_in_buffer[30]), .O(n1295) );
  AOI22S U1791 ( .A1(n1368), .A2(u_input_output_in_buffer[60]), .B1(n1378), 
        .B2(in_kernel[0]), .O(n1294) );
  ND3S U1792 ( .I1(n1296), .I2(n1295), .I3(n1294), .O(n1297) );
  AO12S U1793 ( .B1(n1367), .B2(u_input_output_in_buffer[90]), .A1(n1297), .O(
        n780) );
  AOI22S U1794 ( .A1(u_input_output_in_buffer[1]), .A2(n1417), .B1(
        data_clk1[1]), .B2(n1412), .O(n1300) );
  AOI22S U1795 ( .A1(n1399), .A2(u_input_output_in_buffer[121]), .B1(n1373), 
        .B2(u_input_output_in_buffer[31]), .O(n1299) );
  AOI22S U1796 ( .A1(n1368), .A2(u_input_output_in_buffer[61]), .B1(n1378), 
        .B2(in_kernel[1]), .O(n1298) );
  ND3S U1797 ( .I1(n1300), .I2(n1299), .I3(n1298), .O(n1301) );
  AO12S U1798 ( .B1(n1367), .B2(u_input_output_in_buffer[91]), .A1(n1301), .O(
        n779) );
  AOI22S U1799 ( .A1(u_input_output_in_buffer[2]), .A2(n1362), .B1(
        data_clk1[2]), .B2(n1412), .O(n1304) );
  AOI22S U1800 ( .A1(n1399), .A2(u_input_output_in_buffer[122]), .B1(n1373), 
        .B2(u_input_output_in_buffer[32]), .O(n1303) );
  AOI22S U1801 ( .A1(n1368), .A2(u_input_output_in_buffer[62]), .B1(n1378), 
        .B2(in_kernel[2]), .O(n1302) );
  ND3S U1802 ( .I1(n1304), .I2(n1303), .I3(n1302), .O(n1305) );
  AO12S U1803 ( .B1(n1367), .B2(u_input_output_in_buffer[92]), .A1(n1305), .O(
        n778) );
  AOI22S U1804 ( .A1(u_input_output_in_buffer[3]), .A2(n1417), .B1(
        data_clk1[3]), .B2(n1412), .O(n1308) );
  AOI22S U1805 ( .A1(n1399), .A2(u_input_output_in_buffer[123]), .B1(n1373), 
        .B2(u_input_output_in_buffer[33]), .O(n1307) );
  AOI22S U1806 ( .A1(n1368), .A2(u_input_output_in_buffer[63]), .B1(n1378), 
        .B2(in_kernel[3]), .O(n1306) );
  ND3S U1807 ( .I1(n1308), .I2(n1307), .I3(n1306), .O(n1309) );
  AO12S U1808 ( .B1(n1367), .B2(u_input_output_in_buffer[93]), .A1(n1309), .O(
        n777) );
  AOI22S U1809 ( .A1(u_input_output_in_buffer[4]), .A2(n1362), .B1(
        data_clk1[4]), .B2(n1412), .O(n1312) );
  AOI22S U1810 ( .A1(n1399), .A2(u_input_output_in_buffer[124]), .B1(n1373), 
        .B2(u_input_output_in_buffer[34]), .O(n1311) );
  AOI22S U1811 ( .A1(n1368), .A2(u_input_output_in_buffer[64]), .B1(n1378), 
        .B2(in_kernel[4]), .O(n1310) );
  ND3S U1812 ( .I1(n1312), .I2(n1311), .I3(n1310), .O(n1313) );
  AO12S U1813 ( .B1(n1367), .B2(u_input_output_in_buffer[94]), .A1(n1313), .O(
        n776) );
  AOI22S U1814 ( .A1(u_input_output_in_buffer[5]), .A2(n1417), .B1(
        data_clk1[5]), .B2(n1412), .O(n1316) );
  AOI22S U1815 ( .A1(n1399), .A2(u_input_output_in_buffer[125]), .B1(n1373), 
        .B2(u_input_output_in_buffer[35]), .O(n1315) );
  AOI22S U1816 ( .A1(n1368), .A2(u_input_output_in_buffer[65]), .B1(n1378), 
        .B2(in_kernel[5]), .O(n1314) );
  ND3S U1817 ( .I1(n1316), .I2(n1315), .I3(n1314), .O(n1317) );
  AO12S U1818 ( .B1(n1367), .B2(u_input_output_in_buffer[95]), .A1(n1317), .O(
        n775) );
  AOI22S U1819 ( .A1(u_input_output_in_buffer[6]), .A2(n1362), .B1(
        data_clk1[6]), .B2(n1412), .O(n1320) );
  AOI22S U1820 ( .A1(n1399), .A2(u_input_output_in_buffer[126]), .B1(n1373), 
        .B2(u_input_output_in_buffer[36]), .O(n1319) );
  AOI22S U1821 ( .A1(n1368), .A2(u_input_output_in_buffer[66]), .B1(n1378), 
        .B2(in_kernel[6]), .O(n1318) );
  ND3S U1822 ( .I1(n1320), .I2(n1319), .I3(n1318), .O(n1321) );
  AO12S U1823 ( .B1(n1367), .B2(u_input_output_in_buffer[96]), .A1(n1321), .O(
        n774) );
  AOI22S U1824 ( .A1(u_input_output_in_buffer[7]), .A2(n1417), .B1(
        data_clk1[7]), .B2(n1412), .O(n1324) );
  AOI22S U1825 ( .A1(n1399), .A2(u_input_output_in_buffer[127]), .B1(n1373), 
        .B2(u_input_output_in_buffer[37]), .O(n1323) );
  AOI22S U1826 ( .A1(n1368), .A2(u_input_output_in_buffer[67]), .B1(n1378), 
        .B2(in_kernel[7]), .O(n1322) );
  ND3S U1827 ( .I1(n1324), .I2(n1323), .I3(n1322), .O(n1325) );
  AO12S U1828 ( .B1(n1367), .B2(u_input_output_in_buffer[97]), .A1(n1325), .O(
        n773) );
  AOI22S U1829 ( .A1(u_input_output_in_buffer[8]), .A2(n1417), .B1(
        data_clk1[8]), .B2(n1412), .O(n1328) );
  AOI22S U1830 ( .A1(n1399), .A2(u_input_output_in_buffer[128]), .B1(n1373), 
        .B2(u_input_output_in_buffer[38]), .O(n1327) );
  AOI22S U1831 ( .A1(n1368), .A2(u_input_output_in_buffer[68]), .B1(n1378), 
        .B2(in_kernel[8]), .O(n1326) );
  ND3S U1832 ( .I1(n1328), .I2(n1327), .I3(n1326), .O(n1329) );
  AO12S U1833 ( .B1(n1367), .B2(u_input_output_in_buffer[98]), .A1(n1329), .O(
        n772) );
  AOI22S U1834 ( .A1(u_input_output_in_buffer[9]), .A2(n1417), .B1(
        data_clk1[9]), .B2(n1412), .O(n1332) );
  AOI22S U1835 ( .A1(n1399), .A2(u_input_output_in_buffer[129]), .B1(n1373), 
        .B2(u_input_output_in_buffer[39]), .O(n1331) );
  AOI22S U1836 ( .A1(n1368), .A2(u_input_output_in_buffer[69]), .B1(n1378), 
        .B2(in_kernel[9]), .O(n1330) );
  ND3S U1837 ( .I1(n1332), .I2(n1331), .I3(n1330), .O(n1333) );
  AO12S U1838 ( .B1(n1367), .B2(u_input_output_in_buffer[99]), .A1(n1333), .O(
        n771) );
  AOI22S U1839 ( .A1(u_input_output_in_buffer[10]), .A2(n1417), .B1(
        data_clk1[10]), .B2(n1412), .O(n1336) );
  AOI22S U1840 ( .A1(n1399), .A2(u_input_output_in_buffer[130]), .B1(n1373), 
        .B2(u_input_output_in_buffer[40]), .O(n1335) );
  AOI22S U1841 ( .A1(n1368), .A2(u_input_output_in_buffer[70]), .B1(n1378), 
        .B2(in_kernel[10]), .O(n1334) );
  ND3S U1842 ( .I1(n1336), .I2(n1335), .I3(n1334), .O(n1337) );
  AO12S U1843 ( .B1(n1367), .B2(u_input_output_in_buffer[100]), .A1(n1337), 
        .O(n770) );
  AOI22S U1844 ( .A1(u_input_output_in_buffer[11]), .A2(n1417), .B1(
        data_clk1[11]), .B2(n1412), .O(n1340) );
  AOI22S U1845 ( .A1(n1399), .A2(u_input_output_in_buffer[131]), .B1(n1373), 
        .B2(u_input_output_in_buffer[41]), .O(n1339) );
  AOI22S U1846 ( .A1(n1368), .A2(u_input_output_in_buffer[71]), .B1(n1378), 
        .B2(in_kernel[11]), .O(n1338) );
  ND3S U1847 ( .I1(n1340), .I2(n1339), .I3(n1338), .O(n1341) );
  AO12S U1848 ( .B1(n1367), .B2(u_input_output_in_buffer[101]), .A1(n1341), 
        .O(n769) );
  AOI22S U1849 ( .A1(u_input_output_in_buffer[12]), .A2(n1417), .B1(
        data_clk1[12]), .B2(n1412), .O(n1344) );
  AOI22S U1850 ( .A1(n1399), .A2(u_input_output_in_buffer[132]), .B1(n1373), 
        .B2(u_input_output_in_buffer[42]), .O(n1343) );
  AOI22S U1851 ( .A1(n1368), .A2(u_input_output_in_buffer[72]), .B1(n1378), 
        .B2(in_row[0]), .O(n1342) );
  ND3S U1852 ( .I1(n1344), .I2(n1343), .I3(n1342), .O(n1345) );
  AO12S U1853 ( .B1(n1367), .B2(u_input_output_in_buffer[102]), .A1(n1345), 
        .O(n768) );
  AOI22S U1854 ( .A1(u_input_output_in_buffer[13]), .A2(n1362), .B1(
        data_clk1[13]), .B2(n1412), .O(n1348) );
  AOI22S U1855 ( .A1(n1399), .A2(u_input_output_in_buffer[133]), .B1(n1373), 
        .B2(u_input_output_in_buffer[43]), .O(n1347) );
  AOI22S U1856 ( .A1(n1368), .A2(u_input_output_in_buffer[73]), .B1(n1378), 
        .B2(in_row[1]), .O(n1346) );
  ND3S U1857 ( .I1(n1348), .I2(n1347), .I3(n1346), .O(n1349) );
  AO12S U1858 ( .B1(n1367), .B2(u_input_output_in_buffer[103]), .A1(n1349), 
        .O(n767) );
  AOI22S U1859 ( .A1(u_input_output_in_buffer[14]), .A2(n1362), .B1(
        data_clk1[14]), .B2(n1412), .O(n1352) );
  AOI22S U1860 ( .A1(n1399), .A2(u_input_output_in_buffer[134]), .B1(n1373), 
        .B2(u_input_output_in_buffer[44]), .O(n1351) );
  AOI22S U1861 ( .A1(n1368), .A2(u_input_output_in_buffer[74]), .B1(n1378), 
        .B2(in_row[2]), .O(n1350) );
  ND3S U1862 ( .I1(n1352), .I2(n1351), .I3(n1350), .O(n1353) );
  AO12S U1863 ( .B1(n1367), .B2(u_input_output_in_buffer[104]), .A1(n1353), 
        .O(n766) );
  AOI22S U1864 ( .A1(u_input_output_in_buffer[15]), .A2(n1362), .B1(
        data_clk1[15]), .B2(n1412), .O(n1356) );
  AOI22S U1865 ( .A1(n1399), .A2(u_input_output_in_buffer[135]), .B1(n1373), 
        .B2(u_input_output_in_buffer[45]), .O(n1355) );
  AOI22S U1866 ( .A1(n1368), .A2(u_input_output_in_buffer[75]), .B1(n1378), 
        .B2(in_row[3]), .O(n1354) );
  ND3S U1867 ( .I1(n1356), .I2(n1355), .I3(n1354), .O(n1357) );
  AO12S U1868 ( .B1(n1367), .B2(u_input_output_in_buffer[105]), .A1(n1357), 
        .O(n765) );
  AOI22S U1869 ( .A1(u_input_output_in_buffer[16]), .A2(n1362), .B1(
        data_clk1[16]), .B2(n1412), .O(n1360) );
  AOI22S U1870 ( .A1(n1399), .A2(u_input_output_in_buffer[136]), .B1(n1373), 
        .B2(u_input_output_in_buffer[46]), .O(n1359) );
  AOI22S U1871 ( .A1(n1368), .A2(u_input_output_in_buffer[76]), .B1(n1378), 
        .B2(in_row[4]), .O(n1358) );
  ND3S U1872 ( .I1(n1360), .I2(n1359), .I3(n1358), .O(n1361) );
  AO12S U1873 ( .B1(n1367), .B2(u_input_output_in_buffer[106]), .A1(n1361), 
        .O(n764) );
  AOI22S U1874 ( .A1(u_input_output_in_buffer[17]), .A2(n1362), .B1(
        data_clk1[17]), .B2(n1412), .O(n1365) );
  AOI22S U1875 ( .A1(n1399), .A2(u_input_output_in_buffer[137]), .B1(n1373), 
        .B2(u_input_output_in_buffer[47]), .O(n1364) );
  AOI22S U1876 ( .A1(n1368), .A2(u_input_output_in_buffer[77]), .B1(n1378), 
        .B2(in_row[5]), .O(n1363) );
  ND3S U1877 ( .I1(n1365), .I2(n1364), .I3(n1363), .O(n1366) );
  AO12S U1878 ( .B1(n1367), .B2(u_input_output_in_buffer[107]), .A1(n1366), 
        .O(n763) );
  AOI22S U1879 ( .A1(u_input_output_in_buffer[18]), .A2(n1417), .B1(
        data_clk1[18]), .B2(n1412), .O(n1371) );
  AOI22S U1880 ( .A1(n1399), .A2(u_input_output_in_buffer[138]), .B1(n1373), 
        .B2(u_input_output_in_buffer[48]), .O(n1370) );
  AOI22S U1881 ( .A1(n1368), .A2(u_input_output_in_buffer[78]), .B1(n1378), 
        .B2(in_row[6]), .O(n1369) );
  ND3S U1882 ( .I1(n1371), .I2(n1370), .I3(n1369), .O(n1372) );
  AO12S U1883 ( .B1(n1367), .B2(u_input_output_in_buffer[108]), .A1(n1372), 
        .O(n762) );
  AOI22S U1884 ( .A1(u_input_output_in_buffer[19]), .A2(n1417), .B1(
        data_clk1[19]), .B2(n1412), .O(n1376) );
  AOI22S U1885 ( .A1(n1399), .A2(u_input_output_in_buffer[139]), .B1(n1373), 
        .B2(u_input_output_in_buffer[49]), .O(n1375) );
  AOI22S U1886 ( .A1(n1368), .A2(u_input_output_in_buffer[79]), .B1(n1378), 
        .B2(in_row[7]), .O(n1374) );
  ND3S U1887 ( .I1(n1376), .I2(n1375), .I3(n1374), .O(n1377) );
  AO12S U1888 ( .B1(n1367), .B2(u_input_output_in_buffer[109]), .A1(n1377), 
        .O(n761) );
  AOI22S U1889 ( .A1(u_input_output_in_buffer[20]), .A2(n1417), .B1(
        data_clk1[20]), .B2(n1412), .O(n1381) );
  AOI22S U1890 ( .A1(n1399), .A2(u_input_output_in_buffer[140]), .B1(n1373), 
        .B2(u_input_output_in_buffer[50]), .O(n1380) );
  AOI22S U1891 ( .A1(n1368), .A2(u_input_output_in_buffer[80]), .B1(n1378), 
        .B2(in_row[8]), .O(n1379) );
  ND3S U1892 ( .I1(n1381), .I2(n1380), .I3(n1379), .O(n1382) );
  AO12S U1893 ( .B1(n1367), .B2(u_input_output_in_buffer[110]), .A1(n1382), 
        .O(n760) );
  AOI22S U1894 ( .A1(u_input_output_in_buffer[21]), .A2(n1417), .B1(
        data_clk1[21]), .B2(n1412), .O(n1385) );
  AOI22S U1895 ( .A1(n1399), .A2(u_input_output_in_buffer[141]), .B1(n1373), 
        .B2(u_input_output_in_buffer[51]), .O(n1384) );
  AOI22S U1896 ( .A1(n1368), .A2(u_input_output_in_buffer[81]), .B1(n1378), 
        .B2(in_row[9]), .O(n1383) );
  AO12S U1897 ( .B1(n1367), .B2(u_input_output_in_buffer[111]), .A1(n1386), 
        .O(n759) );
  AOI22S U1898 ( .A1(u_input_output_in_buffer[22]), .A2(n1417), .B1(
        data_clk1[22]), .B2(n1412), .O(n1389) );
  AOI22S U1899 ( .A1(n1399), .A2(u_input_output_in_buffer[142]), .B1(n1373), 
        .B2(u_input_output_in_buffer[52]), .O(n1388) );
  AOI22S U1900 ( .A1(n1368), .A2(u_input_output_in_buffer[82]), .B1(n1378), 
        .B2(in_row[10]), .O(n1387) );
  ND3S U1901 ( .I1(n1389), .I2(n1388), .I3(n1387), .O(n1390) );
  AO12S U1902 ( .B1(n1367), .B2(u_input_output_in_buffer[112]), .A1(n1390), 
        .O(n758) );
  AOI22S U1903 ( .A1(u_input_output_in_buffer[23]), .A2(n1417), .B1(
        data_clk1[23]), .B2(n1412), .O(n1393) );
  AOI22S U1904 ( .A1(n1399), .A2(u_input_output_in_buffer[143]), .B1(n1373), 
        .B2(u_input_output_in_buffer[53]), .O(n1392) );
  AOI22S U1905 ( .A1(n1368), .A2(u_input_output_in_buffer[83]), .B1(n1378), 
        .B2(in_row[11]), .O(n1391) );
  ND3S U1906 ( .I1(n1393), .I2(n1392), .I3(n1391), .O(n1394) );
  AO12S U1907 ( .B1(n1367), .B2(u_input_output_in_buffer[113]), .A1(n1394), 
        .O(n757) );
  AOI22S U1908 ( .A1(u_input_output_in_buffer[24]), .A2(n1417), .B1(
        data_clk1[24]), .B2(n1412), .O(n1397) );
  AOI22S U1909 ( .A1(n1399), .A2(u_input_output_in_buffer[144]), .B1(n1373), 
        .B2(u_input_output_in_buffer[54]), .O(n1396) );
  AOI22S U1910 ( .A1(n1368), .A2(u_input_output_in_buffer[84]), .B1(n1378), 
        .B2(in_row[12]), .O(n1395) );
  ND3S U1911 ( .I1(n1397), .I2(n1396), .I3(n1395), .O(n1398) );
  AO12S U1912 ( .B1(n1367), .B2(u_input_output_in_buffer[114]), .A1(n1398), 
        .O(n756) );
  AOI22S U1913 ( .A1(u_input_output_in_buffer[25]), .A2(n1417), .B1(
        data_clk1[25]), .B2(n1412), .O(n1402) );
  AOI22S U1914 ( .A1(n1399), .A2(u_input_output_in_buffer[145]), .B1(n1373), 
        .B2(u_input_output_in_buffer[55]), .O(n1401) );
  AOI22S U1915 ( .A1(n1368), .A2(u_input_output_in_buffer[85]), .B1(n1378), 
        .B2(in_row[13]), .O(n1400) );
  ND3S U1916 ( .I1(n1402), .I2(n1401), .I3(n1400), .O(n1403) );
  AO12S U1917 ( .B1(n1367), .B2(u_input_output_in_buffer[115]), .A1(n1403), 
        .O(n755) );
  AOI22S U1918 ( .A1(u_input_output_in_buffer[26]), .A2(n1417), .B1(
        data_clk1[26]), .B2(n1412), .O(n1406) );
  AOI22S U1919 ( .A1(n1399), .A2(u_input_output_in_buffer[146]), .B1(n1373), 
        .B2(u_input_output_in_buffer[56]), .O(n1405) );
  AOI22S U1920 ( .A1(n1368), .A2(u_input_output_in_buffer[86]), .B1(n1378), 
        .B2(in_row[14]), .O(n1404) );
  ND3S U1921 ( .I1(n1406), .I2(n1405), .I3(n1404), .O(n1407) );
  AO12S U1922 ( .B1(n1367), .B2(u_input_output_in_buffer[116]), .A1(n1407), 
        .O(n754) );
  AOI22S U1923 ( .A1(u_input_output_in_buffer[27]), .A2(n1417), .B1(
        data_clk1[27]), .B2(n1412), .O(n1410) );
  AOI22S U1924 ( .A1(n1399), .A2(u_input_output_in_buffer[147]), .B1(n1373), 
        .B2(u_input_output_in_buffer[57]), .O(n1409) );
  AOI22S U1925 ( .A1(n1368), .A2(u_input_output_in_buffer[87]), .B1(n1378), 
        .B2(in_row[15]), .O(n1408) );
  ND3S U1926 ( .I1(n1410), .I2(n1409), .I3(n1408), .O(n1411) );
  AO12S U1927 ( .B1(n1367), .B2(u_input_output_in_buffer[117]), .A1(n1411), 
        .O(n753) );
  AOI22S U1928 ( .A1(u_input_output_in_buffer[28]), .A2(n1417), .B1(
        data_clk1[28]), .B2(n1412), .O(n1415) );
  AOI22S U1929 ( .A1(n1399), .A2(u_input_output_in_buffer[148]), .B1(n1373), 
        .B2(u_input_output_in_buffer[58]), .O(n1414) );
  AOI22S U1930 ( .A1(n1368), .A2(u_input_output_in_buffer[88]), .B1(n1378), 
        .B2(in_row[16]), .O(n1413) );
  ND3S U1931 ( .I1(n1415), .I2(n1414), .I3(n1413), .O(n1416) );
  AO12S U1932 ( .B1(n1367), .B2(u_input_output_in_buffer[118]), .A1(n1416), 
        .O(n752) );
  AOI22S U1933 ( .A1(u_input_output_in_buffer[29]), .A2(n1417), .B1(
        data_clk1[29]), .B2(n1412), .O(n1420) );
  AOI22S U1934 ( .A1(n1399), .A2(u_input_output_in_buffer[149]), .B1(n1373), 
        .B2(u_input_output_in_buffer[59]), .O(n1419) );
  AOI22S U1935 ( .A1(n1368), .A2(u_input_output_in_buffer[89]), .B1(n1378), 
        .B2(in_row[17]), .O(n1418) );
  ND3S U1936 ( .I1(n1420), .I2(n1419), .I3(n1418), .O(n1421) );
  AO12S U1937 ( .B1(n1367), .B2(u_input_output_in_buffer[119]), .A1(n1421), 
        .O(n751) );
  AOI22S U1938 ( .A1(u_Conv_out_count[6]), .A2(n1424), .B1(n1423), .B2(n1422), 
        .O(n750) );
  MOAI1S U1939 ( .A1(u_Conv_out_count[0]), .A2(n943), .B1(u_Conv_out_count[0]), 
        .B2(n1438), .O(n749) );
  ND3S U1940 ( .I1(n1428), .I2(u_Conv_out_count[1]), .I3(n1425), .O(n1429) );
  MOAI1S U1941 ( .A1(n1426), .A2(n1438), .B1(n1429), .B2(u_Conv_out_count[1]), 
        .O(n748) );
  MOAI1S U1942 ( .A1(n1431), .A2(n1430), .B1(u_Conv_out_count[2]), .B2(n1429), 
        .O(n747) );
  MOAI1S U1943 ( .A1(n1441), .A2(n1439), .B1(u_Conv_ifmap_x[1]), .B2(n1443), 
        .O(n742) );
  OAI12HS U1944 ( .B1(n1442), .B2(n1441), .A1(n1440), .O(n741) );
  AOI13HS U1945 ( .B1(n1446), .B2(n1445), .B3(n1444), .A1(n1443), .O(n1449) );
  ND3S U1946 ( .I1(n1446), .I2(u_Conv_ifmap_x[1]), .I3(u_Conv_ifmap_x[0]), .O(
        n1448) );
  AOI22S U1947 ( .A1(u_Conv_ifmap_x[2]), .A2(n1449), .B1(n1448), .B2(n1447), 
        .O(n740) );
  NR2 U1948 ( .I1(n1451), .I2(n1450), .O(n1455) );
  OAI22S U1949 ( .A1(n1455), .A2(n1454), .B1(n1453), .B2(n1458), .O(n739) );
  AOI22S U1950 ( .A1(u_Conv_ifmap_y[0]), .A2(n1458), .B1(n1457), .B2(n1456), 
        .O(n738) );
  ND2S U1951 ( .I1(n1463), .I2(n1464), .O(n1461) );
  NR2 U1952 ( .I1(u_Conv_in_count[0]), .I2(n1464), .O(n1460) );
  MOAI1S U1953 ( .A1(n1462), .A2(n1461), .B1(n1460), .B2(n1459), .O(n736) );
  MOAI1S U1954 ( .A1(n1464), .A2(u_Conv_in_count[0]), .B1(n1464), .B2(n1463), 
        .O(n1466) );
  OAI12HS U1955 ( .B1(n1466), .B2(n1465), .A1(u_Conv_in_count[2]), .O(n1467)
         );
  ND2S U1956 ( .I1(n1467), .I2(n1498), .O(n734) );
  MOAI1S U1957 ( .A1(n1503), .A2(n1468), .B1(n1503), .B2(u_Conv_kernel_reg[63]), .O(n731) );
  MOAI1S U1958 ( .A1(n1497), .A2(n1469), .B1(n1497), .B2(u_Conv_kernel_reg[67]), .O(n726) );
  MOAI1S U1959 ( .A1(n1498), .A2(n1469), .B1(n1498), .B2(u_Conv_kernel_reg[61]), .O(n724) );
  MOAI1S U1960 ( .A1(n1499), .A2(n1469), .B1(n1499), .B2(u_Conv_kernel_reg[58]), .O(n723) );
  MOAI1S U1961 ( .A1(n1501), .A2(n1469), .B1(n1501), .B2(u_Conv_kernel_reg[55]), .O(n722) );
  MOAI1S U1962 ( .A1(n1503), .A2(n1470), .B1(n1503), .B2(u_Conv_kernel_reg[65]), .O(n719) );
  MOAI1S U1963 ( .A1(n1498), .A2(n1470), .B1(n1498), .B2(u_Conv_kernel_reg[62]), .O(n718) );
  MOAI1S U1964 ( .A1(n1503), .A2(n1471), .B1(n1503), .B2(u_Conv_kernel_reg[45]), .O(n713) );
  MOAI1S U1965 ( .A1(n1498), .A2(n1471), .B1(n1498), .B2(u_Conv_kernel_reg[42]), .O(n712) );
  MOAI1S U1966 ( .A1(n1503), .A2(n1472), .B1(n1503), .B2(u_Conv_kernel_reg[46]), .O(n707) );
  MOAI1S U1967 ( .A1(n1498), .A2(n1472), .B1(n1498), .B2(u_Conv_kernel_reg[43]), .O(n706) );
  MOAI1S U1968 ( .A1(n1503), .A2(n1473), .B1(n1503), .B2(u_Conv_kernel_reg[47]), .O(n701) );
  MOAI1S U1969 ( .A1(n1498), .A2(n1473), .B1(n1498), .B2(u_Conv_kernel_reg[44]), .O(n700) );
  MOAI1S U1970 ( .A1(n1503), .A2(n1474), .B1(n1503), .B2(u_Conv_kernel_reg[27]), .O(n695) );
  MOAI1S U1971 ( .A1(n1498), .A2(n1474), .B1(n1498), .B2(u_Conv_kernel_reg[24]), .O(n694) );
  MOAI1S U1972 ( .A1(n1503), .A2(n1475), .B1(n1503), .B2(u_Conv_kernel_reg[28]), .O(n689) );
  MOAI1S U1973 ( .A1(n1498), .A2(n1475), .B1(n1498), .B2(u_Conv_kernel_reg[25]), .O(n688) );
  MOAI1S U1974 ( .A1(n1492), .A2(n1476), .B1(n1492), .B2(u_Conv_kernel_reg[35]), .O(n685) );
  MOAI1S U1975 ( .A1(n1497), .A2(n1476), .B1(n1497), .B2(u_Conv_kernel_reg[32]), .O(n684) );
  MOAI1S U1976 ( .A1(n1503), .A2(n1476), .B1(n1503), .B2(u_Conv_kernel_reg[29]), .O(n683) );
  MOAI1S U1977 ( .A1(n1499), .A2(n1476), .B1(n1499), .B2(u_Conv_kernel_reg[23]), .O(n681) );
  MOAI1S U1978 ( .A1(n1501), .A2(n1476), .B1(n1501), .B2(u_Conv_kernel_reg[20]), .O(n680) );
  MOAI1S U1979 ( .A1(n1492), .A2(n1477), .B1(n1492), .B2(u_Conv_kernel_reg[15]), .O(n679) );
  MOAI1S U1980 ( .A1(n1497), .A2(n1477), .B1(n1497), .B2(u_Conv_kernel_reg[12]), .O(n678) );
  MOAI1S U1981 ( .A1(n1503), .A2(n1477), .B1(n1503), .B2(u_Conv_kernel_reg[9]), 
        .O(n677) );
  MOAI1S U1982 ( .A1(n1498), .A2(n1477), .B1(n1498), .B2(u_Conv_kernel_reg[6]), 
        .O(n676) );
  MOAI1S U1983 ( .A1(n1499), .A2(n1477), .B1(n1499), .B2(u_Conv_kernel_reg[3]), 
        .O(n675) );
  MOAI1S U1984 ( .A1(n1501), .A2(n1477), .B1(n1501), .B2(u_Conv_kernel_reg[0]), 
        .O(n674) );
  MOAI1S U1985 ( .A1(n1492), .A2(n1478), .B1(n1492), .B2(u_Conv_kernel_reg[16]), .O(n673) );
  MOAI1S U1986 ( .A1(n1497), .A2(n1478), .B1(n1497), .B2(u_Conv_kernel_reg[13]), .O(n672) );
  MOAI1S U1987 ( .A1(n1503), .A2(n1478), .B1(n1503), .B2(u_Conv_kernel_reg[10]), .O(n671) );
  MOAI1S U1988 ( .A1(n1498), .A2(n1478), .B1(n1498), .B2(u_Conv_kernel_reg[7]), 
        .O(n670) );
  MOAI1S U1989 ( .A1(n1499), .A2(n1478), .B1(n1499), .B2(u_Conv_kernel_reg[4]), 
        .O(n669) );
  MOAI1S U1990 ( .A1(n1501), .A2(n1478), .B1(n1501), .B2(u_Conv_kernel_reg[1]), 
        .O(n668) );
  MOAI1S U1991 ( .A1(n1492), .A2(n1479), .B1(n1492), .B2(u_Conv_kernel_reg[17]), .O(n667) );
  MOAI1S U1992 ( .A1(n1497), .A2(n1479), .B1(n1497), .B2(u_Conv_kernel_reg[14]), .O(n666) );
  MOAI1S U1993 ( .A1(n1503), .A2(n1479), .B1(n1503), .B2(u_Conv_kernel_reg[11]), .O(n665) );
  MOAI1S U1994 ( .A1(n1499), .A2(n1479), .B1(n1499), .B2(u_Conv_kernel_reg[5]), 
        .O(n663) );
  MOAI1S U1995 ( .A1(n1501), .A2(n1479), .B1(n1501), .B2(u_Conv_kernel_reg[2]), 
        .O(n662) );
  MOAI1S U1996 ( .A1(n1492), .A2(n1480), .B1(n1492), .B2(u_Conv_ifmap_reg[105]), .O(n661) );
  MOAI1S U1997 ( .A1(n1497), .A2(n1480), .B1(n1497), .B2(u_Conv_ifmap_reg[102]), .O(n660) );
  MOAI1S U1998 ( .A1(n1499), .A2(n1480), .B1(n1499), .B2(u_Conv_ifmap_reg[93]), 
        .O(n657) );
  MOAI1S U1999 ( .A1(n1501), .A2(n1480), .B1(n1501), .B2(u_Conv_ifmap_reg[90]), 
        .O(n656) );
  MOAI1S U2000 ( .A1(n1492), .A2(n1481), .B1(n1492), .B2(u_Conv_ifmap_reg[106]), .O(n655) );
  MOAI1S U2001 ( .A1(n1497), .A2(n1481), .B1(n1497), .B2(u_Conv_ifmap_reg[103]), .O(n654) );
  MOAI1S U2002 ( .A1(n1499), .A2(n1481), .B1(n1499), .B2(u_Conv_ifmap_reg[94]), 
        .O(n651) );
  MOAI1S U2003 ( .A1(n1501), .A2(n1481), .B1(n1501), .B2(u_Conv_ifmap_reg[91]), 
        .O(n650) );
  MOAI1S U2004 ( .A1(n1492), .A2(n1482), .B1(n1492), .B2(u_Conv_ifmap_reg[107]), .O(n649) );
  MOAI1S U2005 ( .A1(n1497), .A2(n1482), .B1(n1497), .B2(u_Conv_ifmap_reg[104]), .O(n648) );
  MOAI1S U2006 ( .A1(n1499), .A2(n1482), .B1(n1499), .B2(u_Conv_ifmap_reg[95]), 
        .O(n645) );
  MOAI1S U2007 ( .A1(n1501), .A2(n1482), .B1(n1501), .B2(u_Conv_ifmap_reg[92]), 
        .O(n644) );
  MOAI1S U2008 ( .A1(n1492), .A2(n1483), .B1(n1492), .B2(u_Conv_ifmap_reg[87]), 
        .O(n643) );
  MOAI1S U2009 ( .A1(n1497), .A2(n1483), .B1(n1497), .B2(u_Conv_ifmap_reg[84]), 
        .O(n642) );
  MOAI1S U2010 ( .A1(n1499), .A2(n1483), .B1(n1499), .B2(u_Conv_ifmap_reg[75]), 
        .O(n639) );
  MOAI1S U2011 ( .A1(n1501), .A2(n1483), .B1(n1501), .B2(u_Conv_ifmap_reg[72]), 
        .O(n638) );
  MOAI1S U2012 ( .A1(n1492), .A2(n1484), .B1(n1492), .B2(u_Conv_ifmap_reg[88]), 
        .O(n637) );
  MOAI1S U2013 ( .A1(n1497), .A2(n1484), .B1(n1497), .B2(u_Conv_ifmap_reg[85]), 
        .O(n636) );
  MOAI1S U2014 ( .A1(n1498), .A2(n1484), .B1(n1498), .B2(u_Conv_ifmap_reg[79]), 
        .O(n634) );
  MOAI1S U2015 ( .A1(n1499), .A2(n1484), .B1(n1499), .B2(u_Conv_ifmap_reg[76]), 
        .O(n633) );
  MOAI1S U2016 ( .A1(n1501), .A2(n1484), .B1(n1501), .B2(u_Conv_ifmap_reg[73]), 
        .O(n632) );
  MOAI1S U2017 ( .A1(n1503), .A2(n1485), .B1(n1503), .B2(u_Conv_ifmap_reg[83]), 
        .O(n629) );
  MOAI1S U2018 ( .A1(n1498), .A2(n1485), .B1(n1498), .B2(u_Conv_ifmap_reg[80]), 
        .O(n628) );
  MOAI1S U2019 ( .A1(n1503), .A2(n1486), .B1(n1503), .B2(u_Conv_ifmap_reg[63]), 
        .O(n623) );
  MOAI1S U2020 ( .A1(n1498), .A2(n1486), .B1(n1498), .B2(u_Conv_ifmap_reg[60]), 
        .O(n622) );
  MOAI1S U2021 ( .A1(n1503), .A2(n1487), .B1(n1503), .B2(u_Conv_ifmap_reg[64]), 
        .O(n617) );
  MOAI1S U2022 ( .A1(n1498), .A2(n1487), .B1(n1498), .B2(u_Conv_ifmap_reg[61]), 
        .O(n616) );
  MOAI1S U2023 ( .A1(n1492), .A2(n1488), .B1(n1492), .B2(u_Conv_ifmap_reg[71]), 
        .O(n613) );
  MOAI1S U2024 ( .A1(n1497), .A2(n1488), .B1(n1497), .B2(u_Conv_ifmap_reg[68]), 
        .O(n612) );
  MOAI1S U2025 ( .A1(n1503), .A2(n1488), .B1(n1503), .B2(u_Conv_ifmap_reg[65]), 
        .O(n611) );
  MOAI1S U2026 ( .A1(n1498), .A2(n1488), .B1(n1498), .B2(u_Conv_ifmap_reg[62]), 
        .O(n610) );
  MOAI1S U2027 ( .A1(n1499), .A2(n1488), .B1(n1499), .B2(u_Conv_ifmap_reg[59]), 
        .O(n609) );
  MOAI1S U2028 ( .A1(n1501), .A2(n1488), .B1(n1501), .B2(u_Conv_ifmap_reg[56]), 
        .O(n608) );
  MOAI1S U2029 ( .A1(n1503), .A2(n1489), .B1(n1503), .B2(u_Conv_ifmap_reg[45]), 
        .O(n605) );
  MOAI1S U2030 ( .A1(n1492), .A2(n1490), .B1(n1492), .B2(u_Conv_ifmap_reg[52]), 
        .O(n601) );
  MOAI1S U2031 ( .A1(n1503), .A2(n1490), .B1(n1503), .B2(u_Conv_ifmap_reg[46]), 
        .O(n599) );
  MOAI1S U2032 ( .A1(n1498), .A2(n1490), .B1(n1498), .B2(u_Conv_ifmap_reg[43]), 
        .O(n598) );
  MOAI1S U2033 ( .A1(n1501), .A2(n1490), .B1(n1501), .B2(u_Conv_ifmap_reg[37]), 
        .O(n596) );
  MOAI1S U2034 ( .A1(n1497), .A2(n1491), .B1(n1497), .B2(u_Conv_ifmap_reg[50]), 
        .O(n594) );
  MOAI1S U2035 ( .A1(n1498), .A2(n1491), .B1(n1498), .B2(u_Conv_ifmap_reg[44]), 
        .O(n592) );
  MOAI1S U2036 ( .A1(n1499), .A2(n1491), .B1(n1499), .B2(u_Conv_ifmap_reg[41]), 
        .O(n591) );
  MOAI1S U2037 ( .A1(n1501), .A2(n1491), .B1(n1501), .B2(u_Conv_ifmap_reg[38]), 
        .O(n590) );
  MOAI1S U2038 ( .A1(n1492), .A2(n1493), .B1(n1492), .B2(u_Conv_ifmap_reg[33]), 
        .O(n589) );
  MOAI1S U2039 ( .A1(n1497), .A2(n1493), .B1(n1497), .B2(u_Conv_ifmap_reg[30]), 
        .O(n588) );
  MOAI1S U2040 ( .A1(n1503), .A2(n1493), .B1(n1503), .B2(u_Conv_ifmap_reg[27]), 
        .O(n587) );
  MOAI1S U2041 ( .A1(n1498), .A2(n1493), .B1(n1498), .B2(u_Conv_ifmap_reg[24]), 
        .O(n586) );
  MOAI1S U2042 ( .A1(n1499), .A2(n1493), .B1(n1499), .B2(u_Conv_ifmap_reg[21]), 
        .O(n585) );
  MOAI1S U2043 ( .A1(n1501), .A2(n1493), .B1(n1501), .B2(u_Conv_ifmap_reg[18]), 
        .O(n584) );
  MOAI1S U2044 ( .A1(n1498), .A2(n1494), .B1(n1498), .B2(u_Conv_ifmap_reg[25]), 
        .O(n580) );
  MOAI1S U2045 ( .A1(n1497), .A2(n1495), .B1(n1497), .B2(u_Conv_ifmap_reg[32]), 
        .O(n576) );
  MOAI1S U2046 ( .A1(n1498), .A2(n1495), .B1(n1498), .B2(u_Conv_ifmap_reg[26]), 
        .O(n574) );
  MOAI1S U2047 ( .A1(n1499), .A2(n1495), .B1(n1499), .B2(u_Conv_ifmap_reg[23]), 
        .O(n573) );
  MOAI1S U2048 ( .A1(n1501), .A2(n1495), .B1(n1501), .B2(u_Conv_ifmap_reg[20]), 
        .O(n572) );
  MOAI1S U2049 ( .A1(n1498), .A2(n1496), .B1(n1498), .B2(u_Conv_ifmap_reg[6]), 
        .O(n568) );
  MOAI1S U2050 ( .A1(n1497), .A2(n1500), .B1(n1497), .B2(u_Conv_ifmap_reg[13]), 
        .O(n564) );
  MOAI1S U2051 ( .A1(n1498), .A2(n1500), .B1(n1498), .B2(u_Conv_ifmap_reg[7]), 
        .O(n562) );
  MOAI1S U2052 ( .A1(n1499), .A2(n1500), .B1(n1499), .B2(u_Conv_ifmap_reg[4]), 
        .O(n561) );
  MOAI1S U2053 ( .A1(n1501), .A2(n1500), .B1(n1501), .B2(u_Conv_ifmap_reg[1]), 
        .O(n560) );
  MOAI1S U2054 ( .A1(n1503), .A2(n1502), .B1(n1503), .B2(u_Conv_ifmap_reg[11]), 
        .O(n557) );
  MOAI1S U2055 ( .A1(u_Conv_kernel_idx[1]), .A2(n1509), .B1(
        u_Conv_kernel_idx[1]), .B2(n1508), .O(n553) );
  MOAI1S U2056 ( .A1(n1523), .A2(u_Conv_acc_count_x), .B1(n1523), .B2(
        u_Conv_acc_count_x), .O(n549) );
  NR2 U2057 ( .I1(n1510), .I2(n1523), .O(n1513) );
  MOAI1S U2058 ( .A1(n1513), .A2(n1512), .B1(conv_busy), .B2(n1511), .O(n548)
         );
  NR2 U2059 ( .I1(n1514), .I2(n1523), .O(n1522) );
endmodule


module NDFF_syn ( D, Q, clk, rst_n );
  input D, clk, rst_n;
  output Q;
  wire   A1;

  QDFFRBS A1_reg ( .D(D), .CK(clk), .RB(rst_n), .Q(A1) );
  QDFFRBS A2_reg ( .D(A1), .CK(clk), .RB(rst_n), .Q(Q) );
endmodule

