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
    wire [(BUS_WIDTH-1):0] _reg_rd0_, _reg_rd1_;
    wire [(BUS_WIDTH-1):0] _alu_src_a_, _alu_src_b_, _alu_result_, _alu_out_;
    
    assign c = _alu_out_;
    
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
        .rst(1'b0),
        .ena(1'b1),
        .d(_mem_read_data_),
        
        //Outputs
        .q(_instr_)
    );

    
    // ALU DECODER
    alu_decoder ALU_DECODER (
        .funct3(_instr_[`INSTR_FUNCT3_RANGE]),
        .funct7(_instr_[`INSTR_FUNCT7_RANGE]),
        .alu_funct(_alu_funct_)
    );
    
    // REGISTER FILE
	registerFile #(.REG_WIDTH(BUS_WIDTH)) REGISTER_FILE (	
	    // Inputs 
	    .clk(clk),
	    .rst(1'b0),
	    .rdAddr0(_instr_[`INSTR_RS1_RANGE]),
	    .rdAddr1(_instr_[`INSTR_RS2_RANGE]),
	    .wrAddr (_instr_[`INSTR_RD_RANGE]),
	    .wrData (_alu_out_),
	    .wrEna(1'b1), //TODO
											
        // Outputs
        .rdData0(_reg_rd0_),
        .rdData1(_reg_rd1_)
    );
    
    // REGISTER_FILE_OUTPUT
    doubleRegister #(
        .BUS_WIDTH(BUS_WIDTH)
    ) REGISTER_FILE_OUTPUT (
        // Inputs
        .clk(clk),
        .rst(1'b0),
        .ena(1'b1),
        .dA(_reg_rd0_),
        .dB(_reg_rd1_),
        
        // Outputs
        .qA(_alu_src_a_),
        .qB(_alu_src_b_)
    ); 
    
    // ALU
    alu #(.N(BUS_WIDTH)) ALU (
        .funct(_alu_funct_),
        .x(_alu_src_a_),
        .y(_alu_src_b_),
        .z(_alu_result_)
    );
    
    // ALU_OUT_REG
    register #(.N(BUS_WIDTH)) ALU_OUT_REG (
        
        // Inputs
        .clk(clk),
        .rst(1'b0),
        .ena(1'b1),
        .d(_alu_result_),
        
        //Outputs
        .q(_alu_out_)
    );

    initial begin
    end
endmodule
