`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Harvard University School of Engineering and Applied Sciences
// Engineer: Anthony JW Kenny
// 
// Create Date: 01/31/2020 03:11:17 PM
// Design Name: 
// Module Name: alu
// Project Name: PhilosophyV
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

`include "alu_funct_defines.h"

module alu(x, y, funct, z, equal, zero, overflow);
    
    // Bit Width
    // TODO: Abstract this out to top level processor
    parameter N = 32;
    
    // Inputs
    input wire [(N-1):0] x, y;
    input wire [(`ALU_FUNCT_WIDTH-1):0] funct;
    
    // Outputs
    output reg [(N-1):0] z;
    output wire equal, zero, overflow;
    
    // Internal
    wire signed [(N-1):0] x_s, y_s;
	assign x_s = x;
	assign y_s = y;
	
	// Logic
	always @(*) begin
	    case (funct)
            `ALU_FUNCT_AND : z = x & y;
			`ALU_FUNCT_OR  : z = x | y;
			`ALU_FUNCT_XOR : z = x ^ y;
			`ALU_FUNCT_NOR : z = ~(x | y);
			`ALU_FUNCT_SLT : z = {31'b0, x_s < y_s}; 
			`ALU_FUNCT_SLL : z = x << y;
			`ALU_FUNCT_SRL : z = x >> y;
			`ALU_FUNCT_ADD : z = x + y;
			`ALU_FUNCT_SUB : z = x - y;
			`ALU_FUNCT_SRA : z = x_s >>> y_s;
			default : z = 0;
		endcase
	end
    
    assign equal = (x === y);
    assign zero = (z === 32'd0);
    
    // TODO: overflow
    
endmodule
