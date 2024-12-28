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

.macro print_float
	enter	0
	larl	%r2, pff
	call	printf
	leave	0
.endm


# This macro read float and store it into memory at given label
# and doesn't return value with registers
.macro read_float label
	enter	0
	larl	%r2, rff
	larl	%r3, \label
	call	scanf
	leave	0
.endm

.data
.align 8
rff:	.asciz	"%lf"
.align 8
pff:	.asciz	"%.2lf\n"
.align 8

num1:	.space	8
num2:	.space	8

.text
.global main

main:
	enter	0

	read_float num1
	read_float num2

# Sum of two floating point numbers in f registers
	larl	%r6, num1
	ld	%f0, 0(%r6)		# Load double precision floating point from memory into f0 (f0 <- num1)
	ld	%f1, 8(%r6)		# f1 <- num2
	adbr	%f0, %f1	# f0 = f0 + f1
	print_float

# Sum of two floating point numbers in register and memory
	larl	%r6, num1
	ld	%f0, 0(%r6)		# f0 <- num1 
	adb	%f0, 8(%r6)		# f0 = f0 + num2 (register indirect)
	print_float

# Subtraction of two floating point numbers in f registers
	larl	%r6, num1
	ld	%f0, 0(%r6)		# f0 <- num1
	ld	%f1, 8(%r6)		# f1 <- num2
	sdbr	%f0, %f1	# f0 = f0 - f1
	print_float

# Subtraction of two floating point numbers in register and memory
	larl	%r6, num1
	ld	%f0, 0(%r6)		# f0 <- num1
	sdb	%f0, 8(%r6)		# f0 = f0 - num2 (register indirect)
	print_float

# Multiplication of two floating point numbers in f registers
	larl	%r6, num1
	ld	%f0, 0(%r6)		# f0 <- num1
	ld	%f1, 8(%r6)		# f1 <- num2
	mdbr	%f0, %f1	# f0 = f0 * f1
	print_float

# Multiplication of two floating point numbers in register and memory
	larl	%r6, num1
	ld	%f0, 0(%r6)		# f0 <- num1
	mdb	%f0, 8(%r6)		# f0 = f0 * num2 (register indirect)
	print_float

# Dividing two floating point numbers in f registers
	larl	%r6, num1
	ld	%f0, 0(%r6)		# f0 <- num1
	ld	%f1, 8(%r6)		# f1 <- num2
	ddbr	%f0, %f1	# f0 = f0 / f1
	print_float

# Dividing two floating point numbers in register and memory
	larl	%r6, num1
	ld	%f0, 0(%r6)		# f0 <- num1
	ddb	%f0, 8(%r6)		# f0 = f0 / num2 (register indirect)
	print_float

# Negative a floating point number
	larl	%r6, num1
	ld	%f0, 0(%r6)		# f0 <- num1
	lndbr	%f0, %f0	# f0 = -f0
	print_float

# Square root of a floating point number in register
	larl	%r6, num1
	ld	%f0, 0(%r6)		# f0 <- num1
	sqdbr	%f0, %f0	# f0 = sqrt(f0)
	print_float

# Square root of a floating point number in memory
	larl	%r6, num1
	sqdb	%f0, 0(%r6)	# f0 = sqrt(num1) (register indirect)
	print_float

	leave	0
 	xgr	%r2, %r2
	ret
