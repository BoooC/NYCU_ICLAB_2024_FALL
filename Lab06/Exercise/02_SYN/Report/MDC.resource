 
****************************************
Report : resources
Design : MDC
Version: T-2022.03
Date   : Fri Jan 10 14:05:56 2025
****************************************


Resource Report for this hierarchy in file ../01_RTL/MDC.v
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_128      | DW01_inc       | width=4    | add_964 (MDC.v:964)        |
| DP_OP_396J1_122_5374            |            |                            |
|                | DP_OP_396J1_122_5374 |      |                            |
| DP_OP_397J1_123_6880            |            |                            |
|                | DP_OP_397J1_123_6880 |      |                            |
=============================================================================

Datapath Report for DP_OP_396J1_122_5374
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_396J1_122_5374 | mult_11x11_0/mult_1031 (MDC.v:1031)                 |
|                      | C10583 (MDC.v:329) C10589 (MDC.v:275)               |
|                      | C10591 (MDC.v:275)                                  |
|                      | mult_11x11_1/mult_1031 (MDC.v:1031)                 |
|                      | C10590 (MDC.v:275) C10592 (MDC.v:275)               |
|                      | sub_22_0/sub_1063 (MDC.v:1063) C10585 (MDC.v:329)   |
|                      | C10587 (MDC.v:275) C10593 (MDC.v:275)               |
|                      | sub_22_1/sub_1063 (MDC.v:1063)                      |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Signed   | 11    |                                          |
| I2    | PI   | Signed   | 11    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| I4    | PI   | Unsigned | 1     |                                          |
| I5    | PI   | Signed   | 22    |                                          |
| I6    | PI   | Unsigned | 1     |                                          |
| I7    | PI   | Signed   | 11    |                                          |
| I8    | PI   | Signed   | 11    |                                          |
| I9    | PI   | Unsigned | 1     |                                          |
| I10   | PI   | Signed   | 22    |                                          |
| I11   | PI   | Unsigned | 1     |                                          |
| I12   | PI   | Unsigned | 1     |                                          |
| I13   | PI   | Signed   | 22    |                                          |
| I14   | PI   | Unsigned | 1     |                                          |
| I15   | PI   | Signed   | 22    |                                          |
| T300  | IFO  | Signed   | 22    | { I3, I4, I6 } ? O1 : O2 : I5 ( MDC.v:275 MDC.v:329 ) |
| T310  | IFO  | Signed   | 22    | { I9, I11 } ? O2 : I10 (MDC.v:275)       |
| T326  | IFO  | Signed   | 22    | { I12, I14 } ? O2 : I13 ( MDC.v:275 MDC.v:329 ) |
| O1    | PO   | Signed   | 22    | I1 * I2 (MDC.v:1031)                     |
| O2    | PO   | Signed   | 22    | I7 * I8 (MDC.v:1031)                     |
| O3    | PO   | Signed   | 23    | T300 - T310 (MDC.v:1063)                 |
| O4    | PO   | Signed   | 23    | T326 - I15 (MDC.v:1063)                  |
==============================================================================

