`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2020 06:51:27 PM
// Design Name: 
// Module Name: mux4_tb
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


module mux4_tb;

	// Inputs
	reg [1:0] selector;
	reg [31:0] in00;
	reg [31:0] in01;
	reg [31:0] in10;
	reg [31:0] in11;

	// Outputs
	wire [31:0] out;

	// Instantiate the Unit Under Test (UUT)
	mux4 uut (
		.selector(selector), 
		.in00(in00), 
		.in01(in01), 
		.in10(in10), 
		.in11(in11), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		selector = 0;
		in00 = 0;
		in01 = 1;
		in10 = 2;
		in11 = 3;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		selector = 2'b00;
		#100;
		if (out != in00) begin
			$display("Error: Out = %d, selector = %b",out, selector);
		end
		#100;

		selector = 2'b01;
		#100;
		if (out != in01) begin
			$display("Error: Out = %d, selector = %b",out, selector);
		end
		#100;

		selector = 2'b10;
		#1001;
		if (out != in10) begin
			$display("Error: Out = %d, selector = %b",out, selector);
		end
		#100;

		selector = 2'b11;
		#100;
		if (out != in11) begin
			$display("Error: Out = %d, selector = %b",out, selector);
		end
		#100;

	end
      
endmodule