`timescale 1 ns / 1 ns
`ifndef NO_TIMING
 `include "/afs/ee.cooper.edu/courses/ece447/gpdk/GPDK045/gsclib045_svt_v4.4/gsclib045/verilog/slow_vdd1v0_basicCells.v"
`endif

`include "rsc.v"
//`include "./outputs_Apr23/rsc.v"
module rscTB ();

   reg clk, in, enable, rst_N, mode;
   wire x_out, z_out, valid_out, clkGated;
   reg [11:0] i; 

   rsc cat (.clk(clkGated), .in(in), .x_out(x_out), .z_out(z_out), .valid_out(valid_out), .rst_N(rst_N), .mode(mode));

   assign clkGated = (clk & enable);
   always #1 clk = ~clk;

   initial begin
`ifdef SIM_IS_ICARUS
      $dumpfile("rsc.vcd");
      $dumpvars;
`else
      $shm_open("rsc.shm");
      $shm_probe("ASCM");
`endif
      in       = 1'b0; 
      clk      = 1'b0;
      enable   = 1'b1;
      rst_N    = 1'b0;
      mode  = 1'b0; 
      #3 rst_N = 1'b1; 
      
      for(i = 0; i < 20; i = i + 1) begin   // Input changes every clock cycle. 
         in = ~in;
         #2;
      end
      mode  = 1'b1;  // Next 3 clock cycles are termination bits. No new input.
      in       = 1'b0; 
      #10;  // Pause Time 
      mode = 1'b0;            
      for(i = 0; i < 20; i = i + 1) begin   // Input changes every clock cycle. 
         in = ~in;
         #2;
      end
      mode  = 1'b1;  // Next 3 clock cycles are termination bits. No new input.
      in       = 1'b0;       
      #10;  // Pause Time 
      mode = 1'b0;            
      for(i = 0; i < 20; i = i + 1) begin   // Input changes every clock cycle. 
         in = ~in;
         #2;
      end


      #10 $finish;
   end
endmodule
