
module rsc(clk, in, x_out, z_out, rst_N, mode, mode_out, valid_out);

   input    clk, in, rst_N, mode;
   output x_out, z_out, mode_out, valid_out;

   wire   clk, in, rst_N, mode;         // 1-bit wide
   reg   x_out, z_out, valid_out, mode_out;       // 1-bit wide

   reg IN, d1, d2, d3; 
   reg n1, n2, n3, n4; 

   always @(posedge clk) begin 

      if(rst_N == 1'b0) begin 
         d1 <= 1'b0; 
         d2 <= 1'b0; 
         d3 <= 1'b0; 
         IN <= 1'b0; 
      end
      else begin  
         d3 <= d2; 
         d2 <= d1; 
         d1 <= n1; 
         IN <= in;    
      end

      valid_out <= rst_N; 
      mode_out <= mode; 

   end

   always @(*) begin 

      n4 = d2 + d3;
      if(mode == 1'b0)          
         n1 = IN + n4;
      else 
         n1 = n4 + n4;

      n2 = d1 + n1; 
      n3 = d3 + n2;  
      


      if(mode == 1'b0) 
         x_out = IN; 
      else 
         x_out = n4; 
    
      z_out = n3; 
      
   end

endmodule 
