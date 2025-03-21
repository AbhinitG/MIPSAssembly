.data
	myInt1: .word 10
	myInt2: .word 5
.text
	lw $s0, myInt1 # s0 gets the value of 10
	lw $s1, myInt2 # s1 gets the value of 8
	
	sub $t0, $s0, $s1 # t0 gets the value of s0 - s1 = 10 - 5 = 5
	
	li $v0, 1
	move $a0, $t0 # this moves the value from the register t0 to a0
	syscall	