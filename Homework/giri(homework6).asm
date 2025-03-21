.data
inBuf:	.byte	0:80
prSym: .word 0:3 	# will be used for printing the labels
prLoc: .word 0:3	# will be used for printing the LOC
prDEFN: .word 0:3	# will be used for printing the flag(DEFN)
spaces: .asciiz "    "
zeroX: .asciiz "0x"	# will be used for printing 
tabSymHead: .asciiz "tabSym:\n"
newLine: .asciiz "\n"
tabToken: .word 0:60
TOKEN: .byte 0:8
tabSym: .word 0:80
LOCATION: .word 0x0400

li $s7, 0			# $s7 will be used as the index for the tabSym
.text
nextLine:
	lw      $s5, LOCATION		# loading the memory of value of LOCATION to $s5
	jal 	getLine			# calling getLine to read the userInput
	lb	$t0, inBuf
	beq	$t0, '#', exit 		# check if the first input of the array is a # in which case it would exit the program
	jal  	tokenSetUp

li $a2, 0 				# index to tabToken
nextTok: 
	lb $t7, tabToken+12($a2)	# loading the character to $t7 to check if it's ':'
	bne $t7, ':', operator		# goes to operator if not ':'
	li $t4, 1			# the register $t4 will be used as the DEFN 
	jal VAR
	addi $a2, $a2, 24
	
operator:
	addi $a2, $a2, 12
chkVar: 
	lb $t0, tabToken+0($a2)		# loading character at index $a2 of tabToken to $t0
	# checking if the character is either ',' or '$' in which case it would just move on to the next index
	beq $t0, ',', nextVar
	beq $t0, '$', nextVar
	beq $t0, '#', dump
	lw $t0, tabToken+8($a2)		# load the type in $t0
	bne $t0, 2, nextVar
	li $t4, 0			# flag(DEFN) is 0.
	jal VAR
	
nextVar: 
	#lw $t3, tabToken($a3)
	addi $a2, $a2, 12
	b chkVar
dump:	
	jal clearInBuf
	jal cleartabToken
	jal printtabSym
	addi $s5, $s5, 4		# increment the value of LOCATION by 4 
	sw $s5, LOCATION		# save the new value in memory by storing in LOCATION
	b nextLine

# definition for the VAR function
VAR:  
		# storing of the characters
		lw $t7, tabToken+0($a2)
    		sw $t7, tabSym+0($s7)
    		lw $t7, tabToken+4($a2)
    		sw $t7, tabSym+4($s7)
    		# storing the LOCATION value 
    		sw $s5, tabSym+8($s7)
    		# storing the flag(DEFN)
    		sw $t4, tabSym+12($s7)
    		addi $s7, $s7, 16
    		jr $ra
 	
	
# this function will initialize the the different indexes that will be used to loop the program to 0
tokenSetUp:
	li 	$t2, 0  		# $t2 will be used as the register for the inBuf index
	li 	$t3, 0 			# $t3 will be used as TOKEN's index and is here set to 0.
	li 	$a3, 0 			# setting $a3 which will be the index used for token table to 0.
	la	$s1, Q0
	li	$s0, 1
nextState:	
	lw	$s2, 0($s1)
	jalr	$v1, $s2		# Save return addr in $v1

	sll	$s0, $s0, 2		# Multiply by 4 for word boundary
	add	$s1, $s1, $s0
	sra	$s0, $s0, 2
	lw	$s1, 0($s1)     
	b	nextState
	
ACT1: 
	lb $t8, inBuf($t2)  	# assign $t8 with the first character read from inBuf
	addi $t2, $t2, 1	# increment the index used for readin from inBuf
	la $t1, search		# go to search and assign s0 with the character type
	jalr $t5, $t1
	jr $v1
	
ACT2:			
	sb $t8, TOKEN		# store the character read from the inBuf in TOKEN
	sw $s0, tabToken+8($a3) # save the character type in tabToken 
	jr $v1 
ACT3:
	bge $t3, 8, exit 	# if the index used for TOKEN ($t3) is greater than or equal to 8, exit
	addi $t3, $t3, 1	# increment the index used for TOKEN
	sb $t8, TOKEN($t3)	# store the current character read from the inBuf in the second index of TOKEN
	jr $v1																																																																																																																																																																																																																																																																																																																																																								
