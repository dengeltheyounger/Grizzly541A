`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2024 02:38:41 PM
// Design Name: 
// Module Name: ram
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


module ram(
    input [15:0] AddrIn,
    input [15:0] AddrOut,
    input Clock1,
    input Clock2,
    input Clock3,
    input [7:0] DataIn,
    output reg [7:0] DataOut,
    input WriteEnable
    );
    
    reg [7:0] mem[65535:0];
    
    always @ (posedge Clock1 or posedge Clock2 or posedge Clock3) begin
        DataOut = mem[AddrOut];
        
        if (WriteEnable) begin
            mem[AddrIn] = DataIn;
        end
    end
endmodule
