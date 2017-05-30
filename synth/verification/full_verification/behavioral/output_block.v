`timescale 1 ns / 1 ns

/*
 Input value should change every 12 clock cycles.
 Holds input values into buffer (2 write cycles)
 Read to output from buffer (after 2 write cycle delay)
 Holds output values for 8 clock cycles.
 */

module output_block(in, clk, reset, mode, validIn, out0, out1, validOut);

   // Ports
   input [3:0]        in;  // in[0] = x; in[1] = z; in[2] = z'; in[3] = x';
   wire [3:0]         in;
   input              clk, reset, mode, validIn;  // When Load is High, new input has arrived at the input port.
   wire               clk, reset, mode, validIn;  // Mode = 0 : Normal Mode; Mode = 1 : Termination Mode.
   output             out0, out1, validOut;
   reg                out0, out1, validOut;

   // Internal Variables
   reg [4:0]          counter;          // Counts up to 24.
   reg [1:0]          counter2; 
   reg                RdStart;          // Read Start Flag - Turned on when enough bits have been written to buffer.
   reg [3:0]          WrIndex0, WrIndex1;          // Write Index - buffer index to which input bit is written.
   reg [3:0]          RdIndex;          // Read Index  - buffer index from which bit is read.
   reg [15:0]         buffer0;           // Storage variable    
   reg [15:0]         buffer1;           // Storage variable    
   reg                current_buf;     // Switches between 0 & 1 

   // Update counters 
   always @(posedge clk) begin

      if(reset == 1'b1 | validIn == 1'b0) begin 
         RdStart         <= 1'b0; 
         counter         <= 5'd0;
         counter2        <= 2'd0; 
      end 
      else begin 
        
         // Reset counter @ 24
         if(counter == 5'd23) begin
            counter <= 5'd0;      
         end else begin 
            counter <= counter + 1; 
         end
         
         if(counter == 5'd23 & validIn) 
            RdStart <= 1'b1; // Start Reading now.
      end

      if(mode == 1'b1 && (counter == 5'd0 || counter == 5'd12))    
         counter2 <= counter2+1; 
      
      if(mode == 1'b0) 
         counter2 <= 2'd0; 
  
   end

   // Control WrIndex, buffer sel & store input to buffer 
   always @(posedge clk) begin 

      if(validIn == 1'b0) begin 
         WrIndex0 <= 4'd0; 
         WrIndex1 <= 4'd0;          
      end

      if(reset == 1'b1) begin 
         WrIndex0    <= 4'd0; 
         WrIndex1    <= 4'd0; 
         buffer0     <= 4'd0; 
         buffer1     <= 4'd0; 
         current_buf <= 1'b0; 
      end
      else begin 
             
            if(validIn == 1'b1) begin 

               // Store in[0] @ correct buffer 
               if(counter == 5'd0 || counter == 5'd12) begin
                  if(~mode) begin 
                     if(current_buf == 1'b0) begin 
                        buffer0[WrIndex0] <= in[0]; // x
                        WrIndex0 <= WrIndex0 + 1; 
                        current_buf <= 1'b1; 
                     end else begin 
                        buffer1[WrIndex1] <= in[0]; // x
                        WrIndex1 <= WrIndex1 + 1; 
                        current_buf <= 1'b0; 
                     end 
                  end else begin 
                     // belongs in buffer 0 
                     buffer0[WrIndex0] <= in[0]; 
                     WrIndex0 <= WrIndex0 + 3;  // Next write will be x'  
                     current_buf <= 1'b0; 
                  end
               end

               // Store in[1] @ correct buffer 
               if(counter == 5'd1 || counter == 5'd13) begin
                  if(~mode) begin 
                     if(current_buf == 1'b0) begin 
                        buffer0[WrIndex0] <= in[1]; // z
                        WrIndex0 <= WrIndex0 + 1; 
                        current_buf <= 1'b1; 
                     end else begin 
                        buffer1[WrIndex1] <= in[1]; // z
                        WrIndex1 <= WrIndex1 + 1; 
                        current_buf <= 1'b0; 
                     end 
                  end else begin 
                     // belongs in buffer 1
                     buffer1[WrIndex1] <= in[1]; 
                     WrIndex1 <= WrIndex1 + 3;  // Next write will be z'  
                     current_buf <= 1'b0; 
                  end   
               end

               // Store in[2] @ correct buffer 
               if(counter == 5'd2 || counter == 5'd14) begin
                  if(~mode) begin 
                     if(current_buf == 1'b0) begin 
                        buffer0[WrIndex0] <= in[2]; // z'
                        WrIndex0 <= WrIndex0 + 1; 
                        current_buf <= 1'b1; 
                     end else begin 
                        buffer1[WrIndex1] <= in[2]; // z'
                        WrIndex1 <= WrIndex1 + 1; 
                        current_buf <= 1'b0; 
                     end 
                  end else begin 
                     // belongs in buffer 1
                     buffer1[WrIndex1] <= in[2]; 
                     if(counter2 != 2'd3) 
                        WrIndex1 <= WrIndex1 - 2;  // Next write will be z  
                     else 
                        WrIndex1 <= WrIndex1 + 1;  // Next write will be z     
                     current_buf <= 1'b0; 
                  end
               end

               // Store in[3] @ correct buffer 
               if((counter == 5'd3 || counter == 5'd15) && mode == 1'b1) begin
                  // belongs in buffer 0
                  buffer0[WrIndex0] <= in[3]; // x' 
                  if(counter2 != 2'd3) 
                     WrIndex0 <= WrIndex0 - 2;  // Next write will be x
                  else 
                     WrIndex0 <= WrIndex0 + 1; 
                  current_buf <= 1'b0; // Next buf shoul be 0.  
               end

         end
      end
   end


   // Control RdIndex 
   always @(posedge clk) begin 

      if(reset == 1'b1 || RdStart == 1'b0) begin 
         RdIndex <= 4'd0; 
      end else begin 
         if(counter == 5'd5 || counter == 5'd13 || counter == 5'd21) begin
            RdIndex <= RdIndex + 1;              
         end
      end
   end


   // Register outputs 
   always @(posedge clk) begin 

      if(reset == 1'b1 || RdStart == 1'b0) begin 
         out0 <= 1'bz;
         out1 <= 1'bz;
         validOut <= 1'b0; 
         
      end
      else begin 
            if(counter == 5'd4 || counter == 5'd12 || counter == 5'd20) begin 
               out0 <= buffer0[RdIndex];              
               out1 <= buffer1[RdIndex]; 
               validOut <= 1'b1;   
            end
      end
   end



endmodule
