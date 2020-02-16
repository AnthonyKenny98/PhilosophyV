`include "alu_funct_defines.h"

// Define Bit Width
`define N 32

// Define Number of Test Vectors
`define TV_LEN 1000

// Define Test Vector File
`define TV_FILE "alu.tv"

module alu_test();
    
    // TODO: Test SLT, SLL, SRL, SRA

    parameter TV_WIDTH = 3*`N + `ALU_FUNCT_WIDTH;
    
    // Inputs for UUT
    reg [(`N-1):0] a, b;
    reg [(`ALU_FUNCT_WIDTH-1):0] funct;
    
    // Outputs of UUT
    wire [(`N-1):0] c;
    wire equal, zero, overflow;

    // Expected Outputs
    reg [(`N-1):0] c_x;
    // reg equal_x, zero_x, overflow_x;
    
    // Init Unit Under Test
    alu uut (
        .x(a),
        .y(b),
        .funct(funct),
        .z(c),
        .equal(equal),
        .zero(zero),
        .overflow(overflow)
    );
    
    // Test Vectors
    reg [(TV_WIDTH-1): 0] test_vectors [`TV_LEN:0];
    integer vectornum, errors;
    

    integer i;
    reg clk;
    initial begin
        #2000; // Wait for global reset.

        // Load test vectors at start of test.
        $readmemb(`TV_FILE, test_vectors);
        vectornum = 0; errors = 0;

        $display("========================================");
        $display("RUNNING TESTBENCH FOR ALU");

        // Generate clk
        for (i = 0; i < `TV_LEN; i = i+1) begin
            clk = 1; #10; clk = 0; #10;
        end
    end
        
    // Apply test vectors on rising edge of clk
    always @(posedge clk) begin
        #2; {a, b, funct, c_x} = test_vectors[vectornum];
    end
    
    // Check results on falling edge of clk
    always @(negedge clk) begin
        // Check for error in test vector
        if (c !== c_x) begin
            $display(
                "ERROR: x = %d | ", a,
                "y = %d | ", b,
                "FUNCT = %b | ", funct,
                "z = %d (%d expected)", c, c_x);
            errors = errors + 1;
        end
        vectornum = vectornum + 1;
        if (test_vectors[vectornum] === 100'bx) begin
            $display("%d tests finished with %d errors.", vectornum, errors);
            $display("========================================");
            $finish;
        end  
    end

endmodule
