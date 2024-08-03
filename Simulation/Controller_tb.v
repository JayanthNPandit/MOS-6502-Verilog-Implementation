`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2024 04:21:45 AM
// Design Name: 
// Module Name: Controller_tb
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

module Controller_tb;

    // Testbench signals
    reg clk;
    reg reset;
    reg [15:0] inputs;
    wire [7:0] opcode;
    
    // Add signals to monitor internal state
    wire [2:0] state; // Assuming state is a 3-bit wire, adjust according to your Controller module
    wire [2:0] next; 
    
    // Instantiate the Controller
    Controller uut (
        .clk(clk),
        .reset(reset),
        .inputs(inputs),
        .opcode(opcode),
        .state(state), // Connect state to monitor
        .next(next)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle clock every 5 ns
    end

    // Test procedure
    initial begin
        // Initialize signals
        reset = 1; // Apply reset
        inputs = 16'h0000; // default
        #10; // Wait 10 ns

        reset = 0; // Release reset
        #10; // Wait 10 ns

        
        // Test case 1: Apply opcode A5
        inputs = 16'hA501;
        #10; // Wait 10 ns
        $display("Test Case 1: Inputs=%h | Opcode=%h | State=%h", inputs, opcode, state);
        
        /*
        // Test case 2: Apply opcode B3
        inputs = 16'hB300;
        #10; // Wait 10 ns
        $display("Test Case 2: Inputs=%h | Opcode=%h | State=%h", inputs, opcode, state);

        // Test case 3: Apply opcode 1F
        inputs = 16'h1F00;
        #10; // Wait 10 ns
        $display("Test Case 3: Inputs=%h | Opcode=%h | State=%h", inputs, opcode, state);

        // Test case 4: Apply opcode 3C
        inputs = 16'h3C00;
        #10; // Wait 10 ns
        $display("Test Case 4: Inputs=%h | Opcode=%h | State=%h", inputs, opcode, state);

        // Test case 5: Apply opcode 7E
        inputs = 16'h7E00;
        #10; // Wait 10 ns
        $display("Test Case 5: Inputs=%h | Opcode=%h | State=%h", inputs, opcode, state);
        
        */
        
        // End simulation
        $finish;
    end

endmodule
