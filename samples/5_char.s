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

.macro	read_char
	enter	8
	larl	%r2, rcf
	lay	%r3, 167(%r15)
	call	scanf
	lb	%r2, 167(%r15)
	leave	8
.endm

.macro print_char
	enter	0
	larl	%r2, pcf
	call	printf
	leave	0
.endm

.data
.align 8
rcf:	.asciz	"%c"
.align 8
pcf:	.asciz	"%c"
.align 8

input:	.space	100

.text
.global main

main:
	enter	0

	larl	%r6, input
get_input:
	read_char
	cfi		%r2, '\n'		# Compare lower 32bit of r2 with \n ascii
	je		print_output
	cfi		%r2, 96			# Compare lower 32bit of r2 with 96 (ascii a - 1)
	jh		store			# If r2 greater than 96, jump to store

	afi		%r2, 32			# Add lower 32bit of r2 with 32 (to convert capital letters into small letters)
store:
	stc		%r2, 0(%r6)		# Store lower 8bit (size of character) of r2 in input[i]
	agfi	%r6, 1			# Go to the next index of input (i++)
	j		get_input

print_output:
	larl	%r7, input
print_loop:
	lgb		%r3, 0(%r7)		# Load 8bit from input[j] into r3
	print_char				
	agfi	%r7, 1			# Go to the next index of input (j++)
	clgr	%r6, %r7		# Compare r6 and r7 (compare j with last index)
	jne		print_loop

	lgfi	%r3, '\n'
	print_char

	leave	0
	ret
