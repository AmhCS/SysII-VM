;;; Stub code

	.Code

	;; The kernel will have placed the process's allocation size (i.e., its virtual limit) in %SP, thus initializing the stack.
	;; Initialize fp.
	COPY		%FP		%SP				; fp = sp

	;; Call main() to enter the program proper.
	SUBUS		%SP		%SP		12		; Push: pfp / ra / rv
	COPY		*%SP		%FP				; pfp = fp
	COPY		%FP		%SP				; fp = sp
	ADDUS		%G0		%FP		4		; %G0 = &ra
	CALL		+_procedure_main		*%G0		; Call main().

	;; Exit, copying the return value from main() as the result code.
	ADDUS		%SP		%SP		4		; Pop: pfp / ra; push: syscall 
	COPY		*%SP		0x1001				; syscall 
	SYSC

	.Code

	;; Procedure entry point
_procedure_=:
	;; Callee for =: (prologue) Push locals
	SUBUS		%SP		%SP		0		; Push locals

	;; Start begin-end statement
	;; Statement #0 of begin-end statement
	;; A literal assembly injection
	      ADDUS	 %G0	%FP	4	; %G0 = &value
       COPY	 %G1	*%FP		; %G1 = destination
	      COPY	 *%G1	*%G0		; *destination = value
	;; Statement #1 of begin-end statement
	;; Return statement 11 from =: (a) Evaluate the expression and prepare the destination
	;; Dereference #10: Prelude -- evaluate the src pointer
	;; Identifier evaluation: destination

	;; Evaluate dynamic variable destination
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		0		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	COPY		%G0		*%SP				; %G0 = src
	ADDUS		%SP		%SP		4		; Pop src pointer
	SUBUS		%SP		%SP		4		; Push dst space
	COPY		*%SP		*%G0				; *dst = *src
	;; Return statement 11 from =: (b) Copy single-word return value into place
	COPY		*%G0		*%SP				; Copy expression result into rv
	ADDUS		%SP		%SP		4		; Pop expression result
	;; Return statement 11 from =: (c) Jump to callee epilogue, since return statements take effect immediately
	JUMP		+_procedure_=_epilogue						; Return to caller
_procedure_=_epilogue:
	;; Callee for =: (epilogue) Pop locals and return

	COPY		%SP		%FP				; Pop locals and temp results
	ADDUS		%G0		%FP		12		; %G0 = &ra
	JUMP		*%G0						; Return to caller

	;; Procedure entry point
_procedure_bitand:
	;; Callee for bitand: (prologue) Push locals
	SUBUS		%SP		%SP		4		; Push locals

	;; Start begin-end statement
	;; Statement #0 of begin-end statement
	;; A literal assembly injection
	      ADDUS	 %G0	%FP	-4	; %G0 = &result
       ADDUS	 %G1	%FP	4	; %G1 = &y
	      AND	 *%G0	*%FP	*%G1	; result = x & y
	;; Statement #1 of begin-end statement
	;; Return statement 23 from bitand: (a) Evaluate the expression and prepare the destination
	;; Identifier evaluation: result

	;; Evaluate dynamic variable result
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		-4		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Return statement 23 from bitand: (b) Copy single-word return value into place
	COPY		*%G0		*%SP				; Copy expression result into rv
	ADDUS		%SP		%SP		4		; Pop expression result
	;; Return statement 23 from bitand: (c) Jump to callee epilogue, since return statements take effect immediately
	JUMP		+_procedure_bitand_epilogue						; Return to caller
_procedure_bitand_epilogue:
	;; Callee for bitand: (epilogue) Pop locals and return

	COPY		%SP		%FP				; Pop locals and temp results
	ADDUS		%G0		%FP		12		; %G0 = &ra
	JUMP		*%G0						; Return to caller

	;; Procedure entry point
_procedure_bitor:
	;; Callee for bitor: (prologue) Push locals
	SUBUS		%SP		%SP		4		; Push locals

	;; Start begin-end statement
	;; Statement #0 of begin-end statement
	;; A literal assembly injection
	      ADDUS	 %G0	%FP	-4	; %G0 = &result
       ADDUS	 %G1	%FP	4	; %G1 = &y
	      OR	 *%G0	*%FP	*%G1	; result = x | y
	;; Statement #1 of begin-end statement
	;; Return statement 35 from bitor: (a) Evaluate the expression and prepare the destination
	;; Identifier evaluation: result

	;; Evaluate dynamic variable result
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		-4		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Return statement 35 from bitor: (b) Copy single-word return value into place
	COPY		*%G0		*%SP				; Copy expression result into rv
	ADDUS		%SP		%SP		4		; Pop expression result
	;; Return statement 35 from bitor: (c) Jump to callee epilogue, since return statements take effect immediately
	JUMP		+_procedure_bitor_epilogue						; Return to caller
_procedure_bitor_epilogue:
	;; Callee for bitor: (epilogue) Pop locals and return

	COPY		%SP		%FP				; Pop locals and temp results
	ADDUS		%G0		%FP		12		; %G0 = &ra
	JUMP		*%G0						; Return to caller

	;; Procedure entry point
_procedure_bitnot:
	;; Callee for bitnot: (prologue) Push locals
	SUBUS		%SP		%SP		4		; Push locals

	;; Start begin-end statement
	;; Statement #0 of begin-end statement
	;; A literal assembly injection
	      ADDUS	 %G0	%FP	-4	; %G0 = &result
	      NOT	 *%G0	*%FP		; result = ~x
	;; Statement #1 of begin-end statement
	;; Return statement 45 from bitnot: (a) Evaluate the expression and prepare the destination
	;; Identifier evaluation: result

	;; Evaluate dynamic variable result
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		-4		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Return statement 45 from bitnot: (b) Copy single-word return value into place
	COPY		*%G0		*%SP				; Copy expression result into rv
	ADDUS		%SP		%SP		4		; Pop expression result
	;; Return statement 45 from bitnot: (c) Jump to callee epilogue, since return statements take effect immediately
	JUMP		+_procedure_bitnot_epilogue						; Return to caller
_procedure_bitnot_epilogue:
	;; Callee for bitnot: (epilogue) Pop locals and return

	COPY		%SP		%FP				; Pop locals and temp results
	ADDUS		%G0		%FP		8		; %G0 = &ra
	JUMP		*%G0						; Return to caller

	;; Procedure entry point
