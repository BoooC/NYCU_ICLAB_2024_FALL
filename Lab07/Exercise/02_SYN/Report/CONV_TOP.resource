 
****************************************
Report : resources
Design : CONV_TOP
Version: T-2022.03
Date   : Fri Jan 10 14:15:33 2025
****************************************


Resource Report for this hierarchy in file ../01_RTL/DESIGN_module.v
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_3        | DW01_inc       | width=3    | u_input_output/add_82 (DESIGN_module.v:82) |
| add_x_6        | DW01_inc       | width=3    | u_input_output/add_94 (DESIGN_module.v:94) |
| add_x_44       | DW01_add       | width=3    | u_Conv/add_198 (DESIGN_module.v:198) |
| add_x_45       | DW01_add       | width=3    | u_Conv/add_198_2 (DESIGN_module.v:198) |
| add_x_49       | DW01_inc       | width=3    | u_Conv/add_276 (DESIGN_module.v:276) |
| add_x_51       | DW01_inc       | width=8    | u_Conv/add_291 (DESIGN_module.v:291) |
| add_x_53       | DW01_inc       | width=3    | u_Conv/add_307 (DESIGN_module.v:307) |
| add_x_55       | DW01_inc       | width=3    | u_Conv/add_322 (DESIGN_module.v:322) |
| add_x_57       | DW01_inc       | width=3    | u_Conv/add_337 (DESIGN_module.v:337) |
| add_x_87       | DW01_add       | width=7    | u_FIFO_syn/add_50 (FIFO_syn.v:50) |
| add_x_88       | DW01_add       | width=7    | u_FIFO_syn/add_51 (FIFO_syn.v:51) |
| eq_x_89        | DW_cmp         | width=7    | u_FIFO_syn/eq_105 (FIFO_syn.v:105) |
| eq_x_90        | DW_cmp         | width=7    | u_FIFO_syn/eq_114 (FIFO_syn.v:114) |
| DP_OP_392J1_122_756             |            |                            |
|                | DP_OP_392J1_122_756 |       |                            |
=============================================================================

Datapath Report for DP_OP_392J1_122_756
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_392J1_122_756  | u_Conv/mult_198 (DESIGN_module.v:198)               |
|                      | u_Conv/add_199 (DESIGN_module.v:199)                |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 3     |                                          |
| I2    | PI   | Unsigned | 3     |                                          |
| I3    | PI   | Unsigned | 8     |                                          |
| O1    | PO   | Unsigned | 6     | I1 * I2 (DESIGN_module.v:198)            |
| O2    | PO   | Unsigned | 8     | I3 + O1 (DESIGN_module.v:199)            |
==============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_x_3            | DW01_inc         | apparch (area)     |                |
| add_x_6            | DW01_inc         | apparch (area)     |                |
| add_x_44           | DW01_add         | apparch (area)     |                |
| add_x_45           | DW01_add         | apparch (area)     |                |
| add_x_49           | DW01_inc         | apparch (area)     |                |
| add_x_51           | DW01_inc         | apparch (area)     |                |
| add_x_53           | DW01_inc         | apparch (area)     |                |
| add_x_55           | DW01_inc         | apparch (area)     |                |
| add_x_57           | DW01_inc         | apparch (area)     |                |
| add_x_87           | DW01_add         | apparch (area)     |                |
| add_x_88           | DW01_add         | apparch (area)     |                |
| eq_x_89            | DW_cmp           | apparch (area)     |                |
| eq_x_90            | DW_cmp           | apparch (area)     |                |
| DP_OP_392J1_122_756                   |                    |                |
|                    | DP_OP_392J1_122_756 | str (area)      |                |
|                    |                  | mult_arch: and     |                |
===============================================================================

1
