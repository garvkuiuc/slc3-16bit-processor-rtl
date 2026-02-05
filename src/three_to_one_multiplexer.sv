`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2025 09:43:25 PM
// Design Name: 
// Module Name: three_to_one_multiplexer
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


module three_to_one_multiplexer(
        input logic [1:0] sel,
        
        input logic [15:0] one,
        input logic [15:0] two,
        input logic [15:0] three,
        output logic [15:0] q

    );
    
    always_comb 
    
    begin
    
        case(sel)
            2'b00 : q = one;
            2'b01 : q = two;
            2'b10 : q = three;
            default : q = 0;
          endcase            
    end
endmodule
