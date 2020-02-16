# This asm test relies on the $zero register being incorrecly set to the value
# of 1. This is because this was written before I type instructions were 
# implemented.
nop
add $x2, $zero, $x0 	# $x2 = 2
sub $x1, $x2, $x0 		# $x1 = 1
add $x4, $x2, $x2 		# $x4 = 4
xor $x5, $tp, $ra		# $x5 = 5
or 	$x3, $sp, $x1		# $x3 = 3
sll $x12, $gp, $x2 		# $x12 = 12
srl $x6, $a2, $x1		# $x6 = 6
add $x9, $x4, $t0 		# $x9 = 9
add $x17, $x9, $x9 		# $x17 = 18
sub $x17, $x17, $x1 	# $x17 = 17
sra $x8, $a7, $x1 		# $x8 = 8
sub $x13, $x1, $x9		# $x13 = -8
sra $x14, $x13, $x1 	# $x14 = -4
sra $x15, $x13, $x2     # $x15 = -2
and $x16, $x4, $x2 		# $x0 = 0
and $x17, $x3, $x2 		# $x17 = 2
slt $x18, $x1, $x3 		# $x18 = 1
slt $x19, $x3, $x1 		# $x19 = 0
slt $x20, $x13, $x0 	# $x20 = 1
sltu $x21, $x13, $x0 	# $x21 = 0
sltu $x22, $x1, $x3 	# $x22 = 1
sltu $x23, $x3, $x1 	# $x23 = 0