ACT4:
	lw $t9, TOKEN		# assign $t9 with the first element in TOKEN	
	sw $t9, tabToken($a3)	# store $t9 in tabToken at the index $a3
	lw $t9, TOKEN + 4	# assign $t9 with the second element in TOKEN
	sw $t9, tabToken+4($a3) # store $t9 in tabToken at the index $a3 + 4
	addi $a3, $a3, 12	# increment $a3 by 12
	sw $zero, TOKEN		# clear TOKEN by assigning the first four element with 0 using sw
	sw $zero, TOKEN + 4	# clear TOKEN by assigning the second four elements with 0 using sw
	li $t3, 0		# reset the index of the index used for TOKEN by assigning it to 0
	jr $v1
	
RETURN:
	jr $ra

ERROR:
	b RETURN
	
search:
	initialization:
		li $t4, 0 # index for searching through the tabChar loop
	
	loop: 	
		lw $t6, tabChar($t4) # saves the value at index $t4 of tabChar to the register $t6
		beq $t6, $t8, found # if the $t6 regiter is equal to the key which is $t8 in this case then go to found
		beq $t6, 0x5c, done
		addi $t4, $t4, 8
		b loop
		
	found: 
		addi $t4, $t4, 4
		lw $s0, tabChar($t4) # assign $s0 with the character type
		b done
	
	done:
		jr 	$t5
		
printtabSym:
	la $a0, tabSymHead 
	li $v0, 4
	syscall
	
	move $t6, $ra 		# save the $ra in $t6 so when calling jr $ra there won't be errors
	
	li $t0, 0        	# index that will be used for printing through
loopSym: 
	bge $t0, $s7, doneSym	# check if $t0 is greater than or equal to $s7 which is the index for tabSym
	# storing the label in prSym
	lw $t1, tabSym($t0)	
	sw $t1, prSym
	lw $t1, tabSym+4($t0)
	sw $t1, prSym + 4
	
	# printing of the label 
	li $v0, 4
	la $a0, prSym
	syscall
	
	li $v0, 4
	la $a0, spaces
	syscall
	
	li $v0, 4
	la $a0, zeroX
	syscall
	
	# storing the value of the location in prLoc
	lw $a0, tabSym+8($t0)
	jal hex2char		# call of hex2char for LOC
	sw $v0, prLoc
	
	# printing the value of LOC
	li $v0, 4
	la $a0, prLoc
	syscall
	
	li $v0, 4
	la $a0, spaces
	syscall
	
	li $v0, 4
	la $a0, zeroX
	syscall
	
	lw $t1, tabSym+12($t0)		# loading the flag(DEFN) of the label into $t1
	
	# printing the flag(DEFN)
	li $v0, 1
	move $a0, $t1
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	addi $t0, $t0, 16
	b loopSym
	
doneSym:
	move $ra, $t6
	jr $ra
	
	
		
	   
# the same code as from h.w 3 except a slight change with b newLine instead of jr $ra
clearInBuf:
	li $t6, 80 # start  the index at 80 and instead of incrementing, it decrements
	loop1:
		addi $t6, $t6, -1 # first index become 79
		sb $zero inBuf($t6) # stores a 0 
		bnez $t6 loop1 # if the index is not 0 then it goes back to the loop otherwise it exits
		jr $ra # then branch to newLine
cleartabToken:
	li $t6, 60 # start the index at 60 and instead of incrementing, it decrements
	loop2:
		addi $t6, $t6, -4 # first index becomes 59
		sw $zero inBuf($t6) # stores a 0 
		bnez $t6 loop2 # if the index is not 0 then it goes back to the loop otherwise it exits
		jr $ra # then branch to newLine
		
exit:	li $v0, 10
	syscall
	
	
# this code for getLine is from homework 3
	.data
prompt:	.asciiz	"enter a new input string! \n"

	.text	
getLine: 
	la	$a0, prompt		# Prompt to enter a new line
	li	$v0, 4
	syscall

	la	$a0, inBuf		# read a new line
	li	$a1, 80	
	li	$v0, 8
	syscall
	
	jr $ra
	
	
# 	hex2char:
#	    Function used to print a hex value into ASCII string.
#	    Convert a hex in $a0 to char hex in $v0 (0x6b6a in $a0, $v0 should have 'a''6''b''6')
#
#	    4-bit mask slides from right to left in $a0.
#		As corresponding char is collected into $v0,
#		$a0 is shifted right by four bits for the next hex digit in the last four bits
#
#	Make it sure that you are handling nested function calls in return addresses
#
		.data
saveReg:	.word	0:3

		.text
