`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2020 10:37:59 AM
// Design Name: 
// Module Name: cmp_reg_file
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

`define NUM_CYCLES 10000
`define REG_FILE_LEN 32
`define INIT_RF "cmp_reg_file.tv"

module cmp_reg_file;
    
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
    
    // Iterator
    integer i;

    // Errors
    integer errors;

    // Register file values in order
    reg [33:0] reg_vals [37:0];

    initial begin
    	errors = 0;

    	// Run Philosophy V Core for NUM_CYCLES
        clk = 0; #100;
        for (i = 0; i < `NUM_CYCLES*2; i = i + 1) begin
        	#10; clk = ~clk;
        end

    	// Load expected register values
    	$display("Initializing Expected Reg File from '%s'", `INIT_RF);
		$readmemb(`INIT_RF, reg_vals);

       	// Compare expected value with that in Register File
		if (uut.REG_FILE.r00 !== reg_vals[0]) errors = errors + 1;
		if (uut.REG_FILE.r01 !== reg_vals[1]) errors = errors + 1;
		if (uut.REG_FILE.r02 !== reg_vals[2]) errors = errors + 1;
		if (uut.REG_FILE.r03 !== reg_vals[3]) errors = errors + 1;
		if (uut.REG_FILE.r04 !== reg_vals[4]) errors = errors + 1;
		if (uut.REG_FILE.r05 !== reg_vals[5]) errors = errors + 1;
		if (uut.REG_FILE.r06 !== reg_vals[6]) errors = errors + 1;
		if (uut.REG_FILE.r07 !== reg_vals[7]) errors = errors + 1;
		if (uut.REG_FILE.r08 !== reg_vals[8]) errors = errors + 1;
		if (uut.REG_FILE.r09 !== reg_vals[9]) errors = errors + 1;
		if (uut.REG_FILE.r10 !== reg_vals[10]) errors = errors + 1;
		if (uut.REG_FILE.r11 !== reg_vals[11]) errors = errors + 1;
		if (uut.REG_FILE.r12 !== reg_vals[12]) errors = errors + 1;
		if (uut.REG_FILE.r13 !== reg_vals[13]) errors = errors + 1;
		if (uut.REG_FILE.r14 !== reg_vals[14]) errors = errors + 1;
		if (uut.REG_FILE.r15 !== reg_vals[15]) errors = errors + 1;
		if (uut.REG_FILE.r16 !== reg_vals[16]) errors = errors + 1;
		if (uut.REG_FILE.r17 !== reg_vals[17]) errors = errors + 1;
		if (uut.REG_FILE.r18 !== reg_vals[18]) errors = errors + 1;
		if (uut.REG_FILE.r19 !== reg_vals[19]) errors = errors + 1;
		if (uut.REG_FILE.r20 !== reg_vals[20]) errors = errors + 1;
		if (uut.REG_FILE.r21 !== reg_vals[21]) errors = errors + 1;
		if (uut.REG_FILE.r22 !== reg_vals[22]) errors = errors + 1;
		if (uut.REG_FILE.r23 !== reg_vals[23]) errors = errors + 1;
		if (uut.REG_FILE.r24 !== reg_vals[24]) errors = errors + 1;
		if (uut.REG_FILE.r25 !== reg_vals[25]) errors = errors + 1;
		if (uut.REG_FILE.r26 !== reg_vals[26]) errors = errors + 1;
		if (uut.REG_FILE.r27 !== reg_vals[27]) errors = errors + 1;
		if (uut.REG_FILE.r28 !== reg_vals[28]) errors = errors + 1;
		if (uut.REG_FILE.r29 !== reg_vals[29]) errors = errors + 1;
		if (uut.REG_FILE.r30 !== reg_vals[30]) errors = errors + 1;
		if (uut.REG_FILE.r31 !== reg_vals[31]) errors = errors + 1;

        if (uut.EDGCOL_REGISTER_FILE.rdData0 !== reg_vals[32]) errors = errors + 1;
        if (uut.EDGCOL_REGISTER_FILE.rdData1 !== reg_vals[33]) errors = errors + 1;
        if (uut.EDGCOL_REGISTER_FILE.rdData2 !== reg_vals[34]) errors = errors + 1;
        if (uut.EDGCOL_REGISTER_FILE.rdData3 !== reg_vals[35]) errors = errors + 1;
        if (uut.EDGCOL_REGISTER_FILE.rdData4 !== reg_vals[36]) errors = errors + 1;
        if (uut.EDGCOL_REGISTER_FILE.rdData5 !== reg_vals[37]) errors = errors + 1;

		$display("Register 00 | Actual = %h | Expected = %h", uut.REG_FILE.r00, reg_vals[0]);
		$display("Register 01 | Actual = %h | Expected = %h", uut.REG_FILE.r01, reg_vals[1]);
		$display("Register 02 | Actual = %h | Expected = %h", uut.REG_FILE.r02, reg_vals[2]);
		$display("Register 03 | Actual = %h | Expected = %h", uut.REG_FILE.r03, reg_vals[3]);
		$display("Register 04 | Actual = %h | Expected = %h", uut.REG_FILE.r04, reg_vals[4]);
		$display("Register 05 | Actual = %h | Expected = %h", uut.REG_FILE.r05, reg_vals[5]);
		$display("Register 06 | Actual = %h | Expected = %h", uut.REG_FILE.r06, reg_vals[6]);
		$display("Register 07 | Actual = %h | Expected = %h", uut.REG_FILE.r07, reg_vals[7]);
		$display("Register 08 | Actual = %h | Expected = %h", uut.REG_FILE.r08, reg_vals[8]);
		$display("Register 09 | Actual = %h | Expected = %h", uut.REG_FILE.r09, reg_vals[9]);
		$display("Register 10 | Actual = %h | Expected = %h", uut.REG_FILE.r10, reg_vals[10]);
		$display("Register 11 | Actual = %h | Expected = %h", uut.REG_FILE.r11, reg_vals[11]);
		$display("Register 12 | Actual = %h | Expected = %h", uut.REG_FILE.r12, reg_vals[12]);
		$display("Register 13 | Actual = %h | Expected = %h", uut.REG_FILE.r13, reg_vals[13]);
		$display("Register 14 | Actual = %h | Expected = %h", uut.REG_FILE.r14, reg_vals[14]);
		$display("Register 15 | Actual = %h | Expected = %h", uut.REG_FILE.r15, reg_vals[15]);
		$display("Register 16 | Actual = %h | Expected = %h", uut.REG_FILE.r16, reg_vals[16]);
		$display("Register 17 | Actual = %h | Expected = %h", uut.REG_FILE.r17, reg_vals[17]);
		$display("Register 18 | Actual = %h | Expected = %h", uut.REG_FILE.r18, reg_vals[18]);
		$display("Register 19 | Actual = %h | Expected = %h", uut.REG_FILE.r19, reg_vals[19]);
		$display("Register 20 | Actual = %h | Expected = %h", uut.REG_FILE.r20, reg_vals[20]);
		$display("Register 21 | Actual = %h | Expected = %h", uut.REG_FILE.r21, reg_vals[21]);
		$display("Register 22 | Actual = %h | Expected = %h", uut.REG_FILE.r22, reg_vals[22]);
		$display("Register 23 | Actual = %h | Expected = %h", uut.REG_FILE.r23, reg_vals[23]);
		$display("Register 24 | Actual = %h | Expected = %h", uut.REG_FILE.r24, reg_vals[24]);
		$display("Register 25 | Actual = %h | Expected = %h", uut.REG_FILE.r25, reg_vals[25]);
		$display("Register 26 | Actual = %h | Expected = %h", uut.REG_FILE.r26, reg_vals[26]);
		$display("Register 27 | Actual = %h | Expected = %h", uut.REG_FILE.r27, reg_vals[27]);
		$display("Register 28 | Actual = %h | Expected = %h", uut.REG_FILE.r28, reg_vals[28]);
		$display("Register 29 | Actual = %h | Expected = %h", uut.REG_FILE.r29, reg_vals[29]);
		$display("Register 30 | Actual = %h | Expected = %h", uut.REG_FILE.r30, reg_vals[30]);
		$display("Register 31 | Actual = %h | Expected = %h", uut.REG_FILE.r31, reg_vals[31]);

        $display("Register e0 | Actual = %h | Expected = %h", uut.EDGCOL_REGISTER_FILE.rdData0, reg_vals[32]);
        $display("Register e1 | Actual = %h | Expected = %h", uut.EDGCOL_REGISTER_FILE.rdData1, reg_vals[33]);
        $display("Register e2 | Actual = %h | Expected = %h", uut.EDGCOL_REGISTER_FILE.rdData2, reg_vals[34]);
        $display("Register e3 | Actual = %h | Expected = %h", uut.EDGCOL_REGISTER_FILE.rdData3, reg_vals[35]);
        $display("Register e4 | Actual = %h | Expected = %h", uut.EDGCOL_REGISTER_FILE.rdData4, reg_vals[36]);
        $display("Register e5 | Actual = %h | Expected = %h", uut.EDGCOL_REGISTER_FILE.rdData5, reg_vals[37]);

		$display("Finished with %d errors.", errors);

		$finish;
		
	end

endmodule