_procedure_<<:
	;; Callee for <<: (prologue) Push locals
	SUBUS		%SP		%SP		4		; Push locals

	;; Start begin-end statement
	;; Statement #0 of begin-end statement
	;; A literal assembly injection
	      ADDUS	 %G0	%FP	-4	; %G0 = &result
       ADDUS	 %G1	%FP	4	; %G1 = &y
	      SHFTL	 *%G0	*%FP	*%G1	; result = x << y
	;; Statement #1 of begin-end statement
	;; Return statement 57 from <<: (a) Evaluate the expression and prepare the destination
	;; Identifier evaluation: result

	;; Evaluate dynamic variable result
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		-4		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Return statement 57 from <<: (b) Copy single-word return value into place
	COPY		*%G0		*%SP				; Copy expression result into rv
	ADDUS		%SP		%SP		4		; Pop expression result
	;; Return statement 57 from <<: (c) Jump to callee epilogue, since return statements take effect immediately
	JUMP		+_procedure_<<_epilogue						; Return to caller
_procedure_<<_epilogue:
	;; Callee for <<: (epilogue) Pop locals and return

	COPY		%SP		%FP				; Pop locals and temp results
	ADDUS		%G0		%FP		12		; %G0 = &ra
	JUMP		*%G0						; Return to caller

	;; Procedure entry point
_procedure_>>:
	;; Callee for >>: (prologue) Push locals
	SUBUS		%SP		%SP		4		; Push locals

	;; Start begin-end statement
	;; Statement #0 of begin-end statement
	;; A literal assembly injection
	      ADDUS	 %G0	%FP	-4	; %G0 = &result
       ADDUS	 %G1	%FP	4	; %G1 = &y
	      SHFTR	 *%G0	*%FP	*%G1	; result = x << y
	;; Statement #1 of begin-end statement
	;; Return statement 69 from >>: (a) Evaluate the expression and prepare the destination
	;; Identifier evaluation: result

	;; Evaluate dynamic variable result
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		-4		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Return statement 69 from >>: (b) Copy single-word return value into place
	COPY		*%G0		*%SP				; Copy expression result into rv
	ADDUS		%SP		%SP		4		; Pop expression result
	;; Return statement 69 from >>: (c) Jump to callee epilogue, since return statements take effect immediately
	JUMP		+_procedure_>>_epilogue						; Return to caller
_procedure_>>_epilogue:
	;; Callee for >>: (epilogue) Pop locals and return

	COPY		%SP		%FP				; Pop locals and temp results
	ADDUS		%G0		%FP		12		; %G0 = &ra
	JUMP		*%G0						; Return to caller

	;; Procedure entry point
_procedure_and:
	;; Callee for and: (prologue) Push locals
	SUBUS		%SP		%SP		0		; Push locals

	;; Start begin-end statement
	;; Statement #0 of begin-end statement
	;; If-then 90: (a) Evaluate the conditional expression, leaving its result on top of the stack
	;; Call to !=: (prologue a) Create base of caller frame segment
	SUBUS		%SP		%SP		12		; Push pfp/ra[/rv] spaces
	;; Call to !=: (prologue b) Evaluate and push arguments
	;; Call to !=:   Argument #1
	;; Push integer value 0 onto stack
	SUBUS		%SP		%SP		4		; Push word space
	COPY		*%SP		0				; Copy the value

	;; Call to !=:   Argument #0
	;; Identifier evaluation: x

	;; Evaluate dynamic variable x
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		0		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Call to !=: (prologue c) Preserve and update frame pointer
	ADDUS		%G0		%SP		8		; %G0 = &pfp
	COPY		*%G0		%FP				; pfp = %FP
	COPY		%FP		%SP				; %FP = %SP
	;; Call to !=
	ADDUS		%G0		%SP		12		; %G0 = &ra
	CALL		+_procedure_!=		*%G0				; Do call
	;; Call to !=: (epilogue a) Restore FP
	ADDUS		%G0		%FP		8		; %G0 = &pfp
	COPY		%FP		*%G0				; Restore FP
	;; Call to !=: (epilogue b) Pop all but rv
	ADDUS		%SP		%SP		16		; Pop args/pfp/ra
	;; If-then 90: (b) Pop conditional result and branch (or not)
	COPY		%G0		*%SP				; %G0 = conditional result
	ADD		%SP		%SP		4		; Pop result
	BEQ		_and_branch_90_end		%G0		0		; If false, jump over then-branch
	;; If-then 90: (c) Then-branch

	;; Start begin-end statement
	;; Statement #0 of begin-end statement
	;; If-then 88: (a) Evaluate the conditional expression, leaving its result on top of the stack
	;; Call to !=: (prologue a) Create base of caller frame segment
	SUBUS		%SP		%SP		12		; Push pfp/ra[/rv] spaces
	;; Call to !=: (prologue b) Evaluate and push arguments
	;; Call to !=:   Argument #1
	;; Push integer value 0 onto stack
	SUBUS		%SP		%SP		4		; Push word space
	COPY		*%SP		0				; Copy the value

	;; Call to !=:   Argument #0
	;; Identifier evaluation: y

	;; Evaluate dynamic variable y
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		4		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Call to !=: (prologue c) Preserve and update frame pointer
	ADDUS		%G0		%SP		8		; %G0 = &pfp
	COPY		*%G0		%FP				; pfp = %FP
	COPY		%FP		%SP				; %FP = %SP
	;; Call to !=
	ADDUS		%G0		%SP		12		; %G0 = &ra
	CALL		+_procedure_!=		*%G0				; Do call
	;; Call to !=: (epilogue a) Restore FP
	ADDUS		%G0		%FP		8		; %G0 = &pfp
	COPY		%FP		*%G0				; Restore FP
	;; Call to !=: (epilogue b) Pop all but rv
	ADDUS		%SP		%SP		16		; Pop args/pfp/ra
	;; If-then 88: (b) Pop conditional result and branch (or not)
	COPY		%G0		*%SP				; %G0 = conditional result
	ADD		%SP		%SP		4		; Pop result
	BEQ		_and_branch_88_end		%G0		0		; If false, jump over then-branch
	;; If-then 88: (c) Then-branch

	;; Start begin-end statement
	;; Statement #0 of begin-end statement
	;; Return statement 86 from and: (a) Evaluate the expression and prepare the destination
	;; Push integer value 1 onto stack
	SUBUS		%SP		%SP		4		; Push word space
	COPY		*%SP		1				; Copy the value

	;; Return statement 86 from and: (b) Copy single-word return value into place
	COPY		*%G0		*%SP				; Copy expression result into rv
	ADDUS		%SP		%SP		4		; Pop expression result
	;; Return statement 86 from and: (c) Jump to callee epilogue, since return statements take effect immediately
	JUMP		+_procedure_and_epilogue						; Return to caller
	;; If-then 88: (d) End
