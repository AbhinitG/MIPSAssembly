.data  # contains all the data, in this case the variable message that stores "Hello, world!", which is stored in the RAM. 
	message: .asciiz "Hello, world!"
.text # contains all the instructions that prints out only ascii values  	
	li $v0, 4 # puts the value 4 in the register v0 which lets it know that you want to print out a value to the screen
	la $a0, message # puts the value of the message variable into the register a0, letting the system know what message you want to print out
	syscall # this executes the program
	
	
