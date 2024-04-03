`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2024 05:48:13 PM
// Design Name: 
// Module Name: register_file
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


module register_file(
    input [7:0] RegIn,
    input [4:0] RegInSel,
    output reg [7:0] RegS1Out,
    input [4:0] RegS1Sel,
    output reg [7:0] RegS2Out,
    input [4:0] RegS2Sel,
    input [7:0] SregIn,
    input SregEn,
    input RegEnable,
    input Clock1,
    input Clock2,
    input [15:0] PCOut,
    output SregOut,
    input StackInEnable,
    input [15:0] StackIn
    );
    
    reg [7:0] reg0 = 0;
    reg [7:0] reg1 = 0;
    reg [7:0] reg2 = 0;
    reg [7:0] reg3 = 0;
    reg [7:0] reg4 = 0;
    reg [7:0] reg5 = 0;
    reg [7:0] reg6 = 0;
    reg [7:0] reg7 = 0;
    reg [7:0] reg8 = 0;
    reg [7:0] reg9 = 0;
    reg [7:0] reg10 = 0;
    reg [7:0] reg11 = 0;
    reg [7:0] reg12 = 0;
    reg [7:0] reg13 = 0;
    reg [7:0] reg14 = 0;
    reg [7:0] reg15 = 0;
    
    reg [7:0] SL = 0;
    reg [7:0] SH = 0;
    reg [7:0] Sreg = 0;
    wire [7:0] PCL;
    wire [7:0] PCH;
    
    assign PCL = PCOut[7:0];
    assign PCH = PCOut[15:8];
    assign SregOut = Sreg;
    
    always @ (posedge Clock1 or posedge Clock2) begin
        case (RegS1Sel)
            5'b00000: RegS1Out <= reg0;
            5'b00001: RegS1Out <= reg1;
            5'b00010: RegS1Out <= reg2;
            5'b00011: RegS1Out <= reg3;
            5'b00100: RegS1Out <= reg4;
            5'b00101: RegS1Out <= reg5;
            5'b00110: RegS1Out <= reg6;
            5'b00111: RegS1Out <= reg7;
            5'b01000: RegS1Out <= reg8;
            5'b01001: RegS1Out <= reg9;
            5'b01010: RegS1Out <= reg10;
            5'b01011: RegS1Out <= reg11;
            5'b01100: RegS1Out <= reg12;
            5'b01101: RegS1Out <= reg13;
            5'b01110: RegS1Out <= reg14;
            5'b01111: RegS1Out <= reg15;
            5'b10000: RegS1Out <= SL;
            5'b10001: RegS1Out <= SH;
            5'b10010: RegS1Out <= Sreg;
            // Note that we call this PC Out because we are outputting the PC.
            5'b10011: RegS1Out <= PCL;
            5'b10100: RegS1Out <= PCH;
            
        endcase
        case (RegS2Sel)
            5'b00000: RegS2Out <= reg0;
            5'b00001: RegS2Out <= reg1;
            5'b00010: RegS2Out <= reg2;
            5'b00011: RegS2Out <= reg3;
            5'b00100: RegS2Out <= reg4;
            5'b00101: RegS2Out <= reg5;
            5'b00110: RegS2Out <= reg6;
            5'b00111: RegS2Out <= reg7;
            5'b01000: RegS2Out <= reg8;
            5'b01001: RegS2Out <= reg9;
            5'b01010: RegS2Out <= reg10;
            5'b01011: RegS2Out <= reg11;
            5'b01100: RegS2Out <= reg12;
            5'b01101: RegS2Out <= reg13;
            5'b01110: RegS2Out <= reg14;
            5'b01111: RegS2Out <= reg15;
            5'b10000: RegS2Out <= SL;
            5'b10001: RegS2Out <= SH;
            5'b10010: RegS2Out <= Sreg;
            // Note that we call this PC Out because we are outputting the PC.
            5'b10011: RegS2Out <= PCL;
            5'b10100: RegS2Out <= PCH;
        endcase
        /*
         * Once we have gotten our two registers, we are allowed to set the
         * stack. This allows us to increment the stack pointer during a call.
         * We cannot modify any other register during that clock cycle,
         * however.
         */
        if (StackInEnable) begin
            SL <= StackIn[7:0];
            SH <= StackIn[15:8];
        end else if (RegEnable) begin
            case (RegInSel)
                5'b00000: reg0 <= RegIn;
                5'b00001: reg1 <= RegIn;
                5'b00010: reg2 <= RegIn;
                5'b00011: reg3 <= RegIn;
                5'b00100: reg4 <= RegIn;
                5'b00101: reg5 <= RegIn;
                5'b00110: reg6 <= RegIn;
                5'b00111: reg7 <= RegIn;
                5'b01000: reg8 <= RegIn;
                5'b01001: reg9 <= RegIn;
                5'b01010: reg10 <= RegIn;
                5'b01011: reg11 <= RegIn;
                5'b01100: reg12 <= RegIn;
                5'b01101: reg13 <= RegIn;
                5'b01110: reg14 <= RegIn;
                5'b01111: reg15 <= RegIn;
                5'b10000: SL <= RegIn;
                5'b10001: SH <=  RegIn;
            endcase
        end
                
        if (SregEn) begin
            Sreg <= SregIn;
        end
    end
endmodule
