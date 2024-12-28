.macro enter size
	stmg	%r3, %r15, 24(%r15)		# Store r3 to r15 in stack
	lay	%r15, -(160+\size)(%r15)	# r15 = r15 - (160 + size)
.endm

.macro leave size
	lay	%r15, (160+\size)(%r15)		# r15 = r15 + (160 + size)
	lmg	%r3, %r15, 24(%r15)			# Restore r3 to r15
.endm

.macro ret
	br	%r14
.endm

.macro call func
	brasl	%r14, \func
.endm

.macro print_long
	enter	0						# Save registers for calling printf (Saving volatile registers is the point)
	larl	%r2, pif				# Load relative long address of pif in r2 (first argument)
	call	printf					# Call printf
	leave	0						# Restore registers from stack
.endm

.macro read_long
	enter	8						# Save registers like above, allocate more 8 bytes to declare local variable
	larl	%r2, rif				# Load relative long long address of rif in r2
	lay		%r3, 160(%r15)			# Load address of declared local variable in r3 (like &variable in scanf in C)
	call	scanf					
	lg		%r2, 160(%r15)			# Load value of local variable in r2 (the input of user)
	leave	8						# Restore registers like above, and unallocate local variable
.endm

.data
.align 8
rif:	.asciz	"%ld"
.align 8
pif:	.asciz	"Quotient = %ld\nRemainder = %ld\n"
.align 8

.text
.global main

main:
	enter	0	
	
#Single:
	read_long			# Read a long from user and store it in r2
	lgr		%r3, %r2	# Save r2 in r3
	read_long			# Read a long from user and store it in r2
	lgr		%r4, %r2	# save r2 in r4 (first input in r3, second input in r4)
	dsgr	%r2, %r4	# R3 / R4 , Quotient in R3, Remainder in R2
	lgr		%r4, %r2	# Save remainder in r4
	print_long			# Print quotient (it is in r3 by default, second argument), remainder (it is in r4, third argument)

	leave	0
 	xgr	%r2, %r2
	ret
