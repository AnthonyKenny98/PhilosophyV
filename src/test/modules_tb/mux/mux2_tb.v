`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2020 06:51:27 PM
// Design Name: 
// Module Name: mux2_tb
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


module mux2_tb;

	// Inputs
	reg selector;
	reg [31:0] in0;
	reg [31:0] in1;

	// Outputs
	wire [31:0] out;

	// Instantiate the Unit Under Test (UUT)
	mux2 uut (
		.selector(selector), 
		.in0(in0), 
		.in1(in1), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		selector = 0;
		in0 = 0;
		in1 = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule