`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2020 09:59:08 AM
// Design Name: 
// Module Name: philosophy_v_core_tb
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

`define INSTR_WIDTH 32
`define NUM_CYCLES 10

module run_philosophy_v_core;

    parameter N = 32;
    
    // Inputs 
    reg [(`INSTR_WIDTH-1):0] instr;
    
    // Outputs
    wire [(N-1):0] c;
    reg clk;
    reg [(`INSTR_WIDTH-1):0] addr = 32'h00400000;
    
    // Init Unit Under Test
    philosophy_v_core uut (
        .clk(clk),
        .c(c),
        .addr(addr)
    );
    
    ///////////////////////////////////////////////////////////////////////////
    // Testing Setup
    ///////////////////////////////////////////////////////////////////////////
    
    // Generate clk for testing
    integer i;
    reg [8*100:0] INIT_INST;
    initial begin
    
        // LOAD MEMORY
        if(!$value$plusargs("INIT_INST=%s", INIT_INST)) begin
	        INIT_INST="current_test.tv";
        end
        $display("initializing %m's instruction memory from '%s'", INIT_INST);
        
        $readmemb(INIT_INST, uut.MEMORY.IMEM, 0, 1024-1);
    
        clk = 0;
        for (i = 0; i < `NUM_CYCLES; i = i + 1) begin
            clk = 1; #10; clk = 0; #10;
        end
        $finish;
    end
    ///////////////////////////////////////////////////////////////////////////
    
    // Print z on falling edge
    always @(negedge clk) begin
        $display("a = %d, b = %d, c = %d, alu_funct = %b", uut.a, uut.b, c, uut.ALU.funct);
    end


endmodule
