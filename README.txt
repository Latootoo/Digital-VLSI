This repo will contain all the rtl and other files associated with our
project for ece447, digital VLSI.

The current plan is for the transmitter to comprise three main
blocks:

(1) LDPC encoder
(2) symbol mapper (binary to 4-QAM)
(3) pulse shaping (root raised cosine filter)

Additionally, we will need I/O control and a custom memory (SRAM
and/or EEPROM).

Currently, the only thing in this repo is the thermometer encoder from
lab 2 with a makefile for compilation and simulation.

Two simulators are supported: 

(1) Cadence's verilog simulator, i.e. the one on the machines in the ICE lab.
(2) Icarus verilog, a FOSS verilog toolchain so that you can work on your own machine.

You can install icarus on Linux or OS X from a package manager: pacman
-S iverilog (arch), apt-get install iverilog (debian/ubuntu), brew
install iverilog (mac) or build from source:
http://iverilog.wikia.com/wiki/Installation_Guide

To run the example with the cadence sim, run:
make nc_bin2th_test

To run with icarus:
make icarus_bin2th_test

You can add other modules by adding space-separated testbench names in
the makefile.

I hope that it won't be too hard to keep things compatible with both
of the simulators. If something compiles with cadence but not icarus
or vice versa, you're probably using some weird SystemVerilog feature.
