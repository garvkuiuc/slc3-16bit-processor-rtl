`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2025 11:27:17 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
      input logic [1:0] aluk,
      input logic [15:0] one,
      input logic [15:0] two,
      
      output logic [15:0] q
    );
    
    
    always_comb
    begin
    
    q = 0;
    
    if(aluk==2'b00) q = one + two;
    else if(aluk==2'b01) q = one & two;
    else if(aluk==2'b10) q = ~one;
    else if(aluk==2'b11) q = one;
   
    end
endmodule