_and_branch_88_end:
	NOOP								; Placeholder for if-then 88
	;; If-then 90: (d) End
_and_branch_90_end:
	NOOP								; Placeholder for if-then 90
	;; Statement #1 of begin-end statement
	;; Return statement 92 from and: (a) Evaluate the expression and prepare the destination
	;; Push integer value 0 onto stack
	SUBUS		%SP		%SP		4		; Push word space
	COPY		*%SP		0				; Copy the value

	;; Return statement 92 from and: (b) Copy single-word return value into place
	COPY		*%G0		*%SP				; Copy expression result into rv
	ADDUS		%SP		%SP		4		; Pop expression result
	;; Return statement 92 from and: (c) Jump to callee epilogue, since return statements take effect immediately
	JUMP		+_procedure_and_epilogue						; Return to caller
_procedure_and_epilogue:
	;; Callee for and: (epilogue) Pop locals and return

	COPY		%SP		%FP				; Pop locals and temp results
	ADDUS		%G0		%FP		12		; %G0 = &ra
	JUMP		*%G0						; Return to caller

	;; Procedure entry point
_procedure_or:
	;; Callee for or: (prologue) Push locals
	SUBUS		%SP		%SP		0		; Push locals

	;; Start begin-end statement
	;; Statement #0 of begin-end statement
	;; If-then 107: (a) Evaluate the conditional expression, leaving its result on top of the stack
	;; Call to !=: (prologue a) Create base of caller frame segment
	SUBUS		%SP		%SP		12		; Push pfp/ra[/rv] spaces
	;; Call to !=: (prologue b) Evaluate and push arguments
	;; Call to !=:   Argument #1
	;; Push integer value 0 onto stack
	SUBUS		%SP		%SP		4		; Push word space
	COPY		*%SP		0				; Copy the value

	;; Call to !=:   Argument #0
	;; Identifier evaluation: x

	;; Evaluate dynamic variable x
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		0		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Call to !=: (prologue c) Preserve and update frame pointer
	ADDUS		%G0		%SP		8		; %G0 = &pfp
	COPY		*%G0		%FP				; pfp = %FP
	COPY		%FP		%SP				; %FP = %SP
	;; Call to !=
	ADDUS		%G0		%SP		12		; %G0 = &ra
	CALL		+_procedure_!=		*%G0				; Do call
	;; Call to !=: (epilogue a) Restore FP
	ADDUS		%G0		%FP		8		; %G0 = &pfp
	COPY		%FP		*%G0				; Restore FP
	;; Call to !=: (epilogue b) Pop all but rv
	ADDUS		%SP		%SP		16		; Pop args/pfp/ra
	;; If-then 107: (b) Pop conditional result and branch (or not)
	COPY		%G0		*%SP				; %G0 = conditional result
	ADD		%SP		%SP		4		; Pop result
	BEQ		_or_branch_107_end		%G0		0		; If false, jump over then-branch
	;; If-then 107: (c) Then-branch

	;; Start begin-end statement
	;; Statement #0 of begin-end statement
	;; Return statement 105 from or: (a) Evaluate the expression and prepare the destination
	;; Push integer value 1 onto stack
	SUBUS		%SP		%SP		4		; Push word space
	COPY		*%SP		1				; Copy the value

	;; Return statement 105 from or: (b) Copy single-word return value into place
	COPY		*%G0		*%SP				; Copy expression result into rv
	ADDUS		%SP		%SP		4		; Pop expression result
	;; Return statement 105 from or: (c) Jump to callee epilogue, since return statements take effect immediately
	JUMP		+_procedure_or_epilogue						; Return to caller
	;; If-then 107: (d) End
_or_branch_107_end:
	NOOP								; Placeholder for if-then 107
	;; Statement #1 of begin-end statement
	;; If-then 115: (a) Evaluate the conditional expression, leaving its result on top of the stack
	;; Call to !=: (prologue a) Create base of caller frame segment
	SUBUS		%SP		%SP		12		; Push pfp/ra[/rv] spaces
	;; Call to !=: (prologue b) Evaluate and push arguments
	;; Call to !=:   Argument #1
	;; Push integer value 0 onto stack
	SUBUS		%SP		%SP		4		; Push word space
	COPY		*%SP		0				; Copy the value

	;; Call to !=:   Argument #0
	;; Identifier evaluation: y

	;; Evaluate dynamic variable y
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		4		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Call to !=: (prologue c) Preserve and update frame pointer
	ADDUS		%G0		%SP		8		; %G0 = &pfp
	COPY		*%G0		%FP				; pfp = %FP
	COPY		%FP		%SP				; %FP = %SP
	;; Call to !=
	ADDUS		%G0		%SP		12		; %G0 = &ra
	CALL		+_procedure_!=		*%G0				; Do call
	;; Call to !=: (epilogue a) Restore FP
	ADDUS		%G0		%FP		8		; %G0 = &pfp
	COPY		%FP		*%G0				; Restore FP
	;; Call to !=: (epilogue b) Pop all but rv
	ADDUS		%SP		%SP		16		; Pop args/pfp/ra
	;; If-then 115: (b) Pop conditional result and branch (or not)
	COPY		%G0		*%SP				; %G0 = conditional result
	ADD		%SP		%SP		4		; Pop result
	BEQ		_or_branch_115_end		%G0		0		; If false, jump over then-branch
	;; If-then 115: (c) Then-branch

	;; Start begin-end statement
	;; Statement #0 of begin-end statement
	;; Return statement 113 from or: (a) Evaluate the expression and prepare the destination
	;; Push integer value 1 onto stack
	SUBUS		%SP		%SP		4		; Push word space
	COPY		*%SP		1				; Copy the value

	;; Return statement 113 from or: (b) Copy single-word return value into place
	COPY		*%G0		*%SP				; Copy expression result into rv
	ADDUS		%SP		%SP		4		; Pop expression result
	;; Return statement 113 from or: (c) Jump to callee epilogue, since return statements take effect immediately
	JUMP		+_procedure_or_epilogue						; Return to caller
	;; If-then 115: (d) End
_or_branch_115_end:
	NOOP								; Placeholder for if-then 115
	;; Statement #2 of begin-end statement
	;; Return statement 117 from or: (a) Evaluate the expression and prepare the destination
	;; Push integer value 0 onto stack
	SUBUS		%SP		%SP		4		; Push word space
	COPY		*%SP		0				; Copy the value

	;; Return statement 117 from or: (b) Copy single-word return value into place
	COPY		*%G0		*%SP				; Copy expression result into rv
	ADDUS		%SP		%SP		4		; Pop expression result
	;; Return statement 117 from or: (c) Jump to callee epilogue, since return statements take effect immediately
	JUMP		+_procedure_or_epilogue						; Return to caller
