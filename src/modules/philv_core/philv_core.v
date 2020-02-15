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
`include "program_count_defines.h"

module philosophy_v_core(clk, rstb);

    // Data Bus Width
    parameter BUS_WIDTH = 32;
    
    // Inputs
    input wire clk, rstb;

    ///////////////////////////////////////////////////////////////////////////
    // CONTROL
    ///////////////////////////////////////////////////////////////////////////

    // Control Enable Signals
    wire _reg_wr_ena_, _pc_ena_, _ir_ena_;

    // Control Select Signals
    wire [(`ALU_FUNCT_WIDTH-1):0] _alu_funct_;
    wire _alu_src_a_select_, _alu_control_;
    wire [(`ALU_SRC_B_WIDTH-1):0] _alu_src_b_select_;


    // Main Controller
    main_controller MAIN_CONTROLLER (
        // Inputs
        .clk(clk),
        .opCode(_instr_[`INSTR_OPCODE_RANGE]),
        // Outputs
        .PCWrite(_pc_ena_),
        .IRWrite(_ir_ena_),
        .ALUOverride(_alu_control_),
        .ALUSrcA(_alu_src_a_select_),
        .ALUSrcB(_alu_src_b_select_),
        .regFileWrite(_reg_wr_ena_)
    );

    // ALU DECODER
    alu_decoder ALU_DECODER (
        .funct3(_instr_[`INSTR_FUNCT3_RANGE]),
        .funct7(_instr_[`INSTR_FUNCT7_RANGE]),
        .controlOverride(_alu_control_),
        .alu_funct(_alu_funct_)
    );

    ///////////////////////////////////////////////////////////////////////////
    // INSTRUCTION FETCH STAGE
    ///////////////////////////////////////////////////////////////////////////

    // Busses for Instruction Address
    wire [(BUS_WIDTH-1):0] _instr_addr_, _program_count_;
    
    // Busses carrying the current Instruction
    wire [(`INSTR_WIDTH-1):0] _instr_, _instr_mem_read_data_;
    

    // Program Counter
    program_counter #(.N(BUS_WIDTH)) PC_LOGIC (
        .lastCount(_ex_out_),
        .newCount(_instr_addr_)
    );


    // INSTRUCTION MEMORY
    memory #(
        .N(BUS_WIDTH),
        .LENGTH(`I_MEM_LEN),
        .WIDTH(`I_MEM_WIDTH)
    ) INSTR_MEMORY (
            
            // Inputs
            .addr(_program_count_),
            
            //Outputs
            .dout(_instr_mem_read_data_)
    );


    // INSTRUCTION FETCH REGISTER
    register #(
        .N(BUS_WIDTH),
        .NUM_VAL(2)
    ) IF_REG (
        .clk(clk),
        .rst(1'b0),

        // {PCWrite, IRWrite}
        .ena({_pc_ena_, _ir_ena_}),

        // {Current Instr Addr, Read from Instr Mem} 
        .d({_instr_addr_, _instr_mem_read_data_}),
        
        // Outputs
        .q({_program_count_, _instr_})
    );


    ///////////////////////////////////////////////////////////////////////////
    // INSTRUCTION DECODE STAGE
    ///////////////////////////////////////////////////////////////////////////

    // Busses carrying read results from REG_FILE
    wire [(BUS_WIDTH-1):0] _reg_rd0_, _reg_rd1_;
    
    // Bus carrying result from EXECUTE state register. Declared here since it
    // is the input for REG_FILE.wrData
    wire [(BUS_WIDTH-1):0] _ex_out_;

    // REGISTER_FILE
	registerFile #(.REG_WIDTH(BUS_WIDTH)) REG_FILE (	
	    // Inputs 
	    .clk(clk),
	    .rst(1'b0),
	    .rdAddr0(_instr_[`INSTR_RS1_RANGE]),
	    .rdAddr1(_instr_[`INSTR_RS2_RANGE]),
	    .wrAddr (_instr_[`INSTR_RD_RANGE]),
	    .wrData (_mem_out_),
	    .wrEna(_reg_wr_ena_),
											
        // Outputs
        .rdData0(_reg_rd0_),
        .rdData1(_reg_rd1_)
    );

    ///////////////////////////////////////////////////////////////////////////
    // EXECUTE STAGE
    ///////////////////////////////////////////////////////////////////////////

    // Busses for ALU inputs and outputs
    wire [(BUS_WIDTH-1):0] _alu_src_a_, _alu_src_b_, _alu_result_;

    // ALU_SRC_A MUX
    mux2 #(
        .BUS_WIDTH(BUS_WIDTH)
    ) ALU_SRC_A (
        .selector(_alu_src_a_select_),
        .in0(_program_count_),
        .in1(_reg_rd0_),
        .out(_alu_src_a_)
    );

    // ALU_SRC_B MUX
    mux4 #(
        .BUS_WIDTH(BUS_WIDTH)
    ) ALU_SRC_B (
        .selector(_alu_src_b_select_),
        .in00(_reg_rd1_),
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
    
    // EXECUTE_REG
    register #(.N(BUS_WIDTH)) EX_REG (
        
        // Inputs
        .clk(clk),
        .rst(1'b0),
        .ena(1'b1),
        .d(_alu_result_),
        
        //Outputs
        .q(_ex_out_)
    );

    ///////////////////////////////////////////////////////////////////////////
    // MEMORY STAGE
    ///////////////////////////////////////////////////////////////////////////

    // Bus for output of MEM_REG
    wire [(BUS_WIDTH-1):0] _mem_out_;

    // EXECUTE_REG
    register #(.N(BUS_WIDTH)) MEM_REG (
        
        // Inputs
        .clk(clk),
        .rst(1'b0),
        .ena(1'b1),
        .d(_ex_out_),
        
        //Outputs
        .q(_mem_out_)
    );

    ///////////////////////////////////////////////////////////////////////////
    // WRITEBACK STAGE
    ///////////////////////////////////////////////////////////////////////////

    // Bus for output of WB_REG
    wire [(BUS_WIDTH-1):0] _wb_out_;

    register #(.N(BUS_WIDTH)) WB_REG (

        // Inputs
        .clk(clk),
        .rst(1'b0),
        .ena(1'b1),
        .d(_mem_out_),

        // Outputs
        .q(_wb_out_)
    );

    initial begin
        // TODO: For this to work, the clk has to start low. Maybe fix with rst
        IF_REG.q[2*BUS_WIDTH-1:BUS_WIDTH] = `PC_START_ADDRESS;
    end
endmodule
