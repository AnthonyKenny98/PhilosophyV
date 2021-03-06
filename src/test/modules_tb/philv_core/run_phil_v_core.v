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
// Additional Comments: Runs the Philosophy V Core for a defined number of cycles,
//                      outputting relevant information each clk cycle. Does not
//                      perform any checks.
// 
//////////////////////////////////////////////////////////////////////////////////

`define NUM_CYCLES 100

module run_philv_core;
    
    // Input
    reg clk;
    
    // Init Unit Under Test
    philosophyVCore uut (
        .clk(clk),
        .rstb(1'b0)
    );
    
    ///////////////////////////////////////////////////////////////////////////
    // Testing Setup
    ///////////////////////////////////////////////////////////////////////////
    
    // Generate clk for testing
    integer i;
    initial begin
        // Run Philosophy V Core for NUM_CYCLES
        clk = 0; #100;
        while (uut._instr_ != 32'bx || uut._program_count_ <=32'h40) begin
            #5; clk = ~clk;
        end
    end
    ///////////////////////////////////////////////////////////////////////////
    
    // Print z on falling edge
    always @(negedge clk) begin
        $display(
            "STATE = %d | ", uut.MAIN_CONTROLLER.state,
            "PC = %h | ", uut.IF_REG.q,
            "Instr = %b | ",  uut.INSTR_MEMORY.rdData,
            "ALU_SRC_A = %h | ", uut._alu_src_a_,
            "ALU_SRC_B = %h | ", uut._alu_src_b_,
            "EX = %h | ", uut.EX_REG.q,
            "MEM = %h | ", uut.MEM_REG.q);
    end

endmodule
