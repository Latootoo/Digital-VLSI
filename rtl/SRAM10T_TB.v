`timescale 1 ns / 1 ns
`ifndef NO_TIMING
 `include "/afs/ee.cooper.edu/courses/ece447/gpdk/GPDK045/gsclib045_svt_v4.4/gsclib045/verilog/slow_vdd1v0_basicCells.v"
`endif
`include "SRAM10T.v"

module SRAM_TB();


   reg RdWr, DevEn, writeLine;
   reg [11:0] addr1, addr2;
   reg        clk;
   wire       readLine1, readLine2;


   SRAM10T SRAM_1(.clk(clk), .addr1(addr1), .addr2(addr2), .readLine1(readLine1),.readLine2(readLine2), .writeLine(writeLine), .RdWr(RdWr), .DevEn(DevEn));

   always #1 clk = ~clk;
   always @(negedge clk) begin
      addr1 = addr1+1;
      addr2 = addr2+1;
      writeLine = addr1%2;
   end

   initial begin
`ifdef SIM_IS_ICARUS
      $dumpfile("SRAM10T.vcd");
      $dumpvars;
`else
      $shm_open("SRAM10T.shm");
      $shm_probe("ASCM");
`endif
      clk = 1'b0;
      RdWr = 1'b1;
      DevEn = 1'b0;
      addr1 = 12'b0;
      addr2 = 12'b0;
      while(addr1!=12'd4095)#1;
      DevEn = 1'b1;
      #1 RdWr = 1'b0;
      addr1 = 12'd123;
      addr2 = 12'd123;
      writeLine = 1'b1;
      #1 DevEn = 1'b0;
      #10 $finish;
   end
endmodule
