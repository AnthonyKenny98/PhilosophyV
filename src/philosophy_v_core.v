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

`include "instr_defines.h"

module philosophy_v_core(clk, rstb, c, addr); //instr, a, b);

    // Parameter Definition
    parameter BUS_WIDTH = 32;
    
    // Inputs
    input wire clk, rstb;
    input wire [(BUS_WIDTH-1):0] addr;
    
    // Outputs
    output wire [(BUS_WIDTH-1):0] c;
    
    // Internal Wires
    wire [(`ALU_FUNCT_WIDTH-1):0] alu_funct_w;
    
    wire [(BUS_WIDTH-1):0] MemReadData;
    
    wire [(`INSTR_WIDTH-1):0] instr;
    wire [(BUS_WIDTH-1):0] a, b;
    
    assign instr = MemReadData;
    assign a = {27'b0, instr[24:20]};
    assign b = {27'b0, instr[19:15]};
    
    // ALU Decoder
    alu_decoder #(.N(BUS_WIDTH)) ALU_DECODER (
        .funct3(instr[14:12]),
        .funct7(instr[31:25]),
        .alu_funct(alu_funct_w)
    );
    
    // ALU
    alu #(.N(BUS_WIDTH)) ALU (
        .funct(alu_funct_w),
        .x(a),
        .y(b),
        .z(c)
    );

    synth_dual_port_memory #(
        .N(32),
        .I_LENGTH(1024),
        .D_LENGTH(0)) MEMORY(
            
            // Inputs
            .clk(clk),
            .rstb(rstb),
//            .wr_ena0(),
            .addr0(addr),
//            .din0(),
            
            //Outputs
            .dout0(MemReadData)
    );

    initial begin
    end
endmodule