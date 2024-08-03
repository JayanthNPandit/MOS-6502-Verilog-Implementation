`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2024 06:28:39 PM
// Design Name: 
// Module Name: InstructionDecoder
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


module InstructionDecoder(
    input wire clk,
    input wire [7:0] instruction,
);
    reg [3:0] lowNibble, highNibble; // low and high half of instruction
    
    reg [7:0] instructionTable [0:15][0:15]; // 2D array for all opcodes
    
    initial begin
        // Get the low and high half of the instruction
        highNibble = instruction [7:4];
        lowNibble = instruction [3:0]; 
        
        // Initialize the lookup table with some example opcodes
        instructionTable[4'h0][4'h0] = 8'h00; // BRK
        instructionTable[4'h1][4'h0] = 8'h10; // BPL
        instructionTable[4'h2][4'h0] = 8'h20; // JSR
        instructionTable[4'h3][4'h0] = 8'h30; // BMI
        instructionTable[4'h4][4'h0] = 8'h40; // RTI
        instructionTable[4'h5][4'h0] = 8'h50; // BVC
        instructionTable[4'h6][4'h0] = 8'h60; // RTS
        instructionTable[4'h7][4'h0] = 8'h70; // BVS
        instructionTable[4'h8][4'h0] = 8'h80; // NOP
        instructionTable[4'h9][4'h0] = 8'h90; // BCC
        instructionTable[4'hA][4'h0] = 8'hA0; // LDY
        instructionTable[4'hB][4'h0] = 8'hB0; // BCS
        instructionTable[4'hC][4'h0] = 8'hC0; // CPY
        instructionTable[4'hD][4'h0] = 8'hD0; // BNE
        instructionTable[4'hE][4'h0] = 8'hE0; // CPX
        instructionTable[4'hF][4'h0] = 8'hF0; // BEQ
        
        // Continue initializing other instructions...
        instructionTable[4'h6][4'h9] = 8'h69; // ADC
        instructionTable[4'h2][4'h9] = 8'h29; // AND
        instructionTable[4'h0][4'hA] = 8'h0A; // ASL
        instructionTable[4'hB][4'h0] = 8'hB0; // BCS
        // Initialize other instructions...
        
        opcode = instructionTable[highNibble][lowNibble];
    end
    
endmodule