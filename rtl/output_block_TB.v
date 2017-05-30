`timescale 1 ns / 10 ps
`ifndef NO_TIMING
 `include "/afs/ee.cooper.edu/courses/ece447/gpdk/GPDK045/gsclib045_svt_v4.4/gsclib045/verilog/slow_vdd1v0_basicCells.v"
`endif
`include "output_block.v"
//`include "./outputs_Apr27/output_block.v"  // Gate Level Netlist 


module output_block_TB ();
   reg [3:0] in;
   reg       clk, reset, mode, clkEn, validIn;
   wire      clkGated; 
   wire       out0, out1, validOut;
   reg [12:0] i;

   output_block cat(.in(in), .clk(clkGated), .reset(reset), .mode(mode), .validIn(validIn), .out0(out0), .out1(out1), .validOut(validOut));

   assign clkGated = (clk & clkEn);

   always #1 clk = ~clk;




   initial begin
      in       = 4'd0;
      clk      = 1'b0;
      clkEn    = 1'b1;
      reset    = 1'b1;
      mode     = 1'b0;
      validIn  = 1'b0;

      #3 reset = 1'b0;
      validIn  = 1'b1;
      // Normal Mode
      for(i = 0; i < 4096; i = i + 1) begin   // 6 Clock Cycle in Between
         in = in + 1;
         #24;
      end

      // Termination Mode
      mode = 1'b1;
      in   = 4'b1111;
      for(i = 0; i < 3; i = i + 1) begin   // 6 Clock Cycle in Between
         in = in + 1;
         #24;
      end
      validIn  = 1'b0;

      #48 // 1 Input cycle pause 

      mode = 1'b0; 
      for(i = 0; i < 4096; i = i + 1) begin   // 6 Clock Cycle in Between
         validIn  = 1'b1;
         in = in + 1;
         #24;
      end

      // Termination Mode
      mode = 1'b1;
      in   = 4'b1111;
      for(i = 0; i < 3; i = i + 1) begin   // 6 Clock Cycle in Between
         in = in + 1;
         #24;
      end
      validIn  = 1'b0;

      #48 // 2 Input cycle pause 

      mode = 1'b0; 
      for(i = 0; i < 4096; i = i + 1) begin   // 6 Clock Cycle in Between
         validIn  = 1'b1;
         in = in + 1;
         #24;
      end

      // Termination Mode
      mode = 1'b1;
      in   = 4'b1111;
      for(i = 0; i < 3; i = i + 1) begin   // 6 Clock Cycle in Between
         in = in + 1;
         #24;
      end
      validIn  = 1'b0;

      #48 // 2 Input cycle pause 

      mode = 1'b0; 
      for(i = 0; i < 4096; i = i + 1) begin   // 6 Clock Cycle in Between
         validIn  = 1'b1;
         in = in + 1;
         #24;
      end
      #100 $finish;
   end

endmodule
