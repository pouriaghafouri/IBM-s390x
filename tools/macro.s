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

.macro print_long	# Output is in r3
	enter	0
	larl	%r2, pif
	call	printf
	leave	0
.endm

.macro read_long	# Input is in r2
	enter	8
	larl	%r2, rif
	lay	%r3, 160(%r15)
	call	scanf
	lg	%r2, 160(%r15)
	leave	8
.endm

.macro read_string label	# Input is stored in the label
	enter	0
	larl	%r2, rsf
	larl	%r3, \label
	call	scanf
	leave	0
.endm

.macro print_string label	# Output is in the label
	enter	0
	larl	%r3, \label
	larl	%r2, psf
	call	printf
	leave	0
.endm

.macro	read_char	# Input is in r2
	enter	8
	larl	%r2, rcf
	lay	%r3, 167(%r15)
	call	scanf
	lb	%r2, 167(%r15)
	leave	8
.endm

.macro print_char	# Output is in r3
	enter	0
	larl	%r2, pcf
	call	printf
	leave	0
.endm

.data
.align 8
rif:	.asciz	"%ld"
.align 8
pif:	.asciz	"%ld"
.align 8
rsf:	.asciz	"%s"
.align 8
psf:	.asciz	"%s"
.align 8
rcf:	.asciz	"%c"
.align 8
pcf:	.asciz	"%c"
.align 8

.text
.global main

main:
	enter	0	
	
	
	leave	0
 	xgr	%r2, %r2
	ret
