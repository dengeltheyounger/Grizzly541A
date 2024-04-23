`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2024 09:13:08 PM
// Design Name: 
// Module Name: clock
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


module clock(
    input Cin,
    input Reset,
    input Advance,
    output reg C1_Out,
    output reg C2_Out,
    output reg C3_Out
    );
    
    reg [1:0] count;
    
    initial begin
        count = 2'b00;
    end
    
    always @ (posedge Cin) begin
        if (Reset == 1)  begin
            count <= 2'b00;
            C1_Out <= 1;
            C2_Out <= 0;
            C3_Out <= 0;
        end else if (Advance) begin
            case (count)
                2'b00: begin
                    C1_Out <= 0;
                    C2_Out <= 1;
                    C3_Out <= 0;
                    count <= count + 1;
                end
                2'b01: begin
                    C1_Out <= 0;
                    C2_Out <= 0;
                    C3_Out <= 1;
                    count <= count + 1;
                end
                2'b10: begin
                    C1_Out <= 1;
                    C2_Out <= 0;
                    C3_Out <= 0;
                    count <= 0;
                end
                default: begin
                    C1_Out <= 1;
                    C2_Out <= 0;
                    C3_Out <= 0;
                    count <= 0;
		end
            endcase
        end else begin
            C1_Out <= 1;
            C2_Out <= 1;
            C3_Out <= 1;
            count <= 0;
        end
    end
               
endmodule
