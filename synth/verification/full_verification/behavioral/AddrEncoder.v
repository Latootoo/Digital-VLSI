module AddrEncoder(clk, in, out );
   input clk;
   input [11:0] in;
   output [11:0] out;

   wire          clk;
   wire [11:0]   in;
   wire [11:0]   out;
   reg [11:0]    i;
   reg [11:0]    pi;
   // sequential State transitioning block

   parameter f1 = 31;
   parameter f2 = 64;
   parameter K = 4096;

   always @(posedge clk)
      i <= in;

   // combinational state-transition determination
   always @(i) begin
      pi <= (f1*i + f2*i*i) % K;
   end

   assign out = pi;

endmodule
