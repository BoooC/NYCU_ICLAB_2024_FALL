 
****************************************
Report : resources
Design : CNN
Version: T-2022.03
Date   : Fri Jan 10 13:35:31 2025
****************************************


Resource Report for this hierarchy in file ../01_RTL/CNN.v
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_425      | DW01_add       | width=6    | add_683 (CNN.v:683)        |
| add_x_430      | DW01_inc       | width=2    | add_714 (CNN.v:714)        |
| add_x_1098     | DW01_inc       | width=8    | DW_ACT_SOFTMAX_inst/FP_mult_by_2_inst/add_1141 (CNN.v:1141) |
| PE_inst_0/U1_add_inst_3         |            |                            |
|                | DW_fp_add      | sig_width=23 | PE_inst_0/U1_add_inst_3 (CNN.v:846) |
      |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_0/U1_add_inst_2         |            |                            |
|                | DW_fp_add      | sig_width=23 | PE_inst_0/U1_add_inst_2 (CNN.v:842) |
      |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_0/U1_add_inst_1         |            |                            |
|                | DW_fp_add      | sig_width=23 | PE_inst_0/U1_add_inst_1 (CNN.v:838) |
      |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_0/U1_add_inst_0         |            |                            |
|                | DW_fp_add      | sig_width=23 | PE_inst_0/U1_add_inst_0 (CNN.v:835) |
      |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_0/U3_mult               |            |                            |
|                | DW_fp_mult     | sig_width=23 | PE_inst_0/U3_mult (CNN.v:830) |
            |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_0/U2_mult               |            |                            |
|                | DW_fp_mult     | sig_width=23 | PE_inst_0/U2_mult (CNN.v:827) |
            |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_0/U1_mult               |            |                            |
|                | DW_fp_mult     | sig_width=23 | PE_inst_0/U1_mult (CNN.v:824) |
            |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_0/U0_mult               |            |                            |
|                | DW_fp_mult     | sig_width=23 | PE_inst_0/U0_mult (CNN.v:821) |
            |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| DW_COMP_inst_1_left/U2          |            |                            |
|                | DW_fp_cmp      | sig_width=23 | DW_COMP_inst_1_left/U2 (CNN.v:887) |
       |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| DW_COMP_inst_1_left/U1          |            |                            |
|                | DW_fp_cmp      | sig_width=23 | DW_COMP_inst_1_left/U1 (CNN.v:884) |
       |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| DW_ACT_SOFTMAX_inst/DW_fp_add_inst_3         |                            |
|                | DW_fp_add      | sig_width=23 | DW_ACT_SOFTMAX_inst/DW_fp_add_inst_3 (CNN.v:1039) |
         | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| DW_ACT_SOFTMAX_inst/DW_fp_add_inst_2         |                            |
|                | DW_fp_add      | sig_width=23 | DW_ACT_SOFTMAX_inst/DW_fp_add_inst_2 (CNN.v:1031) |
         | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| DW_ACT_SOFTMAX_inst/DW_fp_sub_inst_1         |                            |
|                | DW_fp_sub      | sig_width=23 | DW_ACT_SOFTMAX_inst/DW_fp_sub_inst_1 (CNN.v:971) |
          | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| DW_ACT_SOFTMAX_inst/DW_fp_add_inst_1         |                            |
|                | DW_fp_add      | sig_width=23 | DW_ACT_SOFTMAX_inst/DW_fp_add_inst_1 (CNN.v:963) |
          | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| DW_ACT_SOFTMAX_inst/DW_fp_exp_inst           |                            |
|                | DW_fp_exp      | sig_width=23 | DW_ACT_SOFTMAX_inst/DW_fp_exp_inst (CNN.v:957) |
            | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
|                |                | arch=1     |                            |
| PE_inst_3/U1_add_inst_3         |            |                            |
|                | DW_fp_add      | sig_width=23 | PE_inst_3/U1_add_inst_3 (CNN.v:846) |
      |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_3/U1_add_inst_2         |            |                            |
|                | DW_fp_add      | sig_width=23 | PE_inst_3/U1_add_inst_2 (CNN.v:842) |
      |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_3/U1_add_inst_1         |            |                            |
|                | DW_fp_add      | sig_width=23 | PE_inst_3/U1_add_inst_1 (CNN.v:838) |
      |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_3/U1_add_inst_0         |            |                            |
|                | DW_fp_add      | sig_width=23 | PE_inst_3/U1_add_inst_0 (CNN.v:835) |
      |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_3/U3_mult               |            |                            |
|                | DW_fp_mult     | sig_width=23 | PE_inst_3/U3_mult (CNN.v:830) |
            |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_3/U2_mult               |            |                            |
|                | DW_fp_mult     | sig_width=23 | PE_inst_3/U2_mult (CNN.v:827) |
            |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_3/U1_mult               |            |                            |
|                | DW_fp_mult     | sig_width=23 | PE_inst_3/U1_mult (CNN.v:824) |
            |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_3/U0_mult               |            |                            |
|                | DW_fp_mult     | sig_width=23 | PE_inst_3/U0_mult (CNN.v:821) |
            |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_2/U1_add_inst_3         |            |                            |
|                | DW_fp_add      | sig_width=23 | PE_inst_2/U1_add_inst_3 (CNN.v:846) |
      |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_2/U1_add_inst_2         |            |                            |
|                | DW_fp_add      | sig_width=23 | PE_inst_2/U1_add_inst_2 (CNN.v:842) |
      |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_2/U1_add_inst_1         |            |                            |
|                | DW_fp_add      | sig_width=23 | PE_inst_2/U1_add_inst_1 (CNN.v:838) |
      |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_2/U1_add_inst_0         |            |                            |
|                | DW_fp_add      | sig_width=23 | PE_inst_2/U1_add_inst_0 (CNN.v:835) |
      |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_2/U3_mult               |            |                            |
|                | DW_fp_mult     | sig_width=23 | PE_inst_2/U3_mult (CNN.v:830) |
            |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_2/U2_mult               |            |                            |
|                | DW_fp_mult     | sig_width=23 | PE_inst_2/U2_mult (CNN.v:827) |
            |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_2/U1_mult               |            |                            |
|                | DW_fp_mult     | sig_width=23 | PE_inst_2/U1_mult (CNN.v:824) |
            |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_2/U0_mult               |            |                            |
|                | DW_fp_mult     | sig_width=23 | PE_inst_2/U0_mult (CNN.v:821) |
            |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_1/U1_add_inst_3         |            |                            |
|                | DW_fp_add      | sig_width=23 | PE_inst_1/U1_add_inst_3 (CNN.v:846) |
      |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_1/U1_add_inst_2         |            |                            |
|                | DW_fp_add      | sig_width=23 | PE_inst_1/U1_add_inst_2 (CNN.v:842) |
      |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_1/U1_add_inst_1         |            |                            |
|                | DW_fp_add      | sig_width=23 | PE_inst_1/U1_add_inst_1 (CNN.v:838) |
      |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_1/U1_add_inst_0         |            |                            |
|                | DW_fp_add      | sig_width=23 | PE_inst_1/U1_add_inst_0 (CNN.v:835) |
      |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_1/U3_mult               |            |                            |
|                | DW_fp_mult     | sig_width=23 | PE_inst_1/U3_mult (CNN.v:830) |
            |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_1/U2_mult               |            |                            |
|                | DW_fp_mult     | sig_width=23 | PE_inst_1/U2_mult (CNN.v:827) |
            |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_1/U1_mult               |            |                            |
|                | DW_fp_mult     | sig_width=23 | PE_inst_1/U1_mult (CNN.v:824) |
            |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| PE_inst_1/U0_mult               |            |                            |
|                | DW_fp_mult     | sig_width=23 | PE_inst_1/U0_mult (CNN.v:821) |
            |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| DW_COMP_inst_2_right/U2         |            |                            |
|                | DW_fp_cmp      | sig_width=23 | DW_COMP_inst_2_right/U2 (CNN.v:887) |
      |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| DW_COMP_inst_2_right/U1         |            |                            |
|                | DW_fp_cmp      | sig_width=23 | DW_COMP_inst_2_right/U1 (CNN.v:884) |
      |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| DW_COMP_inst_2_left/U2          |            |                            |
|                | DW_fp_cmp      | sig_width=23 | DW_COMP_inst_2_left/U2 (CNN.v:887) |
       |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| DW_COMP_inst_2_left/U1          |            |                            |
|                | DW_fp_cmp      | sig_width=23 | DW_COMP_inst_2_left/U1 (CNN.v:884) |
       |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| DW_COMP_inst_1_right/U2         |            |                            |
|                | DW_fp_cmp      | sig_width=23 | DW_COMP_inst_1_right/U2 (CNN.v:887) |
      |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| DW_COMP_inst_1_right/U1         |            |                            |
|                | DW_fp_cmp      | sig_width=23 | DW_COMP_inst_1_right/U1 (CNN.v:884) |
      |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
| DW_ACT_SOFTMAX_inst/FP_div_pipe_inst/DW_fp_mult_inst_0                    |
|                | DW_fp_mult     | sig_width=23 | DW_ACT_SOFTMAX_inst/FP_div_pipe_inst/DW_fp_mult_inst_0 (CNN.v:1176) |
| exp_width=8 |                  |
|                |                | ieee_compliance=0 |                     |
| DW_ACT_SOFTMAX_inst/FP_div_pipe_inst/DW_fp_recip_inst_0                   |
|                | DW_fp_recip    | sig_width=23 | DW_ACT_SOFTMAX_inst/FP_div_pipe_inst/DW_fp_recip_inst_0 (CNN.v:1169) |
| exp_width=8 |                 |
|                |                | ieee_compliance=0 |                     |
|                |                | faithful_round=1 |                      |
| gt_x_1100      | DW_cmp         | width=5    | gt_696 (CNN.v:696)         |
|                |                |            | gt_764 (CNN.v:764)         |
|                |                |            | gt_776 (CNN.v:776)         |
| add_x_418      | DW01_inc       | width=5    | add_663 (CNN.v:663)        |
|                |                |            | add_667 (CNN.v:667)        |
|                |                |            | add_668 (CNN.v:668)        |
|                |                |            | add_669 (CNN.v:669)        |
|                |                |            | add_670 (CNN.v:670)        |
|                |                |            | add_671 (CNN.v:671)        |
| sub_x_27       | DW01_sub       | width=6    | sub_224 (CNN.v:224)        |
|                |                |            | sub_228 (CNN.v:228)        |
|                |                |            | sub_231_2 (CNN.v:231)      |
|                |                |            | sub_235_2 (CNN.v:235)      |
| sub_x_29       | DW01_dec       | width=6    | sub_225 (CNN.v:225)        |
|                |                |            | sub_229 (CNN.v:229)        |
|                |                |            | sub_231 (CNN.v:231)        |
|                |                |            | sub_235 (CNN.v:235)        |
| add_x_94       | DW01_inc       | width=7    | add_571 (CNN.v:571)        |
|                |                |            | add_627 (CNN.v:627)        |
|                |                |            | add_683_2 (CNN.v:683)      |
| sub_x_25       | DW01_sub       | width=6    | sub_223 (CNN.v:223)        |
|                |                |            | sub_227 (CNN.v:227)        |
| sub_x_37       | DW01_sub       | width=6    | sub_232 (CNN.v:232)        |
|                |                |            | sub_236 (CNN.v:236)        |
| add_x_95       | DW01_add       | width=7    | add_572 (CNN.v:572)        |
|                |                |            | add_628 (CNN.v:628)        |
| DP_OP_5350J1_178_1243           |            |                            |
|                | DP_OP_5350J1_178_1243 |     |                            |
=============================================================================

Datapath Report for DP_OP_5350J1_178_1243
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_5350J1_178_1243 | add_700_3 (CNN.v:700) add_697_2 (CNN.v:697)        |
|                      | add_700 (CNN.v:700) add_697 (CNN.v:697)             |
|                      | add_700_2 (CNN.v:700)                               |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 6     |                                          |
| I2    | PI   | Unsigned | 2     |                                          |
| O1    | PO   | Unsigned | 6     | I1 + I2 ( CNN.v:697 CNN.v:700 )          |
==============================================================================


Resource Report for Ungrouped Hierarchy
        DW_ACT_SOFTMAX_inst/FP_div_pipe_inst/DW_fp_recip_inst_0 in file
        ./DW_fp_recip__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| mult_x_2       | DW_mult_uns    | a_width=24 | mult_399                   |
|                |                | b_width=9  |                            |
| gte_x_5        | DW_cmp         | width=9    | gte_649                    |
| eq_x_9         | DW_cmp         | width=10   | eq_650 eq_678              |
| DP_OP_44J1_122_8319             |            |                            |
|                | DP_OP_44J1_122_8319 |       |                            |
| DP_OP_45J1_123_5453             |            |                            |
|                | DP_OP_45J1_123_5453 |       |                            |
=============================================================================

