module mapper (bit1, bit2, re, im);
   input bit1, bit2;
   output signed [31:0] re;
   output signed [31:0] im;
   //commented out "wire bit," seems unsued
   //   wire bit;
   reg signed [31:0]    rer;
   reg signed [31:0]    imr;

   wire signed [31:0]   re;
   wire signed [31:0]   im;

   always @(*) begin
      if (bit1 == 0) begin
         rer = 32'd46341;
      end
      else begin
         rer = -32'd46341;
      end
      if (bit2 == 0) begin
         imr = 32'd46341;
      end
      else begin
         imr = -32'd46341;
      end
   end

   assign re = rer;
   assign im = imr;
endmodule
