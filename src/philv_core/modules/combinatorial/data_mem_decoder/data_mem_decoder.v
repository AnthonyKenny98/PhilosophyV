`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2020 01:21:12 PM
// Design Name: 
// Module Name: data_mem_decoder
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

`include "opcode_defines.h"
`include "funct_defines.h"

module data_mem_decoder(in0, in1, opcode, funct3, out0, out1);

    // BUS WIDTH
    parameter N = 32;

    // Inputs
    input wire [N-1:0] in0, in1;
    input wire [`OPCODE_WIDTH-1:0] opcode;
    input wire [`FUNCT3_WIDTH-1:0] funct3;

    // Outputs
    output reg [N-1:0] out0, out1;

    always @(in0, opcode, funct3) begin
        case(opcode)
            `OPCODE_LOAD : case (funct3)
                `FUNCT3_LW : out0 = in0;
                `FUNCT3_LH : out0 = {{16{in0[31]}}, in0[31:16]}; // Sign Extended Half Word
                `FUNCT3_LB : out0 = {{24{in0[31]}}, in0[31:24]}; // Sign Extended Byte
                `FUNCT3_LHU : out0 = {{16{0}}, in0[31:16]}; // Zero Extended Half Word
                `FUNCT3_LBU : out0 = {{24{0}}, in0[31:24]}; // Zero Extended Byte
            endcase
            default : out0 = in0;
        endcase
    end

    always @(in1, opcode, funct3) begin
        case (funct3)
            `FUNCT3_SB : out1 = {{24{in1[7]}}, in1[7:0]};
            `FUNCT3_SH : out1 = {{16{in1[15]}}, in1[15:0]};
            `FUNCT3_SW : out1 = in1;
        endcase
    end

endmodule
