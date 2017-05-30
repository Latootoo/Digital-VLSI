create_clock -name clk [get_ports clk] -period 5
create_clock -name clk_slow [get_ports clk_slow] -period 60

set_clock_uncertainty 0.2 clk
set_clock_uncertainty 0.2 clk_slow

set_dont_touch_network clk
set_dont_touch_network clk_slow

set non_clock_inputs [remove_from_collection [all_inputs] clk]
set_false_path -from [get_ports reset]


set_drive 0 clk
set_driving_cell -cell BUFX4 ${non_clock_inputs}
set_input_delay -clock clk  0.2 [all_inputs]

set_load 0.05 [all_outputs]
set_output_delay -clock clk 0.2 [all_outputs]

set_max_transition 0.200 transmitter
set_max_fanout 8 transmitter

set_dont_use [get_lib_cells CLK*] true
