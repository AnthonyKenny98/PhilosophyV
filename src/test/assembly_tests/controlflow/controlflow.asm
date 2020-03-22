addi $x1, $x0, 16
addi $x3, $x0, 1
jalr $x2, 0($x1)    # Jump to x1 store next instr address (12) in $x2
addi $x3, $x0, 3    # Skip
addi $x0, $x0, 0    # NOP
addi $x4, $x0, 4    #
addi $x5, $x0, 5    # 
jal  $x9, 12        # Jump forward by 12 and store address (32) in $x9
addi $x4, $x0, 5    # skip
addi $x3, $x0, 5    # skip
addi $x6, $x0, 6    # LAND
beq $x0, $x0, 8     # skip one instr
addi $x6, $x0, 0    # skip
addi $x7, $x0, 7    # LAND
beq $x0, $x1, 8     # No skip
addi $x8, $x0, 8
bne $x0, $x0, 8     # No skip
addi $x10, $x0, 10
bne $x0, $x1, 12    # skip 2 instrs
addi $x3, $x3, 3    # skip
addi $x4, $x4, 4    # skip
addi $x11, $x0, 11  
blt $x0, $x1, 8     # skip 1
addi $x5, $x5, 5    # skip
addi $x12, $x0, 12
blt $x0, $x0, 8     # no skip
addi $x13, $x0, 13
bge $x0, $x1, 8     # no skip
addi $x14, $x0, 14
bge $x0, $x0, 8     # skip 1
addi $x6, $x6, 6 # skip
addi $x15, $x0, 15
bge $x1, $x0, 8    # skip 1
addi $x7, $x7, 7    #skip
addi $x16, $x0, 16
bltu $x0, $x0, 8     # no skip
addi $x17, $x0, 17
bgeu $x0, $x1, 8     # no skip
addi $x18, $x0, 18
bgeu $x0, $x0, 8     # skip 1
addi $x8, $x8, 8 # skip
addi $x19, $x0, 19
bgeu $x1, $x0, 8    # skip 1
addi $x9, $x9, 9    #skip
addi $x20, $x0, 20
addi $x21, $x0, -16
bltu $x21, $x0, 8   # no skip
addi $x22, $x0, 22
bgeu $x21, $x0, 8   #ship 1
addi $x10, $x10, 10 # skip this
addi $x23, $x0, 23
### END TEST
addi $x24, $x0, 0
addi $x25, $x0, 0
addi $x26, $x0, 0
addi $x27, $x0, 0
addi $x28, $x0, 0
addi $x29, $x0, 0
addi $x30, $x0, 0
addi $x31, $x0, 0