_procedure_or_epilogue:
	;; Callee for or: (epilogue) Pop locals and return

	COPY		%SP		%FP				; Pop locals and temp results
	ADDUS		%G0		%FP		12		; %G0 = &ra
	JUMP		*%G0						; Return to caller

	;; Procedure entry point
_procedure_not:
	;; Callee for not: (prologue) Push locals
	SUBUS		%SP		%SP		0		; Push locals

	;; Start begin-end statement
	;; Statement #0 of begin-end statement
	;; If-then-else 128: (a) Evaluate the conditional expression, leaving its result on top of the stack
	;; Identifier evaluation: x

	;; Evaluate dynamic variable x
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		0		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; If-then-else 128: (b) Pop conditional result and branch (or not)
	COPY		%G0		*%SP				; %G0 = conditional result
	ADD		%SP		%SP		4		; Pop result
	BEQ		_not_branch_128_else		%G0		0		; If false, jump to else-branch
	;; If-then-else 128: (c) Then-branch
	;; Return statement 125 from not: (a) Evaluate the expression and prepare the destination
	;; Push integer value 0 onto stack
	SUBUS		%SP		%SP		4		; Push word space
	COPY		*%SP		0				; Copy the value

	;; Return statement 125 from not: (b) Copy single-word return value into place
	COPY		*%G0		*%SP				; Copy expression result into rv
	ADDUS		%SP		%SP		4		; Pop expression result
	;; Return statement 125 from not: (c) Jump to callee epilogue, since return statements take effect immediately
	JUMP		+_procedure_not_epilogue						; Return to caller
	JUMP		_not_branch_128_end						; Jump over else-branch
	;; If-then-else128: (d) Else-branch
_not_branch_128_else:
	;; Return statement 127 from not: (a) Evaluate the expression and prepare the destination
	;; Push integer value 1 onto stack
	SUBUS		%SP		%SP		4		; Push word space
	COPY		*%SP		1				; Copy the value

	;; Return statement 127 from not: (b) Copy single-word return value into place
	COPY		*%G0		*%SP				; Copy expression result into rv
	ADDUS		%SP		%SP		4		; Pop expression result
	;; Return statement 127 from not: (c) Jump to callee epilogue, since return statements take effect immediately
	JUMP		+_procedure_not_epilogue						; Return to caller
	;; If-then-else 128: (e) End
_not_branch_128_end:
	NOOP								; Placeholder for if-then-else 128
_procedure_not_epilogue:
	;; Callee for not: (epilogue) Pop locals and return

	COPY		%SP		%FP				; Pop locals and temp results
	ADDUS		%G0		%FP		8		; %G0 = &ra
	JUMP		*%G0						; Return to caller

	;; Procedure entry point
_procedure_+:
	;; Callee for +: (prologue) Push locals
	SUBUS		%SP		%SP		4		; Push locals

	;; Start begin-end statement
	;; Statement #0 of begin-end statement
	;; A literal assembly injection
	      ADDUS	 %G0	%FP	-4	; %G0 = &result
       ADDUS	 %G1	%FP	4	; %G1 = &y
	      ADD	 *%G0	*%FP	*%G1	; result = x + y
	;; Statement #1 of begin-end statement
	;; Return statement 140 from +: (a) Evaluate the expression and prepare the destination
	;; Identifier evaluation: result

	;; Evaluate dynamic variable result
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		-4		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Return statement 140 from +: (b) Copy single-word return value into place
	COPY		*%G0		*%SP				; Copy expression result into rv
	ADDUS		%SP		%SP		4		; Pop expression result
	;; Return statement 140 from +: (c) Jump to callee epilogue, since return statements take effect immediately
	JUMP		+_procedure_+_epilogue						; Return to caller
_procedure_+_epilogue:
	;; Callee for +: (epilogue) Pop locals and return

	COPY		%SP		%FP				; Pop locals and temp results
	ADDUS		%G0		%FP		12		; %G0 = &ra
	JUMP		*%G0						; Return to caller

	;; Procedure entry point
_procedure_-:
	;; Callee for -: (prologue) Push locals
	SUBUS		%SP		%SP		4		; Push locals

	;; Start begin-end statement
	;; Statement #0 of begin-end statement
	;; A literal assembly injection
	      ADDUS	 %G0	%FP	-4	; %G0 = &result
       ADDUS	 %G1	%FP	4	; %G1 = &y
	      SUB	 *%G0	*%FP	*%G1	; result = x - y
	;; Statement #1 of begin-end statement
	;; Return statement 152 from -: (a) Evaluate the expression and prepare the destination
	;; Identifier evaluation: result

	;; Evaluate dynamic variable result
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		-4		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Return statement 152 from -: (b) Copy single-word return value into place
	COPY		*%G0		*%SP				; Copy expression result into rv
	ADDUS		%SP		%SP		4		; Pop expression result
	;; Return statement 152 from -: (c) Jump to callee epilogue, since return statements take effect immediately
	JUMP		+_procedure_-_epilogue						; Return to caller
_procedure_-_epilogue:
	;; Callee for -: (epilogue) Pop locals and return

	COPY		%SP		%FP				; Pop locals and temp results
	ADDUS		%G0		%FP		12		; %G0 = &ra
	JUMP		*%G0						; Return to caller

	;; Procedure entry point
_procedure_*:
	;; Callee for *: (prologue) Push locals
	SUBUS		%SP		%SP		4		; Push locals

	;; Start begin-end statement
	;; Statement #0 of begin-end statement
	;; A literal assembly injection
	      ADDUS	 %G0	%FP	-4	; %G0 = &result
       ADDUS	 %G1	%FP	4	; %G1 = &y
	      MUL	 *%G0	*%FP	*%G1	; result = x * y
	;; Statement #1 of begin-end statement
	;; Return statement 164 from *: (a) Evaluate the expression and prepare the destination
	;; Identifier evaluation: result

	;; Evaluate dynamic variable result
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		-4		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Return statement 164 from *: (b) Copy single-word return value into place
	COPY		*%G0		*%SP				; Copy expression result into rv
	ADDUS		%SP		%SP		4		; Pop expression result
	;; Return statement 164 from *: (c) Jump to callee epilogue, since return statements take effect immediately
	JUMP		+_procedure_*_epilogue						; Return to caller
