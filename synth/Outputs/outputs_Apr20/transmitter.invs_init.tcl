#####################################################################
#
# Init setup file
# Created by Genus(TM) Synthesis Solution on 04/20/2016 16:09:14
#
#####################################################################


read_mmmc Outputs/outputs_Apr20/transmitter.mmmc.tcl

read_physical -lef {/afs/ee.cooper.edu/courses/ece447/gpdk/GPDK045/gsclib045_svt_v4.4/gsclib045/lef/gsclib045_tech.lef /afs/ee.cooper.edu/courses/ece447/gpdk/GPDK045/gsclib045_svt_v4.4/gsclib045/lef/gsclib045_macro.lef}

read_netlist Outputs/outputs_Apr20/transmitter.v

init_design
