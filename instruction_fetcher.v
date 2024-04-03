`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2024 05:48:13 PM
// Design Name: 
// Module Name: instruction__fetcher
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

module instruction_fetcher(
    input [15:0] PCSet,
    input Branch,
    input Reset,
    input Clock,
    output [15:0] PC,
    output [15:0] Instruction
    );
    
    reg [15:0] pc = 0;
    assign PC = pc;
    rom Rom(pc, Instruction);
    
    always @ (posedge Clock) begin
        if  (Reset) begin
            pc <= 0;
        end
        if (Branch == 0) begin
            pc <= pc + 1;
        end else begin
            pc <= PCSet;
        end
    end
endmodule
