`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Harvard University, School of Engineering and Applied Sciences
// Engineer: Anthony JW Kenny
// 
// Create Date: 03/20/2020 01:21:12 PM
// Design Name: // Design Name: PhilosophyV
// Module Name: dataMemController
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

`include "opcode_defines.h"
`include "funct_defines.h"

module dataMemController(in, opcode, funct3, out);

    // BUS WIDTH
    parameter N = 32;

    // Inputs
    input wire [N-1:0] in;
    input wire [`OPCODE_WIDTH-1:0] opcode;
    input wire [`FUNCT3_WIDTH-1:0] funct3;

    // Internal Wires
    wire [N-1:0] _sign_extend_half_, _sign_extend_byte_;
    wire [N-1:0] _zero_extend_half_, _zero_extend_byte_;

    // Outputs
    output reg [N-1:0] out;

    // Assign Extensions
    assign _sign_extend_half_ = {{16{in[15]}}, in[15:0]};
    assign _sign_extend_byte_ = {{24{in[7]}}, in[7:0]};
    assign _zero_extend_half_ = {{16{0}}, in[15:0]};
    assign _zero_extend_byte_ = {{24{0}}, in[7:0]};

    // Determine Data Read Extension based on opcode and func
    always @(in, opcode, funct3) begin
        case(opcode)
            `OPCODE_LOAD : case (funct3)
                `FUNCT3_LW : out = in;
                `FUNCT3_LH : out =  _sign_extend_half_;
                `FUNCT3_LB : out =  _sign_extend_byte_;
                `FUNCT3_LHU : out = _zero_extend_half_;
                `FUNCT3_LBU : out = _zero_extend_byte_;
            endcase
            default : out = in;
        endcase
    end

endmodule
