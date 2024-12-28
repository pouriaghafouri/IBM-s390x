.macro enter size
	stmg	%r6, %r15, 48(%r15)
	lay	%r15, -(160+\size)(%r15)
.endm

.macro leave size
	lay	%r15, (160+\size)(%r15)
	lmg	%r6, %r15, 48(%r15)
.endm

.macro ret
	br	%r14
.endm

.macro call func
	brasl	%r14, \func
.endm

.macro print_long
	enter	0
	larl	%r2, pif
	call	printf
	leave	0
.endm

.macro read_long
	enter	8
	larl	%r2, rif
	lay	%r3, 160(%r15)
	call	scanf
	lg	%r2, 160(%r15)
	leave	8
.endm

.macro	read_char
	enter	8			# Save registers, allocate more 8 bytes to declare local variables (8 local variables because each character is 1 byte)
	larl	%r2, rcf	
	lay	%r3, 166(%r15)	# Load the address of first char variable (which will be \n) for redundant white space ignoring
	lay	%r4, 167(%r15)	# Load the address of second char variable (which will be the input character)
	call	scanf		
	lb	%r2, 167(%r15)	# Load the value of second char variable in r2 (32bit sign-extended, upper 32bit of register is unused)
	leave	8
.endm

.data
.align 8
rif:	.asciz	"%ld"
.align 8
pif:	.asciz	"%ld\n"
.align 8 
rcf:	.asciz	"%c%c"
.align 8

#.set	sa, 1			# It's like define in C, you can use 
.align 8
num1:	.space	8		# Allocate 8 byte
num2:	.space	8		# Allocate 8 byte
zero:	.quad	0		# Define 64bit 0
	.quad	-1			# Define 64bit -1

.text
.global main

main:
	enter	0	
	
	read_long
	stgrl	%r2, num1	# Save 64bit value of r2 in num1 (first user input)
	read_char			
	lgfr	%r6, %r2	# Save the user input character in r6
	read_long			
	stgrl	%r2, num2	# Save 64bit value of r2 in num2 (second user input)

	lgfi	%r7, 4		# Load 64bit sign-extended 4 in r7
	ngr	%r6, %r7		# Logical And r6, r7 (64bit)
	sll	%r6, 1			# Shift the value in r6 logically to the left (input character == + then r6 = 0, else then r6 = 8)

	larl	%r3, zero	
	lg	%r3, 0(%r3, %r6) # Load 0 (if input character is +) in r3, Load 1 (if input character is -)
	
	lgrl	%r2, num2	
	xgr	%r2, %r3		# XOR 64 bit r2 with r3 (r2 xor -1 if character is -)
	sgr	%r2, %r3		# r2 = r2 - r3
	# r2 = -num2 if character is -, r2 = num2 if character is +

	lgrl	%r3, num1
	agr	%r3, %r2		# r3 = r3 + r2 = num2 + (num1 or -num1)
	print_long
	
	leave	0
 	xgr	%r2, %r2
	ret
