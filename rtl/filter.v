`include "mapper.v"
`include "upsample.v"
`include "shape.v"

/*
 * Accepts 2 bits (bit1, bit2) which should be fixed for 8 clock cycles.
 * Outputs real_out, imag_out (I and Q components) every clock cycle.
 * First output appears after 70 ish clock cycles. Clock will be ignored
 * if gate is 0.
 */

module filter (clk, rst, gate, bit1, bit2, real_out, imag_out);
   input clk, rst, bit1, bit2, gate;
   wire clk, rst, bit1, bit2, gate;
   output signed [15:0] real_out;
   output signed [15:0] imag_out;
   wire signed [15:0]   real_out;
   wire signed [15:0]   imag_out;

   wire signed [31:0]   re;
   wire signed [31:0]   im;

   wire signed [31:0]   re_up;
   wire signed [31:0]   im_up;

   wire signed [31:0]   xout_re;
   wire signed [31:0]   xout_im;

   wire clk_gate;

   localparam yin = 32'd0;

   assign clk_gate = clk & gate;

   mapper mapper (.bit1(bit1), .bit2(bit2), .re(re), .im(im));

   upsample upsample_real (.clk(clk_gate), .rst(rst), .x(re), .y(re_up));
   upsample upsample_imag (.clk(clk_gate), .rst(rst), .x(im), .y(im_up));

   shape shape_real (.clk(clk_gate), .rst(rst), .xin(re_up), .yin(yin), .xout(xout_re), .yout(real_out));
   shape shape_imag (.clk(clk_gate), .rst(rst), .xin(im_up), .yin(yin), .xout(xout_re), .yout(imag_out));
endmodule
