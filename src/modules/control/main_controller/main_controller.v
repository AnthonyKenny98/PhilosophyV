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
	ALUSrcB, regFileWrite
);

	// Input Ports
	input wire clk;
	input wire [`INSTR_OPCODE_WIDTH-1:0] opCode;

	// Output Ports
	output reg [`ALU_SRC_B_WIDTH-1:0] ALUSrcB;
	output reg regFileWrite;

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
				regFileWrite = 1;
				ALUSrcB = `ALU_SRC_B_REGOUT;

				// Next State
				next_state = state;
			end
		endcase
	end

endmodule
