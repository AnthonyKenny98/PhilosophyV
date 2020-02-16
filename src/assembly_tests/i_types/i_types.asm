nop
addi $x1, $x0, 1 	# $x1 = 1
addi $x2, $x1, 1	# $x2 = 2
ori $x3, $x2, 1 	# $x3 = 3
ori $x5, $x1, 4	    # $x5 = 5
andi $x4, $x5, 6	# $x4 = 4
addi $x7, $zero, 7 	# $x7 = 7
addi $x6, $x7, -1 	# $x6 = 6
slti $x8, $x6, 7 	# $x8 = 1
slti $x9, $x6, 5 	# $x9 = 0
slti $x10, $x6, 6 	# $x10 = 0
sltiu $x11, $x0, 1  # $x11 = 1
xori $x12, $x7, 5 	# #x12 = 2