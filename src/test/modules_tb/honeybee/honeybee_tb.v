`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2020 04:02:04 PM
// Design Name: 
// Module Name: honeybee_tb
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

`define NUM_CYCLES 4000

`define FLOAT_0_5 32'b00111111000000000000000000000000
`define FLOAT_1_5 32'b00111111110000000000000000000000

module honeybee_tb;

    parameter N = 32;
    parameter OUT_WIDTH = 8;

    // Control Inputs to HoneyBee
    reg clk;
    reg rst;
    reg start;

    // Control Output Signals from HoneyBee
    wire done;
    wire idle;
    wire ready;

    // Edge Inputs to HoneyBee
    reg [N-1:0] edge_p1_x, edge_p1_y, edge_p1_z, edge_p2_x, edge_p2_y, edge_p2_z;

    // Return output bus from HoneyBee
    wire [OUT_WIDTH-1:0] collisions;

    honeybee uut (
        .ap_clk(clk),        // input wire ap_clk
        .ap_rst(rst),        // input wire ap_rst
        .ap_start(start),    // input wire ap_start
        .ap_done(done),      // output wire ap_done
        .ap_idle(idle),      // output wire ap_idle
        .ap_ready(ready),    // output wire ap_ready
        .ap_return(collisions),  // output wire [7 : 0] ap_return
        .edge_p1_x(edge_p1_x),  // input wire [31 : 0] edge_p1_x
        .edge_p1_y(edge_p1_y),  // input wire [31 : 0] edge_p1_y
        .edge_p1_z(edge_p1_z),  // input wire [31 : 0] edge_p1_z
        .edge_p2_x(edge_p2_x),  // input wire [31 : 0] edge_p2_x
        .edge_p2_y(edge_p2_y),  // input wire [31 : 0] edge_p2_y
        .edge_p2_z(edge_p2_z)  // input wire [31 : 0] edge_p2_z
    );


    integer i;
    initial begin
        clk = 0;
        rst = 0;
        start = 0;

        #5000;
        edge_p1_x = `FLOAT_0_5;
        edge_p1_y = `FLOAT_0_5;
        edge_p1_z = `FLOAT_0_5;
        edge_p2_x = `FLOAT_0_5;
        edge_p2_y = `FLOAT_0_5;
        edge_p2_z = `FLOAT_1_5;

        for (i = 0; i<`NUM_CYCLES; i = i+1) begin
            #5; clk= ~clk;
            case (i)
                10: start = 1;
            endcase
            #5; clk = ~clk;
        end
        $finish;
    end

    always @(negedge clk) begin
        // $display(
        //     "i = %d | ", i,
        //     "start = %b ", start,
        //     "done = %b | ", done,
        //     "idle = %b | ", idle,
        //     "ready = %b | ", ready,
        //     "collisions = %b", collisions
        // );
    end
    always @(posedge done) begin
         $display(
            "i = %d | ", i,
            "start = %b ", start,
            "done = %b | ", done,
            "idle = %b | ", idle,
            "ready = %b | ", ready,
            "collisions = %b", collisions
        );
         #100;
        $finish;
    end
endmodule
