.data
	prompt: .asciiz "Enter your age: "
	message: .asciiz "Your age is "
.text
	# Prompt the user to enter age
	li $v0, 4
	la $a0, prompt
	syscall
	
	# Get the user's age
	li $v0, 5 # this is the system code to let the system know that an integer input from the keyboard is wanted
	syscall
	
	# Store the result in t0
	move $t0, $v0 # this moves the value in $v0 to $t0
	
	# Display the message
	li $v0, 4
	la $a0, message
	syscall
	
	# Printing of the age
	li $v0, 1
	move $a0, $t0
	syscall
	