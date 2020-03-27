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

`include "Xedgcol_instr_defines.h"

module philosophy_v_core(clk, rstb);

    // Data Bus Width
    parameter BUS_WIDTH = 32;
    
    // Inputs
    input wire clk, rstb;

    ///////////////////////////////////////////////////////////////////////////
    // CONTROL
    ///////////////////////////////////////////////////////////////////////////

    // Control Enable Signals
    wire _reg_wr_ena_, _pc_ena_, _ir_ena_, _dmem_wr_ena_;

    wire _edgcol_wr_ena_;

    // Control Select Signals
    wire [(`ALU_FUNCT_WIDTH-1):0] _alu_funct_;
    wire _alu_src_a_select_, _alu_control_, _reg_file_src_select_, _exec_src_select_;
    wire [(`ALU_SRC_B_WIDTH-1):0] _alu_src_b_select_;

    wire _branch_;

    wire _hb_start_, _hb_done_;


    // Main Controller
    main_controller MAIN_CONTROLLER (
        // Inputs
        .clk(clk),
        .opCode(_instr_[`INSTR_OPCODE_RANGE]),
        .funct3(_instr_[`INSTR_FUNCT3_RANGE]),
        .branch(_branch_),
        .HBDone(_hb_done_),
        // Outputs
        .PCWrite(_pc_ena_),
        .IRWrite(_ir_ena_),
        .DMemWrite(_dmem_wr_ena_),
        .ALUOverride(_alu_control_),
        .regFileWriteSrc(_reg_file_src_select_),
        .ALUSrcA(_alu_src_a_select_),
        .ALUSrcB(_alu_src_b_select_),
        .regFileWrite(_reg_wr_ena_),
        .edgcolWrEna(_edgcol_wr_ena_),
        .execSrc(_exec_src_select_),
        .HBStart(_hb_start_)
    );

    ///////////////////////////////////////////////////////////////////////////
    // INSTRUCTION FETCH STAGE
    ///////////////////////////////////////////////////////////////////////////

    // Busses for Instruction Address
    wire [(BUS_WIDTH-1):0] _instr_addr_, _program_count_;
    
    // Busses carrying the current Instruction
    wire [(`INSTR_WIDTH-1):0] _instr_;
    
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
        .WIDTH(`I_MEM_WIDTH),
        .MEM_FILE(`I_MEM_FILE)
    ) INSTR_MEMORY (
            
            // Inputs
            .clk(clk),
            .rdEna(_ir_ena_),
            .rdAddr(_program_count_),
            .wrEna(1'b0),
            
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
    wire [(BUS_WIDTH-1):0] _alu_src_a_, _alu_src_b_, _alu_result_, _exec_in_;
    wire _alu_equal_;

    // Bus for output of honeybee
    wire [63:0] _collision_;

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
        .equal(_alu_equal_),
        .x(_alu_src_a_),
        .y(_alu_src_b_),
        .z(_alu_result_)
    );

    branch #(.N(BUS_WIDTH)) BRANCH (
        .aluOut(_alu_result_),
        .funct3(_instr_[`INSTR_FUNCT3_RANGE]),
        .aluEqual(_alu_equal_),
        .branch(_branch_)
    );

    mux2 #(.BUS_WIDTH(BUS_WIDTH)) EX_MUX (
        .selector(_exec_src_select_),
        .in0(_alu_result_),
        .in1(_collision_[32:0]),
        .out(_exec_in_)
    );
    
    // EXECUTE_REG
    register #(.N(BUS_WIDTH)) EX_REG (
        
        // Inputs
        .clk(clk),
        .rst(1'b0),
        .ena(1'b1),
        .d(_exec_in_),
        
        //Outputs
        .q(_ex_out_)
    );

    ///////////////////////////////////////////////////////////////////////////
    // MEMORY STAGE
    ///////////////////////////////////////////////////////////////////////////

    // Bus for output of MEM_REG
    wire [(BUS_WIDTH-1):0] _mem_out_;

    // Bus for output of data memory
    wire [(BUS_WIDTH-1):0] _data_mem_read_data_;
    wire [(BUS_WIDTH-1):0] _data_mem_out_;

    // MEMORY DECODER
    // CONTROLS SHIFTS FOR MEMORY LOADS AND STORES
    data_mem_decoder #(.N(BUS_WIDTH)) DATA_MEM_DECODER (
        .in(_data_mem_read_data_),
        .opcode(_instr_[`INSTR_OPCODE_RANGE]),
        .funct3(_instr_[`INSTR_FUNCT3_RANGE]),
        .out(_data_mem_out_)
    );

    // DATA_MEMORY
    memory #(
        .N(BUS_WIDTH),
        .LENGTH(`D_MEM_LEN),
        .WIDTH(`D_MEM_WIDTH),
        .MEM_FILE(`D_MEM_FILE)
    ) DATA_MEMORY (
        // Inputs
        .clk(clk),
        .access(_instr_[`INSTR_FUNCT3_RANGE]),
        .rdEna(1'b1),
        .rdAddr(_ex_out_),
        .wrEna(_dmem_wr_ena_),
        .wrAddr(_ex_out_),
        .wrData(_reg_rd1_),

        // Outputs
        .rdData(_data_mem_read_data_)
    );

    // MEMORY_REG
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

    mux2 #(.BUS_WIDTH(BUS_WIDTH)) REG_FILE_SRC_MUX (
        .selector(_reg_file_src_select_),
        .in0(_data_mem_out_),
        .in1(_mem_out_),
        .out(_reg_file_write_)
    );

    ///////////////////////////////////////////////////////////////////////////
    // Implement Honeybee
    ///////////////////////////////////////////////////////////////////////////

    wire [BUS_WIDTH-1:0] _e0_, _e1_, _e2_, _e3_, _e4_, _e5_;

    edgcolRegisterFile #(.REG_WIDTH(BUS_WIDTH)) EDGCOL_REGISTER_FILE (
        .clk(clk),
        .rst(1'b0),
        .wrEna(_edgcol_wr_ena_),
        .wrAddr(_instr_[`XEDGCOL_INSTR_RD_RANGE]),
        .wrData({_instr_[`XEDGCOL_INSTR_IMM_RANGE], {6{1'b0}}}), // 0 extend the LSB of imm
        .rdData0(_e0_),
        .rdData1(_e1_),
        .rdData2(_e2_),
        .rdData3(_e3_),
        .rdData4(_e4_),
        .rdData5(_e5_)
    );

    honeybee HONEYBEE (
        .ap_clk(clk),        // input wire ap_clk
        .ap_rst(1'b0),        // input wire ap_rst
        .ap_start(_hb_start_),    // input wire ap_start
        .ap_done(_hb_done_),      // output wire ap_done
        .ap_idle(),      // output wire ap_idle
        .ap_ready(),    // output wire ap_ready
        .ap_return(_collision_),  // output wire [7 : 0] ap_return
        .edge_p1_x(_e1_),  // input wire [31 : 0] edge_p1_x
        .edge_p1_y(_e1_),  // input wire [31 : 0] edge_p1_y
        .edge_p1_z(_e2_),  // input wire [31 : 0] edge_p1_z
        .edge_p2_x(_e3_),  // input wire [31 : 0] edge_p2_x
        .edge_p2_y(_e4_),  // input wire [31 : 0] edge_p2_y
        .edge_p2_z(_e5_)  // input wire [31 : 0] edge_p2_z
    );

   

    initial begin
        // TODO: For this to work, the clk has to start low. Maybe fix with rst
        IF_REG.q = `PC_START_ADDRESS;
    end
endmodule
