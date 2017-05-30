`timescale 1 ns / 1 ns
`ifndef NO_TIMING
 `include "/afs/ee.cooper.edu/courses/ece447/gpdk/GPDK045/gsclib045_svt_v4.4/gsclib045/verilog/slow_vdd1v0_basicCells.v"
`endif
`include "filter.v"

module filter_tb ();
   reg clk, clkEn, rst; // 1-bit wide
   reg  bit1;
   reg  bit2;
   wire [15:0] re;
   wire [15:0] im;

   filter filter_test (.clk(clk), .rst(rst), .gate(clkEn), .bit1(bit1), .bit2(bit2), .real_out(re), .imag_out(im));

   always #1 clk = ~clk;

   //always @(posedge clk) begin
   //   #16 bit1 = ~bit1;
   //   #16 bit2 = ~bit2;
   //end

   initial begin
`ifdef SIM_IS_ICARUS
      $dumpfile("filter.vcd");
      $dumpvars;
`else
      $shm_open("filter.shm");
      $shm_probe("ASCM");
`endif
      clk = 1'b1;
      clkEn = 1'b1;
      bit1 = 1'b0;
      bit2 = 1'b0;
	  rst = 1'b0;
	  #1 rst = 1'b1;
	  #10 rst = 1'b0;
      #500 $finish;
   end

endmodule
