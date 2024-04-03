`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/19/2024 08:39:45 PM
// Design Name: 
// Module Name: alu
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


module alu(
    input [7:0] A,
    input [7:0] B,
    output reg [7:0] O,
    output reg Overflow,
    input [2:0] Opcode,
    input [1:0] FunctionCode,
    input Enable
    );
    
    always @ (*) begin
    // Enable line enables multiplexer output
    	if (Enable) begin
    	// If 0b000, then we are adding
    		case (Opcode)
    		4'b000: begin
    			case (FunctionCode)
    			// Function Code 0b00 indicates unsigned addition
    			3'b000: {Overflow, O} = A + B;
    			// Function Code 0b01 indicates signed addition
    			3'b001: {Overflow, O} = A + ~B + 1;
    			// Default should never happen
    			default: {Overflow, O} = 0;
    			endcase
    		end
    	// If 0b001, then we are doing logical operations.
    		4'b001: begin
    		    Overflow = 0;
    			case (FunctionCode)
    			// 0b00 is logical and
    			3'b00: O = A & B;
    			// 0b01 is logical or
    			3'b01: O = A | B;
    			// 0b10 is logical xor
    			3'b10: O = A ^ B;
    			// 0b11 is logical not 
    			3'b11: O = ~A;
    			default: O = 0;
    			endcase
    		end
    		endcase
    	end else begin
    	   O <= 0;
    	   Overflow = 0;
    	end
    end 
             
endmodule
