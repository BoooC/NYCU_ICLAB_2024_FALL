 
****************************************
Report : resources
Design : Program
Version: T-2022.03
Date   : Wed Nov 27 01:35:20 2024
****************************************


Resource Report for this hierarchy in file ../01_RTL/Program.sv
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| lt_x_1         | DW_cmp         | width=4    | lt_75 (Program.sv:75)      |
| eq_x_2         | DW_cmp         | width=4    | eq_75 (Program.sv:75)      |
| lt_x_3         | DW_cmp         | width=5    | lt_75_2 (Program.sv:75)    |
| add_x_13       | DW01_add       | width=14   | add_330 (Program.sv:330)   |
| add_x_14       | DW01_add       | width=14   | add_331 (Program.sv:331)   |
| add_x_15       | DW01_add       | width=14   | add_332 (Program.sv:332)   |
| add_x_16       | DW01_add       | width=14   | add_333 (Program.sv:333)   |
| add_x_40       | DW01_inc       | width=3    | add_465 (Program.sv:465)   |
| gt_x_44        | DW_cmp         | width=12   | gt_472 (Program.sv:472)    |
| gt_x_45        | DW_cmp         | width=12   | gt_473 (Program.sv:473)    |
| sub_x_57       | DW01_sub       | width=12   | sub_499 (Program.sv:499)   |
| sub_x_58       | DW01_sub       | width=13   | sub_504 (Program.sv:504)   |
| sub_x_59       | DW01_sub       | width=13   | sub_505 (Program.sv:505)   |
| sub_x_60       | DW01_sub       | width=13   | sub_506 (Program.sv:506)   |
| sub_x_61       | DW01_sub       | width=13   | sub_507 (Program.sv:507)   |
| add_x_62       | DW01_inc       | width=12   | add_511 (Program.sv:511)   |
| add_x_63       | DW01_inc       | width=12   | add_512 (Program.sv:512)   |
| add_x_64       | DW01_inc       | width=12   | add_513 (Program.sv:513)   |
| add_x_65       | DW01_inc       | width=12   | add_514 (Program.sv:514)   |
| gte_x_70       | DW_cmp         | width=14   | gte_524 (Program.sv:524)   |
| gte_x_71       | DW_cmp         | width=14   | gte_524_2 (Program.sv:524) |
| gte_x_72       | DW_cmp         | width=14   | gte_524_3 (Program.sv:524) |
| gte_x_83       | DW_cmp         | width=12   | gte_565 (Program.sv:565)   |
| add_x_84       | DW01_inc       | width=3    | add_577 (Program.sv:577)   |
| add_x_87       | DW01_inc       | width=4    | add_592 (Program.sv:592)   |
| add_x_97       | DW01_add       | width=14   | adder_inst/add_686 (Program.sv:686) |
| DP_OP_158J1_122_899             |            |                            |
|                | DP_OP_158J1_122_899 |       |                            |
| DP_OP_159J1_123_899             |            |                            |
|                | DP_OP_159J1_123_899 |       |                            |
=============================================================================

Datapath Report for DP_OP_158J1_122_899
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_158J1_122_899  | add_522 (Program.sv:522) add_522_2 (Program.sv:522) |
|                      | add_522_3 (Program.sv:522)                          |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 1     |                                          |
| I2    | PI   | Unsigned | 1     |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| I4    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Unsigned | 4     | I1 + I2 + I3 + I4 (Program.sv:522)       |
==============================================================================

Datapath Report for DP_OP_159J1_123_899
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_159J1_123_899  | add_523_ni_ni (Program.sv:523)                      |
|                      | add_523_2_ni (Program.sv:523)                       |
|                      | add_523_3_ni (Program.sv:523)                       |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 1     |                                          |
| I2    | PI   | Unsigned | 1     |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| I4    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Unsigned | 4     | I1 + I2 + I3 + I4 (Program.sv:523)       |
==============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| lt_x_1             | DW_cmp           | apparch (area)     |                |
| eq_x_2             | DW_cmp           | apparch (area)     |                |
| lt_x_3             | DW_cmp           | apparch (area)     |                |
| add_x_13           | DW01_add         | pparch (area,speed)                 |
| add_x_14           | DW01_add         | pparch (area,speed)                 |
| add_x_15           | DW01_add         | pparch (area,speed)                 |
| add_x_16           | DW01_add         | pparch (area,speed)                 |
| add_x_40           | DW01_inc         | apparch (area)     |                |
| gt_x_44            | DW_cmp           | apparch (area)     |                |
| gt_x_45            | DW_cmp           | apparch (area)     |                |
| sub_x_57           | DW01_sub         | pparch (area,speed)                 |
| sub_x_58           | DW01_sub         | pparch (area,speed)                 |
| sub_x_59           | DW01_sub         | pparch (area,speed)                 |
| sub_x_60           | DW01_sub         | pparch (area,speed)                 |
| sub_x_61           | DW01_sub         | pparch (area,speed)                 |
| add_x_62           | DW01_inc         | pparch (area,speed)                 |
| add_x_63           | DW01_inc         | pparch (area,speed)                 |
| add_x_64           | DW01_inc         | pparch (area,speed)                 |
| add_x_65           | DW01_inc         | pparch (area,speed)                 |
| gte_x_70           | DW_cmp           | apparch (area)     |                |
| gte_x_71           | DW_cmp           | apparch (area)     |                |
| gte_x_72           | DW_cmp           | apparch (area)     |                |
| gte_x_83           | DW_cmp           | apparch (area)     |                |
| add_x_84           | DW01_inc         | apparch (area)     |                |
| add_x_87           | DW01_inc         | apparch (area)     |                |
| add_x_97           | DW01_add         | pparch (area,speed)                 |
| DP_OP_158J1_122_899                   |                    |                |
|                    | DP_OP_158J1_122_899 | str (area)      |                |
| DP_OP_159J1_123_899                   |                    |                |
|                    | DP_OP_159J1_123_899 | str (area)      |                |
===============================================================================

1
