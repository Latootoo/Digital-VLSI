//Max Howald
//bin2th testbench.

`timescale 1 ns / 10 ps
`include "bin2th.v"

module bin2th_test ();

   parameter INWIDTH = 3;
   parameter OUTWIDTH = (1 << INWIDTH ) - 1;

   reg [INWIDTH-1:0] binary_in;
   wire [OUTWIDTH-1:0] thermometer_out;

   // override the parameters in the bin2th module for a different
   // size bin2th.
   defparam encoder.INWIDTH = INWIDTH;
   defparam encoder.OUTWIDTH = OUTWIDTH;
   
   bin2th encoder ( .IN(binary_in), .OUT(thermometer_out) );

   always begin
      #1 $display("%d %b", binary_in, thermometer_out);
      binary_in <= binary_in + 1;

   end
   
   initial begin      
      $shm_open("bin2th_test.shm");
      $shm_probe("ASCM"); 
      binary_in = 0;      
      #32 $finish; 
   end
endmodule 
