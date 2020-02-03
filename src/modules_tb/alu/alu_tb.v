`include "alu_defines.h"

module alu_test;
    
    // TODO
    parameter N = 32;
    
    // Inputs 
    reg [(N-1):0] a, b;
    reg [(`ALU_FUNCT_WIDTH-1):0] funct;
    
    // Outputs
    wire [(N-1):0] c;
    wire equal, zero, overflow;
    
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
    
    // Clk for testing
    reg clk;
    
    // Expected Outputs for testing
    reg [(N-1):0] c_x;
    // reg equal_x, zero_x, overflow_x;
    
    // Test Vectors
    reg [(3*N+`ALU_FUNCT_WIDTH-1): 0] test_vectors [9:0];
    integer vectornum, errors;
    
    // Error Tracking - Array for each FUNCT
    // `define NUM_ERROR_COUNTERS 10
    // integer errors [(`NUM_ERROR_COUNTERS - 1):0];

    
    // Generate clk
    always begin    // No sensitivity list, so it always cycles
        clk = 1; #10; clk = 0; #10;
    end
        
    // Load test vectors at start of test.
    initial begin    // Will execute at beginning once
        $readmemb("alu.tv", test_vectors);
        vectornum = 0; errors = 0;
    end
        
    // Apply test vectors on rising edge of clk
    always @(posedge clk) begin
        #2; {a, b, funct, c_x} = test_vectors[vectornum];
    end
    
    // Check results on falling edge of clk
    always @(negedge clk) begin
        // Check for error in test vector
        if (c !== c_x) begin
            $display("ERROR: x = %d, y = %d, FUNCT = %b", a, b, funct);
            $display(" z = %d (%d expected)", c, c_x);
            errors = errors + 1;
        end
        vectornum = vectornum + 1;
        if (test_vectors[vectornum] === 100'bx) begin
            $display("%d tests finished with %d errors.", vectornum, errors);
            $finish;
        end  
    end

endmodule
