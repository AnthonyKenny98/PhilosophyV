`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2020 08:16:20 PM
// Design Name: 
// Module Name: edgcolRegisterFile
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

`define REG_FILE_LEN 6
`define REG_FILE_ADDR_WIDTH 3

module edgcolRegisterFile(
    clk, rst, wrAddr, wrData, wrEna,
    rdData0, rdData1, rdData2, rdData3, rdData4, rdData5
);
    // Register Width Parameter
    parameter REG_WIDTH = 32;

    // Inputs
    input wire clk, rst, wrEna;
    input wire [`REG_FILE_ADDR_WIDTH-1:0] wrAddr;
    input wire [REG_WIDTH-1:0] wrData;

    // Outputs
    output wire [REG_WIDTH-1:0] rdData0, rdData1, rdData2, rdData3, rdData4, rdData5;


    // Internal Wire for Register Write Enables
    wire [`REG_FILE_LEN-1:0] reg_enas;
    decoder #(`REG_FILE_ADDR_WIDTH) REGISTER_DECODER (.enable(wrEna), .encoded(wrAddr), .decoded(reg_enas));

    register #(.N(REG_WIDTH)) R00 (.clk(clk), .d(wrData), .q(rdData0), .rst(rst), .ena(reg_enas[00]));
    register #(.N(REG_WIDTH)) R01 (.clk(clk), .d(wrData), .q(rdData1), .rst(rst), .ena(reg_enas[01]));
    register #(.N(REG_WIDTH)) R02 (.clk(clk), .d(wrData), .q(rdData2), .rst(rst), .ena(reg_enas[02]));
    register #(.N(REG_WIDTH)) R03 (.clk(clk), .d(wrData), .q(rdData3), .rst(rst), .ena(reg_enas[03]));
    register #(.N(REG_WIDTH)) R04 (.clk(clk), .d(wrData), .q(rdData4), .rst(rst), .ena(reg_enas[04]));
    register #(.N(REG_WIDTH)) R05 (.clk(clk), .d(wrData), .q(rdData5), .rst(rst), .ena(reg_enas[05]));


    task print_decimal;
    begin
        $display("r00::  %d",rdData0);
        $display("r01::  %d",rdData1);
        $display("r02::  %d",rdData2);
        $display("r03::  %d",rdData3);
        $display("r04::  %d",rdData4);
        $display("r05::  %d",rdData5);
    end
    endtask

endmodule
`default_nettype wire