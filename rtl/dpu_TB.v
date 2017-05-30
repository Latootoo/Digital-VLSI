`timescale 1 ns / 1 ns
`ifndef NO_TIMING
 `include "/afs/ee.cooper.edu/courses/ece447/gpdk/GPDK045/gsclib045_svt_v4.4/gsclib045/verilog/slow_vdd1v0_basicCells.v"
`endif
`include "dpu.v"

module dpu_tb ();
   reg clk, clkEn; // 1-bit wide
   wire clkGated; // 1-bit wide
   reg [31:0] xin;
   reg [31:0] yin;
   wire [31:0] xout;
   wire [31:0] yout;

   dpu dpu_test (.clk(clkGated), .xin(xin), .yin(yin), .xout(xout), .yout(out));

   assign clkGated = (clk & clkEn);
   always #1 clk = ~clk;
   always #2 xin = xin + 1;

   initial begin
`ifdef SIM_IS_ICARUS
      $dumpfile("dpu.vcd");
      $dumpvars;
`else
      $shm_open("dpu.shm");
      $shm_probe("ASCM");
`endif
      clk = 1'b0;
      clkEn = 1'b0;
      xin = 32'd0;
      yin = 32'd1;
      clkEn = 1'b1;
      #20 $finish;
   end

endmodule
