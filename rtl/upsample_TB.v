`timescale 1 ns / 1 ns
`ifndef NO_TIMING
 `include "/afs/ee.cooper.edu/courses/ece447/gpdk/GPDK045/gsclib045_svt_v4.4/gsclib045/verilog/slow_vdd1v0_basicCells.v"
`endif
`include "upsample.v"

module upsample_tb ();
   reg clk, clkEn; // 1-bit wide
   wire clkGated; // 1-bit wide
   reg [31:0] x;
   wire [31:0] y;

   upsample upsample_test ( .clk(clkGated), .x(x), .y(y));

   assign clkGated = (clk & clkEn);
   always #1 clk = ~clk;
   always @(posedge clk)
      #16 x = x +1;

   initial begin
`ifdef SIM_IS_ICARUS
      $dumpfile("upsample.vcd");
      $dumpvars;
`else
      $shm_open("upsample.shm");
      $shm_probe("ASCM");
`endif
      clk = 1'b1;
      x = 32'd10;
      clkEn = 1'b1;
      #150 $finish;
   end

endmodule
