/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : T-2022.03
// Date      : Tue Nov 19 00:47:22 2024
/////////////////////////////////////////////////////////////


module TETRIS ( rst_n, clk, in_valid, tetrominoes, position, tetris_valid, 
        score_valid, fail, score, tetris );
  input [2:0] tetrominoes;
  input [2:0] position;
  output [3:0] score;
  output [71:0] tetris;
  input rst_n, clk, in_valid;
  output tetris_valid, score_valid, fail;
  wire   next_state_0_, bottom_1__0_, bottom_0__0_, bottom_compare_f_2_, N706,
         N707, N708, N709, N710, N711, N712, N713, N714, N715, N716, N717,
         N718, N719, N720, N721, N722, N723, map_f_12__5_, map_f_12__4_,
         map_f_12__3_, map_f_12__2_, map_f_12__1_, map_f_12__0_, map_f_11__5_,
         map_f_11__4_, map_f_11__3_, map_f_11__2_, map_f_11__1_, map_f_11__0_,
         map_f_10__5_, map_f_10__4_, map_f_10__3_, map_f_10__2_, map_f_10__1_,
         map_f_10__0_, map_f_9__5_, map_f_9__4_, map_f_9__3_, map_f_9__2_,
         map_f_9__1_, map_f_9__0_, map_f_8__5_, map_f_8__4_, map_f_8__3_,
         map_f_8__2_, map_f_8__1_, map_f_8__0_, map_f_7__5_, map_f_7__4_,
         map_f_7__3_, map_f_7__2_, map_f_7__1_, map_f_7__0_, map_f_6__5_,
         map_f_6__4_, map_f_6__3_, map_f_6__2_, map_f_6__1_, map_f_6__0_,
         map_f_5__5_, map_f_5__4_, map_f_5__3_, map_f_5__2_, map_f_5__1_,
         map_f_5__0_, map_f_4__5_, map_f_4__4_, map_f_4__3_, map_f_4__2_,
         map_f_4__1_, map_f_4__0_, map_f_3__5_, map_f_3__4_, map_f_3__3_,
         map_f_3__2_, map_f_3__1_, map_f_3__0_, map_f_2__5_, map_f_2__4_,
         map_f_2__3_, map_f_2__2_, map_f_2__1_, map_f_2__0_, map_f_1__5_,
         map_f_1__4_, map_f_1__3_, map_f_1__2_, map_f_1__1_, map_f_1__0_,
         map_f_0__5_, map_f_0__4_, map_f_0__3_, map_f_0__2_, map_f_0__1_,
         map_f_0__0_, N964, n641, n642, n643, n644, n645, n646, n647, n648,
         n649, n650, n651, n652, n653, n654, n655, n656, n657, n658, n659,
         n660, n661, n662, n663, n664, n665, n666, n667, n668, n669, n670,
         n671, n672, n673, n674, n675, n676, n677, n678, n679, n680, n681,
         n682, n683, n684, n685, n686, n687, n688, n689, n690, n691, n692,
         n693, n694, n695, n696, n697, n698, n699, n700, n701, n702, n703,
         n704, n705, n7060, n7070, n7080, n7090, n7100, n7110, n7120, n7130,
         n7140, n7150, n7160, n7170, n7180, n7200, n7210, n7220, n7230, n724,
         n725, n726, n727, n728, n729, n730, n731, n732, n733, n734, n735,
         n736, n737, n738, n739, n740, n741, n742, n743, n744, n745, n746,
         n747, n748, n749, n750, n751, n752, n753, n763, n764, n765, n766,
         n767, n768, n769, n770, n771, n772, n773, n774, n775, n776, n777,
         n778, n779, n780, n781, n782, n783, n784, n785, n786, n787, n788,
         n789, n790, n791, n792, n793, n794, n795, n796, n797, n798, n799,
         n800, n801, n802, n803, n804, n805, n806, n807, n808, n809, n810,
         n811, n812, n813, n814, n815, n816, n817, n818, n819, n820, n821,
         n822, n823, n824, n825, n826, n827, n828, n829, n830, n831, n832,
         n833, n834, n835, n836, n837, n838, n839, n840, n841, n842, n843,
         n844, n845, n846, n847, n848, n849, n850, n851, n852, n853, n854,
         n855, n856, n857, n858, n859, n860, n861, n862, n863, n864, n865,
         n866, n867, n868, n869, n870, n871, n872, n873, n874, n875, n876,
         n877, n878, n879, n880, n881, n882, n883, n884, n885, n886, n887,
         n888, n889, n890, n891, n892, n893, n894, n895, n896, n897, n898,
         n899, n900, n901, n902, n903, n904, n905, n906, n907, n908, n909,
         n910, n911, n912, n913, n914, n915, n916, n917, n918, n919, n920,
         n921, n922, n923, n924, n925, n926, n927, n928, n929, n930, n931,
         n932, n933, n934, n935, n936, n937, n938, n939, n940, n941, n942,
         n943, n944, n945, n946, n947, n948, n949, n950, n951, n952, n953,
         n954, n955, n956, n957, n958, n959, n960, n961, n962, n963, n9640,
         n965, n966, n967, n968, n969, n970, n971, n972, n973, n974, n975,
         n976, n977, n978, n979, n980, n981, n982, n983, n984, n985, n986,
         n987, n988, n989, n990, n991, n992, n993, n994, n995, n996, n997,
         n998, n999, n1000, n1001, n1002, n1003, n1004, n1005, n1006, n1007,
         n1008, n1009, n1010, n1011, n1012, n1013, n1014, n1015, n1016, n1017,
         n1018, n1019, n1020, n1021, n1022, n1023, n1024, n1025, n1026, n1027,
         n1028, n1029, n1030, n1031, n1032, n1033, n1034, n1035, n1036, n1037,
         n1038, n1039, n1040, n1041, n1042, n1043, n1044, n1045, n1046, n1047,
         n1048, n1049, n1050, n1051, n1052, n1053, n1054, n1055, n1056, n1057,
         n1058, n1059, n1060, n1061, n1062, n1063, n1064, n1065, n1066, n1067,
         n1068, n1069, n1070, n1071, n1072, n1073, n1074, n1075, n1076, n1077,
         n1078, n1079, n1080, n1081, n1082, n1083, n1084, n1085, n1086, n1087,
         n1088, n1089, n1090, n1091, n1092, n1093, n1094, n1095, n1096, n1097,
         n1098, n1099, n1100, n1101, n1102, n1103, n1104, n1105, n1106, n1107,
         n1108, n1109, n1110, n1111, n1112, n1113, n1114, n1115, n1116, n1117,
         n1118, n1119, n1120, n1121, n1122, n1123, n1124, n1125, n1126, n1127,
         n1128, n1129, n1130, n1131, n1132, n1133, n1134, n1135, n1136, n1137,
         n1138, n1139, n1140, n1141, n1142, n1143, n1144, n1145, n1146, n1147,
         n1148, n1149, n1150, n1151, n1152, n1153, n1154, n1155, n1156, n1157,
         n1158, n1159, n1160, n1161, n1162, n1163, n1164, n1165, n1166, n1167,
         n1168, n1169, n1170, n1171, n1172, n1173, n1174, n1175, n1176, n1177,
         n1178, n1179, n1180, n1181, n1182, n1183, n1184, n1185, n1186, n1187,
         n1188, n1189, n1190, n1191, n1192, n1193, n1194, n1195, n1196, n1197,
         n1198, n1199, n1200, n1201, n1202, n1203, n1204, n1205, n1206, n1207,
         n1208, n1209, n1210, n1211, n1212, n1213, n1214, n1215, n1216, n1217,
         n1218, n1219, n1220, n1221, n1222, n1223, n1224, n1225, n1226, n1227,
         n1228, n1229, n1230, n1231, n1232, n1233, n1234, n1235, n1236, n1237,
         n1238, n1239, n1240, n1241, n1242, n1243, n1244, n1245, n1246, n1247,
         n1248, n1249, n1250, n1251, n1252, n1253, n1254, n1255, n1256, n1257,
         n1258, n1259, n1260, n1261, n1262, n1263, n1264, n1265, n1266, n1267,
         n1268, n1269, n1270, n1271, n1272, n1273, n1274, n1275, n1276, n1277,
         n1278, n1279, n1280, n1281, n1282, n1283, n1284, n1285, n1286, n1287,
         n1288, n1289, n1290, n1291, n1292, n1293, n1294, n1295, n1296, n1297,
         n1298, n1299, n1300, n1301, n1302, n1303, n1304, n1305, n1306, n1307,
         n1308, n1309, n1310, n1311, n1312, n1313, n1314, n1315, n1316, n1317,
         n1318, n1319, n1320, n1321, n1322, n1323, n1324, n1325, n1326, n1327,
         n1328, n1329, n1330, n1331, n1332, n1333, n1334, n1335, n1336, n1337,
         n1338, n1339, n1340, n1341, n1342, n1343, n1344, n1345, n1346, n1347,
         n1348, n1349, n1350, n1351, n1352, n1353, n1354, n1355, n1356, n1357,
         n1358, n1359, n1360, n1361, n1362, n1363, n1364, n1365, n1366, n1367,
         n1368, n1369, n1370, n1371, n1372, n1373, n1374, n1375, n1376, n1377,
         n1378, n1379, n1380, n1381, n1382, n1383, n1384, n1385, n1386, n1387,
         n1388, n1389, n1390, n1391, n1392, n1393, n1394, n1395, n1396, n1397,
         n1398, n1399, n1400, n1401, n1402, n1403, n1404, n1405, n1406, n1407,
         n1408, n1409, n1410, n1411, n1412, n1413, n1414, n1415, n1416, n1417,
         n1418, n1419, n1420, n1421, n1422, n1423, n1424, n1425, n1426, n1427,
         n1428, n1429, n1430, n1431, n1432, n1433, n1434, n1435, n1436, n1437,
         n1438, n1439, n1440, n1441, n1442, n1443, n1444, n1445, n1446, n1447,
         n1448, n1449, n1450, n1451, n1452, n1453, n1454, n1455, n1456, n1457,
         n1458, n1459, n1460, n1461, n1462, n1463, n1464, n1465, n1466, n1467,
         n1468, n1469, n1470, n1471, n1472, n1473, n1474, n1475, n1476, n1477,
         n1478, n1479, n1480, n1481, n1482, n1483, n1484, n1485, n1486, n1487,
         n1488, n1489, n1490, n1491, n1492, n1493, n1494, n1495, n1496, n1497,
         n1498, n1499, n1500, n1501, n1502, n1503, n1504, n1505, n1506, n1507,
         n1508, n1509, n1510, n1511, n1512, n1513, n1514, n1515, n1516, n1517,
         n1518, n1519, n1520, n1521, n1522, n1523, n1524, n1525, n1526, n1527,
         n1528, n1529, n1530, n1531, n1532, n1533, n1534, n1535, n1536, n1537,
         n1538, n1539, n1540, n1541, n1542, n1543, n1544, n1545, n1546, n1547,
         n1548, n1549, n1550, n1551, n1552, n1553, n1554, n1555, n1556, n1557,
         n1558, n1559, n1560, n1561, n1562, n1563, n1564, n1565, n1566, n1567,
         n1568, n1569, n1570, n1571, n1572, n1573, n1574, n1575, n1576, n1577,
         n1578, n1579, n1580, n1581, n1582, n1583, n1584, n1585, n1586, n1587,
         n1588, n1589, n1590, n1591, n1592, n1593, n1594, n1595, n1596, n1597,
         n1598, n1599, n1600, n1601, n1602, n1603, n1604, n1605, n1606, n1607,
         n1608, n1609, n1610, n1611, n1612, n1613, n1614, n1615, n1616, n1617,
         n1618, n1619, n1620, n1621, n1622, n1623, n1624, n1625, n1626, n1627,
         n1628, n1629, n1630, n1631, n1632, n1633, n1634, n1635, n1636, n1637,
         n1638, n1639, n1640, n1641, n1642, n1643, n1644, n1645, n1646, n1647,
         n1648, n1649, n1650, n1651, n1652, n1653, n1654, n1655, n1656, n1657,
         n1658, n1659, n1660, n1661, n1662, n1663, n1664, n1665, n1666, n1667,
         n1668, n1669, n1670, n1671, n1672, n1673, n1674, n1675, n1676, n1677,
         n1678, n1679, n1680, n1681, n1682, n1683, n1684, n1685, n1686, n1687,
         n1688, n1689, n1690, n1691, n1692, n1693, n1694, n1695, n1696, n1697,
         n1698, n1699, n1700, n1701, n1702, n1703, n1704, n1705, n1706, n1707,
         n1708, n1709, n1710, n1711, n1712, n1713, n1714, n1715, n1716, n1717,
         n1718, n1719, n1720, n1721, n1722, n1723, n1724, n1725, n1726, n1727,
         n1728, n1729, n1730, n1731, n1732, n1733, n1734, n1735, n1736, n1737,
         n1738, n1739, n1740, n1741, n1742, n1743, n1744, n1745, n1746, n1747,
         n1748, n1749, n1750, n1751, n1752, n1753, n1754, n1755, n1756, n1757,
         n1758, n1759, n1760, n1761, n1762, n1763, n1764, n1765, n1766, n1767,
         n1768, n1769, n1770;
  wire   [2:0] state;
  wire   [3:0] cnt_f;
  wire   [3:0] cnt;
  wire   [10:0] bottom_f;
  wire   [2:1] position_f;
  wire   [23:0] tetrominoes_map_f;
  wire   [23:0] col_top_f;
  wire   [23:0] row_f;
  wire   [3:0] score_f;
  wire   [3:0] score_comb;
  wire   [71:0] tetris_comb;
  wire   [23:0] col_top;

  QDFFRBS tetrominoes_map_f_reg_3__0_ ( .D(n753), .CK(clk), .RB(n1767), .Q(
        tetrominoes_map_f[18]) );
  QDFFRBS tetrominoes_map_f_reg_3__1_ ( .D(n752), .CK(clk), .RB(n1767), .Q(
        tetrominoes_map_f[19]) );
  QDFFRBS tetrominoes_map_f_reg_3__2_ ( .D(n751), .CK(clk), .RB(n1767), .Q(
        tetrominoes_map_f[20]) );
  QDFFRBS tetrominoes_map_f_reg_3__3_ ( .D(n750), .CK(clk), .RB(n1767), .Q(
        tetrominoes_map_f[21]) );
  QDFFRBS tetrominoes_map_f_reg_3__4_ ( .D(n749), .CK(clk), .RB(n1767), .Q(
        tetrominoes_map_f[22]) );
  QDFFRBS tetrominoes_map_f_reg_3__5_ ( .D(n748), .CK(clk), .RB(n766), .Q(
        tetrominoes_map_f[23]) );
  QDFFRBS tetrominoes_map_f_reg_2__0_ ( .D(n747), .CK(clk), .RB(n766), .Q(
        tetrominoes_map_f[12]) );
  QDFFRBS tetrominoes_map_f_reg_2__1_ ( .D(n746), .CK(clk), .RB(n766), .Q(
        tetrominoes_map_f[13]) );
  QDFFRBS tetrominoes_map_f_reg_2__2_ ( .D(n745), .CK(clk), .RB(n766), .Q(
        tetrominoes_map_f[14]) );
  QDFFRBS tetrominoes_map_f_reg_2__3_ ( .D(n744), .CK(clk), .RB(n766), .Q(
        tetrominoes_map_f[15]) );
  QDFFRBS tetrominoes_map_f_reg_2__4_ ( .D(n743), .CK(clk), .RB(n766), .Q(
        tetrominoes_map_f[16]) );
  QDFFRBS tetrominoes_map_f_reg_2__5_ ( .D(n742), .CK(clk), .RB(n766), .Q(
        tetrominoes_map_f[17]) );
  QDFFRBS tetrominoes_map_f_reg_1__0_ ( .D(n741), .CK(clk), .RB(n766), .Q(
        tetrominoes_map_f[6]) );
  QDFFRBS tetrominoes_map_f_reg_1__1_ ( .D(n740), .CK(clk), .RB(n766), .Q(
        tetrominoes_map_f[7]) );
  QDFFRBS tetrominoes_map_f_reg_1__2_ ( .D(n739), .CK(clk), .RB(n766), .Q(
        tetrominoes_map_f[8]) );
  QDFFRBS tetrominoes_map_f_reg_1__3_ ( .D(n738), .CK(clk), .RB(n766), .Q(
        tetrominoes_map_f[9]) );
  QDFFRBS tetrominoes_map_f_reg_1__4_ ( .D(n737), .CK(clk), .RB(n766), .Q(
        tetrominoes_map_f[10]) );
  QDFFRBS tetrominoes_map_f_reg_1__5_ ( .D(n736), .CK(clk), .RB(n766), .Q(
        tetrominoes_map_f[11]) );
  QDFFRBS tetrominoes_map_f_reg_0__3_ ( .D(n732), .CK(clk), .RB(n766), .Q(
        tetrominoes_map_f[3]) );
  QDFFRBS tetrominoes_map_f_reg_0__4_ ( .D(n731), .CK(clk), .RB(n766), .Q(
        tetrominoes_map_f[4]) );
  QDFFRBS tetrominoes_map_f_reg_0__5_ ( .D(n730), .CK(clk), .RB(n766), .Q(
        tetrominoes_map_f[5]) );
  QDFFRBS bottom_f_reg_3__3_ ( .D(n1755), .CK(clk), .RB(n766), .Q(bottom_f[10]) );
  QDFFRBS bottom_f_reg_3__2_ ( .D(n1755), .CK(clk), .RB(n766), .Q(bottom_f[9])
         );
  QDFFRBS bottom_f_reg_2__3_ ( .D(n1756), .CK(clk), .RB(n766), .Q(bottom_f[8])
         );
  QDFFRBS bottom_f_reg_2__2_ ( .D(n1756), .CK(clk), .RB(n766), .Q(bottom_f[7])
         );
  QDFFRBS bottom_f_reg_2__0_ ( .D(n1763), .CK(clk), .RB(n766), .Q(bottom_f[6])
         );
  QDFFRBS bottom_f_reg_1__3_ ( .D(n1757), .CK(clk), .RB(n766), .Q(bottom_f[5])
         );
  QDFFRBS bottom_f_reg_1__0_ ( .D(bottom_1__0_), .CK(clk), .RB(n766), .Q(
        bottom_f[3]) );
  QDFFRBS bottom_f_reg_0__1_ ( .D(n1759), .CK(clk), .RB(n1767), .Q(bottom_f[1]) );
  QDFFRBS map_f_reg_0__0_ ( .D(n660), .CK(clk), .RB(n1764), .Q(map_f_0__0_) );
  QDFFRBS row_f_reg_0__0_ ( .D(n926), .CK(clk), .RB(n1767), .Q(row_f[0]) );
  QDFFRBS map_f_reg_10__1_ ( .D(n649), .CK(clk), .RB(n766), .Q(map_f_10__1_)
         );
  QDFFRBS map_f_reg_9__1_ ( .D(n703), .CK(clk), .RB(n767), .Q(map_f_9__1_) );
  QDFFRBS map_f_reg_8__1_ ( .D(n697), .CK(clk), .RB(n1764), .Q(map_f_8__1_) );
  QDFFRBS map_f_reg_7__1_ ( .D(n727), .CK(clk), .RB(n1766), .Q(map_f_7__1_) );
  QDFFRBS map_f_reg_6__1_ ( .D(n691), .CK(clk), .RB(n1764), .Q(map_f_6__1_) );
  QDFFRBS map_f_reg_5__1_ ( .D(n685), .CK(clk), .RB(n1766), .Q(map_f_5__1_) );
  QDFFRBS map_f_reg_4__1_ ( .D(n655), .CK(clk), .RB(n767), .Q(map_f_4__1_) );
  QDFFRBS map_f_reg_3__1_ ( .D(n679), .CK(clk), .RB(n1764), .Q(map_f_3__1_) );
  QDFFRBS map_f_reg_2__1_ ( .D(n673), .CK(clk), .RB(n1767), .Q(map_f_2__1_) );
  QDFFRBS map_f_reg_1__1_ ( .D(n667), .CK(clk), .RB(n767), .Q(map_f_1__1_) );
  QDFFRBS map_f_reg_0__1_ ( .D(n661), .CK(clk), .RB(n766), .Q(map_f_0__1_) );
  QDFFRBS row_f_reg_0__1_ ( .D(n927), .CK(clk), .RB(n1764), .Q(row_f[1]) );
  QDFFRBS map_f_reg_12__1_ ( .D(n7150), .CK(clk), .RB(n1765), .Q(map_f_12__1_)
         );
  QDFFRBS cnt_f_reg_0_ ( .D(cnt[0]), .CK(clk), .RB(n1766), .Q(cnt_f[0]) );
  QDFFRBS cnt_f_reg_1_ ( .D(cnt[1]), .CK(clk), .RB(n1764), .Q(cnt_f[1]) );
  QDFFRBS cnt_f_reg_2_ ( .D(cnt[2]), .CK(clk), .RB(n767), .Q(cnt_f[2]) );
  QDFFRBS map_f_reg_12__0_ ( .D(n7140), .CK(clk), .RB(n766), .Q(map_f_12__0_)
         );
  QDFFRBS map_f_reg_11__0_ ( .D(n7080), .CK(clk), .RB(n1764), .Q(map_f_11__0_)
         );
  QDFFRBS map_f_reg_10__5_ ( .D(n653), .CK(clk), .RB(rst_n), .Q(map_f_10__5_)
         );
  QDFFRBS map_f_reg_9__5_ ( .D(n7070), .CK(clk), .RB(n1764), .Q(map_f_9__5_)
         );
  QDFFRBS map_f_reg_8__5_ ( .D(n701), .CK(clk), .RB(n766), .Q(map_f_8__5_) );
  QDFFRBS map_f_reg_7__5_ ( .D(n7230), .CK(clk), .RB(n1765), .Q(map_f_7__5_)
         );
  QDFFRBS map_f_reg_6__5_ ( .D(n695), .CK(clk), .RB(n766), .Q(map_f_6__5_) );
  QDFFRBS map_f_reg_5__5_ ( .D(n689), .CK(clk), .RB(n1766), .Q(map_f_5__5_) );
  QDFFRBS map_f_reg_4__5_ ( .D(n659), .CK(clk), .RB(n1765), .Q(map_f_4__5_) );
  QDFFRBS map_f_reg_3__5_ ( .D(n683), .CK(clk), .RB(n1764), .Q(map_f_3__5_) );
  QDFFRBS map_f_reg_2__5_ ( .D(n677), .CK(clk), .RB(n1765), .Q(map_f_2__5_) );
  QDFFRBS map_f_reg_1__5_ ( .D(n671), .CK(clk), .RB(n766), .Q(map_f_1__5_) );
  QDFFRBS map_f_reg_0__5_ ( .D(n665), .CK(clk), .RB(n766), .Q(map_f_0__5_) );
  QDFFRBS row_f_reg_0__5_ ( .D(n931), .CK(clk), .RB(n766), .Q(row_f[5]) );
  QDFFRBS map_f_reg_12__5_ ( .D(n7220), .CK(clk), .RB(n1766), .Q(map_f_12__5_)
         );
  QDFFRBS map_f_reg_11__5_ ( .D(n7130), .CK(clk), .RB(n1765), .Q(map_f_11__5_)
         );
  QDFFRBS row_f_reg_3__5_ ( .D(N723), .CK(clk), .RB(n1764), .Q(row_f[23]) );
  QDFFRBS row_f_reg_2__5_ ( .D(N717), .CK(clk), .RB(n766), .Q(row_f[17]) );
  QDFFRBS row_f_reg_1__5_ ( .D(N711), .CK(clk), .RB(n766), .Q(row_f[11]) );
  QDFFRBS map_f_reg_10__4_ ( .D(n652), .CK(clk), .RB(n1766), .Q(map_f_10__4_)
         );
  QDFFRBS map_f_reg_9__4_ ( .D(n7060), .CK(clk), .RB(rst_n), .Q(map_f_9__4_)
         );
  QDFFRBS map_f_reg_8__4_ ( .D(n700), .CK(clk), .RB(n1764), .Q(map_f_8__4_) );
  QDFFRBS map_f_reg_7__4_ ( .D(n724), .CK(clk), .RB(n1764), .Q(map_f_7__4_) );
  QDFFRBS map_f_reg_6__4_ ( .D(n694), .CK(clk), .RB(n1764), .Q(map_f_6__4_) );
  QDFFRBS map_f_reg_5__4_ ( .D(n688), .CK(clk), .RB(n1764), .Q(map_f_5__4_) );
  QDFFRBS map_f_reg_4__4_ ( .D(n658), .CK(clk), .RB(n1764), .Q(map_f_4__4_) );
  QDFFRBS map_f_reg_3__4_ ( .D(n682), .CK(clk), .RB(n1764), .Q(map_f_3__4_) );
  QDFFRBS map_f_reg_2__4_ ( .D(n676), .CK(clk), .RB(n1764), .Q(map_f_2__4_) );
  QDFFRBS map_f_reg_1__4_ ( .D(n670), .CK(clk), .RB(n1764), .Q(map_f_1__4_) );
  QDFFRBS map_f_reg_0__4_ ( .D(n664), .CK(clk), .RB(n1764), .Q(map_f_0__4_) );
  QDFFRBS row_f_reg_0__4_ ( .D(n930), .CK(clk), .RB(n1764), .Q(row_f[4]) );
  QDFFRBS map_f_reg_12__4_ ( .D(n7180), .CK(clk), .RB(n1764), .Q(map_f_12__4_)
         );
  QDFFRBS map_f_reg_11__4_ ( .D(n7120), .CK(clk), .RB(n1764), .Q(map_f_11__4_)
         );
  QDFFRBS row_f_reg_3__4_ ( .D(N722), .CK(clk), .RB(n1764), .Q(row_f[22]) );
  QDFFRBS row_f_reg_2__4_ ( .D(N716), .CK(clk), .RB(n1764), .Q(row_f[16]) );
  QDFFRBS row_f_reg_1__4_ ( .D(N710), .CK(clk), .RB(n767), .Q(row_f[10]) );
  QDFFRBS map_f_reg_10__3_ ( .D(n651), .CK(clk), .RB(n767), .Q(map_f_10__3_)
         );
  QDFFRBS map_f_reg_9__3_ ( .D(n705), .CK(clk), .RB(n767), .Q(map_f_9__3_) );
  QDFFRBS map_f_reg_8__3_ ( .D(n699), .CK(clk), .RB(n1766), .Q(map_f_8__3_) );
  QDFFRBS map_f_reg_7__3_ ( .D(n725), .CK(clk), .RB(n767), .Q(map_f_7__3_) );
  QDFFRBS map_f_reg_6__3_ ( .D(n693), .CK(clk), .RB(n767), .Q(map_f_6__3_) );
  QDFFRBS map_f_reg_5__3_ ( .D(n687), .CK(clk), .RB(n767), .Q(map_f_5__3_) );
  QDFFRBS map_f_reg_4__3_ ( .D(n657), .CK(clk), .RB(n767), .Q(map_f_4__3_) );
  QDFFRBS map_f_reg_3__3_ ( .D(n681), .CK(clk), .RB(n767), .Q(map_f_3__3_) );
  QDFFRBS map_f_reg_2__3_ ( .D(n675), .CK(clk), .RB(n767), .Q(map_f_2__3_) );
  QDFFRBS map_f_reg_1__3_ ( .D(n669), .CK(clk), .RB(n767), .Q(map_f_1__3_) );
  QDFFRBS map_f_reg_0__3_ ( .D(n663), .CK(clk), .RB(n767), .Q(map_f_0__3_) );
  QDFFRBS row_f_reg_0__3_ ( .D(n929), .CK(clk), .RB(n767), .Q(row_f[3]) );
  QDFFRBS map_f_reg_12__3_ ( .D(n7170), .CK(clk), .RB(n1766), .Q(map_f_12__3_)
         );
  QDFFRBS map_f_reg_11__3_ ( .D(n7110), .CK(clk), .RB(n1767), .Q(map_f_11__3_)
         );
  QDFFRBS row_f_reg_3__3_ ( .D(N721), .CK(clk), .RB(n767), .Q(row_f[21]) );
  QDFFRBS row_f_reg_2__3_ ( .D(N715), .CK(clk), .RB(n1764), .Q(row_f[15]) );
  QDFFRBS row_f_reg_1__3_ ( .D(N709), .CK(clk), .RB(n766), .Q(row_f[9]) );
  QDFFRBS map_f_reg_10__2_ ( .D(n650), .CK(clk), .RB(n1766), .Q(map_f_10__2_)
         );
  QDFFRBS map_f_reg_9__2_ ( .D(n704), .CK(clk), .RB(n1765), .Q(map_f_9__2_) );
  QDFFRBS map_f_reg_8__2_ ( .D(n698), .CK(clk), .RB(n1764), .Q(map_f_8__2_) );
  QDFFRBS map_f_reg_7__2_ ( .D(n726), .CK(clk), .RB(n767), .Q(map_f_7__2_) );
  QDFFRBS map_f_reg_6__2_ ( .D(n692), .CK(clk), .RB(n767), .Q(map_f_6__2_) );
  QDFFRBS map_f_reg_5__2_ ( .D(n686), .CK(clk), .RB(n766), .Q(map_f_5__2_) );
  QDFFRBS map_f_reg_4__2_ ( .D(n656), .CK(clk), .RB(n767), .Q(map_f_4__2_) );
  QDFFRBS map_f_reg_3__2_ ( .D(n680), .CK(clk), .RB(n1765), .Q(map_f_3__2_) );
  QDFFRBS map_f_reg_2__2_ ( .D(n674), .CK(clk), .RB(n1765), .Q(map_f_2__2_) );
  QDFFRBS map_f_reg_1__2_ ( .D(n668), .CK(clk), .RB(n1767), .Q(map_f_1__2_) );
  QDFFRBS map_f_reg_0__2_ ( .D(n662), .CK(clk), .RB(n1766), .Q(map_f_0__2_) );
  QDFFRBS row_f_reg_0__2_ ( .D(n928), .CK(clk), .RB(n1765), .Q(row_f[2]) );
  QDFFRBS map_f_reg_12__2_ ( .D(n7160), .CK(clk), .RB(n767), .Q(map_f_12__2_)
         );
  QDFFRBS map_f_reg_11__2_ ( .D(n7100), .CK(clk), .RB(n1767), .Q(map_f_11__2_)
         );
  QDFFRBS row_f_reg_3__2_ ( .D(N720), .CK(clk), .RB(n1767), .Q(row_f[20]) );
  QDFFRBS row_f_reg_2__2_ ( .D(N714), .CK(clk), .RB(n1767), .Q(row_f[14]) );
  QDFFRBS row_f_reg_1__2_ ( .D(N708), .CK(clk), .RB(rst_n), .Q(row_f[8]) );
  QDFFRBS map_f_reg_11__1_ ( .D(n7090), .CK(clk), .RB(rst_n), .Q(map_f_11__1_)
         );
  QDFFRBS row_f_reg_3__1_ ( .D(N719), .CK(clk), .RB(n766), .Q(row_f[19]) );
  QDFFRBS row_f_reg_2__1_ ( .D(N713), .CK(clk), .RB(n1767), .Q(row_f[13]) );
  QDFFRBS row_f_reg_1__1_ ( .D(N707), .CK(clk), .RB(n1767), .Q(row_f[7]) );
  QDFFRBS map_f_reg_10__0_ ( .D(n648), .CK(clk), .RB(n1766), .Q(map_f_10__0_)
         );
  QDFFRBS map_f_reg_9__0_ ( .D(n702), .CK(clk), .RB(n1766), .Q(map_f_9__0_) );
  QDFFRBS map_f_reg_8__0_ ( .D(n696), .CK(clk), .RB(n1767), .Q(map_f_8__0_) );
  QDFFRBS map_f_reg_7__0_ ( .D(n728), .CK(clk), .RB(rst_n), .Q(map_f_7__0_) );
  QDFFRBS map_f_reg_6__0_ ( .D(n690), .CK(clk), .RB(n1764), .Q(map_f_6__0_) );
  QDFFRBS map_f_reg_5__0_ ( .D(n684), .CK(clk), .RB(n1767), .Q(map_f_5__0_) );
  QDFFRBS map_f_reg_4__0_ ( .D(n654), .CK(clk), .RB(n767), .Q(map_f_4__0_) );
  QDFFRBS map_f_reg_3__0_ ( .D(n678), .CK(clk), .RB(n1767), .Q(map_f_3__0_) );
  QDFFRBS row_f_reg_3__0_ ( .D(N718), .CK(clk), .RB(n1766), .Q(row_f[18]) );
  QDFFRBS map_f_reg_2__0_ ( .D(n672), .CK(clk), .RB(n767), .Q(map_f_2__0_) );
  QDFFRBS row_f_reg_2__0_ ( .D(N712), .CK(clk), .RB(n1764), .Q(row_f[12]) );
  QDFFRBS map_f_reg_1__0_ ( .D(n666), .CK(clk), .RB(n1765), .Q(map_f_1__0_) );
  QDFFRBS row_f_reg_1__0_ ( .D(N706), .CK(clk), .RB(n767), .Q(row_f[6]) );
  QDFFRBS score_f_reg_0_ ( .D(n647), .CK(clk), .RB(n1765), .Q(score_f[0]) );
  QDFFRBS score_f_reg_1_ ( .D(n646), .CK(clk), .RB(n1765), .Q(score_f[1]) );
  QDFFRBS score_f_reg_2_ ( .D(n645), .CK(clk), .RB(n1767), .Q(score_f[2]) );
  QDFFRBS score_f_reg_3_ ( .D(n644), .CK(clk), .RB(n1765), .Q(score_f[3]) );
  QDFFRBS col_top_f_reg_5__3_ ( .D(col_top[23]), .CK(clk), .RB(n1766), .Q(
        col_top_f[23]) );
  QDFFRBS col_top_f_reg_5__1_ ( .D(col_top[21]), .CK(clk), .RB(n1766), .Q(
        col_top_f[21]) );
  QDFFRBS col_top_f_reg_5__0_ ( .D(col_top[20]), .CK(clk), .RB(n1766), .Q(
        col_top_f[20]) );
  QDFFRBS col_top_f_reg_4__0_ ( .D(col_top[16]), .CK(clk), .RB(n766), .Q(
        col_top_f[16]) );
  QDFFRBS col_top_f_reg_3__3_ ( .D(col_top[15]), .CK(clk), .RB(n1765), .Q(
        col_top_f[15]) );
  QDFFRBS col_top_f_reg_3__1_ ( .D(col_top[13]), .CK(clk), .RB(n1764), .Q(
        col_top_f[13]) );
  QDFFRBS col_top_f_reg_3__0_ ( .D(col_top[12]), .CK(clk), .RB(n1766), .Q(
        col_top_f[12]) );
  QDFFRBS col_top_f_reg_2__2_ ( .D(col_top[10]), .CK(clk), .RB(n766), .Q(
        col_top_f[10]) );
  QDFFRBS col_top_f_reg_2__1_ ( .D(col_top[9]), .CK(clk), .RB(n1764), .Q(
        col_top_f[9]) );
  QDFFRBS col_top_f_reg_2__0_ ( .D(col_top[8]), .CK(clk), .RB(n1765), .Q(
        col_top_f[8]) );
  QDFFRBS col_top_f_reg_1__2_ ( .D(col_top[6]), .CK(clk), .RB(n1766), .Q(
        col_top_f[6]) );
  QDFFRBS col_top_f_reg_1__1_ ( .D(col_top[5]), .CK(clk), .RB(n766), .Q(
        col_top_f[5]) );
  QDFFRBS col_top_f_reg_1__0_ ( .D(col_top[4]), .CK(clk), .RB(n766), .Q(
        col_top_f[4]) );
  QDFFRBS col_top_f_reg_0__3_ ( .D(col_top[3]), .CK(clk), .RB(n1766), .Q(
        col_top_f[3]) );
  QDFFRBS col_top_f_reg_0__2_ ( .D(col_top[2]), .CK(clk), .RB(n1765), .Q(
        col_top_f[2]) );
  QDFFRBS col_top_f_reg_0__1_ ( .D(col_top[1]), .CK(clk), .RB(n766), .Q(
        col_top_f[1]) );
  QDFFRBS col_top_f_reg_0__0_ ( .D(col_top[0]), .CK(clk), .RB(n766), .Q(
        col_top_f[0]) );
  QDFFRBS fail_reg ( .D(n1761), .CK(clk), .RB(n1764), .Q(fail) );
  QDFFRBS tetris_valid_reg ( .D(n1760), .CK(clk), .RB(n766), .Q(tetris_valid)
         );
  QDFFRBS score_reg_3_ ( .D(score_comb[3]), .CK(clk), .RB(n766), .Q(score[3])
         );
  QDFFRBS score_reg_2_ ( .D(score_comb[2]), .CK(clk), .RB(n1764), .Q(score[2])
         );
  QDFFRBS score_reg_1_ ( .D(score_comb[1]), .CK(clk), .RB(n766), .Q(score[1])
         );
  QDFFRBS score_reg_0_ ( .D(score_comb[0]), .CK(clk), .RB(n1766), .Q(score[0])
         );
  QDFFRBS score_valid_reg ( .D(n937), .CK(clk), .RB(n1765), .Q(score_valid) );
  QDFFRBS tetris_reg_71_ ( .D(tetris_comb[71]), .CK(clk), .RB(n1764), .Q(
        tetris[71]) );
  QDFFRBS tetris_reg_70_ ( .D(tetris_comb[70]), .CK(clk), .RB(n766), .Q(
        tetris[70]) );
  QDFFRBS tetris_reg_69_ ( .D(tetris_comb[69]), .CK(clk), .RB(n766), .Q(
        tetris[69]) );
  QDFFRBS tetris_reg_68_ ( .D(tetris_comb[68]), .CK(clk), .RB(n766), .Q(
        tetris[68]) );
  QDFFRBS tetris_reg_67_ ( .D(tetris_comb[67]), .CK(clk), .RB(n766), .Q(
        tetris[67]) );
  QDFFRBS tetris_reg_66_ ( .D(tetris_comb[66]), .CK(clk), .RB(n1766), .Q(
        tetris[66]) );
  QDFFRBS tetris_reg_65_ ( .D(tetris_comb[65]), .CK(clk), .RB(n1765), .Q(
        tetris[65]) );
  QDFFRBS tetris_reg_64_ ( .D(tetris_comb[64]), .CK(clk), .RB(n1766), .Q(
        tetris[64]) );
  QDFFRBS tetris_reg_63_ ( .D(tetris_comb[63]), .CK(clk), .RB(n766), .Q(
        tetris[63]) );
  QDFFRBS tetris_reg_62_ ( .D(tetris_comb[62]), .CK(clk), .RB(n766), .Q(
        tetris[62]) );
  QDFFRBS tetris_reg_61_ ( .D(tetris_comb[61]), .CK(clk), .RB(n766), .Q(
        tetris[61]) );
  QDFFRBS tetris_reg_60_ ( .D(tetris_comb[60]), .CK(clk), .RB(n1765), .Q(
        tetris[60]) );
  QDFFRBS tetris_reg_59_ ( .D(tetris_comb[59]), .CK(clk), .RB(n1766), .Q(
        tetris[59]) );
  QDFFRBS tetris_reg_58_ ( .D(tetris_comb[58]), .CK(clk), .RB(n1764), .Q(
        tetris[58]) );
  QDFFRBS tetris_reg_57_ ( .D(tetris_comb[57]), .CK(clk), .RB(n1765), .Q(
        tetris[57]) );
  QDFFRBS tetris_reg_56_ ( .D(tetris_comb[56]), .CK(clk), .RB(n766), .Q(
        tetris[56]) );
  QDFFRBS tetris_reg_55_ ( .D(tetris_comb[55]), .CK(clk), .RB(n766), .Q(
        tetris[55]) );
  QDFFRBS tetris_reg_54_ ( .D(tetris_comb[54]), .CK(clk), .RB(n1766), .Q(
        tetris[54]) );
  QDFFRBS tetris_reg_53_ ( .D(tetris_comb[53]), .CK(clk), .RB(n1765), .Q(
        tetris[53]) );
  QDFFRBS tetris_reg_52_ ( .D(tetris_comb[52]), .CK(clk), .RB(n1764), .Q(
        tetris[52]) );
  QDFFRBS tetris_reg_51_ ( .D(tetris_comb[51]), .CK(clk), .RB(n766), .Q(
        tetris[51]) );
  QDFFRBS tetris_reg_50_ ( .D(tetris_comb[50]), .CK(clk), .RB(n1767), .Q(
        tetris[50]) );
  QDFFRBS tetris_reg_49_ ( .D(tetris_comb[49]), .CK(clk), .RB(n766), .Q(
        tetris[49]) );
  QDFFRBS tetris_reg_48_ ( .D(tetris_comb[48]), .CK(clk), .RB(n1766), .Q(
        tetris[48]) );
  QDFFRBS tetris_reg_47_ ( .D(tetris_comb[47]), .CK(clk), .RB(n1767), .Q(
        tetris[47]) );
  QDFFRBS tetris_reg_46_ ( .D(tetris_comb[46]), .CK(clk), .RB(rst_n), .Q(
        tetris[46]) );
  QDFFRBS tetris_reg_45_ ( .D(tetris_comb[45]), .CK(clk), .RB(n767), .Q(
        tetris[45]) );
  QDFFRBS tetris_reg_44_ ( .D(tetris_comb[44]), .CK(clk), .RB(n1767), .Q(
        tetris[44]) );
  QDFFRBS tetris_reg_43_ ( .D(tetris_comb[43]), .CK(clk), .RB(n767), .Q(
        tetris[43]) );
  QDFFRBS tetris_reg_42_ ( .D(tetris_comb[42]), .CK(clk), .RB(n1765), .Q(
        tetris[42]) );
  QDFFRBS tetris_reg_41_ ( .D(tetris_comb[41]), .CK(clk), .RB(n1764), .Q(
        tetris[41]) );
  QDFFRBS tetris_reg_40_ ( .D(tetris_comb[40]), .CK(clk), .RB(n1767), .Q(
        tetris[40]) );
  QDFFRBS tetris_reg_39_ ( .D(tetris_comb[39]), .CK(clk), .RB(n766), .Q(
        tetris[39]) );
  QDFFRBS tetris_reg_38_ ( .D(tetris_comb[38]), .CK(clk), .RB(n767), .Q(
        tetris[38]) );
  QDFFRBS tetris_reg_37_ ( .D(tetris_comb[37]), .CK(clk), .RB(rst_n), .Q(
        tetris[37]) );
  QDFFRBS tetris_reg_36_ ( .D(tetris_comb[36]), .CK(clk), .RB(n1766), .Q(
        tetris[36]) );
  QDFFRBS tetris_reg_35_ ( .D(tetris_comb[35]), .CK(clk), .RB(n1764), .Q(
        tetris[35]) );
  QDFFRBS tetris_reg_34_ ( .D(tetris_comb[34]), .CK(clk), .RB(n767), .Q(
        tetris[34]) );
  QDFFRBS tetris_reg_33_ ( .D(tetris_comb[33]), .CK(clk), .RB(n766), .Q(
        tetris[33]) );
  QDFFRBS tetris_reg_32_ ( .D(tetris_comb[32]), .CK(clk), .RB(n1765), .Q(
        tetris[32]) );
  QDFFRBS tetris_reg_31_ ( .D(tetris_comb[31]), .CK(clk), .RB(n1767), .Q(
        tetris[31]) );
  QDFFRBS tetris_reg_30_ ( .D(tetris_comb[30]), .CK(clk), .RB(n1767), .Q(
        tetris[30]) );
  QDFFRBS tetris_reg_29_ ( .D(tetris_comb[29]), .CK(clk), .RB(n1764), .Q(
        tetris[29]) );
  QDFFRBS tetris_reg_28_ ( .D(tetris_comb[28]), .CK(clk), .RB(n1766), .Q(
        tetris[28]) );
  QDFFRBS tetris_reg_27_ ( .D(tetris_comb[27]), .CK(clk), .RB(n1767), .Q(
        tetris[27]) );
  QDFFRBS tetris_reg_26_ ( .D(tetris_comb[26]), .CK(clk), .RB(n766), .Q(
        tetris[26]) );
  QDFFRBS tetris_reg_25_ ( .D(tetris_comb[25]), .CK(clk), .RB(n1767), .Q(
        tetris[25]) );
  QDFFRBS tetris_reg_24_ ( .D(tetris_comb[24]), .CK(clk), .RB(n1765), .Q(
        tetris[24]) );
  QDFFRBS tetris_reg_23_ ( .D(tetris_comb[23]), .CK(clk), .RB(n1767), .Q(
        tetris[23]) );
  QDFFRBS tetris_reg_22_ ( .D(tetris_comb[22]), .CK(clk), .RB(n1765), .Q(
        tetris[22]) );
  QDFFRBS tetris_reg_21_ ( .D(tetris_comb[21]), .CK(clk), .RB(n1765), .Q(
        tetris[21]) );
  QDFFRBS tetris_reg_20_ ( .D(tetris_comb[20]), .CK(clk), .RB(n1765), .Q(
        tetris[20]) );
  QDFFRBS tetris_reg_19_ ( .D(tetris_comb[19]), .CK(clk), .RB(n1765), .Q(
        tetris[19]) );
  QDFFRBS tetris_reg_18_ ( .D(tetris_comb[18]), .CK(clk), .RB(n1765), .Q(
        tetris[18]) );
  QDFFRBS tetris_reg_17_ ( .D(tetris_comb[17]), .CK(clk), .RB(n1765), .Q(
        tetris[17]) );
  QDFFRBS tetris_reg_16_ ( .D(tetris_comb[16]), .CK(clk), .RB(n1765), .Q(
        tetris[16]) );
  QDFFRBS tetris_reg_15_ ( .D(tetris_comb[15]), .CK(clk), .RB(n1765), .Q(
        tetris[15]) );
  QDFFRBS tetris_reg_14_ ( .D(tetris_comb[14]), .CK(clk), .RB(n1765), .Q(
        tetris[14]) );
  QDFFRBS tetris_reg_13_ ( .D(tetris_comb[13]), .CK(clk), .RB(n1765), .Q(
        tetris[13]) );
  QDFFRBS tetris_reg_12_ ( .D(tetris_comb[12]), .CK(clk), .RB(n1765), .Q(
        tetris[12]) );
  QDFFRBS tetris_reg_11_ ( .D(tetris_comb[11]), .CK(clk), .RB(n1765), .Q(
        tetris[11]) );
  QDFFRBS tetris_reg_10_ ( .D(tetris_comb[10]), .CK(clk), .RB(n1765), .Q(
        tetris[10]) );
  QDFFRBS tetris_reg_9_ ( .D(tetris_comb[9]), .CK(clk), .RB(n1765), .Q(
        tetris[9]) );
  QDFFRBS tetris_reg_8_ ( .D(tetris_comb[8]), .CK(clk), .RB(n1766), .Q(
        tetris[8]) );
  QDFFRBS tetris_reg_7_ ( .D(tetris_comb[7]), .CK(clk), .RB(n1766), .Q(
        tetris[7]) );
  QDFFRBS tetris_reg_6_ ( .D(tetris_comb[6]), .CK(clk), .RB(n1766), .Q(
        tetris[6]) );
  QDFFRBS tetris_reg_5_ ( .D(tetris_comb[5]), .CK(clk), .RB(n1766), .Q(
        tetris[5]) );
  QDFFRBS tetris_reg_4_ ( .D(tetris_comb[4]), .CK(clk), .RB(n1766), .Q(
        tetris[4]) );
  QDFFRBS tetris_reg_3_ ( .D(tetris_comb[3]), .CK(clk), .RB(n1766), .Q(
        tetris[3]) );
  QDFFRBS tetris_reg_2_ ( .D(tetris_comb[2]), .CK(clk), .RB(n1766), .Q(
        tetris[2]) );
  QDFFRBS tetris_reg_1_ ( .D(tetris_comb[1]), .CK(clk), .RB(n1766), .Q(
        tetris[1]) );
  QDFFRBS tetris_reg_0_ ( .D(tetris_comb[0]), .CK(clk), .RB(n1766), .Q(
        tetris[0]) );
  QDFFRBN tetrominoes_map_f_reg_0__0_ ( .D(n735), .CK(clk), .RB(n766), .Q(
        tetrominoes_map_f[0]) );
  QDFFRBN tetrominoes_map_f_reg_0__2_ ( .D(n733), .CK(clk), .RB(n766), .Q(
        tetrominoes_map_f[2]) );
  QDFFRBP bottom_compare_f_reg_3_ ( .D(n729), .CK(clk), .RB(n1767), .Q(N964)
         );
  QDFFRBP state_reg_0_ ( .D(next_state_0_), .CK(clk), .RB(n1767), .Q(state[0])
         );
  QDFFRBT position_f_reg_1_ ( .D(n642), .CK(clk), .RB(n766), .Q(position_f[1])
         );
  QDFFRBT bottom_compare_f_reg_2_ ( .D(n1768), .CK(clk), .RB(n1767), .Q(
        bottom_compare_f_2_) );
  QDFFRBN cnt_f_reg_3_ ( .D(cnt[3]), .CK(clk), .RB(n1764), .Q(cnt_f[3]) );
  DFFSBN state_reg_2_ ( .D(n1762), .CK(clk), .SB(n1767), .Q(n1770), .QB(
        state[2]) );
  DFFSBN bottom_f_reg_0__2_ ( .D(n808), .CK(clk), .SB(n766), .Q(n1769), .QB(
        bottom_f[2]) );
  QDFFRBT position_f_reg_2_ ( .D(n643), .CK(clk), .RB(n1767), .Q(position_f[2]) );
  QDFFRBN col_top_f_reg_2__3_ ( .D(col_top[11]), .CK(clk), .RB(n766), .Q(
        col_top_f[11]) );
  QDFFRBN col_top_f_reg_4__3_ ( .D(col_top[19]), .CK(clk), .RB(n1766), .Q(
        col_top_f[19]) );
  QDFFRBN col_top_f_reg_1__3_ ( .D(col_top[7]), .CK(clk), .RB(n766), .Q(
        col_top_f[7]) );
  QDFFRBS bottom_f_reg_1__2_ ( .D(n1757), .CK(clk), .RB(n766), .Q(bottom_f[4])
         );
  QDFFRBS bottom_f_reg_0__0_ ( .D(bottom_0__0_), .CK(clk), .RB(n1765), .Q(
        bottom_f[0]) );
  QDFFRBN col_top_f_reg_4__2_ ( .D(col_top[18]), .CK(clk), .RB(n766), .Q(
        col_top_f[18]) );
  QDFFRBS col_top_f_reg_5__2_ ( .D(col_top[22]), .CK(clk), .RB(n1766), .Q(
        col_top_f[22]) );
  QDFFRBS col_top_f_reg_3__2_ ( .D(col_top[14]), .CK(clk), .RB(n766), .Q(
        col_top_f[14]) );
  QDFFRBS tetrominoes_map_f_reg_0__1_ ( .D(n734), .CK(clk), .RB(n766), .Q(
        tetrominoes_map_f[1]) );
  QDFFRBN col_top_f_reg_4__1_ ( .D(col_top[17]), .CK(clk), .RB(n766), .Q(
        col_top_f[17]) );
  DFFRBT position_f_reg_0_ ( .D(n641), .CK(clk), .RB(n766), .Q(n788), .QB(n789) );
  QDFFRBN state_reg_1_ ( .D(n1758), .CK(clk), .RB(n1767), .Q(state[1]) );
  DFFRBP bottom_compare_f_reg_0_ ( .D(n7210), .CK(clk), .RB(n1767), .Q(n804), 
        .QB(n805) );
  DFFRBP bottom_compare_f_reg_1_ ( .D(n7200), .CK(clk), .RB(n1767), .Q(n802), 
        .QB(n803) );
  BUF1 U915 ( .I(n1626), .O(n794) );
  NR2T U916 ( .I1(n1401), .I2(n1400), .O(n1416) );
  INV3CK U917 ( .I(N964), .O(n1715) );
  BUF2 U918 ( .I(n867), .O(n769) );
  INV3 U919 ( .I(n860), .O(n859) );
  INV3 U920 ( .I(n1374), .O(n1376) );
  INV3CK U921 ( .I(n874), .O(n784) );
  BUF1CK U922 ( .I(n1296), .O(n813) );
  INV2 U923 ( .I(n1344), .O(n791) );
  NR2P U924 ( .I1(n819), .I2(n1356), .O(n774) );
  INV1S U925 ( .I(n770), .O(n902) );
  NR2 U926 ( .I1(n1346), .I2(n1347), .O(n890) );
  INV4 U927 ( .I(position_f[1]), .O(n778) );
  INV2 U928 ( .I(n1394), .O(n863) );
  INV2 U929 ( .I(n865), .O(n875) );
  ND2P U930 ( .I1(n786), .I2(n875), .O(n831) );
  INV1S U931 ( .I(n1307), .O(n1300) );
  ND3S U932 ( .I1(n945), .I2(n1577), .I3(n1578), .O(n946) );
  OR2 U933 ( .I1(N964), .I2(bottom_compare_f_2_), .O(n1688) );
  INV1S U934 ( .I(n943), .O(n937) );
  NR2P U935 ( .I1(n921), .I2(n1023), .O(n1357) );
  AN2 U936 ( .I1(n1358), .I2(col_top_f[21]), .O(n763) );
  AN2B1S U937 ( .I1(n882), .B1(n800), .O(n799) );
  INV3 U938 ( .I(n882), .O(n1296) );
  ND2T U939 ( .I1(n1304), .I2(n1306), .O(n1305) );
  INV1 U940 ( .I(n1395), .O(n1410) );
  INV2 U941 ( .I(n1409), .O(n764) );
  INV4 U942 ( .I(n1760), .O(n1481) );
  INV1 U943 ( .I(n1288), .O(n1291) );
  BUF1S U944 ( .I(n1380), .O(n1382) );
  ND2 U945 ( .I1(n1742), .I2(n1691), .O(n1702) );
  ND2 U946 ( .I1(n1742), .I2(n1599), .O(n1594) );
  BUF1 U947 ( .I(n1026), .O(n1557) );
  ND2 U948 ( .I1(n1742), .I2(n1634), .O(n1640) );
  ND2 U949 ( .I1(n1742), .I2(n1130), .O(n1667) );
  ND3P U950 ( .I1(n1340), .I2(n1339), .I3(n913), .O(n1342) );
  OR2 U951 ( .I1(n1740), .I2(n1684), .O(n1686) );
  ND2 U952 ( .I1(n1707), .I2(n805), .O(n1738) );
  INV3 U953 ( .I(n1740), .O(n1742) );
  OR2 U954 ( .I1(n1600), .I2(n1740), .O(n1611) );
  INV2 U955 ( .I(n1761), .O(n1545) );
  OR2 U956 ( .I1(N964), .I2(n1740), .O(n1571) );
  ND2P U957 ( .I1(n1582), .I2(n1482), .O(n1282) );
  ND2S U958 ( .I1(n1569), .I2(n1469), .O(n1471) );
  INV4 U959 ( .I(n937), .O(n1482) );
  ND2 U960 ( .I1(n1597), .I2(n1631), .O(n1615) );
  OR2 U961 ( .I1(n1714), .I2(n1468), .O(n1569) );
  ND2 U962 ( .I1(n1630), .I2(n804), .O(n1643) );
  NR2 U963 ( .I1(n1289), .I2(n770), .O(n904) );
  ND2 U964 ( .I1(n1687), .I2(n1691), .O(n1706) );
  ND2 U965 ( .I1(n1708), .I2(n1648), .O(n1646) );
  OR2 U966 ( .I1(n805), .I2(n1671), .O(n1670) );
  ND2 U967 ( .I1(n1632), .I2(n1688), .O(n1691) );
  ND2 U968 ( .I1(n1647), .I2(n805), .O(n1661) );
  INV1 U969 ( .I(n1671), .O(n1130) );
  ND3 U970 ( .I1(n940), .I2(n1546), .I3(n1544), .O(n1161) );
  OR2 U971 ( .I1(row_f[0]), .I2(tetrominoes_map_f[0]), .O(n1578) );
  ND2 U972 ( .I1(n802), .I2(n804), .O(n1714) );
  OR2 U973 ( .I1(row_f[1]), .I2(tetrominoes_map_f[1]), .O(n1577) );
  INV1S U974 ( .I(n1350), .O(n765) );
  BUF2 U975 ( .I(rst_n), .O(n766) );
  ND2 U976 ( .I1(tetrominoes[1]), .I2(in_valid), .O(n1259) );
  INV1 U977 ( .I(tetrominoes[0]), .O(n1553) );
  BUF1 U978 ( .I(rst_n), .O(n767) );
  MOAI1H U979 ( .A1(n816), .A2(n1405), .B1(n1420), .B2(n1421), .O(n1304) );
  ND3HT U980 ( .I1(n775), .I2(n773), .I3(n1355), .O(n821) );
  INV2 U981 ( .I(n1458), .O(n1427) );
  ND2 U982 ( .I1(n1359), .I2(col_top_f[14]), .O(n1298) );
  OAI12HS U983 ( .B1(bottom_f[9]), .B2(n768), .A1(n1307), .O(n1319) );
  ND2T U984 ( .I1(n768), .I2(bottom_f[9]), .O(n1307) );
  NR2T U985 ( .I1(n826), .I2(n799), .O(n768) );
  MAOI1HP U986 ( .A1(n1439), .A2(n1438), .B1(n1436), .B2(n1428), .O(n1456) );
  INV2 U987 ( .I(n817), .O(n897) );
  XOR2HP U988 ( .I1(n1350), .I2(n867), .O(n793) );
  ND3HT U989 ( .I1(n892), .I2(n889), .I3(n891), .O(n867) );
  OR2T U990 ( .I1(n918), .I2(n772), .O(n917) );
  NR2P U991 ( .I1(n1347), .I2(n1293), .O(n770) );
  OAI12H U992 ( .B1(n1309), .B2(n1310), .A1(n771), .O(n1381) );
  XNR2H U993 ( .I1(n771), .I2(n840), .O(n1384) );
  ND3HT U994 ( .I1(n839), .I2(n838), .I3(n837), .O(n771) );
  NR2T U995 ( .I1(n777), .I2(n821), .O(n772) );
  AOI12H U996 ( .B1(n1352), .B2(col_top_f[13]), .A1(n774), .O(n773) );
  NR2T U997 ( .I1(n776), .I2(n763), .O(n775) );
  NR2F U998 ( .I1(n1353), .I2(n1354), .O(n776) );
  NR2 U999 ( .I1(n1375), .I2(n1363), .O(n777) );
  INV1 U1000 ( .I(n1351), .O(n1363) );
  NR3HT U1001 ( .I1(position_f[2]), .I2(n788), .I3(n778), .O(n1025) );
  NR2F U1002 ( .I1(n778), .I2(n847), .O(n886) );
  OAI12HS U1003 ( .B1(in_valid), .B2(n778), .A1(n1163), .O(n642) );
  XNR2H U1004 ( .I1(n1364), .I2(n821), .O(n860) );
  INV1 U1005 ( .I(n874), .O(n873) );
  OR2 U1006 ( .I1(n1390), .I2(n887), .O(n779) );
  MXL2HS U1007 ( .A(n872), .B(n1457), .S(n1465), .OB(n1463) );
  INV2 U1008 ( .I(n868), .O(n780) );
  INV1 U1009 ( .I(n780), .O(n781) );
  INV3 U1010 ( .I(n1352), .O(n829) );
  BUF1CK U1011 ( .I(n825), .O(n782) );
  BUF1S U1012 ( .I(n1388), .O(n783) );
  INV2 U1013 ( .I(n1426), .O(n1457) );
  ND2P U1014 ( .I1(n784), .I2(n785), .O(n786) );
  INV1S U1015 ( .I(bottom_f[8]), .O(n785) );
  XNR2HS U1016 ( .I1(bottom_f[10]), .I2(n1303), .O(n1301) );
  OAI12H U1017 ( .B1(n1437), .B2(n1432), .A1(n1431), .O(n1434) );
  AOI22S U1018 ( .A1(n1352), .A2(col_top_f[19]), .B1(col_top_f[11]), .B2(n1359), .O(n834) );
  BUF1 U1019 ( .I(n1325), .O(n790) );
  MXL2HS U1020 ( .A(n1467), .B(n1466), .S(n1465), .OB(n922) );
  ND2 U1021 ( .I1(n1742), .I2(n1648), .O(n1651) );
  BUF4CK U1022 ( .I(n1433), .O(n787) );
  XOR2H U1023 ( .I1(n792), .I2(n1302), .O(n816) );
  XOR2HS U1024 ( .I1(bottom_f[8]), .I2(n865), .O(n792) );
  INV2 U1025 ( .I(n1319), .O(n1385) );
  BUF1 U1026 ( .I(n1420), .O(n1423) );
  ND2 U1027 ( .I1(n1358), .I2(col_top_f[23]), .O(n1339) );
  ND2P U1028 ( .I1(n1357), .I2(col_top_f[22]), .O(n895) );
  AOI22H U1029 ( .A1(n1352), .A2(col_top_f[8]), .B1(col_top_f[0]), .B2(n1359), 
        .O(n885) );
  MOAI1H U1030 ( .A1(n898), .A2(n1383), .B1(n1441), .B2(n1448), .O(n1425) );
  NR2P U1031 ( .I1(n1448), .I2(n1441), .O(n898) );
  NR2P U1032 ( .I1(n823), .I2(n822), .O(n824) );
  XNR2HP U1033 ( .I1(n825), .I2(n793), .O(n879) );
  ND2 U1034 ( .I1(n1352), .I2(col_top_f[14]), .O(n891) );
  INV3 U1035 ( .I(n1027), .O(n1028) );
  NR2P U1036 ( .I1(n1341), .I2(n1356), .O(n914) );
  NR2P U1037 ( .I1(n1332), .I2(n791), .O(n883) );
  AOI22H U1038 ( .A1(n882), .A2(col_top_f[7]), .B1(n1352), .B2(col_top_f[11]), 
        .O(n1337) );
  MXL2H U1039 ( .A(n1435), .B(n1434), .S(n787), .OB(n1439) );
  MXL2HP U1040 ( .A(n1379), .B(n1378), .S(n1433), .OB(n1448) );
  NR2P U1041 ( .I1(n1713), .I2(n1712), .O(n1735) );
  OR2 U1042 ( .I1(n1747), .I2(n1711), .O(n1712) );
  AOI22H U1043 ( .A1(col_top_f[14]), .A2(n882), .B1(n1352), .B2(col_top_f[18]), 
        .O(n842) );
  OR2 U1044 ( .I1(n1717), .I2(n1716), .O(n1733) );
  NR2P U1045 ( .I1(n915), .I2(n897), .O(n896) );
  INV2 U1046 ( .I(n1057), .O(n1473) );
  NR2 U1047 ( .I1(n949), .I2(n1715), .O(n1581) );
  ND2S U1048 ( .I1(n1581), .I2(map_f_12__0_), .O(n1013) );
  BUF2 U1049 ( .I(n954), .O(n1536) );
  ND2S U1050 ( .I1(n1581), .I2(map_f_12__2_), .O(n991) );
  ND2S U1051 ( .I1(n1581), .I2(map_f_12__3_), .O(n980) );
  ND2S U1052 ( .I1(n1581), .I2(map_f_12__4_), .O(n968) );
  ND2S U1053 ( .I1(n1581), .I2(map_f_12__5_), .O(n956) );
  ND2S U1054 ( .I1(n1581), .I2(map_f_12__1_), .O(n1002) );
  ND2P U1055 ( .I1(n944), .I2(n1482), .O(n1747) );
  BUF1S U1056 ( .I(n813), .O(n836) );
  ND2S U1057 ( .I1(n1459), .I2(n802), .O(n1451) );
  INV2 U1058 ( .I(n1597), .O(n1469) );
  AO112S U1059 ( .C1(map_f_7__0_), .C2(n1616), .A1(n1011), .B1(n1010), .O(
        n1534) );
  ND3S U1060 ( .I1(n1009), .I2(n1008), .I3(n1013), .O(n1010) );
  OAI12HS U1061 ( .B1(n1354), .B2(n1536), .A1(n1473), .O(n1561) );
  INV1S U1062 ( .I(n818), .O(n908) );
  ND2S U1063 ( .I1(n825), .I2(n1769), .O(n1418) );
  MAOI1 U1064 ( .A1(n1358), .A2(col_top_f[19]), .B1(n1335), .B2(n1347), .O(
        n1336) );
  OAI22S U1065 ( .A1(n1312), .A2(n1311), .B1(n813), .B2(n819), .O(n1315) );
  INV1S U1066 ( .I(n1352), .O(n1312) );
  AOI22HP U1067 ( .A1(n1436), .A2(n1428), .B1(n1464), .B2(n1467), .O(n920) );
  INV2 U1068 ( .I(n1467), .O(n1438) );
  ND2P U1069 ( .I1(n877), .I2(n873), .O(n1302) );
  ND2S U1070 ( .I1(n1631), .I2(n1715), .O(n1632) );
  ND2S U1071 ( .I1(n1617), .I2(n1715), .O(n1620) );
  ND2S U1072 ( .I1(bottom_compare_f_2_), .I2(n802), .O(n1617) );
  INV1S U1073 ( .I(n979), .O(n1597) );
  ND2S U1074 ( .I1(n1749), .I2(N964), .O(n1709) );
  INV2 U1075 ( .I(n1688), .O(n1648) );
  INV1S U1076 ( .I(n1383), .O(n1446) );
  OR2S U1077 ( .I1(state[0]), .I2(state[2]), .O(n1443) );
  ND3S U1078 ( .I1(n1727), .I2(n1728), .I3(n1607), .O(n1213) );
  ND2S U1079 ( .I1(n1749), .I2(n1748), .O(n1751) );
  OR2S U1080 ( .I1(n1747), .I2(n947), .O(n1662) );
  ND3S U1081 ( .I1(n1105), .I2(n1104), .I3(n1103), .O(n1527) );
  OR2S U1082 ( .I1(n1715), .I2(n1587), .O(n1105) );
  OR2S U1083 ( .I1(n1688), .I2(n1701), .O(n1104) );
  ND2S U1084 ( .I1(n1687), .I2(map_f_8__1_), .O(n1103) );
  AO112S U1085 ( .C1(map_f_7__2_), .C2(n1616), .A1(n989), .B1(n988), .O(n1521)
         );
  ND3S U1086 ( .I1(n987), .I2(n986), .I3(n991), .O(n988) );
  ND3S U1087 ( .I1(n1119), .I2(n1118), .I3(n1117), .O(n1517) );
  OR2S U1088 ( .I1(n1715), .I2(n1585), .O(n1119) );
  OR2S U1089 ( .I1(n1688), .I2(n1697), .O(n1118) );
  ND2S U1090 ( .I1(n1687), .I2(map_f_8__3_), .O(n1117) );
  AO112S U1091 ( .C1(map_f_7__3_), .C2(n1616), .A1(n977), .B1(n976), .O(n1516)
         );
  ND3S U1092 ( .I1(n975), .I2(n974), .I3(n980), .O(n976) );
  OA12S U1093 ( .B1(n1584), .B2(n1715), .A1(n1134), .O(n1135) );
  ND2S U1094 ( .I1(n1687), .I2(map_f_8__4_), .O(n1134) );
  AO112S U1095 ( .C1(map_f_7__4_), .C2(n1616), .A1(n966), .B1(n965), .O(n1511)
         );
  ND3S U1096 ( .I1(n9640), .I2(n963), .I3(n968), .O(n965) );
  OR2S U1097 ( .I1(n1715), .I2(n1583), .O(n1127) );
  OR2S U1098 ( .I1(n1688), .I2(n1693), .O(n1126) );
  ND2S U1099 ( .I1(n1687), .I2(map_f_8__5_), .O(n1125) );
  AO112S U1100 ( .C1(map_f_7__5_), .C2(n1616), .A1(n953), .B1(n952), .O(n1506)
         );
  ND3S U1101 ( .I1(n951), .I2(n950), .I3(n956), .O(n952) );
  AO112S U1102 ( .C1(map_f_7__1_), .C2(n1616), .A1(n1000), .B1(n999), .O(n1526) );
  ND3S U1103 ( .I1(n998), .I2(n997), .I3(n1002), .O(n999) );
  ND2 U1104 ( .I1(n1739), .I2(n1578), .O(n1737) );
  INV1S U1105 ( .I(tetrominoes[1]), .O(n1248) );
  MOAI1S U1106 ( .A1(n1553), .A2(tetrominoes[1]), .B1(n1553), .B2(
        tetrominoes[1]), .O(n1558) );
  OR2S U1107 ( .I1(n1536), .I2(n791), .O(n798) );
  ND2S U1108 ( .I1(n1248), .I2(n1551), .O(n1554) );
  ND3S U1109 ( .I1(n1088), .I2(n1087), .I3(n1086), .O(n734) );
  ND2S U1110 ( .I1(n1561), .I2(tetrominoes_map_f[1]), .O(n1088) );
  ND3S U1111 ( .I1(n1076), .I2(n1075), .I3(n1074), .O(n733) );
  AN3S U1112 ( .I1(n1073), .I2(n1072), .I3(n1071), .O(n1075) );
  ND2S U1113 ( .I1(tetrominoes_map_f[8]), .I2(n1562), .O(n1072) );
  AOI13HS U1114 ( .B1(n939), .B2(n938), .B3(n1584), .A1(n1482), .O(n1761) );
  MAOI1S U1115 ( .A1(n1535), .A2(n1534), .B1(n1533), .B2(n1532), .O(n1540) );
  ND2S U1116 ( .I1(n1344), .I2(col_top_f[14]), .O(n910) );
  AOI12H U1117 ( .B1(n1344), .B2(col_top_f[18]), .A1(n890), .O(n889) );
  INV1S U1118 ( .I(col_top_f[17]), .O(n819) );
  INV3 U1119 ( .I(n1292), .O(n905) );
  INV1S U1120 ( .I(col_top_f[18]), .O(n800) );
  ND2S U1121 ( .I1(n882), .I2(col_top_f[9]), .O(n1355) );
  ND3P U1122 ( .I1(n1419), .I2(n1418), .I3(n1417), .O(n1432) );
  ND2P U1123 ( .I1(n1416), .I2(n1415), .O(n1419) );
  ND2S U1124 ( .I1(bottom_f[7]), .I2(bottom_f[8]), .O(n830) );
  OR2S U1125 ( .I1(bottom_f[5]), .I2(n1394), .O(n1413) );
  INV1S U1126 ( .I(n1368), .O(n915) );
  NR2P U1127 ( .I1(n1376), .I2(n860), .O(n848) );
  ND2P U1128 ( .I1(n1359), .I2(col_top_f[8]), .O(n844) );
  ND2S U1129 ( .I1(n769), .I2(n1334), .O(n1395) );
  INV2 U1130 ( .I(n1428), .O(n1437) );
  ND2 U1131 ( .I1(n1344), .I2(col_top_f[23]), .O(n833) );
  INV1 U1132 ( .I(n811), .O(n835) );
  ND3 U1133 ( .I1(n1297), .I2(n846), .I3(n845), .O(n1303) );
  ND2S U1134 ( .I1(n1352), .I2(col_top_f[23]), .O(n845) );
  ND2S U1135 ( .I1(n882), .I2(col_top_f[19]), .O(n846) );
  NR2P U1136 ( .I1(n1402), .I2(n1416), .O(n1403) );
  MXL2H U1137 ( .A(n1382), .B(n899), .S(n1325), .OB(n1383) );
  INV1S U1138 ( .I(n864), .O(n899) );
  ND2S U1139 ( .I1(n1566), .I2(n1688), .O(n1618) );
  ND2S U1140 ( .I1(n1714), .I2(n1715), .O(n1566) );
  ND2 U1141 ( .I1(state[0]), .I2(state[1]), .O(n941) );
  BUF2 U1142 ( .I(n1358), .O(n815) );
  OAI22S U1143 ( .A1(n1284), .A2(n1312), .B1(n836), .B2(n828), .O(n1286) );
  BUF1S U1144 ( .I(n1441), .O(n807) );
  INV1S U1145 ( .I(col_top_f[19]), .O(n1341) );
  OR2S U1146 ( .I1(n1195), .I2(map_f_8__4_), .O(n1219) );
  BUF1S U1147 ( .I(n1405), .O(n1406) );
  INV1S U1148 ( .I(n816), .O(n1407) );
  OR2S U1149 ( .I1(n1460), .I2(n1459), .O(n1470) );
  ND2S U1150 ( .I1(n1557), .I2(tetrominoes_map_f[0]), .O(n1071) );
  OR2S U1151 ( .I1(n1265), .I2(map_f_8__1_), .O(n1275) );
  ND2S U1152 ( .I1(n1208), .I2(n1608), .O(n1236) );
  ND3S U1153 ( .I1(n1224), .I2(n1724), .I3(n1623), .O(n1190) );
  OR2S U1154 ( .I1(n1190), .I2(map_f_8__3_), .O(n1225) );
  ND3S U1155 ( .I1(n1218), .I2(n1721), .I3(n1622), .O(n1195) );
  ND3S U1156 ( .I1(n1230), .I2(n1718), .I3(n1621), .O(n1192) );
  OR2S U1157 ( .I1(n1192), .I2(map_f_8__5_), .O(n1231) );
  ND2S U1158 ( .I1(n1538), .I2(N964), .O(n1504) );
  ND2 U1159 ( .I1(n1597), .I2(n1708), .O(n1588) );
  ND2S U1160 ( .I1(n1582), .I2(n1576), .O(n1580) );
  INV1S U1161 ( .I(n1662), .O(n1669) );
  NR2 U1162 ( .I1(n1747), .I2(n1650), .O(n1659) );
  ND2S U1163 ( .I1(n1648), .I2(n1714), .O(n1649) );
  OR2 U1164 ( .I1(n1651), .I2(n1708), .O(n1657) );
  AOI13HS U1165 ( .B1(n1749), .B2(n1646), .B3(n1644), .A1(n1747), .O(n1645) );
  ND2S U1166 ( .I1(n1648), .I2(n1689), .O(n1644) );
  NR2 U1167 ( .I1(n1747), .I2(n1690), .O(n1704) );
  MOAI1S U1168 ( .A1(n1762), .A2(n1634), .B1(n1739), .B2(n1691), .O(n1633) );
  ND2 U1169 ( .I1(n1616), .I2(n805), .O(n1629) );
  AO12S U1170 ( .B1(n1629), .B2(n1620), .A1(n1740), .O(n1626) );
  NR2 U1171 ( .I1(n1747), .I2(n1619), .O(n1628) );
  MOAI1S U1172 ( .A1(n1618), .A2(n1762), .B1(n1739), .B2(n1634), .O(n1619) );
  NR2 U1173 ( .I1(n1747), .I2(n1568), .O(n1570) );
  ND2S U1174 ( .I1(n1567), .I2(n1709), .O(n1568) );
  ND2S U1175 ( .I1(n1739), .I2(n1618), .O(n1567) );
  OR2S U1176 ( .I1(N964), .I2(n1739), .O(n1598) );
  ND2 U1177 ( .I1(n1739), .I2(n1577), .O(n1732) );
  OA12 U1178 ( .B1(n804), .B2(n1671), .A1(n1749), .O(n1684) );
  NR2 U1179 ( .I1(n1747), .I2(n1684), .O(n1682) );
  ND2S U1180 ( .I1(n1451), .I2(n1450), .O(n1452) );
  ND2S U1181 ( .I1(n808), .I2(position[2]), .O(n1148) );
  ND2S U1182 ( .I1(n808), .I2(position[1]), .O(n1163) );
  AN2S U1183 ( .I1(n937), .I2(score_f[1]), .O(score_comb[1]) );
  AN2S U1184 ( .I1(n937), .I2(score_f[3]), .O(score_comb[3]) );
  ND2S U1185 ( .I1(n808), .I2(position[0]), .O(n1146) );
  ND2S U1186 ( .I1(n1254), .I2(n937), .O(n1256) );
  ND2S U1187 ( .I1(n1253), .I2(n1252), .O(n1254) );
  ND3S U1188 ( .I1(n1641), .I2(n1703), .I3(n1277), .O(n1279) );
  ND2S U1189 ( .I1(n1187), .I2(n937), .O(n1188) );
  ND2S U1190 ( .I1(n1186), .I2(n1185), .O(n1187) );
  ND2S U1191 ( .I1(n1752), .I2(n1751), .O(n1753) );
  AO12S U1192 ( .B1(n1662), .B2(map_f_1__0_), .A1(n948), .O(n666) );
  ND2S U1193 ( .I1(n1113), .I2(n1112), .O(N712) );
  ND2S U1194 ( .I1(n1107), .I2(n1106), .O(N713) );
  ND2S U1195 ( .I1(n1099), .I2(n1098), .O(N714) );
  AO12S U1196 ( .B1(n1521), .B2(n1483), .A1(n996), .O(n928) );
  ND2S U1197 ( .I1(n995), .I2(n994), .O(n996) );
  ND2S U1198 ( .I1(n993), .I2(n1137), .O(n994) );
  ND2S U1199 ( .I1(n1121), .I2(n1120), .O(N715) );
  AO12S U1200 ( .B1(n1516), .B2(n1483), .A1(n985), .O(n929) );
  ND2S U1201 ( .I1(n984), .I2(n983), .O(n985) );
  ND2S U1202 ( .I1(n982), .I2(n1137), .O(n983) );
  ND2S U1203 ( .I1(n1139), .I2(n1138), .O(N716) );
  AO12S U1204 ( .B1(n1511), .B2(n1483), .A1(n973), .O(n930) );
  ND2S U1205 ( .I1(n972), .I2(n971), .O(n973) );
  ND2S U1206 ( .I1(n970), .I2(n1137), .O(n971) );
  ND2S U1207 ( .I1(n1129), .I2(n1128), .O(N717) );
  AO12S U1208 ( .B1(n1506), .B2(n1483), .A1(n962), .O(n931) );
  ND2S U1209 ( .I1(n961), .I2(n960), .O(n962) );
  ND2S U1210 ( .I1(n959), .I2(n1137), .O(n960) );
  ND2S U1211 ( .I1(n1559), .I2(cnt_f[0]), .O(n1541) );
  AO12S U1212 ( .B1(n1526), .B2(n1483), .A1(n1007), .O(n927) );
  ND2S U1213 ( .I1(n1006), .I2(n1005), .O(n1007) );
  ND2S U1214 ( .I1(n1004), .I2(n1137), .O(n1005) );
  AO12S U1215 ( .B1(n1534), .B2(n1483), .A1(n1018), .O(n926) );
  ND2S U1216 ( .I1(n1017), .I2(n1016), .O(n1018) );
  ND2S U1217 ( .I1(n1015), .I2(n1137), .O(n1016) );
  ND2S U1218 ( .I1(n1248), .I2(in_valid), .O(n1249) );
  AO12S U1219 ( .B1(n936), .B2(n1248), .A1(n935), .O(n1757) );
  AN3S U1220 ( .I1(in_valid), .I2(tetrominoes[2]), .I3(n1145), .O(n1763) );
  ND3S U1221 ( .I1(n1043), .I2(n1042), .I3(n1041), .O(n730) );
  ND3S U1222 ( .I1(n1061), .I2(n1060), .I3(n1059), .O(n731) );
  ND3S U1223 ( .I1(n1076), .I2(n1070), .I3(n1069), .O(n732) );
  ND2S U1224 ( .I1(n1561), .I2(tetrominoes_map_f[3]), .O(n1069) );
  ND3S U1225 ( .I1(n1046), .I2(n1045), .I3(n1044), .O(n736) );
  ND3S U1226 ( .I1(n1053), .I2(n1052), .I3(n1051), .O(n737) );
  ND3S U1227 ( .I1(n1084), .I2(n1083), .I3(n1082), .O(n738) );
  OR2S U1228 ( .I1(n1081), .I2(n798), .O(n1084) );
  ND2S U1229 ( .I1(n1557), .I2(tetrominoes_map_f[6]), .O(n1565) );
  ND2S U1230 ( .I1(n1144), .I2(n1143), .O(n740) );
  ND2S U1231 ( .I1(n1258), .I2(n1558), .O(n1142) );
  ND3S U1232 ( .I1(n1022), .I2(n1021), .I3(n1554), .O(n741) );
  ND2S U1233 ( .I1(tetrominoes_map_f[12]), .I2(n1562), .O(n1022) );
  ND3S U1234 ( .I1(n1050), .I2(n1049), .I3(n1048), .O(n742) );
  ND3S U1235 ( .I1(n1080), .I2(n1079), .I3(n1078), .O(n744) );
  OR2S U1236 ( .I1(n1077), .I2(n798), .O(n1080) );
  ND2S U1237 ( .I1(n1093), .I2(n1092), .O(n745) );
  ND2S U1238 ( .I1(n1141), .I2(n1140), .O(n746) );
  ND3S U1239 ( .I1(n1036), .I2(n1035), .I3(n1034), .O(n748) );
  ND2S U1240 ( .I1(n1047), .I2(tetrominoes_map_f[18]), .O(n1036) );
  ND3S U1241 ( .I1(n1040), .I2(n1039), .I3(n1038), .O(n749) );
  ND2S U1242 ( .I1(n1058), .I2(tetrominoes_map_f[18]), .O(n1040) );
  ND2S U1243 ( .I1(n1091), .I2(n1090), .O(n750) );
  ND2S U1244 ( .I1(n1037), .I2(tetrominoes_map_f[19]), .O(n1476) );
  ND2S U1245 ( .I1(n1561), .I2(tetrominoes_map_f[20]), .O(n1477) );
  INV1S U1246 ( .I(col_top_f[16]), .O(n828) );
  INV6 U1247 ( .I(n886), .O(n1356) );
  OR2 U1248 ( .I1(n830), .I2(n1308), .O(n795) );
  AN2 U1249 ( .I1(col_top_f[16]), .I2(n1358), .O(n796) );
  XNR2HS U1250 ( .I1(bottom_f[4]), .I2(bottom_f[2]), .O(n1350) );
  XOR2HS U1251 ( .I1(bottom_f[0]), .I2(bottom_f[3]), .O(n797) );
  INV1S U1252 ( .I(bottom_f[7]), .O(n1294) );
  NR2P U1253 ( .I1(n1536), .I2(n836), .O(n1037) );
  INV1S U1254 ( .I(bottom_f[4]), .O(n1334) );
  INV1S U1255 ( .I(col_top_f[10]), .O(n893) );
  BUF6 U1256 ( .I(position_f[1]), .O(n921) );
  AN2 U1257 ( .I1(n1687), .I2(n803), .O(n1630) );
  NR2 U1258 ( .I1(n803), .I2(n1469), .O(n1707) );
  OR2T U1259 ( .I1(n1368), .I2(n817), .O(n801) );
  FA1P U1260 ( .A(n1769), .B(bottom_f[5]), .CI(n1348), .CO(n1368), .S(n1349)
         );
  OR2 U1261 ( .I1(n1334), .I2(n769), .O(n1408) );
  INV1 U1262 ( .I(n1408), .O(n861) );
  OAI12HS U1263 ( .B1(n764), .B2(n861), .A1(n1395), .O(n1396) );
  INV1S U1264 ( .I(n820), .O(n806) );
  INV2 U1265 ( .I(n821), .O(n820) );
  ND2P U1266 ( .I1(n1455), .I2(n1456), .O(n1465) );
  NR2P U1267 ( .I1(n908), .I2(n906), .O(n837) );
  NR2P U1268 ( .I1(n1303), .I2(n1307), .O(n876) );
  INV1S U1269 ( .I(n935), .O(n808) );
  MOAI1HP U1270 ( .A1(n809), .A2(n797), .B1(n1371), .B2(n1365), .O(n858) );
  NR2T U1271 ( .I1(n1365), .I2(n1371), .O(n809) );
  INV2 U1272 ( .I(n810), .O(n880) );
  NR2P U1273 ( .I1(n1346), .I2(n1296), .O(n810) );
  NR2T U1274 ( .I1(n1318), .I2(n1317), .O(n1322) );
  NR2F U1275 ( .I1(n1343), .I2(n1342), .O(n1394) );
  NR2P U1276 ( .I1(n1295), .I2(n1296), .O(n811) );
  ND3HT U1277 ( .I1(n842), .I2(n843), .I3(n841), .O(n1308) );
  INV1 U1278 ( .I(bottom_f[0]), .O(n1373) );
  NR2F U1279 ( .I1(n1373), .I2(n1333), .O(n1389) );
  BUF12CK U1280 ( .I(n1025), .O(n1352) );
  MOAI1HT U1281 ( .A1(n812), .A2(n863), .B1(n868), .B2(n1349), .O(n817) );
  NR2F U1282 ( .I1(n1349), .I2(n868), .O(n812) );
  NR2F U1283 ( .I1(bottom_f[1]), .I2(n1376), .O(n1390) );
  ND2P U1284 ( .I1(n1344), .I2(col_top_f[22]), .O(n843) );
  ND3HT U1285 ( .I1(n1329), .I2(n1330), .I3(n1328), .O(n1371) );
  NR2F U1286 ( .I1(n1389), .I2(n1388), .O(n887) );
  INV3 U1287 ( .I(n1365), .O(n1333) );
  INV12 U1288 ( .I(n1356), .O(n1344) );
  ND3P U1289 ( .I1(n835), .I2(n834), .I3(n833), .O(n865) );
  INV6 U1290 ( .I(n1347), .O(n1359) );
  NR2F U1291 ( .I1(n1324), .I2(n1323), .O(n911) );
  INV2 U1292 ( .I(n903), .O(n839) );
  ND3HT U1293 ( .I1(n1336), .I2(n814), .I3(n1337), .O(n868) );
  AOI22H U1294 ( .A1(n1357), .A2(col_top_f[23]), .B1(n1344), .B2(col_top_f[15]), .O(n814) );
  NR2F U1295 ( .I1(n919), .I2(n912), .O(n916) );
  ND2T U1296 ( .I1(n855), .I2(n854), .O(n853) );
  MOAI1HP U1297 ( .A1(n1322), .A2(n1321), .B1(n816), .B2(n1405), .O(n1323) );
  NR2F U1298 ( .I1(n1368), .I2(n817), .O(n919) );
  ND2 U1299 ( .I1(n1352), .I2(col_top_f[17]), .O(n818) );
  ND2 U1300 ( .I1(n818), .I2(n902), .O(n901) );
  ND2P U1301 ( .I1(n1386), .I2(n820), .O(n1409) );
  XNR2HS U1302 ( .I1(n806), .I2(n1386), .O(n1379) );
  ND3HT U1303 ( .I1(n881), .I2(n880), .I3(n910), .O(n825) );
  ND3 U1304 ( .I1(n881), .I2(n910), .I3(n765), .O(n822) );
  INV1S U1305 ( .I(n880), .O(n823) );
  NR2P U1306 ( .I1(n1769), .I2(n782), .O(n1401) );
  MOAI1H U1307 ( .A1(n769), .A2(n824), .B1(n1350), .B2(n825), .O(n1366) );
  ND2 U1308 ( .I1(n1299), .I2(n1298), .O(n826) );
  ND3 U1309 ( .I1(n827), .I2(n1287), .I3(n844), .O(n1288) );
  INV2 U1310 ( .I(n907), .O(n827) );
  MOAI1HP U1311 ( .A1(n829), .A2(n828), .B1(n849), .B2(n850), .O(n907) );
  OAI112HP U1312 ( .C1(n877), .C2(n832), .A1(n831), .B1(n795), .O(n1420) );
  NR2F U1313 ( .I1(n1294), .I2(n1308), .O(n874) );
  NR2T U1314 ( .I1(bottom_f[8]), .I2(n875), .O(n832) );
  ND3HT U1315 ( .I1(n878), .I2(n1309), .I3(n1310), .O(n877) );
  NR2P U1316 ( .I1(n907), .I2(n905), .O(n838) );
  XNR2HS U1317 ( .I1(bottom_f[7]), .I2(n1308), .O(n840) );
  ND2 U1318 ( .I1(n1359), .I2(col_top_f[10]), .O(n841) );
  ND3P U1319 ( .I1(n1287), .I2(bottom_f[6]), .I3(n844), .O(n900) );
  ND3 U1320 ( .I1(n1287), .I2(n904), .I3(n844), .O(n903) );
  AOI22H U1321 ( .A1(n1344), .A2(col_top_f[13]), .B1(n852), .B2(col_top_f[5]), 
        .O(n1361) );
  ND2F U1322 ( .I1(n1030), .I2(n788), .O(n847) );
  NR2F U1323 ( .I1(n921), .I2(n847), .O(n882) );
  INV1S U1324 ( .I(n847), .O(n849) );
  INV2 U1325 ( .I(n848), .O(n855) );
  ND3HT U1326 ( .I1(n1362), .I2(n1361), .I3(n1360), .O(n1374) );
  NR2 U1327 ( .I1(n851), .I2(n921), .O(n850) );
  INV1S U1328 ( .I(col_top_f[12]), .O(n851) );
  BUF1CK U1329 ( .I(n882), .O(n852) );
  ND2S U1330 ( .I1(n882), .I2(col_top_f[11]), .O(n1340) );
  AOI22S U1331 ( .A1(n1358), .A2(col_top_f[22]), .B1(n882), .B2(col_top_f[10]), 
        .O(n892) );
  AOI22S U1332 ( .A1(n882), .A2(col_top_f[4]), .B1(n1357), .B2(col_top_f[20]), 
        .O(n884) );
  AOI22S U1333 ( .A1(n882), .A2(col_top_f[8]), .B1(n888), .B2(col_top_f[16]), 
        .O(n1329) );
  NR2F U1334 ( .I1(n856), .I2(n853), .O(n924) );
  ND2T U1335 ( .I1(n917), .I2(n879), .O(n854) );
  NR2F U1336 ( .I1(n858), .I2(n857), .O(n856) );
  NR2T U1337 ( .I1(n1374), .I2(n859), .O(n857) );
  XNR2H U1338 ( .I1(n781), .I2(n862), .O(n1367) );
  XNR2H U1339 ( .I1(n1349), .I2(n1394), .O(n862) );
  BUF1S U1340 ( .I(n1381), .O(n864) );
  OAI12HP U1341 ( .B1(n1367), .B2(n1366), .A1(n916), .O(n925) );
  NR2F U1342 ( .I1(n907), .I2(n900), .O(n1310) );
  NR2P U1343 ( .I1(n1385), .I2(n1320), .O(n1321) );
  MXL2H U1344 ( .A(n1393), .B(n1392), .S(n1433), .OB(n1426) );
  OAI12HP U1345 ( .B1(n1345), .B2(n1354), .A1(n895), .O(n894) );
  NR2T U1346 ( .I1(n1375), .I2(n1374), .O(n1388) );
  ND3HT U1347 ( .I1(n1440), .I2(n1455), .I3(n1456), .O(n1447) );
  NR2F U1348 ( .I1(n1390), .I2(n887), .O(n1400) );
  ND2P U1349 ( .I1(n884), .I2(n885), .O(n866) );
  ND3HT U1350 ( .I1(n1425), .I2(n1424), .I3(n920), .O(n1440) );
  INV8 U1351 ( .I(position_f[2]), .O(n1030) );
  OAI12HT U1352 ( .B1(n925), .B2(n924), .A1(n923), .O(n1433) );
  NR3HT U1353 ( .I1(n883), .I2(n796), .I3(n866), .O(n1365) );
  INV2 U1354 ( .I(n1356), .O(n888) );
  ND3P U1355 ( .I1(n1414), .I2(n1413), .I3(n1412), .O(n1430) );
  MXL2H U1356 ( .A(n1429), .B(n1431), .S(n1433), .OB(n1464) );
  MXL2HS U1357 ( .A(n1442), .B(n807), .S(n1447), .OB(n1445) );
  MXL2HP U1358 ( .A(n1430), .B(n1432), .S(n1433), .OB(n1436) );
  MXL2H U1359 ( .A(n1370), .B(n1369), .S(n1433), .OB(n1441) );
  NR2P U1360 ( .I1(n1334), .I2(bottom_f[2]), .O(n1348) );
  NR2T U1361 ( .I1(n869), .I2(n894), .O(n881) );
  ND2P U1362 ( .I1(n871), .I2(n870), .O(n869) );
  ND2P U1363 ( .I1(n1358), .I2(col_top_f[18]), .O(n870) );
  ND2P U1364 ( .I1(n1352), .I2(col_top_f[10]), .O(n871) );
  MAO222 U1365 ( .A1(n1316), .B1(n1380), .C1(n1381), .O(n1317) );
  ND3HT U1366 ( .I1(n920), .I2(n1427), .I3(n1457), .O(n1455) );
  BUF1S U1367 ( .I(n1458), .O(n872) );
  NR3HT U1368 ( .I1(n905), .I2(n901), .I3(n906), .O(n1309) );
  ND2F U1369 ( .I1(n1030), .I2(n1027), .O(n1347) );
  BUF6 U1370 ( .I(n1347), .O(n1354) );
  ND2P U1371 ( .I1(n1458), .I2(n1426), .O(n1424) );
  MXL2H U1372 ( .A(n1385), .B(n1384), .S(n1325), .OB(n1458) );
  MOAI1H U1373 ( .A1(n876), .A2(bottom_f[10]), .B1(n1307), .B2(n1303), .O(
        n1421) );
  INV1 U1374 ( .I(bottom_f[1]), .O(n1375) );
  ND2P U1375 ( .I1(n1308), .I2(n1294), .O(n878) );
  NR2F U1376 ( .I1(n917), .I2(n879), .O(n912) );
  INV2 U1377 ( .I(n1421), .O(n1422) );
  ND2T U1378 ( .I1(n1423), .I2(n1422), .O(n1428) );
  ND2P U1379 ( .I1(n888), .I2(col_top_f[20]), .O(n1287) );
  BUF6 U1380 ( .I(n1030), .O(n1147) );
  NR2F U1381 ( .I1(n1028), .I2(n1147), .O(n1358) );
  AOI13HP U1382 ( .B1(n801), .B2(n1367), .B3(n1366), .A1(n896), .O(n923) );
  INV1S U1383 ( .I(n815), .O(n1331) );
  NR2T U1384 ( .I1(n1313), .I2(n1296), .O(n906) );
  NR2F U1385 ( .I1(n909), .I2(n911), .O(n1325) );
  INV4 U1386 ( .I(n1305), .O(n909) );
  MXL2H U1387 ( .A(n1406), .B(n1407), .S(n1305), .OB(n1467) );
  INV2 U1388 ( .I(n914), .O(n913) );
  NR2 U1389 ( .I1(bottom_f[1]), .I2(n1351), .O(n918) );
  OAI12H U1390 ( .B1(n922), .B2(n1473), .A1(n1472), .O(n729) );
  ND3S U1391 ( .I1(n1269), .I2(n1730), .I3(n1625), .O(n1265) );
  INV1S U1392 ( .I(bottom_compare_f_2_), .O(n949) );
  ND3S U1393 ( .I1(n1734), .I2(n1736), .I3(n1612), .O(n1280) );
  ND3S U1394 ( .I1(n1127), .I2(n1126), .I3(n1125), .O(n1507) );
  NR2 U1395 ( .I1(n803), .I2(n1688), .O(n1647) );
  INV1S U1396 ( .I(col_top_f[7]), .O(n1338) );
  OR2 U1397 ( .I1(n1689), .I2(n1575), .O(n1729) );
  OR2 U1398 ( .I1(n1689), .I2(n1574), .O(n1726) );
  OR2 U1399 ( .I1(n1689), .I2(n1573), .O(n1723) );
  OR2 U1400 ( .I1(n1689), .I2(n1572), .O(n1720) );
  NR2 U1401 ( .I1(n1747), .I2(n1633), .O(n1642) );
  ND3S U1402 ( .I1(n1056), .I2(n1055), .I3(n1054), .O(n743) );
  XOR2HS U1403 ( .I1(state[1]), .I2(state[0]), .O(n1758) );
  INV1S U1404 ( .I(n1259), .O(n932) );
  INV1S U1405 ( .I(tetrominoes[2]), .O(n1062) );
  ND3S U1406 ( .I1(n932), .I2(n1553), .I3(n1062), .O(n1755) );
  OR2 U1407 ( .I1(tetrominoes[0]), .I2(n1062), .O(n1258) );
  INV1CK U1408 ( .I(n1258), .O(n934) );
  NR2 U1409 ( .I1(tetrominoes[2]), .I2(n1553), .O(n936) );
  NR2 U1410 ( .I1(n936), .I2(n934), .O(n1085) );
  NR2 U1411 ( .I1(n1248), .I2(n1085), .O(n1552) );
  INV1S U1412 ( .I(n1552), .O(n933) );
  OAI112HS U1413 ( .C1(tetrominoes[1]), .C2(n934), .A1(n933), .B1(in_valid), 
        .O(n1756) );
  INV1S U1414 ( .I(in_valid), .O(n935) );
  INV1S U1415 ( .I(n936), .O(n1474) );
  NR2 U1416 ( .I1(n1259), .I2(n1474), .O(n1759) );
  NR2 U1417 ( .I1(map_f_12__0_), .I2(map_f_12__1_), .O(n939) );
  NR3 U1418 ( .I1(map_f_12__5_), .I2(map_f_12__2_), .I3(map_f_12__3_), .O(n938) );
  INV1S U1419 ( .I(map_f_12__4_), .O(n1584) );
  OR2 U1420 ( .I1(n1770), .I2(n941), .O(n943) );
  NR2 U1421 ( .I1(cnt_f[0]), .I2(cnt_f[3]), .O(n940) );
  INV1S U1422 ( .I(cnt_f[2]), .O(n1546) );
  INV1S U1423 ( .I(cnt_f[1]), .O(n1544) );
  OAI12HS U1424 ( .B1(n1161), .B2(n1482), .A1(n1545), .O(n1760) );
  ND2S U1425 ( .I1(n941), .I2(n1770), .O(n942) );
  BUF4 U1426 ( .I(n942), .O(n1562) );
  AN2T U1427 ( .I1(n943), .I2(n1562), .O(n1749) );
  INV4 U1428 ( .I(n1749), .O(n1762) );
  OR2 U1429 ( .I1(state[1]), .I2(state[2]), .O(n1150) );
  NR2 U1430 ( .I1(state[0]), .I2(n1150), .O(n1160) );
  AOI22S U1431 ( .A1(n1160), .A2(n1161), .B1(n1770), .B2(n1758), .O(n944) );
  OR2 U1432 ( .I1(n802), .I2(n1688), .O(n1671) );
  NR2 U1433 ( .I1(row_f[3]), .I2(tetrominoes_map_f[3]), .O(n1574) );
  NR2 U1434 ( .I1(row_f[4]), .I2(tetrominoes_map_f[4]), .O(n1573) );
  NR2 U1435 ( .I1(row_f[2]), .I2(tetrominoes_map_f[2]), .O(n1575) );
  NR2 U1436 ( .I1(row_f[5]), .I2(tetrominoes_map_f[5]), .O(n1572) );
  NR2 U1437 ( .I1(n1575), .I2(n1572), .O(n945) );
  NR3H U1438 ( .I1(n1574), .I2(n1573), .I3(n946), .O(n1746) );
  NR2F U1439 ( .I1(n1762), .I2(n1746), .O(n1739) );
  MOAI1S U1440 ( .A1(n1130), .A2(n1762), .B1(n1739), .B2(n805), .O(n947) );
  INV1S U1441 ( .I(map_f_1__0_), .O(n1685) );
  INV1S U1442 ( .I(map_f_2__0_), .O(n1660) );
  ND2P U1443 ( .I1(n1746), .I2(n1749), .O(n1740) );
  OAI22S U1444 ( .A1(n1660), .A2(n1667), .B1(n1670), .B2(n1737), .O(n948) );
  NR2F U1445 ( .I1(N964), .I2(n949), .O(n1687) );
  AN2P U1446 ( .I1(n1687), .I2(n802), .O(n1616) );
  INV1S U1447 ( .I(map_f_1__5_), .O(n1673) );
  MOAI1S U1448 ( .A1(n1673), .A2(n1671), .B1(map_f_3__5_), .B2(n1647), .O(n953) );
  OR2 U1449 ( .I1(bottom_compare_f_2_), .I2(n1715), .O(n979) );
  ND2S U1450 ( .I1(map_f_11__5_), .I2(n1707), .O(n951) );
  NR2P U1451 ( .I1(n802), .I2(n979), .O(n1591) );
  AOI22S U1452 ( .A1(map_f_9__5_), .A2(n1591), .B1(map_f_5__5_), .B2(n1630), 
        .O(n950) );
  INV1S U1453 ( .I(state[0]), .O(n1019) );
  ND3S U1454 ( .I1(n1770), .I2(n1019), .I3(state[1]), .O(n954) );
  NR2P U1455 ( .I1(n805), .I2(n1536), .O(n1483) );
  NR2P U1456 ( .I1(n804), .I2(n1536), .O(n1535) );
  AN2 U1457 ( .I1(n1535), .I2(n802), .O(n1136) );
  INV1S U1458 ( .I(map_f_10__5_), .O(n1719) );
  AOI22S U1459 ( .A1(n1687), .A2(map_f_6__5_), .B1(map_f_2__5_), .B2(n1648), 
        .O(n955) );
  OAI112HS U1460 ( .C1(n1719), .C2(n979), .A1(n955), .B1(n956), .O(n1505) );
  AOI22S U1461 ( .A1(n1136), .A2(n1505), .B1(row_f[11]), .B2(n1536), .O(n961)
         );
  INV1S U1462 ( .I(map_f_8__5_), .O(n1602) );
  AOI22S U1463 ( .A1(n1687), .A2(map_f_4__5_), .B1(map_f_0__5_), .B2(n1648), 
        .O(n957) );
  OAI112HS U1464 ( .C1(n1602), .C2(n1469), .A1(n957), .B1(n956), .O(n959) );
  NR2 U1465 ( .I1(n804), .I2(n802), .O(n1631) );
  INV1S U1466 ( .I(n1631), .O(n958) );
  NR2 U1467 ( .I1(n958), .I2(n1536), .O(n1137) );
  INV1S U1468 ( .I(map_f_1__4_), .O(n1675) );
  MOAI1S U1469 ( .A1(n1675), .A2(n1671), .B1(map_f_3__4_), .B2(n1647), .O(n966) );
  ND2S U1470 ( .I1(map_f_11__4_), .I2(n1707), .O(n9640) );
  AOI22S U1471 ( .A1(map_f_9__4_), .A2(n1591), .B1(map_f_5__4_), .B2(n1630), 
        .O(n963) );
  INV1S U1472 ( .I(map_f_10__4_), .O(n1722) );
  AOI22S U1473 ( .A1(n1687), .A2(map_f_6__4_), .B1(map_f_2__4_), .B2(n1648), 
        .O(n967) );
  OAI112HS U1474 ( .C1(n1722), .C2(n979), .A1(n967), .B1(n968), .O(n1510) );
  AOI22S U1475 ( .A1(n1136), .A2(n1510), .B1(row_f[10]), .B2(n1536), .O(n972)
         );
  INV1S U1476 ( .I(map_f_8__4_), .O(n1604) );
  AOI22S U1477 ( .A1(n1687), .A2(map_f_4__4_), .B1(map_f_0__4_), .B2(n1648), 
        .O(n969) );
  OAI112HS U1478 ( .C1(n1604), .C2(n1469), .A1(n969), .B1(n968), .O(n970) );
  INV1S U1479 ( .I(map_f_1__3_), .O(n1677) );
  MOAI1S U1480 ( .A1(n1677), .A2(n1671), .B1(map_f_3__3_), .B2(n1647), .O(n977) );
  ND2S U1481 ( .I1(map_f_11__3_), .I2(n1707), .O(n975) );
  AOI22S U1482 ( .A1(map_f_9__3_), .A2(n1591), .B1(map_f_5__3_), .B2(n1630), 
        .O(n974) );
  INV1S U1483 ( .I(map_f_10__3_), .O(n1725) );
  AOI22S U1484 ( .A1(n1687), .A2(map_f_6__3_), .B1(map_f_2__3_), .B2(n1648), 
        .O(n978) );
  OAI112HS U1485 ( .C1(n1725), .C2(n979), .A1(n978), .B1(n980), .O(n1515) );
  AOI22S U1486 ( .A1(n1136), .A2(n1515), .B1(row_f[9]), .B2(n1536), .O(n984)
         );
  INV1S U1487 ( .I(map_f_8__3_), .O(n1606) );
  AOI22S U1488 ( .A1(n1687), .A2(map_f_4__3_), .B1(map_f_0__3_), .B2(n1648), 
        .O(n981) );
  OAI112HS U1489 ( .C1(n1606), .C2(n1469), .A1(n981), .B1(n980), .O(n982) );
  INV1S U1490 ( .I(map_f_1__2_), .O(n1679) );
  MOAI1S U1491 ( .A1(n1679), .A2(n1671), .B1(map_f_3__2_), .B2(n1647), .O(n989) );
  ND2S U1492 ( .I1(map_f_11__2_), .I2(n1707), .O(n987) );
  AOI22S U1493 ( .A1(map_f_9__2_), .A2(n1591), .B1(map_f_5__2_), .B2(n1630), 
        .O(n986) );
  INV1S U1494 ( .I(map_f_10__2_), .O(n1728) );
  AOI22S U1495 ( .A1(n1687), .A2(map_f_6__2_), .B1(map_f_2__2_), .B2(n1648), 
        .O(n990) );
  OAI112HS U1496 ( .C1(n1728), .C2(n1469), .A1(n990), .B1(n991), .O(n1520) );
  AOI22S U1497 ( .A1(n1136), .A2(n1520), .B1(row_f[8]), .B2(n1536), .O(n995)
         );
  INV1S U1498 ( .I(map_f_8__2_), .O(n1608) );
  AOI22S U1499 ( .A1(n1687), .A2(map_f_4__2_), .B1(map_f_0__2_), .B2(n1648), 
        .O(n992) );
  OAI112HS U1500 ( .C1(n1608), .C2(n1469), .A1(n992), .B1(n991), .O(n993) );
  INV1S U1501 ( .I(map_f_1__1_), .O(n1681) );
  MOAI1S U1502 ( .A1(n1681), .A2(n1671), .B1(map_f_3__1_), .B2(n1647), .O(
        n1000) );
  ND2S U1503 ( .I1(map_f_11__1_), .I2(n1707), .O(n998) );
  AOI22S U1504 ( .A1(map_f_9__1_), .A2(n1591), .B1(map_f_5__1_), .B2(n1630), 
        .O(n997) );
  INV1S U1505 ( .I(map_f_10__1_), .O(n1731) );
  AOI22S U1506 ( .A1(n1687), .A2(map_f_6__1_), .B1(map_f_2__1_), .B2(n1648), 
        .O(n1001) );
  OAI112HS U1507 ( .C1(n1731), .C2(n1469), .A1(n1001), .B1(n1002), .O(n1525)
         );
  AOI22S U1508 ( .A1(n1136), .A2(n1525), .B1(row_f[7]), .B2(n1536), .O(n1006)
         );
  INV1S U1509 ( .I(map_f_8__1_), .O(n1610) );
  AOI22S U1510 ( .A1(n1687), .A2(map_f_4__1_), .B1(map_f_0__1_), .B2(n1648), 
        .O(n1003) );
  OAI112HS U1511 ( .C1(n1610), .C2(n1469), .A1(n1003), .B1(n1002), .O(n1004)
         );
  MOAI1S U1512 ( .A1(n1685), .A2(n1671), .B1(map_f_3__0_), .B2(n1647), .O(
        n1011) );
  ND2S U1513 ( .I1(map_f_11__0_), .I2(n1707), .O(n1009) );
  AOI22S U1514 ( .A1(map_f_9__0_), .A2(n1591), .B1(map_f_5__0_), .B2(n1630), 
        .O(n1008) );
  INV1S U1515 ( .I(map_f_10__0_), .O(n1736) );
  AOI22S U1516 ( .A1(n1687), .A2(map_f_6__0_), .B1(map_f_2__0_), .B2(n1648), 
        .O(n1012) );
  OAI112HS U1517 ( .C1(n1736), .C2(n1469), .A1(n1012), .B1(n1013), .O(n1531)
         );
  AOI22S U1518 ( .A1(n1136), .A2(n1531), .B1(row_f[6]), .B2(n1536), .O(n1017)
         );
  INV1S U1519 ( .I(map_f_8__0_), .O(n1614) );
  AOI22S U1520 ( .A1(n1687), .A2(map_f_4__0_), .B1(map_f_0__0_), .B2(n1648), 
        .O(n1014) );
  OAI112HS U1521 ( .C1(n1614), .C2(n1469), .A1(n1014), .B1(n1013), .O(n1015)
         );
  ND2P U1522 ( .I1(in_valid), .I2(n1160), .O(n1559) );
  NR2F U1523 ( .I1(position_f[1]), .I2(n788), .O(n1027) );
  NR2 U1524 ( .I1(n1019), .I2(n1150), .O(n1057) );
  MOAI1S U1525 ( .A1(n1258), .A2(n1559), .B1(tetrominoes_map_f[6]), .B2(n1561), 
        .O(n1020) );
  INV1S U1526 ( .I(n1020), .O(n1021) );
  INV3 U1527 ( .I(n1559), .O(n1551) );
  BUF1 U1528 ( .I(n767), .O(n1764) );
  BUF1 U1529 ( .I(rst_n), .O(n1767) );
  BUF1 U1530 ( .I(n767), .O(n1765) );
  BUF1 U1531 ( .I(n767), .O(n1766) );
  ND2 U1532 ( .I1(position_f[2]), .I2(n788), .O(n1023) );
  INV1S U1533 ( .I(n1357), .O(n1024) );
  NR2 U1534 ( .I1(n1536), .I2(n1024), .O(n1047) );
  NR2 U1535 ( .I1(n1536), .I2(n1312), .O(n1026) );
  NR2 U1536 ( .I1(n1536), .I2(n1331), .O(n1058) );
  AOI22S U1537 ( .A1(n1557), .A2(tetrominoes_map_f[21]), .B1(n1058), .B2(
        tetrominoes_map_f[19]), .O(n1035) );
  INV1S U1538 ( .I(tetrominoes_map_f[23]), .O(n1029) );
  NR2 U1539 ( .I1(n1029), .I2(n1473), .O(n1033) );
  INV1S U1540 ( .I(tetrominoes_map_f[20]), .O(n1031) );
  NR2 U1541 ( .I1(n1031), .I2(n798), .O(n1032) );
  NR2 U1542 ( .I1(n1033), .I2(n1032), .O(n1034) );
  INV1S U1543 ( .I(n798), .O(n1089) );
  AOI22S U1544 ( .A1(n1037), .A2(tetrominoes_map_f[21]), .B1(n1089), .B2(
        tetrominoes_map_f[19]), .O(n1039) );
  AOI22S U1545 ( .A1(n1057), .A2(tetrominoes_map_f[22]), .B1(n1557), .B2(
        tetrominoes_map_f[20]), .O(n1038) );
  AOI22S U1546 ( .A1(n1057), .A2(tetrominoes_map_f[5]), .B1(
        tetrominoes_map_f[11]), .B2(n1562), .O(n1043) );
  AOI22S U1547 ( .A1(n1047), .A2(tetrominoes_map_f[0]), .B1(n1089), .B2(
        tetrominoes_map_f[2]), .O(n1042) );
  AOI22S U1548 ( .A1(n1557), .A2(tetrominoes_map_f[3]), .B1(n1058), .B2(
        tetrominoes_map_f[1]), .O(n1041) );
  AOI22S U1549 ( .A1(tetrominoes_map_f[11]), .A2(n1057), .B1(
        tetrominoes_map_f[17]), .B2(n1562), .O(n1046) );
  AOI22S U1550 ( .A1(n1047), .A2(tetrominoes_map_f[6]), .B1(n1089), .B2(
        tetrominoes_map_f[8]), .O(n1045) );
  AOI22S U1551 ( .A1(n1557), .A2(tetrominoes_map_f[9]), .B1(n1058), .B2(
        tetrominoes_map_f[7]), .O(n1044) );
  AOI22S U1552 ( .A1(tetrominoes_map_f[17]), .A2(n1057), .B1(
        tetrominoes_map_f[23]), .B2(n1562), .O(n1050) );
  AOI22S U1553 ( .A1(n1047), .A2(tetrominoes_map_f[12]), .B1(n1089), .B2(
        tetrominoes_map_f[14]), .O(n1049) );
  AOI22S U1554 ( .A1(n1557), .A2(tetrominoes_map_f[15]), .B1(n1058), .B2(
        tetrominoes_map_f[13]), .O(n1048) );
  AOI22S U1555 ( .A1(tetrominoes_map_f[10]), .A2(n1057), .B1(
        tetrominoes_map_f[16]), .B2(n1562), .O(n1053) );
  AOI22S U1556 ( .A1(n1058), .A2(tetrominoes_map_f[6]), .B1(n1089), .B2(
        tetrominoes_map_f[7]), .O(n1052) );
  AOI22S U1557 ( .A1(n1557), .A2(tetrominoes_map_f[8]), .B1(n1037), .B2(
        tetrominoes_map_f[9]), .O(n1051) );
  AOI22S U1558 ( .A1(tetrominoes_map_f[16]), .A2(n1057), .B1(
        tetrominoes_map_f[22]), .B2(n1562), .O(n1056) );
  AOI22S U1559 ( .A1(n1058), .A2(tetrominoes_map_f[12]), .B1(n1089), .B2(
        tetrominoes_map_f[13]), .O(n1055) );
  AOI22S U1560 ( .A1(n1557), .A2(tetrominoes_map_f[14]), .B1(n1037), .B2(
        tetrominoes_map_f[15]), .O(n1054) );
  AOI22S U1561 ( .A1(n1057), .A2(tetrominoes_map_f[4]), .B1(
        tetrominoes_map_f[10]), .B2(n1562), .O(n1061) );
  AOI22S U1562 ( .A1(n1058), .A2(tetrominoes_map_f[0]), .B1(
        tetrominoes_map_f[1]), .B2(n1089), .O(n1060) );
  AOI22S U1563 ( .A1(n1557), .A2(tetrominoes_map_f[2]), .B1(n1037), .B2(
        tetrominoes_map_f[3]), .O(n1059) );
  NR2 U1564 ( .I1(tetrominoes[0]), .I2(n1248), .O(n1063) );
  ND3S U1565 ( .I1(n1551), .I2(n1063), .I3(n1062), .O(n1076) );
  INV1S U1566 ( .I(tetrominoes_map_f[0]), .O(n1064) );
  MOAI1S U1567 ( .A1(n1064), .A2(n798), .B1(n1557), .B2(tetrominoes_map_f[1]), 
        .O(n1068) );
  INV1S U1568 ( .I(n1562), .O(n1066) );
  INV1S U1569 ( .I(tetrominoes_map_f[9]), .O(n1065) );
  MOAI1S U1570 ( .A1(n1066), .A2(n1065), .B1(n1037), .B2(tetrominoes_map_f[2]), 
        .O(n1067) );
  NR2 U1571 ( .I1(n1068), .I2(n1067), .O(n1070) );
  ND2S U1572 ( .I1(n1037), .I2(tetrominoes_map_f[1]), .O(n1073) );
  ND2S U1573 ( .I1(n1561), .I2(tetrominoes_map_f[2]), .O(n1074) );
  INV1S U1574 ( .I(tetrominoes_map_f[12]), .O(n1077) );
  AOI22S U1575 ( .A1(n1037), .A2(tetrominoes_map_f[14]), .B1(n1561), .B2(
        tetrominoes_map_f[15]), .O(n1079) );
  AOI22S U1576 ( .A1(tetrominoes_map_f[21]), .A2(n1562), .B1(n1557), .B2(
        tetrominoes_map_f[13]), .O(n1078) );
  INV1S U1577 ( .I(tetrominoes_map_f[6]), .O(n1081) );
  AOI22S U1578 ( .A1(n1037), .A2(tetrominoes_map_f[8]), .B1(n1561), .B2(
        tetrominoes_map_f[9]), .O(n1083) );
  AOI22S U1579 ( .A1(tetrominoes_map_f[15]), .A2(n1562), .B1(n1557), .B2(
        tetrominoes_map_f[7]), .O(n1082) );
  AOI22S U1580 ( .A1(tetrominoes_map_f[7]), .A2(n1562), .B1(n1037), .B2(
        tetrominoes_map_f[0]), .O(n1087) );
  OAI12HS U1581 ( .B1(tetrominoes[1]), .B2(n1085), .A1(n1551), .O(n1086) );
  AOI22S U1582 ( .A1(n1037), .A2(tetrominoes_map_f[20]), .B1(n1561), .B2(
        tetrominoes_map_f[21]), .O(n1091) );
  AOI22S U1583 ( .A1(n1557), .A2(tetrominoes_map_f[19]), .B1(n1089), .B2(
        tetrominoes_map_f[18]), .O(n1090) );
  AOI22S U1584 ( .A1(n1037), .A2(tetrominoes_map_f[13]), .B1(n1561), .B2(
        tetrominoes_map_f[14]), .O(n1093) );
  AOI22S U1585 ( .A1(tetrominoes_map_f[20]), .A2(n1562), .B1(n1557), .B2(
        tetrominoes_map_f[12]), .O(n1092) );
  OAI12HS U1586 ( .B1(bottom_compare_f_2_), .B2(n802), .A1(N964), .O(n1599) );
  INV1S U1587 ( .I(n1599), .O(n1592) );
  AOI22S U1588 ( .A1(map_f_11__2_), .A2(n1591), .B1(n1592), .B2(map_f_12__2_), 
        .O(n1096) );
  AOI22S U1589 ( .A1(map_f_7__2_), .A2(n1630), .B1(map_f_3__2_), .B2(n1130), 
        .O(n1095) );
  AOI22S U1590 ( .A1(map_f_9__2_), .A2(n1616), .B1(map_f_5__2_), .B2(n1647), 
        .O(n1094) );
  ND3S U1591 ( .I1(n1096), .I2(n1095), .I3(n1094), .O(n1493) );
  AOI22S U1592 ( .A1(n1483), .A2(n1493), .B1(row_f[20]), .B2(n1536), .O(n1099)
         );
  INV1S U1593 ( .I(map_f_12__2_), .O(n1586) );
  AOI22S U1594 ( .A1(n1687), .A2(map_f_8__2_), .B1(n1648), .B2(map_f_4__2_), 
        .O(n1097) );
  OAI12HS U1595 ( .B1(n1586), .B2(n1715), .A1(n1097), .O(n1522) );
  AOI22S U1596 ( .A1(n1137), .A2(n1520), .B1(n1136), .B2(n1522), .O(n1098) );
  AOI22S U1597 ( .A1(map_f_11__1_), .A2(n1591), .B1(n1592), .B2(map_f_12__1_), 
        .O(n1102) );
  AOI22S U1598 ( .A1(map_f_7__1_), .A2(n1630), .B1(map_f_3__1_), .B2(n1130), 
        .O(n1101) );
  AOI22S U1599 ( .A1(map_f_9__1_), .A2(n1616), .B1(map_f_5__1_), .B2(n1647), 
        .O(n1100) );
  ND3S U1600 ( .I1(n1102), .I2(n1101), .I3(n1100), .O(n1496) );
  AOI22S U1601 ( .A1(n1483), .A2(n1496), .B1(row_f[19]), .B2(n1536), .O(n1107)
         );
  INV1S U1602 ( .I(map_f_12__1_), .O(n1587) );
  INV1S U1603 ( .I(map_f_4__1_), .O(n1701) );
  AOI22S U1604 ( .A1(n1137), .A2(n1525), .B1(n1136), .B2(n1527), .O(n1106) );
  AOI22S U1605 ( .A1(map_f_11__0_), .A2(n1591), .B1(n1592), .B2(map_f_12__0_), 
        .O(n1110) );
  AOI22S U1606 ( .A1(map_f_7__0_), .A2(n1630), .B1(map_f_3__0_), .B2(n1130), 
        .O(n1109) );
  AOI22S U1607 ( .A1(map_f_9__0_), .A2(n1616), .B1(map_f_5__0_), .B2(n1647), 
        .O(n1108) );
  ND3S U1608 ( .I1(n1110), .I2(n1109), .I3(n1108), .O(n1501) );
  AOI22S U1609 ( .A1(n1483), .A2(n1501), .B1(row_f[18]), .B2(n1536), .O(n1113)
         );
  INV1S U1610 ( .I(map_f_12__0_), .O(n1590) );
  AOI22S U1611 ( .A1(n1687), .A2(map_f_8__0_), .B1(n1648), .B2(map_f_4__0_), 
        .O(n1111) );
  OAI12HS U1612 ( .B1(n1590), .B2(n1715), .A1(n1111), .O(n1537) );
  AOI22S U1613 ( .A1(n1137), .A2(n1531), .B1(n1136), .B2(n1537), .O(n1112) );
  AOI22S U1614 ( .A1(map_f_11__3_), .A2(n1591), .B1(n1592), .B2(map_f_12__3_), 
        .O(n1116) );
  AOI22S U1615 ( .A1(map_f_7__3_), .A2(n1630), .B1(map_f_3__3_), .B2(n1130), 
        .O(n1115) );
  AOI22S U1616 ( .A1(map_f_9__3_), .A2(n1616), .B1(map_f_5__3_), .B2(n1647), 
        .O(n1114) );
  ND3S U1617 ( .I1(n1116), .I2(n1115), .I3(n1114), .O(n1490) );
  AOI22S U1618 ( .A1(n1483), .A2(n1490), .B1(row_f[21]), .B2(n1536), .O(n1121)
         );
  INV1S U1619 ( .I(map_f_12__3_), .O(n1585) );
  INV1S U1620 ( .I(map_f_4__3_), .O(n1697) );
  AOI22S U1621 ( .A1(n1137), .A2(n1515), .B1(n1136), .B2(n1517), .O(n1120) );
  AOI22S U1622 ( .A1(map_f_11__5_), .A2(n1591), .B1(n1592), .B2(map_f_12__5_), 
        .O(n1124) );
  AOI22S U1623 ( .A1(map_f_7__5_), .A2(n1630), .B1(map_f_3__5_), .B2(n1130), 
        .O(n1123) );
  AOI22S U1624 ( .A1(map_f_9__5_), .A2(n1616), .B1(map_f_5__5_), .B2(n1647), 
        .O(n1122) );
  ND3S U1625 ( .I1(n1124), .I2(n1123), .I3(n1122), .O(n1484) );
  AOI22S U1626 ( .A1(n1483), .A2(n1484), .B1(row_f[23]), .B2(n1536), .O(n1129)
         );
  INV1S U1627 ( .I(map_f_12__5_), .O(n1583) );
  INV1S U1628 ( .I(map_f_4__5_), .O(n1693) );
  AOI22S U1629 ( .A1(n1137), .A2(n1505), .B1(n1136), .B2(n1507), .O(n1128) );
  AOI22S U1630 ( .A1(map_f_11__4_), .A2(n1591), .B1(n1592), .B2(map_f_12__4_), 
        .O(n1133) );
  AOI22S U1631 ( .A1(map_f_7__4_), .A2(n1630), .B1(map_f_3__4_), .B2(n1130), 
        .O(n1132) );
  AOI22S U1632 ( .A1(map_f_9__4_), .A2(n1616), .B1(map_f_5__4_), .B2(n1647), 
        .O(n1131) );
  ND3S U1633 ( .I1(n1133), .I2(n1132), .I3(n1131), .O(n1487) );
  AOI22S U1634 ( .A1(n1483), .A2(n1487), .B1(row_f[22]), .B2(n1536), .O(n1139)
         );
  INV1S U1635 ( .I(map_f_4__4_), .O(n1695) );
  OAI12HS U1636 ( .B1(n1695), .B2(n1688), .A1(n1135), .O(n1512) );
  AOI22S U1637 ( .A1(n1137), .A2(n1510), .B1(n1136), .B2(n1512), .O(n1138) );
  AOI22S U1638 ( .A1(tetrominoes_map_f[13]), .A2(n1561), .B1(n1759), .B2(n1160), .O(n1141) );
  AOI22S U1639 ( .A1(tetrominoes_map_f[19]), .A2(n1562), .B1(n1037), .B2(
        tetrominoes_map_f[12]), .O(n1140) );
  AOI22S U1640 ( .A1(n1551), .A2(n1142), .B1(tetrominoes_map_f[13]), .B2(n1562), .O(n1144) );
  AOI22S U1641 ( .A1(n1037), .A2(tetrominoes_map_f[6]), .B1(n1561), .B2(
        tetrominoes_map_f[7]), .O(n1143) );
  INV1S U1642 ( .I(n1558), .O(n1145) );
  OAI12HS U1643 ( .B1(in_valid), .B2(n789), .A1(n1146), .O(n641) );
  BUF1S U1644 ( .I(n1147), .O(n1149) );
  OAI12HS U1645 ( .B1(n1149), .B2(in_valid), .A1(n1148), .O(n643) );
  NR2 U1646 ( .I1(n1150), .I2(in_valid), .O(n1151) );
  NR2 U1647 ( .I1(state[0]), .I2(n1151), .O(next_state_0_) );
  INV1S U1648 ( .I(map_f_11__3_), .O(n1724) );
  ND2S U1649 ( .I1(n1724), .I2(map_f_8__3_), .O(n1152) );
  OAI22S U1650 ( .A1(n1152), .A2(map_f_9__3_), .B1(map_f_11__3_), .B2(n1725), 
        .O(n1159) );
  INV1S U1651 ( .I(map_f_3__3_), .O(n1654) );
  ND2S U1652 ( .I1(n1654), .I2(map_f_0__3_), .O(n1153) );
  INV1S U1653 ( .I(map_f_2__3_), .O(n1665) );
  OAI22S U1654 ( .A1(n1153), .A2(map_f_1__3_), .B1(map_f_3__3_), .B2(n1665), 
        .O(n1154) );
  NR2 U1655 ( .I1(map_f_4__3_), .I2(n1154), .O(n1155) );
  NR2 U1656 ( .I1(map_f_5__3_), .I2(n1155), .O(n1156) );
  NR2 U1657 ( .I1(map_f_6__3_), .I2(n1156), .O(n1157) );
  NR2 U1658 ( .I1(map_f_10__3_), .I2(map_f_9__3_), .O(n1224) );
  INV1S U1659 ( .I(map_f_7__3_), .O(n1623) );
  NR2 U1660 ( .I1(n1157), .I2(n1190), .O(n1158) );
  NR2 U1661 ( .I1(n1159), .I2(n1158), .O(n1162) );
  OR2B1S U1662 ( .I1(n1161), .B1(n1160), .O(n1582) );
  INV1S U1663 ( .I(col_top_f[12]), .O(n1332) );
  OAI22S U1664 ( .A1(n1482), .A2(n1162), .B1(n1282), .B2(n1332), .O(
        col_top[12]) );
  INV1S U1665 ( .I(map_f_11__5_), .O(n1718) );
  ND2S U1666 ( .I1(n1718), .I2(map_f_8__5_), .O(n1164) );
  OAI22S U1667 ( .A1(n1164), .A2(map_f_9__5_), .B1(map_f_11__5_), .B2(n1719), 
        .O(n1171) );
  INV1S U1668 ( .I(map_f_3__5_), .O(n1652) );
  ND2S U1669 ( .I1(n1652), .I2(map_f_0__5_), .O(n1165) );
  INV1S U1670 ( .I(map_f_2__5_), .O(n1663) );
  OAI22S U1671 ( .A1(n1165), .A2(map_f_1__5_), .B1(map_f_3__5_), .B2(n1663), 
        .O(n1166) );
  NR2 U1672 ( .I1(map_f_4__5_), .I2(n1166), .O(n1167) );
  NR2 U1673 ( .I1(map_f_5__5_), .I2(n1167), .O(n1168) );
  NR2 U1674 ( .I1(map_f_6__5_), .I2(n1168), .O(n1169) );
  NR2 U1675 ( .I1(map_f_10__5_), .I2(map_f_9__5_), .O(n1230) );
  INV1S U1676 ( .I(map_f_7__5_), .O(n1621) );
  NR2 U1677 ( .I1(n1169), .I2(n1192), .O(n1170) );
  NR2 U1678 ( .I1(n1171), .I2(n1170), .O(n1172) );
  INV1S U1679 ( .I(col_top_f[20]), .O(n1284) );
  OAI22S U1680 ( .A1(n1482), .A2(n1172), .B1(n1282), .B2(n1284), .O(
        col_top[20]) );
  INV1S U1681 ( .I(map_f_11__4_), .O(n1721) );
  ND2S U1682 ( .I1(n1721), .I2(map_f_8__4_), .O(n1173) );
  OAI22S U1683 ( .A1(n1173), .A2(map_f_9__4_), .B1(map_f_11__4_), .B2(n1722), 
        .O(n1180) );
  INV1S U1684 ( .I(map_f_3__4_), .O(n1653) );
  ND2S U1685 ( .I1(n1653), .I2(map_f_0__4_), .O(n1174) );
  INV1S U1686 ( .I(map_f_2__4_), .O(n1664) );
  OAI22S U1687 ( .A1(n1174), .A2(map_f_1__4_), .B1(map_f_3__4_), .B2(n1664), 
        .O(n1175) );
  NR2 U1688 ( .I1(map_f_4__4_), .I2(n1175), .O(n1176) );
  NR2 U1689 ( .I1(map_f_5__4_), .I2(n1176), .O(n1177) );
  NR2 U1690 ( .I1(map_f_6__4_), .I2(n1177), .O(n1178) );
  NR2 U1691 ( .I1(map_f_10__4_), .I2(map_f_9__4_), .O(n1218) );
  INV1S U1692 ( .I(map_f_7__4_), .O(n1622) );
  NR2 U1693 ( .I1(n1178), .I2(n1195), .O(n1179) );
  NR2 U1694 ( .I1(n1180), .I2(n1179), .O(n1181) );
  OAI22S U1695 ( .A1(n1482), .A2(n1181), .B1(n1282), .B2(n828), .O(col_top[16]) );
  INV1S U1696 ( .I(map_f_11__2_), .O(n1727) );
  INV1S U1697 ( .I(map_f_9__2_), .O(n1607) );
  NR2 U1698 ( .I1(map_f_7__2_), .I2(n1213), .O(n1208) );
  MOAI1S U1699 ( .A1(n1608), .A2(n1213), .B1(n1727), .B2(map_f_10__2_), .O(
        n1182) );
  NR2 U1700 ( .I1(n1208), .I2(n1182), .O(n1189) );
  NR2 U1701 ( .I1(map_f_6__2_), .I2(n1182), .O(n1186) );
  INV1S U1702 ( .I(map_f_3__2_), .O(n1655) );
  ND2S U1703 ( .I1(n1655), .I2(map_f_0__2_), .O(n1183) );
  INV1S U1704 ( .I(map_f_2__2_), .O(n1666) );
  OAI22S U1705 ( .A1(n1183), .A2(map_f_1__2_), .B1(map_f_3__2_), .B2(n1666), 
        .O(n1184) );
  INV1S U1706 ( .I(map_f_5__2_), .O(n1698) );
  OAI12HS U1707 ( .B1(n1184), .B2(map_f_4__2_), .A1(n1698), .O(n1185) );
  INV1S U1708 ( .I(n1282), .O(n1255) );
  MOAI1S U1709 ( .A1(n1189), .A2(n1188), .B1(col_top_f[8]), .B2(n1255), .O(
        col_top[8]) );
  INV1S U1710 ( .I(col_top_f[15]), .O(n1295) );
  INV1S U1711 ( .I(n1225), .O(n1191) );
  OAI22S U1712 ( .A1(n1295), .A2(n1282), .B1(n1191), .B2(n1482), .O(
        col_top[15]) );
  INV1S U1713 ( .I(col_top_f[23]), .O(n1194) );
  INV1S U1714 ( .I(n1231), .O(n1193) );
  OAI22S U1715 ( .A1(n1194), .A2(n1282), .B1(n1193), .B2(n1482), .O(
        col_top[23]) );
  INV1S U1716 ( .I(n1219), .O(n1196) );
  OAI22S U1717 ( .A1(n1341), .A2(n1282), .B1(n1196), .B2(n1482), .O(
        col_top[19]) );
  INV1S U1718 ( .I(col_top_f[14]), .O(n1200) );
  NR2 U1719 ( .I1(map_f_4__3_), .I2(map_f_3__3_), .O(n1197) );
  INV1S U1720 ( .I(map_f_6__3_), .O(n1637) );
  INV1S U1721 ( .I(map_f_5__3_), .O(n1696) );
  AOI13HS U1722 ( .B1(n1197), .B2(n1637), .B3(n1696), .A1(n1225), .O(n1198) );
  NR2 U1723 ( .I1(map_f_11__3_), .I2(n1198), .O(n1199) );
  OAI22S U1724 ( .A1(n1200), .A2(n1282), .B1(n1199), .B2(n1482), .O(
        col_top[14]) );
  INV1S U1725 ( .I(col_top_f[22]), .O(n1204) );
  NR2 U1726 ( .I1(map_f_4__5_), .I2(map_f_3__5_), .O(n1201) );
  INV1S U1727 ( .I(map_f_6__5_), .O(n1635) );
  INV1S U1728 ( .I(map_f_5__5_), .O(n1692) );
  AOI13HS U1729 ( .B1(n1201), .B2(n1635), .B3(n1692), .A1(n1231), .O(n1202) );
  NR2 U1730 ( .I1(map_f_11__5_), .I2(n1202), .O(n1203) );
  OAI22S U1731 ( .A1(n1204), .A2(n1282), .B1(n1203), .B2(n1482), .O(
        col_top[22]) );
  NR2 U1732 ( .I1(map_f_4__4_), .I2(map_f_3__4_), .O(n1205) );
  INV1S U1733 ( .I(map_f_6__4_), .O(n1636) );
  INV1S U1734 ( .I(map_f_5__4_), .O(n1694) );
  AOI13HS U1735 ( .B1(n1205), .B2(n1636), .B3(n1694), .A1(n1219), .O(n1206) );
  NR2 U1736 ( .I1(map_f_11__4_), .I2(n1206), .O(n1207) );
  OAI22S U1737 ( .A1(n800), .A2(n1282), .B1(n1207), .B2(n1482), .O(col_top[18]) );
  NR2 U1738 ( .I1(map_f_4__2_), .I2(map_f_3__2_), .O(n1209) );
  NR2 U1739 ( .I1(n1236), .I2(n1209), .O(n1211) );
  NR2 U1740 ( .I1(map_f_6__2_), .I2(map_f_5__2_), .O(n1210) );
  NR2 U1741 ( .I1(n1236), .I2(n1210), .O(n1216) );
  NR3 U1742 ( .I1(n1211), .I2(map_f_11__2_), .I3(n1216), .O(n1212) );
  OAI22S U1743 ( .A1(n1482), .A2(n1212), .B1(n1282), .B2(n893), .O(col_top[10]) );
  INV1S U1744 ( .I(map_f_4__2_), .O(n1699) );
  OAI112HS U1745 ( .C1(map_f_2__2_), .C2(map_f_1__2_), .A1(n1699), .B1(n1655), 
        .O(n1214) );
  MOAI1S U1746 ( .A1(n1214), .A2(n1236), .B1(n1727), .B2(n1213), .O(n1215) );
  NR2 U1747 ( .I1(n1216), .I2(n1215), .O(n1217) );
  MOAI1S U1748 ( .A1(n1217), .A2(n1482), .B1(col_top_f[9]), .B2(n1255), .O(
        col_top[9]) );
  NR2 U1749 ( .I1(map_f_11__4_), .I2(n1218), .O(n1222) );
  OAI112HS U1750 ( .C1(map_f_2__4_), .C2(map_f_1__4_), .A1(n1695), .B1(n1653), 
        .O(n1220) );
  AOI13HS U1751 ( .B1(n1636), .B2(n1694), .B3(n1220), .A1(n1219), .O(n1221) );
  NR2 U1752 ( .I1(n1222), .I2(n1221), .O(n1223) );
  OAI22S U1753 ( .A1(n819), .A2(n1282), .B1(n1223), .B2(n1482), .O(col_top[17]) );
  INV1S U1754 ( .I(col_top_f[13]), .O(n1313) );
  NR2 U1755 ( .I1(map_f_11__3_), .I2(n1224), .O(n1228) );
  OAI112HS U1756 ( .C1(map_f_2__3_), .C2(map_f_1__3_), .A1(n1697), .B1(n1654), 
        .O(n1226) );
  AOI13HS U1757 ( .B1(n1637), .B2(n1696), .B3(n1226), .A1(n1225), .O(n1227) );
  NR2 U1758 ( .I1(n1228), .I2(n1227), .O(n1229) );
  OAI22S U1759 ( .A1(n1313), .A2(n1282), .B1(n1229), .B2(n1482), .O(
        col_top[13]) );
  INV1S U1760 ( .I(col_top_f[21]), .O(n1311) );
  NR2 U1761 ( .I1(map_f_11__5_), .I2(n1230), .O(n1234) );
  OAI112HS U1762 ( .C1(map_f_2__5_), .C2(map_f_1__5_), .A1(n1693), .B1(n1652), 
        .O(n1232) );
  AOI13HS U1763 ( .B1(n1635), .B2(n1692), .B3(n1232), .A1(n1231), .O(n1233) );
  NR2 U1764 ( .I1(n1234), .I2(n1233), .O(n1235) );
  OAI22S U1765 ( .A1(n1311), .A2(n1282), .B1(n1235), .B2(n1482), .O(
        col_top[21]) );
  INV1S U1766 ( .I(col_top_f[11]), .O(n1237) );
  MOAI1S U1767 ( .A1(n1237), .A2(n1282), .B1(n1236), .B2(n937), .O(col_top[11]) );
  INV1S U1768 ( .I(map_f_11__1_), .O(n1730) );
  ND2S U1769 ( .I1(n1730), .I2(map_f_8__1_), .O(n1238) );
  OAI22S U1770 ( .A1(n1238), .A2(map_f_9__1_), .B1(map_f_11__1_), .B2(n1731), 
        .O(n1245) );
  INV1S U1771 ( .I(map_f_3__1_), .O(n1656) );
  ND2S U1772 ( .I1(n1656), .I2(map_f_0__1_), .O(n1239) );
  INV1S U1773 ( .I(map_f_2__1_), .O(n1668) );
  OAI22S U1774 ( .A1(n1239), .A2(map_f_1__1_), .B1(map_f_3__1_), .B2(n1668), 
        .O(n1240) );
  NR2 U1775 ( .I1(map_f_4__1_), .I2(n1240), .O(n1241) );
  NR2 U1776 ( .I1(map_f_5__1_), .I2(n1241), .O(n1242) );
  NR2 U1777 ( .I1(map_f_6__1_), .I2(n1242), .O(n1243) );
  NR2 U1778 ( .I1(map_f_10__1_), .I2(map_f_9__1_), .O(n1269) );
  INV1S U1779 ( .I(map_f_7__1_), .O(n1625) );
  NR2 U1780 ( .I1(n1243), .I2(n1265), .O(n1244) );
  NR2 U1781 ( .I1(n1245), .I2(n1244), .O(n1247) );
  INV1S U1782 ( .I(col_top_f[4]), .O(n1246) );
  OAI22S U1783 ( .A1(n1482), .A2(n1247), .B1(n1282), .B2(n1246), .O(col_top[4]) );
  NR2 U1784 ( .I1(n1249), .I2(n1258), .O(bottom_1__0_) );
  INV1S U1785 ( .I(map_f_11__0_), .O(n1734) );
  INV1S U1786 ( .I(map_f_9__0_), .O(n1612) );
  NR2 U1787 ( .I1(map_f_7__0_), .I2(n1280), .O(n1260) );
  MOAI1S U1788 ( .A1(n1614), .A2(n1280), .B1(n1734), .B2(map_f_10__0_), .O(
        n1261) );
  NR2 U1789 ( .I1(n1260), .I2(n1261), .O(n1257) );
  NR2 U1790 ( .I1(map_f_6__0_), .I2(n1261), .O(n1253) );
  INV1S U1791 ( .I(map_f_3__0_), .O(n1658) );
  ND2S U1792 ( .I1(n1658), .I2(map_f_0__0_), .O(n1250) );
  OAI22S U1793 ( .A1(n1250), .A2(map_f_1__0_), .B1(map_f_3__0_), .B2(n1660), 
        .O(n1251) );
  INV1S U1794 ( .I(map_f_5__0_), .O(n1703) );
  OAI12HS U1795 ( .B1(n1251), .B2(map_f_4__0_), .A1(n1703), .O(n1252) );
  MOAI1S U1796 ( .A1(n1257), .A2(n1256), .B1(col_top_f[0]), .B2(n1255), .O(
        col_top[0]) );
  NR2 U1797 ( .I1(n1259), .I2(n1258), .O(bottom_0__0_) );
  INV1S U1798 ( .I(map_f_4__0_), .O(n1705) );
  ND2S U1799 ( .I1(n1705), .I2(n1658), .O(n1262) );
  OR2B1S U1800 ( .I1(n1261), .B1(n1260), .O(n1274) );
  INV1S U1801 ( .I(n1274), .O(n1278) );
  OA13S U1802 ( .B1(map_f_6__0_), .B2(map_f_5__0_), .B3(n1262), .A1(n1278), 
        .O(n1263) );
  NR2 U1803 ( .I1(map_f_11__0_), .I2(n1263), .O(n1264) );
  INV1S U1804 ( .I(col_top_f[2]), .O(n1345) );
  OAI22S U1805 ( .A1(n1482), .A2(n1264), .B1(n1282), .B2(n1345), .O(col_top[2]) );
  INV1S U1806 ( .I(col_top_f[6]), .O(n1346) );
  NR2 U1807 ( .I1(map_f_4__1_), .I2(map_f_3__1_), .O(n1266) );
  INV1S U1808 ( .I(map_f_6__1_), .O(n1639) );
  INV1S U1809 ( .I(map_f_5__1_), .O(n1700) );
  AOI13HS U1810 ( .B1(n1266), .B2(n1639), .B3(n1700), .A1(n1275), .O(n1267) );
  NR2 U1811 ( .I1(map_f_11__1_), .I2(n1267), .O(n1268) );
  OAI22S U1812 ( .A1(n1346), .A2(n1282), .B1(n1268), .B2(n1482), .O(col_top[6]) );
  INV1S U1813 ( .I(col_top_f[5]), .O(n1353) );
  NR2 U1814 ( .I1(map_f_11__1_), .I2(n1269), .O(n1272) );
  OAI112HS U1815 ( .C1(map_f_2__1_), .C2(map_f_1__1_), .A1(n1701), .B1(n1656), 
        .O(n1270) );
  AOI13HS U1816 ( .B1(n1639), .B2(n1700), .B3(n1270), .A1(n1275), .O(n1271) );
  NR2 U1817 ( .I1(n1272), .I2(n1271), .O(n1273) );
  OAI22S U1818 ( .A1(n1353), .A2(n1282), .B1(n1273), .B2(n1482), .O(col_top[5]) );
  INV1S U1819 ( .I(col_top_f[3]), .O(n1335) );
  MOAI1S U1820 ( .A1(n1335), .A2(n1282), .B1(n1274), .B2(n937), .O(col_top[3])
         );
  INV1S U1821 ( .I(n1275), .O(n1276) );
  OAI22S U1822 ( .A1(n1338), .A2(n1282), .B1(n1276), .B2(n1482), .O(col_top[7]) );
  INV1S U1823 ( .I(col_top_f[1]), .O(n1283) );
  INV1S U1824 ( .I(map_f_6__0_), .O(n1641) );
  OAI112HS U1825 ( .C1(map_f_2__0_), .C2(map_f_1__0_), .A1(n1705), .B1(n1658), 
        .O(n1277) );
  AOI22S U1826 ( .A1(n1280), .A2(n1734), .B1(n1279), .B2(n1278), .O(n1281) );
  OAI22S U1827 ( .A1(n1283), .A2(n1282), .B1(n1281), .B2(n1482), .O(col_top[1]) );
  NR2 U1828 ( .I1(n1332), .I2(n1354), .O(n1285) );
  NR2 U1829 ( .I1(n1286), .I2(n1285), .O(n1327) );
  INV1S U1830 ( .I(bottom_f[6]), .O(n1289) );
  INV1 U1831 ( .I(n1310), .O(n1290) );
  OAI12HS U1832 ( .B1(n1291), .B2(bottom_f[6]), .A1(n1290), .O(n1316) );
  INV1S U1833 ( .I(n1316), .O(n1326) );
  ND2P U1834 ( .I1(n888), .I2(col_top_f[21]), .O(n1292) );
  INV1S U1835 ( .I(col_top_f[9]), .O(n1293) );
  ND2S U1836 ( .I1(n1359), .I2(col_top_f[15]), .O(n1297) );
  ND2S U1837 ( .I1(n1352), .I2(col_top_f[22]), .O(n1299) );
  XOR2H U1838 ( .I1(n1301), .I2(n1300), .O(n1405) );
  OR2T U1839 ( .I1(n1421), .I2(n1420), .O(n1306) );
  INV2 U1840 ( .I(n1306), .O(n1324) );
  NR2T U1841 ( .I1(n1319), .I2(n1384), .O(n1318) );
  NR2 U1842 ( .I1(n1313), .I2(n1354), .O(n1314) );
  NR2 U1843 ( .I1(n1315), .I2(n1314), .O(n1380) );
  INV2 U1844 ( .I(n1384), .O(n1320) );
  MXL2HS U1845 ( .A(n1327), .B(n1326), .S(n790), .OB(n1442) );
  AOI22S U1846 ( .A1(n1352), .A2(col_top_f[12]), .B1(n1359), .B2(col_top_f[4]), 
        .O(n1330) );
  ND2S U1847 ( .I1(n815), .I2(col_top_f[20]), .O(n1328) );
  XNR2HS U1848 ( .I1(n1371), .I2(bottom_f[3]), .O(n1370) );
  XNR2HS U1849 ( .I1(n1333), .I2(bottom_f[0]), .O(n1369) );
  MOAI1H U1850 ( .A1(n1354), .A2(n1338), .B1(n1352), .B2(col_top_f[15]), .O(
        n1343) );
  NR2 U1851 ( .I1(n1373), .I2(bottom_f[3]), .O(n1351) );
  AOI22S U1852 ( .A1(n1357), .A2(col_top_f[21]), .B1(n1352), .B2(col_top_f[9]), 
        .O(n1362) );
  AOI22S U1853 ( .A1(n1359), .A2(col_top_f[1]), .B1(n815), .B2(col_top_f[17]), 
        .O(n1360) );
  XNR2HS U1854 ( .I1(n1375), .I2(n1363), .O(n1364) );
  INV1S U1855 ( .I(bottom_f[3]), .O(n1372) );
  NR2P U1856 ( .I1(n1372), .I2(n1371), .O(n1386) );
  NR2 U1857 ( .I1(n1390), .I2(n783), .O(n1377) );
  XOR2HS U1858 ( .I1(n1389), .I2(n1377), .O(n1378) );
  ND2S U1859 ( .I1(n1395), .I2(n1408), .O(n1387) );
  XOR2HS U1860 ( .I1(n764), .I2(n1387), .O(n1393) );
  INV1S U1861 ( .I(n1418), .O(n1402) );
  NR2 U1862 ( .I1(n1401), .I2(n1402), .O(n1391) );
  XOR2HS U1863 ( .I1(n1391), .I2(n779), .O(n1392) );
  ND2S U1864 ( .I1(n1394), .I2(bottom_f[5]), .O(n1411) );
  ND2S U1865 ( .I1(n1411), .I2(n1413), .O(n1397) );
  XNR2HS U1866 ( .I1(n1397), .I2(n1396), .O(n1429) );
  OR2 U1867 ( .I1(n1769), .I2(n868), .O(n1415) );
  INV1S U1868 ( .I(n1415), .O(n1399) );
  ND2S U1869 ( .I1(n868), .I2(n1769), .O(n1417) );
  INV1S U1870 ( .I(n1417), .O(n1398) );
  NR2 U1871 ( .I1(n1399), .I2(n1398), .O(n1404) );
  XNR2HS U1872 ( .I1(n1404), .I2(n1403), .O(n1431) );
  ND3S U1873 ( .I1(n1409), .I2(n1408), .I3(n1411), .O(n1414) );
  ND2S U1874 ( .I1(n1411), .I2(n1410), .O(n1412) );
  OAI12H U1875 ( .B1(n1437), .B2(n1430), .A1(n1429), .O(n1435) );
  ND3S U1876 ( .I1(n1740), .I2(n1482), .I3(n1443), .O(n1459) );
  AOI22S U1877 ( .A1(n804), .A2(n1459), .B1(n1739), .B2(n805), .O(n1444) );
  OAI12H U1878 ( .B1(n1445), .B2(n1473), .A1(n1444), .O(n7210) );
  INV1S U1879 ( .I(n1446), .O(n1449) );
  MXL2HS U1880 ( .A(n1449), .B(n1448), .S(n1447), .OB(n1454) );
  ND3S U1881 ( .I1(n1749), .I2(n802), .I3(n805), .O(n1450) );
  AOI13HS U1882 ( .B1(n1739), .B2(n804), .B3(n803), .A1(n1452), .O(n1453) );
  OAI12H U1883 ( .B1(n1454), .B2(n1473), .A1(n1453), .O(n7200) );
  NR2 U1884 ( .I1(bottom_compare_f_2_), .I2(n1714), .O(n1461) );
  INV1S U1885 ( .I(n1714), .O(n1708) );
  NR2 U1886 ( .I1(n1708), .I2(n1762), .O(n1460) );
  AOI22S U1887 ( .A1(n1739), .A2(n1461), .B1(bottom_compare_f_2_), .B2(n1470), 
        .O(n1462) );
  OAI12H U1888 ( .B1(n1463), .B2(n1473), .A1(n1462), .O(n1768) );
  INV1S U1889 ( .I(n1464), .O(n1466) );
  INV1S U1890 ( .I(n1687), .O(n1468) );
  AOI22S U1891 ( .A1(n1739), .A2(n1471), .B1(N964), .B2(n1470), .O(n1472) );
  MOAI1S U1892 ( .A1(n1474), .A2(n1554), .B1(tetrominoes_map_f[18]), .B2(n1561), .O(n753) );
  INV1S U1893 ( .I(tetrominoes_map_f[18]), .O(n1478) );
  INV1S U1894 ( .I(n1037), .O(n1475) );
  MOAI1S U1895 ( .A1(n1478), .A2(n1475), .B1(n1561), .B2(tetrominoes_map_f[19]), .O(n752) );
  INV1S U1896 ( .I(n1557), .O(n1479) );
  OAI112HS U1897 ( .C1(n1479), .C2(n1478), .A1(n1477), .B1(n1476), .O(n751) );
  AOI22S U1898 ( .A1(tetrominoes_map_f[6]), .A2(n1562), .B1(n1561), .B2(
        tetrominoes_map_f[0]), .O(n1480) );
  OAI12HS U1899 ( .B1(n1552), .B2(n1559), .A1(n1480), .O(n735) );
  INV1S U1900 ( .I(map_f_0__0_), .O(n1683) );
  NR2 U1901 ( .I1(n1481), .I2(n1683), .O(tetris_comb[0]) );
  INV1S U1902 ( .I(map_f_0__1_), .O(n1680) );
  NR2 U1903 ( .I1(n1481), .I2(n1680), .O(tetris_comb[1]) );
  INV1S U1904 ( .I(map_f_0__2_), .O(n1678) );
  NR2 U1905 ( .I1(n1481), .I2(n1678), .O(tetris_comb[2]) );
  INV1S U1906 ( .I(map_f_0__3_), .O(n1676) );
  NR2 U1907 ( .I1(n1481), .I2(n1676), .O(tetris_comb[3]) );
  INV1S U1908 ( .I(map_f_0__4_), .O(n1674) );
  NR2 U1909 ( .I1(n1481), .I2(n1674), .O(tetris_comb[4]) );
  INV1S U1910 ( .I(map_f_0__5_), .O(n1672) );
  NR2 U1911 ( .I1(n1481), .I2(n1672), .O(tetris_comb[5]) );
  NR2 U1912 ( .I1(n1481), .I2(n1685), .O(tetris_comb[6]) );
  NR2 U1913 ( .I1(n1481), .I2(n1681), .O(tetris_comb[7]) );
  NR2 U1914 ( .I1(n1481), .I2(n1679), .O(tetris_comb[8]) );
  NR2 U1915 ( .I1(n1481), .I2(n1677), .O(tetris_comb[9]) );
  NR2 U1916 ( .I1(n1481), .I2(n1675), .O(tetris_comb[10]) );
  NR2 U1917 ( .I1(n1481), .I2(n1673), .O(tetris_comb[11]) );
  NR2 U1918 ( .I1(n1481), .I2(n1660), .O(tetris_comb[12]) );
  NR2 U1919 ( .I1(n1481), .I2(n1668), .O(tetris_comb[13]) );
  NR2 U1920 ( .I1(n1481), .I2(n1666), .O(tetris_comb[14]) );
  NR2 U1921 ( .I1(n1481), .I2(n1665), .O(tetris_comb[15]) );
  NR2 U1922 ( .I1(n1481), .I2(n1664), .O(tetris_comb[16]) );
  NR2 U1923 ( .I1(n1481), .I2(n1663), .O(tetris_comb[17]) );
  NR2 U1924 ( .I1(n1481), .I2(n1658), .O(tetris_comb[18]) );
  NR2 U1925 ( .I1(n1481), .I2(n1656), .O(tetris_comb[19]) );
  NR2 U1926 ( .I1(n1481), .I2(n1655), .O(tetris_comb[20]) );
  NR2 U1927 ( .I1(n1481), .I2(n1654), .O(tetris_comb[21]) );
  NR2 U1928 ( .I1(n1481), .I2(n1653), .O(tetris_comb[22]) );
  NR2 U1929 ( .I1(n1481), .I2(n1652), .O(tetris_comb[23]) );
  NR2 U1930 ( .I1(n1481), .I2(n1705), .O(tetris_comb[24]) );
  NR2 U1931 ( .I1(n1481), .I2(n1701), .O(tetris_comb[25]) );
  NR2 U1932 ( .I1(n1481), .I2(n1699), .O(tetris_comb[26]) );
  NR2 U1933 ( .I1(n1481), .I2(n1697), .O(tetris_comb[27]) );
  NR2 U1934 ( .I1(n1481), .I2(n1695), .O(tetris_comb[28]) );
  NR2 U1935 ( .I1(n1481), .I2(n1693), .O(tetris_comb[29]) );
  NR2 U1936 ( .I1(n1481), .I2(n1703), .O(tetris_comb[30]) );
  NR2 U1937 ( .I1(n1481), .I2(n1700), .O(tetris_comb[31]) );
  NR2 U1938 ( .I1(n1481), .I2(n1698), .O(tetris_comb[32]) );
  NR2 U1939 ( .I1(n1481), .I2(n1696), .O(tetris_comb[33]) );
  NR2 U1940 ( .I1(n1481), .I2(n1694), .O(tetris_comb[34]) );
  NR2 U1941 ( .I1(n1481), .I2(n1692), .O(tetris_comb[35]) );
  NR2 U1942 ( .I1(n1481), .I2(n1641), .O(tetris_comb[36]) );
  NR2 U1943 ( .I1(n1481), .I2(n1639), .O(tetris_comb[37]) );
  INV1S U1944 ( .I(map_f_6__2_), .O(n1638) );
  NR2 U1945 ( .I1(n1481), .I2(n1638), .O(tetris_comb[38]) );
  NR2 U1946 ( .I1(n1481), .I2(n1637), .O(tetris_comb[39]) );
  NR2 U1947 ( .I1(n1481), .I2(n1636), .O(tetris_comb[40]) );
  NR2 U1948 ( .I1(n1481), .I2(n1635), .O(tetris_comb[41]) );
  INV1S U1949 ( .I(map_f_7__0_), .O(n1627) );
  NR2 U1950 ( .I1(n1481), .I2(n1627), .O(tetris_comb[42]) );
  NR2 U1951 ( .I1(n1481), .I2(n1625), .O(tetris_comb[43]) );
  INV1S U1952 ( .I(map_f_7__2_), .O(n1624) );
  NR2 U1953 ( .I1(n1481), .I2(n1624), .O(tetris_comb[44]) );
  NR2 U1954 ( .I1(n1481), .I2(n1623), .O(tetris_comb[45]) );
  NR2 U1955 ( .I1(n1481), .I2(n1622), .O(tetris_comb[46]) );
  NR2 U1956 ( .I1(n1481), .I2(n1621), .O(tetris_comb[47]) );
  NR2 U1957 ( .I1(n1481), .I2(n1614), .O(tetris_comb[48]) );
  NR2 U1958 ( .I1(n1481), .I2(n1610), .O(tetris_comb[49]) );
  NR2 U1959 ( .I1(n1481), .I2(n1608), .O(tetris_comb[50]) );
  NR2 U1960 ( .I1(n1481), .I2(n1606), .O(tetris_comb[51]) );
  NR2 U1961 ( .I1(n1481), .I2(n1604), .O(tetris_comb[52]) );
  NR2 U1962 ( .I1(n1481), .I2(n1602), .O(tetris_comb[53]) );
  NR2 U1963 ( .I1(n1481), .I2(n1612), .O(tetris_comb[54]) );
  INV1S U1964 ( .I(map_f_9__1_), .O(n1609) );
  NR2 U1965 ( .I1(n1481), .I2(n1609), .O(tetris_comb[55]) );
  NR2 U1966 ( .I1(n1481), .I2(n1607), .O(tetris_comb[56]) );
  INV1S U1967 ( .I(map_f_9__3_), .O(n1605) );
  NR2 U1968 ( .I1(n1481), .I2(n1605), .O(tetris_comb[57]) );
  INV1S U1969 ( .I(map_f_9__4_), .O(n1603) );
  NR2 U1970 ( .I1(n1481), .I2(n1603), .O(tetris_comb[58]) );
  INV1S U1971 ( .I(map_f_9__5_), .O(n1601) );
  NR2 U1972 ( .I1(n1481), .I2(n1601), .O(tetris_comb[59]) );
  NR2 U1973 ( .I1(n1481), .I2(n1736), .O(tetris_comb[60]) );
  NR2 U1974 ( .I1(n1481), .I2(n1731), .O(tetris_comb[61]) );
  NR2 U1975 ( .I1(n1481), .I2(n1728), .O(tetris_comb[62]) );
  NR2 U1976 ( .I1(n1481), .I2(n1725), .O(tetris_comb[63]) );
  NR2 U1977 ( .I1(n1481), .I2(n1722), .O(tetris_comb[64]) );
  NR2 U1978 ( .I1(n1481), .I2(n1719), .O(tetris_comb[65]) );
  NR2 U1979 ( .I1(n1481), .I2(n1734), .O(tetris_comb[66]) );
  NR2 U1980 ( .I1(n1481), .I2(n1730), .O(tetris_comb[67]) );
  NR2 U1981 ( .I1(n1481), .I2(n1727), .O(tetris_comb[68]) );
  NR2 U1982 ( .I1(n1481), .I2(n1724), .O(tetris_comb[69]) );
  NR2 U1983 ( .I1(n1481), .I2(n1721), .O(tetris_comb[70]) );
  NR2 U1984 ( .I1(n1481), .I2(n1718), .O(tetris_comb[71]) );
  INV1S U1985 ( .I(score_f[0]), .O(n1741) );
  NR2 U1986 ( .I1(n1482), .I2(n1741), .O(score_comb[0]) );
  INV1S U1987 ( .I(score_f[2]), .O(n1748) );
  NR2 U1988 ( .I1(n1482), .I2(n1748), .O(score_comb[2]) );
  NR2 U1989 ( .I1(n1714), .I2(n1536), .O(n1538) );
  NR2 U1990 ( .I1(n1569), .I2(n1536), .O(n1500) );
  NR2 U1991 ( .I1(n1646), .I2(n1536), .O(n1499) );
  AOI22S U1992 ( .A1(map_f_10__5_), .A2(n1500), .B1(map_f_6__5_), .B2(n1499), 
        .O(n1486) );
  AN2 U1993 ( .I1(n1483), .I2(n803), .O(n1530) );
  AOI22S U1994 ( .A1(n1535), .A2(n1484), .B1(n1530), .B2(n1507), .O(n1485) );
  OAI112HS U1995 ( .C1(n1583), .C2(n1504), .A1(n1486), .B1(n1485), .O(N723) );
  AOI22S U1996 ( .A1(map_f_10__4_), .A2(n1500), .B1(map_f_6__4_), .B2(n1499), 
        .O(n1489) );
  AOI22S U1997 ( .A1(n1535), .A2(n1487), .B1(n1530), .B2(n1512), .O(n1488) );
  OAI112HS U1998 ( .C1(n1584), .C2(n1504), .A1(n1489), .B1(n1488), .O(N722) );
  AOI22S U1999 ( .A1(map_f_10__3_), .A2(n1500), .B1(map_f_6__3_), .B2(n1499), 
        .O(n1492) );
  AOI22S U2000 ( .A1(n1535), .A2(n1490), .B1(n1530), .B2(n1517), .O(n1491) );
  OAI112HS U2001 ( .C1(n1585), .C2(n1504), .A1(n1492), .B1(n1491), .O(N721) );
  AOI22S U2002 ( .A1(map_f_10__2_), .A2(n1500), .B1(map_f_6__2_), .B2(n1499), 
        .O(n1495) );
  AOI22S U2003 ( .A1(n1535), .A2(n1493), .B1(n1530), .B2(n1522), .O(n1494) );
  OAI112HS U2004 ( .C1(n1586), .C2(n1504), .A1(n1495), .B1(n1494), .O(N720) );
  AOI22S U2005 ( .A1(map_f_10__1_), .A2(n1500), .B1(map_f_6__1_), .B2(n1499), 
        .O(n1498) );
  AOI22S U2006 ( .A1(n1535), .A2(n1496), .B1(n1530), .B2(n1527), .O(n1497) );
  OAI112HS U2007 ( .C1(n1587), .C2(n1504), .A1(n1498), .B1(n1497), .O(N719) );
  AOI22S U2008 ( .A1(map_f_10__0_), .A2(n1500), .B1(map_f_6__0_), .B2(n1499), 
        .O(n1503) );
  AOI22S U2009 ( .A1(n1535), .A2(n1501), .B1(n1530), .B2(n1537), .O(n1502) );
  OAI112HS U2010 ( .C1(n1590), .C2(n1504), .A1(n1503), .B1(n1502), .O(N718) );
  AOI22S U2011 ( .A1(n1535), .A2(n1506), .B1(n1530), .B2(n1505), .O(n1509) );
  AOI22S U2012 ( .A1(n1538), .A2(n1507), .B1(row_f[17]), .B2(n1536), .O(n1508)
         );
  ND2S U2013 ( .I1(n1509), .I2(n1508), .O(N711) );
  AOI22S U2014 ( .A1(n1535), .A2(n1511), .B1(n1530), .B2(n1510), .O(n1514) );
  AOI22S U2015 ( .A1(n1538), .A2(n1512), .B1(row_f[16]), .B2(n1536), .O(n1513)
         );
  ND2S U2016 ( .I1(n1514), .I2(n1513), .O(N710) );
  AOI22S U2017 ( .A1(n1535), .A2(n1516), .B1(n1530), .B2(n1515), .O(n1519) );
  AOI22S U2018 ( .A1(n1538), .A2(n1517), .B1(row_f[15]), .B2(n1536), .O(n1518)
         );
  ND2S U2019 ( .I1(n1519), .I2(n1518), .O(N709) );
  AOI22S U2020 ( .A1(n1535), .A2(n1521), .B1(n1530), .B2(n1520), .O(n1524) );
  AOI22S U2021 ( .A1(n1538), .A2(n1522), .B1(row_f[14]), .B2(n1536), .O(n1523)
         );
  ND2S U2022 ( .I1(n1524), .I2(n1523), .O(N708) );
  AOI22S U2023 ( .A1(n1535), .A2(n1526), .B1(n1530), .B2(n1525), .O(n1529) );
  AOI22S U2024 ( .A1(n1538), .A2(n1527), .B1(row_f[13]), .B2(n1536), .O(n1528)
         );
  ND2S U2025 ( .I1(n1529), .I2(n1528), .O(N707) );
  INV1S U2026 ( .I(n1530), .O(n1533) );
  INV1S U2027 ( .I(n1531), .O(n1532) );
  AOI22S U2028 ( .A1(n1538), .A2(n1537), .B1(row_f[12]), .B2(n1536), .O(n1539)
         );
  ND2S U2029 ( .I1(n1540), .I2(n1539), .O(N706) );
  OAI22S U2030 ( .A1(n1761), .A2(n1541), .B1(n1559), .B2(cnt_f[0]), .O(cnt[0])
         );
  ND2S U2031 ( .I1(cnt_f[0]), .I2(n1551), .O(n1543) );
  ND2S U2032 ( .I1(n1543), .I2(n1545), .O(n1542) );
  AOI22S U2033 ( .A1(cnt_f[1]), .A2(n1542), .B1(n1543), .B2(n1544), .O(cnt[1])
         );
  NR2 U2034 ( .I1(n1544), .I2(n1543), .O(n1547) );
  OR2B1 U2035 ( .I1(n1547), .B1(n1545), .O(n1548) );
  MOAI1S U2036 ( .A1(n1546), .A2(n1548), .B1(n1546), .B2(n1547), .O(cnt[2]) );
  ND2S U2037 ( .I1(cnt_f[2]), .I2(n1547), .O(n1550) );
  OAI12HS U2038 ( .B1(cnt_f[2]), .B2(n1559), .A1(n1548), .O(n1549) );
  MOAI1 U2039 ( .A1(cnt_f[3]), .A2(n1550), .B1(cnt_f[3]), .B2(n1549), .O(
        cnt[3]) );
  AOI22S U2040 ( .A1(tetrominoes_map_f[12]), .A2(n1561), .B1(n1552), .B2(n1551), .O(n1556) );
  MAOI1S U2041 ( .A1(tetrominoes_map_f[18]), .A2(n1562), .B1(n1554), .B2(n1553), .O(n1555) );
  ND2S U2042 ( .I1(n1556), .I2(n1555), .O(n747) );
  NR2 U2043 ( .I1(n1559), .I2(n1558), .O(n1560) );
  AOI22S U2044 ( .A1(tetrominoes_map_f[8]), .A2(n1561), .B1(tetrominoes[2]), 
        .B2(n1560), .O(n1564) );
  AOI22S U2045 ( .A1(tetrominoes_map_f[14]), .A2(n1562), .B1(n1037), .B2(
        tetrominoes_map_f[7]), .O(n1563) );
  ND3S U2046 ( .I1(n1565), .I2(n1564), .I3(n1563), .O(n739) );
  OAI222S U2047 ( .A1(n1571), .A2(n1614), .B1(n1627), .B2(n1570), .C1(n1569), 
        .C2(n1737), .O(n728) );
  OAI222S U2048 ( .A1(n1571), .A2(n1610), .B1(n1625), .B2(n1570), .C1(n1569), 
        .C2(n1732), .O(n727) );
  INV3 U2049 ( .I(n1739), .O(n1689) );
  OAI222S U2050 ( .A1(n1571), .A2(n1608), .B1(n1624), .B2(n1570), .C1(n1569), 
        .C2(n1729), .O(n726) );
  OAI222S U2051 ( .A1(n1571), .A2(n1606), .B1(n1623), .B2(n1570), .C1(n1569), 
        .C2(n1726), .O(n725) );
  OAI222S U2052 ( .A1(n1571), .A2(n1604), .B1(n1622), .B2(n1570), .C1(n1569), 
        .C2(n1723), .O(n724) );
  OAI222S U2053 ( .A1(n1571), .A2(n1602), .B1(n1621), .B2(n1570), .C1(n1569), 
        .C2(n1720), .O(n7230) );
  ND3S U2054 ( .I1(n1749), .I2(n1581), .I3(n1631), .O(n1576) );
  OAI22S U2055 ( .A1(n1572), .A2(n1576), .B1(n1580), .B2(n1583), .O(n7220) );
  OAI22S U2056 ( .A1(n1573), .A2(n1576), .B1(n1580), .B2(n1584), .O(n7180) );
  OAI22S U2057 ( .A1(n1574), .A2(n1576), .B1(n1580), .B2(n1585), .O(n7170) );
  OAI22S U2058 ( .A1(n1575), .A2(n1576), .B1(n1580), .B2(n1586), .O(n7160) );
  INV1S U2059 ( .I(n1576), .O(n1579) );
  MOAI1S U2060 ( .A1(n1580), .A2(n1587), .B1(n1579), .B2(n1577), .O(n7150) );
  MOAI1S U2061 ( .A1(n1580), .A2(n1590), .B1(n1579), .B2(n1578), .O(n7140) );
  OR2 U2062 ( .I1(n1581), .I2(n1740), .O(n1716) );
  OAI112HS U2063 ( .C1(n1762), .C2(n1588), .A1(n1716), .B1(n1582), .O(n1589)
         );
  OAI222S U2064 ( .A1(n1583), .A2(n1716), .B1(n1589), .B2(n1718), .C1(n1588), 
        .C2(n1720), .O(n7130) );
  OAI222S U2065 ( .A1(n1584), .A2(n1716), .B1(n1589), .B2(n1721), .C1(n1588), 
        .C2(n1723), .O(n7120) );
  OAI222S U2066 ( .A1(n1585), .A2(n1716), .B1(n1589), .B2(n1724), .C1(n1588), 
        .C2(n1726), .O(n7110) );
  OAI222S U2067 ( .A1(n1586), .A2(n1716), .B1(n1589), .B2(n1727), .C1(n1588), 
        .C2(n1729), .O(n7100) );
  OAI222S U2068 ( .A1(n1587), .A2(n1716), .B1(n1589), .B2(n1730), .C1(n1588), 
        .C2(n1732), .O(n7090) );
  OAI222S U2069 ( .A1(n1590), .A2(n1716), .B1(n1589), .B2(n1734), .C1(n1588), 
        .C2(n1737), .O(n7080) );
  ND2P U2070 ( .I1(n1591), .I2(n804), .O(n1596) );
  NR2 U2071 ( .I1(n1689), .I2(n1592), .O(n1711) );
  MOAI1S U2072 ( .A1(n1762), .A2(n1599), .B1(n1596), .B2(n1711), .O(n1593) );
  NR2P U2073 ( .I1(n1747), .I2(n1593), .O(n1595) );
  OAI222S U2074 ( .A1(n1720), .A2(n1596), .B1(n1601), .B2(n1595), .C1(n1719), 
        .C2(n1594), .O(n7070) );
  OAI222S U2075 ( .A1(n1723), .A2(n1596), .B1(n1603), .B2(n1595), .C1(n1722), 
        .C2(n1594), .O(n7060) );
  OAI222S U2076 ( .A1(n1726), .A2(n1596), .B1(n1605), .B2(n1595), .C1(n1725), 
        .C2(n1594), .O(n705) );
  OAI222S U2077 ( .A1(n1729), .A2(n1596), .B1(n1607), .B2(n1595), .C1(n1728), 
        .C2(n1594), .O(n704) );
  OAI222S U2078 ( .A1(n1732), .A2(n1596), .B1(n1609), .B2(n1595), .C1(n1731), 
        .C2(n1594), .O(n703) );
  OAI222S U2079 ( .A1(n1737), .A2(n1596), .B1(n1612), .B2(n1595), .C1(n1736), 
        .C2(n1594), .O(n702) );
  AOI13HS U2080 ( .B1(n1749), .B2(n1615), .B3(n1598), .A1(n1747), .O(n1613) );
  OAI12HS U2081 ( .B1(n1715), .B2(n805), .A1(n1599), .O(n1600) );
  OAI222S U2082 ( .A1(n1615), .A2(n1720), .B1(n1602), .B2(n1613), .C1(n1601), 
        .C2(n1611), .O(n701) );
  OAI222S U2083 ( .A1(n1615), .A2(n1723), .B1(n1604), .B2(n1613), .C1(n1603), 
        .C2(n1611), .O(n700) );
  OAI222S U2084 ( .A1(n1615), .A2(n1726), .B1(n1606), .B2(n1613), .C1(n1605), 
        .C2(n1611), .O(n699) );
  OAI222S U2085 ( .A1(n1615), .A2(n1729), .B1(n1608), .B2(n1613), .C1(n1607), 
        .C2(n1611), .O(n698) );
  OAI222S U2086 ( .A1(n1615), .A2(n1732), .B1(n1610), .B2(n1613), .C1(n1609), 
        .C2(n1611), .O(n697) );
  OAI222S U2087 ( .A1(n1615), .A2(n1737), .B1(n1614), .B2(n1613), .C1(n1612), 
        .C2(n1611), .O(n696) );
  INV1S U2088 ( .I(n1620), .O(n1634) );
  OAI222S U2089 ( .A1(n1629), .A2(n1720), .B1(n1635), .B2(n1628), .C1(n1621), 
        .C2(n794), .O(n695) );
  OAI222S U2090 ( .A1(n1629), .A2(n1723), .B1(n1636), .B2(n1628), .C1(n1622), 
        .C2(n794), .O(n694) );
  OAI222S U2091 ( .A1(n1629), .A2(n1726), .B1(n1637), .B2(n1628), .C1(n1623), 
        .C2(n794), .O(n693) );
  OAI222S U2092 ( .A1(n1629), .A2(n1729), .B1(n1638), .B2(n1628), .C1(n1624), 
        .C2(n794), .O(n692) );
  OAI222S U2093 ( .A1(n1629), .A2(n1732), .B1(n1639), .B2(n1628), .C1(n1625), 
        .C2(n794), .O(n691) );
  OAI222S U2094 ( .A1(n1629), .A2(n1737), .B1(n1641), .B2(n1628), .C1(n1627), 
        .C2(n794), .O(n690) );
  OAI222S U2095 ( .A1(n1643), .A2(n1720), .B1(n1692), .B2(n1642), .C1(n1635), 
        .C2(n1640), .O(n689) );
  OAI222S U2096 ( .A1(n1643), .A2(n1723), .B1(n1694), .B2(n1642), .C1(n1636), 
        .C2(n1640), .O(n688) );
  OAI222S U2097 ( .A1(n1643), .A2(n1726), .B1(n1696), .B2(n1642), .C1(n1637), 
        .C2(n1640), .O(n687) );
  OAI222S U2098 ( .A1(n1643), .A2(n1729), .B1(n1698), .B2(n1642), .C1(n1638), 
        .C2(n1640), .O(n686) );
  OAI222S U2099 ( .A1(n1643), .A2(n1732), .B1(n1700), .B2(n1642), .C1(n1639), 
        .C2(n1640), .O(n685) );
  OAI222S U2100 ( .A1(n1643), .A2(n1737), .B1(n1703), .B2(n1642), .C1(n1641), 
        .C2(n1640), .O(n684) );
  OAI222S U2101 ( .A1(n1646), .A2(n1720), .B1(n1652), .B2(n1645), .C1(n1693), 
        .C2(n1651), .O(n683) );
  OAI222S U2102 ( .A1(n1646), .A2(n1723), .B1(n1653), .B2(n1645), .C1(n1695), 
        .C2(n1651), .O(n682) );
  OAI222S U2103 ( .A1(n1646), .A2(n1726), .B1(n1654), .B2(n1645), .C1(n1697), 
        .C2(n1651), .O(n681) );
  OAI222S U2104 ( .A1(n1646), .A2(n1729), .B1(n1655), .B2(n1645), .C1(n1699), 
        .C2(n1651), .O(n680) );
  OAI222S U2105 ( .A1(n1646), .A2(n1732), .B1(n1656), .B2(n1645), .C1(n1701), 
        .C2(n1651), .O(n679) );
  OAI222S U2106 ( .A1(n1646), .A2(n1737), .B1(n1658), .B2(n1645), .C1(n1705), 
        .C2(n1651), .O(n678) );
  MOAI1S U2107 ( .A1(n1689), .A2(n1671), .B1(n1749), .B2(n1649), .O(n1650) );
  OAI222S U2108 ( .A1(n1661), .A2(n1720), .B1(n1663), .B2(n1659), .C1(n1652), 
        .C2(n1657), .O(n677) );
  OAI222S U2109 ( .A1(n1661), .A2(n1723), .B1(n1664), .B2(n1659), .C1(n1653), 
        .C2(n1657), .O(n676) );
  OAI222S U2110 ( .A1(n1661), .A2(n1726), .B1(n1665), .B2(n1659), .C1(n1654), 
        .C2(n1657), .O(n675) );
  OAI222S U2111 ( .A1(n1661), .A2(n1729), .B1(n1666), .B2(n1659), .C1(n1655), 
        .C2(n1657), .O(n674) );
  OAI222S U2112 ( .A1(n1661), .A2(n1732), .B1(n1668), .B2(n1659), .C1(n1656), 
        .C2(n1657), .O(n673) );
  OAI222S U2113 ( .A1(n1661), .A2(n1737), .B1(n1660), .B2(n1659), .C1(n1658), 
        .C2(n1657), .O(n672) );
  OAI222S U2114 ( .A1(n1670), .A2(n1720), .B1(n1673), .B2(n1669), .C1(n1663), 
        .C2(n1667), .O(n671) );
  OAI222S U2115 ( .A1(n1670), .A2(n1723), .B1(n1675), .B2(n1669), .C1(n1664), 
        .C2(n1667), .O(n670) );
  OAI222S U2116 ( .A1(n1670), .A2(n1726), .B1(n1677), .B2(n1669), .C1(n1665), 
        .C2(n1667), .O(n669) );
  OAI222S U2117 ( .A1(n1670), .A2(n1729), .B1(n1679), .B2(n1669), .C1(n1666), 
        .C2(n1667), .O(n668) );
  OAI222S U2118 ( .A1(n1670), .A2(n1732), .B1(n1681), .B2(n1669), .C1(n1668), 
        .C2(n1667), .O(n667) );
  OAI222S U2119 ( .A1(n1686), .A2(n1673), .B1(n1720), .B2(n1684), .C1(n1672), 
        .C2(n1682), .O(n665) );
  OAI222S U2120 ( .A1(n1686), .A2(n1675), .B1(n1723), .B2(n1684), .C1(n1674), 
        .C2(n1682), .O(n664) );
  OAI222S U2121 ( .A1(n1686), .A2(n1677), .B1(n1726), .B2(n1684), .C1(n1676), 
        .C2(n1682), .O(n663) );
  OAI222S U2122 ( .A1(n1686), .A2(n1679), .B1(n1729), .B2(n1684), .C1(n1678), 
        .C2(n1682), .O(n662) );
  OAI222S U2123 ( .A1(n1686), .A2(n1681), .B1(n1732), .B2(n1684), .C1(n1680), 
        .C2(n1682), .O(n661) );
  OAI222S U2124 ( .A1(n1686), .A2(n1685), .B1(n1737), .B2(n1684), .C1(n1683), 
        .C2(n1682), .O(n660) );
  OAI22S U2125 ( .A1(n1762), .A2(n1691), .B1(n1689), .B2(n1688), .O(n1690) );
  OAI222S U2126 ( .A1(n1706), .A2(n1720), .B1(n1693), .B2(n1704), .C1(n1692), 
        .C2(n1702), .O(n659) );
  OAI222S U2127 ( .A1(n1706), .A2(n1723), .B1(n1695), .B2(n1704), .C1(n1694), 
        .C2(n1702), .O(n658) );
  OAI222S U2128 ( .A1(n1706), .A2(n1726), .B1(n1697), .B2(n1704), .C1(n1696), 
        .C2(n1702), .O(n657) );
  OAI222S U2129 ( .A1(n1706), .A2(n1729), .B1(n1699), .B2(n1704), .C1(n1698), 
        .C2(n1702), .O(n656) );
  OAI222S U2130 ( .A1(n1706), .A2(n1732), .B1(n1701), .B2(n1704), .C1(n1700), 
        .C2(n1702), .O(n655) );
  OAI222S U2131 ( .A1(n1706), .A2(n1737), .B1(n1705), .B2(n1704), .C1(n1703), 
        .C2(n1702), .O(n654) );
  NR2 U2132 ( .I1(bottom_compare_f_2_), .I2(n1708), .O(n1710) );
  NR2 U2133 ( .I1(n1710), .I2(n1709), .O(n1713) );
  NR2 U2134 ( .I1(n1715), .I2(n1714), .O(n1717) );
  OAI222S U2135 ( .A1(n1738), .A2(n1720), .B1(n1719), .B2(n1735), .C1(n1718), 
        .C2(n1733), .O(n653) );
  OAI222S U2136 ( .A1(n1738), .A2(n1723), .B1(n1722), .B2(n1735), .C1(n1721), 
        .C2(n1733), .O(n652) );
  OAI222S U2137 ( .A1(n1738), .A2(n1726), .B1(n1725), .B2(n1735), .C1(n1724), 
        .C2(n1733), .O(n651) );
  OAI222S U2138 ( .A1(n1738), .A2(n1729), .B1(n1728), .B2(n1735), .C1(n1727), 
        .C2(n1733), .O(n650) );
  OAI222S U2139 ( .A1(n1738), .A2(n1732), .B1(n1731), .B2(n1735), .C1(n1730), 
        .C2(n1733), .O(n649) );
  OAI222S U2140 ( .A1(n1738), .A2(n1737), .B1(n1736), .B2(n1735), .C1(n1734), 
        .C2(n1733), .O(n648) );
  NR2 U2141 ( .I1(n1739), .I2(n1747), .O(n1743) );
  OAI22S U2142 ( .A1(n1741), .A2(n1743), .B1(score_f[0]), .B2(n1740), .O(n647)
         );
  ND2S U2143 ( .I1(n1742), .I2(score_f[0]), .O(n1745) );
  OAI12HS U2144 ( .B1(score_f[0]), .B2(n1762), .A1(n1743), .O(n1744) );
  MOAI1S U2145 ( .A1(score_f[1]), .A2(n1745), .B1(score_f[1]), .B2(n1744), .O(
        n646) );
  ND3S U2146 ( .I1(n1746), .I2(score_f[1]), .I3(score_f[0]), .O(n1750) );
  OAI22S U2147 ( .A1(n1749), .A2(n1747), .B1(n1750), .B2(n1747), .O(n1752) );
  OAI22S U2148 ( .A1(n1752), .A2(n1748), .B1(n1751), .B2(n1750), .O(n645) );
  OR3B2S U2149 ( .I1(n1750), .B1(n1749), .B2(score_f[2]), .O(n1754) );
  MOAI1S U2150 ( .A1(score_f[3]), .A2(n1754), .B1(score_f[3]), .B2(n1753), .O(
        n644) );
endmodule