Datapath Report for DP_OP_397J1_123_6880
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_397J1_123_6880 | mult_11x34_0/mult_1053 (MDC.v:1053)                 |
|                      | sub_add_702 (MDC.v:702) add_702_ni (MDC.v:702)      |
|                      | sub_add_710 (MDC.v:710) add_710_ni (MDC.v:710)      |
|                      | C10644 (MDC.v:691) C10646 (MDC.v:681)               |
|                      | C10648 (MDC.v:681) add_45_0/add_1085 (MDC.v:1085)   |
|                      | sub_add_649 (MDC.v:649) add_649_ni (MDC.v:649)      |
|                      | C10630 (MDC.v:644) C10632 (MDC.v:644)               |
|                      | C10626 (MDC.v:598) C10638 (MDC.v:590)               |
|                      | C10640 (MDC.v:590) sub_add_609 (MDC.v:609)          |
|                      | add_609_ni (MDC.v:609) sub_add_627 (MDC.v:627)      |
|                      | add_627_ni (MDC.v:627) sub_add_655 (MDC.v:655)      |
|                      | add_655_ni (MDC.v:655) sub_add_647 (MDC.v:647)      |
|                      | add_647_ni (MDC.v:647)                              |
|                      | mult_11x23_1/mult_1042 (MDC.v:1042)                 |
|                      | C10628 (MDC.v:644) C10634 (MDC.v:644)               |
|                      | C10624 (MDC.v:598) C10636 (MDC.v:590)               |
|                      | C10642 (MDC.v:590) sub_add_601 (MDC.v:601)          |
|                      | add_601_ni (MDC.v:601) sub_add_619 (MDC.v:619)      |
|                      | add_619_ni (MDC.v:619) sub_add_653 (MDC.v:653)      |
|                      | add_653_ni (MDC.v:653)                              |
|                      | mult_11x23_0/mult_1042 (MDC.v:1042)                 |
|                      | add_34_0/add_1074 (MDC.v:1074)                      |
|                      | add_34_1/add_1074 (MDC.v:1074)                      |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Signed   | 11    |                                          |
| I2    | PI   | Signed   | 34    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| I4    | PI   | Unsigned | 1     |                                          |
| I5    | PI   | Unsigned | 1     |                                          |
| I6    | PI   | Signed   | 45    |                                          |
| I7    | PI   | Unsigned | 1     |                                          |
| I8    | PI   | Unsigned | 1     |                                          |
| I9    | PI   | Unsigned | 1     |                                          |
| I10   | PI   | Unsigned | 1     |                                          |
| I11   | PI   | Signed   | 11    |                                          |
| I12   | PI   | Signed   | 23    |                                          |
| I13   | PI   | Unsigned | 1     |                                          |
| I14   | PI   | Unsigned | 1     |                                          |
| I15   | PI   | Unsigned | 1     |                                          |
| I16   | PI   | Unsigned | 1     |                                          |
| I17   | PI   | Signed   | 11    |                                          |
| I18   | PI   | Signed   | 23    |                                          |
| I19   | PI   | Signed   | 34    |                                          |
| I20   | PI   | Signed   | 34    |                                          |
| T283  | IFO  | Signed   | 45    | -O1 + $unsigned(45'b000000000000000000000000000000000000000000000) ( MDC.v:702 MDC.v:710 ) |
| T391  | IFO  | Unsigned | 45    | { I3, I4, I5 } ? O1 : T283 : $unsigned(1'b0) ( MDC.v:681 MDC.v:691 ) |
| T278  | IFO  | Signed   | 34    | -O3 + $unsigned(34'b0000000000000000000000000000000000) ( MDC.v:609 MDC.v:627 MDC.v:647 MDC.v:655 ) |
| T281  | IFO  | Signed   | 34    | -O4 + $unsigned(34'b0000000000000000000000000000000000) ( MDC.v:601 MDC.v:619 MDC.v:653 ) |
| T374  | IFO  | Unsigned | 34    | { I13, I14, I15, I16 } ? T278 : T281 : O4 : $unsigned(1'b0) ( MDC.v:590 MDC.v:598 MDC.v:644 ) |
| T395  | IFO  | Signed   | 34    | O1[33:0]                                 |
| T266  | IFO  | Signed   | 34    | -T395 + $unsigned(34'b0000000000000000000000000000000000) (MDC.v:649) |
| T349  | IFO  | Unsigned | 34    | { I7, I8, I9, I10 } ? T266 : T278 : O3 : $unsigned(1'b0) ( MDC.v:590 MDC.v:598 MDC.v:644 ) |
| O1    | PO   | Signed   | 45    | I1 * I2 (MDC.v:1053)                     |
| O2    | PO   | Unsigned | 45    | I6 + T391 (MDC.v:1085)                   |
| O3    | PO   | Signed   | 34    | I11 * I12 (MDC.v:1042)                   |
| O4    | PO   | Signed   | 34    | I17 * I18 (MDC.v:1042)                   |
| O5    | PO   | Unsigned | 34    | I19 + T374 (MDC.v:1074)                  |
| O6    | PO   | Unsigned | 34    | I20 + T349 (MDC.v:1074)                  |
==============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_x_128          | DW01_inc         | apparch (area)     |                |
| DP_OP_396J1_122_5374                  |                    |                |
|                    | DP_OP_396J1_122_5374 | str (area,speed)                |
|                    |                  | mult_arch: benc_radix4              |
|                    |                  | mult_arch: benc_radix4              |
| DP_OP_397J1_123_6880                  |                    |                |
|                    | DP_OP_397J1_123_6880 | str (area,speed)                |
|                    |                  | mult_arch: benc_radix4              |
|                    |                  | mult_arch: benc_radix4              |
|                    |                  | mult_arch: benc_radix4              |
===============================================================================

1
