`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2024 04:21:45 AM
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb;

    // Testbench signals
    reg clk;
    reg [7:0] A;
    reg [7:0] B;
    reg CarryBit;
    reg [3:0] op;
    reg Decimal;
    wire [7:0] Result;
    wire [7:0] PSRout;

    // Instantiate the ALU
    ALU uut (
        .clk(clk),
        .A(A),
        .B(B),
        .CarryBit(CarryBit),
        .op(op),
        .Decimal(Decimal),
        .Result(Result),
        .PSRout(PSRout)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle clock every 5 ns
    end

    // Test procedure
    initial begin
        // Test Addition with Carry (ADC)
        A = 8'h7F; B = 8'h01; CarryBit = 1'b0; op = 4'b0000; Decimal = 1'b0;
        #10; // Wait 10 ns
        $display("ADC: A=%h B=%h CarryBit=%b | Result=%h PSR=%b", A, B, CarryBit, Result, PSRout);

        // Test Subtraction with Carry (SBC)
        A = 8'h80; B = 8'h01; CarryBit = 1'b1; op = 4'b0001; Decimal = 1'b0;
        #10; // Wait 10 ns
        $display("SBC: A=%h B=%h CarryBit=%b | Result=%h PSR=%b", A, B, CarryBit, Result, PSRout);

        // Test AND
        A = 8'hAA; B = 8'h55; CarryBit = 1'b0; op = 4'b0010; Decimal = 1'b0;
        #10; // Wait 10 ns
        $display("AND: A=%h B=%h | Result=%h", A, B, Result);

        // Test OR
        A = 8'hAA; B = 8'h55; CarryBit = 1'b0; op = 4'b0011; Decimal = 1'b0;
        #10; // Wait 10 ns
        $display("OR: A=%h B=%h | Result=%h", A, B, Result);

        // Test XOR
        A = 8'hAA; B = 8'h55; CarryBit = 1'b0; op = 4'b0100; Decimal = 1'b0;
        #10; // Wait 10 ns
        $display("XOR: A=%h B=%h | Result=%h", A, B, Result);

        // Test Compare (SUB)
        A = 8'h10; B = 8'h08; CarryBit = 1'b0; op = 4'b0101; Decimal = 1'b0;
        #10; // Wait 10 ns
        $display("Compare: A=%h B=%h | Result=%h", A, B, Result);

        // Test Increment
        A = 8'h7F; CarryBit = 1'b0; op = 4'b0110; Decimal = 1'b0;
        #10; // Wait 10 ns
        $display("Increment: A=%h | Result=%h", A, Result);

        // Test Decrement
        A = 8'h80; CarryBit = 1'b0; op = 4'b0111; Decimal = 1'b0;
        #10; // Wait 10 ns
        $display("Decrement: A=%h | Result=%h", A, Result);

        // Test Arithmetic Shift Left
        A = 8'h3F; op = 4'b1000; Decimal = 1'b0;
        #10; // Wait 10 ns
        $display("ASL: A=%h | Result=%h PSRout=%b", A, Result, PSRout);

        // Test Logical Shift Right
        A = 8'h3F; op = 4'b1001; Decimal = 1'b0;
        #10; // Wait 10 ns
        $display("LSR: A=%h | Result=%h PSRout=%b", A, Result, PSRout);

        // Test Rotate Right
        A = 8'h89; op = 4'b1010; Decimal = 1'b0;
        #10; // Wait 10 ns
        $display("ROR: A=%h | Result=%h PSRout=%b", A, Result, PSRout);

        // Test Rotate Left
        A = 8'h89; op = 4'b1011; Decimal = 1'b0;
        #10; // Wait 10 ns
        $display("ROL: A=%h | Result=%h PSRout=%b", A, Result, PSRout);

        // End simulation
        $finish;
    end

endmodule
