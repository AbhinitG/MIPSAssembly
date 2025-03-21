.data
	PI: .float 3.14596 # .float is used for floats 
.text
	li $v0, 2 # 2 is used for printing out floats
	# always have to put the value of the float in $f12 otherwise it's not going to work
	lwc1 $f12, PI # lwc1 is used for floats becuase Coproc 1(Codeprocessor 1) has all the registers for floats
	syscall