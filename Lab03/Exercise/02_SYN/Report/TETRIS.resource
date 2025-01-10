 
****************************************
Report : resources
Design : TETRIS
Version: T-2022.03
Date   : Fri Jan 10 13:10:39 2025
****************************************


Resource Report for this hierarchy in file ../01_RTL/TETRIS.v
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| gt_x_1         | DW_cmp         | width=3    | gt_79 (TETRIS.v:79)        |
| add_x_2        | DW01_inc       | width=3    | add_79 (TETRIS.v:79)       |
| add_x_5        | DW01_add       | width=3    | add_80 (TETRIS.v:80)       |
| gt_x_7         | DW_cmp         | width=3    | gt_81 (TETRIS.v:81)        |
| add_x_8        | DW01_add       | width=3    | add_81 (TETRIS.v:81)       |
| add_x_12       | DW01_inc       | width=4    | add_227 (TETRIS.v:227)     |
| add_x_2922     | DW01_inc       | width=3    | add_323 (TETRIS.v:323)     |
| DP_OP_3140J1_122_8115           |            |                            |
|                | DP_OP_3140J1_122_8115 |     |                            |
=============================================================================

Datapath Report for DP_OP_3140J1_122_8115
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_3140J1_122_8115 | add_185 (TETRIS.v:185) add_186 (TETRIS.v:186)      |
|                      | add_187 (TETRIS.v:187)                              |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 4     |                                          |
| O1    | PO   | Unsigned | 4     | I1 + $unsigned(1'b1) (TETRIS.v:185)      |
| O2    | PO   | Unsigned | 4     | O1 + $unsigned(1'b1) (TETRIS.v:186)      |
| O3    | PO   | Unsigned | 4     | O2 + $unsigned(1'b1) (TETRIS.v:187)      |
==============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| gt_x_1             | DW_cmp           | apparch (area)     |                |
| add_x_2            | DW01_inc         | apparch (area)     |                |
| add_x_5            | DW01_add         | apparch (area)     |                |
| gt_x_7             | DW_cmp           | apparch (area)     |                |
| add_x_8            | DW01_add         | apparch (area)     |                |
| add_x_12           | DW01_inc         | apparch (area)     |                |
| add_x_2922         | DW01_inc         | apparch (area)     |                |
| DP_OP_3140J1_122_8115                 |                    |                |
|                    | DP_OP_3140J1_122_8115 | str (area)    |                |
===============================================================================

1
