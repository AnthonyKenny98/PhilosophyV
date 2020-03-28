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

`include "Xedgcol_instr_defines.h"
`include "Xedgcol_opcode_defines.h"

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
    wire [N-1:0] imm_extended, shamt_extended, asym_extended, j_extended, b_extended;

    // Opcode
    assign opcode = instr[`INSTR_OPCODE_RANGE];

    // Funct Codes
    assign funct3 = instr[`INSTR_FUNCT3_RANGE];
    assign funct7 = instr[`INSTR_FUNCT7_RANGE];

    // Zero and Sign Extensions
    assign shamt_extended = {{27{instr[24]}}, instr[`INSTR_SHAMT_RANGE]};
    assign imm_extended = {{20{instr[31]}}, instr[`INSTR_IMM_RANGE]};
    assign asym_extended = {{20{instr[31]}}, instr[`INSTR_FUNCT7_RANGE], instr[`INSTR_RD_RANGE]};
    // THis looks really weird, but its the sign extended immediate, arranged in order
    assign j_extended = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], {1{1'b0}}};
    assign b_extended = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], {1{1'b0}}};
    
    // Outputs
    output reg [(`ALU_FUNCT_WIDTH-1):0] alu_funct;
    output reg [(`INSTR_REG_WIDTH-1):0] rs1, rs2, rd;
    output reg [(N-1):0] immed;
    
    // Logic
    always @(*) begin
        
        // Determine ALU Funct Code
        if (controlOverride) begin
            alu_funct = `ALU_FUNCT_ADD;
        end
        else if (opcode == `OPCODE_BRANCH) begin
            case (funct3)
                `FUNCT3_BLT : alu_funct = `ALU_FUNCT_SLT;
                `FUNCT3_BGE : alu_funct = `ALU_FUNCT_SLT;
                `FUNCT3_BLTU : alu_funct = `ALU_FUNCT_SLTU;
                `FUNCT3_BGEU : alu_funct = `ALU_FUNCT_SLTU;
            endcase
        end
        else if ((opcode !== `OPCODE_ALU_IMM) && (opcode !== `OPCODE_ALU_REG)) begin
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
                    `FUNCT7_ALT1 : alu_funct = `ALU_FUNCT_SUB;
                    default : alu_funct = `ALU_FUNCT_ADD;
                endcase
                `FUNCT3_SRL : case (funct7)
                    `FUNCT7_BASE : alu_funct = `ALU_FUNCT_SRL;
                    `FUNCT7_ALT1 : alu_funct = `ALU_FUNCT_SRA;
                endcase
                default : alu_funct = `ALU_FUNCT_ADD;
            endcase
        end

        // Determine Immed output
        case (opcode)
            `OPCODE_STORE : immed = asym_extended;
            `OPCODE_LOAD : immed = imm_extended;
            `OPCODE_JALR : immed = imm_extended;
            `OPCODE_JAL : immed = j_extended;
            `OPCODE_BRANCH: immed = b_extended;
            default : case (funct3)
                `FUNCT3_SLL : immed = shamt_extended;
                `FUNCT3_SRL : immed = shamt_extended;
                default : immed = imm_extended;   
            endcase
        endcase 

    // Register outputs
        rs1 = instr[`INSTR_RS1_RANGE];
        rs2 = instr[`INSTR_RS2_RANGE];

        // Determine Reg File Write Address
        if (opcode[`XEDGCOL_INSTR_OPCODE_RANGE] == `XEDGCOL_OPCODE_ECOL && controlOverride) begin
            rd = instr[`INSTR_RS1_RANGE];
        end else begin
            rd = instr[`INSTR_RD_RANGE];
        end
    end
    
endmodule
