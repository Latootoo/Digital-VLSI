create_clock -name clk [get_ports clk] -period 2
create_clock -name clk_slow [get_ports clk_slow] -period 24

set_clock_uncertainty 0.2 clk
set_clock_uncertainty 0.2 clk_slow 

set_dont_touch_network clk
set_dont_touch_network clk_slow

set non_clock_inputs [remove_from_collection [all_inputs] clk clk_slow]

set_false_path -from [get_ports reset]

set_drive 0 clk clk_slow
set_driving_cell -cell BUFX4 ${non_clock_inputs}
set_input_delay 0.2 -clock clk -clock clk_slow [all_inputs]

set_load 0.1 [all_outputs]
set_output_delay 0.1 -clock clk -clock clk_slow [all_outputs]

set_max_transition 0.300 output_block
set_max_fanout 8 output_block

set_dont_use [get_lib_cells CLK*] true
