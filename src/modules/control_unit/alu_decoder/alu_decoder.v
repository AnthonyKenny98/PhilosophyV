`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2020 11:30:15 AM
// Design Name: 
// Module Name: alu_decoder
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

module alu_decoder(funct3, funct7, alu_funct);
    
    // Inputs
    input wire [(`FUNCT3_WIDTH-1):0] funct3;
    input wire [(`FUNCT7_WIDTH-1):0] funct7;
    
    // Outputs
    output reg [(`ALU_FUNCT_WIDTH-1):0] alu_funct;
    
    always @(*) begin
        case (funct3)
            `FUNCT3_AND : alu_funct = `ALU_FUNCT_AND;
            `FUNCT3_OR  : alu_funct = `ALU_FUNCT_OR;
            `FUNCT3_XOR : alu_funct = `ALU_FUNCT_XOR;
            `FUNCT3_SLT : alu_funct = `ALU_FUNCT_SLT;
            `FUNCT3_SLL : alu_funct = `ALU_FUNCT_SLL;
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
    
endmodule
