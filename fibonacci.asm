;;; A simple program that calculates the 7th fibonacci number

	.Code

;;; The entry point.
__start:

	;; Initialize the stack at the limit.
	COPY	%SP	*+limit

	COPY	%G1	2

not_doneo:	
	BEQ	+doneo	%G1	7
	ADDUS	%G2	*+x	*+y
	COPY	*+y	*+x
	COPY	*+x	%G2
	ADDUS	%G1	%G1	1
	JUMP	+not_doneo

doneo:	COPY	%G5	*+x

	HALT
	
	.Numeric

	;; The source values to be added.
x:	1
y:	1

	;; Assume (at least) a 16 KB main memory.
limit:	0x5000
