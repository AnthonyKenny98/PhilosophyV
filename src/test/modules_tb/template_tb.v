///////////////////////////////////////////////////////////////////////////////
// Template TestBench
///////////////////////////////////////////////////////////////////////////////


// Include Any Files Here
`include "template_defines.h"                                           // TODO

// Define any module specific constants here
`define N 32                                                            // TODO

// Define Number of Test Vectors here
`define TV_LEN 100                                                      // TODO

// Define Test Vector File here. Should be [template].tv
`define TV_FILE "template.tv"                                           // TODO

// Define Test Module for unit named template
module template_test;

    // Define Test Vector Width here. This is the total number of bits per test 
    // vector, and should be the sum of all inputs and outputs you need to test.
    // This should be the only parameter, and is only such and defined within
    // the test module for the ability to make it dynamic (e.g. = 3*N not 96).
    parameter TV_WIDTH = 3*`N;                                           // TODO
    
    // Inputs (reg)
    reg [`N-1:0] inputA, inputB;                                        // TODO
    
    // Real Outputs (wire)
    wire [`N-1:0] outputC;                                              // TODO

    // Expected Outputs (reg). Should have same name with suffix "_x"
    reg [`N-1:0] outputC_x;                                             // TODO

    assign actual = {outputC};
    assign expected = {outputC_x};
    
    // Init Unit Under Test
    template uut (                                                      // TODO
        .inputX(inputA),
        .inputY(inputB),
        .outputZ(inputC)
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
        $display("RUNNING TESTBENCH FOR MODULE");                       // TODO

        // Generate clk
        for (i = 0; i < `TV_LEN; i = i+1) begin
            clk = 1; #10; clk = 0; #10;
        end
    end
        
    // Apply test vectors on rising clk edge
    always @(posedge clk) begin
        #2; {inputA, inputB, outputC_x} = test_vectors[vectornum];      // TODO
    end
    
    // Check results on falling clk edge
    always @(negedge clk) begin
        // Check for error in test vector
        if (actual !== expected) begin
            $display("ERROR - TV #%d\n===============", vectornum);
            $display("Actual = %b | Expected = %b", actual, expected);
            $display("custom error message here");                     // TODO
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
