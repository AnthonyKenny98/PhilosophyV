`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2020 11:30:15 AM
// Design Name: 
// Module Name: instr_decoder
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


`include "alu_funct_defines.h"
`include "funct_defines.h"
`include "instr_defines.h"
`include "opcode_defines.h"

module instr_decoder(instr, controlOverride, alu_funct, rs1, rs2, rd, immed);
    
    // Bus Width
    parameter N = 32;

    // Inputs
    input wire [(`INSTR_WIDTH-1):0] instr;
    input wire controlOverride;

    // Wires used to split instruction
    wire [(`INSTR_OPCODE_WIDTH-1):0] opcode;
    wire [(`FUNCT3_WIDTH-1):0] funct3;
    wire [(`FUNCT7_WIDTH-1):0] funct7;
    wire [N-1:0] imm_extended, shamt_extende, asym_extended;

    // Opcode
    assign opcode = instr[`INSTR_OPCODE_RANGE];

    // Funct Codes
    assign funct3 = instr[`INSTR_FUNCT3_RANGE];
    assign funct7 = instr[`INSTR_FUNCT7_RANGE];

    // Zero and Sign Extensions
    assign shamt_extended = {{27{instr[24]}}, instr[`INSTR_SHAMT_RANGE]};
    assign imm_extended = {{20{instr[31]}}, instr[`INSTR_IMM_RANGE]};
    assign asym_extended = {{20{instr[31]}}, instr[`INSTR_FUNCT7_RANGE], instr[`INSTR_RD_RANGE]};
    
    // Outputs
    output reg [(`ALU_FUNCT_WIDTH-1):0] alu_funct;
    output reg [(`INSTR_REG_WIDTH-1):0] rs1, rs2, rd;
    output reg [(N-1):0] immed;
    
    // Sequential Logic
    always @(*) begin
        
        // Determine ALU Funct Code
        if (controlOverride || ((opcode !== `OPCODE_ALU_IMM) && (opcode !== `OPCODE_ALU_REG))) begin
            alu_funct = `ALU_FUNCT_ADD;
        end
        else begin
            case (funct3)
                `FUNCT3_AND : alu_funct = `ALU_FUNCT_AND;
                `FUNCT3_OR  : alu_funct = `ALU_FUNCT_OR;
                `FUNCT3_XOR : alu_funct = `ALU_FUNCT_XOR;
                `FUNCT3_SLT : alu_funct = `ALU_FUNCT_SLT;
                `FUNCT3_SLL : alu_funct = `ALU_FUNCT_SLL;
                `FUNCT3_SLTU: alu_funct = `ALU_FUNCT_SLTU;
                `FUNCT3_ADD : case (funct7)
                    `FUNCT7_BASE : alu_funct = `ALU_FUNCT_ADD;
                    `FUNCT7_ALT1 : alu_funct = `ALU_FUNCT_SUB;
                endcase
                `FUNCT3_SRL : case (funct7)
                    `FUNCT7_BASE : alu_funct = `ALU_FUNCT_SRL;
                    `FUNCT7_ALT1 : alu_funct = `ALU_FUNCT_SRA;
                endcase
                default : alu_funct = `ALU_FUNCT_ADD;
            endcase
        end

        // Determine Immed output
        if (opcode === `OPCODE_STORE) begin
            immed = asym_extended;
        end
        else begin 
            case (funct3)
                `FUNCT3_SLL : immed = shamt_extended;
                `FUNCT3_SRL : immed = shamt_extended;
                default : immed = imm_extended;   
            endcase
        end 

    // Register outputs
        rs1 = instr[`INSTR_RS1_RANGE];
        rs2 = instr[`INSTR_RS2_RANGE];
        rd = instr[`INSTR_RD_RANGE];
    end
    
endmodule
