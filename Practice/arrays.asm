.data
	myArray: .space 12
.text
	#addi $s0, $zero, 4
	#addi $s1, $zero, 8
	#addi $s2, $zero, 12
	li $s0, 4
	li $s1, 8
	li $s2, 12
	
	# $t0 = index
	li $t0, 0
	sw $s0, myArray($t0)
	addi $t0, $t0, 4
	sw $s1, myArray($t0)
	addi $t0, $t0, 4
	sw $s2, myArray($t0)
	
	# lw gets the value from the array
	lw $t6, myArray($zero) # $t6 is being assigned with the value of myArray at the index 0 (first index)
	
	li $v0, 1
	move $a0, $t6
	syscall
