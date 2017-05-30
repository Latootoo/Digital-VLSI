set_driving_cell -cell BUFX4 [all_inputs]
set_input_delay 0.2 [all_inputs]

set_load 0.05 [all_outputs]
set_output_delay 0.2 [all_outputs]

set_max_transition 0.200 mapper
set_max_fanout 8 mapper

set_dont_use [get_lib_cells CLK*] true
