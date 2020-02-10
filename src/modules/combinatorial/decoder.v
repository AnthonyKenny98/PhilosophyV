`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2020 07:02:54 AM
// Design Name: 
// Module Name: decoder
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

module decoder(enable, encoded, decoded);

	parameter N = 1;

	input enable;
	input [(N-1):0] encoded;
	output [(2**N-1):0] decoded;

	genvar ii;

	generate for(ii = 0; ii < 2**N; ii = ii + 1) begin : DECODER_AND_GATES
		assign decoded[ii] = enable & &(encoded ~^ ii);
	end endgenerate

endmodule
