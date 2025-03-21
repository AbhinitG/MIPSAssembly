.data
	myInt1: .word 9, 21
	myInt2: .word 10 
.text
	lw $t0, myInt1 + 4
	lw $t1, myInt2
	
	add $t2, $t0, $t1 # register t2 is will be assigned with the value of t0 plus t1
	
	li $v0, 1
	add $a0, $zero, $t2 # assigns register a0 with the value of t2 + 0.
	syscall
	
	
