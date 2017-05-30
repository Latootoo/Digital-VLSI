`include "filter.v"
`include "TurboEncoderBlock.v"

module transmitter (clk, clk_slow, in, real_out, imag_out, reset, enable);

   input  clk, clk_slow, in, reset, enable;

   output signed [15:0] real_out;
   output signed [15:0] imag_out;

   wire   clk, clk_slow, in, reset, enable;
   reg   out0, out1, valid;


   wire signed [15:0] real_out;
   wire signed [15:0] imag_out;

   TurboEncoderBlock turbo_coder(.clk(clk), .clk_slow(clk_slow),
                                 .input_bits(in), .reset(reset),
                                 .enable(enable), .out0(out0),
                                 .out1(out1), .valid(valid));


   filter filt(.clk(clk), .rst(reset), .gate(valid), .bit1(out0), .bit2(out1), .real_out(real_out), .imag_out(imag_out));

endmodule
