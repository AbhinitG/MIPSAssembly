.data
	promptMessage: .asciiz "Enter a number for which you want to find the factorial: "
	result: .ascii "\nThe factorial of the number is: "
	userNumber: .word 0
	answer: .word 0
.text
	.globl main
	main: 
		# Prompt the user to enter a number
		li $v0, 4
		la $a0, promptMessage
		syscall
		# Read the number from the user
		li $v0, 5 # value entered by the user is going to be stored in $v0
		syscall
		
		# store the value entered by the user in the global variable userNumber
		sw $v0, userNumber
		
		# Call the factorial function
		lw $a0, userNumber # assign $a0 with the number inputed by the user
		jal findFactorial # call the function 
		sw $v0, answer
		
		# Display the message for the result
		li $v0, 4
		la $a0, result
		syscall
		
		# Display the integer
		li $v0, 1
		lw $a0, answer
		syscall
		
		# Tell the operating system about the end of the program
		li $v0, 10
		syscall
		
	#-------------------------------------------------------------------------------------
	.globl findFactorial
	findFactorial:
		subu $sp, $sp, 8
		sw $ra, ($sp)
		sw $s0, 4($sp)
		
		# Base case
		li $v0, 1
		beqz $a0, factorialDone
		
		move $s0, $a0
		sub $a0, $a0, 1
		jal findFactorial
		
		mul $v0, $s0, $v0
		
	factorialDone:
		lw $ra, ($sp)
		lw $s0, 4($sp)
		addu $sp, $sp, 8
		jr $ra
	
	
		
		
		
		
		
		