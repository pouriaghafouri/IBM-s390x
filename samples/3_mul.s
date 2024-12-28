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

.macro print_hex
	enter	0
	larl	%r2, phf
	call	printf
	leave	0
.endm

.data
.align 8
rif:	.asciz	"%ld"
.align 8
pif:	.asciz	"%ld\n"
.align 8
phf:	.asciz	"%.16lx\n"
.align	8

.text
.global main

main:
	enter	0
#Singles:

	# R3 = R3 * Immediate
	lgfi	%r3, -2			# Load -2 in r3 (64bit sign-extended)
	msgfi	%r3, 2147483647	# Multiply 64bit sign-extended immediate by r3 and store the 64bit result in r3 (the immediate is 32bit by default)
	print_long
		
	# R3 = R3 * R1 (64bit <- 64bit * 64bit)
	lgfi	%r3, 2			# Load 2 in r3 (64bit sign-extended)
	lgfi	%r1, -8			# Load -8 in r1 //
	msgr	%r3, %r1		# r3 = r3 * r1
	print_long
	
#Doubles:

	# R2:R3 = R3 * R4 (Lower half of result in first 32bit of R3,
	# Upper half of result in first 32bit of R2)
	lgfi	%r3, 10			# Load 10 in r3
	lgfi	%r4, -1			# Load -1 in r4
	mr		%r2, %r4		# 
	lgr		%r6, %r2		# Load 64bit of r2 to r6 (r6 is a tmp register to save r2)
	print_hex				# Print r3 (least significant 32bit of the result)
	lgr		%r3, %r6		# restore the value of r2 (which was stored in r6) to print it
	print_hex				# Print r3 (now it's most significant 32bit of the result)

	leave	0
 	xgr	%r2, %r2
	ret
