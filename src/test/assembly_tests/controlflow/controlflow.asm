addi $x1, $x0, 16   # x1 = 16
addi $x3, $x0, 1    # x3 = 1
jalr $x2, 0($x1)    # Jump to x1 (20) and store next instr address (12) in $x2
addi $x3, $x0, 3    # x3 = 3 --> Shouldn't happen
addi $x0, $x0, 0    # NOP
addi $x4, $x0, 4    # x4 = 4 --> SHOULD happen
addi $x5, $x0, 5    # x5 = 5 --> SHOULD happen
jal  $x9, 12         # Jump forward by 12 and store address (32) in $x9
addi $x4, $x0, 5    # skip
addi $x3, $x0, 5    # skip
addi $x6, $x0, 6    # LAND HERE
beq $x0, $x0, 8     # skip one instr
addi $x6, $x0, 0    # skip
addi $x7, $x0, 7    # LAND HERE