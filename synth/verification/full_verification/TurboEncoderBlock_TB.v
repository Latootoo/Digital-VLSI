`timescale 1 ns / 1 ns
`ifndef NO_TIMING
 `include "/afs/ee.cooper.edu/courses/ece447/gpdk/GPDK045/gsclib045_svt_v4.4/gsclib045/verilog/slow_vdd1v0_basicCells.v"
`endif

`include "TurboEncoderBlock.v"



module TurboEncoderTB ();
   reg clk, input_bits, reset, enable;
   wire clkGated,valid,out0,out1;
   reg  clk_slow; 
   reg [2:0] counter;
   reg tmp; 

   reg out0g, out1g, err; 

   TurboEncoderBlock cat(.clk(clk), .clk_slow(clk_slow),.reset(reset), .input_bits(input_bits),.out0(out0),.out1(out1), .valid(valid), .enable(enable));

   //assign clkGated = (clk & enable);

   always #1 clk = ~clk;

   integer infile, i; 
   initial begin
      `ifdef SIM_IS_ICARUS
            $dumpfile("TurboEncoder.vcd");
            $dumpvars;
      `else
            $shm_open("TurboEncoder.shm");
            $shm_probe("ASCM");
      `endif
      infile = $fopen("input.txt", "r"); 

      enable = 1'b1;
      input_bits = 1'b1;
      clk = 1'b0;
      reset = 1'b1;
      clk_slow = 1'b0;
      counter = 3'd0;
      #61 reset = 1'b0;
      input_bits = 0;

      for(i = 0; i < 4096; i = i + 1) begin   // 6 Clock Cycle in Between
         $fscanf(infile, "%b\n", input_bits); 
         #24;
      end

      #72 // Termination Mode 

      for(i = 0; i < 4096; i = i + 1) begin   // 6 Clock Cycle in Between
         $fscanf(infile, "%b\n", input_bits); 
         #24;
      end

      #72 // Termination Mode 

      for(i = 0; i < 4096; i = i + 1) begin   // 6 Clock Cycle in Between
         $fscanf(infile, "%b\n", input_bits); 
         #24;
      end

      $fclose(infile); 

      #200000 $finish;
   end

   always@ (posedge clk) begin
      if(counter == 3'd6) begin   // Clk Slow should be 6 times slower than base clock.  
	      counter = 3'd0;
	      clk_slow = ~clk_slow;
      end
      counter = counter + 1;
   end

   integer outfile, gldfile, k; 
   initial begin 
      err = 1'b0; 
      outfile = $fopen("full_output.txt", "w"); 
      gldfile = $fopen("gld_output.txt", "r"); 
      

      @(posedge valid); 

      #2 
      for(k = 0; k < 6150; k = k + 1) begin 
         @(posedge clk) 
         $fwrite(outfile, "%b\t%b\n", out0, out1);
         $fscanf(gldfile, "%b\t%b\n", out0g, out1g); 
         if((out0 != out0g) || (out1 != out1g)) begin 
            $display ("DUT Error %b-%b %b-%b  Gld-NonGld @ line %d\n", out0g, out0, out1g, out1, k);  
            err = 1'b1; 
         end
         #16;  
      end

      for(k = 0; k < 6150; k = k + 1) begin 
         @(posedge clk) 
         $fwrite(outfile, "%b\t%b\n", out0, out1);
         $fscanf(gldfile, "%b\t%b\n", out0g, out1g); 
         if((out0 != out0g) || (out1 != out1g)) begin
            $display ("DUT Error %b-%b %b-%b  Gld-NonGld @ line %d\n", out0g, out0, out1g, out1, k+6150);  
            err = 1'b1; 
         end
         #16;  
      end

      for(k = 0; k < 6150; k = k + 1) begin 
         @(posedge clk) 
         $fwrite(outfile, "%b\t%b\n", out0, out1);
         $fscanf(gldfile, "%b\t%b\n", out0g, out1g); 
         if((out0 != out0g) || (out1 != out1g)) begin
            $display ("DUT Error %b-%b %b-%b  Gld-NonGld @ line %d\n", out0g, out0, out1g, out1, k+12300);  
            err = 1'b1; 
         end
         #16;  
      end

      if(err == 1'b0)
         $display("Success! No Error in Comparison\n");  

      $fclose(outfile); 
      $fclose(gldfile); 

   end

endmodule
