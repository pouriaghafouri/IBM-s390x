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
pif:	.asciz	"%ld "
.align 8
pcf:	.asciz	"%c"
.align 8

size:	.zero	8
array:	.zero	8000

.text
.global main

main:
	enter	0	
	
	read_long
	stgrl	%r2, size	# store the size of array in size variable
	larl	%r6, array	# save the relative address of array to R6
	xgr		%r7, %r7
get_array:
	cgrl	%r7, size	# compare R7 with size (64bit)
	je		print_array
	read_long
	stg		%r2, 0(%r6)	# store the input data in array[i]
	agfi	%r6, 8		# Increase the address pointer because each element is 8byte
	agfi	%r7, 1		# i++
	j	get_array

print_array:
	agfi	%r6, -8
	agfi	%r7, -1
	cgfi	%r7, -1		# compare R7 with -1 (64bit)
	je		end
	lg		%r3, 0(%r6)	# load array[i] in R3
	print_long
	j		print_array
end:
	lgfi	%r3, '\n'
	larl	%r2, pcf
	call	printf
	
	leave	0
 	xgr	%r2, %r2
	ret
