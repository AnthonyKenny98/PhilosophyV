`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2020 08:36:39 PM
// Design Name: 
// Module Name: edgcolTegisterFile_tb
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


module edgcolTegisterFile_tb;

    parameter REG_WIDTH = 32;

    reg clk, rst, wrEna;
    reg [2:0] wrAddr;
    reg [REG_WIDTH-1:0] wrData;

    wire [REG_WIDTH-1:0] e0, e1, e2, e3, e4, e5;

    edgcolRegisterFile #(.REG_WIDTH(REG_WIDTH)) uut (
        .clk(clk),
        .rst(rst),
        .wrEna(wrEna),
        .wrAddr(wrAddr),
        .wrData(wrData),
        .rdData0(e0),
        .rdData1(e1),
        .rdData2(e2),
        .rdData3(e3),
        .rdData4(e4),
        .rdData5(e5)
    );

    initial begin
        #1000;
        #10; clk = 0; rst = 0;
        wrEna = 0;
        wrAddr = 0;
        wrData = 1;

        #10; clk = 1;
        #10; clk = 0;
        wrData = 10;
        wrEna = 1;

        #10; clk = 1;
        #10; clk = 0;

        wrAddr = 1;
        wrData = 11;

        #10; clk = 1;
        #10; clk = 0;

        wrAddr = 2;
        wrData = 12;

        #10; clk = 1;
        #10; clk = 0;

        wrAddr = 3;
        wrData = 13;

        #10; clk = 1;
        #10; clk = 0;

        wrAddr = 4;
        wrData = 14;

        #10; clk = 1;
        #10; clk = 0;

        wrAddr = 5;
        wrData = 15;

        #10; clk = 1;
        #10; clk = 0;

        uut.print_decimal();
        $finish;

    end
endmodule