Datapath Report for DP_OP_44J1_122_8319
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_44J1_122_8319  | mult_403 add_410 add_431 mult_426 mult_418 add_468  |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 9     |                                          |
| I2    | PI   | Unsigned | 25    |                                          |
| I3    | PI   | Unsigned | 27    |                                          |
| I4    | PI   | Unsigned | 13    |                                          |
| I5    | PI   | Unsigned | 13    |                                          |
| T4    | IFO  | Unsigned | 34    | I1 * I2                                  |
| T25   | IFO  | Unsigned | 20    | T4[33:14]                                |
| T6    | IFO  | Unsigned | 26    | I5 * I5                                  |
| T28   | IFO  | Unsigned | 13    | T6[25:13]                                |
| T7    | IFO  | Unsigned | 26    | I4 * T28                                 |
| T29   | IFO  | Unsigned | 13    | T7[25:13]                                |
| O1    | PO   | Unsigned | 27    | I3 + T25                                 |
| O2    | PO   | Unsigned | 27    | O1 + T29                                 |
| O3    | PO   | Unsigned | 27    | O2 + $unsigned(4'b1000)                  |
==============================================================================

Datapath Report for DP_OP_45J1_123_5453
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_45J1_123_5453  | sub_342 add_342 sub_574_ni                          |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Signed   | 10    | -I1 - I2 + $unsigned(10'b0011111110)     |
==============================================================================


Resource Report for Ungrouped Hierarchy DW_COMP_inst_1_right/U1 in file
        ./DW_fp_cmp__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| gt_x_3         | DW_cmp         | width=23   | gt_219                     |
| eq_x_4         | DW_cmp         | width=23   | eq_222                     |
| gt_x_5         | DW_cmp         | width=8    | gt_227                     |
| eq_x_6         | DW_cmp         | width=8    | eq_230                     |
=============================================================================


Resource Report for Ungrouped Hierarchy DW_COMP_inst_1_right/U2 in file
        ./DW_fp_cmp__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| gt_x_3         | DW_cmp         | width=23   | gt_219                     |
| eq_x_4         | DW_cmp         | width=23   | eq_222                     |
| gt_x_5         | DW_cmp         | width=8    | gt_227                     |
| eq_x_6         | DW_cmp         | width=8    | eq_230                     |
=============================================================================


Resource Report for Ungrouped Hierarchy DW_COMP_inst_2_left/U1 in file
        ./DW_fp_cmp__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| gt_x_3         | DW_cmp         | width=23   | gt_219                     |
| eq_x_4         | DW_cmp         | width=23   | eq_222                     |
| gt_x_5         | DW_cmp         | width=8    | gt_227                     |
| eq_x_6         | DW_cmp         | width=8    | eq_230                     |
=============================================================================


Resource Report for Ungrouped Hierarchy DW_COMP_inst_2_left/U2 in file
        ./DW_fp_cmp__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| gt_x_3         | DW_cmp         | width=23   | gt_219                     |
| eq_x_4         | DW_cmp         | width=23   | eq_222                     |
| gt_x_5         | DW_cmp         | width=8    | gt_227                     |
| eq_x_6         | DW_cmp         | width=8    | eq_230                     |
=============================================================================


Resource Report for Ungrouped Hierarchy DW_COMP_inst_2_right/U1 in file
        ./DW_fp_cmp__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| gt_x_3         | DW_cmp         | width=23   | gt_219                     |
| eq_x_4         | DW_cmp         | width=23   | eq_222                     |
| gt_x_5         | DW_cmp         | width=8    | gt_227                     |
| eq_x_6         | DW_cmp         | width=8    | eq_230                     |
=============================================================================


Resource Report for Ungrouped Hierarchy DW_COMP_inst_2_right/U2 in file
        ./DW_fp_cmp__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| gt_x_3         | DW_cmp         | width=23   | gt_219                     |
| eq_x_4         | DW_cmp         | width=23   | eq_222                     |
| gt_x_5         | DW_cmp         | width=8    | gt_227                     |
| eq_x_6         | DW_cmp         | width=8    | eq_230                     |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_1/U1_add_inst_0
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fp_addsub   | sig_width=23 | U1                       |
|                |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_1/U1_add_inst_1
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fp_addsub   | sig_width=23 | U1                       |
|                |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_1/U1_add_inst_2
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fp_addsub   | sig_width=23 | U1                       |
|                |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_1/U1_add_inst_3
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fp_addsub   | sig_width=23 | U1                       |
|                |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_2/U1_add_inst_0
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fp_addsub   | sig_width=23 | U1                       |
|                |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_2/U1_add_inst_1
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fp_addsub   | sig_width=23 | U1                       |
|                |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_2/U1_add_inst_2
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fp_addsub   | sig_width=23 | U1                       |
|                |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_2/U1_add_inst_3
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fp_addsub   | sig_width=23 | U1                       |
|                |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_3/U1_add_inst_0
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fp_addsub   | sig_width=23 | U1                       |
|                |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_3/U1_add_inst_1
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fp_addsub   | sig_width=23 | U1                       |
|                |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_3/U1_add_inst_2
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fp_addsub   | sig_width=23 | U1                       |
|                |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_3/U1_add_inst_3
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fp_addsub   | sig_width=23 | U1                       |
|                |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
=============================================================================


Resource Report for Ungrouped Hierarchy DW_ACT_SOFTMAX_inst/DW_fp_exp_inst/U2
        in file ./DW_exp2__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| mult_x_91      | DW_mult_uns    | a_width=31 | mult_4987_2                |
|                |                | b_width=18 |                            |
| DP_OP_106J1_152_3223            |            |                            |
|                | DP_OP_106J1_152_3223 |      |                            |
| DP_OP_107J1_153_9769            |            |                            |
|                | DP_OP_107J1_153_9769 |      |                            |
=============================================================================

Datapath Report for DP_OP_106J1_152_3223
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_106J1_152_3223 | mult_4967 mult_4981_2                               |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 18    |                                          |
| I2    | PI   | Unsigned | 29    |                                          |
| T90   | IFO  | Unsigned | 36    | I1 * I1                                  |
| T98   | IFO  | Unsigned | 14    | T90[35:22]                               |
| O1    | PO   | Unsigned | 45    | I2 * T98                                 |
==============================================================================

Datapath Report for DP_OP_107J1_153_9769
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_107J1_153_9769 | add_4991_2 add_4991_3 add_4994                      |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Signed   | 15    |                                          |
| I2    | PI   | Signed   | 25    |                                          |
| I3    | PI   | Signed   | 31    |                                          |
| T105  | IFO  | Signed   | 31    | I1 + I2 + I3                             |
| T103  | IFO  | Signed   | 28    | T105[30:3]                               |
| O1    | PO   | Unsigned | 28    | T103 + $unsigned(1'b1)                   |
==============================================================================


Resource Report for Ungrouped Hierarchy DW_ACT_SOFTMAX_inst/DW_fp_exp_inst in
        file ./DW_fp_exp__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| mult_x_4       | DW_mult_uns    | a_width=33 | mult_219                   |
|                |                | b_width=33 |                            |
| sub_x_5        | DW01_sub       | width=9    | sub_221                    |
| gte_x_6        | DW_cmp         | width=9    | gte_232                    |
| add_x_9        | DW01_add       | width=26   | add_270                    |
| add_x_11       | DW01_inc       | width=24   | add_276_round              |
| U1             | DW01_ash       | A_width=41 | U1                         |
|                |                | SH_width=9 |                            |
| U2             | DW_exp2        | op_width=26 | U2                        |
|                |                | arch=1     |                            |
|                |                | err_range=1 |                           |
| sub_x_16       | DW01_sub       | width=10   | add_242 sub_242            |
| add_x_17       | DW01_dec       | width=2    | add_247_ni_ni sub_add_247  |
| sub_x_18       | DW01_sub       | width=26   | add_247_ni_ni sub_add_247  |
| add_x_19       | DW01_add       | width=8    | add_260 add_261            |
| add_x_20       | DW01_add       | width=10   | add_260 add_261            |
=============================================================================


Resource Report for Ungrouped Hierarchy DW_ACT_SOFTMAX_inst/DW_fp_add_inst_1
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fp_addsub   | sig_width=23 | U1                       |
|                |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
=============================================================================


Resource Report for Ungrouped Hierarchy DW_ACT_SOFTMAX_inst/DW_fp_sub_inst_1
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fp_addsub   | sig_width=23 | U1                       |
|                |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
=============================================================================


Resource Report for Ungrouped Hierarchy DW_ACT_SOFTMAX_inst/DW_fp_add_inst_2
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fp_addsub   | sig_width=23 | U1                       |
|                |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
=============================================================================


Resource Report for Ungrouped Hierarchy DW_ACT_SOFTMAX_inst/DW_fp_add_inst_3
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fp_addsub   | sig_width=23 | U1                       |
|                |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
=============================================================================


Resource Report for Ungrouped Hierarchy DW_COMP_inst_1_left/U1 in file
        ./DW_fp_cmp__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| gt_x_3         | DW_cmp         | width=23   | gt_219                     |
| eq_x_4         | DW_cmp         | width=23   | eq_222                     |
| gt_x_5         | DW_cmp         | width=8    | gt_227                     |
| eq_x_6         | DW_cmp         | width=8    | eq_230                     |
=============================================================================


Resource Report for Ungrouped Hierarchy DW_COMP_inst_1_left/U2 in file
        ./DW_fp_cmp__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| gt_x_3         | DW_cmp         | width=23   | gt_219                     |
| eq_x_4         | DW_cmp         | width=23   | eq_222                     |
| gt_x_5         | DW_cmp         | width=8    | gt_227                     |
| eq_x_6         | DW_cmp         | width=8    | eq_230                     |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_0/U1_add_inst_0
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fp_addsub   | sig_width=23 | U1                       |
|                |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_0/U1_add_inst_1
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fp_addsub   | sig_width=23 | U1                       |
|                |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_0/U1_add_inst_2
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fp_addsub   | sig_width=23 | U1                       |
|                |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_0/U1_add_inst_3
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fp_addsub   | sig_width=23 | U1                       |
|                |                | exp_width=8 |                           |
|                |                | ieee_compliance=0 |                     |
=============================================================================


Resource Report for Ungrouped Hierarchy *cell*J9*108055/U1 in file
        ./DW_norm_rtl.vhd.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U2             | DW01_ash       | A_width=27 | U2                         |
|                |                | SH_width=3 |                            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_1/U1_add_inst_2/U1 in file
        ./DW_fp_addsub__str.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| lt_x_1         | DW_cmp         | width=31   | lt_223                     |
| ashr_5         | DW_rightsh     | A_width=26 | srl_283_lsb_trim           |
|                |                | SH_width=8 |                            |
| ash_6          | DW_leftsh      | A_width=26 | sll_285                    |
|                |                | SH_width=8 |                            |
| ash_8          | DW_leftsh      | A_width=27 | sll_337                    |
|                |                | SH_width=6 |                            |
| add_x_9        | DW01_add       | width=5    | add_339                    |
| add_x_16       | DW01_inc       | width=23   | add_398                    |
| U2             | DW_lzd         | a_width=28 | U2                         |
| U1             | DW_norm        | a_width=27 | U1                         |
|                |                | srch_wind=3 |                           |
|                |                | exp_width=6 |                           |
|                |                | exp_ctr=0  |                            |
| DP_OP_65J9_187_7885             |            |                            |
|                | DP_OP_65J9_187_7885 |       |                            |
| DP_OP_66J9_188_3163             |            |                            |
|                | DP_OP_66J9_188_3163 |       |                            |
| DP_OP_67J9_189_9752             |            |                            |
|                | DP_OP_67J9_189_9752 |       |                            |
=============================================================================

Datapath Report for DP_OP_65J9_187_7885
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_65J9_187_7885  | sub_277 sub_add_279 add_279_ni                      |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 8     |                                          |
| T64   | IFO  | Signed   | 8     | O1[7:0]                                  |
| O1    | PO   | Signed   | 9     | I1 - I2                                  |
| O2    | PO   | Signed   | 8     | -T64 + $unsigned(8'b00000000)            |
==============================================================================

Datapath Report for DP_OP_66J9_188_3163
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_66J9_188_3163  | add_294 add_294_2                                   |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 27    |                                          |
| I2    | PI   | Unsigned | 28    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Unsigned | 28    | I1 + I2 + I3                             |
==============================================================================

Datapath Report for DP_OP_67J9_189_9752
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_67J9_189_9752  | add_402 sub_403                                     |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 5     |                                          |
| O1    | PO   | Unsigned | 9     | I1 + $unsigned(1'b1)                     |
| O2    | PO   | Signed   | 10    | O1 - I2                                  |
==============================================================================


Resource Report for Ungrouped Hierarchy *cell*J11*108055/U1 in file
        ./DW_norm_rtl.vhd.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U2             | DW01_ash       | A_width=27 | U2                         |
|                |                | SH_width=3 |                            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_2/U1_add_inst_2/U1 in file
        ./DW_fp_addsub__str.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| lt_x_1         | DW_cmp         | width=31   | lt_223                     |
| ashr_5         | DW_rightsh     | A_width=26 | srl_283_lsb_trim           |
|                |                | SH_width=8 |                            |
| ash_6          | DW_leftsh      | A_width=26 | sll_285                    |
|                |                | SH_width=8 |                            |
| ash_8          | DW_leftsh      | A_width=27 | sll_337                    |
|                |                | SH_width=6 |                            |
| add_x_9        | DW01_add       | width=5    | add_339                    |
| add_x_16       | DW01_inc       | width=23   | add_398                    |
| U2             | DW_lzd         | a_width=28 | U2                         |
| U1             | DW_norm        | a_width=27 | U1                         |
|                |                | srch_wind=3 |                           |
|                |                | exp_width=6 |                           |
|                |                | exp_ctr=0  |                            |
| DP_OP_65J11_187_7885            |            |                            |
|                | DP_OP_65J11_187_7885 |      |                            |
| DP_OP_66J11_188_3163            |            |                            |
|                | DP_OP_66J11_188_3163 |      |                            |
| DP_OP_67J11_189_9752            |            |                            |
|                | DP_OP_67J11_189_9752 |      |                            |
=============================================================================

Datapath Report for DP_OP_65J11_187_7885
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_65J11_187_7885 | sub_277 sub_add_279 add_279_ni                      |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 8     |                                          |
| T64   | IFO  | Signed   | 8     | O1[7:0]                                  |
| O1    | PO   | Signed   | 9     | I1 - I2                                  |
| O2    | PO   | Signed   | 8     | -T64 + $unsigned(8'b00000000)            |
==============================================================================

Datapath Report for DP_OP_66J11_188_3163
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_66J11_188_3163 | add_294 add_294_2                                   |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 27    |                                          |
| I2    | PI   | Unsigned | 28    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Unsigned | 28    | I1 + I2 + I3                             |
==============================================================================

Datapath Report for DP_OP_67J11_189_9752
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_67J11_189_9752 | add_402 sub_403                                     |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 5     |                                          |
| O1    | PO   | Unsigned | 9     | I1 + $unsigned(1'b1)                     |
| O2    | PO   | Signed   | 10    | O1 - I2                                  |
==============================================================================


Resource Report for Ungrouped Hierarchy *cell*J13*108055/U1 in file
        ./DW_norm_rtl.vhd.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U2             | DW01_ash       | A_width=27 | U2                         |
|                |                | SH_width=3 |                            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_3/U1_add_inst_2/U1 in file
        ./DW_fp_addsub__str.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| lt_x_1         | DW_cmp         | width=31   | lt_223                     |
| ashr_5         | DW_rightsh     | A_width=26 | srl_283_lsb_trim           |
|                |                | SH_width=8 |                            |
| ash_6          | DW_leftsh      | A_width=26 | sll_285                    |
|                |                | SH_width=8 |                            |
| ash_8          | DW_leftsh      | A_width=27 | sll_337                    |
|                |                | SH_width=6 |                            |
| add_x_9        | DW01_add       | width=5    | add_339                    |
| add_x_16       | DW01_inc       | width=23   | add_398                    |
| U2             | DW_lzd         | a_width=28 | U2                         |
| U1             | DW_norm        | a_width=27 | U1                         |
|                |                | srch_wind=3 |                           |
|                |                | exp_width=6 |                           |
|                |                | exp_ctr=0  |                            |
| DP_OP_65J13_187_7885            |            |                            |
|                | DP_OP_65J13_187_7885 |      |                            |
| DP_OP_66J13_188_3163            |            |                            |
|                | DP_OP_66J13_188_3163 |      |                            |
| DP_OP_67J13_189_9752            |            |                            |
|                | DP_OP_67J13_189_9752 |      |                            |
=============================================================================

Datapath Report for DP_OP_65J13_187_7885
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_65J13_187_7885 | sub_277 sub_add_279 add_279_ni                      |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 8     |                                          |
| T64   | IFO  | Signed   | 8     | O1[7:0]                                  |
| O1    | PO   | Signed   | 9     | I1 - I2                                  |
| O2    | PO   | Signed   | 8     | -T64 + $unsigned(8'b00000000)            |
==============================================================================

Datapath Report for DP_OP_66J13_188_3163
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_66J13_188_3163 | add_294 add_294_2                                   |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 27    |                                          |
| I2    | PI   | Unsigned | 28    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Unsigned | 28    | I1 + I2 + I3                             |
==============================================================================

Datapath Report for DP_OP_67J13_189_9752
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_67J13_189_9752 | add_402 sub_403                                     |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 5     |                                          |
| O1    | PO   | Unsigned | 9     | I1 + $unsigned(1'b1)                     |
| O2    | PO   | Signed   | 10    | O1 - I2                                  |
==============================================================================


Resource Report for Ungrouped Hierarchy *cell*J14*108055/U1 in file
        ./DW_norm_rtl.vhd.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U2             | DW01_ash       | A_width=27 | U2                         |
|                |                | SH_width=3 |                            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_0/U1_add_inst_2/U1 in file
        ./DW_fp_addsub__str.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| lt_x_1         | DW_cmp         | width=31   | lt_223                     |
| ashr_5         | DW_rightsh     | A_width=26 | srl_283_lsb_trim           |
|                |                | SH_width=8 |                            |
| ash_6          | DW_leftsh      | A_width=26 | sll_285                    |
|                |                | SH_width=8 |                            |
| ash_8          | DW_leftsh      | A_width=27 | sll_337                    |
|                |                | SH_width=6 |                            |
| add_x_9        | DW01_add       | width=5    | add_339                    |
| add_x_16       | DW01_inc       | width=23   | add_398                    |
| U2             | DW_lzd         | a_width=28 | U2                         |
| U1             | DW_norm        | a_width=27 | U1                         |
|                |                | srch_wind=3 |                           |
|                |                | exp_width=6 |                           |
|                |                | exp_ctr=0  |                            |
| DP_OP_65J14_187_7885            |            |                            |
|                | DP_OP_65J14_187_7885 |      |                            |
| DP_OP_66J14_188_3163            |            |                            |
|                | DP_OP_66J14_188_3163 |      |                            |
| DP_OP_67J14_189_9752            |            |                            |
|                | DP_OP_67J14_189_9752 |      |                            |
=============================================================================

Datapath Report for DP_OP_65J14_187_7885
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_65J14_187_7885 | sub_277 sub_add_279 add_279_ni                      |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 8     |                                          |
| T64   | IFO  | Signed   | 8     | O1[7:0]                                  |
| O1    | PO   | Signed   | 9     | I1 - I2                                  |
| O2    | PO   | Signed   | 8     | -T64 + $unsigned(8'b00000000)            |
==============================================================================

Datapath Report for DP_OP_66J14_188_3163
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_66J14_188_3163 | add_294 add_294_2                                   |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 27    |                                          |
| I2    | PI   | Unsigned | 28    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Unsigned | 28    | I1 + I2 + I3                             |
==============================================================================

Datapath Report for DP_OP_67J14_189_9752
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_67J14_189_9752 | add_402 sub_403                                     |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 5     |                                          |
| O1    | PO   | Unsigned | 9     | I1 + $unsigned(1'b1)                     |
| O2    | PO   | Signed   | 10    | O1 - I2                                  |
==============================================================================


Resource Report for Ungrouped Hierarchy *cell*J8*108105/U1 in file
        ./DW_norm_rtl.vhd.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U2             | DW01_ash       | A_width=27 | U2                         |
|                |                | SH_width=3 |                            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_1/U1_add_inst_1/U1 in file
        ./DW_fp_addsub__str.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| lt_x_1         | DW_cmp         | width=31   | lt_223                     |
| ashr_5         | DW_rightsh     | A_width=26 | srl_283_lsb_trim           |
|                |                | SH_width=8 |                            |
| ash_6          | DW_leftsh      | A_width=26 | sll_285                    |
|                |                | SH_width=8 |                            |
| ash_8          | DW_leftsh      | A_width=27 | sll_337                    |
|                |                | SH_width=6 |                            |
| add_x_9        | DW01_add       | width=5    | add_339                    |
| add_x_16       | DW01_inc       | width=23   | add_398                    |
| U2             | DW_lzd         | a_width=28 | U2                         |
| U1             | DW_norm        | a_width=27 | U1                         |
|                |                | srch_wind=3 |                           |
|                |                | exp_width=6 |                           |
|                |                | exp_ctr=0  |                            |
| DP_OP_65J8_187_7885             |            |                            |
|                | DP_OP_65J8_187_7885 |       |                            |
| DP_OP_66J8_188_3163             |            |                            |
|                | DP_OP_66J8_188_3163 |       |                            |
| DP_OP_67J8_189_9752             |            |                            |
|                | DP_OP_67J8_189_9752 |       |                            |
=============================================================================

Datapath Report for DP_OP_65J8_187_7885
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_65J8_187_7885  | sub_277 sub_add_279 add_279_ni                      |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 8     |                                          |
| T64   | IFO  | Signed   | 8     | O1[7:0]                                  |
| O1    | PO   | Signed   | 9     | I1 - I2                                  |
| O2    | PO   | Signed   | 8     | -T64 + $unsigned(8'b00000000)            |
==============================================================================

Datapath Report for DP_OP_66J8_188_3163
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_66J8_188_3163  | add_294 add_294_2                                   |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 27    |                                          |
| I2    | PI   | Unsigned | 28    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Unsigned | 28    | I1 + I2 + I3                             |
==============================================================================

Datapath Report for DP_OP_67J8_189_9752
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_67J8_189_9752  | add_402 sub_403                                     |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 5     |                                          |
| O1    | PO   | Unsigned | 9     | I1 + $unsigned(1'b1)                     |
| O2    | PO   | Signed   | 10    | O1 - I2                                  |
==============================================================================


Resource Report for Ungrouped Hierarchy *cell*J10*108105/U1 in file
        ./DW_norm_rtl.vhd.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U2             | DW01_ash       | A_width=27 | U2                         |
|                |                | SH_width=3 |                            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_2/U1_add_inst_1/U1 in file
        ./DW_fp_addsub__str.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| lt_x_1         | DW_cmp         | width=31   | lt_223                     |
| ashr_5         | DW_rightsh     | A_width=26 | srl_283_lsb_trim           |
|                |                | SH_width=8 |                            |
| ash_6          | DW_leftsh      | A_width=26 | sll_285                    |
|                |                | SH_width=8 |                            |
| ash_8          | DW_leftsh      | A_width=27 | sll_337                    |
|                |                | SH_width=6 |                            |
| add_x_9        | DW01_add       | width=5    | add_339                    |
| add_x_16       | DW01_inc       | width=23   | add_398                    |
| U2             | DW_lzd         | a_width=28 | U2                         |
| U1             | DW_norm        | a_width=27 | U1                         |
|                |                | srch_wind=3 |                           |
|                |                | exp_width=6 |                           |
|                |                | exp_ctr=0  |                            |
| DP_OP_65J10_187_7885            |            |                            |
|                | DP_OP_65J10_187_7885 |      |                            |
| DP_OP_66J10_188_3163            |            |                            |
|                | DP_OP_66J10_188_3163 |      |                            |
| DP_OP_67J10_189_9752            |            |                            |
|                | DP_OP_67J10_189_9752 |      |                            |
=============================================================================

Datapath Report for DP_OP_65J10_187_7885
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_65J10_187_7885 | sub_277 sub_add_279 add_279_ni                      |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 8     |                                          |
| T64   | IFO  | Signed   | 8     | O1[7:0]                                  |
| O1    | PO   | Signed   | 9     | I1 - I2                                  |
| O2    | PO   | Signed   | 8     | -T64 + $unsigned(8'b00000000)            |
==============================================================================

Datapath Report for DP_OP_66J10_188_3163
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_66J10_188_3163 | add_294 add_294_2                                   |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 27    |                                          |
| I2    | PI   | Unsigned | 28    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Unsigned | 28    | I1 + I2 + I3                             |
==============================================================================

Datapath Report for DP_OP_67J10_189_9752
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_67J10_189_9752 | add_402 sub_403                                     |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 5     |                                          |
| O1    | PO   | Unsigned | 9     | I1 + $unsigned(1'b1)                     |
| O2    | PO   | Signed   | 10    | O1 - I2                                  |
==============================================================================


Resource Report for Ungrouped Hierarchy *cell*J12*108105/U1 in file
        ./DW_norm_rtl.vhd.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U2             | DW01_ash       | A_width=27 | U2                         |
|                |                | SH_width=3 |                            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_3/U1_add_inst_1/U1 in file
        ./DW_fp_addsub__str.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| lt_x_1         | DW_cmp         | width=31   | lt_223                     |
| ashr_5         | DW_rightsh     | A_width=26 | srl_283_lsb_trim           |
|                |                | SH_width=8 |                            |
| ash_6          | DW_leftsh      | A_width=26 | sll_285                    |
|                |                | SH_width=8 |                            |
| ash_8          | DW_leftsh      | A_width=27 | sll_337                    |
|                |                | SH_width=6 |                            |
| add_x_9        | DW01_add       | width=5    | add_339                    |
| add_x_16       | DW01_inc       | width=23   | add_398                    |
| U2             | DW_lzd         | a_width=28 | U2                         |
| U1             | DW_norm        | a_width=27 | U1                         |
|                |                | srch_wind=3 |                           |
|                |                | exp_width=6 |                           |
|                |                | exp_ctr=0  |                            |
| DP_OP_65J12_187_7885            |            |                            |
|                | DP_OP_65J12_187_7885 |      |                            |
| DP_OP_66J12_188_3163            |            |                            |
|                | DP_OP_66J12_188_3163 |      |                            |
| DP_OP_67J12_189_9752            |            |                            |
|                | DP_OP_67J12_189_9752 |      |                            |
=============================================================================

Datapath Report for DP_OP_65J12_187_7885
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_65J12_187_7885 | sub_277 sub_add_279 add_279_ni                      |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 8     |                                          |
| T64   | IFO  | Signed   | 8     | O1[7:0]                                  |
| O1    | PO   | Signed   | 9     | I1 - I2                                  |
| O2    | PO   | Signed   | 8     | -T64 + $unsigned(8'b00000000)            |
==============================================================================

Datapath Report for DP_OP_66J12_188_3163
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_66J12_188_3163 | add_294 add_294_2                                   |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 27    |                                          |
| I2    | PI   | Unsigned | 28    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Unsigned | 28    | I1 + I2 + I3                             |
==============================================================================

Datapath Report for DP_OP_67J12_189_9752
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_67J12_189_9752 | add_402 sub_403                                     |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 5     |                                          |
| O1    | PO   | Unsigned | 9     | I1 + $unsigned(1'b1)                     |
| O2    | PO   | Signed   | 10    | O1 - I2                                  |
==============================================================================


Resource Report for Ungrouped Hierarchy *cell*108105/U1 in file
        ./DW_norm_rtl.vhd.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U2             | DW01_ash       | A_width=27 | U2                         |
|                |                | SH_width=3 |                            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_0/U1_add_inst_1/U1 in file
        ./DW_fp_addsub__str.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| lt_x_1         | DW_cmp         | width=31   | lt_223                     |
| ashr_5         | DW_rightsh     | A_width=26 | srl_283_lsb_trim           |
|                |                | SH_width=8 |                            |
| ash_6          | DW_leftsh      | A_width=26 | sll_285                    |
|                |                | SH_width=8 |                            |
| ash_8          | DW_leftsh      | A_width=27 | sll_337                    |
|                |                | SH_width=6 |                            |
| add_x_9        | DW01_add       | width=5    | add_339                    |
| add_x_16       | DW01_inc       | width=23   | add_398                    |
| U2             | DW_lzd         | a_width=28 | U2                         |
| U1             | DW_norm        | a_width=27 | U1                         |
|                |                | srch_wind=3 |                           |
|                |                | exp_width=6 |                           |
|                |                | exp_ctr=0  |                            |
| DP_OP_65_187_7885               |            |                            |
|                | DP_OP_65_187_7885 |         |                            |
| DP_OP_66_188_3163               |            |                            |
|                | DP_OP_66_188_3163 |         |                            |
| DP_OP_67_189_9752               |            |                            |
|                | DP_OP_67_189_9752 |         |                            |
=============================================================================

Datapath Report for DP_OP_65_187_7885
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_65_187_7885    | sub_277 sub_add_279 add_279_ni                      |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 8     |                                          |
| T64   | IFO  | Signed   | 8     | O1[7:0]                                  |
| O1    | PO   | Signed   | 9     | I1 - I2                                  |
| O2    | PO   | Signed   | 8     | -T64 + $unsigned(8'b00000000)            |
==============================================================================

Datapath Report for DP_OP_66_188_3163
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_66_188_3163    | add_294 add_294_2                                   |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 27    |                                          |
| I2    | PI   | Unsigned | 28    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Unsigned | 28    | I1 + I2 + I3                             |
==============================================================================

Datapath Report for DP_OP_67_189_9752
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_67_189_9752    | add_402 sub_403                                     |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 5     |                                          |
| O1    | PO   | Unsigned | 9     | I1 + $unsigned(1'b1)                     |
| O2    | PO   | Signed   | 10    | O1 - I2                                  |
==============================================================================


Resource Report for Ungrouped Hierarchy *cell*116618/U1 in file
        ./DW_norm_rtl.vhd.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U2             | DW01_ash       | A_width=27 | U2                         |
|                |                | SH_width=3 |                            |
=============================================================================


Resource Report for Ungrouped Hierarchy
        DW_ACT_SOFTMAX_inst/DW_fp_add_inst_2/U1 in file ./DW_fp_addsub__str.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| lt_x_1         | DW_cmp         | width=31   | lt_223                     |
| ashr_5         | DW_rightsh     | A_width=26 | srl_283_lsb_trim           |
|                |                | SH_width=8 |                            |
| ash_6          | DW_leftsh      | A_width=26 | sll_285                    |
|                |                | SH_width=8 |                            |
| ash_8          | DW_leftsh      | A_width=27 | sll_337                    |
|                |                | SH_width=6 |                            |
| add_x_9        | DW01_add       | width=5    | add_339                    |
| add_x_16       | DW01_inc       | width=23   | add_398                    |
| U2             | DW_lzd         | a_width=28 | U2                         |
| U1             | DW_norm        | a_width=27 | U1                         |
|                |                | srch_wind=3 |                           |
|                |                | exp_width=6 |                           |
|                |                | exp_ctr=0  |                            |
| DP_OP_65_195_7885               |            |                            |
|                | DP_OP_65_195_7885 |         |                            |
| DP_OP_66_196_3163               |            |                            |
|                | DP_OP_66_196_3163 |         |                            |
| DP_OP_67_197_9752               |            |                            |
|                | DP_OP_67_197_9752 |         |                            |
=============================================================================

Datapath Report for DP_OP_65_195_7885
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_65_195_7885    | sub_277 sub_add_279 add_279_ni                      |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 8     |                                          |
| T64   | IFO  | Signed   | 8     | O1[7:0]                                  |
| O1    | PO   | Signed   | 9     | I1 - I2                                  |
| O2    | PO   | Signed   | 8     | -T64 + $unsigned(8'b00000000)            |
==============================================================================

Datapath Report for DP_OP_66_196_3163
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_66_196_3163    | add_294 add_294_2                                   |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 27    |                                          |
| I2    | PI   | Unsigned | 28    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Unsigned | 28    | I1 + I2 + I3                             |
==============================================================================

Datapath Report for DP_OP_67_197_9752
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_67_197_9752    | add_402 sub_403                                     |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 5     |                                          |
| O1    | PO   | Unsigned | 9     | I1 + $unsigned(1'b1)                     |
| O2    | PO   | Signed   | 10    | O1 - I2                                  |
==============================================================================


Resource Report for Ungrouped Hierarchy *cell*J12*116502/U1 in file
        ./DW_norm_rtl.vhd.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U2             | DW01_ash       | A_width=27 | U2                         |
|                |                | SH_width=3 |                            |
=============================================================================


Resource Report for Ungrouped Hierarchy
        DW_ACT_SOFTMAX_inst/DW_fp_add_inst_3/U1 in file ./DW_fp_addsub__str.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| lt_x_1         | DW_cmp         | width=31   | lt_223                     |
| ashr_5         | DW_rightsh     | A_width=26 | srl_283_lsb_trim           |
|                |                | SH_width=8 |                            |
| ash_6          | DW_leftsh      | A_width=26 | sll_285                    |
|                |                | SH_width=8 |                            |
| ash_8          | DW_leftsh      | A_width=27 | sll_337                    |
|                |                | SH_width=6 |                            |
| add_x_9        | DW01_add       | width=5    | add_339                    |
| add_x_16       | DW01_inc       | width=23   | add_398                    |
| U2             | DW_lzd         | a_width=28 | U2                         |
| U1             | DW_norm        | a_width=27 | U1                         |
|                |                | srch_wind=3 |                           |
|                |                | exp_width=6 |                           |
|                |                | exp_ctr=0  |                            |
| DP_OP_65J12_195_7885            |            |                            |
|                | DP_OP_65J12_195_7885 |      |                            |
| DP_OP_66J12_196_3163            |            |                            |
|                | DP_OP_66J12_196_3163 |      |                            |
| DP_OP_67J12_197_9752            |            |                            |
|                | DP_OP_67J12_197_9752 |      |                            |
=============================================================================

Datapath Report for DP_OP_65J12_195_7885
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_65J12_195_7885 | sub_277 sub_add_279 add_279_ni                      |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 8     |                                          |
| T64   | IFO  | Signed   | 8     | O1[7:0]                                  |
| O1    | PO   | Signed   | 9     | I1 - I2                                  |
| O2    | PO   | Signed   | 8     | -T64 + $unsigned(8'b00000000)            |
==============================================================================

Datapath Report for DP_OP_66J12_196_3163
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_66J12_196_3163 | add_294 add_294_2                                   |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 27    |                                          |
| I2    | PI   | Unsigned | 28    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Unsigned | 28    | I1 + I2 + I3                             |
==============================================================================

Datapath Report for DP_OP_67J12_197_9752
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_67J12_197_9752 | add_402 sub_403                                     |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 5     |                                          |
| O1    | PO   | Unsigned | 9     | I1 + $unsigned(1'b1)                     |
| O2    | PO   | Signed   | 10    | O1 - I2                                  |
==============================================================================


Resource Report for Ungrouped Hierarchy *cell*J13*116523/U1 in file
        ./DW_norm_rtl.vhd.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U2             | DW01_ash       | A_width=27 | U2                         |
|                |                | SH_width=3 |                            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_1/U1_add_inst_0/U1 in file
        ./DW_fp_addsub__str.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| lt_x_1         | DW_cmp         | width=31   | lt_223                     |
| ashr_5         | DW_rightsh     | A_width=26 | srl_283_lsb_trim           |
|                |                | SH_width=8 |                            |
| ash_6          | DW_leftsh      | A_width=26 | sll_285                    |
|                |                | SH_width=8 |                            |
| ash_8          | DW_leftsh      | A_width=27 | sll_337                    |
|                |                | SH_width=6 |                            |
| add_x_9        | DW01_add       | width=5    | add_339                    |
| add_x_16       | DW01_inc       | width=23   | add_398                    |
| U2             | DW_lzd         | a_width=28 | U2                         |
| U1             | DW_norm        | a_width=27 | U1                         |
|                |                | srch_wind=3 |                           |
|                |                | exp_width=6 |                           |
|                |                | exp_ctr=0  |                            |
| DP_OP_65J13_195_7885            |            |                            |
|                | DP_OP_65J13_195_7885 |      |                            |
| DP_OP_66J13_196_3163            |            |                            |
|                | DP_OP_66J13_196_3163 |      |                            |
| DP_OP_67J13_197_9752            |            |                            |
|                | DP_OP_67J13_197_9752 |      |                            |
=============================================================================

Datapath Report for DP_OP_65J13_195_7885
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_65J13_195_7885 | sub_277 sub_add_279 add_279_ni                      |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 8     |                                          |
| T64   | IFO  | Signed   | 8     | O1[7:0]                                  |
| O1    | PO   | Signed   | 9     | I1 - I2                                  |
| O2    | PO   | Signed   | 8     | -T64 + $unsigned(8'b00000000)            |
==============================================================================

Datapath Report for DP_OP_66J13_196_3163
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_66J13_196_3163 | add_294 add_294_2                                   |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 27    |                                          |
| I2    | PI   | Unsigned | 28    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Unsigned | 28    | I1 + I2 + I3                             |
==============================================================================

Datapath Report for DP_OP_67J13_197_9752
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_67J13_197_9752 | add_402 sub_403                                     |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 5     |                                          |
| O1    | PO   | Unsigned | 9     | I1 + $unsigned(1'b1)                     |
| O2    | PO   | Signed   | 10    | O1 - I2                                  |
==============================================================================


Resource Report for Ungrouped Hierarchy *cell*J8*116670/U1 in file
        ./DW_norm_rtl.vhd.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U2             | DW01_ash       | A_width=27 | U2                         |
|                |                | SH_width=3 |                            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_2/U1_add_inst_0/U1 in file
        ./DW_fp_addsub__str.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| lt_x_1         | DW_cmp         | width=31   | lt_223                     |
| ashr_5         | DW_rightsh     | A_width=26 | srl_283_lsb_trim           |
|                |                | SH_width=8 |                            |
| ash_6          | DW_leftsh      | A_width=26 | sll_285                    |
|                |                | SH_width=8 |                            |
| ash_8          | DW_leftsh      | A_width=27 | sll_337                    |
|                |                | SH_width=6 |                            |
| add_x_9        | DW01_add       | width=5    | add_339                    |
| add_x_16       | DW01_inc       | width=23   | add_398                    |
| U2             | DW_lzd         | a_width=28 | U2                         |
| U1             | DW_norm        | a_width=27 | U1                         |
|                |                | srch_wind=3 |                           |
|                |                | exp_width=6 |                           |
|                |                | exp_ctr=0  |                            |
| DP_OP_65J8_195_7885             |            |                            |
|                | DP_OP_65J8_195_7885 |       |                            |
| DP_OP_66J8_196_3163             |            |                            |
|                | DP_OP_66J8_196_3163 |       |                            |
| DP_OP_67J8_197_9752             |            |                            |
|                | DP_OP_67J8_197_9752 |       |                            |
=============================================================================

Datapath Report for DP_OP_65J8_195_7885
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_65J8_195_7885  | sub_277 sub_add_279 add_279_ni                      |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 8     |                                          |
| T64   | IFO  | Signed   | 8     | O1[7:0]                                  |
| O1    | PO   | Signed   | 9     | I1 - I2                                  |
| O2    | PO   | Signed   | 8     | -T64 + $unsigned(8'b00000000)            |
==============================================================================

Datapath Report for DP_OP_66J8_196_3163
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_66J8_196_3163  | add_294 add_294_2                                   |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 27    |                                          |
| I2    | PI   | Unsigned | 28    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Unsigned | 28    | I1 + I2 + I3                             |
==============================================================================

Datapath Report for DP_OP_67J8_197_9752
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_67J8_197_9752  | add_402 sub_403                                     |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 5     |                                          |
| O1    | PO   | Unsigned | 9     | I1 + $unsigned(1'b1)                     |
| O2    | PO   | Signed   | 10    | O1 - I2                                  |
==============================================================================


Resource Report for Ungrouped Hierarchy *cell*J11*116523/U1 in file
        ./DW_norm_rtl.vhd.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U2             | DW01_ash       | A_width=27 | U2                         |
|                |                | SH_width=3 |                            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_3/U1_add_inst_0/U1 in file
        ./DW_fp_addsub__str.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| lt_x_1         | DW_cmp         | width=31   | lt_223                     |
| ashr_5         | DW_rightsh     | A_width=26 | srl_283_lsb_trim           |
|                |                | SH_width=8 |                            |
| ash_6          | DW_leftsh      | A_width=26 | sll_285                    |
|                |                | SH_width=8 |                            |
| ash_8          | DW_leftsh      | A_width=27 | sll_337                    |
|                |                | SH_width=6 |                            |
| add_x_9        | DW01_add       | width=5    | add_339                    |
| add_x_16       | DW01_inc       | width=23   | add_398                    |
| U2             | DW_lzd         | a_width=28 | U2                         |
| U1             | DW_norm        | a_width=27 | U1                         |
|                |                | srch_wind=3 |                           |
|                |                | exp_width=6 |                           |
|                |                | exp_ctr=0  |                            |
| DP_OP_65J11_195_7885            |            |                            |
|                | DP_OP_65J11_195_7885 |      |                            |
| DP_OP_66J11_196_3163            |            |                            |
|                | DP_OP_66J11_196_3163 |      |                            |
| DP_OP_67J11_197_9752            |            |                            |
|                | DP_OP_67J11_197_9752 |      |                            |
=============================================================================

Datapath Report for DP_OP_65J11_195_7885
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_65J11_195_7885 | sub_277 sub_add_279 add_279_ni                      |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 8     |                                          |
| T64   | IFO  | Signed   | 8     | O1[7:0]                                  |
| O1    | PO   | Signed   | 9     | I1 - I2                                  |
| O2    | PO   | Signed   | 8     | -T64 + $unsigned(8'b00000000)            |
==============================================================================

Datapath Report for DP_OP_66J11_196_3163
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_66J11_196_3163 | add_294 add_294_2                                   |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 27    |                                          |
| I2    | PI   | Unsigned | 28    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Unsigned | 28    | I1 + I2 + I3                             |
==============================================================================

Datapath Report for DP_OP_67J11_197_9752
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_67J11_197_9752 | add_402 sub_403                                     |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 5     |                                          |
| O1    | PO   | Unsigned | 9     | I1 + $unsigned(1'b1)                     |
| O2    | PO   | Signed   | 10    | O1 - I2                                  |
==============================================================================


Resource Report for Ungrouped Hierarchy *cell*J9*116523/U1 in file
        ./DW_norm_rtl.vhd.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U2             | DW01_ash       | A_width=27 | U2                         |
|                |                | SH_width=3 |                            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_0/U1_add_inst_0/U1 in file
        ./DW_fp_addsub__str.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| lt_x_1         | DW_cmp         | width=31   | lt_223                     |
| ashr_5         | DW_rightsh     | A_width=26 | srl_283_lsb_trim           |
|                |                | SH_width=8 |                            |
| ash_6          | DW_leftsh      | A_width=26 | sll_285                    |
|                |                | SH_width=8 |                            |
| ash_8          | DW_leftsh      | A_width=27 | sll_337                    |
|                |                | SH_width=6 |                            |
| add_x_9        | DW01_add       | width=5    | add_339                    |
| add_x_16       | DW01_inc       | width=23   | add_398                    |
| U2             | DW_lzd         | a_width=28 | U2                         |
| U1             | DW_norm        | a_width=27 | U1                         |
|                |                | srch_wind=3 |                           |
|                |                | exp_width=6 |                           |
|                |                | exp_ctr=0  |                            |
| DP_OP_65J9_195_7885             |            |                            |
|                | DP_OP_65J9_195_7885 |       |                            |
| DP_OP_66J9_196_3163             |            |                            |
|                | DP_OP_66J9_196_3163 |       |                            |
| DP_OP_67J9_197_9752             |            |                            |
|                | DP_OP_67J9_197_9752 |       |                            |
=============================================================================

Datapath Report for DP_OP_65J9_195_7885
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_65J9_195_7885  | sub_277 sub_add_279 add_279_ni                      |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 8     |                                          |
| T64   | IFO  | Signed   | 8     | O1[7:0]                                  |
| O1    | PO   | Signed   | 9     | I1 - I2                                  |
| O2    | PO   | Signed   | 8     | -T64 + $unsigned(8'b00000000)            |
==============================================================================

Datapath Report for DP_OP_66J9_196_3163
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_66J9_196_3163  | add_294 add_294_2                                   |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 27    |                                          |
| I2    | PI   | Unsigned | 28    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Unsigned | 28    | I1 + I2 + I3                             |
==============================================================================

Datapath Report for DP_OP_67J9_197_9752
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_67J9_197_9752  | add_402 sub_403                                     |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 5     |                                          |
| O1    | PO   | Unsigned | 9     | I1 + $unsigned(1'b1)                     |
| O2    | PO   | Signed   | 10    | O1 - I2                                  |
==============================================================================


Resource Report for Ungrouped Hierarchy *cell*J47*184058/U1 in file
        ./DW_norm_rtl.vhd.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U2             | DW01_ash       | A_width=27 | U2                         |
|                |                | SH_width=3 |                            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_2/U1_add_inst_3/U1 in file
        ./DW_fp_addsub__str.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| lt_x_1         | DW_cmp         | width=31   | lt_223                     |
| ashr_5         | DW_rightsh     | A_width=26 | srl_283_lsb_trim           |
|                |                | SH_width=8 |                            |
| ash_6          | DW_leftsh      | A_width=26 | sll_285                    |
|                |                | SH_width=8 |                            |
| ash_8          | DW_leftsh      | A_width=27 | sll_337                    |
|                |                | SH_width=6 |                            |
| add_x_9        | DW01_add       | width=5    | add_339                    |
| add_x_16       | DW01_inc       | width=23   | add_398                    |
| U2             | DW_lzd         | a_width=28 | U2                         |
| U1             | DW_norm        | a_width=27 | U1                         |
|                |                | srch_wind=3 |                           |
|                |                | exp_width=6 |                           |
|                |                | exp_ctr=0  |                            |
| DP_OP_65J47_299_7885            |            |                            |
|                | DP_OP_65J47_299_7885 |      |                            |
| DP_OP_66J47_300_3163            |            |                            |
|                | DP_OP_66J47_300_3163 |      |                            |
| DP_OP_67J47_301_9752            |            |                            |
|                | DP_OP_67J47_301_9752 |      |                            |
=============================================================================

Datapath Report for DP_OP_65J47_299_7885
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_65J47_299_7885 | sub_277 sub_add_279 add_279_ni                      |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 8     |                                          |
| T64   | IFO  | Signed   | 8     | O1[7:0]                                  |
| O1    | PO   | Signed   | 9     | I1 - I2                                  |
| O2    | PO   | Signed   | 8     | -T64 + $unsigned(8'b00000000)            |
==============================================================================

Datapath Report for DP_OP_66J47_300_3163
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_66J47_300_3163 | add_294 add_294_2                                   |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 27    |                                          |
| I2    | PI   | Unsigned | 28    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Unsigned | 28    | I1 + I2 + I3                             |
==============================================================================

Datapath Report for DP_OP_67J47_301_9752
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_67J47_301_9752 | add_402 sub_403                                     |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 5     |                                          |
| O1    | PO   | Unsigned | 9     | I1 + $unsigned(1'b1)                     |
| O2    | PO   | Signed   | 10    | O1 - I2                                  |
==============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_1/U2_mult in file
        ./DW_fp_mult__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_2        | DW01_inc       | width=8    | add_366                    |
| lte_x_3        | DW_cmp         | width=10   | lte_374                    |
| gte_x_5        | DW_cmp         | width=9    | gte_384                    |
| gte_x_7        | DW_cmp         | width=9    | gte_386                    |
| add_x_12       | DW01_add       | width=7    | add_471_4                  |
| mult_x_13      | DW_mult_uns    | a_width=24 | mult_477                   |
|                |                | b_width=24 |                            |
| eq_x_14        | DW_cmp         | width=10   | eq_478                     |
| lt_x_17        | DW_cmp         | width=8    | lt_492                     |
| lt_x_19        | DW_cmp         | width=8    | lt_497                     |
| add_x_20       | DW01_add       | width=24   | add_501                    |
| U1             | DW_lzd         | a_width=24 | U1                         |
| U2             | DW_lzd         | a_width=24 | U2                         |
| U3             | DW_lzd         | a_width=24 | U3                         |
| U4             | DW_lzd         | a_width=24 | U4                         |
| sub_x_33       | DW01_sub       | width=9    | add_363 sub_363            |
| add_x_34       | DW01_add       | width=10   | add_363 sub_363            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_0/U2_mult in file
        ./DW_fp_mult__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_2        | DW01_inc       | width=8    | add_366                    |
| lte_x_3        | DW_cmp         | width=10   | lte_374                    |
| gte_x_5        | DW_cmp         | width=9    | gte_384                    |
| gte_x_7        | DW_cmp         | width=9    | gte_386                    |
| add_x_12       | DW01_add       | width=7    | add_471_4                  |
| mult_x_13      | DW_mult_uns    | a_width=24 | mult_477                   |
|                |                | b_width=24 |                            |
| eq_x_14        | DW_cmp         | width=10   | eq_478                     |
| lt_x_17        | DW_cmp         | width=8    | lt_492                     |
| lt_x_19        | DW_cmp         | width=8    | lt_497                     |
| add_x_20       | DW01_add       | width=24   | add_501                    |
| U1             | DW_lzd         | a_width=24 | U1                         |
| U2             | DW_lzd         | a_width=24 | U2                         |
| U3             | DW_lzd         | a_width=24 | U3                         |
| U4             | DW_lzd         | a_width=24 | U4                         |
| sub_x_33       | DW01_sub       | width=9    | add_363 sub_363            |
| add_x_34       | DW01_add       | width=10   | add_363 sub_363            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_2/U2_mult in file
        ./DW_fp_mult__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_2        | DW01_inc       | width=8    | add_366                    |
| lte_x_3        | DW_cmp         | width=10   | lte_374                    |
| gte_x_5        | DW_cmp         | width=9    | gte_384                    |
| gte_x_7        | DW_cmp         | width=9    | gte_386                    |
| add_x_12       | DW01_add       | width=7    | add_471_4                  |
| mult_x_13      | DW_mult_uns    | a_width=24 | mult_477                   |
|                |                | b_width=24 |                            |
| eq_x_14        | DW_cmp         | width=10   | eq_478                     |
| lt_x_17        | DW_cmp         | width=8    | lt_492                     |
| lt_x_19        | DW_cmp         | width=8    | lt_497                     |
| add_x_20       | DW01_add       | width=24   | add_501                    |
| U1             | DW_lzd         | a_width=24 | U1                         |
| U2             | DW_lzd         | a_width=24 | U2                         |
| U3             | DW_lzd         | a_width=24 | U3                         |
| U4             | DW_lzd         | a_width=24 | U4                         |
| sub_x_33       | DW01_sub       | width=9    | add_363 sub_363            |
| add_x_34       | DW01_add       | width=10   | add_363 sub_363            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_3/U2_mult in file
        ./DW_fp_mult__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_2        | DW01_inc       | width=8    | add_366                    |
| lte_x_3        | DW_cmp         | width=10   | lte_374                    |
| gte_x_5        | DW_cmp         | width=9    | gte_384                    |
| gte_x_7        | DW_cmp         | width=9    | gte_386                    |
| add_x_12       | DW01_add       | width=7    | add_471_4                  |
| mult_x_13      | DW_mult_uns    | a_width=24 | mult_477                   |
|                |                | b_width=24 |                            |
| eq_x_14        | DW_cmp         | width=10   | eq_478                     |
| lt_x_17        | DW_cmp         | width=8    | lt_492                     |
| lt_x_19        | DW_cmp         | width=8    | lt_497                     |
| add_x_20       | DW01_add       | width=24   | add_501                    |
| U1             | DW_lzd         | a_width=24 | U1                         |
| U2             | DW_lzd         | a_width=24 | U2                         |
| U3             | DW_lzd         | a_width=24 | U3                         |
| U4             | DW_lzd         | a_width=24 | U4                         |
| sub_x_33       | DW01_sub       | width=9    | add_363 sub_363            |
| add_x_34       | DW01_add       | width=10   | add_363 sub_363            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_1/U3_mult in file
        ./DW_fp_mult__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_2        | DW01_inc       | width=8    | add_366                    |
| lte_x_3        | DW_cmp         | width=10   | lte_374                    |
| gte_x_5        | DW_cmp         | width=9    | gte_384                    |
| gte_x_7        | DW_cmp         | width=9    | gte_386                    |
| add_x_12       | DW01_add       | width=7    | add_471_4                  |
| mult_x_13      | DW_mult_uns    | a_width=24 | mult_477                   |
|                |                | b_width=24 |                            |
| eq_x_14        | DW_cmp         | width=10   | eq_478                     |
| lt_x_17        | DW_cmp         | width=8    | lt_492                     |
| lt_x_19        | DW_cmp         | width=8    | lt_497                     |
| add_x_20       | DW01_add       | width=24   | add_501                    |
| U1             | DW_lzd         | a_width=24 | U1                         |
| U2             | DW_lzd         | a_width=24 | U2                         |
| U3             | DW_lzd         | a_width=24 | U3                         |
| U4             | DW_lzd         | a_width=24 | U4                         |
| sub_x_33       | DW01_sub       | width=9    | add_363 sub_363            |
| add_x_34       | DW01_add       | width=10   | add_363 sub_363            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_0/U3_mult in file
        ./DW_fp_mult__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_2        | DW01_inc       | width=8    | add_366                    |
| lte_x_3        | DW_cmp         | width=10   | lte_374                    |
| gte_x_5        | DW_cmp         | width=9    | gte_384                    |
| gte_x_7        | DW_cmp         | width=9    | gte_386                    |
| add_x_12       | DW01_add       | width=7    | add_471_4                  |
| mult_x_13      | DW_mult_uns    | a_width=24 | mult_477                   |
|                |                | b_width=24 |                            |
| eq_x_14        | DW_cmp         | width=10   | eq_478                     |
| lt_x_17        | DW_cmp         | width=8    | lt_492                     |
| lt_x_19        | DW_cmp         | width=8    | lt_497                     |
| add_x_20       | DW01_add       | width=24   | add_501                    |
| U1             | DW_lzd         | a_width=24 | U1                         |
| U2             | DW_lzd         | a_width=24 | U2                         |
| U3             | DW_lzd         | a_width=24 | U3                         |
| U4             | DW_lzd         | a_width=24 | U4                         |
| sub_x_33       | DW01_sub       | width=9    | add_363 sub_363            |
| add_x_34       | DW01_add       | width=10   | add_363 sub_363            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_2/U0_mult in file
        ./DW_fp_mult__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_2        | DW01_inc       | width=8    | add_366                    |
| lte_x_3        | DW_cmp         | width=10   | lte_374                    |
| gte_x_5        | DW_cmp         | width=9    | gte_384                    |
| gte_x_7        | DW_cmp         | width=9    | gte_386                    |
| add_x_12       | DW01_add       | width=7    | add_471_4                  |
| mult_x_13      | DW_mult_uns    | a_width=24 | mult_477                   |
|                |                | b_width=24 |                            |
| eq_x_14        | DW_cmp         | width=10   | eq_478                     |
| lt_x_17        | DW_cmp         | width=8    | lt_492                     |
| lt_x_19        | DW_cmp         | width=8    | lt_497                     |
| add_x_20       | DW01_add       | width=24   | add_501                    |
| U1             | DW_lzd         | a_width=24 | U1                         |
| U2             | DW_lzd         | a_width=24 | U2                         |
| U3             | DW_lzd         | a_width=24 | U3                         |
| U4             | DW_lzd         | a_width=24 | U4                         |
| sub_x_33       | DW01_sub       | width=9    | add_363 sub_363            |
| add_x_34       | DW01_add       | width=10   | add_363 sub_363            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_3/U0_mult in file
        ./DW_fp_mult__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_2        | DW01_inc       | width=8    | add_366                    |
| lte_x_3        | DW_cmp         | width=10   | lte_374                    |
| gte_x_5        | DW_cmp         | width=9    | gte_384                    |
| gte_x_7        | DW_cmp         | width=9    | gte_386                    |
| add_x_12       | DW01_add       | width=7    | add_471_4                  |
| mult_x_13      | DW_mult_uns    | a_width=24 | mult_477                   |
|                |                | b_width=24 |                            |
| eq_x_14        | DW_cmp         | width=10   | eq_478                     |
| lt_x_17        | DW_cmp         | width=8    | lt_492                     |
| lt_x_19        | DW_cmp         | width=8    | lt_497                     |
| add_x_20       | DW01_add       | width=24   | add_501                    |
| U1             | DW_lzd         | a_width=24 | U1                         |
| U2             | DW_lzd         | a_width=24 | U2                         |
| U3             | DW_lzd         | a_width=24 | U3                         |
| U4             | DW_lzd         | a_width=24 | U4                         |
| sub_x_33       | DW01_sub       | width=9    | add_363 sub_363            |
| add_x_34       | DW01_add       | width=10   | add_363 sub_363            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_1/U1_mult in file
        ./DW_fp_mult__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_2        | DW01_inc       | width=8    | add_366                    |
| lte_x_3        | DW_cmp         | width=10   | lte_374                    |
| gte_x_5        | DW_cmp         | width=9    | gte_384                    |
| gte_x_7        | DW_cmp         | width=9    | gte_386                    |
| add_x_12       | DW01_add       | width=7    | add_471_4                  |
| mult_x_13      | DW_mult_uns    | a_width=24 | mult_477                   |
|                |                | b_width=24 |                            |
| eq_x_14        | DW_cmp         | width=10   | eq_478                     |
| lt_x_17        | DW_cmp         | width=8    | lt_492                     |
| lt_x_19        | DW_cmp         | width=8    | lt_497                     |
| add_x_20       | DW01_add       | width=24   | add_501                    |
| U1             | DW_lzd         | a_width=24 | U1                         |
| U2             | DW_lzd         | a_width=24 | U2                         |
| U3             | DW_lzd         | a_width=24 | U3                         |
| U4             | DW_lzd         | a_width=24 | U4                         |
| sub_x_33       | DW01_sub       | width=9    | add_363 sub_363            |
| add_x_34       | DW01_add       | width=10   | add_363 sub_363            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_0/U1_mult in file
        ./DW_fp_mult__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_2        | DW01_inc       | width=8    | add_366                    |
| lte_x_3        | DW_cmp         | width=10   | lte_374                    |
| gte_x_5        | DW_cmp         | width=9    | gte_384                    |
| gte_x_7        | DW_cmp         | width=9    | gte_386                    |
| add_x_12       | DW01_add       | width=7    | add_471_4                  |
| mult_x_13      | DW_mult_uns    | a_width=24 | mult_477                   |
|                |                | b_width=24 |                            |
| eq_x_14        | DW_cmp         | width=10   | eq_478                     |
| lt_x_17        | DW_cmp         | width=8    | lt_492                     |
| lt_x_19        | DW_cmp         | width=8    | lt_497                     |
| add_x_20       | DW01_add       | width=24   | add_501                    |
| U1             | DW_lzd         | a_width=24 | U1                         |
| U2             | DW_lzd         | a_width=24 | U2                         |
| U3             | DW_lzd         | a_width=24 | U3                         |
| U4             | DW_lzd         | a_width=24 | U4                         |
| sub_x_33       | DW01_sub       | width=9    | add_363 sub_363            |
| add_x_34       | DW01_add       | width=10   | add_363 sub_363            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_2/U1_mult in file
        ./DW_fp_mult__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_2        | DW01_inc       | width=8    | add_366                    |
| lte_x_3        | DW_cmp         | width=10   | lte_374                    |
| gte_x_5        | DW_cmp         | width=9    | gte_384                    |
| gte_x_7        | DW_cmp         | width=9    | gte_386                    |
| add_x_12       | DW01_add       | width=7    | add_471_4                  |
| mult_x_13      | DW_mult_uns    | a_width=24 | mult_477                   |
|                |                | b_width=24 |                            |
| eq_x_14        | DW_cmp         | width=10   | eq_478                     |
| lt_x_17        | DW_cmp         | width=8    | lt_492                     |
| lt_x_19        | DW_cmp         | width=8    | lt_497                     |
| add_x_20       | DW01_add       | width=24   | add_501                    |
| U1             | DW_lzd         | a_width=24 | U1                         |
| U2             | DW_lzd         | a_width=24 | U2                         |
| U3             | DW_lzd         | a_width=24 | U3                         |
| U4             | DW_lzd         | a_width=24 | U4                         |
| sub_x_33       | DW01_sub       | width=9    | add_363 sub_363            |
| add_x_34       | DW01_add       | width=10   | add_363 sub_363            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_3/U1_mult in file
        ./DW_fp_mult__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_2        | DW01_inc       | width=8    | add_366                    |
| lte_x_3        | DW_cmp         | width=10   | lte_374                    |
| gte_x_5        | DW_cmp         | width=9    | gte_384                    |
| gte_x_7        | DW_cmp         | width=9    | gte_386                    |
| add_x_12       | DW01_add       | width=7    | add_471_4                  |
| mult_x_13      | DW_mult_uns    | a_width=24 | mult_477                   |
|                |                | b_width=24 |                            |
| eq_x_14        | DW_cmp         | width=10   | eq_478                     |
| lt_x_17        | DW_cmp         | width=8    | lt_492                     |
| lt_x_19        | DW_cmp         | width=8    | lt_497                     |
| add_x_20       | DW01_add       | width=24   | add_501                    |
| U1             | DW_lzd         | a_width=24 | U1                         |
| U2             | DW_lzd         | a_width=24 | U2                         |
| U3             | DW_lzd         | a_width=24 | U3                         |
| U4             | DW_lzd         | a_width=24 | U4                         |
| sub_x_33       | DW01_sub       | width=9    | add_363 sub_363            |
| add_x_34       | DW01_add       | width=10   | add_363 sub_363            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_1/U0_mult in file
        ./DW_fp_mult__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_2        | DW01_inc       | width=8    | add_366                    |
| lte_x_3        | DW_cmp         | width=10   | lte_374                    |
| gte_x_5        | DW_cmp         | width=9    | gte_384                    |
| gte_x_7        | DW_cmp         | width=9    | gte_386                    |
| add_x_12       | DW01_add       | width=7    | add_471_4                  |
| mult_x_13      | DW_mult_uns    | a_width=24 | mult_477                   |
|                |                | b_width=24 |                            |
| eq_x_14        | DW_cmp         | width=10   | eq_478                     |
| lt_x_17        | DW_cmp         | width=8    | lt_492                     |
| lt_x_19        | DW_cmp         | width=8    | lt_497                     |
| add_x_20       | DW01_add       | width=24   | add_501                    |
| U1             | DW_lzd         | a_width=24 | U1                         |
| U2             | DW_lzd         | a_width=24 | U2                         |
| U3             | DW_lzd         | a_width=24 | U3                         |
| U4             | DW_lzd         | a_width=24 | U4                         |
| sub_x_33       | DW01_sub       | width=9    | add_363 sub_363            |
| add_x_34       | DW01_add       | width=10   | add_363 sub_363            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_0/U0_mult in file
        ./DW_fp_mult__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_2        | DW01_inc       | width=8    | add_366                    |
| lte_x_3        | DW_cmp         | width=10   | lte_374                    |
| gte_x_5        | DW_cmp         | width=9    | gte_384                    |
| gte_x_7        | DW_cmp         | width=9    | gte_386                    |
| add_x_12       | DW01_add       | width=7    | add_471_4                  |
| mult_x_13      | DW_mult_uns    | a_width=24 | mult_477                   |
|                |                | b_width=24 |                            |
| eq_x_14        | DW_cmp         | width=10   | eq_478                     |
| lt_x_17        | DW_cmp         | width=8    | lt_492                     |
| lt_x_19        | DW_cmp         | width=8    | lt_497                     |
| add_x_20       | DW01_add       | width=24   | add_501                    |
| U1             | DW_lzd         | a_width=24 | U1                         |
| U2             | DW_lzd         | a_width=24 | U2                         |
| U3             | DW_lzd         | a_width=24 | U3                         |
| U4             | DW_lzd         | a_width=24 | U4                         |
| sub_x_33       | DW01_sub       | width=9    | add_363 sub_363            |
| add_x_34       | DW01_add       | width=10   | add_363 sub_363            |
=============================================================================


Resource Report for Ungrouped Hierarchy *cell*J46*184022/U1 in file
        ./DW_norm_rtl.vhd.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U2             | DW01_ash       | A_width=27 | U2                         |
|                |                | SH_width=3 |                            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_3/U1_add_inst_3/U1 in file
        ./DW_fp_addsub__str.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| lt_x_1         | DW_cmp         | width=31   | lt_223                     |
| ashr_5         | DW_rightsh     | A_width=26 | srl_283_lsb_trim           |
|                |                | SH_width=8 |                            |
| ash_6          | DW_leftsh      | A_width=26 | sll_285                    |
|                |                | SH_width=8 |                            |
| ash_8          | DW_leftsh      | A_width=27 | sll_337                    |
|                |                | SH_width=6 |                            |
| add_x_9        | DW01_add       | width=5    | add_339                    |
| add_x_16       | DW01_inc       | width=23   | add_398                    |
| U2             | DW_lzd         | a_width=28 | U2                         |
| U1             | DW_norm        | a_width=27 | U1                         |
|                |                | srch_wind=3 |                           |
|                |                | exp_width=6 |                           |
|                |                | exp_ctr=0  |                            |
| DP_OP_65J46_299_7885            |            |                            |
|                | DP_OP_65J46_299_7885 |      |                            |
| DP_OP_66J46_300_3163            |            |                            |
|                | DP_OP_66J46_300_3163 |      |                            |
| DP_OP_67J46_301_9752            |            |                            |
|                | DP_OP_67J46_301_9752 |      |                            |
=============================================================================

Datapath Report for DP_OP_65J46_299_7885
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_65J46_299_7885 | sub_277 sub_add_279 add_279_ni                      |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 8     |                                          |
| T64   | IFO  | Signed   | 8     | O1[7:0]                                  |
| O1    | PO   | Signed   | 9     | I1 - I2                                  |
| O2    | PO   | Signed   | 8     | -T64 + $unsigned(8'b00000000)            |
==============================================================================

Datapath Report for DP_OP_66J46_300_3163
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_66J46_300_3163 | add_294 add_294_2                                   |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 27    |                                          |
| I2    | PI   | Unsigned | 28    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Unsigned | 28    | I1 + I2 + I3                             |
==============================================================================

Datapath Report for DP_OP_67J46_301_9752
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_67J46_301_9752 | add_402 sub_403                                     |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 5     |                                          |
| O1    | PO   | Unsigned | 9     | I1 + $unsigned(1'b1)                     |
| O2    | PO   | Signed   | 10    | O1 - I2                                  |
==============================================================================


Resource Report for Ungrouped Hierarchy *cell*J44*184004/U1 in file
        ./DW_norm_rtl.vhd.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U2             | DW01_ash       | A_width=27 | U2                         |
|                |                | SH_width=3 |                            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_1/U1_add_inst_3/U1 in file
        ./DW_fp_addsub__str.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| lt_x_1         | DW_cmp         | width=31   | lt_223                     |
| ashr_5         | DW_rightsh     | A_width=26 | srl_283_lsb_trim           |
|                |                | SH_width=8 |                            |
| ash_6          | DW_leftsh      | A_width=26 | sll_285                    |
|                |                | SH_width=8 |                            |
| ash_8          | DW_leftsh      | A_width=27 | sll_337                    |
|                |                | SH_width=6 |                            |
| add_x_9        | DW01_add       | width=5    | add_339                    |
| add_x_16       | DW01_inc       | width=23   | add_398                    |
| U2             | DW_lzd         | a_width=28 | U2                         |
| U1             | DW_norm        | a_width=27 | U1                         |
|                |                | srch_wind=3 |                           |
|                |                | exp_width=6 |                           |
|                |                | exp_ctr=0  |                            |
| DP_OP_65J44_299_7885            |            |                            |
|                | DP_OP_65J44_299_7885 |      |                            |
| DP_OP_66J44_300_3163            |            |                            |
|                | DP_OP_66J44_300_3163 |      |                            |
| DP_OP_67J44_301_9752            |            |                            |
|                | DP_OP_67J44_301_9752 |      |                            |
=============================================================================

Datapath Report for DP_OP_65J44_299_7885
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_65J44_299_7885 | sub_277 sub_add_279 add_279_ni                      |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 8     |                                          |
| T64   | IFO  | Signed   | 8     | O1[7:0]                                  |
| O1    | PO   | Signed   | 9     | I1 - I2                                  |
| O2    | PO   | Signed   | 8     | -T64 + $unsigned(8'b00000000)            |
==============================================================================

Datapath Report for DP_OP_66J44_300_3163
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_66J44_300_3163 | add_294 add_294_2                                   |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 27    |                                          |
| I2    | PI   | Unsigned | 28    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Unsigned | 28    | I1 + I2 + I3                             |
==============================================================================

Datapath Report for DP_OP_67J44_301_9752
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_67J44_301_9752 | add_402 sub_403                                     |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 5     |                                          |
| O1    | PO   | Unsigned | 9     | I1 + $unsigned(1'b1)                     |
| O2    | PO   | Signed   | 10    | O1 - I2                                  |
==============================================================================


Resource Report for Ungrouped Hierarchy *cell*J48*184015/U1 in file
        ./DW_norm_rtl.vhd.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U2             | DW01_ash       | A_width=27 | U2                         |
|                |                | SH_width=3 |                            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_0/U1_add_inst_3/U1 in file
        ./DW_fp_addsub__str.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| lt_x_1         | DW_cmp         | width=31   | lt_223                     |
| ashr_5         | DW_rightsh     | A_width=26 | srl_283_lsb_trim           |
|                |                | SH_width=8 |                            |
| ash_6          | DW_leftsh      | A_width=26 | sll_285                    |
|                |                | SH_width=8 |                            |
| ash_8          | DW_leftsh      | A_width=27 | sll_337                    |
|                |                | SH_width=6 |                            |
| add_x_9        | DW01_add       | width=5    | add_339                    |
| add_x_16       | DW01_inc       | width=23   | add_398                    |
| U2             | DW_lzd         | a_width=28 | U2                         |
| U1             | DW_norm        | a_width=27 | U1                         |
|                |                | srch_wind=3 |                           |
|                |                | exp_width=6 |                           |
|                |                | exp_ctr=0  |                            |
| DP_OP_65J48_299_7885            |            |                            |
|                | DP_OP_65J48_299_7885 |      |                            |
| DP_OP_66J48_300_3163            |            |                            |
|                | DP_OP_66J48_300_3163 |      |                            |
| DP_OP_67J48_301_9752            |            |                            |
|                | DP_OP_67J48_301_9752 |      |                            |
=============================================================================

Datapath Report for DP_OP_65J48_299_7885
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_65J48_299_7885 | sub_277 sub_add_279 add_279_ni                      |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 8     |                                          |
| T64   | IFO  | Signed   | 8     | O1[7:0]                                  |
| O1    | PO   | Signed   | 9     | I1 - I2                                  |
| O2    | PO   | Signed   | 8     | -T64 + $unsigned(8'b00000000)            |
==============================================================================

Datapath Report for DP_OP_66J48_300_3163
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_66J48_300_3163 | add_294 add_294_2                                   |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 27    |                                          |
| I2    | PI   | Unsigned | 28    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Unsigned | 28    | I1 + I2 + I3                             |
==============================================================================

Datapath Report for DP_OP_67J48_301_9752
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_67J48_301_9752 | add_402 sub_403                                     |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 5     |                                          |
| O1    | PO   | Unsigned | 9     | I1 + $unsigned(1'b1)                     |
| O2    | PO   | Signed   | 10    | O1 - I2                                  |
==============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_2/U3_mult in file
        ./DW_fp_mult__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_2        | DW01_inc       | width=8    | add_366                    |
| lte_x_3        | DW_cmp         | width=10   | lte_374                    |
| gte_x_5        | DW_cmp         | width=9    | gte_384                    |
| gte_x_7        | DW_cmp         | width=9    | gte_386                    |
| add_x_12       | DW01_add       | width=7    | add_471_4                  |
| mult_x_13      | DW_mult_uns    | a_width=24 | mult_477                   |
|                |                | b_width=24 |                            |
| eq_x_14        | DW_cmp         | width=10   | eq_478                     |
| lt_x_17        | DW_cmp         | width=8    | lt_492                     |
| lt_x_19        | DW_cmp         | width=8    | lt_497                     |
| add_x_20       | DW01_add       | width=24   | add_501                    |
| U1             | DW_lzd         | a_width=24 | U1                         |
| U2             | DW_lzd         | a_width=24 | U2                         |
| U3             | DW_lzd         | a_width=24 | U3                         |
| U4             | DW_lzd         | a_width=24 | U4                         |
| sub_x_33       | DW01_sub       | width=9    | add_363 sub_363            |
| add_x_34       | DW01_add       | width=10   | add_363 sub_363            |
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_3/U3_mult in file
        ./DW_fp_mult__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_2        | DW01_inc       | width=8    | add_366                    |
| lte_x_3        | DW_cmp         | width=10   | lte_374                    |
| gte_x_5        | DW_cmp         | width=9    | gte_384                    |
| gte_x_7        | DW_cmp         | width=9    | gte_386                    |
| add_x_12       | DW01_add       | width=7    | add_471_4                  |
| mult_x_13      | DW_mult_uns    | a_width=24 | mult_477                   |
|                |                | b_width=24 |                            |
| eq_x_14        | DW_cmp         | width=10   | eq_478                     |
| lt_x_17        | DW_cmp         | width=8    | lt_492                     |
| lt_x_19        | DW_cmp         | width=8    | lt_497                     |
| add_x_20       | DW01_add       | width=24   | add_501                    |
| U1             | DW_lzd         | a_width=24 | U1                         |
| U2             | DW_lzd         | a_width=24 | U2                         |
| U3             | DW_lzd         | a_width=24 | U3                         |
| U4             | DW_lzd         | a_width=24 | U4                         |
| sub_x_33       | DW01_sub       | width=9    | add_363 sub_363            |
| add_x_34       | DW01_add       | width=10   | add_363 sub_363            |
=============================================================================


Resource Report for Ungrouped Hierarchy
        DW_ACT_SOFTMAX_inst/FP_div_pipe_inst/DW_fp_mult_inst_0/U3
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy
        DW_ACT_SOFTMAX_inst/FP_div_pipe_inst/DW_fp_mult_inst_0/U4
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy
        DW_ACT_SOFTMAX_inst/FP_div_pipe_inst/DW_fp_mult_inst_0 in file
        ./DW_fp_mult__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_2        | DW01_inc       | width=8    | add_366                    |
| lte_x_3        | DW_cmp         | width=10   | lte_374                    |
| gte_x_5        | DW_cmp         | width=9    | gte_384                    |
| gte_x_7        | DW_cmp         | width=9    | gte_386                    |
| add_x_12       | DW01_add       | width=7    | add_471_4                  |
| mult_x_13      | DW_mult_uns    | a_width=24 | mult_477                   |
|                |                | b_width=24 |                            |
| eq_x_14        | DW_cmp         | width=10   | eq_478                     |
| lt_x_17        | DW_cmp         | width=8    | lt_492                     |
| lt_x_19        | DW_cmp         | width=8    | lt_497                     |
| add_x_20       | DW01_add       | width=24   | add_501                    |
| U1             | DW_lzd         | a_width=24 | U1                         |
| U2             | DW_lzd         | a_width=24 | U2                         |
| U3             | DW_lzd         | a_width=24 | U3                         |
| U4             | DW_lzd         | a_width=24 | U4                         |
| sub_x_33       | DW01_sub       | width=9    | add_363 sub_363            |
| add_x_34       | DW01_add       | width=10   | add_363 sub_363            |
=============================================================================


Resource Report for Ungrouped Hierarchy
        DW_ACT_SOFTMAX_inst/DW_fp_sub_inst_1/U1 in file ./DW_fp_addsub__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| lt_x_1         | DW_cmp         | width=31   | lt_191                     |
| sub_x_4        | DW01_sub       | width=8    | sub_232                    |
| ashr_5         | DW_rightsh     | A_width=26 | srl_237_lsb_trim           |
|                |                | SH_width=8 |                            |
| ash_6          | DW_leftsh      | A_width=26 | sll_239                    |
|                |                | SH_width=8 |                            |
| ash_8          | DW_leftsh      | A_width=26 | sll_266                    |
|                |                | SH_width=5 |                            |
| add_x_12       | DW01_inc       | width=23   | add_303                    |
| U1             | DW_lzd         | a_width=27 | U1                         |
| DP_OP_49J1_160_3163             |            |                            |
|                | DP_OP_49J1_160_3163 |       |                            |
| DP_OP_50J1_161_9752             |            |                            |
|                | DP_OP_50J1_161_9752 |       |                            |
=============================================================================

Datapath Report for DP_OP_49J1_160_3163
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_49J1_160_3163  | add_249 add_249_2                                   |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 27    |                                          |
| I2    | PI   | Unsigned | 28    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Unsigned | 28    | I1 + I2 + I3                             |
==============================================================================

Datapath Report for DP_OP_50J1_161_9752
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_50J1_161_9752  | add_306 sub_307                                     |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 5     |                                          |
| O1    | PO   | Unsigned | 9     | I1 + $unsigned(1'b1)                     |
| O2    | PO   | Signed   | 10    | O1 - I2                                  |
==============================================================================


Resource Report for Ungrouped Hierarchy
        DW_ACT_SOFTMAX_inst/DW_fp_add_inst_1/U1 in file ./DW_fp_addsub__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| lt_x_1         | DW_cmp         | width=31   | lt_191                     |
| sub_x_4        | DW01_sub       | width=8    | sub_232                    |
| ashr_5         | DW_rightsh     | A_width=26 | srl_237_lsb_trim           |
|                |                | SH_width=8 |                            |
| ash_6          | DW_leftsh      | A_width=26 | sll_239                    |
|                |                | SH_width=8 |                            |
| ash_8          | DW_leftsh      | A_width=26 | sll_266                    |
|                |                | SH_width=5 |                            |
| add_x_12       | DW01_inc       | width=23   | add_303                    |
| U1             | DW_lzd         | a_width=27 | U1                         |
| DP_OP_49J1_156_3163             |            |                            |
|                | DP_OP_49J1_156_3163 |       |                            |
| DP_OP_50J1_157_9752             |            |                            |
|                | DP_OP_50J1_157_9752 |       |                            |
=============================================================================

Datapath Report for DP_OP_49J1_156_3163
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_49J1_156_3163  | add_249 add_249_2                                   |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 27    |                                          |
| I2    | PI   | Unsigned | 28    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Unsigned | 28    | I1 + I2 + I3                             |
==============================================================================

Datapath Report for DP_OP_50J1_157_9752
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_50J1_157_9752  | add_306 sub_307                                     |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 8     |                                          |
| I2    | PI   | Unsigned | 5     |                                          |
| O1    | PO   | Unsigned | 9     | I1 + $unsigned(1'b1)                     |
| O2    | PO   | Signed   | 10    | O1 - I2                                  |
==============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_1/U0_mult/U4
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_1/U1_mult/U4
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_1/U2_mult/U4
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_1/U3_mult/U4
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_2/U0_mult/U4
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_2/U1_mult/U4
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_2/U2_mult/U4
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_2/U3_mult/U4
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_3/U0_mult/U4
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_3/U1_mult/U4
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_3/U2_mult/U4
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_3/U3_mult/U4
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_0/U0_mult/U4
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_0/U1_mult/U4
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_0/U2_mult/U4
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_0/U3_mult/U4
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_1/U1_add_inst_1/U1/U2
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_1/U1_add_inst_2/U1/U2
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_2/U1_add_inst_1/U1/U2
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_2/U1_add_inst_2/U1/U2
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_3/U1_add_inst_1/U1/U2
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_3/U1_add_inst_2/U1/U2
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_0/U1_add_inst_1/U1/U2
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_0/U1_add_inst_2/U1/U2
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_1/U1_add_inst_0/U1/U2
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_2/U1_add_inst_0/U1/U2
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_3/U1_add_inst_0/U1/U2
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_0/U1_add_inst_0/U1/U2
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy
        DW_ACT_SOFTMAX_inst/DW_fp_add_inst_2/U1/U2
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy
        DW_ACT_SOFTMAX_inst/DW_fp_add_inst_3/U1/U2
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_1/U1_add_inst_3/U1/U2
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_3/U1_add_inst_3/U1/U2
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_2/U1_add_inst_3/U1/U2
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_0/U1_add_inst_3/U1/U2
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_1/U0_mult/U3
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_1/U1_mult/U3
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_1/U2_mult/U3
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_1/U3_mult/U3
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_2/U0_mult/U3
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_2/U1_mult/U3
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_2/U2_mult/U3
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_2/U3_mult/U3
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_3/U0_mult/U3
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_3/U1_mult/U3
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_3/U2_mult/U3
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_3/U3_mult/U3
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_0/U0_mult/U3
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_0/U1_mult/U3
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_0/U2_mult/U3
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy PE_inst_0/U3_mult/U3
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy
        DW_ACT_SOFTMAX_inst/DW_fp_add_inst_1/U1/U1
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy
        DW_ACT_SOFTMAX_inst/DW_fp_sub_inst_1/U1/U1
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_x_425          | DW01_add         | apparch (area)     |                |
| add_x_430          | DW01_inc         | apparch (area)     |                |
| add_x_1098         | DW01_inc         | apparch (area)     |                |
| PE_inst_0/U1_add_inst_3               |                    |                |
|                    | DW_fp_add        | rtl                |                |
| PE_inst_0/U1_add_inst_2               |                    |                |
|                    | DW_fp_add        | rtl                |                |
| PE_inst_0/U1_add_inst_1               |                    |                |
|                    | DW_fp_add        | rtl                |                |
| PE_inst_0/U1_add_inst_0               |                    |                |
|                    | DW_fp_add        | rtl                |                |
| PE_inst_0/U3_mult  | DW_fp_mult       | rtl                |                |
| PE_inst_0/U2_mult  | DW_fp_mult       | rtl                |                |
| PE_inst_0/U1_mult  | DW_fp_mult       | rtl                |                |
| PE_inst_0/U0_mult  | DW_fp_mult       | rtl                |                |
| DW_COMP_inst_1_left/U2                |                    |                |
|                    | DW_fp_cmp        | rtl                |                |
| DW_COMP_inst_1_left/U1                |                    |                |
|                    | DW_fp_cmp        | rtl                |                |
| DW_ACT_SOFTMAX_inst/DW_fp_add_inst_3  |                    |                |
|                    | DW_fp_add        | rtl                |                |
| DW_ACT_SOFTMAX_inst/DW_fp_add_inst_2  |                    |                |
|                    | DW_fp_add        | rtl                |                |
| DW_ACT_SOFTMAX_inst/DW_fp_sub_inst_1  |                    |                |
|                    | DW_fp_sub        | rtl                |                |
| DW_ACT_SOFTMAX_inst/DW_fp_add_inst_1  |                    |                |
|                    | DW_fp_add        | rtl                |                |
| DW_ACT_SOFTMAX_inst/DW_fp_exp_inst    |                    |                |
|                    | DW_fp_exp        | rtl                |                |
| PE_inst_3/U1_add_inst_3               |                    |                |
|                    | DW_fp_add        | rtl                |                |
| PE_inst_3/U1_add_inst_2               |                    |                |
|                    | DW_fp_add        | rtl                |                |
| PE_inst_3/U1_add_inst_1               |                    |                |
|                    | DW_fp_add        | rtl                |                |
| PE_inst_3/U1_add_inst_0               |                    |                |
|                    | DW_fp_add        | rtl                |                |
| PE_inst_3/U3_mult  | DW_fp_mult       | rtl                |                |
| PE_inst_3/U2_mult  | DW_fp_mult       | rtl                |                |
| PE_inst_3/U1_mult  | DW_fp_mult       | rtl                |                |
| PE_inst_3/U0_mult  | DW_fp_mult       | rtl                |                |
| PE_inst_2/U1_add_inst_3               |                    |                |
|                    | DW_fp_add        | rtl                |                |
| PE_inst_2/U1_add_inst_2               |                    |                |
|                    | DW_fp_add        | rtl                |                |
| PE_inst_2/U1_add_inst_1               |                    |                |
|                    | DW_fp_add        | rtl                |                |
| PE_inst_2/U1_add_inst_0               |                    |                |
|                    | DW_fp_add        | rtl                |                |
| PE_inst_2/U3_mult  | DW_fp_mult       | rtl                |                |
| PE_inst_2/U2_mult  | DW_fp_mult       | rtl                |                |
| PE_inst_2/U1_mult  | DW_fp_mult       | rtl                |                |
| PE_inst_2/U0_mult  | DW_fp_mult       | rtl                |                |
| PE_inst_1/U1_add_inst_3               |                    |                |
|                    | DW_fp_add        | rtl                |                |
| PE_inst_1/U1_add_inst_2               |                    |                |
|                    | DW_fp_add        | rtl                |                |
| PE_inst_1/U1_add_inst_1               |                    |                |
|                    | DW_fp_add        | rtl                |                |
| PE_inst_1/U1_add_inst_0               |                    |                |
|                    | DW_fp_add        | rtl                |                |
| PE_inst_1/U3_mult  | DW_fp_mult       | rtl                |                |
| PE_inst_1/U2_mult  | DW_fp_mult       | rtl                |                |
| PE_inst_1/U1_mult  | DW_fp_mult       | rtl                |                |
| PE_inst_1/U0_mult  | DW_fp_mult       | rtl                |                |
| DW_COMP_inst_2_right/U2               |                    |                |
|                    | DW_fp_cmp        | rtl                |                |
| DW_COMP_inst_2_right/U1               |                    |                |
|                    | DW_fp_cmp        | rtl                |                |
| DW_COMP_inst_2_left/U2                |                    |                |
|                    | DW_fp_cmp        | rtl                |                |
| DW_COMP_inst_2_left/U1                |                    |                |
|                    | DW_fp_cmp        | rtl                |                |
| DW_COMP_inst_1_right/U2               |                    |                |
|                    | DW_fp_cmp        | rtl                |                |
| DW_COMP_inst_1_right/U1               |                    |                |
|                    | DW_fp_cmp        | rtl                |                |
| DW_ACT_SOFTMAX_inst/FP_div_pipe_inst/DW_fp_mult_inst_0     |                |
|                    | DW_fp_mult       | rtl                |                |
| DW_ACT_SOFTMAX_inst/FP_div_pipe_inst/DW_fp_recip_inst_0    |                |
|                    | DW_fp_recip      | rtl                |                |
| gt_x_1100          | DW_cmp           | apparch (area)     |                |
| add_x_418          | DW01_inc         | apparch (area)     |                |
| sub_x_27           | DW01_sub         | apparch (area)     |                |
| sub_x_29           | DW01_dec         | apparch (area)     |                |
| add_x_94           | DW01_inc         | apparch (area)     |                |
| sub_x_25           | DW01_sub         | apparch (area)     |                |
| sub_x_37           | DW01_sub         | apparch (area)     |                |
| add_x_95           | DW01_add         | apparch (area)     |                |
| mult_x_2           | DW_mult_uns      | pparch (speed)     |                |
|                    |                  | mult_arch: benc_radix4              |
| gte_x_5            | DW_cmp           | apparch (area)     |                |
| eq_x_9             | DW_cmp           | apparch (area)     |                |
| gt_x_3             | DW_cmp           | pparch (area,speed)                 |
| eq_x_4             | DW_cmp           | apparch (area)     |                |
| gt_x_5             | DW_cmp           | apparch (area)     |                |
| eq_x_6             | DW_cmp           | apparch (area)     |                |
| gt_x_3             | DW_cmp           | pparch (area,speed)                 |
| eq_x_4             | DW_cmp           | apparch (area)     |                |
| gt_x_5             | DW_cmp           | apparch (area)     |                |
| eq_x_6             | DW_cmp           | apparch (area)     |                |
| gt_x_3             | DW_cmp           | pparch (area,speed)                 |
| eq_x_4             | DW_cmp           | apparch (area)     |                |
| gt_x_5             | DW_cmp           | apparch (area)     |                |
| eq_x_6             | DW_cmp           | apparch (area)     |                |
| gt_x_3             | DW_cmp           | pparch (area,speed)                 |
| eq_x_4             | DW_cmp           | apparch (area)     |                |
| gt_x_5             | DW_cmp           | apparch (area)     |                |
| eq_x_6             | DW_cmp           | apparch (area)     |                |
| gt_x_3             | DW_cmp           | pparch (area,speed)                 |
| eq_x_4             | DW_cmp           | apparch (area)     |                |
| gt_x_5             | DW_cmp           | apparch (area)     |                |
| eq_x_6             | DW_cmp           | apparch (area)     |                |
| gt_x_3             | DW_cmp           | pparch (area,speed)                 |
| eq_x_4             | DW_cmp           | apparch (area)     |                |
| gt_x_5             | DW_cmp           | apparch (area)     |                |
| eq_x_6             | DW_cmp           | apparch (area)     |                |
| U1                 | DW_fp_addsub     | str                |                |
| U1                 | DW_fp_addsub     | str                |                |
| U1                 | DW_fp_addsub     | str                |                |
| U1                 | DW_fp_addsub     | str                |                |
| U1                 | DW_fp_addsub     | str                |                |
| U1                 | DW_fp_addsub     | str                |                |
| U1                 | DW_fp_addsub     | str                |                |
| U1                 | DW_fp_addsub     | str                |                |
| U1                 | DW_fp_addsub     | str                |                |
| U1                 | DW_fp_addsub     | str                |                |
| U1                 | DW_fp_addsub     | str                |                |
| U1                 | DW_fp_addsub     | str                |                |
| mult_x_91          | DW_mult_uns      | pparch (area,speed)                 |
|                    |                  | mult_arch: benc_radix4              |
| mult_x_4           | DW_mult_uns      | pparch (area,speed)                 |
| sub_x_5            | DW01_sub         | apparch (area)     |                |
| gte_x_6            | DW_cmp           | apparch (area)     |                |
| add_x_9            | DW01_add         | pparch (area,speed)                 |
| add_x_11           | DW01_inc         | pparch (speed)     |                |
| U1                 | DW01_ash         | astr (area)        |                |
| U2                 | DW_exp2          | rtl                |                |
| sub_x_16           | DW01_sub         | apparch (area)     |                |
| add_x_17           | DW01_dec         | apparch (area)     |                |
| sub_x_18           | DW01_sub         | pparch (area,speed)                 |
| add_x_19           | DW01_add         | apparch (area)     |                |
| add_x_20           | DW01_add         | apparch (area)     |                |
| U1                 | DW_fp_addsub     | rtl                |                |
| U1                 | DW_fp_addsub     | rtl                |                |
| U1                 | DW_fp_addsub     | str                |                |
| U1                 | DW_fp_addsub     | str                |                |
| gt_x_3             | DW_cmp           | pparch (area,speed)                 |
| eq_x_4             | DW_cmp           | apparch (area)     |                |
| gt_x_5             | DW_cmp           | apparch (area)     |                |
| eq_x_6             | DW_cmp           | apparch (area)     |                |
| gt_x_3             | DW_cmp           | pparch (area,speed)                 |
| eq_x_4             | DW_cmp           | apparch (area)     |                |
| gt_x_5             | DW_cmp           | apparch (area)     |                |
| eq_x_6             | DW_cmp           | apparch (area)     |                |
| U1                 | DW_fp_addsub     | str                |                |
| U1                 | DW_fp_addsub     | str                |                |
| U1                 | DW_fp_addsub     | str                |                |
| U1                 | DW_fp_addsub     | str                |                |
| U2                 | DW01_ash         | astr (area)        |                |
| lt_x_1             | DW_cmp           | pparch (area,speed)                 |
| ashr_5             | DW_rightsh       | astr (area)        |                |
| ash_6              | DW_leftsh        | astr (area)        |                |
| ash_8              | DW_leftsh        | astr (area)        |                |
| add_x_9            | DW01_add         | apparch (area)     |                |
| add_x_16           | DW01_inc         | pparch (area,speed)                 |
| U2                 | DW_lzd           | cla                |                |
| U1                 | DW_norm          | rtl                |                |
| U2                 | DW01_ash         | astr (area)        |                |
| lt_x_1             | DW_cmp           | pparch (area,speed)                 |
| ashr_5             | DW_rightsh       | astr (area)        |                |
| ash_6              | DW_leftsh        | astr (area)        |                |
| ash_8              | DW_leftsh        | astr (area)        |                |
| add_x_9            | DW01_add         | apparch (area)     |                |
| add_x_16           | DW01_inc         | pparch (area,speed)                 |
| U2                 | DW_lzd           | cla                |                |
| U1                 | DW_norm          | rtl                |                |
| U2                 | DW01_ash         | astr (area)        |                |
| lt_x_1             | DW_cmp           | pparch (area,speed)                 |
| ashr_5             | DW_rightsh       | astr (area)        |                |
| ash_6              | DW_leftsh        | astr (area)        |                |
| ash_8              | DW_leftsh        | astr (area)        |                |
| add_x_9            | DW01_add         | apparch (area)     |                |
| add_x_16           | DW01_inc         | pparch (area,speed)                 |
| U2                 | DW_lzd           | cla                |                |
| U1                 | DW_norm          | rtl                |                |
| U2                 | DW01_ash         | astr (area)        |                |
| lt_x_1             | DW_cmp           | pparch (area,speed)                 |
| ashr_5             | DW_rightsh       | astr (area)        |                |
| ash_6              | DW_leftsh        | astr (area)        |                |
| ash_8              | DW_leftsh        | astr (area)        |                |
| add_x_9            | DW01_add         | apparch (area)     |                |
| add_x_16           | DW01_inc         | pparch (area,speed)                 |
| U2                 | DW_lzd           | cla                |                |
| U1                 | DW_norm          | rtl                |                |
| U2                 | DW01_ash         | astr (area)        |                |
| lt_x_1             | DW_cmp           | pparch (area,speed)                 |
| ashr_5             | DW_rightsh       | astr (area)        |                |
| ash_6              | DW_leftsh        | astr (area)        |                |
| ash_8              | DW_leftsh        | astr (area)        |                |
| add_x_9            | DW01_add         | apparch (area)     |                |
| add_x_16           | DW01_inc         | pparch (area,speed)                 |
| U2                 | DW_lzd           | cla                |                |
| U1                 | DW_norm          | rtl                |                |
| U2                 | DW01_ash         | astr (area)        |                |
| lt_x_1             | DW_cmp           | pparch (area,speed)                 |
| ashr_5             | DW_rightsh       | astr (area)        |                |
| ash_6              | DW_leftsh        | astr (area)        |                |
| ash_8              | DW_leftsh        | astr (area)        |                |
| add_x_9            | DW01_add         | apparch (area)     |                |
| add_x_16           | DW01_inc         | pparch (area,speed)                 |
| U2                 | DW_lzd           | cla                |                |
| U1                 | DW_norm          | rtl                |                |
| U2                 | DW01_ash         | astr (area)        |                |
| lt_x_1             | DW_cmp           | pparch (area,speed)                 |
| ashr_5             | DW_rightsh       | astr (area)        |                |
| ash_6              | DW_leftsh        | astr (area)        |                |
| ash_8              | DW_leftsh        | astr (area)        |                |
| add_x_9            | DW01_add         | apparch (area)     |                |
| add_x_16           | DW01_inc         | pparch (area,speed)                 |
| U2                 | DW_lzd           | cla                |                |
| U1                 | DW_norm          | rtl                |                |
| U2                 | DW01_ash         | astr (area)        |                |
| lt_x_1             | DW_cmp           | pparch (area,speed)                 |
| ashr_5             | DW_rightsh       | astr (area)        |                |
| ash_6              | DW_leftsh        | astr (area)        |                |
| ash_8              | DW_leftsh        | astr (area)        |                |
| add_x_9            | DW01_add         | apparch (area)     |                |
| add_x_16           | DW01_inc         | pparch (area,speed)                 |
| U2                 | DW_lzd           | cla                |                |
| U1                 | DW_norm          | rtl                |                |
| U2                 | DW01_ash         | astr (area)        |                |
| lt_x_1             | DW_cmp           | pparch (area,speed)                 |
| ashr_5             | DW_rightsh       | astr (area)        |                |
| ash_6              | DW_leftsh        | astr (area)        |                |
| ash_8              | DW_leftsh        | astr (area)        |                |
| add_x_9            | DW01_add         | apparch (area)     |                |
| add_x_16           | DW01_inc         | pparch (area,speed)                 |
| U2                 | DW_lzd           | cla                |                |
| U1                 | DW_norm          | rtl                |                |
| U2                 | DW01_ash         | astr (area)        |                |
| lt_x_1             | DW_cmp           | pparch (area,speed)                 |
| ashr_5             | DW_rightsh       | astr (area)        |                |
| ash_6              | DW_leftsh        | astr (area)        |                |
| ash_8              | DW_leftsh        | astr (area)        |                |
| add_x_9            | DW01_add         | apparch (area)     |                |
| add_x_16           | DW01_inc         | pparch (area,speed)                 |
| U2                 | DW_lzd           | cla                |                |
| U1                 | DW_norm          | rtl                |                |
| U2                 | DW01_ash         | astr (area)        |                |
| lt_x_1             | DW_cmp           | pparch (area,speed)                 |
| ashr_5             | DW_rightsh       | astr (area)        |                |
| ash_6              | DW_leftsh        | astr (area)        |                |
| ash_8              | DW_leftsh        | astr (area)        |                |
| add_x_9            | DW01_add         | apparch (area)     |                |
| add_x_16           | DW01_inc         | pparch (area,speed)                 |
| U2                 | DW_lzd           | cla                |                |
| U1                 | DW_norm          | rtl                |                |
| U2                 | DW01_ash         | astr (area)        |                |
| lt_x_1             | DW_cmp           | pparch (area,speed)                 |
| ashr_5             | DW_rightsh       | astr (area)        |                |
| ash_6              | DW_leftsh        | astr (area)        |                |
| ash_8              | DW_leftsh        | astr (area)        |                |
| add_x_9            | DW01_add         | apparch (area)     |                |
| add_x_16           | DW01_inc         | pparch (area,speed)                 |
| U2                 | DW_lzd           | cla                |                |
| U1                 | DW_norm          | rtl                |                |
| U2                 | DW01_ash         | astr (area)        |                |
| lt_x_1             | DW_cmp           | pparch (area,speed)                 |
| ashr_5             | DW_rightsh       | astr (area)        |                |
| ash_6              | DW_leftsh        | astr (area)        |                |
| ash_8              | DW_leftsh        | astr (area)        |                |
| add_x_9            | DW01_add         | apparch (area)     |                |
| add_x_16           | DW01_inc         | pparch (area,speed)                 |
| U2                 | DW_lzd           | cla                |                |
| U1                 | DW_norm          | rtl                |                |
| U2                 | DW01_ash         | astr (area)        |                |
| lt_x_1             | DW_cmp           | pparch (area,speed)                 |
| ashr_5             | DW_rightsh       | astr (area)        |                |
| ash_6              | DW_leftsh        | astr (area)        |                |
| ash_8              | DW_leftsh        | astr (area)        |                |
| add_x_9            | DW01_add         | apparch (area)     |                |
| add_x_16           | DW01_inc         | pparch (area,speed)                 |
| U2                 | DW_lzd           | cla                |                |
| U1                 | DW_norm          | rtl                |                |
| U2                 | DW01_ash         | astr (area)        |                |
| lt_x_1             | DW_cmp           | pparch (area,speed)                 |
| ashr_5             | DW_rightsh       | astr (area)        |                |
| ash_6              | DW_leftsh        | astr (area)        |                |
| ash_8              | DW_leftsh        | astr (area)        |                |
| add_x_9            | DW01_add         | apparch (area)     |                |
| add_x_16           | DW01_inc         | pparch (area,speed)                 |
| U2                 | DW_lzd           | cla                |                |
| U1                 | DW_norm          | rtl                |                |
| add_x_2            | DW01_inc         | apparch (area)     |                |
| lte_x_3            | DW_cmp           | apparch (area)     |                |
| gte_x_5            | DW_cmp           | apparch (area)     |                |
| gte_x_7            | DW_cmp           | apparch (area)     |                |
| add_x_12           | DW01_add         | apparch (area)     |                |
| mult_x_13          | DW_mult_uns      | pparch (area,speed)                 |
|                    |                  | mult_arch: benc_radix8              |
| eq_x_14            | DW_cmp           | apparch (area)     |                |
| lt_x_17            | DW_cmp           | apparch (area)     |                |
| lt_x_19            | DW_cmp           | apparch (area)     |                |
| add_x_20           | DW01_add         | pparch (area,speed)                 |
| U3                 | DW_lzd           | rtl                |                |
| U4                 | DW_lzd           | rtl                |                |
| sub_x_33           | DW01_sub         | apparch (area)     |                |
| add_x_34           | DW01_add         | apparch (area)     |                |
| add_x_2            | DW01_inc         | apparch (area)     |                |
| lte_x_3            | DW_cmp           | apparch (area)     |                |
| gte_x_5            | DW_cmp           | apparch (area)     |                |
| gte_x_7            | DW_cmp           | apparch (area)     |                |
| add_x_12           | DW01_add         | apparch (area)     |                |
| mult_x_13          | DW_mult_uns      | pparch (area,speed)                 |
|                    |                  | mult_arch: benc_radix8              |
| eq_x_14            | DW_cmp           | apparch (area)     |                |
| lt_x_17            | DW_cmp           | apparch (area)     |                |
| lt_x_19            | DW_cmp           | apparch (area)     |                |
| add_x_20           | DW01_add         | pparch (area,speed)                 |
| U3                 | DW_lzd           | rtl                |                |
| U4                 | DW_lzd           | rtl                |                |
| sub_x_33           | DW01_sub         | apparch (area)     |                |
| add_x_34           | DW01_add         | apparch (area)     |                |
| add_x_2            | DW01_inc         | apparch (area)     |                |
| lte_x_3            | DW_cmp           | apparch (area)     |                |
| gte_x_5            | DW_cmp           | apparch (area)     |                |
| gte_x_7            | DW_cmp           | apparch (area)     |                |
| add_x_12           | DW01_add         | apparch (area)     |                |
| mult_x_13          | DW_mult_uns      | pparch (area,speed)                 |
|                    |                  | mult_arch: benc_radix8              |
| eq_x_14            | DW_cmp           | apparch (area)     |                |
| lt_x_17            | DW_cmp           | apparch (area)     |                |
| lt_x_19            | DW_cmp           | apparch (area)     |                |
| add_x_20           | DW01_add         | pparch (area,speed)                 |
| U3                 | DW_lzd           | rtl                |                |
| U4                 | DW_lzd           | rtl                |                |
| sub_x_33           | DW01_sub         | apparch (area)     |                |
| add_x_34           | DW01_add         | apparch (area)     |                |
| add_x_2            | DW01_inc         | apparch (area)     |                |
| lte_x_3            | DW_cmp           | apparch (area)     |                |
| gte_x_5            | DW_cmp           | apparch (area)     |                |
| gte_x_7            | DW_cmp           | apparch (area)     |                |
| add_x_12           | DW01_add         | apparch (area)     |                |
| mult_x_13          | DW_mult_uns      | pparch (area,speed)                 |
|                    |                  | mult_arch: benc_radix8              |
| eq_x_14            | DW_cmp           | apparch (area)     |                |
| lt_x_17            | DW_cmp           | apparch (area)     |                |
| lt_x_19            | DW_cmp           | apparch (area)     |                |
| add_x_20           | DW01_add         | pparch (area,speed)                 |
| U3                 | DW_lzd           | rtl                |                |
| U4                 | DW_lzd           | rtl                |                |
| sub_x_33           | DW01_sub         | apparch (area)     |                |
| add_x_34           | DW01_add         | apparch (area)     |                |
| add_x_2            | DW01_inc         | apparch (area)     |                |
| lte_x_3            | DW_cmp           | apparch (area)     |                |
| gte_x_5            | DW_cmp           | apparch (area)     |                |
| gte_x_7            | DW_cmp           | apparch (area)     |                |
| add_x_12           | DW01_add         | apparch (area)     |                |
| mult_x_13          | DW_mult_uns      | pparch (area,speed)                 |
|                    |                  | mult_arch: benc_radix8              |
| eq_x_14            | DW_cmp           | apparch (area)     |                |
| lt_x_17            | DW_cmp           | apparch (area)     |                |
| lt_x_19            | DW_cmp           | apparch (area)     |                |
| add_x_20           | DW01_add         | pparch (area,speed)                 |
| U3                 | DW_lzd           | rtl                |                |
| U4                 | DW_lzd           | rtl                |                |
| sub_x_33           | DW01_sub         | apparch (area)     |                |
| add_x_34           | DW01_add         | apparch (area)     |                |
| add_x_2            | DW01_inc         | apparch (area)     |                |
| lte_x_3            | DW_cmp           | apparch (area)     |                |
| gte_x_5            | DW_cmp           | apparch (area)     |                |
| gte_x_7            | DW_cmp           | apparch (area)     |                |
| add_x_12           | DW01_add         | apparch (area)     |                |
| mult_x_13          | DW_mult_uns      | pparch (area,speed)                 |
|                    |                  | mult_arch: benc_radix8              |
| eq_x_14            | DW_cmp           | apparch (area)     |                |
| lt_x_17            | DW_cmp           | apparch (area)     |                |
| lt_x_19            | DW_cmp           | apparch (area)     |                |
| add_x_20           | DW01_add         | pparch (area,speed)                 |
| U3                 | DW_lzd           | rtl                |                |
| U4                 | DW_lzd           | rtl                |                |
| sub_x_33           | DW01_sub         | apparch (area)     |                |
| add_x_34           | DW01_add         | apparch (area)     |                |
| add_x_2            | DW01_inc         | apparch (area)     |                |
| lte_x_3            | DW_cmp           | apparch (area)     |                |
| gte_x_5            | DW_cmp           | apparch (area)     |                |
| gte_x_7            | DW_cmp           | apparch (area)     |                |
| add_x_12           | DW01_add         | apparch (area)     |                |
| mult_x_13          | DW_mult_uns      | pparch (area,speed)                 |
|                    |                  | mult_arch: benc_radix8              |
| eq_x_14            | DW_cmp           | apparch (area)     |                |
| lt_x_17            | DW_cmp           | apparch (area)     |                |
| lt_x_19            | DW_cmp           | apparch (area)     |                |
| add_x_20           | DW01_add         | pparch (area,speed)                 |
| U3                 | DW_lzd           | rtl                |                |
| U4                 | DW_lzd           | rtl                |                |
| sub_x_33           | DW01_sub         | apparch (area)     |                |
| add_x_34           | DW01_add         | apparch (area)     |                |
| add_x_2            | DW01_inc         | apparch (area)     |                |
| lte_x_3            | DW_cmp           | apparch (area)     |                |
| gte_x_5            | DW_cmp           | apparch (area)     |                |
| gte_x_7            | DW_cmp           | apparch (area)     |                |
| add_x_12           | DW01_add         | apparch (area)     |                |
| mult_x_13          | DW_mult_uns      | pparch (area,speed)                 |
|                    |                  | mult_arch: benc_radix8              |
| eq_x_14            | DW_cmp           | apparch (area)     |                |
| lt_x_17            | DW_cmp           | apparch (area)     |                |
| lt_x_19            | DW_cmp           | apparch (area)     |                |
| add_x_20           | DW01_add         | pparch (area,speed)                 |
| U3                 | DW_lzd           | rtl                |                |
| U4                 | DW_lzd           | rtl                |                |
| sub_x_33           | DW01_sub         | apparch (area)     |                |
| add_x_34           | DW01_add         | apparch (area)     |                |
| add_x_2            | DW01_inc         | apparch (area)     |                |
| lte_x_3            | DW_cmp           | apparch (area)     |                |
| gte_x_5            | DW_cmp           | apparch (area)     |                |
| gte_x_7            | DW_cmp           | apparch (area)     |                |
| add_x_12           | DW01_add         | apparch (area)     |                |
| mult_x_13          | DW_mult_uns      | pparch (area,speed)                 |
|                    |                  | mult_arch: benc_radix8              |
| eq_x_14            | DW_cmp           | apparch (area)     |                |
| lt_x_17            | DW_cmp           | apparch (area)     |                |
| lt_x_19            | DW_cmp           | apparch (area)     |                |
| add_x_20           | DW01_add         | pparch (area,speed)                 |
| U3                 | DW_lzd           | rtl                |                |
| U4                 | DW_lzd           | rtl                |                |
| sub_x_33           | DW01_sub         | apparch (area)     |                |
| add_x_34           | DW01_add         | apparch (area)     |                |
| add_x_2            | DW01_inc         | apparch (area)     |                |
| lte_x_3            | DW_cmp           | apparch (area)     |                |
| gte_x_5            | DW_cmp           | apparch (area)     |                |
| gte_x_7            | DW_cmp           | apparch (area)     |                |
| add_x_12           | DW01_add         | apparch (area)     |                |
| mult_x_13          | DW_mult_uns      | pparch (area,speed)                 |
|                    |                  | mult_arch: benc_radix8              |
| eq_x_14            | DW_cmp           | apparch (area)     |                |
| lt_x_17            | DW_cmp           | apparch (area)     |                |
| lt_x_19            | DW_cmp           | apparch (area)     |                |
| add_x_20           | DW01_add         | pparch (area,speed)                 |
| U3                 | DW_lzd           | rtl                |                |
| U4                 | DW_lzd           | rtl                |                |
| sub_x_33           | DW01_sub         | apparch (area)     |                |
| add_x_34           | DW01_add         | apparch (area)     |                |
| add_x_2            | DW01_inc         | apparch (area)     |                |
| lte_x_3            | DW_cmp           | apparch (area)     |                |
| gte_x_5            | DW_cmp           | apparch (area)     |                |
| gte_x_7            | DW_cmp           | apparch (area)     |                |
| add_x_12           | DW01_add         | apparch (area)     |                |
| mult_x_13          | DW_mult_uns      | pparch (area,speed)                 |
|                    |                  | mult_arch: benc_radix8              |
| eq_x_14            | DW_cmp           | apparch (area)     |                |
| lt_x_17            | DW_cmp           | apparch (area)     |                |
| lt_x_19            | DW_cmp           | apparch (area)     |                |
| add_x_20           | DW01_add         | pparch (area,speed)                 |
| U3                 | DW_lzd           | rtl                |                |
| U4                 | DW_lzd           | rtl                |                |
| sub_x_33           | DW01_sub         | apparch (area)     |                |
| add_x_34           | DW01_add         | apparch (area)     |                |
| add_x_2            | DW01_inc         | apparch (area)     |                |
| lte_x_3            | DW_cmp           | apparch (area)     |                |
| gte_x_5            | DW_cmp           | apparch (area)     |                |
| gte_x_7            | DW_cmp           | apparch (area)     |                |
| add_x_12           | DW01_add         | apparch (area)     |                |
| mult_x_13          | DW_mult_uns      | pparch (area,speed)                 |
|                    |                  | mult_arch: benc_radix8              |
| eq_x_14            | DW_cmp           | apparch (area)     |                |
| lt_x_17            | DW_cmp           | apparch (area)     |                |
| lt_x_19            | DW_cmp           | apparch (area)     |                |
| add_x_20           | DW01_add         | pparch (area,speed)                 |
| U3                 | DW_lzd           | rtl                |                |
| U4                 | DW_lzd           | rtl                |                |
| sub_x_33           | DW01_sub         | apparch (area)     |                |
| add_x_34           | DW01_add         | apparch (area)     |                |
| add_x_2            | DW01_inc         | apparch (area)     |                |
| lte_x_3            | DW_cmp           | apparch (area)     |                |
| gte_x_5            | DW_cmp           | apparch (area)     |                |
| gte_x_7            | DW_cmp           | apparch (area)     |                |
| add_x_12           | DW01_add         | apparch (area)     |                |
| mult_x_13          | DW_mult_uns      | pparch (area,speed)                 |
|                    |                  | mult_arch: benc_radix8              |
| eq_x_14            | DW_cmp           | apparch (area)     |                |
| lt_x_17            | DW_cmp           | apparch (area)     |                |
| lt_x_19            | DW_cmp           | apparch (area)     |                |
| add_x_20           | DW01_add         | pparch (area,speed)                 |
| U3                 | DW_lzd           | rtl                |                |
| U4                 | DW_lzd           | rtl                |                |
| sub_x_33           | DW01_sub         | apparch (area)     |                |
| add_x_34           | DW01_add         | apparch (area)     |                |
| add_x_2            | DW01_inc         | apparch (area)     |                |
| lte_x_3            | DW_cmp           | apparch (area)     |                |
| gte_x_5            | DW_cmp           | apparch (area)     |                |
| gte_x_7            | DW_cmp           | apparch (area)     |                |
| add_x_12           | DW01_add         | apparch (area)     |                |
| mult_x_13          | DW_mult_uns      | pparch (area,speed)                 |
|                    |                  | mult_arch: benc_radix8              |
| eq_x_14            | DW_cmp           | apparch (area)     |                |
| lt_x_17            | DW_cmp           | apparch (area)     |                |
| lt_x_19            | DW_cmp           | apparch (area)     |                |
| add_x_20           | DW01_add         | pparch (area,speed)                 |
| U3                 | DW_lzd           | rtl                |                |
| U4                 | DW_lzd           | rtl                |                |
| sub_x_33           | DW01_sub         | apparch (area)     |                |
| add_x_34           | DW01_add         | apparch (area)     |                |
| U2                 | DW01_ash         | astr (area)        |                |
| lt_x_1             | DW_cmp           | pparch (area,speed)                 |
| ashr_5             | DW_rightsh       | astr (area)        |                |
| ash_6              | DW_leftsh        | astr (area)        |                |
| ash_8              | DW_leftsh        | astr (area)        |                |
| add_x_9            | DW01_add         | apparch (area)     |                |
| add_x_16           | DW01_inc         | pparch (area,speed)                 |
| U2                 | DW_lzd           | cla                |                |
| U1                 | DW_norm          | rtl                |                |
| U2                 | DW01_ash         | astr (area)        |                |
| lt_x_1             | DW_cmp           | pparch (area,speed)                 |
| ashr_5             | DW_rightsh       | astr (area)        |                |
| ash_6              | DW_leftsh        | astr (area)        |                |
| ash_8              | DW_leftsh        | astr (area)        |                |
| add_x_9            | DW01_add         | apparch (area)     |                |
| add_x_16           | DW01_inc         | pparch (area,speed)                 |
| U2                 | DW_lzd           | cla                |                |
| U1                 | DW_norm          | rtl                |                |
| U2                 | DW01_ash         | astr (area)        |                |
| lt_x_1             | DW_cmp           | pparch (area,speed)                 |
| ashr_5             | DW_rightsh       | astr (area)        |                |
| ash_6              | DW_leftsh        | astr (area)        |                |
| ash_8              | DW_leftsh        | astr (area)        |                |
| add_x_9            | DW01_add         | apparch (area)     |                |
| add_x_16           | DW01_inc         | pparch (area,speed)                 |
| U2                 | DW_lzd           | cla                |                |
| U1                 | DW_norm          | rtl                |                |
| add_x_2            | DW01_inc         | apparch (area)     |                |
| lte_x_3            | DW_cmp           | apparch (area)     |                |
| gte_x_5            | DW_cmp           | apparch (area)     |                |
| gte_x_7            | DW_cmp           | apparch (area)     |                |
| add_x_12           | DW01_add         | apparch (area)     |                |
| mult_x_13          | DW_mult_uns      | pparch (area,speed)                 |
|                    |                  | mult_arch: benc_radix8              |
| eq_x_14            | DW_cmp           | apparch (area)     |                |
| lt_x_17            | DW_cmp           | apparch (area)     |                |
| lt_x_19            | DW_cmp           | apparch (area)     |                |
| add_x_20           | DW01_add         | pparch (area,speed)                 |
| U3                 | DW_lzd           | rtl                |                |
| U4                 | DW_lzd           | rtl                |                |
| sub_x_33           | DW01_sub         | apparch (area)     |                |
| add_x_34           | DW01_add         | apparch (area)     |                |
| add_x_2            | DW01_inc         | apparch (area)     |                |
| lte_x_3            | DW_cmp           | apparch (area)     |                |
| gte_x_5            | DW_cmp           | apparch (area)     |                |
| gte_x_7            | DW_cmp           | apparch (area)     |                |
| add_x_12           | DW01_add         | apparch (area)     |                |
| mult_x_13          | DW_mult_uns      | pparch (area,speed)                 |
|                    |                  | mult_arch: benc_radix8              |
| eq_x_14            | DW_cmp           | apparch (area)     |                |
| lt_x_17            | DW_cmp           | apparch (area)     |                |
| lt_x_19            | DW_cmp           | apparch (area)     |                |
| add_x_20           | DW01_add         | pparch (area,speed)                 |
| U3                 | DW_lzd           | rtl                |                |
| U4                 | DW_lzd           | rtl                |                |
| sub_x_33           | DW01_sub         | apparch (area)     |                |
| add_x_34           | DW01_add         | apparch (area)     |                |
| add_x_2            | DW01_inc         | apparch (area)     |                |
| lte_x_3            | DW_cmp           | apparch (area)     |                |
| gte_x_5            | DW_cmp           | apparch (area)     |                |
| gte_x_7            | DW_cmp           | apparch (area)     |                |
| add_x_12           | DW01_add         | apparch (area)     |                |
| mult_x_13          | DW_mult_uns      | pparch (area,speed)                 |
|                    |                  | mult_arch: benc_radix8              |
| eq_x_14            | DW_cmp           | apparch (area)     |                |
| lt_x_17            | DW_cmp           | apparch (area)     |                |
| lt_x_19            | DW_cmp           | apparch (area)     |                |
| add_x_20           | DW01_add         | pparch (area,speed)                 |
| U3                 | DW_lzd           | rtl                |                |
| U4                 | DW_lzd           | rtl                |                |
| sub_x_33           | DW01_sub         | apparch (area)     |                |
| add_x_34           | DW01_add         | apparch (area)     |                |
| lt_x_1             | DW_cmp           | apparch (area)     |                |
| sub_x_4            | DW01_sub         | pparch (area,speed)                 |
| ashr_5             | DW_rightsh       | astr (area)        |                |
| ash_6              | DW_leftsh        | astr (area)        |                |
| ash_8              | DW_leftsh        | astr (area)        |                |
| add_x_12           | DW01_inc         | pparch (area,speed)                 |
| U1                 | DW_lzd           | rtl                |                |
| lt_x_1             | DW_cmp           | apparch (area)     |                |
| sub_x_4            | DW01_sub         | pparch (area,speed)                 |
| ashr_5             | DW_rightsh       | astr (area)        |                |
| ash_6              | DW_leftsh        | astr (area)        |                |
| ash_8              | DW_leftsh        | astr (area)        |                |
| add_x_12           | DW01_inc         | pparch (area,speed)                 |
| U1                 | DW_lzd           | rtl                |                |
| DP_OP_5350J1_178_1243                 |                    |                |
|                    | DP_OP_5350J1_178_1243 | str (area)    |                |
| DP_OP_44J1_122_8319                   |                    |                |
|                    | DP_OP_44J1_122_8319 | str (area,speed)                 |
|                    |                  | mult_arch: and     |                |
|                    |                  | mult_arch: benc_radix4              |
|                    |                  | mult_arch: benc_radix4              |
| DP_OP_45J1_123_5453                   |                    |                |
|                    | DP_OP_45J1_123_5453 | str (area)      |                |
| DP_OP_106J1_152_3223                  |                    |                |
|                    | DP_OP_106J1_152_3223 | str (area,speed)                |
|                    |                  | mult_arch: and     |                |
|                    |                  | mult_arch: benc_radix4              |
| DP_OP_107J1_153_9769                  |                    |                |
|                    | DP_OP_107J1_153_9769 | str (area,speed)                |
| DP_OP_65J9_187_7885                   |                    |                |
|                    | DP_OP_65J9_187_7885 | str (area,speed)                 |
| DP_OP_66J9_188_3163                   |                    |                |
|                    | DP_OP_66J9_188_3163 | str (area,speed)                 |
| DP_OP_67J9_189_9752                   |                    |                |
|                    | DP_OP_67J9_189_9752 | str (area,speed)                 |
| DP_OP_65J11_187_7885                  |                    |                |
|                    | DP_OP_65J11_187_7885 | str (area,speed)                |
| DP_OP_66J11_188_3163                  |                    |                |
|                    | DP_OP_66J11_188_3163 | str (area,speed)                |
| DP_OP_67J11_189_9752                  |                    |                |
|                    | DP_OP_67J11_189_9752 | str (area,speed)                |
| DP_OP_65J13_187_7885                  |                    |                |
|                    | DP_OP_65J13_187_7885 | str (area,speed)                |
| DP_OP_66J13_188_3163                  |                    |                |
|                    | DP_OP_66J13_188_3163 | str (area,speed)                |
| DP_OP_67J13_189_9752                  |                    |                |
|                    | DP_OP_67J13_189_9752 | str (area,speed)                |
| DP_OP_65J14_187_7885                  |                    |                |
|                    | DP_OP_65J14_187_7885 | str (area,speed)                |
| DP_OP_66J14_188_3163                  |                    |                |
|                    | DP_OP_66J14_188_3163 | str (area,speed)                |
| DP_OP_67J14_189_9752                  |                    |                |
|                    | DP_OP_67J14_189_9752 | str (area,speed)                |
| DP_OP_65J8_187_7885                   |                    |                |
|                    | DP_OP_65J8_187_7885 | str (area,speed)                 |
| DP_OP_66J8_188_3163                   |                    |                |
|                    | DP_OP_66J8_188_3163 | str (area,speed)                 |
| DP_OP_67J8_189_9752                   |                    |                |
|                    | DP_OP_67J8_189_9752 | str (area,speed)                 |
| DP_OP_65J10_187_7885                  |                    |                |
|                    | DP_OP_65J10_187_7885 | str (area,speed)                |
| DP_OP_66J10_188_3163                  |                    |                |
|                    | DP_OP_66J10_188_3163 | str (area,speed)                |
| DP_OP_67J10_189_9752                  |                    |                |
|                    | DP_OP_67J10_189_9752 | str (area,speed)                |
| DP_OP_65J12_187_7885                  |                    |                |
|                    | DP_OP_65J12_187_7885 | str (area,speed)                |
| DP_OP_66J12_188_3163                  |                    |                |
|                    | DP_OP_66J12_188_3163 | str (area,speed)                |
| DP_OP_67J12_189_9752                  |                    |                |
|                    | DP_OP_67J12_189_9752 | str (area,speed)                |
| DP_OP_65_187_7885  | DP_OP_65_187_7885 | str (area,speed)  |                |
| DP_OP_66_188_3163  | DP_OP_66_188_3163 | str (area,speed)  |                |
| DP_OP_67_189_9752  | DP_OP_67_189_9752 | str (area,speed)  |                |
| DP_OP_65_195_7885  | DP_OP_65_195_7885 | str (area,speed)  |                |
| DP_OP_66_196_3163  | DP_OP_66_196_3163 | str (area,speed)  |                |
| DP_OP_67_197_9752  | DP_OP_67_197_9752 | str (area,speed)  |                |
| DP_OP_65J12_195_7885                  |                    |                |
|                    | DP_OP_65J12_195_7885 | str (area,speed)                |
| DP_OP_66J12_196_3163                  |                    |                |
|                    | DP_OP_66J12_196_3163 | str (area,speed)                |
| DP_OP_67J12_197_9752                  |                    |                |
|                    | DP_OP_67J12_197_9752 | str (area,speed)                |
| DP_OP_65J13_195_7885                  |                    |                |
|                    | DP_OP_65J13_195_7885 | str (area,speed)                |
| DP_OP_66J13_196_3163                  |                    |                |
|                    | DP_OP_66J13_196_3163 | str (area,speed)                |
| DP_OP_67J13_197_9752                  |                    |                |
|                    | DP_OP_67J13_197_9752 | str (area,speed)                |
| DP_OP_65J8_195_7885                   |                    |                |
|                    | DP_OP_65J8_195_7885 | str (area,speed)                 |
| DP_OP_66J8_196_3163                   |                    |                |
|                    | DP_OP_66J8_196_3163 | str (area,speed)                 |
| DP_OP_67J8_197_9752                   |                    |                |
|                    | DP_OP_67J8_197_9752 | str (area,speed)                 |
| DP_OP_65J11_195_7885                  |                    |                |
|                    | DP_OP_65J11_195_7885 | str (area,speed)                |
| DP_OP_66J11_196_3163                  |                    |                |
|                    | DP_OP_66J11_196_3163 | str (area,speed)                |
| DP_OP_67J11_197_9752                  |                    |                |
|                    | DP_OP_67J11_197_9752 | str (area,speed)                |
| DP_OP_65J9_195_7885                   |                    |                |
|                    | DP_OP_65J9_195_7885 | str (area,speed)                 |
| DP_OP_66J9_196_3163                   |                    |                |
|                    | DP_OP_66J9_196_3163 | str (area,speed)                 |
| DP_OP_67J9_197_9752                   |                    |                |
|                    | DP_OP_67J9_197_9752 | str (area,speed)                 |
| DP_OP_65J47_299_7885                  |                    |                |
|                    | DP_OP_65J47_299_7885 | str (area,speed)                |
| DP_OP_66J47_300_3163                  |                    |                |
|                    | DP_OP_66J47_300_3163 | str (area,speed)                |
| DP_OP_67J47_301_9752                  |                    |                |
|                    | DP_OP_67J47_301_9752 | str (area,speed)                |
| DP_OP_65J46_299_7885                  |                    |                |
|                    | DP_OP_65J46_299_7885 | str (area,speed)                |
| DP_OP_66J46_300_3163                  |                    |                |
|                    | DP_OP_66J46_300_3163 | str (area,speed)                |
| DP_OP_67J46_301_9752                  |                    |                |
|                    | DP_OP_67J46_301_9752 | str (area,speed)                |
| DP_OP_65J44_299_7885                  |                    |                |
|                    | DP_OP_65J44_299_7885 | str (area,speed)                |
| DP_OP_66J44_300_3163                  |                    |                |
|                    | DP_OP_66J44_300_3163 | str (area,speed)                |
| DP_OP_67J44_301_9752                  |                    |                |
|                    | DP_OP_67J44_301_9752 | str (area,speed)                |
| DP_OP_65J48_299_7885                  |                    |                |
|                    | DP_OP_65J48_299_7885 | str (area,speed)                |
| DP_OP_66J48_300_3163                  |                    |                |
|                    | DP_OP_66J48_300_3163 | str (area,speed)                |
| DP_OP_67J48_301_9752                  |                    |                |
|                    | DP_OP_67J48_301_9752 | str (area,speed)                |
| DP_OP_49J1_160_3163                   |                    |                |
|                    | DP_OP_49J1_160_3163 | str (area,speed)                 |
| DP_OP_50J1_161_9752                   |                    |                |
|                    | DP_OP_50J1_161_9752 | str (area)      |                |
| DP_OP_49J1_156_3163                   |                    |                |
|                    | DP_OP_49J1_156_3163 | str (area,speed)                 |
| DP_OP_50J1_157_9752                   |                    |                |
|                    | DP_OP_50J1_157_9752 | str (area)      |                |
===============================================================================

1
