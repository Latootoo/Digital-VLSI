`timescale 1 ns / 1 ns
`ifndef NO_TIMING
 `include "/afs/ee.cooper.edu/courses/ece447/gpdk/GPDK045/gsclib045_svt_v4.4/gsclib045/verilog/slow_vdd1v0_basicCells.v"
`endif
`include "transmitter.v"


module transmitter_tb ();
   reg clk, in, reset, enable;
   wire clkGated, valid;
   reg  clk_slow; //three times slower clock for everything but the output block
   reg [2:0] counter;

   wire signed [15:0] re_out;
   wire signed [15:0] im_out;

   transmitter tx(.clk(clkGated), .clk_slow(clk_slow), .in(in),
                  .real_out(re_out), .imag_out(im_out), .reset(reset),
                  .enable(enable));



   assign clkGated = (clk & enable);

   always #1 clk = ~clk;

   initial begin
`ifdef SIM_IS_ICARUS
      $dumpfile("transmitter.vcd");
      $dumpvars;
`else
      $shm_open("transmitter.shm");
      $shm_probe("ASCM");
`endif
      enable = 1'b1;
      in = 1'b0;
      clk = 1'b0;
      clk_slow = 1'b0;
      counter = 3'd0;
//TODO: debug undocumented reset behavior.
      reset = 1'b0;
      #1 reset = 1'b1;
      #10 reset = 1'b0;

      for(int i = 0; i < 4096; i = i + 1) begin   // 6 Clock Cycle in Between
         in = ~in;
         #48;
      end

      #30000 $finish;
   end


   always@ (clk) begin
      if(counter == 3'd6) begin
	 counter = 3'd0;
	 clk_slow = 1'b1;
      end
      if(counter == 3'd3) begin
	 clk_slow = 1'b0;
      end
      counter = counter + 1;
   end

endmodule
