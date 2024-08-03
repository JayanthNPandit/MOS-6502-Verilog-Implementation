`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2024 02:22:25 AM
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
    input wire clk,
    input wire [7:0] A,         // Operand A, not a specific register, just some value inputted
    input wire [7:0] B,         // Operand B
    input wire CarryBit,        // Current carry bit
    input wire [3:0] op,        // Operation code
    input wire Decimal,         // Input Decimal flag
    output reg [7:0] Result,    // Result of the operation
    output reg [7:0] PSRout    // N (7), V (6), - (5), B (4), D (3), I (2), Z (1), C (0)
);
    reg [8:0] tempResult; // 9 bit reg for intermediary checks
    reg carryIn, carryOut; // carry in and out registers

    always @(posedge clk) begin
        // Initialize flags
        //          NV-BDIZC
        PSRout = 8'b00000000; // Initialize to 0
        PSRout[3] = Decimal; // Set decimal status bit
        
        $display("ALU: starting");

        case (op)
            4'b0000: begin // Add with carry (ADC)
                tempResult = A + B + CarryBit; // Use CarryBit directly for ADC
                Result = tempResult[7:0];
                PSRout[6] = (A[7] == B[7]) && (Result[7] != A[7]); // Overflow condition
                PSRout[0] = tempResult[8]; // Carry out bit
                $display("ALU: ADC done");
            end
            4'b0001: begin // Subtract with carry (SBC)
                tempResult = A - B - (1 - CarryBit); // Use CarryBit directly for SBC
                Result = tempResult[7:0];
                PSRout[6] = (A[7] != B[7]) && (Result[7] != A[7]); // Overflow condition
                PSRout[0] = ~tempResult[8]; // Carry in bit
                $display("ALU: SBC done");
            end
            4'b0010: begin // AND
                Result = A & B;
                $display("ALU: AND done");
            end
            4'b0011: begin // OR
                Result = A | B;
                $display("ALU: OR done");
            end
            4'b0100: begin // XOR
                Result = A ^ B;
                $display("ALU: XOR done");
            end
            4'b0101: begin // Compare (CMP)
                Result = A - B;
                $display("ALU: CMP done");
            end
            4'b0110: begin // Increment (INC)
                Result = A + 1;
                $display("ALU: INC done");
            end
            4'b0111: begin // Decrement (DEC)
                Result = A - 1;
                $display("ALU: DEC done");
            end
            4'b1000: begin // Arithmetic Shift Left (ASL)
                Result = A << 1;
                PSRout[0] = A[7]; // Capture bit that falls off (bit 7)
                $display("ALU: ASL done");
            end
            4'b1001: begin // Logical Shift Right (LSR)
                Result = A >> 1;
                PSRout[0] = A[0]; // Capture bit that falls off (bit 0)
                $display("ALU: LSR done");
            end
            4'b1010: begin // Rotate Right (ROR)
                Result = (A >> 1) | (A << 7);
                PSRout[0] = A[0]; // Capture bit that falls off (bit 0)
                $display("ALU: ROR done");
            end
            4'b1011: begin // Rotate Left (ROL)
                Result = (A << 1) | (A >> 7);
                PSRout[0] = A[7]; // Capture bit that falls off (bit 7)
                $display("ALU: ROL done");
            end
            default: begin
                Result = 8'b0; // Default case
            end
        endcase


        // Set flags
        PSRout[1] = (Result == 8'b0);
        PSRout[7] = Result[7];
        $display("ALU: Flag setting"); 
        
    end

endmodule