_procedure_*_epilogue:
	;; Callee for *: (epilogue) Pop locals and return

	COPY		%SP		%FP				; Pop locals and temp results
	ADDUS		%G0		%FP		12		; %G0 = &ra
	JUMP		*%G0						; Return to caller

	;; Procedure entry point
_procedure_/:
	;; Callee for /: (prologue) Push locals
	SUBUS		%SP		%SP		4		; Push locals

	;; Start begin-end statement
	;; Statement #0 of begin-end statement
	;; A literal assembly injection
	      ADDUS	 %G0	%FP	-4	; %G0 = &result
       ADDUS	 %G1	%FP	4	; %G1 = &y
	      DIV	 *%G0	*%FP	*%G1	; result = x / y
	;; Statement #1 of begin-end statement
	;; Return statement 176 from /: (a) Evaluate the expression and prepare the destination
	;; Identifier evaluation: result

	;; Evaluate dynamic variable result
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		-4		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Return statement 176 from /: (b) Copy single-word return value into place
	COPY		*%G0		*%SP				; Copy expression result into rv
	ADDUS		%SP		%SP		4		; Pop expression result
	;; Return statement 176 from /: (c) Jump to callee epilogue, since return statements take effect immediately
	JUMP		+_procedure_/_epilogue						; Return to caller
_procedure_/_epilogue:
	;; Callee for /: (epilogue) Pop locals and return

	COPY		%SP		%FP				; Pop locals and temp results
	ADDUS		%G0		%FP		12		; %G0 = &ra
	JUMP		*%G0						; Return to caller

	;; Procedure entry point
_procedure_==:
	;; Callee for ==: (prologue) Push locals
	SUBUS		%SP		%SP		4		; Push locals

	;; Start begin-end statement
	;; Statement #0 of begin-end statement
	;; Call to =: (prologue a) Create base of caller frame segment
	SUBUS		%SP		%SP		12		; Push pfp/ra[/rv] spaces
	;; Call to =: (prologue b) Evaluate and push arguments
	;; Call to =:   Argument #1
	;; Call to -: (prologue a) Create base of caller frame segment
	SUBUS		%SP		%SP		12		; Push pfp/ra[/rv] spaces
	;; Call to -: (prologue b) Evaluate and push arguments
	;; Call to -:   Argument #1
	;; Identifier evaluation: y

	;; Evaluate dynamic variable y
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		4		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Call to -:   Argument #0
	;; Identifier evaluation: x

	;; Evaluate dynamic variable x
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		0		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Call to -: (prologue c) Preserve and update frame pointer
	ADDUS		%G0		%SP		8		; %G0 = &pfp
	COPY		*%G0		%FP				; pfp = %FP
	COPY		%FP		%SP				; %FP = %SP
	;; Call to -
	ADDUS		%G0		%SP		12		; %G0 = &ra
	CALL		+_procedure_-		*%G0				; Do call
	;; Call to -: (epilogue a) Restore FP
	ADDUS		%G0		%FP		8		; %G0 = &pfp
	COPY		%FP		*%G0				; Restore FP
	;; Call to -: (epilogue b) Pop all but rv
	ADDUS		%SP		%SP		16		; Pop args/pfp/ra
	;; Call to =:   Argument #0
	;; Reference difference
	;; Push the address of dynamic variable difference

	SUBUS		%SP		%SP		4		; Push pointer space
	ADDUS		*%SP		%FP		-4		; src = %FP + offset
	;; Call to =: (prologue c) Preserve and update frame pointer
	ADDUS		%G0		%SP		8		; %G0 = &pfp
	COPY		*%G0		%FP				; pfp = %FP
	COPY		%FP		%SP				; %FP = %SP
	;; Call to =
	ADDUS		%G0		%SP		12		; %G0 = &ra
	CALL		+_procedure_=		*%G0				; Do call
	;; Call to =: (epilogue a) Restore FP
	ADDUS		%G0		%FP		8		; %G0 = &pfp
	COPY		%FP		*%G0				; Restore FP
	;; Call to =: (epilogue b) Pop all but rv
	ADDUS		%SP		%SP		16		; Pop args/pfp/ra
	;; Statement #1 of begin-end statement
	;; Return statement 197 from ==: (a) Evaluate the expression and prepare the destination
	;; Call to not: (prologue a) Create base of caller frame segment
	SUBUS		%SP		%SP		12		; Push pfp/ra[/rv] spaces
	;; Call to not: (prologue b) Evaluate and push arguments
	;; Call to not:   Argument #0
	;; Identifier evaluation: difference

	;; Evaluate dynamic variable difference
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		-4		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Call to not: (prologue c) Preserve and update frame pointer
	ADDUS		%G0		%SP		4		; %G0 = &pfp
	COPY		*%G0		%FP				; pfp = %FP
	COPY		%FP		%SP				; %FP = %SP
	;; Call to not
	ADDUS		%G0		%SP		8		; %G0 = &ra
	CALL		+_procedure_not		*%G0				; Do call
	;; Call to not: (epilogue a) Restore FP
	ADDUS		%G0		%FP		4		; %G0 = &pfp
	COPY		%FP		*%G0				; Restore FP
	;; Call to not: (epilogue b) Pop all but rv
	ADDUS		%SP		%SP		12		; Pop args/pfp/ra
	;; Return statement 197 from ==: (b) Copy single-word return value into place
	COPY		*%G0		*%SP				; Copy expression result into rv
	ADDUS		%SP		%SP		4		; Pop expression result
	;; Return statement 197 from ==: (c) Jump to callee epilogue, since return statements take effect immediately
	JUMP		+_procedure_==_epilogue						; Return to caller
_procedure_==_epilogue:
	;; Callee for ==: (epilogue) Pop locals and return

	COPY		%SP		%FP				; Pop locals and temp results
	ADDUS		%G0		%FP		12		; %G0 = &ra
	JUMP		*%G0						; Return to caller

	;; Procedure entry point
