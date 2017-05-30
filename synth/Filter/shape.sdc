create_clock -name clk [get_ports clk] -period 4

set_clock_uncertainty 0.2 clk
set_dont_touch_network clk

set non_clock_inputs [remove_from_collection [all_inputs] clk]
set_false_path -from [get_ports rst]

set_drive 0 clk
set_driving_cell -cell BUFX4 ${non_clock_inputs}
set_input_delay 0.2 -clock clk [all_inputs]

set_load 0.05 [all_outputs]
set_output_delay 0.2 -clock clk [all_outputs]

set_max_transition 0.200 shape
set_max_fanout 8 shape

set_dont_use [get_lib_cells CLK*] true
