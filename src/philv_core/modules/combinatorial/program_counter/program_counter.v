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

module program_counter(lastCount, newCount);

	parameter N = 32;

	input wire [N-1:0] lastCount;
	output reg [N-1:0] newCount;

    always @(*) begin
        newCount = lastCount;
    end

endmodule
