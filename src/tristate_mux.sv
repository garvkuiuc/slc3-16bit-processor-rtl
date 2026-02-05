`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2025 09:21:51 PM
// Design Name: 
// Module Name: tristate_mux
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


module tristate_mux(
      //input logic [3:0] tristate,
      input logic gate_pc,
      input logic gate_mar,
      input logic gate_mdr,
      input logic gate_alu,


      input logic [15:0] pc,
      input logic [15:0] mar,
      input logic [15:0] mdr,
      input logic [15:0] alu,

      
      output logic [15:0] q
    );
    
    always_comb
    
    
    
    begin   
    
    if(gate_pc == 1) q = pc;
    
    else if(gate_mdr == 1) q = mdr;
    
    else if(gate_mar == 1) q = mar;
    
    else if(gate_alu == 1) q = alu;
    
    else 
        q = 16'hx;
    end
    
endmodule
