`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2025 09:18:53 PM
// Design Name: 
// Module Name: ben
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ben(
        input logic [15:0] bus,
        input logic [15:0] ir,
        input logic        ld_cc,
        input logic        clk,
        input logic        reset,
        
        
        
        output logic       branch

    );
    
    
    logic n,z,p;
    logic N,Z,P;
    
    always_ff @(posedge clk)
     begin
        if(reset)
        begin
            //branch<=1'b0;
            n <= 1'b0;
            z <= 1'b0;
            p <= 1'b0;        
        end
        if(ld_cc) 
        begin
            n <= N;       
            z <= Z;      
            p <= P; 
        end
        
    end
    
    always_comb
    begin
//         branch = 1'b0;
   
//         if(ir[15:12] == 4'b0000)
//         begin
//            branch = ((ir[11] & n) | (ir[10] & z) | (ir[9] & p));
//         end
         N = 1'b0;
         Z = 1'b0;
         P = 1'b0;
         
         if(bus[15] == 1'b1) 
         begin
            N = 1'b1;
            Z = 1'b0;
            P = 1'b0;
         end   
          
         else if (bus == 16'h0000) 
         begin
            N = 1'b0;
            Z = 1'b1;
            P = 1'b0;     
         end
         
         else if ((bus[15] == 1'b0) & (bus != 16'b0)) 
         begin
            N = 1'b0;
            Z = 1'b0;
            P = 1'b1; 
         end
    
    
        
    
    
    
    
    
    
       /* branch = 1'b0;
        if(ir[15:12] == 4'b0000)
            if(ir[11] == 1)
                if(n)
                    branch = 1'b1;
            if(ir[10] == 1'b1)
                if(z)
                    branch = 1'b1;
            if(ir[9] == 1)
                if(p)
                    branch = 1'b1;
        else
            branch = 1'b0;*/
              
              
    end
              
              
          
   assign branch = ((ir[11] & n) | (ir[10] & z) | (ir[9] & p)); 
    
    
endmodule




