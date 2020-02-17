`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2020 05:55:11 PM
// Design Name: 
// Module Name: instr_decoder_tb
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

// Include Any Files Here
`include "instr_defines.h"
`include "alu_funct_defines.h"                                        

// Define any module specific constants here
`define N 32

// Define Number of Test Vectors here
`define TV_LEN 100                                                      // TODO

// Define Test Vector File here. Should be [template].tv
`define TV_FILE "instr_decoder.tv"

module instr_decoder_tb;

	// Define Test Vector Width here. This is the total number of bits per test 
    // vector, and should be the sum of all inputs and outputs you need to test.
    // This should be the only parameter, and is only such and defined within
    // the test module for the ability to make it dynamic (e.g. = 3*N not 96).
    
    // Instruction + controlOverride + alu_funct + 3*registers + extended immed
    parameter TV_WIDTH =`N + 1 + `ALU_FUNCT_WIDTH + 3*`INSTR_REG_WIDTH + `N;
    
    // Inputs (reg)
    reg [`N-1:0] instr;
    reg controlOverride;
    
    // Real Outputs (wire)
    wire [`ALU_FUNCT_WIDTH-1:0] alu_funct;
    wire [`INSTR_REG_WIDTH-1:0] rs1, rs2, rd;
    wire [`N-1:0] immed;

    // Expected Outputs (reg). Should have same name with suffix "_x"
    reg [`ALU_FUNCT_WIDTH-1:0] alu_funct_x;
    reg [`INSTR_REG_WIDTH-1:0] rs1_x, rs2_x, rd_x;
    reg [`N-1:0] immed_x;

    // Amalgamate actual and expected outputs
    wire [`TV_LEN-1:0] actual, expected;

    assign actual = {alu_funct, rs1, rs2, rd, immed};
    assign expected = {alu_funct_x, rs1_x, rs2_x, rd_x, immed_x};

    // Init Unit Under Test
    instr_decoder uut (
        .instr(instr),
        .controlOverride(controlOverride),
        .alu_funct(alu_funct),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .immed(immed)
    );

    // Test Vectors
    reg [TV_WIDTH-1: 0] test_vectors [`TV_LEN-1:0];
    integer vectornum, errors;
        
    integer i;
    reg clk;
    initial begin
        #2000; // Wait for global reset. 

        // Load test vectors at start of test.
        $readmemb(`TV_FILE, test_vectors);
        vectornum = 0; errors = 0;

        $display("========================================");
        $display("RUNNING TESTBENCH FOR INSTR_DECODER");

        // Generate clk
        for (i = 0; i < `TV_LEN; i = i+1) begin
            clk = 1; #10; clk = 0; #10;
        end
    end

    // Apply test vectors on rising clk edge
    always @(posedge clk) begin
        #2;
        {instr, controlOverride, alu_funct_x,
        	rs1_x, rs2_x, rd_x, immed_x} = test_vectors[vectornum];
    end

    // Check results on falling clk edge
    always @(negedge clk) begin
        // Check for error in test vector
        if (actual !== expected) begin
            $display("ERROR - TV #%d\n===============", vectornum);
            $display("Actual = %b | Expected = %b", actual, expected);
            errors = errors + 1;
        end
        vectornum = vectornum + 1;
        if (test_vectors[vectornum] === {TV_WIDTH{1'bx}}) begin
            $display("%d tests finished with %d errors.", vectornum, errors);
            $display("========================================");
            $finish;
        end  
    end

endmodule
