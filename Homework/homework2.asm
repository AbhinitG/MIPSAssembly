.data
	myArrayX: .word 1, 2, 3, 4, 5, 6, 0
	key: .word 4
.text
	initialization:
		move $t0, $zero # $t0 will be the index variable i, which is set to 0 right now
		move $t1, $zero # $t1 will be the variable found, which is initialized to 0
		lw $t2, key # $t2 will hold the value of key
	 while: 
	 	 bnez $t1, printFound # checks if found is not equal to 0, in which case it goes to the label printFound
	 	 lw $t6, myArrayX($t0) # storing the value at the index($t0) of myArrayX in to $t6
	 	 beqz $t6, printFound # checks if $t6 is equal to 0, in which case it goes to the label printFound
	 	 bne $t6, $t2, else # checks if $t6 is not equal to the key, in which case goes to the label else
	 	 li $t1, 1
	 	 b while # use of b(branch) back to go to while
	 	 
	 else: 
	 	addi $t0, $t0, 4 # increments i by 4 since each spot integer is 4 bytes
	 	b while # goes to the while
	 
	 printFound:
	 	beqz $t1, printNegativeOne # checks if $t1 (found) is equal to 0, in which it case it goes to the label printNegativeOne
	 	# this is for printing $t0 (index)
	 	li $v0, 1
	 	sra $a0, $t0, 2 # shift right arithmetic is used to convert from bytes to regular index 
	 	syscall
	 	b exit # after goes to exit
	 	
	 printNegativeOne:	
	 	# prints negative one
	 	li $v0, 1
	 	li $a0, -1
	 	syscall
	 	b exit # jumps to exit
	 
	 exit: 
	 	# to end the program
	 	li $v0, 10
	 	syscall
	 	
	 	
	 	 
	
