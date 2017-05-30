`timescale 1 ns / 1 ns
`ifndef NO_TIMING
 `include "/afs/ee.cooper.edu/courses/ece447/gpdk/GPDK045/gsclib045_svt_v4.4/gsclib045/verilog/slow_vdd1v0_basicCells.v"
`endif
`include "./outputs_Apr28/input_block.v"
//`include "input_block.v"
`include "SRAM10T.v"
`include "AddrEncoder.v"

module input_block_TB ();
   reg clk, bin_in, reset, clkEn; // 1 bit wide
   wire bin_out, bin_int_out, valid, mode;
   wire clkGated;
   
   input_block cat (.clk(clkGated), .bin_in(bin_in), .bin_out(bin_out), .bin_int_out(bin_int_out), .reset(reset), .valid(valid), .mode(mode));

   assign clkGated = (clk & clkEn);

   always #1 clk = ~clk;

   always #2 bin_in = ~bin_in;

   initial begin
`ifdef SIM_IS_ICARUS
      $dumpfile("input_block.vcd");
      $dumpvars;
`else
      $shm_open("input_block.shm");
      $shm_probe("ASCM");
`endif
      clk = 1'b0;
      clkEn = 1'b0;
      reset = 1'b1;
      bin_in = 1'b0;
      #2 clkEn = 1'b1;
      #4 reset = 1'b0;
      #40000 $finish;
   end

endmodule
