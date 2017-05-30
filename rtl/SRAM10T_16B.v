/*
 *****Overview*****
 Dual read SRAM (16 Bits)

 *****Inputs*****
 clk        -   At the positive clock edge, latch inputs: (addr1,addr2,writeLine) to internal registers
 addr1      -   address for writeLine input and for readLine1 output
 addr2      -   address for readLine2 output
 writeLine  -   Input port for writing to device
 RdWr       -   Low for read operation, high for write operation.  When RdWr is high, readLine1 and readLine2 is hiZ.
 DevEn      -   active low, when DevEn is high, read and write operation is disabled

 *****Outputs*****
 readLine1  -   Output port 1 for reading from device
 readLine2  -   Output port 2 for reading from device

 */
module SRAM10T_16B(clk, addr1, addr2, readLine1, readLine2, writeLine, RdWr, DevEn);

   input    writeLine;
   input [3:0] addr1, addr2;
   input       clk;
   output      readLine1, readLine2;
   input       RdWr, DevEn;

   wire        RdWr, DevEn, writeLine, readLine1, readLine2, clk;
   wire [3:0]  addr1, addr2;
   reg [3:0]   intAddr1, intAddr2;
   reg [15:0]  M;
   reg         memVal_wr, memVal_r1, memVal_r2;

   always @(posedge clk) begin //At the positive clock edge, latch inputs to internal registers
      intAddr1 = addr1;
      intAddr2 = addr2;
      memVal_wr = writeLine;
   end

   always @(intAddr1 or intAddr2 or RdWr or memVal_wr or DevEn) begin
      if(!DevEn) begin
         if(RdWr) begin
            M[intAddr1] = memVal_wr;
            memVal_r1 = 1'bZ;
            memVal_r2 = 1'bZ;
         end
         else begin
            memVal_r1 = M[intAddr1];
            memVal_r2 = M[intAddr2];
         end
      end
      else begin
         memVal_r1 = 1'bZ;
         memVal_r2 = 1'bZ;
      end
   end

   assign readLine1 = memVal_r1;
   assign readLine2 = memVal_r2;

endmodule
