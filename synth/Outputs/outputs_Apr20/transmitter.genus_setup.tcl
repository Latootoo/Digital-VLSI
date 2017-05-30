#####################################################################
#
# Genus(TM) Synthesis Solution setup file
# Created by Genus(TM) Synthesis Solution GENUS15.21 - 15.20-s010_1
#   on 04/20/2016 16:09:14
#
# This file can only be run in Genus Common UI mode.
#
#####################################################################


# This script is intended for use with Genus(TM) Synthesis Solution version GENUS15.21 - 15.20-s010_1


# Remove Existing Design
###########################################################
if {[::legacy::find -design design:transmitter] ne ""} {
  puts "** A design with the same name is already loaded. It will be removed. **"
  delete_obj design:transmitter
}


# Source INIT Setup file
########################################################
source Outputs/outputs_Apr20/transmitter.genus_init.tcl

## Use below command till fix of CCR 1316394
::legacy::set_attribute qrc_tech_file /afs/ee.cooper.edu/courses/ece447/gpdk/GPDK045/gsclib045_svt_v4.4/gsclib045_tech/qrc/qx/gpdk045.tch
read_metric -id current Outputs/outputs_Apr20/transmitter.metrics.json

source Outputs/outputs_Apr20/transmitter.g
puts "\n** Restoration Completed **\n"


# Data Integrity Check
###########################################################
# program version
if {"[string_representation [::legacy::get_attribute program_version /]]" != "{GENUS15.21 - 15.20-s010_1}"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-91] "golden program_version: {GENUS15.21 - 15.20-s010_1}  current program_version: [string_representation [::legacy::get_attribute program_version /]]"
}
# license
if {"[string_representation [::legacy::get_attribute startup_license /]]" != "Genus_Synthesis"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-91] "golden license: Genus_Synthesis  current license: [string_representation [::legacy::get_attribute startup_license /]]"
}
# slack
set _slk_ [::legacy::get_attribute slack design:transmitter]
if {[regexp {^-?[0-9.]+$} $_slk_]} {
  set _slk_ [format %.1f $_slk_]
}
if {$_slk_ != "422.7"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-92] "golden slack: 422.7,  current slack: $_slk_"
}
unset _slk_
# multi-mode slack
if {"[string_representation [::legacy::get_attribute slack_by_mode design:transmitter]]" != "{{mode:transmitter/bcwc 422.7}}"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-92] "golden slack_by_mode: {{mode:transmitter/bcwc 422.7}}  current slack_by_mode: [string_representation [::legacy::get_attribute slack_by_mode design:transmitter]]"
}
# tns
set _tns_ [::legacy::get_attribute tns design:transmitter]
if {[regexp {^-?[0-9.]+$} $_tns_]} {
  set _tns_ [format %.0f $_tns_]
}
if {$_tns_ != "0"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-92] "golden tns: 0,  current tns: $_tns_"
}
unset _tns_
# cell area
set _cell_area_ [::legacy::get_attribute cell_area design:transmitter]
if {[regexp {^-?[0-9.]+$} $_cell_area_]} {
  set _cell_area_ [format %.0f $_cell_area_]
}
if {$_cell_area_ != "29859"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-92] "golden cell area: 29859,  current cell area: $_cell_area_"
}
unset _cell_area_
# net area
set _net_area_ [::legacy::get_attribute net_area design:transmitter]
if {[regexp {^-?[0-9.]+$} $_net_area_]} {
  set _net_area_ [format %.0f $_net_area_]
}
if {$_net_area_ != "10298"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-92] "golden net area: 10298,  current net area: $_net_area_"
}
unset _net_area_
# library domain count
if {[llength [::legacy::find /libraries -library_domain *]] != "2"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-92] "golden # library domains: 2  current # library domains: [llength [::legacy::find /libraries -library_domain *]]"
}
