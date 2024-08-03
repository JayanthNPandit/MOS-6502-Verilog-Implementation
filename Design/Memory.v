`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/20/2024 04:10:26 PM
// Design Name: 
// Module Name: Memory
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


module Memory(
    input wire clk, // clock
    input wire [15:0] address, // address in memroy
    input wire [7:0] dataIn, // 8 bit data load
    input wire write, // write enable
    output reg [7:0] dataOut // 8 bit data read
);

    reg [7:0] memory [0:65535]; // 8 bit locations x 2^16 locations so ranging from 0x0000 to 0xFFFF
    
    // MOS-6502 Memory Map:
    // x0000 - x00FF    Zero Page RAM (256 bytes)
    // x0100 - x01FF    Stack (256 bytes)
    // x0200 - x7FFF    General Purpose RAM
    // x8000 - xFFFF    ROM (Program Code)
    
    always @(posedge clk) begin
        if (write) begin
            memory[address] <= dataIn; // wrote
            $display("Memory: writing");
        end
        dataOut <= memory[address]; // default read
        $display("Memory: standard read");
    end
    
endmodule
