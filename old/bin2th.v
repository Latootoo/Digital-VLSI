//Max Howald
//bin2th example.

`timescale 1 ns / 10 ps
module bin2th ( IN, OUT );
   
   parameter INWIDTH = 3;
   parameter OUTWIDTH = (1 << INWIDTH ) - 1;
   input [INWIDTH-1:0] IN;
   output [OUTWIDTH-1:0] OUT;
   
   generate
      genvar i;
      for ( i = 0; i <= OUTWIDTH-1; i = i+1 )
        begin : mainblock
           assign OUT[i] = ( IN > i ) ? 1'b1 : 1'b0;
        end // mainblock
   endgenerate
   
endmodule
