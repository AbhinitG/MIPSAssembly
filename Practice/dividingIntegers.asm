.data

.text
	addi $t0, $zero, 30
	addi $t1, $zero, 8
	
	# div has 2 versions, one that takes 2 arguments while the other takes in 3 arguments
	# div $s0, $t0, $t1 # this is the 2 register version
	div $t0, $t1 # when doing division like this, the quotient is going to be stored in lo and the remainder is going to be stored in hi
	
	mflo $s0 # quotient
	mfhi $s1, # remainder
	
	li $v0, 1
	add $a0, $zero, $s1 # can switch between printing the remainder and quotient by switching between the registers s0 and s1
	syscall
	
