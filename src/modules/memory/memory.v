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
	addr, dout,
);

// Bus Width 
parameter N = 32;

// Instruction Parameters
parameter LENGTH = 512;
parameter WIDTH  = 9; // (2^9 = 512)

// Control Inputs
input wire [N-1:0] addr;
output reg [N-1:0] dout;

// Memory
reg  [N-1:0] MEM [LENGTH-1:0];

// Physical address
wire [WIDTH-1:0] phy_addr;
assign phy_addr = addr[WIDTH+1:2];

//instruction memory
always @(addr) begin
	dout = MEM[phy_addr];
end

//`ifndef SYNTHESIS
reg [8*100:0] INIT_INST;
initial begin
	if(!$value$plusargs("INIT_INST=%s", INIT_INST)) begin
		INIT_INST="instr_load.memb";
	end
	$display("initializing %m's instruction memory from '%s'", INIT_INST);
	$readmemb(INIT_INST, MEM, 0, LENGTH-1);
end
//`else
//initial begin
//	$readmemh("tests/i_synth.memh", IMEM, 0, LENGTH-1);
//end
//`endif

endmodule

`default_nettype wire
