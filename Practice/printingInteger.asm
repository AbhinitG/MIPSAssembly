.data
	# declare integer as .word because .word is 32 bits(4 bytes)and an integer needs 32 bits
	year: .word 2021
.text
	li $v0, 1 # use 1 instead of 4 because we are telling the system to get ready to print out an integer
	# $a0 is for arguments
	lw $a0, year  # load word is used instead of load address because integer is .word type
	syscall