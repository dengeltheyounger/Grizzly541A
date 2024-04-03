`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2024 08:25:42 PM
// Design Name: 
// Module Name: cpu
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


module cpu(
    input Reset,
    input Clock
    );
    
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] out;
    wire overflow;
    wire [2:0] opcode;
    reg [2:0] alu_opcode;
    wire [1:0] fcode;
    reg [1:0] alu_fcode;
    reg aluEnable;
    reg [15:0] pcIn;
    wire branch;
    wire [15:0] pc;
    wire [15:0] instruction;
    
    wire arithmetic;
    wire logic;
    wire call;
    wire ldi;
    wire push;
    wire ldr;
    wire [4:0] ldireg_sel;
    wire [7:0] imm;
    reg [7:0] regs1;
    reg [7:0] regs1_new_val;
    reg [7:0] regs2;
    reg [4:0] regs1_sel;
    reg [4:0] regs2_sel;
    reg [7:0] sreg_in;
    reg sreg_en;
    reg sreg_out;
    reg reg_enable;
    reg [15:0] ram_addr_in;
    wire [15:0] ram_addr_out;
    reg [7:0] ram_data_in;
    wire [7:0] ram_data_out;
    wire ram_write_enable;
    reg stack_in_enable;
    reg [15:0] stack_in;
    
    assign opcode = instruction[2:0];
    
    alu(    .A(a), 
            .B(b), 
            .O(out), 
            .Overflow(overflow), 
            .Opcode(alu_opcode), 
            .FunctionCode(alu_fcode), 
            .Enable(aluEnable)
            );
            
    instruction_fetcher(    .PCSet(pcIn),
                            .Branch(branch),
                            .Reset(Reset),
                            .Clock(Clock1),
                            .PC(pc),
                            .Instruction(instruction)
                        );
    
    instruction_decoder(    .Instruction(instruction),
                            .Clock(Clock1),
                            .Arithmetic(arithmetic),
                            .Logic(logic),
                            .Branch(branch),
                            .Call(call),
                            .Ldi(ldi),
                            .Push(push),
                            .Ldr(ldr),
                            .FunctionCode(fcode),
                            .LDIReg(ldireg_sel),
                            .Imm(imm),
                            .RegS1(regs1_sel),
                            .RegS2(regs2_sel)
                            );
                            
    register_file(  .RegIn(regs1_new_val),
                    .RegInSel(regs1_sel),
                    .RegS1Out(regs1),
                    .RegS1Sel(regs1_sel),
                    .RegS2Out(regs2),
                    .RegS2Sel(regs2_sel),
                    .SregIn(sreg_in),
                    .SregEn(sreg_en),
                    .RegEnable(reg_enable),
                    .Clock1(Clock1),
                    .Clock2(Clock2),
                    .SregOut(sreg_out),
                    .PCOut(pc),
                    .StackInEnable(stack_in_enable),
                    .StackIn(stack_in)
                    );      
                    
                    
   ram( .AddrIn(ram_addr_in),
        .AddrOut(ram_addr_out),
        .DataIn(ram_data_in),
        .DataOut(ram_data_out),
        .Clock1(Clock1),
        .Clock2(Clock2),
        .Clock3(Clock3),
        .WriteEnable(ram_write_enable)
        );
        
    clock(  
                    
    always @ (posedge Clock1 or posedge Clock2 or posedge Clock3) begin
        if (arithmetic || logic) begin
            alu_opcode = opcode;
            alu_fcode = fcode;
            aluEnable = 1;
            a <= regs1;
            b <= regs2;
            reg_enable = 1;
            regs1_new_val = out;
            sreg_en = 1;
            if (overflow) begin
                sreg_in <= sreg_out | overflow;
            end else begin
                sreg_in <= sreg_out & ~overflow;
            end
            
            if (regs1_new_val == 8'b00000000) begin
                sreg_in <= sreg_out | (1 << 1);
            end else begin
                sreg_in <= sreg_out & ~(1 << 1);
            end
        end
        
        if (branch)  begin
            case (fcode)
            // Compare operation
                2'b00: begin
                    if (regs1 == regs2) begin
                        sreg_in <= sreg_out | (1 << 1);
                        // Overflow flag doesn't make sense in this case.
                        sreg_in <= sreg_out & ~(1 << 0);
                    end
                end
            // Branch operation
                2'b01: begin
                    pcIn = {regs2,regs1};
                end
                // Branch if equal
                2'b10: begin
                    if ((sreg_out & (1 << 1))) begin
                        pcIn = {regs2,regs1};
                    end
                end
                //  Branch if overflow
                2'b11: begin
                    if ((sreg_out & (1 << 0))) begin
                        pcIn = {regs2,regs1};
                    end
                end 
            endcase
            // Since we did a branch, the status register is empty.
            sreg_en <= 1;
            sreg_in = 8'b00000000;
        end
        if (call) begin
            if (Clock1 == 1) begin
                // Increment the stack  pointer
                /*
                 * The register file has not been used yet during this call.
                 */
                regs1_sel <= 5'b10000;
                regs2_sel <= 5'b10001;
                stack_in_enable = 1;
                stack_in = {regs2,regs1} + 1;
                /*
                 * While we write to the stack, we're also going to "push" the
                 * return address to the stack. We're going to do the first 
                 * 8 bits in this clock cycle (meaning we're LSB)
                 */
                ram_addr_in = stack_in;
                ram_data_in = pc[7:0];
            end else if (Clock == 2) begin
                /*
                 * Now we're going to increment the stack pointer again and
                 * push the second 8 bits of the pc onto the stack
                 */
                 regs1_sel <= 5'b10000;
                 regs2_sel <= 5'b10001;
                 stack_in_enable = 1;
                 stack_in = {regs2,regs1} + 1;
                ram_addr_in = stack_in;
                ram_data_in = pc[15:0];
                // Now clear the status reg.
                sreg_en <= 1;
                sreg_in = 8'b00000000;
            end             
        end  
    end
endmodule
