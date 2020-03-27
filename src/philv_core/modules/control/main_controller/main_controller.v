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

`include "Xedgcol_instr_defines.h"
`include "Xedgcol_opcode_defines.h"

module main_controller(
	// Inputs
	clk, opCode, funct3, branch, HBDone,
	// Outputs
	PCWrite, IRWrite, DMemWrite, ALUOverride, ALUSrcA, ALUSrcB,
	regFileWrite, regFileWriteSrc, edgcolWrEna, execSrc, HBStart
);

	// Input Ports
	input wire clk;
	input wire branch;
	input wire HBDone;
	input wire [`INSTR_OPCODE_WIDTH-1:0] opCode;
	input wire [`FUNCT3_WIDTH-1:0] funct3;

	// Output Ports
	output reg PCWrite, IRWrite, regFileWrite, DMemWrite, ALUOverride, edgcolWrEna;
	output reg ALUSrcA, regFileWriteSrc, execSrc;
	output reg [`ALU_SRC_B_WIDTH-1:0] ALUSrcB;
	output reg HBStart;

	// Internal Reg for State Tracking
	reg [3:0] state, next_state;

	initial begin
		state = `CONTROL_STATE_FETCH;
	end

	always @(posedge clk) begin
		state <= next_state;
	end

	always @(state, opCode, HBDone) begin
		case(state)

			`CONTROL_STATE_FETCH : begin
				
				// Control Signals
				PCWrite = 0;
				IRWrite = 1;
				regFileWrite = 0;
				ALUOverride = 0;
				DMemWrite = 0;
				edgcolWrEna = 0;
				
				// 
				execSrc = 0;
				HBStart = 0;


				// Select Signals
				regFileWriteSrc = `REG_FILE_WRITE_SRC_EX;

				// Next State
				next_state = `CONTROL_STATE_DECODE;
			end

			`CONTROL_STATE_DECODE : begin

				// Control Signals
				PCWrite = 0;
				IRWrite = 0;
				regFileWrite = 0;
				ALUOverride = 0;
				DMemWrite = 0;
				edgcolWrEna = 0;
				execSrc = 0;
				HBStart = 0;

				regFileWriteSrc = `REG_FILE_WRITE_SRC_EX;

				case (opCode[`XEDGCOL_INSTR_OPCODE_RANGE])
					`XEDGCOL_OPCODE_LI : edgcolWrEna = 1;
					`XEDGCOL_OPCODE_ECOL : HBStart = 1;
				endcase

				// Next State
				next_state = `CONTROL_STATE_EXECUTE;
			end

			`CONTROL_STATE_EXECUTE : begin

				// Control Signals
				PCWrite = 0;
				IRWrite = 0;
				regFileWrite = 0;
				ALUOverride = 0;
				DMemWrite = 0;
				edgcolWrEna = 0;
				execSrc = 0;
				HBStart = 0;

				// Select Signals
				regFileWriteSrc = `REG_FILE_WRITE_SRC_EX;

				case (opCode)
					`OPCODE_ALU_REG : begin
						ALUSrcA = `ALU_SRC_A_REGOUT;
						ALUSrcB = `ALU_SRC_B_REGOUT;
					end
					`OPCODE_JALR : begin
						ALUSrcA = `ALU_SRC_A_PC;
						ALUSrcB = `ALU_SRC_B_CONST4;
					end
					`OPCODE_JAL : begin
						ALUSrcA = `ALU_SRC_A_PC;
						ALUSrcB = `ALU_SRC_B_CONST4;
					end
					`OPCODE_BRANCH : begin
						ALUSrcA = `ALU_SRC_A_REGOUT;
						ALUSrcB = `ALU_SRC_B_REGOUT;
					end
					default : begin
						ALUSrcA = `ALU_SRC_A_REGOUT;
						ALUSrcB = `ALU_SRC_B_IMMED;
					end
				endcase

				if (opCode[`XEDGCOL_INSTR_OPCODE_RANGE] == `XEDGCOL_OPCODE_ECOL) begin
					execSrc = 1;
					case (HBDone) 
						1'b0 : next_state = state;
						1'b1 : next_state = `CONTROL_STATE_MEMORY;
					endcase
				end else begin
					next_state = `CONTROL_STATE_MEMORY;
				end
			end

			`CONTROL_STATE_MEMORY : begin

				// Control Signals
				PCWrite = 0;
				IRWrite = 0;
				regFileWrite = 0;
				ALUOverride = 1;
				edgcolWrEna = 0;
				execSrc = 0;
				HBStart = 0;

				// Calculate next address
				case (opCode)
					`OPCODE_JALR : begin
						ALUSrcA = `ALU_SRC_A_REGOUT;
						ALUSrcB = `ALU_SRC_B_IMMED;
					end
					`OPCODE_JAL : begin
						ALUSrcA = `ALU_SRC_A_PC;
						ALUSrcB = `ALU_SRC_B_IMMED;
					end
					`OPCODE_BRANCH : begin
						ALUSrcA = `ALU_SRC_A_PC;
						if (branch) begin
							ALUSrcB = `ALU_SRC_B_IMMED;
						end else begin
							ALUSrcB = `ALU_SRC_B_CONST4;
						end
					end
					default: begin
						ALUSrcA = `ALU_SRC_A_PC;
						ALUSrcB = `ALU_SRC_B_CONST4;
					end
				endcase
				
				case (opCode) 
					`OPCODE_STORE : DMemWrite = 1;
					default : DMemWrite = 0;
				endcase

				regFileWriteSrc = `REG_FILE_WRITE_SRC_EX;


				// Next State
				next_state = `CONTROL_STATE_WRITEBACK;	
			end

			`CONTROL_STATE_WRITEBACK : begin

				// Control Signals
				PCWrite = 1;
				IRWrite = 0;
				ALUOverride = 0;
				DMemWrite = 0;
				edgcolWrEna = 0;
				execSrc = 0;
				HBStart = 0;

				if (opCode[`XEDGCOL_INSTR_OPCODE_RANGE] == `XEDGCOL_OPCODE_LI) begin // Clean up - this is the prefix for Xedgcol
					regFileWrite = 0;
				end else begin
					case (opCode)
						`OPCODE_STORE : regFileWrite = 0;
						`OPCODE_BRANCH : regFileWrite = 0;
						`OPCODE_LOAD : begin
							regFileWrite = 1;
							regFileWriteSrc = `REG_FILE_WRITE_SRC_MEM;
						end
						default : begin
							regFileWrite = 1;
							regFileWriteSrc = `REG_FILE_WRITE_SRC_EX;
						end
					endcase
				end

				// Next State
				next_state = `CONTROL_STATE_FETCH;
			end
		endcase
	end
endmodule
