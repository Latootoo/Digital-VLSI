`timescale 1 ns / 1 ns

`include "rsc.v"
`include "input_block.v"
`include "output_block.v"
`include "../../rtl/SRAM10T.v"
`include "../../rtl/AddrEncoder.v"

//`include "SRAM10T_16B.v"

module TurboEncoderBlock (clk, clk_slow, reset, input_bits,out0, out1,valid,enable);


   input  clk, clk_slow, input_bits, reset, enable;
   output out0, out1, valid;

   //define ports
   wire   clk,input_bits,out0,out1,reset,enable;
   wire   intrvalid, valid;
   reg    resetReg;
   
   //internal variables
   wire   input_rsc,	input_rsc_intrlvd; //what the input block spits out
   wire   valid_out; 
   wire   mode; //is it in termination mode or not
   wire [3:0] rsc_output;// in[0] = x; in[1] = z; in[2] = z'; in[3] = x'; I STILL DONT DO X'

   input_block in_block(.clk(clk_slow), .bin_in(input_bits), .bin_out(input_rsc), .bin_int_out(input_rsc_intrlvd), .reset(reset),.valid(intrvalid),.mode(mode));
   rsc rsc_1(.clk(clk_slow), .in(input_rsc), .x_out(rsc_output[0]), .z_out(rsc_output[1]), .rst_N(intrvalid), .mode(mode), .valid_out(valid_out));
   rsc rsc_2(.clk(clk_slow), .in(input_rsc_intrlvd), .x_out(rsc_output[2]), .z_out(rsc_output[3]), .rst_N(intrvalid), .mode(mode), .valid_out(valid_out));
   output_block out_block(.in(rsc_output), .clk(clk), .reset(reset),  .mode(mode),.validIn(valid_out), .out0(out0), .out1(out1), .validOut(valid));

endmodule
