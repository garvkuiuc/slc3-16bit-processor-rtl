`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2025 09:36:00 PM
// Design Name: 
// Module Name: two_to_one_multiplexer
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


module two_to_one_multiplexer
#(parameter width = 16)
(
    input logic [width - 1:0] one,
    input logic [width - 1:0] two,
    
    input logic sel,
    
    output logic [width - 1:0] q

    
    );
    
    
    assign q = sel ? two : one;
endmodule
