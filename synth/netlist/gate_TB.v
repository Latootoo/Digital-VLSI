`timescale 1 ns / 1 ns
`ifndef NO_TIMING
 `include "/afs/ee.cooper.edu/courses/ece447/gpdk/GPDK045/gsclib045_svt_v4.4/gsclib045/verilog/slow_vdd1v0_basicCells.v"
`endif
`include "TurboEncoderBlock.v"
//`include "./outputs_Apr28/TurboEncoderBlock.v"
//`include "rsc.v"
//`include "output_block.v"
//`include "input_block.v:


module TurboEncoderTB ();
   reg clk,input_bits,reset,enable;
   wire clkGated,valid,out0,out1;
   reg  clk_slow; // times slower clock for everything but the output block
   reg [2:0] counter;
   reg [12:0] i; 

   TurboEncoderBlock cat(.clk(clkGated), .clk_slow(clk_slow),.reset(reset), .input_bits(input_bits),.out0(out0),.out1(out1),.valid(valid),.enable(enable));

   assign clkGated = (clk & enable);

   always #1 clk = ~clk;


   initial begin
`ifdef SIM_IS_ICARUS
      $dumpfile("TurboEncoder.vcd");
      $dumpvars;
`else
      $shm_open("TurboEncoder.shm");
      $shm_probe("ASCM");
`endif
      enable = 1'b1;
      input_bits = 1'b1;
      clk = 1'b0;
      reset = 1'b1;
      clk_slow = 1'b0;
      counter = 3'd0;
      #48 reset = 1'b0;
      input_bits = 0;
      for(i = 0; i < 4096; i = i + 1) begin   // 6 Clock Cycle in Between
         input_bits = ~input_bits;
         #48;
      end
      #200000 $finish;
   end

   always@ (posedge clk) begin
      if(counter == 3'd6) begin   // Clk Slow should be 8 times as slow. 
	      counter = 3'd0;
	      clk_slow = ~clk_slow;
      end
      //if(counter == 3'd3) begin
	   //clk_slow = 1'b0;
      //end
      counter = counter + 1;
   end

endmodule
