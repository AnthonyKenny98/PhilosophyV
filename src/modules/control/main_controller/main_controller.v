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
`include "alu_src_defines.h"
`include "control_state_defines.h"

module main_controller(
	// Inputs
	clk, opCode,
	// Outputs
	PCWrite, IRWrite, ALUOverride, ALUSrcA, ALUSrcB, regFileWrite
);

	// Input Ports
	input wire clk;
	input wire [`INSTR_OPCODE_WIDTH-1:0] opCode;

	// Output Ports
	output reg PCWrite, IRWrite, regFileWrite, ALUOverride;
	output reg ALUSrcA;
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

				// Select Signals
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

				// Next State
				next_state = `CONTROL_STATE_EXECUTE;
				
			end

			`CONTROL_STATE_EXECUTE : begin

				// Control Signals
				PCWrite = 0;
				IRWrite = 0;
				regFileWrite = 0;
				ALUOverride = 0;

				// Select Signals
				ALUSrcA = `ALU_SRC_A_REGOUT;
				ALUSrcB = `ALU_SRC_B_REGOUT;

				// Next State
				next_state = `CONTROL_STATE_MEMORY;

				
			end

			`CONTROL_STATE_MEMORY : begin

				// Control Signals
				PCWrite = 0;
				IRWrite = 0;
				regFileWrite = 0;
				ALUOverride = 0;


				// Next State
				next_state = `CONTROL_STATE_WRITEBACK;
				
			end

			`CONTROL_STATE_WRITEBACK : begin

				// Control Signals
				PCWrite = 0;
				IRWrite = 0;
				regFileWrite = 1;
				ALUOverride = 0;

				// Next State
				next_state = `CONTROL_STATE_FETCH;
				
			end
		endcase
	end

endmodule
