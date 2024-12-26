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

.data
.align 8
rif:	.asciz	"%ld"
.align 8
pif:	.asciz	"%ld\n"
.align 8

.text
.global main

factorial:
	stg	%r14, 120(%r15)	 # Save the return address (r14)

	cgfi	%r2, 0		 # Check if r2 is 0 (base condition)
	je	end_recursion

	stg	%r2, 16(%r15)	 # Save the current value of r2
	lay	%r15, -160(%r15) # Allocate stack for calling recursive function

	agfi	%r2, -1		 # Decrement r2
	call	factorial	 # Call factorial function recursively

	lay	%r15, 160(%r15)	 # Disallocate stack of called function
	msg	%r2, 16(%r15)	 # Multiply the returned result with the saved value of r2 in stack (64bit)

	lg	%r14, 120(%r15)	 # Restore the saved return address
	ret
end_recursion:
	lgfi	%r2, 1		 # Return 1 when r2 is 0 (base condition)

	lg	%r14, 120(%r15)	 # Restore the saved return address
	ret


main:
	enter	0           # save registers and allocate stack for calling any function inside main

	read_long
	call	factorial
	lgr	%r3, %r2		# Load the return value of factorial into r3 to print it
	print_long

	leave	0
	ret
