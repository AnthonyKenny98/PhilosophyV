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
`define NUM_CYCLES 20

module run_philv_core;

    parameter N = 32;
    
    // Input
    reg clk;
    
    // Init Unit Under Test
    philosophy_v_core uut (
        .clk(clk),
        .rstb(1'b0)
    );
    
    ///////////////////////////////////////////////////////////////////////////
    // Testing Setup
    ///////////////////////////////////////////////////////////////////////////
    
    // Generate clk for testing
    integer i;
    initial begin
        clk = 0;
        #100;

        for (i = 0; i < `NUM_CYCLES*2; i = i + 1) begin
            #10; clk = ~clk;
        end
        $finish;
    end
    ///////////////////////////////////////////////////////////////////////////
    
    // Print z on falling edge
    always @(negedge clk) begin
        $display("STATE = %d, IR_PC = %h, IR_I = %b, ALU_SRC_A = %h, ALU_SRC_B = %h, EX = %h, MEM = %h, WB = %h, r03 = %h", 
            uut.MAIN_CONTROLLER.state, uut.IF_REG.q[63:32], uut.IF_REG.q[31:0], uut._alu_src_a_, uut._alu_src_b_, uut.EX_REG.q, uut.MEM_REG.q, uut.WB_REG.q, uut.REG_FILE.r03);
    end


endmodule
