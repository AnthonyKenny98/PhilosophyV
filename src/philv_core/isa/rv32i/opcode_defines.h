`ifndef OPCODE_DEFINES
`define OPCODE_DEFINES

`define OPCODE_WIDTH 7

`define OPCODE_ALU_IMM 	7'b0010011
`define OPCODE_ALU_REG 	7'b0110011
`define OPCODE_LOAD 	7'b0000011
`define OPCODE_STORE 	7'b0100011
`define OPCODE_JALR     7'b1100111
`define OPCODE_JAL      7'b1101111

`endif
