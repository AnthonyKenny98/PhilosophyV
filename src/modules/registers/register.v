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

	parameter N = 32;
	input wire clk, rst, ena;
	input wire [N-1:0] d;
	output reg [N-1:0] q;

	always @(posedge clk) begin
		if(rst) begin
			q <= 0;
		end
		else if (ena) begin
			q <= d;
		end
		else begin
			q <= q;
		end
	end
	
endmodule
