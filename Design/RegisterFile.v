`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/20/2024 10:35:19 AM
// Design Name: 
// Module Name: RegisterFile
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

// GP Registers: X, Y
// Special Registers: Accumulator, Stack Pointer, Processor Status Register, Program Counter

module RegisterFile(
    input wire clk,
    input wire reset,
    input wire [7:0] dataIn, // Full 16 bit load to registers, will be 0 padded for normal registers
    input wire [2:0] regSelect,
    input wire load,
    output reg [7:0] Acc, X, Y, SP, PSR, // Rest are all 8 bits
    // PSR bits are mapped as: N (7), V (6), - (5), B (4), D (3), I (2), Z (1), C (0)
    output reg [15:0] PC, // Program Counter has 16 bits
    output wire [7:0] dataOut // wire for outgoing data
);
    reg [7:0] dataOutReg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin // All registers are 0
            $display("RegisterFile: resetting");
            Acc <= 8'd0;
            X <= 8'd0;
            Y <= 8'd0;
            SP <= 8'd0;
            PC <= 16'd0;
            PSR <= 8'd0;
        end 
        else if (load) begin
            case (regSelect)
                3'd0: Acc <= dataIn;        // Accumulator
                3'd1: X <= dataIn;        // X register
                3'd2: Y <= dataIn;        // Y register
                3'd3: SP <= dataIn;       // Stack Pointer
                3'd4: PC[7:0] <= dataIn;  // Program Counter (low byte)
                3'd5: PC[15:8] <= dataIn; // Program Counter (high byte)
                3'd6: PSR <= dataIn;        // Status Register 
                default: ;
            endcase
            
            dataOutReg <= dataIn;
            $display("RegisterFile: writing");
        end
        else if (!load) begin
            case(regSelect)
                3'd0: dataOutReg = Acc;      // Read Accumulator
                3'd1: dataOutReg = X;      // Read X register
                3'd2: dataOutReg = Y;      // Read Y register
                3'd3: dataOutReg = SP;     // Read Stack Pointer
                3'd4: dataOutReg = PC[7:0];// Read Program Counter (low byte)
                3'd5: dataOutReg = PC[15:8]; // Read high byte of Program Counter
                3'd6: dataOutReg = PSR;      // Read Status Register
                default: dataOutReg = 8'd0;
            endcase
            $display("RegisterFile: reading");
        end             
    end
    
    assign dataOut = dataOutReg;

endmodule