_procedure_!=:
	;; Callee for !=: (prologue) Push locals
	SUBUS		%SP		%SP		4		; Push locals

	;; Start begin-end statement
	;; Statement #0 of begin-end statement
	;; Call to =: (prologue a) Create base of caller frame segment
	SUBUS		%SP		%SP		12		; Push pfp/ra[/rv] spaces
	;; Call to =: (prologue b) Evaluate and push arguments
	;; Call to =:   Argument #1
	;; Call to -: (prologue a) Create base of caller frame segment
	SUBUS		%SP		%SP		12		; Push pfp/ra[/rv] spaces
	;; Call to -: (prologue b) Evaluate and push arguments
	;; Call to -:   Argument #1
	;; Identifier evaluation: y

	;; Evaluate dynamic variable y
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		4		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Call to -:   Argument #0
	;; Identifier evaluation: x

	;; Evaluate dynamic variable x
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		0		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Call to -: (prologue c) Preserve and update frame pointer
	ADDUS		%G0		%SP		8		; %G0 = &pfp
	COPY		*%G0		%FP				; pfp = %FP
	COPY		%FP		%SP				; %FP = %SP
	;; Call to -
	ADDUS		%G0		%SP		12		; %G0 = &ra
	CALL		+_procedure_-		*%G0				; Do call
	;; Call to -: (epilogue a) Restore FP
	ADDUS		%G0		%FP		8		; %G0 = &pfp
	COPY		%FP		*%G0				; Restore FP
	;; Call to -: (epilogue b) Pop all but rv
	ADDUS		%SP		%SP		16		; Pop args/pfp/ra
	;; Call to =:   Argument #0
	;; Reference difference
	;; Push the address of dynamic variable difference

	SUBUS		%SP		%SP		4		; Push pointer space
	ADDUS		*%SP		%FP		-4		; src = %FP + offset
	;; Call to =: (prologue c) Preserve and update frame pointer
	ADDUS		%G0		%SP		8		; %G0 = &pfp
	COPY		*%G0		%FP				; pfp = %FP
	COPY		%FP		%SP				; %FP = %SP
	;; Call to =
	ADDUS		%G0		%SP		12		; %G0 = &ra
	CALL		+_procedure_=		*%G0				; Do call
	;; Call to =: (epilogue a) Restore FP
	ADDUS		%G0		%FP		8		; %G0 = &pfp
	COPY		%FP		*%G0				; Restore FP
	;; Call to =: (epilogue b) Pop all but rv
	ADDUS		%SP		%SP		16		; Pop args/pfp/ra
	;; Statement #1 of begin-end statement
	;; Return statement 216 from !=: (a) Evaluate the expression and prepare the destination
	;; Identifier evaluation: difference

	;; Evaluate dynamic variable difference
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		-4		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Return statement 216 from !=: (b) Copy single-word return value into place
	COPY		*%G0		*%SP				; Copy expression result into rv
	ADDUS		%SP		%SP		4		; Pop expression result
	;; Return statement 216 from !=: (c) Jump to callee epilogue, since return statements take effect immediately
	JUMP		+_procedure_!=_epilogue						; Return to caller
_procedure_!=_epilogue:
	;; Callee for !=: (epilogue) Pop locals and return

	COPY		%SP		%FP				; Pop locals and temp results
	ADDUS		%G0		%FP		12		; %G0 = &ra
	JUMP		*%G0						; Return to caller

	;; Procedure entry point
_procedure_<:
	;; Callee for <: (prologue) Push locals
	SUBUS		%SP		%SP		4		; Push locals

	;; Start begin-end statement
	;; Statement #0 of begin-end statement
	;; Call to =: (prologue a) Create base of caller frame segment
	SUBUS		%SP		%SP		12		; Push pfp/ra[/rv] spaces
	;; Call to =: (prologue b) Evaluate and push arguments
	;; Call to =:   Argument #1
	;; Call to -: (prologue a) Create base of caller frame segment
	SUBUS		%SP		%SP		12		; Push pfp/ra[/rv] spaces
	;; Call to -: (prologue b) Evaluate and push arguments
	;; Call to -:   Argument #1
	;; Identifier evaluation: y

	;; Evaluate dynamic variable y
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		4		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Call to -:   Argument #0
	;; Identifier evaluation: x

	;; Evaluate dynamic variable x
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		0		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Call to -: (prologue c) Preserve and update frame pointer
	ADDUS		%G0		%SP		8		; %G0 = &pfp
	COPY		*%G0		%FP				; pfp = %FP
	COPY		%FP		%SP				; %FP = %SP
	;; Call to -
	ADDUS		%G0		%SP		12		; %G0 = &ra
	CALL		+_procedure_-		*%G0				; Do call
	;; Call to -: (epilogue a) Restore FP
	ADDUS		%G0		%FP		8		; %G0 = &pfp
	COPY		%FP		*%G0				; Restore FP
	;; Call to -: (epilogue b) Pop all but rv
	ADDUS		%SP		%SP		16		; Pop args/pfp/ra
	;; Call to =:   Argument #0
	;; Reference result
	;; Push the address of dynamic variable result

	SUBUS		%SP		%SP		4		; Push pointer space
	ADDUS		*%SP		%FP		-4		; src = %FP + offset
	;; Call to =: (prologue c) Preserve and update frame pointer
	ADDUS		%G0		%SP		8		; %G0 = &pfp
	COPY		*%G0		%FP				; pfp = %FP
	COPY		%FP		%SP				; %FP = %SP
	;; Call to =
	ADDUS		%G0		%SP		12		; %G0 = &ra
	CALL		+_procedure_=		*%G0				; Do call
	;; Call to =: (epilogue a) Restore FP
	ADDUS		%G0		%FP		8		; %G0 = &pfp
	COPY		%FP		*%G0				; Restore FP
	;; Call to =: (epilogue b) Pop all but rv
	ADDUS		%SP		%SP		16		; Pop args/pfp/ra
	;; Statement #1 of begin-end statement
	;; Return statement 238 from <: (a) Evaluate the expression and prepare the destination
	;; Call to >>: (prologue a) Create base of caller frame segment
	SUBUS		%SP		%SP		12		; Push pfp/ra[/rv] spaces
	;; Call to >>: (prologue b) Evaluate and push arguments
	;; Call to >>:   Argument #1
	;; Push integer value 31 onto stack
	SUBUS		%SP		%SP		4		; Push word space
	COPY		*%SP		31				; Copy the value

	;; Call to >>:   Argument #0
	;; Identifier evaluation: result

	;; Evaluate dynamic variable result
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		-4		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Call to >>: (prologue c) Preserve and update frame pointer
	ADDUS		%G0		%SP		8		; %G0 = &pfp
	COPY		*%G0		%FP				; pfp = %FP
	COPY		%FP		%SP				; %FP = %SP
	;; Call to >>
	ADDUS		%G0		%SP		12		; %G0 = &ra
	CALL		+_procedure_>>		*%G0				; Do call
	;; Call to >>: (epilogue a) Restore FP
	ADDUS		%G0		%FP		8		; %G0 = &pfp
	COPY		%FP		*%G0				; Restore FP
	;; Call to >>: (epilogue b) Pop all but rv
	ADDUS		%SP		%SP		16		; Pop args/pfp/ra
	;; Return statement 238 from <: (b) Copy single-word return value into place
	COPY		*%G0		*%SP				; Copy expression result into rv
	ADDUS		%SP		%SP		4		; Pop expression result
	;; Return statement 238 from <: (c) Jump to callee epilogue, since return statements take effect immediately
	JUMP		+_procedure_<_epilogue						; Return to caller
