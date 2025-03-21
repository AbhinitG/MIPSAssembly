.data
	message: .asciiz "Exit!"
	space: .asciiz ", "
.text 
	main:
		#addi $t0, $zero, 0 
		li $t0, 0
		
		
	while:
		bgt $t0, 10, exit
		beq $t0, 10, exit
		
		jal printNumber
		
		addi $t0, $t0, 1 # essentially the same as i++
		
		b while # this loops back to the while
	
	exit:
		li $v0, 4
		la $a0, message
		syscall
		
		li $v0, 10
		syscall
		
	printNumber:
		li $v0, 1
		#add $a0, $t0, $zero
		move $a0, $t0
		syscall
		
		li $v0, 4
		la $a0, space
		syscall
		
		jr $ra
		
