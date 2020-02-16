# Testing Methodology

There are currently two methods provided for testing the Philosophy V Core and its submodules.
1) [Module Test Benches](#module_tb)
2) [Assembly Tests](#assembly)

## <a name=#module_tb></a>Module Test Benches
Consider a 8 bit adder that takes inputs `a` & `b` and outputs `c`. For now let's ignore overflow and other edge cases

  1. Create a csv file in the following format:
  ```
                col_0       col_1       col_2       ...
    ----------------------------------------------------
    row_0   |     8           8           8         ...  # The first row is the bit length of each decimal value
    row_1   |     1           1           2         ...  # All following rows are different test vectors
    row_2   |     4           6          10         ...
    row_3   |    13         24           37         ...
    ...     |   ...         ...         ...         ...
  ```
  
  Where:
    + The first row is the bit length for each value in binary representation.
    + ```col_0, col_1``` are the ```a``` and ```b``` values.  
    + ```col_2``` is the ```c``` value.
    
  2. Use the python script to convert csv into test vector file.
  ``` bash
    $ python3 csv_to_test_vector.py adder.csv adder.tv
  ```
  
  This will generate a file that looks like this:
  ```
    000000010000000100000010
    000001000000011000001010
    000011010001100000100101
  ```
  
  3. In ```adder_tb.v``` import the test vector file and compare.
  
  ``` verilog
  
    module adder_test;
    
        // Inputs 
        reg [(7):0] a, b;
        // Outputs
        wire [7:0] c;

        // Init Unit Under Test
        adder uut (
            .x(a),
            .y(b),
            .z(c),
        );

        // Clk for testing
        reg clk;

        // Expected Output for testing
        reg [7:0] c_x;

        // Test Vectors
        reg [8 + 8 + 8 - 1): 0] test_vectors [1000:0];
        integer vectornum, errors;

        // Generate clk
        always begin    // No sensitivity list, so it always cycles
            clk = 1; #10; clk = 0; #10;
        end

        // Load test vectors at start of test.
        initial begin    // Will execute at beginning once
            $readmemb("adder.tv", test_vectors);
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
                $display("ERROR: a = %d, b = %d", a, b);
                $display(" c = %d (%d expected)", c, c_x);
                errors = errors + 1;
            end
            vectornum = vectornum + 1;
            if (test_vectors[vectornum] === (8+8+8-1)'bx) begin
                $display("%d tests finished with %d errors.", vectornum, errors);
                $finish;
            end  
        end

  endmodule

  ```
  ## <a name=#assembly></a>Assembly Tests
  
