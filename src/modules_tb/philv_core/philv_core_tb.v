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

`define TEST_VECTOR_FILE "philv.tv"
`define TV_LEN 10

`define INSTR_WIDTH 32

module phil_core_tb;

    parameter N = 32;
    
    // Inputs 
    reg [(N-1):0] a, b;
    reg [(`INSTR_WIDTH-1):0] instr;
    
    // Outputs
    wire [(N-1):0] c;
    
    // Init Unit Under Test
    philosophy_v_core uut (
        .instr(instr),
        .a(a),
        .b(b),
        .c(c)
    );
    
    ///////////////////////////////////////////////////////////////////////////
    // Testing Setup
    ///////////////////////////////////////////////////////////////////////////
    
    // Generate clk for testing
    reg clk;
    always begin    // No sensitivity list, so it always cycles
        clk = 1; #10; clk = 0; #10;
    end
    
    // Declare Expected Outputs
    reg [(N-1):0] c_x;
    
    // Test Vectors
    `define TV_WIDTH 3*N + `INSTR_WIDTH
    reg [(`TV_WIDTH-1): 0] test_vectors [(`TV_LEN-1):0];
    
    // Counters
    integer vectornum, errors;
    
    // Load test vectors at start of test.
    initial begin    // Will execute at beginning once
        $readmemb(`TEST_VECTOR_FILE, test_vectors);
        vectornum = 0; errors = 0;
    end
    
    ///////////////////////////////////////////////////////////////////////////
        
    // Apply test vectors on rising edge of clk
    always @(posedge clk) begin
        #2; {instr, a, b, c_x} = test_vectors[vectornum];
    end
    
    // Check results on falling edge of clk
    always @(negedge clk) begin
        // Check for error in test vector
        if (c !== c_x) begin
            $display("ERROR: x = %d, y = %d, ALU_OP_CODE = %b", a, b, instr);
            $display(" z = %d (%d expected)", c, c_x);
            errors = errors + 1;
        end
        vectornum = vectornum + 1;
        if (test_vectors[vectornum] === `TV_WIDTH'bx) begin
            $display("%d tests finished with %d errors.", vectornum, errors);
            $finish;
        end  
    end


endmodule
