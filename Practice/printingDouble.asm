.data
	myE: .double 2.178  
	zeroDouble: .double 0.0
.text
	ldc1 $f2, myE # ldc1 is going to get a double from the RAM and place it in a pair of registers because a double is 64-bit so two registers are needed to hold a double
	ldc1 $f0, zeroDouble
	
	li $v0, 3 # 3 lets the system know to get ready to print a double 
	add.d $f12, $f2, $f0 # $f12 is used for both floats and doubles, this line adds $f0 and $f2 and stores teh value of that in $f12
	syscall
	
