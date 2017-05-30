module upsample ( clk, rst, x, y );
   input clk, rst;
   input signed [31:0] x;
   output signed [31:0] y;

   wire clk, rst;
   wire signed [31:0]   x;
   wire signed [31:0]   y;

   reg signed [31:0]    state;
   reg [2:0]            count;

   always @(posedge clk) begin
      if (rst)
	  begin
	     count <= 3'd0;
		 state <= 32'd0;
	  end
	  else
	  begin
         count <= count + 1;
         if (count == 0)
            state <= x;
         else
            state <= 32'd0;
      end
   end

   assign y = state;
endmodule
