`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2025 11:21:22 PM
// Design Name: 
// Module Name: 4_to_1
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


module four_to_one(
        input logic [15:0] one,
        input logic [15:0] two,
        input logic [15:0] three,
        input logic [15:0] four,
        
        input logic [1:0] sel,
        
        output logic [15:0] q
        
    );
    always_comb
    begin
    
    q = 0;
    
    if(sel == 2'b00) q = one;
    else if(sel == 2'b01) q = two;
    else if(sel == 2'b10) q = three;
    else if(sel == 2'b11) q = four;
    
    end
    
    
    
endmodule
