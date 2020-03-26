"""Convert RISC-V Assembly to Machine."""
# !/usr/bin/env python
#
# MIPS assembler
# Author: Zachary Yedidia

# Edited for RISC-V by Anthony Kenny
#
# Usage:
#    python3 assembler.py [<input.asm>] [<output> (no file extension)]

import sys
import re
import bitstring


def bin_to_hex(x):
    """Convert Binary to Hex."""
    y = hex(int(x, 2))[2:]
    if len(y) < 8:
        y = (8 - len(y)) * "0" + y
    return y


def dec_to_bin(value, nbits):
    """Convert Decimal to Binary."""
    value = int(value)
    fill = "0"
    if value < 0:
        value = (abs(value) ^ 0xffffffff) + 1
        fill = "1"

    value = bin(value)[2:]
    if len(value) < nbits:
        value = (nbits - len(value)) * fill + value
    if len(value) > nbits:
        value = value[-nbits:]
    return value


def dec_to_float_bin(val):
    """Convert Decimal to Binary."""
    val = float(val)
    return str(bitstring.BitArray(float=val, length=32).bin)


rtypes = {
    "add": (0, 0, 51),
    "sub": (32, 0, 51),
    "and": (0, 7, 51),
    "or": (0, 6, 51),
    "xor": (0, 4, 51),
    "sll": (0, 1, 51),
    "sra": (32, 5, 51),
    "srl": (0, 5, 51),
    "slt": (0, 2, 51),
    "sltu": (0, 3, 51)
}

itypes = {
    "addi": (0, 0, 19),
    "andi": (0, 7, 19),
    "ori": (0, 6, 19),
    "xori": (0, 4, 19),
    "slli": (0, 1, 19),
    "srai": (32, 5, 19),
    "srli": (0, 5, 19),
    "slti": (0, 2, 19),
    "sltiu": (0, 3, 19)
}

loads = {
    "lw": (2, 3),
    "lb": (0, 3),
    "lh": (1, 3),
    "lbu": (4, 3),
    "lhu": (5, 3)
}

stores = {
    "sw": (2, 35),
    "sh": (1, 35),
    "sb": (0, 35)
}

jumps = {
    "jalr": (0, 103),
    "jal": (0, 111)
}

branch = {
    "beq": (0, 99),
    "bne": (1, 99),
    "blt": (4, 99),
    "bge": (5, 99),
    "bltu": (6, 99),
    "bgeu": (7, 99),
}

Xedgcol = {
    "li.e": 0
}

registers = {
    # Direct numbers
    '$x0': 0,
    '$x1': 1,
    '$x2': 2,
    '$x3': 3,
    '$x4': 4,
    '$x5': 5,
    '$x6': 6,
    '$x7': 7,
    '$x8': 8,
    '$x9': 9,
    '$x10': 10,
    '$x11': 11,
    '$x12': 12,
    '$x13': 13,
    '$x14': 14,
    '$x15': 15,
    '$x16': 16,
    '$x17': 17,
    '$x18': 18,
    '$x19': 19,
    '$x20': 20,
    '$x21': 21,
    '$x22': 22,
    '$x23': 23,
    '$x24': 24,
    '$x25': 25,
    '$x26': 26,
    '$x27': 27,
    '$x28': 28,
    '$x29': 29,
    '$x30': 30,
    '$x31': 31,

    # Names
    '$zero': 0,
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

    # XEDGCOL
    '$e0': 0,
    '$e1': 1,
    '$e2': 2,
    '$e3': 3,
    '$e4': 4,
    '$e5': 5,

    '$px0': 0,
    '$py0': 1,
    '$pz0': 2,
    '$px1': 3,
    '$py1': 4,
    '$pz1': 5,

}


def find_label_relative(parsed_lines, line, label):
    """Find Label."""
    for l in parsed_lines:
        if l['label'] == label:
            imm = l['line_number'] - line['line_number'] - 1
            return dec_to_bin(imm, 16)


def find_label_absolute(parsed_lines, label):
    """Find Label."""
    for l in parsed_lines:
        if l['label'] == label:
            imm = l['line_number'] * 4 + 0x400000
            return dec_to_bin(imm, 32)[4:30]


