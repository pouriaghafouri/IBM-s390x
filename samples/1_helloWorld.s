.macro enter
	stmg	%r6, %r15, 48(%r15)	# Store r6 to r15 in stack
	lay	%r15, -160(%r15)		# r15 = r15 - 160 (r15 = Stack Pointer) 
.endm

.macro leave
	lay	%r15, 160(%r15)			# r15 = r15 + 160
	lmg	%r6, %r15, 48(%r15)		# Restore r6 - r15
.endm

.macro ret
	br	%r14
.endm

.macro call func
	brasl	%r14, \func
.endm

.data
hello_world:	.asciz	"Hello World!\n"

.text
.global main

main:
	enter						# Save r6 to r15 to stack
	
	larl	%r2, hello_world	# Load relative long address of hello_world to r2
	call	printf				# Call printf (using libc)

	leave						# Restore r6 to r15 from stack
 	xgr	%r2, %r2
	ret							# return (like jr $ra in MIPS)

