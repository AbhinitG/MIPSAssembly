.data
inBuf:	.byte	0:80

.text
main: 
	jal 	getLine
	lb	$t0, inBuf  
	beq	$t0, '#', exit 		# check if the first input of the array is a # in which case it would exit the program
	jal  	tokenSetUp
	jal 	printToken
	jal 	clearInBuf
	b 	main
	
# this function will initialize the the different indexes that will be used to loop the program to 0
tokenSetUp:
	li 	$t2, 0  		# $t2 will be used as the register for the inBuf index
	li 	$t3, 0 			# $t3 will be used as TOKEN's index and is here set to 0.
	li 	$a3, 0 			# setting $a3 which will be the index used for token table to 0.
	la	$s1, Q0
	li	$s0, 1
nextState:	
	lw	$s2, 0($s1)
	jalr	$v1, $s2	# Save return addr in $v1

	sll	$s0, $s0, 2	# Multiply by 4 for word boundary
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


#######################################################################
#
#  printToken:
#	print Token table header
#	copy each entry of tabToken into prToken and print TOKEN
#
#	in Main(), $a3 has the index to tabToken in 12 bytes per entry
#			for the byte offset to the last entry of tabToken
#
########################################################################
		.data
prToken:	.word	0:3			# space to copy one token at a time
tableHead:	.asciiz "TOKEN    TYPE\n"

		.text
printToken:
		la	$a0, tableHead		# print table heading
		li	$v0, 4
		syscall

		# copy 2-word token from tabToken into prToken
		#  run through prToken, and replace 0 (Null) by ' ' (0x20)
		#  so that printing does not terminate prematurely
		li	$t0, 0
loopTok:	bge	$t0, $a3, donePrTok	# if ($t0 <= $a3)
	
		lw	$t1, tabToken($t0)	#   copy tabTok[] into prTok
		sw	$t1, prToken
		lw	$t1, tabToken+4($t0)
		sw	$t1, prToken+4
	
		li	$t7, 0x20		# blank in $t7
		li	$t9, -1			# for each char in prTok
loopChar:	addi	$t9, $t9, 1
		bge	$t9, 8, tokType		
		lb	$t8, prToken($t9)		#   if char == Null
		bne	$t8, $zero, loopChar	
		sb	$t7, prToken($t9)		#  replace it by ' ' (0x20)
		b	loopChar

		# to print type, use four bytes: ' ', char(type), '\n', and Null
		#  in order to print the ASCII type and newline
tokType:
		li	$t6, '\n'			# newline in $t6
		sb	$t7, prToken+8
		#sb	$t7, prToken+9
		lb	$t1, tabToken+8($t0)
		addi	$t1, $t1, 0x30		# ASCII(token type)
		sb	$t1, prToken+9
		sb	$t6, prToken+10		# terminate with '\n'
		sb	$0, prToken+11
		
		la	$a0, prToken		# print token and its type
		li	$v0, 4
		syscall
	
		addi	$t0, $t0, 12
		sw	$0, prToken		# clear prToken
		sw	$0, prToken+4
		b	loopTok

donePrTok:
		jr	$ra

				

# the same code as from h.w 3 except a slight change with b newLine instead of jr $ra
clearInBuf:
	li $t6, 80 # start  the index at 80 and instead of incrementing, it decrements
	loop1:
		addi $t6, $t6, -1 # first index become 79
		sb $zero inBuf($t6) # stores a 0 
		bnez $t6 loop1 # if the index is not 0 then it goes back to the loop otherwise it exits
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
	

	
#=========== State table to be copied into a data segment

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

	.word	'\\', -1	

tabToken: .word 0:60


TOKEN: .byte 0:8
	