def main():
    """Main."""
    # Check Usage
    if len(sys.argv) != 3:
        print("Usage: python3 assembler.py [<input.asm>] [<output> (no ext)]")
        return

    # Set up input and output files
    _, inputname, outputname = sys.argv
    outputname = outputname if outputname != 'default' else 'instr_load'

    # Input Assembly File
    input_asm = open(inputname, "r")

    # Output Binary File
    output_b = open("{}.memb".format(outputname), "w")

    labels = {}         # Map from label to its address.
    parsed_lines = []   # List of parsed instructions.
    line_count = 0      # Number of lines.

    for line in input_asm:

        # Stores attributes about the current line of code, like its label,
        # line number, instruction, and arguments.
        line_attr = {}

        # Handle whitespace.
        line = line.strip()

        if line:
            label = ""

            # Remove Comments
            if "#" in line:
                line = line.split("#")[0].strip()
                if not line:
                    continue

            # Save Label
            if ":" in line:
                elems = line.split(":")
                label = elems[0].strip()
                # labels[label] = 0x400000 + line_count * 4
                labels[label] = line_count * 4
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

            line_count += 1

    # Close input file
    input_asm.close()

    machine = ""  # Current machine code word.

    for line in parsed_lines:
        instr = line['instruction']
        args = line['args']

        # R Types
        if instr in rtypes:

            rs1 = dec_to_bin(registers[args[1].strip()], 5)
            rs2 = dec_to_bin(registers[args[2].strip()], 5)
            rd = dec_to_bin(registers[args[0].strip()], 5)

            funct7 = dec_to_bin(rtypes[instr][0], 7)
            funct3 = dec_to_bin(rtypes[instr][1], 3)
            opcode = dec_to_bin(rtypes[instr][2], 7)

            machine = funct7 + rs2 + rs1 + funct3 + rd + opcode

        # I-Types
        elif instr in itypes:

            rs1 = dec_to_bin(registers[args[1].strip()], 5)
            rd = dec_to_bin(registers[args[0].strip()], 5)

            # Account for shamt
            if instr in ['slli', 'srli', 'srai']:
                imm = dec_to_bin(itypes[instr][0], 7)
                imm = imm + dec_to_bin(args[2].strip(), 5)
            else:
                imm = dec_to_bin(args[2].strip(), 12)

            funct3 = dec_to_bin(itypes[instr][1], 3)
            opcode = dec_to_bin(itypes[instr][2], 7)

            machine = imm + rs1 + funct3 + rd + opcode

        # Loads
        elif instr in loads:

            rd = dec_to_bin(registers[args[0].strip()], 5)

            opcode = dec_to_bin(loads[instr][1], 7)
            funct3 = dec_to_bin(loads[instr][0], 3)

            arg2 = args[1].strip()
            match_obj = re.match(r'(-?\d+)\((.+?)\)', arg2)
            imm = dec_to_bin(match_obj.group(1), 12)
            rs1 = dec_to_bin(registers[match_obj.group(2)], 5)

            machine = imm + rs1 + funct3 + rd + opcode

        # Stores
        elif instr in stores:

            rs2 = dec_to_bin(registers[args[0].strip()], 5)

            opcode = dec_to_bin(stores[instr][1], 7)
            funct3 = dec_to_bin(stores[instr][0], 3)

            arg2 = args[1].strip()
            match_obj = re.match(r'(-?\d+)\((.+?)\)', arg2)
            imm = dec_to_bin(match_obj.group(1), 12)
            rs1 = dec_to_bin(registers[match_obj.group(2)], 5)

            machine = imm[0:7] + rs2 + rs1 + funct3 + imm[7:12] + opcode

        elif instr in jumps:

            opcode = dec_to_bin(jumps[instr][1], 7)
            rd = dec_to_bin(registers[args[0].strip()], 5)

            if instr == "jalr":
                funct3 = dec_to_bin(jumps[instr][0], 3)

                arg2 = args[1].strip()
                match_obj = re.match(r'(-?\d+)\((.+?)\)', arg2)
                imm = dec_to_bin(match_obj.group(1), 12)
                rs1 = dec_to_bin(registers[match_obj.group(2)], 5)

                machine = imm + rs1 + funct3 + rd + opcode

            elif instr == "jal":
                imm = dec_to_bin(args[1].strip(), 21)
                machine = imm[0] + imm[10:20] + imm[9] + imm[1:9] + rd + opcode

        elif instr in branch:

            opcode = dec_to_bin(branch[instr][1], 7)
            funct3 = dec_to_bin(branch[instr][0], 3)
            rs1 = dec_to_bin(registers[args[0].strip()], 5)
            rs2 = dec_to_bin(registers[args[1].strip()], 5)
            imm = dec_to_bin(args[2].strip(), 13)[0:12]

            machine = imm[0] + imm[2:8] + rs2 + rs1 + \
                funct3 + imm[8:12] + imm[1] + opcode

        elif instr in Xedgcol:
            opcode = dec_to_bin(Xedgcol[instr], 3)
            rd = dec_to_bin(registers[args[0].strip()], 3)
            imm = dec_to_float_bin(args[1].strip())

            machine = imm[0:26] + rd + opcode

        else:
            raise Exception("BAA")

        # Format Machine Code into little-endian with spaces between bytes
        formatted_machine = machine[24:32] + ' ' + machine[16:24] + ' ' + \
            machine[8:16] + ' ' + machine[0:8]
        output_b.write(formatted_machine + '\n')

if __name__ == "__main__":
    main()
