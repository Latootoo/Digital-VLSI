`timescale 1 ns / 1 ns

`include "../../netlist/rsc.v"  // Gate Level Netlist 

module rscTest(clk, clk_slow, reset, in1, in2, mode, out0, out1, out2, out3, valid1, valid2);

   // Ports 
   input  clk, clk_slow, in1, in2, reset, mode;
   wire   clk, clk_slow, in1, in2, reset, mode;    

   output out0, out1, out2, out3, valid1, valid2;
   wire   out0, out1, out2, out3, valid1, valid2; 

   rsc rsc_1(.clk(clk_slow), .in(in1), .x_out(out0), .z_out(out1), .rst_N(reset), .mode(mode), .valid_out(valid1));
   rsc rsc_2(.clk(clk_slow), .in(in2), .x_out(out3), .z_out(out2), .rst_N(reset), .mode(mode), .valid_out(valid2));


endmodule
