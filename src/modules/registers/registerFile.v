`default_nettype none
`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2020 06:31:43 AM
// Design Name: 
// Module Name: register_file
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

`define REG_FILE_LEN 32
`define REG_FILE_ADDR_WIDTH 5

module registerFile(clk, rst, rdAddr0, rdAddr1, wrAddr, rdData0, rdData1, wrData, wrEna);

	// Register Width Parameter
	parameter REG_WIDTH = 32;
	
	// Inputs
	input wire clk, rst, wrEna;
	input wire [`REG_FILE_ADDR_WIDTH-1:0] rdAddr0, rdAddr1, wrAddr;
	input wire [REG_WIDTH-1:0] wrData;
	
	// Outputs
	output reg [REG_WIDTH-1:0] rdData0, rdData1;
	
    // Internal Wire for Register Write Enables
	wire [`REG_FILE_LEN-1:0] reg_enas;
	decoder #(`REG_FILE_ADDR_WIDTH) REGISTER_DECODER (.enable(wrEna), .encoded(wrAddr), .decoded(reg_enas));

	wire signed [REG_WIDTH-1:0] r00, r01, r02, r03, r04, r05, r06, r07, r08, r09, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, r30, r31;

    // TODO: SET BACK TO 0
	assign r00 = 1; //RV32i has the first register as all zeros
	
    register #(.N(REG_WIDTH)) R01 (.clk(clk), .d(wrData), .q(r01), .rst(rst), .ena(reg_enas[01]));
	register #(.N(REG_WIDTH)) R02 (.clk(clk), .d(wrData), .q(r02), .rst(rst), .ena(reg_enas[02]));
	register #(.N(REG_WIDTH)) R03 (.clk(clk), .d(wrData), .q(r03), .rst(rst), .ena(reg_enas[03]));
	register #(.N(REG_WIDTH)) R04 (.clk(clk), .d(wrData), .q(r04), .rst(rst), .ena(reg_enas[04]));
	register #(.N(REG_WIDTH)) R05 (.clk(clk), .d(wrData), .q(r05), .rst(rst), .ena(reg_enas[05]));
	register #(.N(REG_WIDTH)) R06 (.clk(clk), .d(wrData), .q(r06), .rst(rst), .ena(reg_enas[06]));
	register #(.N(REG_WIDTH)) R07 (.clk(clk), .d(wrData), .q(r07), .rst(rst), .ena(reg_enas[07]));
	register #(.N(REG_WIDTH)) R08 (.clk(clk), .d(wrData), .q(r08), .rst(rst), .ena(reg_enas[08]));
	register #(.N(REG_WIDTH)) R09 (.clk(clk), .d(wrData), .q(r09), .rst(rst), .ena(reg_enas[09]));
	register #(.N(REG_WIDTH)) R10 (.clk(clk), .d(wrData), .q(r10), .rst(rst), .ena(reg_enas[10]));
	register #(.N(REG_WIDTH)) R11 (.clk(clk), .d(wrData), .q(r11), .rst(rst), .ena(reg_enas[11]));
	register #(.N(REG_WIDTH)) R12 (.clk(clk), .d(wrData), .q(r12), .rst(rst), .ena(reg_enas[12]));
	register #(.N(REG_WIDTH)) R13 (.clk(clk), .d(wrData), .q(r13), .rst(rst), .ena(reg_enas[13]));
	register #(.N(REG_WIDTH)) R14 (.clk(clk), .d(wrData), .q(r14), .rst(rst), .ena(reg_enas[14]));
	register #(.N(REG_WIDTH)) R15 (.clk(clk), .d(wrData), .q(r15), .rst(rst), .ena(reg_enas[15]));
	register #(.N(REG_WIDTH)) R16 (.clk(clk), .d(wrData), .q(r16), .rst(rst), .ena(reg_enas[16]));
	register #(.N(REG_WIDTH)) R17 (.clk(clk), .d(wrData), .q(r17), .rst(rst), .ena(reg_enas[17]));
	register #(.N(REG_WIDTH)) R18 (.clk(clk), .d(wrData), .q(r18), .rst(rst), .ena(reg_enas[18]));
	register #(.N(REG_WIDTH)) R19 (.clk(clk), .d(wrData), .q(r19), .rst(rst), .ena(reg_enas[19]));
	register #(.N(REG_WIDTH)) R20 (.clk(clk), .d(wrData), .q(r20), .rst(rst), .ena(reg_enas[20]));
	register #(.N(REG_WIDTH)) R21 (.clk(clk), .d(wrData), .q(r21), .rst(rst), .ena(reg_enas[21]));
	register #(.N(REG_WIDTH)) R22 (.clk(clk), .d(wrData), .q(r22), .rst(rst), .ena(reg_enas[22]));
	register #(.N(REG_WIDTH)) R23 (.clk(clk), .d(wrData), .q(r23), .rst(rst), .ena(reg_enas[23]));
	register #(.N(REG_WIDTH)) R24 (.clk(clk), .d(wrData), .q(r24), .rst(rst), .ena(reg_enas[24]));
	register #(.N(REG_WIDTH)) R25 (.clk(clk), .d(wrData), .q(r25), .rst(rst), .ena(reg_enas[25]));
	register #(.N(REG_WIDTH)) R26 (.clk(clk), .d(wrData), .q(r26), .rst(rst), .ena(reg_enas[26]));
	register #(.N(REG_WIDTH)) R27 (.clk(clk), .d(wrData), .q(r27), .rst(rst), .ena(reg_enas[27]));
	register #(.N(REG_WIDTH)) R28 (.clk(clk), .d(wrData), .q(r28), .rst(rst), .ena(reg_enas[28]));
	register #(.N(REG_WIDTH)) R29 (.clk(clk), .d(wrData), .q(r29), .rst(rst), .ena(reg_enas[29]));
	register #(.N(REG_WIDTH)) R30 (.clk(clk), .d(wrData), .q(r30), .rst(rst), .ena(reg_enas[30]));
	register #(.N(REG_WIDTH)) R31 (.clk(clk), .d(wrData), .q(r31), .rst(rst), .ena(reg_enas[31]));

	always @(*) begin
		case (rdAddr0) 
			5'd00 : rdData0 = r00;
			5'd01 : rdData0 = r01;
			5'd02 : rdData0 = r02;
			5'd03 : rdData0 = r03;
			5'd04 : rdData0 = r04;
			5'd05 : rdData0 = r05;
			5'd06 : rdData0 = r06;
			5'd07 : rdData0 = r07;
			5'd08 : rdData0 = r08;
			5'd09 : rdData0 = r09;
			5'd10 : rdData0 = r10;
			5'd11 : rdData0 = r11;
			5'd12 : rdData0 = r12;
			5'd13 : rdData0 = r13;
			5'd14 : rdData0 = r14;
			5'd15 : rdData0 = r15;
			5'd16 : rdData0 = r16;
			5'd17 : rdData0 = r17;
			5'd18 : rdData0 = r18;
			5'd19 : rdData0 = r19;
			5'd20 : rdData0 = r20;
			5'd21 : rdData0 = r21;
			5'd22 : rdData0 = r22;
			5'd23 : rdData0 = r23;
			5'd24 : rdData0 = r24;
			5'd25 : rdData0 = r25;
			5'd26 : rdData0 = r26;
			5'd27 : rdData0 = r27;
			5'd28 : rdData0 = r28;
			5'd29 : rdData0 = r29;
			5'd30 : rdData0 = r30;
			5'd31 : rdData0 = r31;
			default: rdData0 = 0;
		endcase
		case (rdAddr1)
			5'd00 : rdData1 = r00;
			5'd01 : rdData1 = r01;
			5'd02 : rdData1 = r02;
			5'd03 : rdData1 = r03;
			5'd04 : rdData1 = r04;
			5'd05 : rdData1 = r05;
			5'd06 : rdData1 = r06;
			5'd07 : rdData1 = r07;
			5'd08 : rdData1 = r08;
			5'd09 : rdData1 = r09;
			5'd10 : rdData1 = r10;
			5'd11 : rdData1 = r11;
			5'd12 : rdData1 = r12;
			5'd13 : rdData1 = r13;
			5'd14 : rdData1 = r14;
			5'd15 : rdData1 = r15;
			5'd16 : rdData1 = r16;
			5'd17 : rdData1 = r17;
			5'd18 : rdData1 = r18;
			5'd19 : rdData1 = r19;
			5'd20 : rdData1 = r20;
			5'd21 : rdData1 = r21;
			5'd22 : rdData1 = r22;
			5'd23 : rdData1 = r23;
			5'd24 : rdData1 = r24;
			5'd25 : rdData1 = r25;
			5'd26 : rdData1 = r26;
			5'd27 : rdData1 = r27;
			5'd28 : rdData1 = r28;
			5'd29 : rdData1 = r29;
			5'd30 : rdData1 = r30;
			5'd31 : rdData1 = r31;
			default: rdData1 = 0;
		endcase
	end

	// helpful for debugging - prints out contents of register file
	task print_hex;
	begin
		$display("r00::   $zero::%h",r00);
		$display("r01::     $at::%h",r01);
		$display("r02::     $v0::%h",r02);
		$display("r03::     $v1::%h",r03);
		$display("r04::     $a0::%h",r04);
		$display("r05::     $a1::%h",r05);
		$display("r06::     $a2::%h",r06);
		$display("r07::     $a3::%h",r07);
		$display("r08::     $t0::%h",r08);
		$display("r09::     $t1::%h",r09);
		$display("r10::     $t2::%h",r10);
		$display("r11::     $t3::%h",r11);
		$display("r12::     $t4::%h",r12);
		$display("r13::     $t5::%h",r13);
		$display("r14::     $t6::%h",r14);
		$display("r15::     $t7::%h",r15);
		$display("r16::     $s0::%h",r16);
		$display("r17::     $s1::%h",r17);
		$display("r18::     $s2::%h",r18);
		$display("r19::     $s3::%h",r19);
		$display("r20::     $s4::%h",r20);
		$display("r21::     $s5::%h",r21);
		$display("r22::     $s6::%h",r22);
		$display("r23::     $s7::%h",r23);
		$display("r24::     $t8::%h",r24);
		$display("r25::     $t9::%h",r25);
		$display("r26::     $k0::%h",r26);
		$display("r27::     $k1::%h",r27);
		$display("r28::     $gp::%h",r28);
		$display("r29::     $sp::%h",r29);
		$display("r30::     $fp::%h",r30);
		$display("r31::     $ra::%h",r31);
	end
	endtask

	task print_decimal;
	begin
		$display("r00::   $zero::%d",r00);
		$display("r01::     $at::%d",r01);
		$display("r02::     $v0::%d",r02);
		$display("r03::     $v1::%d",r03);
		$display("r04::     $a0::%d",r04);
		$display("r05::     $a1::%d",r05);
		$display("r06::     $a2::%d",r06);
		$display("r07::     $a3::%d",r07);
		$display("r08::     $t0::%d",r08);
		$display("r09::     $t1::%d",r09);
		$display("r10::     $t2::%d",r10);
		$display("r11::     $t3::%d",r11);
		$display("r12::     $t4::%d",r12);
		$display("r13::     $t5::%d",r13);
		$display("r14::     $t6::%d",r14);
		$display("r15::     $t7::%d",r15);
		$display("r16::     $s0::%d",r16);
		$display("r17::     $s1::%d",r17);
		$display("r18::     $s2::%d",r18);
		$display("r19::     $s3::%d",r19);
		$display("r20::     $s4::%d",r20);
		$display("r21::     $s5::%d",r21);
		$display("r22::     $s6::%d",r22);
		$display("r23::     $s7::%d",r23);
		$display("r24::     $t8::%d",r24);
		$display("r25::     $t9::%d",r25);
		$display("r26::     $k0::%d",r26);
		$display("r27::     $k1::%d",r27);
		$display("r28::     $gp::%d",r28);
		$display("r29::     $sp::%d",r29);
		$display("r30::     $fp::%d",r30);
		$display("r31::     $ra::%d",r31);
	end
	endtask


endmodule
`default_nettype wire
