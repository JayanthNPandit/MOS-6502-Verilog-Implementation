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

module Controller(
    input wire clk,
    input wire reset,
    input wire [15:0] inputs,
    output reg [7:0] opcode,
    output reg [2:0] state,
    output reg [2:0] next
);

    // Define states for instruction cycle, same as LC3 instruction cycles
    localparam FETCH = 3'b000; // Fetch instruction
    localparam DECODE = 3'b001; // Decode instruction
    localparam EVALUATE = 3'b010; // Evaluate address
    localparam OPERAND = 3'b011; // Fetch operands
    localparam EXECUTE = 3'b100; // Execute instruction
    localparam STORE = 3'b101; // Store result
    localparam HALT = 3'b111; // Extra


    // EXECUTIVE DESIGNER PRIVILEGE: the first 8 bits of the inputs specify the opcode, the last 8 bits specify additional info
    reg [7:0] instruction;
    reg [7:0] extras;
    
    // Registers
    wire [7:0] regAcc;
    wire [7:0] regX;
    wire [7:0] regY;
    wire [7:0] regSP;
    wire [7:0] regPSR;
    wire [15:0] regPC;

    // Memory control signals
    reg [15:0] address;
    reg [7:0] dataWrite;
    wire [7:0] dataRead;
    reg writeEnable;

    // RegisterFile control signals
    reg resetEnable;
    reg loadEnable;
    reg [7:0] dataIn;
    wire [7:0] dataOut;
    reg [2:0] regSelect;

    // ALU control signals
    reg [7:0] Ain;
    reg [7:0] Bin;
    reg carryIn;
    reg [3:0] inOp;
    reg decimalFlag;
    wire [7:0] aluResult;
    wire [7:0] PSRout;

    RegisterFile rf (
        .clk(clk),
        .reset(resetEnable),
        .dataIn(dataIn),
        .regSelect(regSelect),
        .load(loadEnable),
        .Acc(regAcc),
        .X(regX),
        .Y(regY),
        .SP(regSP),
        .PSR(regPSR),
        .PC(regPC),
        .dataOut(dataOut)
    );

    Memory mem (
        .clk(clk),
        .address(address),
        .dataIn(dataWrite),
        .write(writeEnable),
        .dataOut(dataRead)
    );

    ALU alu (
        .clk(clk),
        .A(Ain),
        .B(Bin),
        .CarryBit(carryIn),
        .op(inOp),
        .Decimal(decimalFlag),
        .Result(aluResult),
        .PSRout(PSRout)
    );

    // State machine for controlling the instruction cycle
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= FETCH;
        end else begin
            state <= next;
        end
    end

    // Next state logic and output logic
    always @(*) begin
        // Default values
        next = state;
        instruction = inputs[15:8];
        opcode = instruction;
        extras = inputs[7:0];
        writeEnable = 1'b0;
        loadEnable = 1'b0;

        case (state)
            FETCH: begin
                // Fetch the instruction from memory
                //address = regPC;
                //regPC = regPC + 1;
                //opcode = dataRead;
                next = DECODE; // goes here at next clock cycle
            end

            DECODE: begin
                // Decode the instruction, determine addressing mode, and set up the next state
                
                // all eval instructions (some version of which requires eval): LDA, STA, ADC, SBC, AND, ORA, EOR, CMP, BIT, LDX, LDY, STX, STY
                // all others can go to fetch operand or execute
                
                case (opcode)
                    // Instructions that need the EVALUATE phase
                    8'hA5: next = EVALUATE; // LDA Zero Page
                    8'hB5: next = EVALUATE; // LDA Zero Page, X
                    8'hA6: next = EVALUATE; // LDX Zero Page
                    8'hB6: next = EVALUATE; // LDX Zero Page, Y
                    8'hA4: next = EVALUATE; // LDY Zero Page
                    8'hB4: next = EVALUATE; // LDY Zero Page, X
                    8'h85: next = EVALUATE; // STA Zero Page
                    8'h95: next = EVALUATE; // STA Zero Page, X
                    8'h86: next = EVALUATE; // STX Zero Page
                    8'h96: next = EVALUATE; // STX Zero Page, Y
                    8'h84: next = EVALUATE; // STY Zero Page
                    8'h94: next = EVALUATE; // STY Zero Page, X
                    8'h65: next = EVALUATE; // ADC Zero Page
                    8'h75: next = EVALUATE; // ADC Zero Page, X
                    8'hE5: next = EVALUATE; // SBC Zero Page
                    8'hF5: next = EVALUATE; // SBC Zero Page, X
                    8'h25: next = EVALUATE; // AND Zero Page
                    8'h35: next = EVALUATE; // AND Zero Page, X
                    8'h45: next = EVALUATE; // EOR Zero Page
                    8'h55: next = EVALUATE; // EOR Zero Page, X
                    8'hC5: next = EVALUATE; // CMP Zero Page
                    8'hD5: next = EVALUATE; // CMP Zero Page, X
                    8'hE4: next = EVALUATE; // CPX Zero Page
                    8'hC4: next = EVALUATE; // CPY Zero Page
                
                    8'hAD: next = EVALUATE; // LDA Absolute
                    8'hBD: next = EVALUATE; // LDA Absolute, X
                    8'hB9: next = EVALUATE; // LDA Absolute, Y
                    8'hCD: next = EVALUATE; // CMP Absolute
                    8'hDD: next = EVALUATE; // CMP Absolute, X
                    8'hD9: next = EVALUATE; // CMP Absolute, Y
                    8'hED: next = EVALUATE; // SBC Absolute
                    8'hFD: next = EVALUATE; // SBC Absolute, X
                    8'hF9: next = EVALUATE; // SBC Absolute, Y
                    8'h2D: next = EVALUATE; // AND Absolute
                    8'h3D: next = EVALUATE; // AND Absolute, X
                    8'h39: next = EVALUATE; // AND Absolute, Y
                    8'h4D: next = EVALUATE; // EOR Absolute
                    8'h5D: next = EVALUATE; // EOR Absolute, X
                    8'h59: next = EVALUATE; // EOR Absolute, Y
                    8'h6D: next = EVALUATE; // ADC Absolute
                    8'h7D: next = EVALUATE; // ADC Absolute, X
                    8'h79: next = EVALUATE; // ADC Absolute, Y
                    8'h8D: next = EVALUATE; // STA Absolute
                    8'h9D: next = EVALUATE; // STA Absolute, X
                    8'h99: next = EVALUATE; // STA Absolute, Y
                    8'hAD: next = EVALUATE; // LDA Absolute
                    8'hAE: next = EVALUATE; // LDX Absolute
                    8'hBE: next = EVALUATE; // LDY Absolute, X
                    8'h8E: next = EVALUATE; // STX Absolute
                    8'h8C: next = EVALUATE; // STY Absolute
                    8'hCC: next = EVALUATE; // CPX Absolute
                    8'hEC: next = EVALUATE; // CPY Absolute
                
                    8'hA1: next = EVALUATE; // LDA (Indirect, X)
                    8'h61: next = EVALUATE; // ADC (Indirect, X)
                    8'hE1: next = EVALUATE; // SBC (Indirect, X)
                    8'h21: next = EVALUATE; // AND (Indirect, X)
                    8'h41: next = EVALUATE; // EOR (Indirect, X)
                    8'h61: next = EVALUATE; // CMP (Indirect, X)
                
                    8'hB1: next = EVALUATE; // LDA (Indirect), Y
                    8'h71: next = EVALUATE; // ADC (Indirect), Y
                    8'hF1: next = EVALUATE; // SBC (Indirect), Y
                    8'h31: next = EVALUATE; // AND (Indirect), Y
                    8'h51: next = EVALUATE; // EOR (Indirect), Y
                    8'hD1: next = EVALUATE; // CMP (Indirect), Y
                
                    // Instructions that go from DECODE to FETCH_OPERANDS
                    8'hA9: next = OPERAND; // LDA Immediate
                    8'hA2: next = OPERAND; // LDX Immediate
                    8'hA0: next = OPERAND; // LDY Immediate
                    8'h69: next = OPERAND; // ADC Immediate
                    8'hE9: next = OPERAND; // SBC Immediate
                    8'h29: next = OPERAND; // AND Immediate
                    8'h09: next = OPERAND; // ORA Immediate
                    8'h49: next = OPERAND; // EOR Immediate
                    8'hC9: next = OPERAND; // CMP Immediate
                    8'hE0: next = OPERAND; // CPX Immediate
                    8'hC0: next = OPERAND; // CPY Immediate
                
                    // Instructions that go directly to EXECUTE phase
                    8'h00: next = EXECUTE; // BRK
                    8'h4C: next = EXECUTE; // JMP Absolute
                    8'h6C: next = EXECUTE; // JMP Indirect
                    8'h40: next = EXECUTE; // RTI
                    8'h60: next = EXECUTE; // RTS
                    8'h20: next = EXECUTE; // JSR Absolute
                    8'hA8: next = EXECUTE; // TAY
                    8'hAA: next = EXECUTE; // TAX
                    8'h8A: next = EXECUTE; // TXA
                    8'h9A: next = EXECUTE; // TXS
                    8'h98: next = EXECUTE; // TYA
                    8'hBA: next = EXECUTE; // TSX
                    8'h8D: next = EXECUTE; // STA Absolute
                    8'h9D: next = EXECUTE; // STA Absolute, X
                    8'h99: next = EXECUTE; // STA Absolute, Y
                
                    default: next = HALT; // Undefined instruction
                endcase

            end
            
            //eval address
            EVALUATE: begin
                // Evaluate the address to be serviced, for indirect or zpg instructions
                case (opcode)
                    8'hA5: next = OPERAND; // LDA Zero Page
                    8'hB5: next = OPERAND; // LDA Zero Page, X
                    8'hA6: next = OPERAND; // LDX Zero Page
                    8'hB6: next = OPERAND; // LDX Zero Page, Y
                    8'hA4: next = OPERAND; // LDY Zero Page
                    8'hB4: next = OPERAND; // LDY Zero Page, X
                    8'h85: next = OPERAND; // STA Zero Page
                    8'h95: next = OPERAND; // STA Zero Page, X
                    8'h86: next = OPERAND; // STX Zero Page
                    8'h96: next = OPERAND; // STX Zero Page, Y
                    8'h84: next = OPERAND; // STY Zero Page
                    8'h94: next = OPERAND; // STY Zero Page, X
                    8'h65: next = OPERAND; // ADC Zero Page
                    8'h75: next = OPERAND; // ADC Zero Page, X
                    8'hE5: next = OPERAND; // SBC Zero Page
                    8'hF5: next = OPERAND; // SBC Zero Page, X
                    8'h24: next = OPERAND; // BIT Zero Page
                    8'h2C: next = OPERAND; // BIT Absolute
                
                    // For these instructions, you can directly move to EXECUTE
                    8'hA9: next = EXECUTE; // LDA Immediate
                    8'hAD: next = EXECUTE; // LDA Absolute
                    8'hBD: next = EXECUTE; // LDA Absolute, X
                    8'hB9: next = EXECUTE; // LDA Absolute, Y
                    8'hA1: next = EXECUTE; // LDA (Indirect, X)
                    8'hB1: next = EXECUTE; // LDA (Indirect), Y
                    8'h6D: next = EXECUTE; // ADC Absolute
                    8'h7D: next = EXECUTE; // ADC Absolute, X
                    8'h79: next = EXECUTE; // ADC Absolute, Y
                    8'h61: next = EXECUTE; // ADC (Indirect, X)
                    8'h71: next = EXECUTE; // ADC (Indirect), Y
                    8'h8D: next = EXECUTE; // STA Absolute
                    8'h9D: next = EXECUTE; // STA Absolute, X
                    8'h99: next = EXECUTE; // STA Absolute, Y
                    8'h81: next = EXECUTE; // STA (Indirect, X)
                    8'h91: next = EXECUTE; // STA (Indirect), Y
                    8'h6C: next = EXECUTE; // JMP Indirect
                    8'h4C: next = EXECUTE; // JMP Absolute
                    8'h20: next = EXECUTE; // JSR Absolute
                    8'hE8: next = EXECUTE; // INX
                    8'hC8: next = EXECUTE; // INY
                    8'hCA: next = EXECUTE; // DEX
                    8'h88: next = EXECUTE; // DEY
                
                    default: next = HALT; // Undefined instruction
                endcase

            end
            
            OPERAND: begin
                // Get the necessery operands for the instruction's execution
                
                // Immediate: LDA, LDX, LDY, ADC, SBC, AND< ORA, EOR, CMP, CPX, CPY
                // ZPG: LDA, LDX, LDY, STA, STX, STY, ADC, SBC, AND, ORA, EOR, CMP, CPX, CPY
                // X/Y Indexed: LDA, LDX, LDY, STA, STX, STY, ADC, SBC, AND, ORA, EOR, CMP, CPX, CPY
                // Absolute: LDA, LDX, LDY, STA, STX, STY, ADC, SBC, AND, ORA, EOR, CMP, CPX, CPY
                // Indirect: LDA, STA, ADC, SBC, AND, ORA, EOR, CMP
                // all others go to execute
                
                case (opcode)
                    8'hA5: next = EXECUTE; // LDA Zero Page
                    8'hB5: next = EXECUTE; // LDA Zero Page, X
                    8'hA6: next = EXECUTE; // LDX Zero Page
                    8'hB6: next = EXECUTE; // LDX Zero Page, Y
                    8'hA4: next = EXECUTE; // LDY Zero Page
                    8'hB4: next = EXECUTE; // LDY Zero Page, X
                    8'h85: next = EXECUTE; // STA Zero Page
                    8'h95: next = EXECUTE; // STA Zero Page, X
                    8'h86: next = EXECUTE; // STX Zero Page
                    8'h96: next = EXECUTE; // STX Zero Page, Y
                    8'h84: next = EXECUTE; // STY Zero Page
                    8'h94: next = EXECUTE; // STY Zero Page, X
                    8'h65: next = EXECUTE; // ADC Zero Page
                    8'h75: next = EXECUTE; // ADC Zero Page, X
                    8'hE5: next = EXECUTE; // SBC Zero Page
                    8'hF5: next = EXECUTE; // SBC Zero Page, X
                    8'h24: next = EXECUTE; // BIT Zero Page
                    8'h2C: next = EXECUTE; // BIT Absolute
                
                    // In case there are more instructions with OPERAND stage (none specifically listed, but included as examples)
                    8'hA1: next = EXECUTE; // LDA (Indirect, X)
                    8'hB1: next = EXECUTE; // LDA (Indirect), Y
                    8'h61: next = EXECUTE; // ADC (Indirect, X)
                    8'h71: next = EXECUTE; // ADC (Indirect), Y
                
                    default: next = EXECUTE; // For any unexpected opcode
                endcase    
            end

            EXECUTE: begin
                // Execute the instruction
                
                // All instructions do this
                case (opcode)
                    // Instructions that need to go to STORE
                    8'h85: next = STORE; // STA Zero Page
                    8'h95: next = STORE; // STA Zero Page, X
                    8'h8D: next = STORE; // STA Absolute
                    8'h9D: next = STORE; // STA Absolute, X
                    8'h99: next = STORE; // STA Absolute, Y
                    8'h81: next = STORE; // STA (Indirect, X)
                    8'h91: next = STORE; // STA (Indirect), Y
                    8'hA2: next = STORE; // LDX Immediate (update register)
                    8'hA6: next = STORE; // LDX Zero Page
                    8'hB6: next = STORE; // LDX Zero Page, Y
                    8'hAE: next = STORE; // LDX Absolute
                    8'hBE: next = STORE; // LDX Absolute, Y
                    8'hA0: next = STORE; // LDY Immediate (update register)
                    8'hA4: next = STORE; // LDY Zero Page
                    8'hB4: next = STORE; // LDY Zero Page, X
                    8'hAC: next = STORE; // LDY Absolute
                    8'hBC: next = STORE; // LDY Absolute, X
                
                    // Instructions that go back to FETCH
                    8'h69: next = FETCH; // ADC Immediate
                    8'h65: next = FETCH; // ADC Zero Page
                    8'h75: next = FETCH; // ADC Zero Page, X
                    8'h6D: next = FETCH; // ADC Absolute
                    8'h7D: next = FETCH; // ADC Absolute, X
                    8'h79: next = FETCH; // ADC Absolute, Y
                    8'h61: next = FETCH; // ADC (Indirect, X)
                    8'h71: next = FETCH; // ADC (Indirect), Y
                    8'h29: next = FETCH; // AND Immediate
                    8'h25: next = FETCH; // AND Zero Page
                    8'h35: next = FETCH; // AND Zero Page, X
                    8'h2D: next = FETCH; // AND Absolute
                    8'h3D: next = FETCH; // AND Absolute, X
                    8'h39: next = FETCH; // AND Absolute, Y
                    8'h21: next = FETCH; // AND (Indirect, X)
                    8'h31: next = FETCH; // AND (Indirect), Y
                    8'h0A: next = FETCH; // ASL Accumulator
                    8'h06: next = FETCH; // ASL Zero Page
                    8'h16: next = FETCH; // ASL Zero Page, X
                    8'h0E: next = FETCH; // ASL Absolute
                    8'h1E: next = FETCH; // ASL Absolute, X
                    8'h90: next = FETCH; // BCC Relative
                    8'hB0: next = FETCH; // BCS Relative
                    8'hF0: next = FETCH; // BEQ Relative
                    8'hD0: next = FETCH; // BNE Relative
                    8'h80: next = FETCH; // BRA Relative (Not standard 6502, used in some variants)
                    8'hC9: next = FETCH; // CMP Immediate
                    8'hC5: next = FETCH; // CMP Zero Page
                    8'hD5: next = FETCH; // CMP Zero Page, X
                    8'hCD: next = FETCH; // CMP Absolute
                    8'hDD: next = FETCH; // CMP Absolute, X
                    8'hD9: next = FETCH; // CMP Absolute, Y
                    8'hC1: next = FETCH; // CMP (Indirect, X)
                    8'hD1: next = FETCH; // CMP (Indirect), Y
                    8'hE0: next = FETCH; // CPX Immediate
                    8'hE4: next = FETCH; // CPX Zero Page
                    8'hEC: next = FETCH; // CPX Absolute
                    8'hC0: next = FETCH; // CPY Immediate
                    8'hC4: next = FETCH; // CPY Zero Page
                    8'hCC: next = FETCH; // CPY Absolute
                    8'hE6: next = FETCH; // DEC Zero Page
                    8'hF6: next = FETCH; // DEC Zero Page, X
                    8'hCE: next = FETCH; // DEC Absolute
                    8'hDE: next = FETCH; // DEC Absolute, X
                    8'hE8: next = FETCH; // INX
                    8'hC8: next = FETCH; // INY
                    8'h4A: next = FETCH; // LSR Accumulator
                    8'h46: next = FETCH; // LSR Zero Page
                    8'h56: next = FETCH; // LSR Zero Page, X
                    8'h4E: next = FETCH; // LSR Absolute
                    8'h5E: next = FETCH; // LSR Absolute, X
                    8'h6A: next = FETCH; // ROR Accumulator
                    8'h66: next = FETCH; // ROR Zero Page
                    8'h76: next = FETCH; // ROR Zero Page, X
                    8'h6E: next = FETCH; // ROR Absolute
                    8'h7E: next = FETCH; // ROR Absolute, X
                    8'hE9: next = FETCH; // SBC Immediate
                    8'hE5: next = FETCH; // SBC Zero Page
                    8'hF5: next = FETCH; // SBC Zero Page, X
                    8'hED: next = FETCH; // SBC Absolute
                    8'hFD: next = FETCH; // SBC Absolute, X
                    8'hF9: next = FETCH; // SBC Absolute, Y
                    8'hE1: next = FETCH; // SBC (Indirect, X)
                    8'hF1: next = FETCH; // SBC (Indirect), Y
                    8'hAA: next = FETCH; // TAX
                    8'hA8: next = FETCH; // TAY
                    8'hBA: next = FETCH; // TSX
                    8'h8A: next = FETCH; // TXA
                    8'h9A: next = FETCH; // TXS
                    8'h98: next = FETCH; // TYA
                    8'h00: next = FETCH; // BRK
                    default: next = FETCH; // Default case
                endcase

            end

            STORE: begin // memory access
                // Access memory if needed to store a value
                
                // STA, STX, STY
                case (opcode)
                    // Instructions that go back to FETCH after STORE
                    8'h85: next = FETCH; // STA Zero Page
                    8'h95: next = FETCH; // STA Zero Page, X
                    8'h8D: next = FETCH; // STA Absolute
                    8'h9D: next = FETCH; // STA Absolute, X
                    8'h99: next = FETCH; // STA Absolute, Y
                    8'h81: next = FETCH; // STA (Indirect, X)
                    8'h91: next = FETCH; // STA (Indirect), Y
                    8'hA2: next = FETCH; // LDX Immediate (update register)
                    8'hA6: next = FETCH; // LDX Zero Page
                    8'hB6: next = FETCH; // LDX Zero Page, Y
                    8'hAE: next = FETCH; // LDX Absolute
                    8'hBE: next = FETCH; // LDX Absolute, Y
                    8'hA0: next = FETCH; // LDY Immediate (update register)
                    8'hA4: next = FETCH; // LDY Zero Page
                    8'hB4: next = FETCH; // LDY Zero Page, X
                    8'hAC: next = FETCH; // LDY Absolute
                    8'hBC: next = FETCH; // LDY Absolute, X
                    default: next = FETCH; // Default case
                endcase
            end

            HALT: begin
                // Halt state for undefined instructions
                next = HALT;
            end

            default: begin
                next = FETCH;
            end
        endcase
    end
endmodule
