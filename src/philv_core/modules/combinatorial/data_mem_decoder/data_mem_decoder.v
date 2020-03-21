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

module data_mem_decoder(in, opcode, funct3, out);

    // BUS WIDTH
    parameter N = 32;

    // Inputs
    input wire [N-1:0] in;
    input wire [`OPCODE_WIDTH-1:0] opcode;
    input wire [`FUNCT3_WIDTH-1:0] funct3;

    // Outputs
    output reg [N-1:0] out;

    always @(in, opcode, funct3) begin
        case(opcode)
            `OPCODE_LOAD : case (funct3)
                `FUNCT3_LW : out = in;
                `FUNCT3_LH : out = {{16{in[15]}}, in[15:0]}; // Sign Extended Half Word
                `FUNCT3_LB : out = {{24{in[7]}}, in[7:0]}; // Sign Extended Byte
                `FUNCT3_LHU : out = {{16{0}}, in[15:0]}; // Zero Extended Half Word
                `FUNCT3_LBU : out = {{24{0}}, in[7:0]}; // Zero Extended Byte
            endcase
            default : out = in;
        endcase
    end

endmodule
