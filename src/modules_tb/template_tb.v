///////////////////////////////////////////////////////////////////////////////
// Template TestBench
///////////////////////////////////////////////////////////////////////////////


// Include Any Files Here
`include "template_defines.h"

// Define any module specific constants here
`define N 32

// Define Number of Test Vectors here
`define TV_LEN 100

// Define Test Vector File here. Should be [template].tv
`define TV_FILE "template.tv"

// Define Test Module for unit named template
module template_test;

    // Define Test Vector Width here. This is the total number of bits per test 
    // vector, and should be the sum of all inputs and outputs you need to test.
    // This should be the only parameter, and is only such and defined within
    // the test module for the ability to make it dynamic (e.g. = 3*N not 96).
    parameter TV_WIDTH = 3*N;
    
    // Inputs (reg)
    reg [`N-1:0] inputA, inputB;
    
    // Real Outputs (wire)
    wire [`N-1:0] outputC;

    // Expected Outputs (reg). Should have same name with suffix "_x"
    reg [`N-1:0] outputC_x;
    
    // Init Unit Under Test
    template uut (
        .inputX(inputA),
        .inputY(inputB),
        .outputZ(inputC)
    );
    
    // Test Vectors
    reg [TV_WIDTH-1: 0] test_vectors [`TV_LEN-1:0];
    integer vectornum, errors;
    
    // Generate clk - No sensitivity list for continuous cycling
    reg clk;
    always begin
        clk = 1; #10; clk = 0; #10;
    end
        
    // Load test vectors at start of test
    initial begin
        $readmemb(`TV_FILE, test_vectors);
        vectornum = 0; errors = 0;
    end
        
    // Apply test vectors on rising clk edge
    always @(posedge clk) begin
        #2; {inputA, inputB, outputC_x} = test_vectors[vectornum];
    end
    
    // Check results on falling clk edge
    always @(negedge clk) begin
        // Check for error in test vector
        if (outputC !== outputC_x) begin
            $display("ERROR - TV #%d\n===============",vectornum);
            $display("custom error message here");
            errors = errors + 1;
        end
        vectornum = vectornum + 1;
        if (test_vectors[vectornum] === {TV_WIDTH{1'bx}}) begin
            $display("\n\nTEST BENCH COMPLETE\n===================");
            $display("%d tests finished with %d errors.", vectornum, errors);
            $finish;
        end  
    end

endmodule
