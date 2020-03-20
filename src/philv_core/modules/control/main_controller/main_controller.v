`timescale 1ns / 1ps
`default_nettype none //helps catch typo-related bugs
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2020 08:34:10 AM
// Design Name: 
// Module Name: main_controller
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
`include "funct_defines.h"
`include "opcode_defines.h"
`include "alu_src_defines.h"
`include "control_state_defines.h"
`include "control_signal_defines.h"

module main_controller(
	// Inputs
	clk, opCode, funct3,
	// Outputs
	PCWrite, IRWrite, DMemWrite, ALUOverride, ALUSrcA, ALUSrcB, regFileWrite, regFileWriteSrc
);

	// Input Ports
	input wire clk;
	input wire [`INSTR_OPCODE_WIDTH-1:0] opCode;
	input wire [`FUNCT3_WIDTH-1:0] funct3;

	// Output Ports
	output reg PCWrite, IRWrite, regFileWrite, DMemWrite, ALUOverride;
	output reg ALUSrcA;
	output reg [`REG_FILE_WRITE_SRC_WIDTH-1:0] regFileWriteSrc;
	output reg [`ALU_SRC_B_WIDTH-1:0] ALUSrcB;

	// Internal Reg for State Tracking
	reg [3:0] state, next_state;

	initial begin
		state = `CONTROL_STATE_FETCH;
	end

	always @(posedge clk) begin
		state <= next_state;
	end

	always @(state, opCode) begin
		case(state)

			`CONTROL_STATE_FETCH : begin
				
				// Control Signals
				PCWrite = 0;
				IRWrite = 1;
				regFileWrite = 0;
				ALUOverride = 1;
				DMemWrite = 0;

				// Select Signals
				regFileWriteSrc = `REG_FILE_WRITE_SRC_EX;
				ALUSrcA = `ALU_SRC_A_PC;
				ALUSrcB = `ALU_SRC_B_CONST4;

				// Next State
				next_state = `CONTROL_STATE_DECODE;
			end

			`CONTROL_STATE_DECODE : begin

				// Control Signals
				PCWrite = 1;
				IRWrite = 0;
				regFileWrite = 0;
				ALUOverride = 0;
				DMemWrite = 0;

				regFileWriteSrc = `REG_FILE_WRITE_SRC_EX;

				// Next State
				case (opCode) 

					`OPCODE_ALU_REG : next_state = `CONTROL_STATE_EXECUTE_R;
					`OPCODE_ALU_IMM : next_state = `CONTROL_STATE_EXECUTE_I;
					`OPCODE_LOAD	: next_state = `CONTROL_STATE_EXECUTE_I;
					`OPCODE_STORE 	: next_state = `CONTROL_STATE_EXECUTE_I;
					default: next_state = `CONTROL_STATE_EXECUTE_R;
				endcase
			end

			`CONTROL_STATE_EXECUTE_R : begin

				// Control Signals
				PCWrite = 0;
				IRWrite = 0;
				regFileWrite = 0;
				ALUOverride = 0;
				DMemWrite = 0;

				// Select Signals
				regFileWriteSrc = `REG_FILE_WRITE_SRC_EX;
				ALUSrcA = `ALU_SRC_A_REGOUT;
				ALUSrcB = `ALU_SRC_B_REGOUT;

				// Next State
				next_state = `CONTROL_STATE_MEMORY;

			end

			`CONTROL_STATE_EXECUTE_I : begin

				// Control Signals
				PCWrite = 0;
				IRWrite = 0;
				regFileWrite = 0;
				ALUOverride = 0;
				DMemWrite = 0;

				// Select Signals
				ALUSrcA = `ALU_SRC_A_REGOUT;
				ALUSrcB = `ALU_SRC_B_IMMED;

				regFileWriteSrc = `REG_FILE_WRITE_SRC_EX;

				// Next State
				case (opCode) 
					`OPCODE_STORE : next_state = `CONTROL_STATE_MEMORY_STORE;
					default : next_state = `CONTROL_STATE_MEMORY;
				endcase
			end

			`CONTROL_STATE_MEMORY : begin

				// Control Signals
				PCWrite = 0;
				IRWrite = 0;
				regFileWrite = 0;
				ALUOverride = 0;
				DMemWrite = 0;

				regFileWriteSrc = `REG_FILE_WRITE_SRC_EX;


				// Next State
				case (opCode)
					`OPCODE_LOAD : next_state = `CONTROL_STATE_WRITEBACK_MEM;
					default : next_state = `CONTROL_STATE_WRITEBACK;
				endcase
				
				
			end

			`CONTROL_STATE_MEMORY_STORE : begin

				// Control Signals
				PCWrite = 0;
				IRWrite = 0;
				regFileWrite = 0;
				ALUOverride = 0;
				DMemWrite = 1;

				regFileWriteSrc = `REG_FILE_WRITE_SRC_EX;


				// Next State
				next_state = `CONTROL_STATE_WRITEBACK;
				
				
			end

			`CONTROL_STATE_WRITEBACK : begin

				// Control Signals
				PCWrite = 0;
				IRWrite = 0;
				regFileWrite = 1;
				ALUOverride = 0;
				DMemWrite = 0;

				regFileWriteSrc = `REG_FILE_WRITE_SRC_EX;

				// Next State
				next_state = `CONTROL_STATE_FETCH;
				
			end

			`CONTROL_STATE_WRITEBACK_MEM : begin

				// Control Signals
				PCWrite = 0;
				IRWrite = 0;
				regFileWrite = 1;
				ALUOverride = 0;
				DMemWrite = 0;

				case (funct3)
					`FUNCT3_LB : regFileWriteSrc = `REG_FILE_WRITE_SRC_BYTE;
					default : regFileWriteSrc = `REG_FILE_WRITE_SRC_MEM;
				endcase


				// Next State
				next_state = `CONTROL_STATE_FETCH;
				
			end
		endcase
	end

endmodule
