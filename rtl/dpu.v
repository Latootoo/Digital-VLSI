module dpu (clk, rst, w, xin, yin, xout, yout);
   input clk, rst;
   input signed [31:0] w;
   input signed [31:0] xin;
   input signed [31:0] yin;
   output signed [31:0] xout;
   output signed [31:0] yout;

   wire clk, rst;
   wire signed [31:0]   w;
   wire signed [31:0]   xin;
   reg signed [31:0]    xin_z1;
   wire signed [31:0]   yin;

   wire signed [31:0]   xout;
   wire signed [31:0]   yout;
   reg signed [31:0]    yout_z0;
   reg signed [31:0]    yout_z1;

   always @(posedge clk) begin
      if (rst) begin
	     yout_z1 <= 32'd0;
		 yout_z0 <= 32'd0;
		 xin_z1 <= 32'd0;
      end
	  else
	  begin
         xin_z1 <= xin;
         yout_z0 <= yout_z1;
         yout_z1 <= w * xin_z1 + yin;
      end
   end

   assign yout = yout_z0;
   assign xout = xin_z1;
endmodule
