#####################################################################
#
# Innovus setup file
# Created by Genus(TM) Synthesis Solution on 04/20/2016 16:09:14
#
# This file can only be run in Innovus Common UI mode.
#
#####################################################################


# Design Import
###########################################################
## Reading FlowKit settings file
source Outputs/outputs_Apr20/transmitter.flowkit_settings.tcl

source Outputs/outputs_Apr20/transmitter.invs_init.tcl

# Reading metrics file
######################
read_metric -id current Outputs/outputs_Apr20/transmitter.metrics.json 



# Mode Setup
###########################################################
source Outputs/outputs_Apr20/transmitter.mode

# Import list of instances with subdesigns having boundary optimization disabled
################################################################################
set_db opt_keep_ports Outputs/outputs_Apr20/transmitter.boundary_opto.tcl 


# Import list of size_only instances
######################################
set_db opt_size_only_file Outputs/outputs_Apr20/transmitter.size_ok.tcl 

