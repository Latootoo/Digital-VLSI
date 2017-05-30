`timescale 1 ns / 1 ns
`ifndef NO_TIMING
 `include "/afs/ee.cooper.edu/courses/ece447/gpdk/GPDK045/gsclib045_svt_v4.4/gsclib045/verilog/slow_vdd1v0_basicCells.v"
`endif


`include "mapper.v"

module mapper_tb ();
   reg clk, clkEn; // 1-bit wide
   wire clkGated; // 1-bit wide
   reg  bit1;
   reg  bit2;
   wire [31:0] re;
   wire [31:0] im;


   mapper mapper_test (.bit1(bit1), .bit2(bit2), .re(re), .im(im));

   assign clkGated = (clk & clkEn);
   always #1 clk = ~clk;

   always @(posedge clk) begin
      #1 bit1 = ~bit1;
      #2 bit2 = ~bit2;
   end

   initial begin
`ifdef SIM_IS_ICARUS
      $dumpfile("mapper.vcd");
      $dumpvars;
`else
      $shm_open("mapper.shm");
      $shm_probe("ASCM");
`endif
      clk = 1'b1;
      clkEn = 1'b1;
      bit1 = 1'b1;
      bit2 = 1'b1;
      #10 $finish;
   end

endmodule
