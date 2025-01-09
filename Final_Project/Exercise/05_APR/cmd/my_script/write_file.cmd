#====================================================================
# Stream Out and Write Netlist
#====================================================================
saveDesign ./DBS/CHIP.inn
saveDesign CHIP.inn
write_sdf CHIP.sdf
saveNetlist CHIP.v

summaryReport -noHtml -outfile summaryReport.rpt