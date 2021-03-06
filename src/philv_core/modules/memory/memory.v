`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Harvard University School of Engineering and Applied Sciences
// Engineer: Anthony JW Kenny
// 
// Create Date: 02/04/2020 11:01:53 AM
// Design Name: 
// Module Name: synth_dual_port_memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Taken from the source code for a MIPS processor given be the CS141 
//              staff in Spring 2019
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: READ ONLY - NOT SYNCHRONIZED
// 
//////////////////////////////////////////////////////////////////////////////////


`default_nettype none
`timescale 1ns/1ps

`include "memory_defines.h"

module memory( 
	clk, access, rdEna, rdAddr, wrEna, wrAddr, wrData, rdData,
);

// Bus Width 
parameter N = 32;

// Instruction Parameters
parameter LENGTH = 512;
parameter WIDTH  = 9; // (2^9 = 512)
parameter MEM_FILE = "load.memb";

// Inputs
input wire clk;
input wire [`MEM_ACCESS_WIDTH-1:0] access;
input wire rdEna, wrEna;
input wire [N-1:0] rdAddr, wrAddr, wrData;

// Outputs
output reg [N-1:0] rdData;

// Memory
reg  [(N/4)-1:0] MEM [(LENGTH*4)-1:0];

// memory
always @(posedge clk) begin
	if (rdEna) begin
		// Always read word in little-endian order at read addr
		rdData <= {MEM[rdAddr+3], MEM[rdAddr+2], MEM[rdAddr+1], MEM[rdAddr]};
	end
	if (wrEna) begin
		case(access)
			`MEM_ACCESS_BYTE :
				// Write Least Significant Byte to wrAddr
				MEM[wrAddr] <= wrData[7:0];
			`MEM_ACCESS_HALF :
				// Write Least Significant Half Word to wrAddr
				{MEM[wrAddr+1], MEM[wrAddr]} <= wrData[15:0];
			default :
				// Default to write whole word to memory in litte-endian order 
				{MEM[wrAddr+3], MEM[wrAddr+2], MEM[wrAddr+1], MEM[wrAddr]} <= wrData;
		endcase
	end

end

//`ifndef SYNTHESIS
reg [8*100:0] INIT_INST;
initial begin
	if(!$value$plusargs("INIT_INST=%s", INIT_INST)) begin
		INIT_INST=MEM_FILE;
	end
	$display("initializing %m's instruction memory from '%s'", INIT_INST);
	// $readmemb(INIT_INST, MEM, 0, (LENGTH*4)-1);
	$readmemh(INIT_INST, MEM, 0, (LENGTH*4)-1);
end
//`else
//initial begin
//	$readmemh("tests/i_synth.memh", IMEM, 0, LENGTH-1);
//end
//`endif

endmodule

`default_nettype wire