_procedure_<_epilogue:
	;; Callee for <: (epilogue) Pop locals and return

	COPY		%SP		%FP				; Pop locals and temp results
	ADDUS		%G0		%FP		12		; %G0 = &ra
	JUMP		*%G0						; Return to caller

	;; Procedure entry point
_procedure_>:
	;; Callee for >: (prologue) Push locals
	SUBUS		%SP		%SP		4		; Push locals

	;; Start begin-end statement
	;; Statement #0 of begin-end statement
	;; Return statement 260 from >: (a) Evaluate the expression and prepare the destination
	;; Call to not: (prologue a) Create base of caller frame segment
	SUBUS		%SP		%SP		12		; Push pfp/ra[/rv] spaces
	;; Call to not: (prologue b) Evaluate and push arguments
	;; Call to not:   Argument #0
	;; Call to or: (prologue a) Create base of caller frame segment
	SUBUS		%SP		%SP		12		; Push pfp/ra[/rv] spaces
	;; Call to or: (prologue b) Evaluate and push arguments
	;; Call to or:   Argument #1
	;; Call to ==: (prologue a) Create base of caller frame segment
	SUBUS		%SP		%SP		12		; Push pfp/ra[/rv] spaces
	;; Call to ==: (prologue b) Evaluate and push arguments
	;; Call to ==:   Argument #1
	;; Identifier evaluation: y

	;; Evaluate dynamic variable y
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		4		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Call to ==:   Argument #0
	;; Identifier evaluation: x

	;; Evaluate dynamic variable x
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		0		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Call to ==: (prologue c) Preserve and update frame pointer
	ADDUS		%G0		%SP		8		; %G0 = &pfp
	COPY		*%G0		%FP				; pfp = %FP
	COPY		%FP		%SP				; %FP = %SP
	;; Call to ==
	ADDUS		%G0		%SP		12		; %G0 = &ra
	CALL		+_procedure_==		*%G0				; Do call
	;; Call to ==: (epilogue a) Restore FP
	ADDUS		%G0		%FP		8		; %G0 = &pfp
	COPY		%FP		*%G0				; Restore FP
	;; Call to ==: (epilogue b) Pop all but rv
	ADDUS		%SP		%SP		16		; Pop args/pfp/ra
	;; Call to or:   Argument #0
	;; Call to <: (prologue a) Create base of caller frame segment
	SUBUS		%SP		%SP		12		; Push pfp/ra[/rv] spaces
	;; Call to <: (prologue b) Evaluate and push arguments
	;; Call to <:   Argument #1
	;; Identifier evaluation: y

	;; Evaluate dynamic variable y
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		4		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Call to <:   Argument #0
	;; Identifier evaluation: x

	;; Evaluate dynamic variable x
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		0		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Call to <: (prologue c) Preserve and update frame pointer
	ADDUS		%G0		%SP		8		; %G0 = &pfp
	COPY		*%G0		%FP				; pfp = %FP
	COPY		%FP		%SP				; %FP = %SP
	;; Call to <
	ADDUS		%G0		%SP		12		; %G0 = &ra
	CALL		+_procedure_<		*%G0				; Do call
	;; Call to <: (epilogue a) Restore FP
	ADDUS		%G0		%FP		8		; %G0 = &pfp
	COPY		%FP		*%G0				; Restore FP
	;; Call to <: (epilogue b) Pop all but rv
	ADDUS		%SP		%SP		16		; Pop args/pfp/ra
	;; Call to or: (prologue c) Preserve and update frame pointer
	ADDUS		%G0		%SP		8		; %G0 = &pfp
	COPY		*%G0		%FP				; pfp = %FP
	COPY		%FP		%SP				; %FP = %SP
	;; Call to or
	ADDUS		%G0		%SP		12		; %G0 = &ra
	CALL		+_procedure_or		*%G0				; Do call
	;; Call to or: (epilogue a) Restore FP
	ADDUS		%G0		%FP		8		; %G0 = &pfp
	COPY		%FP		*%G0				; Restore FP
	;; Call to or: (epilogue b) Pop all but rv
	ADDUS		%SP		%SP		16		; Pop args/pfp/ra
	;; Call to not: (prologue c) Preserve and update frame pointer
	ADDUS		%G0		%SP		4		; %G0 = &pfp
	COPY		*%G0		%FP				; pfp = %FP
	COPY		%FP		%SP				; %FP = %SP
	;; Call to not
	ADDUS		%G0		%SP		8		; %G0 = &ra
	CALL		+_procedure_not		*%G0				; Do call
	;; Call to not: (epilogue a) Restore FP
	ADDUS		%G0		%FP		4		; %G0 = &pfp
	COPY		%FP		*%G0				; Restore FP
	;; Call to not: (epilogue b) Pop all but rv
	ADDUS		%SP		%SP		12		; Pop args/pfp/ra
	;; Return statement 260 from >: (b) Copy single-word return value into place
	COPY		*%G0		*%SP				; Copy expression result into rv
	ADDUS		%SP		%SP		4		; Pop expression result
	;; Return statement 260 from >: (c) Jump to callee epilogue, since return statements take effect immediately
	JUMP		+_procedure_>_epilogue						; Return to caller
_procedure_>_epilogue:
	;; Callee for >: (epilogue) Pop locals and return

	COPY		%SP		%FP				; Pop locals and temp results
	ADDUS		%G0		%FP		12		; %G0 = &ra
	JUMP		*%G0						; Return to caller

	;; Procedure entry point
