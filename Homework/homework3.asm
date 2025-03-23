.data
inBuf:	.byte	0:80		# .space 80
outBuf:	.byte	0:80


	.text
nextline:
	jal	getline
	lb	$t0, inBuf
	beq	$t0, '#', exit
	li	$t1, 0		# i = 0
nextChar:
	lb	$a3, inBuf($t1)	# key = inBuf[i]
	beq	$a3, '#', dump	# if(key=='#")goto dump
	jal	search		# $v0=search(key)
	#addi	$v0, $v0, 0x30	# char($v0)
	sb	$v0, outBuf($t1)# outBuf[i]=chType
	addi	$t1, $t1, 1	# i++
	b	nextChar
dump:
	jal	printOutBuf
	jal	clearInBuf
	jal	clearOutBuf
	b	nextline
exit:
	li	$v0, 10
	syscall
	
	.data
prompt:	.asciiz	"enter a new input string! \n"

	.text	
getline: 
	la	$a0, prompt		# Prompt to enter a new line
	li	$v0, 4
	syscall

	la	$a0, inBuf		# read a new line
	li	$a1, 80	
	li	$v0, 8
	syscall
	
	jr	$ra
	
	
	
	
search:
	initialization:
		li $t4, 0 # index for searching through the tabChar loop
	
	loop: 	
		lw $t6, tabChar($t4) # saves the value at index $t4 of tabChar to the register $t6
		beq $t6, $a3, found # if the $t6 regiter is equal to the key then go to found
		beq $t6, 0x5c, done
		addi $t4, $t4, 8
		b loop
		
	found: 
		addi $t3, $t4, 4
		lw $v0, tabChar($t3) # assign $v0 with the type
		b done
	
	done:
		jr	$ra

printOutBuf:
	initialization2:
		li $t6, 0 # index to go through the outBuf array
	loop2: 
		bge $t6, 80, done2 # checks if the index is greater than or equal to 80 in which case it goes to done2
		lb $t2, outBuf($t6) # save the value at the index $t6 of outBuf to $t2
		add $t6, $t6, 1 # incrementing the index
		beq $t2, 6, printSpace # in the case that the value is a 6 (space), go to printSpace
		beq $t2, 0, done2 # goes to done2 when it finds a 0
		b printType
	
	# function for printing the type
	printType:
		li $v0, 1
		move $a0, $t2
		syscall
		b loop2
	
	# function for printing space
	printSpace:
		li $a0, ' '
		li $v0, 11
		syscall
		b loop2
		
	# prints a new line then exits 
	done2:
		li $a0, '\n'
		li $v0, 11
		syscall
		jr $ra
	
clearInBuf:
	li $t6, 80 # start  the index at 80 and instead of incrementing, it decrements
	loop3:
		addi $t6, $t6, -1 # first index become 79
		sb $zero inBuf($t6) # stores a 0 
		bnez $t6 loop3 # if the index is not 0 then it goes back to the loop otherwise it exits
		jr	$ra

# same code as clearInBuf with a little change for the label names
clearOutBuf:
	li $t6, 80
	loop4:
		addi $t6, $t6, -1
		sb $zero outBuf($t6)
		bnez $t6 loop4
		jr	$ra
	




	.data

tabChar: 
	.word 	'\n', 5		# LF
	.word 	' ', 6
 	.word 	'#', 5
	.word 	'$', 4
	.word 	'(', 4 
	.word 	')', 4 
	.word 	'*', 3 
	.word 	'+', 3 
	.word 	',', 4 
	.word 	'-', 3 
	.word 	'.', 4 
	.word 	'/', 3 

	.word 	'0', 1
	.word 	'1', 1 
	.word 	'2', 1 
	.word 	'3', 1 
	.word 	'4', 1 
	.word 	'5', 1 
	.word 	'6', 1 
	.word 	'7', 1 
	.word 	'8', 1 
	.word 	'9', 1 

	.word 	':', 4 

	.word 	'A', 2
	.word 	'B', 2 
	.word 	'C', 2 
	.word 	'D', 2 
	.word 	'E', 2 
	.word 	'F', 2 
	.word 	'G', 2 
	.word 	'H', 2 
	.word 	'I', 2 
	.word 	'J', 2 
	.word 	'K', 2
	.word 	'L', 2 
	.word 	'M', 2 
	.word 	'N', 2 
	.word 	'O', 2 
	.word 	'P', 2 
	.word 	'Q', 2 
	.word 	'R', 2 
	.word 	'S', 2 
	.word 	'T', 2 
	.word 	'U', 2
	.word 	'V', 2 
	.word 	'W', 2 
	.word 	'X', 2 
	.word 	'Y', 2
	.word 	'Z', 2

	.word 	'a', 2 
	.word 	'b', 2 
	.word 	'c', 2 
	.word 	'd', 2 
	.word 	'e', 2 
	.word 	'f', 2 
	.word 	'g', 2 
	.word 	'h', 2 
	.word 	'i', 2 
	.word 	'j', 2 
	.word 	'k', 2
	.word 	'l', 2 
	.word 	'm', 2 
	.word 	'n', 2 
	.word 	'o', 2 
	.word 	'p', 2 
	.word 	'q', 2 
	.word 	'r', 2 
	.word 	's', 2 
	.word 	't', 2 
	.word 	'u', 2
	.word 	'v', 2 
	.word 	'w', 2 
	.word 	'x', 2 
	.word 	'y', 2
	.word 	'z', 2

	.word	'\\', -1		# if you ‘\’ as the end-of-table symbol
