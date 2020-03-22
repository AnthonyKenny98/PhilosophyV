`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2020 05:43:50 PM
// Design Name: 
// Module Name: branch
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

`include "instr_defines.h"
`include "funct_defines.h"

module branch(aluOut, aluEqual, funct3, branch);

    // BUS WIDTH
    parameter N = 32;

    // Inputs
    input wire [N-1:0] aluOut;
    input wire aluEqual;
    input wire [`INSTR_FUNCT3_WIDTH-1:0] funct3;

    // Outputs
    output reg branch;


    always @(*) begin
        case (funct3)
            `FUNCT3_BEQ : branch = aluEqual;
            `FUNCT3_BNE : branch = ~aluEqual;
            `FUNCT3_BLT : branch = aluOut == 32'b1;
            `FUNCT3_BGE : branch = aluOut == 32'b0;
            `FUNCT3_BLTU : branch = aluOut == 32'b1;
            `FUNCT3_BGEU : branch = aluOut == 32'b0;
            default : branch = 0;
        endcase
    end
endmodule
