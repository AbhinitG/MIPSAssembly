.data

.text
	# mul # one of the ways to multiply integers as it takes three integers
	# mult # takes in 2 registers
	# sll # this is shift left logical, very efficient but doesn't give you much flexibility as the other two
	
	# gets the value into registers without using RAM 
	addi $s0, $zero, 10 # this adds ten + zero and store the result in s0
	addi $s1, $zero, 5 
	
	# the numbers that can be multiplied can only be 16 bits when using mul, have to use something else when wanting to multiply bigger numbers
	mul $t0, $s0, $s1 # this multiplies s0 and s1, and stores the product in t0
	
	# Displaying of the product
	li, $v0, 1
	add $a0, $zero, $t0
	syscall
	
	