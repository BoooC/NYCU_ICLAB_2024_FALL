update_constraint_mode -name func_mode -sdc_files CHIP_cts.sdc
set_ccopt_property update_io_latency false

create_ccopt_skew_group -name all_output -source clk -sinks {
out_data_reg_7_/CK
out_data_reg_6_/CK
out_data_reg_5_/CK
out_data_reg_4_/CK
out_data_reg_3_/CK
out_data_reg_2_/CK
out_data_reg_1_/CK
out_data_reg_0_/CK
awaddr_s_inf_reg_16_/CK
awaddr_s_inf_reg_15_/CK
awaddr_s_inf_reg_14_/CK
awaddr_s_inf_reg_13_/CK
awaddr_s_inf_reg_12_/CK
awaddr_s_inf_reg_11_/CK
awaddr_s_inf_reg_10_/CK
araddr_s_inf_reg_16_/CK
wdata_s_inf_reg_127_/CK
wdata_s_inf_reg_126_/CK
wdata_s_inf_reg_125_/CK
wdata_s_inf_reg_124_/CK
wdata_s_inf_reg_123_/CK
wdata_s_inf_reg_122_/CK
wdata_s_inf_reg_121_/CK
wdata_s_inf_reg_120_/CK
wdata_s_inf_reg_119_/CK
wdata_s_inf_reg_118_/CK
wdata_s_inf_reg_117_/CK
wdata_s_inf_reg_116_/CK
wdata_s_inf_reg_115_/CK
wdata_s_inf_reg_114_/CK
wdata_s_inf_reg_113_/CK
wdata_s_inf_reg_112_/CK
wdata_s_inf_reg_111_/CK
wdata_s_inf_reg_110_/CK
wdata_s_inf_reg_109_/CK
wdata_s_inf_reg_108_/CK
wdata_s_inf_reg_107_/CK
wdata_s_inf_reg_106_/CK
wdata_s_inf_reg_105_/CK
wdata_s_inf_reg_104_/CK
wdata_s_inf_reg_103_/CK
wdata_s_inf_reg_102_/CK
wdata_s_inf_reg_101_/CK
wdata_s_inf_reg_100_/CK
wdata_s_inf_reg_99_/CK
wdata_s_inf_reg_98_/CK
wdata_s_inf_reg_97_/CK
wdata_s_inf_reg_96_/CK
wdata_s_inf_reg_95_/CK
wdata_s_inf_reg_94_/CK
wdata_s_inf_reg_93_/CK
wdata_s_inf_reg_92_/CK
wdata_s_inf_reg_91_/CK
wdata_s_inf_reg_90_/CK
wdata_s_inf_reg_89_/CK
wdata_s_inf_reg_88_/CK
wdata_s_inf_reg_87_/CK
wdata_s_inf_reg_86_/CK
wdata_s_inf_reg_85_/CK
wdata_s_inf_reg_84_/CK
wdata_s_inf_reg_83_/CK
wdata_s_inf_reg_82_/CK
wdata_s_inf_reg_81_/CK
wdata_s_inf_reg_80_/CK
wdata_s_inf_reg_79_/CK
wdata_s_inf_reg_78_/CK
wdata_s_inf_reg_77_/CK
wdata_s_inf_reg_76_/CK
wdata_s_inf_reg_75_/CK
wdata_s_inf_reg_74_/CK
wdata_s_inf_reg_73_/CK
wdata_s_inf_reg_72_/CK
wdata_s_inf_reg_71_/CK
wdata_s_inf_reg_70_/CK
wdata_s_inf_reg_69_/CK
wdata_s_inf_reg_68_/CK
wdata_s_inf_reg_67_/CK
wdata_s_inf_reg_66_/CK
wdata_s_inf_reg_65_/CK
wdata_s_inf_reg_64_/CK
wdata_s_inf_reg_63_/CK
wdata_s_inf_reg_62_/CK
wdata_s_inf_reg_61_/CK
wdata_s_inf_reg_60_/CK
wdata_s_inf_reg_59_/CK
wdata_s_inf_reg_58_/CK
wdata_s_inf_reg_57_/CK
wdata_s_inf_reg_56_/CK
wdata_s_inf_reg_55_/CK
wdata_s_inf_reg_54_/CK
wdata_s_inf_reg_53_/CK
wdata_s_inf_reg_52_/CK
wdata_s_inf_reg_51_/CK
wdata_s_inf_reg_50_/CK
wdata_s_inf_reg_49_/CK
wdata_s_inf_reg_48_/CK
wdata_s_inf_reg_47_/CK
wdata_s_inf_reg_46_/CK
wdata_s_inf_reg_45_/CK
wdata_s_inf_reg_44_/CK
wdata_s_inf_reg_43_/CK
wdata_s_inf_reg_42_/CK
wdata_s_inf_reg_41_/CK
wdata_s_inf_reg_40_/CK
wdata_s_inf_reg_39_/CK
wdata_s_inf_reg_38_/CK
wdata_s_inf_reg_37_/CK
wdata_s_inf_reg_36_/CK
wdata_s_inf_reg_35_/CK
wdata_s_inf_reg_34_/CK
wdata_s_inf_reg_33_/CK
wdata_s_inf_reg_32_/CK
wdata_s_inf_reg_31_/CK
wdata_s_inf_reg_30_/CK
wdata_s_inf_reg_29_/CK
wdata_s_inf_reg_28_/CK
wdata_s_inf_reg_27_/CK
wdata_s_inf_reg_26_/CK
wdata_s_inf_reg_25_/CK
wdata_s_inf_reg_24_/CK
wdata_s_inf_reg_23_/CK
wdata_s_inf_reg_22_/CK
wdata_s_inf_reg_21_/CK
wdata_s_inf_reg_20_/CK
wdata_s_inf_reg_19_/CK
wdata_s_inf_reg_18_/CK
wdata_s_inf_reg_17_/CK
wdata_s_inf_reg_16_/CK
wdata_s_inf_reg_15_/CK
wdata_s_inf_reg_14_/CK
wdata_s_inf_reg_13_/CK
wdata_s_inf_reg_12_/CK
wdata_s_inf_reg_11_/CK
wdata_s_inf_reg_10_/CK
wdata_s_inf_reg_9_/CK
wdata_s_inf_reg_8_/CK
wdata_s_inf_reg_7_/CK
wdata_s_inf_reg_6_/CK
wdata_s_inf_reg_5_/CK
wdata_s_inf_reg_4_/CK
wdata_s_inf_reg_3_/CK
wdata_s_inf_reg_2_/CK
wdata_s_inf_reg_1_/CK
wdata_s_inf_reg_0_/CK
araddr_s_inf_reg_15_/CK
araddr_s_inf_reg_14_/CK
araddr_s_inf_reg_13_/CK
araddr_s_inf_reg_12_/CK
araddr_s_inf_reg_11_/CK
araddr_s_inf_reg_10_/CK
arlen_s_inf_reg_1_/CK
out_valid_reg/CK
awvalid_s_inf_reg/CK
wlast_s_inf_reg/CK
wvalid_s_inf_reg/CK
arvalid_s_inf_reg/CK
rready_s_inf_reg/CK
}

set_ccopt_property -skew_group all_output target_insertion_delay 0.01ps


create_ccopt_clock_tree_spec -file CHIP.CCOPT.spec -keep_all_sdc_clocks
source CHIP.CCOPT.spec
ccopt_design
saveDesign ./DBS/CHIP_CTS.inn
