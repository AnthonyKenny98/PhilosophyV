`timescale 1ns / 1ps
`default_nettype none //helps catch typo-related bugs
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2020 07:57:29 AM
// Design Name: 
// Module Name: doubleRegister
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


module doubleRegister(clk, rst, ena, dA, dB, qA, qB);

	//	Parameter definitions
	parameter BUS_WIDTH = 32;

	// Input Ports
	input wire clk, rst, ena;
	input wire [BUS_WIDTH-1:0] dA, dB;

	// Outut Ports
	output wire [BUS_WIDTH-1:0] qA, qB;



	// A Register
	register #(.N(BUS_WIDTH)) REGISTER_A (	.clk(clk),
									        .rst(rst),
									        .ena(ena),
									        .d(dA),
									        .q(qA));

	// B Register
	register #(.N(BUS_WIDTH)) REGISTER_B (	.clk(clk),
									        .rst(rst),
									        .ena(ena),
									        .d(dB),
									        .q(qB));


endmodule

`default_nettype wire //some Xilinx IP requires that the default_nettype be set to wire
