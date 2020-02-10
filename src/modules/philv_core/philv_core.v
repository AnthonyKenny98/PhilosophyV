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
    
    // Control Signals
    wire [(`ALU_FUNCT_WIDTH-1):0] _alu_funct_;
    wire [(`ALU_SRC_B_WIDTH-1):0] _alu_src_b_select_;
    wire _reg_wr_ena_;

    // Data Bus Wires
    wire [(`INSTR_WIDTH-1):0] _instr_;
    wire [(BUS_WIDTH-1):0] _mem_read_data_;
    wire [(BUS_WIDTH-1):0] _reg_rd0_, _reg_rd1_;
    wire [(BUS_WIDTH-1):0] _reg_out_1_;
    wire [(BUS_WIDTH-1):0] _alu_src_a_, _alu_src_b_;
    wire [(BUS_WIDTH-1):0] _alu_result_, _alu_out_;


    // TODO: Delete
    assign c = _alu_out_;

    ///////////////////////////////////////////////////////////////////////////
    // CONTROL UNITS
    ///////////////////////////////////////////////////////////////////////////

    // Main Controller
    main_controller MAIN_CONTROLLER (
        // Inputs
        .opCode(_instr_[`INSTR_OPCODE_RANGE]),
        // Outputs
        .ALUSrcB(_alu_src_b_select_),
        .regFileWrite(_reg_wr_ena_)
    );

    // ALU DECODER
    alu_decoder ALU_DECODER (
        .funct3(_instr_[`INSTR_FUNCT3_RANGE]),
        .funct7(_instr_[`INSTR_FUNCT7_RANGE]),
        .alu_funct(_alu_funct_)
    );

    ///////////////////////////////////////////////////////////////////////////
    // 
    ///////////////////////////////////////////////////////////////////////////


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
        
        // Outputs
        .q(_instr_)
    );


    // REGISTER_FILE
	registerFile #(.REG_WIDTH(BUS_WIDTH)) REGISTER_FILE (	
	    // Inputs 
	    .clk(clk),
	    .rst(1'b0),
	    .rdAddr0(_instr_[`INSTR_RS1_RANGE]),
	    .rdAddr1(_instr_[`INSTR_RS2_RANGE]),
	    .wrAddr (_instr_[`INSTR_RD_RANGE]),
	    .wrData (_alu_out_),
	    .wrEna(_reg_wr_ena_),
											
        // Outputs
        .rdData0(_reg_rd0_),
        .rdData1(_reg_rd1_)
    );


    // REGISTER_FILE_OUTPUT REGISTER
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
        .qB(_reg_out_1_)
    ); 


    // ALU_SRC_B MUX
    mux4 #(
        .BUS_WIDTH(BUS_WIDTH)
    ) ALU_SRC_B (
        .selector(_alu_src_b_select_),
        .in00(_reg_out_1_),
        .in01(4),
        .in10(),
        .in11(),
        .out(_alu_src_b_)
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