hex2char:
		# save registers
		sw	$t0, saveReg($0)	# hex digit to process
		sw	$t1, saveReg+4($0)	# 4-bit mask
		sw	$t9, saveReg+8($0)

		# initialize registers
		li	$t1, 0x0000000f	# $t1: mask of 4 bits
		li	$t9, 3			# $t9: counter limit

nibble2char:
		and 	$t0, $a0, $t1		# $t0 = least significant 4 bits of $a0

		# convert 4-bit number to hex char
		bgt	$t0, 9, hex_alpha	# if ($t0 > 9) goto alpha
		# hex char '0' to '9'
		addi	$t0, $t0, 0x30		# convert to hex digit
		b	collect

hex_alpha:
		addi	$t0, $t0, -10		# subtract hex # "A"
		addi	$t0, $t0, 0x61		# convert to hex char, a..f

		# save converted hex char to $v0
collect:
		sll	$v0, $v0, 8		# make a room for a new hex char
		or	$v0, $v0, $t0		# collect the new hex char

		# loop counter bookkeeping
		srl	$a0, $a0, 4		# right shift $a0 for the next digit
		addi	$t9, $t9, -1		# $t9--
		bgez	$t9, nibble2char

		# restore registers
		lw	$t0, saveReg($0)
		lw	$t1, saveReg+4($0)
		lw	$t9, saveReg+8($0)
		jr	$ra
	
		
.data

tabState:
Q0:     .word  ACT1
        .word  Q1   # T1
        .word  Q1   # T2
        .word  Q1   # T3
        .word  Q1   # T4
        .word  Q1   # T5
        .word  Q1   # T6
        .word  Q11  # T7

Q1:     .word  ACT2
        .word  Q2   # T1
        .word  Q5   # T2
        .word  Q3   # T3
        .word  Q3   # T4
        .word  Q4   # T5
        .word  Q0   # T6
        .word  Q11  # T7

Q2:     .word  ACT1
        .word  Q6   # T1
        .word  Q7   # T2
        .word  Q7   # T3
        .word  Q7   # T4
        .word  Q7   # T5
        .word  Q7   # T6
        .word  Q11  # T7

Q3:     .word  ACT4
        .word  Q0   # T1
        .word  Q0   # T2
        .word  Q0   # T3
        .word  Q0   # T4
        .word  Q0   # T5
        .word  Q0   # T6
        .word  Q11  # T7

Q4:     .word  ACT4
        .word  Q10  # T1
        .word  Q10  # T2
        .word  Q10  # T3
        .word  Q10  # T4
        .word  Q10  # T5
        .word  Q10  # T6
        .word  Q11  # T7

Q5:     .word  ACT1
        .word  Q8   # T1
        .word  Q8   # T2
        .word  Q9   # T3
        .word  Q9   # T4
        .word  Q9   # T5
        .word  Q9   # T6
        .word  Q11  # T7

Q6:     .word  ACT3
        .word  Q2   # T1
        .word  Q2   # T2
        .word  Q2   # T3
        .word  Q2   # T4
        .word  Q2   # T5
        .word  Q2   # T6
        .word  Q11  # T7

Q7:     .word  ACT4
        .word  Q1   # T1
        .word  Q1   # T2
        .word  Q1   # T3
        .word  Q1   # T4
        .word  Q1   # T5
        .word  Q1   # T6
        .word  Q11  # T7

Q8:     .word  ACT3
        .word  Q5   # T1
        .word  Q5   # T2
        .word  Q5   # T3
        .word  Q5   # T4
        .word  Q5   # T5
        .word  Q5   # T6
        .word  Q11  # T7

Q9:     .word  ACT4
        .word  Q1  # T1
        .word  Q1  # T2
        .word  Q1  # T3
        .word  Q1  # T4
        .word  Q1  # T5
        .word  Q1  # T6
        .word  Q11 # T7

Q10:	.word	RETURN
        .word  Q10  # T1
        .word  Q10  # T2
        .word  Q10  # T3
        .word  Q10  # T4
        .word  Q10  # T5
        .word  Q10  # T6
        .word  Q11  # T7

Q11:    .word  ERROR 
	.word  Q4  # T1
	.word  Q4  # T2
	.word  Q4  # T3
	.word  Q4  # T4
	.word  Q4  # T5
	.word  Q4  # T6
	.word  Q4  # T7

tabChar: 
	.word 	'\n', 5		# LF
	.word 	' ', 6
 	.word 	'#', 5
	.word 	'$', 2
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

	.word	'\\', -1	



