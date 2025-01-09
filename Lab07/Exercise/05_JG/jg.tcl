clear -all

## --------------- Environment Setting ---------------- ##
set_schematic_viewer_simplify_concatenations on
set_reset_max_iterations 2000

## ----------------- Setting Variables ---------------- ##
set design_path "../01_RTL"
set mem_path "../04_MEM"
set report_dir "./Report"
set DESIGN "CONV_TOP"
set MEM "DUAL_64X8X1BM1"

## ------------- Loading Custom Rule File ------------- ##

## --------------- Analyzing the Design --------------- ##
analyze -sv ${mem_path}/$MEM\.v
analyze -sv ${design_path}/$DESIGN\.v 

## ----------------- Reading Liberty ------------------ ##
liberty -load ${mem_path}/$MEM\_WC.lib 

## -------------- Elaborating the design -------------- ##
elaborate -top $DESIGN 

## ---------------- Decalaring Resets ----------------- ##
config_rtlds -reset -async rst_n -polarity low  

## ------------------- Reading SDC -------------------- ##
read_sdc $DESIGN\_SYN.sdc

## --------------- Defining False Path ---------------- ##

## ---------------- Defining Constants ---------------- ##
# config_rtlds -rule -parameter {fifo_detection = true}
# config_rtlds -rule -parameter {handshake_detection = true}
config_rtlds -rule -parameter  {ignore_convergence_from_complex_schemes = true}

## ------------ Clock Association of Ports ------------ ##

## --------------- Structural Analysis ---------------- ##
# Find Clock Domains
check_cdc -clock_domain -find
# Find CDC pairs
check_cdc -pair -find
# Find Schemes
check_cdc -scheme -add handshake -module Handshake_syn -map {{data din} {sreq sreq} {dreq dreq} {dack dack} {sack sack}}
check_cdc -scheme -add fifo -module FIFO_syn -map {{rdata rdata} {wdata wdata} {wptr wptr} {rptr rptr} {wfull wfull} {rempty rempty} {winc winc} {rinc rinc}}
check_cdc -scheme -find
# Find Convergence
check_cdc -group -find

## ------------------ Reset Analysis ------------------ ##
## check_cdc -reset -find

## ---------------- Functional Checks ----------------- ##
check_cdc -protocol_check -generate
check_cdc -protocol_check -prove

## ---------- Proving Signal Configuration ------------ ##
# config_rtlds -signal -prove

## ----------------- Validate Waiver ------------------ ##
check_cdc -waiver -generate
check_cdc -waiver -prove

## ------- Metastability Injection in Formal ---------- ##
# check_cdc -metastability -inject -include_protocol_check -include_inactive_pairs
# check_cdc -metastability -prove

## ---------------- Report Generation ----------------- ##
check_cdc -report pairs -file $report_dir/pairs.csv -force
check_cdc -report convergence_schemes -file $report_dir/schemes.csv -force
check_cdc -report violations -file $report_dir/violations.csv -force
check_cdc -report rules -file $report_dir/rules.csv -force
check_cdc -report -detailed -file $report_dir/summary.txt -force