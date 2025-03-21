.data

.text
	main:
		# typically the a regisgters are used to pass values to the function
		addi $a1, $zero, 50
		addi $a2, $zero, 100
		jal addNumbers  
		
		li $v0, 1
		move $a0, $v1
		syscall
		
	# Ends the program in the main, kind of like return 0 in C++ and C	
	li $v0, 10 
	syscall
	
	addNumbers:
		add $v1, $a1, $a2 # the sum is stored in v1, because by convection v1 is for return values
		jr $ra	
