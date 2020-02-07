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

`include "philv_core.h"
`include "instr_defines.h"
`include "alu_funct_defines.h"

module philosophy_v_core(clk, rstb, c, addr); //instr, a, b);

    // Data Bus Width
    parameter BUS_WIDTH = 32;
    
    // Inputs
    input wire clk, rstb;
    input wire [(BUS_WIDTH-1):0] addr;
    
    // Outputs
    output wire [(BUS_WIDTH-1):0] c;
    
    // Internal Wires
    wire [(`ALU_FUNCT_WIDTH-1):0] _alu_funct_;
    
    wire [(BUS_WIDTH-1):0] _mem_read_data_;
    
    wire [(`INSTR_WIDTH-1):0] _instr_;
    wire [(BUS_WIDTH-1):0] _a_, _b_;
    
    assign _instr_ = _mem_read_data_;
    assign _a_ = {27'b0, _instr_[24:20]};
    assign _b_ = {27'b0, _instr_[19:15]};
    
    // MEMORY
    synth_dual_port_memory #(
        .N(BUS_WIDTH),
        .I_LENGTH(`I_MEM_LEN),
        .D_LENGTH(`D_MEM_LEN)
    ) MEMORY (
            
            // Inputs
            .clk(clk),
            .rstb(rstb),
//            .wr_ena0(),
            .addr0(addr),
//            .din0(),
            
            //Outputs
            .dout0(_mem_read_data_)
    );
    
    // INSTRUCTION REGISTER
    register #(.N(BUS_WIDTH)) INSTR_REGISTER (
        // Inputs
        .clk(clk),
        .rst(0),
        .ena(1),
        .d(_mem_read_data_),
        //Outputs
        .q(_instr_)
    );

    
    // ALU Decoder
    alu_decoder #(.N(BUS_WIDTH)) ALU_DECODER (
        .funct3(_instr_[14:12]),
        .funct7(_instr_[31:25]),
        .alu_funct(_alu_funct_)
    );
    
    // ALU
    alu #(.N(BUS_WIDTH)) ALU (
        .funct(_alu_funct_),
        .x(_a_),
        .y(_b_),
        .z(c)
    );

    initial begin
    end
endmodule
