`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2024 05:48:13 PM
// Design Name: 
// Module Name: instruction_decoder
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


module instruction_decoder(
    input [15:0] Instruction,
    input Clock,
    output reg Arithmetic,
    output reg Logic,
    output reg Branch,
    output reg Call,
    output reg Ldi,
    output reg Push,
    output reg Ldr,
    output reg [1:0] FunctionCode,
    output reg [4:0] LDIReg,
    output reg [7:0] Imm,
    // These refer to the select lines
    output reg [4:0] RegS1,
    output reg [4:0] RegS2
    );
    
    always @ (*) begin

        case (Instruction[2:0])
        3'b000: Arithmetic = 1;
        3'b001: Logic = 1;
        3'b010: Branch = 1;
        3'b011: Call = 1;
        3'b101: Ldi = 1;
        3'b100: Push = 1;
        3'b111: Ldr = 1; 
        endcase
        FunctionCode = Instruction[4:3];
        LDIReg = Instruction[7:3];
        Imm = Instruction[15:8];
        RegS1 = Instruction[9:5];
        RegS2 = Instruction[14:10];
    end
        
endmodule
