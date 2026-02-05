`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2025 11:32:54 PM
// Design Name: 
// Module Name: reg
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


module register(
      input logic [15:0] din,
      input logic [2:0] dr,
      input logic ld_reg,
      input logic [2:0] sr1,
      input logic [2:0] sr2,
      input logic       clk,
      input logic       reset,      
      output logic [15:0] sr1_out,
      output logic [15:0] sr2_out
      
    );
    
     
    logic [15:0] r00, r11, r22, r33, r44, r55, r66, r77;    
    logic ld_r0, ld_r1, ld_r2, ld_r3, ld_r4, ld_r5, ld_r6, ld_r7;
    
    
    
    always_comb 
    begin
    ld_r0 = 0;
    ld_r1 = 0;
    ld_r2 = 0;
    ld_r3 = 0;
    ld_r4 = 0;
    ld_r5 = 0;
    ld_r6 = 0;
    ld_r7 = 0;

    if(ld_reg)
        begin
        if(dr == 3'b000) ld_r0 = 1;
        else if(dr == 3'b001) ld_r1 = 1;
        else if(dr == 3'b010) ld_r2 = 1;
        else if(dr == 3'b011) ld_r3 = 1;
        else if(dr == 3'b100) ld_r4 = 1;
        else if(dr == 3'b101) ld_r5 = 1;
        else if(dr == 3'b110) ld_r6 = 1;
        else if(dr == 3'b111) ld_r7 = 1;
        
        end
    end
    
    
    
    always_comb 
    begin
        unique case(sr1)
            3'b000: sr1_out = r00;
            3'b001: sr1_out = r11;
            3'b010: sr1_out = r22;
            3'b011: sr1_out = r33;
            3'b100: sr1_out = r44;
            3'b101: sr1_out = r55;
            3'b110: sr1_out = r66;
            3'b111: sr1_out = r77;
           // default: sr1_out = 16'b0;
        endcase
    end

    always_comb 
    begin
        unique case(sr2)
            3'b000: sr2_out = r00;
            3'b001: sr2_out = r11;
            3'b010: sr2_out = r22;
            3'b011: sr2_out = r33;
            3'b100: sr2_out = r44;
            3'b101: sr2_out = r55;
            3'b110: sr2_out = r66;
            3'b111: sr2_out = r77;
          //  default: sr2_out = 16'b0;
        endcase
    end


    
    load_reg #(.DATA_WIDTH(16)) r0 (
    .clk(clk),
    .reset(reset),

    .load(ld_r0),
    .data_i(din),

    .data_q(r00)
    );  
    
    load_reg #(.DATA_WIDTH(16)) r1 (
    .clk(clk),
    .reset(reset),

    .load(ld_r1),
    .data_i(din),

    .data_q(r11)
    );
    
    
    load_reg #(.DATA_WIDTH(16)) r2 (
    .clk(clk),
    .reset(reset),

    .load(ld_r2),
    .data_i(din),

    .data_q(r22)
    );
    
    load_reg #(.DATA_WIDTH(16)) r3 (
    .clk(clk),
    .reset(reset),

    .load(ld_r3),
    .data_i(din),

    .data_q(r33)
    );

load_reg #(.DATA_WIDTH(16)) r4 (
    .clk(clk),
    .reset(reset),

    .load(ld_r4),
    .data_i(din),

    .data_q(r44)
    );

load_reg #(.DATA_WIDTH(16)) r5 (
    .clk(clk),
    .reset(reset),

    .load(ld_r5),
    .data_i(din),

    .data_q(r55)
    );

load_reg #(.DATA_WIDTH(16)) r6 (
    .clk(clk),
    .reset(reset),

    .load(ld_r6),
    .data_i(din),

    .data_q(r66)
    );

load_reg #(.DATA_WIDTH(16)) r7 (
    .clk(clk),
    .reset(reset),

    .load(ld_r7),
    .data_i(din),

    .data_q(r77)
    );


endmodule
