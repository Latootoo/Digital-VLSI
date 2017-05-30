#################################################################################
#
# Created by Genus(TM) Synthesis Solution GENUS15.21 - 15.20-s010_1 on Wed Apr 20 16:09:13 -0400 2016
#
#################################################################################

## library_sets
create_library_set -name slow_1v0 \
    -timing { /afs/ee.cooper.edu/courses/ece447/gpdk/GPDK045/gsclib045_svt_v4.4/gsclib045/timing/slow_vdd1v0_basicCells.lib }
create_library_set -name slow_1v2 \
    -timing { /afs/ee.cooper.edu/courses/ece447/gpdk/GPDK045/gsclib045_svt_v4.4/gsclib045/timing/slow_vdd1v2_basicCells.lib }
create_library_set -name fast_1v2 \
    -timing { timing/fast_vdd1v2_basicCells.lib }

## timing_condition
create_timing_condition -name fast \
    -library_sets { fast_1v2 }
create_timing_condition -name slow \
    -library_sets { slow_1v0 }
create_timing_condition -name leakage \
    -library_sets { slow_1v2 }

## rc_corner
create_rc_corner -name nominal \
    -qrc_tech /afs/ee.cooper.edu/courses/ece447/gpdk/GPDK045/gsclib045_svt_v4.4/gsclib045_tech/qrc/qx/gpdk045.tch \
    -post_route_res {1.0 1.0 1.0} \
    -post_route_cap {1.0 1.0 1.0} \
    -post_route_cross_cap {1.0 1.0 1.0} \
    -post_route_clock_res {1.0 1.0 1.0} \
    -post_route_clock_cap {1.0 1.0 1.0}

## delay_corner
create_delay_corner -name bcwc \
    -early_timing_condition { fast } \
    -late_timing_condition { slow } \
    -early_rc_corner nominal \
    -late_rc_corner nominal
create_delay_corner -name leakage \
    -early_timing_condition { leakage } \
    -late_timing_condition { leakage } \
    -early_rc_corner nominal \
    -late_rc_corner nominal

## constraint_mode
create_constraint_mode -name nominal \
    -sdc_files { Outputs/outputs_Apr20//transmitter.nominal.sdc }

## analysis_view
create_analysis_view -name bcwc \
    -constraint_mode nominal \
    -delay_corner bcwc
create_analysis_view -name leakage \
    -constraint_mode nominal \
    -delay_corner leakage

## set_analysis_view
set_analysis_view -setup { bcwc } \
                  -hold { bcwc } \
                  -leakage leakage \
                  -dynamic leakage
