addi $x1, $x0, 16   # x1 = 16
addi $x3, $x0, 1    # x3 = 1
jalr $x2, 0($x1)    # Jump to x1 (20) and store next instr address (12) in $x2
addi $x3, $x0, 3    # x3 = 3 --> Shouldn't happen
addi $x0, $x0, 0    # NOP
addi $x4, $x0, 4    # x4 = 4 --> SHOULD happen
addi $x5, $x0, 1    # x5 = 1 --> SHOULD happen
jal  $x9, 12         # Jump forward by 12 and store address (32) in $x9
addi $x4, $x0, 5    # x4 = 5 shouldnt happen
addi $x3, $x0, 5    # x3 = 5 --> Shouldn't happen
addi $x6, $x0, 6    # x6 = 1 --> SHOULD
addi $x7, $x0, 7    # x7 = 1
addi $x8, $x0, 8    # x8 = 1
