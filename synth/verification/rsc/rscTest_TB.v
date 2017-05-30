`timescale 1 ns / 1 ns
`ifndef NO_TIMING
 `include "/afs/ee.cooper.edu/courses/ece447/gpdk/GPDK045/gsclib045_svt_v4.4/gsclib045/verilog/slow_vdd1v0_basicCells.v"
`endif
`include "rscTest.v"


module rscTest_TB ();

   reg   clk, in1, in2, reset, mode;
   wire  valid1, valid2, out0, out1, out2, out3;
   reg   out0_gld, out1_gld, out2_gld, out3_gld; 
   reg   clk_slow; 
   reg   [2:0] counter;
   reg   [12:0] i; 
   reg   err; 

   rscTest cat(.clk(clk), .clk_slow(clk_slow), .reset(reset), .in1(in1), .in2(in2), .mode(mode), .out0(out0), .out1(out1), .out2(out2), .out3(out3), .valid1(valid1), .valid2(valid2));

   always #1 clk = ~clk;

   integer in; 
   initial begin    // This Initial Block is for writing to input. 
      in = $fopen("input.txt", "r");  // Input 

      mode        = 1'b0;
      in1         = 1'b0;
      in2         = 1'b0;
      clk         = 1'b0;
      reset       = 1'b0;
      clk_slow    = 1'b0;
      counter     = 3'd0;
      #48 reset   = 1'b1; // Reset is active Low 

      for(i = 0; i < 4096; i = i + 1) begin   // Sets in1 and in2 based on input.txt. 
         $fscanf(in, "%b\t%b\n", in1, in2); 
         #24;
      end
      mode        = 1'b1; 

      $fclose(in); 
      #200000 $finish;
   end
   

   integer gld_out, rsc_out, k; 
   initial begin   // This Initial block is for comparing outputs with golden output. 
      gld_out = $fopen("output.txt", "r");  // Golden Output 
      rsc_out = $fopen("rsc_output.txt", "w"); // for DUT output. 

      err = 1'b0; 

      @(posedge valid1); // Wait for output to be valid. 

      for (k = 0; k < 4099 ; k = k + 1) begin 
         @(posedge clk_slow); 
         $fscanf(gld_out, "%b\t%b\t%b\t%b\n", out0_gld, out1_gld, out2_gld, out3_gld); 
         $fwrite(rsc_out, "%b\t%b\t%b\t%b\n", out0, out1, out2, out3); 
         // Compare 
         if(out0_gld != out0 | out1_gld != out1 || out2_gld != out2 || out3_gld != out3) begin 
            $display ("DUT Error %b-%b %b-%b %b-%b %b-%b Gld-NonGld @ line %d\n", out0_gld, out0, out1_gld, out1, out2_gld, out2, out3_gld, out3, k); 
            err = 1'b1;          
         end
      
      end
      
      if(err == 1'b0) 
            $display("Success! No Error in Comparison\n"); 

      $fclose(gld_out); 
   end



   always@ (posedge clk) begin
      if(counter == 3'd6) begin   // Clk Slow should be 6 times slower than base clock. 
	      counter = 3'd0;
	      clk_slow = ~clk_slow;
      end
      counter = counter + 1;
   end

   
endmodule
