.data
inBuf:	.byte	0:80

	.text
newLine:
	jal	getline

	lb	$t0, inBuf
	beq	$t0, '#', exit

	la	$s1, Q0		# CUR = Q0
	li	$t9, 0		# i=0

nextChar:
	lb	$t0, inBuf($t9)
	beq	$t0, '#', dump

	lw	$s2, ($s1)	# ACT = tabState[CUR][0]
	jalr	$v0, $s2	# call ACT

	sll	$s0, $s0, 2	# byte offset of column
	add	$s1, $s1, $s0
	lw	$s1, ($s1)	#CUR = tabState[CUR][C]

	addi	$t9, $t9, 1	#i++;

	b	nextChar

ACT1:
	# lb in $t0 isn't needed since it's already done before the calling of ACT in nextChar
	beq $t0, 'H', setCToOne # checks if $t0 is equal to H in which case it goes to set $s0(C) to 1 in the label setCToOne
	beq $t0, 'T', setCToTwo # checks if $t0 is equal to T in which case it goes to set $s0(C) to 2 in the label setCToTwo
	jr $v0 # returns to $v0

setCToOne:
	li $s0, 1 # use of li to load $s0 with the constant 1
	jr $v0 # returns to $v0
	
setCToTwo:
	li $s0, 2 # use of li to load $s0 with the constant 2
	jr $v0 # returns to $v0

ACT2:
	# ACT2 just branches to dump
	b dump

dump:    # print (i+1) and clear inBuf[]
	# this prints the index $t9
	li $v0, 1
	move $a0, $t9
	syscall
	
	# this prints a new line after printing the index
	li $a0, '\n'
	li $v0, 11
	syscall
	
	# goes to clearInBuf
	jal clearInBuf

# the same code as from h.w 3 except a slight change with b newLine instead of jr $ra
clearInBuf:
	li $t6, 80 # start  the index at 80 and instead of incrementing, it decrements
	loop:
		addi $t6, $t6, -1 # first index become 79
		sb $zero inBuf($t6) # stores a 0 
		bnez $t6 loop # if the index is not 0 then it goes back to the loop otherwise it exits
		b newLine # then branch to newLine

exit:	li $v0, 10
	syscall
	
	
# this code for getLine is from homework 3
	.data
prompt:	.asciiz	"enter a new input string of H and T! \n"

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



	.data
tabState:
Q0:     .word  ACT1
        .word  H   		# C = 1
        .word  T	   	# C = 2

H:      .word  ACT1
        .word  H   		# C = 1
        .word  Q1   	# C = 2



T:      .word  ACT1

        .word  H   		# C = 1

        .word  T	   	# C = 2



Q1:     .word  ACT2

        .word  -1

        .word  -1
