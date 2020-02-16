`timescale 1ns / 1ps
`default_nettype none //helps catch typo-related bugs
//////////////////////////////////////////////////////////////////////////////////
// Company: Harvard University School of Engineering and Applied Sciences
// Engineer: Anthony JW Kenny
// 
// Create Date: 02/07/2020 06:30:09 PM
// Design Name: 
// Module Name: mux2
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


module mux2(selector, in0, in1, out);

	//parameter definitions
	parameter BUS_WIDTH = 32;

	//port definitions - customize for different bit widths
	input  wire selector;
	input  wire [BUS_WIDTH-1:0] in0; // input to return when relevant op_code bit is low
	input  wire [BUS_WIDTH-1:0] in1; // input to return when relevant op_code bit is high

	output wire [BUS_WIDTH-1:0] out;

	assign out = selector ? in1 : in0;


endmodule
`default_nettype wire //some Xilinx IP requires that the default_nettype be set to wire
