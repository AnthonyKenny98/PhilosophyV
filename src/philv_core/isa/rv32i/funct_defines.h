`ifndef FUNCT_DEFINES
`define FUNCT_DEFINES

// FUNCT7
`define FUNCT7_WIDTH 7

`define FUNCT7_BASE 7'b0000000
`define FUNCT7_ALT1 7'b0100000

// FUNCT3
`define FUNCT3_WIDTH 3

`define FUNCT3_ADD  3'b000
`define FUNCT3_SLL  3'b001
`define FUNCT3_SLT  3'b010
`define FUNCT3_SLTU 3'b011
`define FUNCT3_XOR  3'b100
`define FUNCT3_SRL  3'b101
`define FUNCT3_OR   3'b110
`define FUNCT3_AND  3'b111

`define FUNCT3_LW   3'b010
`define FUNCT3_LB   3'b000
`define FUNCT3_LH   3'b001
`define FUNCT3_LBU  3'b100
`define FUNCT3_LHU  3'b101

`define FUNCT3_SB   3'b000
`define FUNCT3_SH   3'b001
`define FUNCT3_SW   3'b010

`endif
