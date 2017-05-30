`timescale 1 ns / 1 ns
`ifndef NO_TIMING
 `include "/afs/ee.cooper.edu/courses/ece447/gpdk/GPDK045/gsclib045_svt_v4.4/gsclib045/verilog/slow_vdd1v0_basicCells.v"
`endif

`include "shape.v"

module shape_tb ();
   reg clk, clkEn; // 1-bit wide
   wire clkGated; // 1-bit wide
   reg [31:0] xin;
   reg [31:0] yin;
   wire [31:0] xout;
   wire [31:0] yout;

   shape shape_test ( .clk(clkGated), .xin(xin), .yin(yin), .xout(xout), .yout(yout));

   assign clkGated = (clk & clkEn);
   always #1 clk = ~clk;

   initial begin
`ifdef SIM_IS_ICARUS
      $dumpfile("shape.vcd");
      $dumpvars;
`else
      $shm_open("shape.shm");
      $shm_probe("ASCM");
`endif
      clk = 1'b1;
      clkEn = 1'b0;
      xin = 32'd46341;
      yin = 32'd0;
      #1 clkEn = 1'b1;
      #2 xin = 32'd0;
      #14 xin = 32'd46351;
      #2 xin = 32'd0;
      #14 xin = 32'd46351;
      #2 xin = 32'd0;
      #14 xin = 32'd46351;
      #2 xin = 32'd0;
      #14 xin = 32'd46351;
      #2 xin = 32'd0;
      #14 xin = 32'd46351;
      #2 xin = 32'd0;
      #14 xin = 32'd46351;
      #2 xin = 32'd0;
      #14 xin = 32'd46351;
      #2 xin = 32'd0;
      #300 $finish;
   end

endmodule
