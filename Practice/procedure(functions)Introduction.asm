.data
	message: .asciiz "Hey, everybody!\nMy name is Abhinit.\n"
.text
	# a label is a name with a colon so for example "somename:" is a label
	main: # this is the main function
		jal displayMessage # jal (jump at link) is used for calling the function 	 
		
		addi $s0, $zero, 5
		
		# Prints out the number 5 to the screen
		li $v0, 1
		add $a0, $zero, $s0
		syscall 
	
	# This is going to tell the system that the program is done. Not having this will create an infinite recursion that ends with an error.
	# Tells main that this is the end of the program.
	li $v0, 10
	syscall
		
	# the function for displaying the message 
	displayMessage: 
		li $v0, 4
		la $a0, message
		syscall
		
		jr $ra # this is gonna make it so that it exits out of the function, jr stands for jump register
