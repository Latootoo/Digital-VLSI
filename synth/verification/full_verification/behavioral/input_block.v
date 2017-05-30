// Input block - also does the interleaving.

`timescale 1 ns / 10 ps
module input_block(clk, bin_in, bin_out, bin_int_out, reset, valid, mode);
   input clk, bin_in, reset;
   output bin_out, bin_int_out,valid,mode;

   wire   clk, bin_in; // 1-bit wide
   reg    bin_out, bin_int_out, valid, bin_in_tmp; 

   // Internal Variables
   reg        current_block;
   reg        mode;//renamed Term_En to mode
   //reg        validReg;
   reg [11:0] counter, rom_counter, rd_counter;     // Input counter
   reg [2:0]  Term_Counter; // Termination Counter

   // Sram Interface variables
   reg         RdWr0, RdWr1, DevEn0, DevEn1, Dev0_State, Dev1_State;
   reg  [11:0] b0_addr1, b0_addr2, b1_addr1, b1_addr2;
   wire [11:0] addr1_tmp, addr2_tmp; 
   wire        b0_out0, b0_out1, b1_out0, b1_out1; 
   reg         valid_reg; 

   // Instantiate Srams
   SRAM10T Buffer_0(.clk(!clk), .addr1(b0_addr1), .addr2(b0_addr2), .readLine1(b0_out0),.readLine2(b0_out1), .writeLine(bin_in_tmp), .RdWr(RdWr0), .DevEn(DevEn0));
   SRAM10T Buffer_1(.clk(!clk), .addr1(b1_addr1), .addr2(b1_addr2), .readLine1(b1_out0),.readLine2(b1_out1), .writeLine(bin_in_tmp), .RdWr(RdWr1), .DevEn(DevEn1));
   AddrEncoder ROM (.clk(clk), .in(rom_counter),  .out(addr2_tmp));  
   

   always @(posedge clk) begin
            
      bin_in_tmp <= bin_in;    
      //valid <= valid_reg;    

      if(reset) begin 
         rom_counter   <= 12'd0; 
         rd_counter    <= 12'd0; 
         //counter       <= 12'd4095; // Correct Output in Behavioral 
         counter       <= 12'd0; // 
         mode          <= 1'b0; 
         Term_Counter  <= 3'd0;
         current_block <= 1'b1;
         DevEn1        <= 1'b1;               // Disable Block 1
         DevEn0        <= 1'b1;               // Disable Block 0
      end


      // Increment Counter if not in Termination Bit Stage
      if(mode == 1'b0 && reset == 1'b0) begin
         counter <= counter + 1;               

         if(current_block == 1'b0) begin  
            DevEn0 <= 1'b0; 
            RdWr0  <= 1'b1;    // Write to Block 0.
            RdWr1  <= 1'b0;    // Read from Block 1 
         end 

         if(current_block == 1'b1) begin 
            DevEn1 <= 1'b0; 
            RdWr0  <= 1'b0;    // Read from Block 0. 
            RdWr1  <= 1'b1;    // Write to Block 1.
         end

      end

      if(Term_Counter != 3'd1) begin 
         if(current_block == 1'b1) begin 
            bin_out <= b0_out0;  
            bin_int_out <= b0_out1; 
         end
         if(current_block == 1'b0) begin 
            bin_out <= b1_out0;  
            bin_int_out <= b1_out1; 
         end
      end else begin 
         bin_out <= 1'b0; 
         bin_int_out <= 1'b0; 
      end

      // If counter has overflowed, Enable Termination Bit Stage
      if(counter == 12'd4095 && reset == 1'b0 && DevEn1 == 1'b0) begin
         mode       <= 1'b1;
         RdWr0      <= 1'b0; 
         RdWr1      <= 1'b0; 
      end

      if(~mode) begin 
         rom_counter <= rom_counter + 1; 
         rd_counter <= rd_counter + 1; 
      end

      // Termination Bit Stage
      if (mode) begin
         Term_Counter <= Term_Counter + 1;

         if(Term_Counter == 3'd0) begin 
            Dev0_State  <= DevEn0;
            Dev1_State  <= DevEn1;
            rom_counter <= 12'd0; 
         end

         if(Term_Counter == 3'd1) begin 
            rom_counter <= 12'd1;
            rd_counter <= 12'd0; 
            current_block  <= ~current_block;  // Flips between 0 and 1
            RdWr0          <= current_block;  // Low for Read, High for Write: cb = 0 -> block 0 is writing. cb = 1 -> block0 is reading.
            RdWr1          <= ~ current_block;  // Low for Read, High for Write: cb = 0 -> block 1 is reading. cb = 1 -> block1 is writing.            
         end

         if(Term_Counter == 3'd2) begin
            DevEn0         <= 1'b0;
            DevEn1         <= Dev1_State;
            counter        <= 12'd0;
            mode           <= 1'b0;         
            Term_Counter   <= 3'd0;
            rom_counter    <= 12'd2;
            rd_counter     <= 12'd1; 
         end
      end
         
   end


   // Control block for valid pin. 
  always @(posedge clk) begin 
      if(reset) 
         valid <= 1'b0; 
      else begin 
         if(Term_Counter == 3'd2)   
            valid <= 1'b1; 
      end
   end

   always @(*) begin

      if(reset == 1'b1) begin
         b0_addr1         = 12'd0;
         b0_addr2         = 12'd0;
         b1_addr1         = 12'd0;
         b1_addr2         = 12'd0;
      end
      else begin
         if(current_block == 1'b0) begin // Write to Block 0 & Read for Block 1.
            b0_addr1  = counter; 

            if(DevEn1 ==  1'b0) begin // Read from block 1 if it is ready.
               b1_addr1 = rd_counter; 
               b1_addr2 = addr2_tmp; 
            end

         end
         else if(current_block == 1'b1) begin // Write to Block 1 // Read from Block 0
            b1_addr1 = counter; 

            if(DevEn0  == 1'b0) begin         // Read from block 0 if it is ready.
               b0_addr1 = rd_counter;    
               b0_addr2 = addr2_tmp; 
            end
         end
      end
   end

endmodule
