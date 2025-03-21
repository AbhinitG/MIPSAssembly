.data
	# one character is a byte, thus .byte is used for character
	myCharacter: .byte 'A' # can choose to do 'A' or "A"
.text 
	li $v0, 4
	la $a0, myCharacter
	syscall  