_procedure_<=:
	;; Callee for <=: (prologue) Push locals
	SUBUS		%SP		%SP		4		; Push locals

	;; Start begin-end statement
	;; Statement #0 of begin-end statement
	;; Return statement 280 from <=: (a) Evaluate the expression and prepare the destination
	;; Call to or: (prologue a) Create base of caller frame segment
	SUBUS		%SP		%SP		12		; Push pfp/ra[/rv] spaces
	;; Call to or: (prologue b) Evaluate and push arguments
	;; Call to or:   Argument #1
	;; Call to ==: (prologue a) Create base of caller frame segment
	SUBUS		%SP		%SP		12		; Push pfp/ra[/rv] spaces
	;; Call to ==: (prologue b) Evaluate and push arguments
	;; Call to ==:   Argument #1
	;; Identifier evaluation: y

	;; Evaluate dynamic variable y
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		4		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Call to ==:   Argument #0
	;; Identifier evaluation: x

	;; Evaluate dynamic variable x
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		0		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Call to ==: (prologue c) Preserve and update frame pointer
	ADDUS		%G0		%SP		8		; %G0 = &pfp
	COPY		*%G0		%FP				; pfp = %FP
	COPY		%FP		%SP				; %FP = %SP
	;; Call to ==
	ADDUS		%G0		%SP		12		; %G0 = &ra
	CALL		+_procedure_==		*%G0				; Do call
	;; Call to ==: (epilogue a) Restore FP
	ADDUS		%G0		%FP		8		; %G0 = &pfp
	COPY		%FP		*%G0				; Restore FP
	;; Call to ==: (epilogue b) Pop all but rv
	ADDUS		%SP		%SP		16		; Pop args/pfp/ra
	;; Call to or:   Argument #0
	;; Call to <: (prologue a) Create base of caller frame segment
	SUBUS		%SP		%SP		12		; Push pfp/ra[/rv] spaces
	;; Call to <: (prologue b) Evaluate and push arguments
	;; Call to <:   Argument #1
	;; Identifier evaluation: y

	;; Evaluate dynamic variable y
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		4		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Call to <:   Argument #0
	;; Identifier evaluation: x

	;; Evaluate dynamic variable x
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		0		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Call to <: (prologue c) Preserve and update frame pointer
	ADDUS		%G0		%SP		8		; %G0 = &pfp
	COPY		*%G0		%FP				; pfp = %FP
	COPY		%FP		%SP				; %FP = %SP
	;; Call to <
	ADDUS		%G0		%SP		12		; %G0 = &ra
	CALL		+_procedure_<		*%G0				; Do call
	;; Call to <: (epilogue a) Restore FP
	ADDUS		%G0		%FP		8		; %G0 = &pfp
	COPY		%FP		*%G0				; Restore FP
	;; Call to <: (epilogue b) Pop all but rv
	ADDUS		%SP		%SP		16		; Pop args/pfp/ra
	;; Call to or: (prologue c) Preserve and update frame pointer
	ADDUS		%G0		%SP		8		; %G0 = &pfp
	COPY		*%G0		%FP				; pfp = %FP
	COPY		%FP		%SP				; %FP = %SP
	;; Call to or
	ADDUS		%G0		%SP		12		; %G0 = &ra
	CALL		+_procedure_or		*%G0				; Do call
	;; Call to or: (epilogue a) Restore FP
	ADDUS		%G0		%FP		8		; %G0 = &pfp
	COPY		%FP		*%G0				; Restore FP
	;; Call to or: (epilogue b) Pop all but rv
	ADDUS		%SP		%SP		16		; Pop args/pfp/ra
	;; Return statement 280 from <=: (b) Copy single-word return value into place
	COPY		*%G0		*%SP				; Copy expression result into rv
	ADDUS		%SP		%SP		4		; Pop expression result
	;; Return statement 280 from <=: (c) Jump to callee epilogue, since return statements take effect immediately
	JUMP		+_procedure_<=_epilogue						; Return to caller
_procedure_<=_epilogue:
	;; Callee for <=: (epilogue) Pop locals and return

	COPY		%SP		%FP				; Pop locals and temp results
	ADDUS		%G0		%FP		12		; %G0 = &ra
	JUMP		*%G0						; Return to caller

	;; Procedure entry point
_procedure_>=:
	;; Callee for >=: (prologue) Push locals
	SUBUS		%SP		%SP		4		; Push locals

	;; Start begin-end statement
	;; Statement #0 of begin-end statement
	;; Return statement 296 from >=: (a) Evaluate the expression and prepare the destination
	;; Call to not: (prologue a) Create base of caller frame segment
	SUBUS		%SP		%SP		12		; Push pfp/ra[/rv] spaces
	;; Call to not: (prologue b) Evaluate and push arguments
	;; Call to not:   Argument #0
	;; Call to <: (prologue a) Create base of caller frame segment
	SUBUS		%SP		%SP		12		; Push pfp/ra[/rv] spaces
	;; Call to <: (prologue b) Evaluate and push arguments
	;; Call to <:   Argument #1
	;; Identifier evaluation: y

	;; Evaluate dynamic variable y
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		4		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Call to <:   Argument #0
	;; Identifier evaluation: x

	;; Evaluate dynamic variable x
	SUBUS		%SP		%SP		4		; Push space for resulting value, %SP = dst
	ADDUS		%G0		%FP		0		; %G0 = src = %FP + offset
	COPY		*%SP		*%G0				; *dst = *src
	;; Call to <: (prologue c) Preserve and update frame pointer
	ADDUS		%G0		%SP		8		; %G0 = &pfp
	COPY		*%G0		%FP				; pfp = %FP
	COPY		%FP		%SP				; %FP = %SP
	;; Call to <
	ADDUS		%G0		%SP		12		; %G0 = &ra
	CALL		+_procedure_<		*%G0				; Do call
	;; Call to <: (epilogue a) Restore FP
	ADDUS		%G0		%FP		8		; %G0 = &pfp
	COPY		%FP		*%G0				; Restore FP
	;; Call to <: (epilogue b) Pop all but rv
	ADDUS		%SP		%SP		16		; Pop args/pfp/ra
	;; Call to not: (prologue c) Preserve and update frame pointer
	ADDUS		%G0		%SP		4		; %G0 = &pfp
	COPY		*%G0		%FP				; pfp = %FP
	COPY		%FP		%SP				; %FP = %SP
	;; Call to not
	ADDUS		%G0		%SP		8		; %G0 = &ra
	CALL		+_procedure_not		*%G0				; Do call
	;; Call to not: (epilogue a) Restore FP
	ADDUS		%G0		%FP		4		; %G0 = &pfp
	COPY		%FP		*%G0				; Restore FP
	;; Call to not: (epilogue b) Pop all but rv
	ADDUS		%SP		%SP		12		; Pop args/pfp/ra
	;; Return statement 296 from >=: (b) Copy single-word return value into place
	COPY		*%G0		*%SP				; Copy expression result into rv
	ADDUS		%SP		%SP		4		; Pop expression result
	;; Return statement 296 from >=: (c) Jump to callee epilogue, since return statements take effect immediately
	JUMP		+_procedure_>=_epilogue						; Return to caller
_procedure_>=_epilogue:
	;; Callee for >=: (epilogue) Pop locals and return

	COPY		%SP		%FP				; Pop locals and temp results
	ADDUS		%G0		%FP		12		; %G0 = &ra
	JUMP		*%G0						; Return to caller

	.Numeric

	.Text

