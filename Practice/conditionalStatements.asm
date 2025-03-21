.data
	message: .asciiz "The numbers are equal."
	message2: .asciiz "The numbers are not equal!"
	message3: .asciiz "Nothing happened!"
.text
	main:
		addi $t0, $zero, 20
		addi $t1, $zero, 20
	
		# this calls the fuction numbersEqual only if $t0 and $t1 are equal to each other 
		beq $t0, $t1, numbersEqual # beq (branch if equal) checks if the registers given are equal or not
		bne $t0, $t1, numbersNotEqual # ben (branch if not equal) checks if the registers are not equal to each other, and if so then it goes to the label numbersNotEqual
		b nothingHappened # b (branch) can be used to call a label
	
		# Syscall to end program
		jal exit
	
	numbersEqual:
		li $v0, 4
		la $a0, message
		syscall
		
		jal exit
		
	numbersNotEqual:
		li $v0, 4
		la $a0, message2
		syscall
		
		jal exit
	
	nothingHappened:
		li $v0, 4
		la $a0, message3
		syscall
		
		jal exit
		
	exit: 
	li $v0, 10
	syscall