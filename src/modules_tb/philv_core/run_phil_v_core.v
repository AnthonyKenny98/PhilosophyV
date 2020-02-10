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

module run_philv_core;

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
        .rstb(1'b0),
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
    
        clk = 0;
        for (i = 0; i < `NUM_CYCLES; i = i + 1) begin
            clk = 1; #10; clk = 0; #10;
        end
        $finish;
    end
    ///////////////////////////////////////////////////////////////////////////
    
    // Print z on falling edge
    always @(negedge clk) begin
        $display("PC.q = %h, MemReadData = %b, Instr = %b, R1 = %h, R2 = %h, ALU_SRC_A = %d, ALU_SRC_B = %d, ALU_RESULT = %d, ALU_OUT = %d, r03 = %d", addr, uut._mem_read_data_, uut._instr_, uut._reg_rd0_, uut._reg_rd1_, uut._alu_src_a_, uut._alu_src_b_, uut._alu_result_, uut.c, uut.REGISTER_FILE.r03);
    end


endmodule
