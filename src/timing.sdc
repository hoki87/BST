## Generated SDC file "X:/BST/FPGA/src/timing.sdc"

## Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, the Altera Quartus Prime License Agreement,
## the Altera MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Altera and sold by Altera or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 15.1.0 Build 185 10/21/2015 SJ Standard Edition"

## DATE    "Fri Feb 26 11:35:11 2016"

##
## DEVICE  "EP4CE10F17C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

#create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name udr_clk -period 200 [get_keepers {sld_hub:auto_hub|alt_sld_fab_with_jtag_input:\instrumentation_fabric_with_node_gen:fabric_gen_new_way:with_jtag_input_gen:instrumentation_fabric|alt_sld_fab:instrumentation_fabric|alt_sld_fab_alt_sld_fab:alt_sld_fab|alt_sld_fab_alt_sld_fab_sldfabric:sldfabric|sld_jtag_hub:\jtag_hub_gen:real_sld_jtag_hub|sld_shadow_jsm:shadow_jsm|state[8]}]

#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
set_clock_uncertainty -from { altera_reserved_tck } -to { altera_reserved_tck } -setup 0
set_clock_uncertainty -from { altera_reserved_tck } -to { altera_reserved_tck } -hold 0

#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 


#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_ports {IO_A8}]  -to [get_keepers {inj_capture_reg[0]}]
set_false_path -from [get_ports {IO_B8}]  -to [get_keepers {inj_capture_reg[1]}]
set_false_path -from [get_ports {IO_C8}]  -to [get_keepers {inj_capture_reg[2]}]
set_false_path -from [get_ports {IO_D8}]  -to [get_keepers {inj_capture_reg[3]}]
set_false_path -from {oej_update_reg[0]}  -to [get_ports {IO_A8}] 
set_false_path -from {outj_update_reg[0]} -to [get_ports {IO_A8}] 
set_false_path -from {oej_update_reg[1]}  -to [get_ports {IO_B8}] 
set_false_path -from {outj_update_reg[1]} -to [get_ports {IO_B8}] 
set_false_path -from {oej_update_reg[2]}  -to [get_ports {IO_C8}] 
set_false_path -from {outj_update_reg[2]} -to [get_ports {IO_C8}] 
set_false_path -from {oej_update_reg[3]}  -to [get_ports {IO_D8}] 
set_false_path -from {outj_update_reg[3]} -to [get_ports {IO_D8}]
set_false_path -from [get_ports {altera_reserved_tdi}] -to {*}
set_false_path -from [get_ports {altera_reserved_tms}] -to {*}
set_false_path -from {*} -to [get_ports {altera_reserved_tdo}]

#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

