`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2020 06:30:09 PM
// Design Name: 
// Module Name: mux4
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


module mux4(selector, in00, in01, in10, in11, out);

	//parameter definitions
	parameter BUS_WIDTH = 32;

	//port definitions - customize for different bit widths
	input wire [1:0] selector;
	input wire [BUS_WIDTH-1:0] in00, in01, in10, in11;

	wire [BUS_WIDTH-1:0] mux1_out, mux2_out;

	output wire [BUS_WIDTH-1:0] out;

	mux2 #(
		.BUS_WIDTH(BUS_WIDTH)
	) MUX1 (
		.selector(selector[0]),
		.in0(in00),
		.in1(in01),
		.out(mux1_out));

	mux2 #(
		.BUS_WIDTH(BUS_WIDTH)
	) MUX2 (
		.selector(selector[0]),
		.in0(in10),
		.in1(in11),
		.out(mux2_out));

	assign out = selector[1] ? mux2_out : mux1_out;


endmodule
`default_nettype wire //some Xilinx IP requires that the default_nettype be set to wire