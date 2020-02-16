`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2020 04:29:56 PM
// Design Name: 
// Module Name: register
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


module register(clk, rst, d, q, ena);

	// Size of Data Bus. Must be uniform between different register lanes
	parameter N = 32;
	// Number of values in register
	parameter NUM_VAL = 1;

	// Control Inputs
	input wire clk, rst;
	input wire [NUM_VAL-1:0] ena;

	// D inputs
	input wire [NUM_VAL*N-1:0] d;
	
	// Q Outputs
	output reg [NUM_VAL*N-1:0] q;

	// Generate Logic for each register val
	genvar r;
	generate 
		for (r = 1; r<=NUM_VAL; r=r+1) begin : REGISTERS

			always @(posedge clk) begin
				if(rst) begin
					q[r*N-1:(r-1)*N] <= 0;
				end
				else if (ena[r-1]) begin
					q[r*N-1:(r-1)*N] <= d[r*N-1:(r-1)*N];
				end
				else begin
					q[r*N-1:(r-1)*N] <= q[r*N-1:(r-1)*N];
				end
			end
		end
	endgenerate
	
endmodule
