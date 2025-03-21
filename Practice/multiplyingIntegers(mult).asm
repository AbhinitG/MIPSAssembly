.data

.text
	addi $t0, $zero, 2000 # t0 holds the value 2000
	addi $t1, $zero, 10
	
	mult $t0, $t1 #  this is used for multiplication of numbers that are bigger than 16 bits
	
	mflo $s0 # move from lo (mflo) moves the product that of t0 and t1 to s0
	
	li $v0, 1
	add $a0, $zero, $s0 
	syscall
	 
