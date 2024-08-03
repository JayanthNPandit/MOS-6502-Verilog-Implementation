`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/20/2024 10:53:42 AM
// Design Name: 
// Module Name: RegisterFile_tb
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


module RegisterFile_tb;
    // Inputs
    reg clk;
    reg reset;
    reg [7:0] dataIn;
    reg [2:0] regSelect;
    reg load;
    
    // Outputs
    wire [7:0] dataOut;
    wire [7:0] Acc, X, Y, SP, PSR;
    wire [15:0] PC;
    
    RegisterFile rf_inst (
        .clk(clk), 
        .reset(reset), 
        .dataIn(dataIn), 
        .regSelect(regSelect), 
        .load(load), 
        .Acc(Acc), 
        .X(X), 
        .Y(Y), 
        .SP(SP), 
        .PSR(PSR), 
        .PC(PC), 
        .dataOut(dataOut)
    );
    
    always begin
        #5 clk = ~clk; // just for testing, switch clock ever 5 unit
    end
    
    // Tests
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        load = 0;
        dataIn = 8'd0;
        regSelect = 3'd0;
        #10;
        
        // Release reset
        reset = 0;
        #10;
        
        // Test 1: Check all registers after reset
        $display("Test 1: All registers should be 0 after reset");
        #10;
        /*
        assert(Acc == 8'd0);
        assert(X == 8'd0);
        assert(Y == 8'd0);
        assert(SP == 8'd0);
        assert(PSR == 8'd0);
        assert(PC == 16'd0);
        */
        
        // Test 2: Load and Read Registers Sequentially
        $display("Test 2: Load and read each register");
        load = 1;
        
        // Load into Acc
        dataIn = 8'd10;
        regSelect = 3'd0;
        #10;
        load = 0;
        #10;
        //assert(Acc == 8'd10);
        
        // Load into X
        load = 1;
        dataIn = 8'd20;
        regSelect = 3'd1;
        #10;
        load = 0;
        #10;
        //assert(X == 8'd20);
        
        // Load into Y
        load = 1;
        dataIn = 8'd30;
        regSelect = 3'd2;
        #10;
        load = 0;
        #10;
        //assert(Y == 8'd30);
        
        // Load into SP
        load = 1;
        dataIn = 8'd40;
        regSelect = 3'd3;
        #10;
        load = 0;
        #10;
        //assert(SP == 8'd40);
        
        // Load into PSR
        load = 1;
        dataIn = 8'd50;
        regSelect = 3'd6;
        #10;
        load = 0;
        #10;
        //assert(PSR == 8'd50);
        
        // Load low byte of PC
        load = 1;
        dataIn = 8'd60;
        regSelect = 3'd4;
        #10;
        load = 0;
        #10;
        //assert(PC[7:0] == 8'd60);
        
        // Load high byte of PC
        load = 1;
        dataIn = 8'd70;
        regSelect = 3'd5;
        #10;
        load = 0;
        #10;
        //assert(PC[15:8] == 8'd70);
        
        // Test 3: Load and Verify Multiple Values
        $display("Test 3: Load and verify multiple values");
        load = 1;
        
        // Load values
        dataIn = 8'd100;
        regSelect = 3'd0; // Acc
        #10;
        
        dataIn = 8'd200;
        regSelect = 3'd1; // X
        #10;
        
        dataIn = 8'd150;
        regSelect = 3'd2; // Y
        #10;
        
        dataIn = 8'd250;
        regSelect = 3'd3; // SP
        #10;
        
        dataIn = 8'd75;
        regSelect = 3'd6; // PSR
        #10;
        
        dataIn = 8'd123;
        regSelect = 3'd4; // Low byte of PC
        #10;
        
        dataIn = 8'd231;
        regSelect = 3'd5; // High byte of PC
        #10;
        
        load = 0;
        #10;
        
        // Verify values
        /*
        assert(Acc == 8'd100);
        assert(X == 8'd200);
        assert(Y == 8'd150);
        assert(SP == 8'd250);
        assert(PSR == 8'd75);
        assert(PC[7:0] == 8'd123);
        assert(PC[15:8] == 8'd231);
        */
        
        // Test 4: Register Overwriting
        $display("Test 4: Check if new values overwrite old values");
        load = 1;
        
        // Load new values
        dataIn = 8'd99;
        regSelect = 3'd0; // Acc
        #10;
        
        dataIn = 8'd88;
        regSelect = 3'd1; // X
        #10;
        
        dataIn = 8'd77;
        regSelect = 3'd2; // Y
        #10;
        
        dataIn = 8'd66;
        regSelect = 3'd3; // SP
        #10;
        
        dataIn = 8'd55;
        regSelect = 3'd6; // PSR
        #10;
        
        dataIn = 8'd44;
        regSelect = 3'd4; // Low byte of PC
        #10;
        
        dataIn = 8'd33;
        regSelect = 3'd5; // High byte of PC
        #10;
        
        load = 0;
        #10;
        
        // Verify new values
        /*
        assert(Acc == 8'd99);
        assert(X == 8'd88);
        assert(Y == 8'd77);
        assert(SP == 8'd66);
        assert(PSR == 8'd55);
        assert(PC[7:0] == 8'd44);
        assert(PC[15:8] == 8'd33);
        */
        
        // Test 5: Simultaneous Load and Read
        $display("Test 5: Check simultaneous load and read operations");
        load = 1;
        dataIn = 8'd222;
        regSelect = 3'd0; // Acc
        #10;
        
        // Read Acc after load
        load = 0;
        regSelect = 3'd0; // Acc
        #10;
        
        //assert(Acc == 8'd222);
        
        // End of test
        $finish;
    end


endmodule
