lw $x1, 4($zero)    # 1
lw $x2, 8($zero)    # 2
lw $x3, 12($zero)   # 3
lw $x4, 16($zero)   # 4
lw $x5, 0($x4)      # 1
lb $x6, 4($zero)    # 0
lb $x7, 5($zero)    # 0
lb $x8, 6($zero)    # 0
lb $x9, 7($zero)    # 1
lb $x10, 11($zero)  # 2
addi $x14, $x0, 32  # x14 = 32
lw $x11, 0($x14)    # x11 = 16843009
lh $x12, 0($x14)    # x12 = 257
lb $x13, 0($x14)    # x13 = 1
lw $x15, 4($x14)    # x15 = -2139029504
lh $x16, 4($x14)    # x16 = -32639
lb $x17, 4($x14)    # x17 = -128
lhu $x18, 4($x14)   # x18 = 32897
lbu $x19, 4($x14)   # x19 = 128
