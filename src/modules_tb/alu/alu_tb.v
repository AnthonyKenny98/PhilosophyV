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
    
    // Error Tracking - Array for each FUNCT
    `define NUM_ERROR_COUNTERS 10
    integer errors [(`NUM_ERROR_COUNTERS - 1):0];
    integer i;
    
    initial begin
    
        // Set Up Error Tracking
        for (i=0; i<`NUM_ERROR_COUNTERS; i=i+1) begin
            errors[i] = 0;
        end
        
        // Init Inputs
        a = 1791;
        b = 1324;
        
        // And
        funct = `ALU_FUNCT_AND;
        #10;
        if (c != 1068) begin
            errors[`ALU_FUNCT_AND] = errors[`ALU_FUNCT_AND] + 1;
        end
        
        // Or
        funct = `ALU_FUNCT_OR;
        #10;
        if (c != 2047) begin
            errors[`ALU_FUNCT_OR] = errors[`ALU_FUNCT_OR] + 1;
        end
        
        // Xor
        funct = `ALU_FUNCT_XOR;
        #10;
        if (c != 979) begin
            errors[`ALU_FUNCT_XOR] = errors[`ALU_FUNCT_XOR] + 1;
        end
        
        // Nor
        funct = `ALU_FUNCT_NOR;
        #10;
        if (c != 0) begin
            errors[`ALU_FUNCT_NOR] = errors[`ALU_FUNCT_NOR] + 1;
        end
        
        // Add
        funct = `ALU_FUNCT_ADD;
        #10;
        if (c != 3115) begin
            errors[`ALU_FUNCT_ADD] = errors[`ALU_FUNCT_ADD] + 1;
        end
        
        // Sub
        funct = `ALU_FUNCT_SUB;
        #10;
        if (c != 467) begin
            errors[`ALU_FUNCT_SUB] = errors[`ALU_FUNCT_SUB] + 1;
        end
        
        
        // Display Errors
        for (i=0; i<`NUM_ERROR_COUNTERS; i=i+1) begin
            $display("Errors for FUNCT %d = %d\n", i, errors[i]);
        end
    end
endmodule
