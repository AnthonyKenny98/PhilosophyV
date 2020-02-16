#!/usr/bin/env python
#
# MIPS assembler
# Author: Zachary Yedidia

# Edited for RISC-V by Anthony Kenny
#
# Usage:
#    python3 assembler.py [<input.asm>] [<output> (no file extension)]

import sys, re

def bin_to_hex(x):
    y = hex(int(x,2))[2:]
    if len(y) < 8:
        y = (8-len(y))*"0" + y
    return y

def dec_to_bin(value, nbits):
  value = int(value)
  fill = "0"
  if value < 0:
    value = (abs(value) ^ 0xffffffff) + 1
    fill = "1"

  value = bin(value)[2:]
  if len(value) < nbits:
    value = (nbits-len(value))*fill + value
  if len(value) > nbits:
    value = value[-nbits:]
  return value

rtypes = {
    "add": (0,0,51),
    "sub": (32,0,51),
    "and": (0,7,51),
    "or": (0,6,51),
    "xor": (0,4,51),
    "sll": (0,1,51),
    "sra": (32,5,51),
    "srl": (0,5,51),
    "slt": (0,2,51),
    "sltu": (0,3,51)
    # "jr": 8
}

# op_codes = {
#     "add": 0,
#     "sub": 0,
#     "and": 0,
#     "or": 0,
#     "xor": 0,
#     "nor": 0,
#     "sll": 0,
#     "sra": 0,
#     "srl": 0,
#     "slt": 0,
#     "jr": 0,
#     "jal": 3,
#     "beq": 4,
#     "bne": 5,
#     "addi": 8,
#     "andi": 12,
#     "lw": 35,
#     "sw": 43,
#     "xori": 14,
#     "j": 2,
#     "slti": 10,
#     "ori": 13
# }

registers = {
    # Direct numbers
    '$x0' :  0,
    '$x1' :  1,
    '$x2' :  2,
    '$x3' :  3,
    '$x4' :  4,
    '$x5' :  5,
    '$x6' :  6,
    '$x7' :  7,
    '$x8' :  8,
    '$x9' :  9,
    '$x10' : 10,
    '$x11' : 11,
    '$x12' : 12,
    '$x13' : 13,
    '$x14' : 14,
    '$x15' : 15,
    '$x16' : 16,
    '$x17' : 17,
    '$x18' : 18,
    '$x19' : 19,
    '$x20' : 20,
    '$x21' : 21,
    '$x22' : 22,
    '$x23' : 23,
    '$x24' : 24,
    '$x25' : 25,
    '$x26' : 26,
    '$x27' : 27,
    '$x28' : 28,
    '$x29' : 29,
    '$x30' : 30,
    '$x31' : 31,

    # Names
    '$zero' : 0,
    '$ra': 1,
    '$sp': 2,
    '$gp': 3,
    '$tp': 4,
    '$t0': 5,
    '$t1': 6,
    '$t2': 7,
    '$s0': 8, '$fp': 8,
    '$s1': 9,
    '$a0': 10,
    '$a1': 11,
    '$a2': 12,
    '$a3': 13,
    '$a4': 14,
    '$a5': 15,
    '$a6': 16,
    '$a7': 17,
    '$s2': 18,
    '$s3': 19,
    '$s4': 20,
    '$s5': 21,
    '$s6': 22,
    '$s7': 23,
    '$s8': 24,
    '$s9': 25,
    '$s10': 26,
    '$s11': 27,
    '$t3': 28,
    '$t4': 29,
    '$t5': 30,
    '$t6': 31,
}

def find_label_relative(parsed_lines, line, label):
    for l in parsed_lines:
        if l['label'] == label:
            imm = l['line_number'] - line['line_number'] - 1
            return dec_to_bin(imm, 16)

def find_label_absolute(parsed_lines, label):
    for l in parsed_lines:
        if l['label'] == label:
            imm = l['line_number']*4 + 0x400000
            return dec_to_bin(imm, 32)[4:30]

def main():
    if len(sys.argv) != 3:
        print("Usage: python3 assembler.py [<input.asm>] [<output> (no ext)]")
        return
    me, inputname, outputname = sys.argv
    outputname = outputname if outputname != 'default' else 'instr_load'

    f = open(inputname, "r")
    labels = {}        # Map from label to its address.
    parsed_lines = []  # List of parsed instructions.
    address = 0        # Track the current address of the instruction.
    line_count = 0     # Number of lines.

    output_b = open("{}.memb".format(outputname), "w")

    for line in f:

        # Stores attributes about the current line of code, like its label, line
        # number, instruction, and arguments.
        line_attr = {}

        # Handle comments, whitespace.
        line = line.strip()

        if line:
            label = ""
            if "#" in line:
                line = line.split("#")[0].strip()
                if not line:
                    continue

            if ":" in line:
                elems = line.split(":")
                label = elems[0].strip()
                labels[label] = 0x400000 + line_count * 4
                line = elems[1].strip()

            sp = re.split(r"\s+", line, 1)
            cmd = sp[0]
            args = ""
            if len(sp) > 1:
                args = sp[1].split(',')

            line_attr['line_number'] = line_count

            # Handle labels
            # Parse the rest of the instruction and its register arguments.
            line_attr["instruction"] = cmd
            line_attr["label"] = label
            line_attr["args"] = args

            # Finally, add this dict to the complete list of instructions.
            parsed_lines.append(line_attr)

            line_count = line_count + 1
    f.close()

    machine = ""  # Current machine code word.

    for line in parsed_lines:
        if line['instruction'] == 'nop':
            machine = 32*'0'
        elif line['instruction'] in rtypes:
            # Encode an R-type instruction.
            args = line['args']

            rs1 = dec_to_bin(registers[args[1].strip()], 5)
            rs2 = dec_to_bin(registers[args[2].strip()], 5)
            rd = dec_to_bin(registers[args[0].strip()], 5)

            funct7 = dec_to_bin(rtypes[line['instruction']][0], 7)
            funct3 = dec_to_bin(rtypes[line['instruction']][1], 3)
            opcode = dec_to_bin(rtypes[line['instruction']][2], 7)

            machine = funct7 + rs2 + rs1 + funct3 + rd + opcode
        # else:
        #     # Encode a non-R-type instruction.
        #     args = line['args']
        #     op = dec_to_bin(op_codes[line['instruction']], 6)
        #     if line['instruction'] == 'jal':
        #         addr = find_label_absolute(parsed_lines, args[0].strip())
        #         machine = op + addr
        #     elif line['instruction'] == 'j':
        #         addr = find_label_absolute(parsed_lines, args[0].strip())
        #         machine = op + addr
        #     else:
        #         rt = dec_to_bin(registers[args[0].strip()], 5)
        #         if line['instruction'].endswith('i'):
        #             rs = dec_to_bin(registers[args[1].strip()], 5)
        #             imm = dec_to_bin(int(args[2].strip()), 16)
        #         elif line['instruction'].endswith('w'):
        #             arg2 = args[1].strip()
        #             matchObj = re.match(r'(-?\d+)\((.+?)\)', arg2)
        #             imm = dec_to_bin(matchObj.group(1), 16)
        #             rs = dec_to_bin(registers[matchObj.group(2)], 5)
        #         elif line['instruction'].startswith('b'):
        #             rt = dec_to_bin(registers[args[1].strip()], 5)
        #             rs = dec_to_bin(registers[args[0].strip()], 5)

        #             imm = find_label_relative(parsed_lines, line, args[2].strip())

        #         machine = op + rs + rt + imm

        output_b.write(machine + '\n')

if __name__ == "__main__":
    main()