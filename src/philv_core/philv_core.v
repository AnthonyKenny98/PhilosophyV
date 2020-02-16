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
    wire _alu_src_a_select_, _alu_control_, _reg_file_src_select_;
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
        .regFileWriteSrc(_reg_file_src_select_),
        .ALUSrcA(_alu_src_a_select_),
        .ALUSrcB(_alu_src_b_select_),
        .regFileWrite(_reg_wr_ena_)
    );

    ///////////////////////////////////////////////////////////////////////////
    // INSTRUCTION FETCH STAGE
    ///////////////////////////////////////////////////////////////////////////

    // Busses for Instruction Address
    wire [(BUS_WIDTH-1):0] _instr_addr_, _program_count_;
    
    // Busses carrying the current Instruction
    wire [(`INSTR_WIDTH-1):0] _instr_, _instr_mem_read_data_;
    
    // Bus carrying result from EXECUTE state register. Declared here since it
    // is the input for REG_FILE.wrData
    wire [(BUS_WIDTH-1):0] _ex_out_;

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
            .clk(clk),
            .rdEna(_ir_ena_),
            .rdAddr(_program_count_),
            .wrEna(1'b0),
            .wrAddr(),
            .wrData(),
            
            //Outputs
            .rdData(_instr_)
    );


    // INSTRUCTION FETCH REGISTER
    register #(.N(BUS_WIDTH)) IF_REG (
        // Inputs
        .clk(clk),
        .rst(1'b0),
        .ena(_pc_ena_),
        .d(_instr_addr_),
        
        // Outputs
        .q(_program_count_)
    );


    ///////////////////////////////////////////////////////////////////////////
    // INSTRUCTION DECODE STAGE
    ///////////////////////////////////////////////////////////////////////////

    // Busses carrying read results from REG_FILE
    wire [(BUS_WIDTH-1):0] _reg_rd0_, _reg_rd1_;

    // Bus for writeback to register file
    wire [(BUS_WIDTH-1):0] _reg_file_write_;

    // Busses carrying rs, rd and immed
    wire [`INSTR_REG_WIDTH-1:0] _rs1_, _rs2_, _rd_;
    wire [BUS_WIDTH-1:0] _extended_immed_;

    // ALU DECODER
    instr_decoder INSTR_DECODER (
        .instr(_instr_),
        .controlOverride(_alu_control_),
        .alu_funct(_alu_funct_),
        .rs1(_rs1_),
        .rs2(_rs2_),
        .rd(_rd_),
        .immed(_extended_immed_)
    );

    // REGISTER_FILE
	registerFile #(.REG_WIDTH(BUS_WIDTH)) REG_FILE (	
	    // Inputs 
	    .clk(clk),
	    .rst(1'b0),
	    .rdAddr0(_rs1_),
	    .rdAddr1(_rs2_),
	    .wrAddr (_rd_),
	    .wrData (_reg_file_write_),
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
        .in10(_extended_immed_),
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

    mux2 #(.BUS_WIDTH(BUS_WIDTH)) REG_FILE_SRC_MUX (
        .selector(_reg_file_src_select_),
        .in0(),
        .in1(_mem_out_),
        .out(_reg_file_write_)
    );

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
        IF_REG.q = `PC_START_ADDRESS;
    end
endmodule
