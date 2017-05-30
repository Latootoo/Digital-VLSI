`timescale 1 ns / 1 ns
`ifndef NO_TIMING
 `include "/afs/ee.cooper.edu/courses/ece447/gpdk/GPDK045/gsclib045_svt_v4.4/gsclib045/verilog/slow_vdd1v0_basicCells.v"
`endif
`include "AddrEncoder.v"

module AddrEncoder_TB();
   reg [11:0] out;
   reg [11:0] in;
   reg        clk;


   AddrEncoder AddrEncoder_1( .clk(clk), .in(in), .out(out) );
   always #1 clk = ~clk;

   initial begin
`ifdef SIM_IS_ICARUS
      $dumpfile("AddrEncoder.vcd");
      $dumpvars;
`else
      $shm_open("AddrEncoder.shm");
      $shm_probe("ASCM");
`endif

      clk = 1'b0;
      #1
         for(int i = 0; i < 4096; i++ )
            #2 in = i;
      $finish;
   end
endmodule
