`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2024 02:09:34 AM
// Design Name: 
// Module Name: Memory_tb
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


`timescale 1ns / 1ps

module Memory_tb;

    // Testbench signals
    reg clk;
    reg [15:0] address;
    reg [7:0] dataIn;
    reg write;
    wire [7:0] dataOut;

    // Instantiate the Memory module
    Memory uut (
        .clk(clk),
        .address(address),
        .dataIn(dataIn),
        .write(write),
        .dataOut(dataOut)
    );

    // Clock generation
    always #5 clk = ~clk; // 100 MHz clock

    initial begin
        // Initialize signals
        clk = 0;
        address = 16'b0;
        dataIn = 8'b0;
        write = 0;

        // Write some data to memory
        #10;
        address = 16'h0000; dataIn = 8'hAA; write = 1;
        #10;
        address = 16'h0001; dataIn = 8'hBB; write = 1;
        #10;
        address = 16'h0002; dataIn = 8'hCC; write = 1;
        #10;
        address = 16'h0003; dataIn = 8'hDD; write = 1;
        #10;
        address = 16'h7FFF; dataIn = 8'hEE; write = 1;
        #10;
        address = 16'h8000; dataIn = 8'hFF; write = 1;
        #10;

        // Disable write
        write = 0;

        // Read back the data
        #10;
        address = 16'h0000;
        #10;
        $display("Read from 0x0000: %h", dataOut); // Expect AA
        address = 16'h0001;
        #10;
        $display("Read from 0x0001: %h", dataOut); // Expect BB
        address = 16'h0002;
        #10;
        $display("Read from 0x0002: %h", dataOut); // Expect CC
        address = 16'h0003;
        #10;
        $display("Read from 0x0003: %h", dataOut); // Expect DD
        address = 16'h7FFF;
        #10;
        $display("Read from 0x7FFF: %h", dataOut); // Expect EE
        address = 16'h8000;
        #10;
        $display("Read from 0x8000: %h", dataOut); // Expect FF

        // End simulation
        $finish;
    end

endmodule
