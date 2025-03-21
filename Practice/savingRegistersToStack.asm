.data
	newLine: .asciiz "\n" 
.text
	main:
		# whenever s register is used in a procedure, by convention it has to be saved to the stack, so the old value is available
		addi, $s0, $zero, 21
		
		jal increaseMyRegister
		
		# have to print a line to separate the integers
		li, $v0, 4
		la $a0, newLine
		syscall 
		
		jal printValue
		 
	li $v0, 10
	syscall
	
	increaseMyRegister: # this function increases the value passed in by 1 and prints it out.
	
		# saving the old value in the stack makes it so the function can't change it
		# is element needs 4 bytes in the stack so for 2 elements -8 would be used
		addi $sp, $sp, -8 # sp (stack pointer)is used for saving the value of s0, -4 is used as an integer is 4 bytes and -4 allocates 4 bytes of space in the stack pointer, whereas a positive value would take away from the stack
		sw $s0, 0($sp) # this is telling the system to store the value of s0 in the first location which is 0 of the stack pointer
		sw $ra,	4($sp) 
		
		addi, $s0, $s0, 29
		
		# when a procedure is called inside another procedure, it's called Nested Procedure  
		jal printValue
		
		lw $s0, 0($sp) # this restores the value of s0
		lw $ra, 4($sp)
		addi $sp, $sp, 8 # restores the stack 
		
		jr $ra
		
	printValue:
		# The value is printed in the function 
		li $v0, 1
		move $a0, $s0
		syscall
		
		jr $ra
		
