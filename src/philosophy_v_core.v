`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Harvard University, School of Engineering and Applied Sciences
// Engineer: Anthony JW Kenny
// 
// Create Date: 02/04/2020 11:42:31 AM
// Design Name: 
// Module Name: philosophy_v_core
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

`define INSTR_WIDTH 32

`include "alu_funct_defines.h"

module philosophy_v_core(instr, a, b, c);

    // Parameter Definition
    parameter BIT_WIDTH = 32;
    
    // Inputs
    input wire [(BIT_WIDTH-1):0] a, b;
    input wire [(`INSTR_WIDTH-1):0] instr;
    
    // Outputs
    output wire [(BIT_WIDTH-1):0] c;
    
    // Internal Wires
    wire [(`ALU_FUNCT_WIDTH-1):0] alu_funct_w;
    
    // ALU Decoder
    alu_decoder #(.N(BIT_WIDTH)) ALU_DECODER (
        .funct3(instr[14:12]),
        .funct7(instr[31:25]),
        .alu_funct(alu_funct_w)
    );
    
    // ALU
    alu #(.N(BIT_WIDTH)) ALU (
        .funct(alu_funct_w),
        .x(a),
        .y(b),
        .z(c)
    );


    initial begin
    end
endmodule
