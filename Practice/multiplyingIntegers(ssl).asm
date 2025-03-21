.data

.text
	# sll allows for doing multiplication in a very efficient manner, while srl allows for doing division in an efficient manner
	# sll # shift left logical allows for the user to shift a bit to the left, srl shifts a bit to the right
	addi $s0, $zero, 4
	
	sll $t0, $s0, 2 # this instruction does 2^i, the last number is the power that it is raised to like the last 2 means 2^2 = 4, so s0 * 4 = 16
	
	li $v0, 1
	add $a0, $zero, $t0
	syscall