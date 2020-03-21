`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2020 09:02:58 PM
// Design Name: 
// Module Name: program_counter
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
`include "opcode_defines.h"

module program_counter(lastCount, newCount, opcode);

	parameter N = 32;

	input wire [N-1:0] lastCount;
    input wire [`INSTR_OPCODE_WIDTH-1:0] opcode;
	output reg [N-1:0] newCount;

    always @(*) begin
        case (opcode)
            `OPCODE_JAL : newCount = lastCount - 4;
            default: newCount = lastCount;
        endcase
    end

endmodule
