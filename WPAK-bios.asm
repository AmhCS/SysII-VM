	.Code

_start:
	COPY %G0 12

;;; Copy the addresses of the bus controllers base and limit in %G0 and %G1
	;; bcBase and bcLimit hold the addresses where the base and limit
	;; of the bus controller are stored in memory.
	COPY %G0 *+bcBase

	COPY %G1 *+bcLimit
	COPY %G1 *%G1


;;;Loop through the bus controller, breaking if the
;;;currSpot, being held in %GO ever exceeds the limit of the controller itself


ROMloop: BGTE	+resetG0	%G0	%G1

	;;If the type is = 2:
	;; store the base and limit of the ROM into %G4 and %G5 respectively
	;;Break if whatever is at the address specified in %G0 is != 2
	BNEQ	+ROMloopbottom	*%G0	2

	ADDUS	%G4	%G0	4  ;%G4 now holds the address where the ROMBase is stored
	COPY	%G4	*%G4	   ;%G4 now holds the address of the ROMBase
	ADDUS	%G5	%G0 	8  ;%G5 now holds the address that specifies the ROMLimt
	COPY	%G5	*%G5       ;%G5 now holds the address of the ROMLimit
	ADDUS	%G2	%G2	1  ;%G1 holds a count for the number of ROMs found
	;; Once the count = 2, jump out of loop
	BEQ	+resetG0	%G2	2	 

ROMloopbottom:	ADDUS	%G0	%G0	12
		JUMP	+ROMloop	
;;; Willam Poss and Avery Klemmer
resetG0: COPY %G0 *+bcBase
RAMloop: BGTE	+copyloop	%G0	%G1

	;; If the type is =3:
	;; jump to the bottom of the loop
	BNEQ	+RAMloopbottom	*%G0	3
	ADDUS	%G0	%G0	4     ;%G0 now holds the address specifying the RAMBase
	COPY	%G0	*%G0	      ;%G0 now holds the address of the RAMBase
	JUMP +copyloop

RAMloopbottom:	ADDUS	%G0	%G0	12
		JUMP	+RAMloop

	;; Use the shortcut to copy chunks of code
copyloop: SUBUS %G3	%G1	12
       	SUBUS %G2	%G1	8
	SUBUS %G1	%G1	4
	COPY *%G3	%G4
	COPY *%G2	%G0
	SUBUS %G2	%G5	%G4

	SUBUS *%G1	%G5	%G4 ;The length of the portion of code is the ROMLimit - ROMBase

	SUBUS %G1 %G5	%G4
	ADDUS %G1 %G1 %G0
	JUMP %G0
_procedure_find_device:

	;; Prologue: Preserve the registers used on the stack.
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G0
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G1
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G2
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G4

	;; Initialize the locals.
	COPY		%G0		*%FP
	ADDUS		%G1		%FP		4
	COPY		%G1		*%G1
	COPY		%G2		*+_static_device_table_base

find_device_loop_top:

	;; End the search with failure if we've reached the end of the table without finding the device.
	BEQ		+find_device_loop_failure	*%G2		*+_static_none_device_code

	;; If this entry matches the device type we seek, then decrement the instance count.  If the instance count hits zero, then
	;; the search ends successfully.
	BNEQ		+find_device_continue_loop	*%G2		%G0
	SUB		%G1				%G1		1
	BEQ		+find_device_loop_success	%G1		0

find_device_continue_loop:	

	;; Advance to the next entry.
	ADDUS		%G2			%G2		*+_static_dt_entry_size
	JUMP		+find_device_loop_top

find_device_loop_failure:

	;; Set the return value to a null pointer.
	ADDUS		%G4			%FP		16 	; %G4 = &rv
	COPY		*%G4			0			; rv = null
	JUMP		+find_device_return

find_device_loop_success:

	;; Set the return pointer into the device table that currently points to the given iteration of the given type.
	ADDUS		%G4			%FP		16 	; %G4 = &rv
	COPY		*%G4			%G2			; rv = &dt[<device>]
	;; Fall through...

find_device_return:

	;; Epilogue: Restore preserved registers, then return.
	COPY		%G4		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G2		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G1		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G0		*%SP
	ADDUS		%SP		%SP		4
	ADDUS		%G5		%FP		12 	; %G5 = &ra
	JUMP		*%G5
;;; ================================================================================================================================



;;; ================================================================================================================================
;;; Procedure: print
;;; Callee preserved registers:
;;;   [%FP - 4]: G0
;;;   [%FP - 8]: G3
;;;   [%FP - 12]: G4
;;; Parameters:
;;;   [%FP + 0]: A pointer to the beginning of a null-terminated string.
;;; Caller preserved registers:
;;;   [%FP + 4]: FP
;;; Return address:
;;;   [%FP + 8]
;;; Return value:
;;;   <none>
;;; Locals:
;;;   %G0: Pointer to the current position in the string.

_procedure_print:

	;; Prologue: Push preserved registers.
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G0
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G3
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G4

	;; If not yet initialized, set the console base/limit statics.
	BNEQ		+print_init_loop	*+_static_console_base		0
	SUBUS		%SP		%SP		12		; Push pfp / ra / rv
	COPY		*%SP		%FP				; pFP = %FP
	SUBUS		%SP		%SP		4 		; Push arg[1]
	COPY		*%SP		1				; Find the 1st device of the given type.
	SUBUS		%SP		%SP		4		; Push arg[0]
	COPY		*%SP		*+_static_console_device_code	; Find a console device.
	COPY		%FP		%SP				; Update %FP
	ADDUS		%G5		%SP		12		; %G5 = &ra
	CALL		+_procedure_find_device		*%G5
	ADDUS		%SP		%SP		8 		; Pop arg[0,1]
	COPY		%FP		*%SP 				; %FP = pfp
	ADDUS		%SP		%SP		8		; Pop pfp / ra
	COPY		%G4		*%SP				; %G4 = &dt[console]
	ADDUS		%SP		%SP		4		; Pop rv

	;; Panic if the console was not found.
	BNEQ		+print_found_console	%G4		0
	COPY		%G5		*+_static_error_console_not_found
	HALT

print_found_console:	
	ADDUS		%G3		%G4		*+_static_dt_base_offset  ; %G3 = &console[base]
	COPY		*+_static_console_base		*%G3			  ; Store static console[base]
	ADDUS		%G3		%G4		*+_static_dt_limit_offset ; %G3 = &console[limit]
	COPY		*+_static_console_limit		*%G3			  ; Store static console[limit]

print_init_loop:	

	;; Loop through the characters of the given string until the null character is found.
	COPY		%G0		*%FP 				; %G0 = str_ptr
print_loop_top:
	COPYB		%G4		*%G0 				; %G4 = current_char

	;; The loop should end if this is a null character
	BEQ		+print_loop_end	%G4		0

	;; Scroll without copying the character if this is a newline.
	COPY		%G3		*+_static_newline_char		; %G3 = <newline>
	BEQ		+print_scroll_call	%G4	%G3

	;; Assume that the cursor is in a valid location.  Copy the current character into it.
	;; The cursor position c maps to buffer location: console[limit] - width + c
	SUBUS		%G3		*+_static_console_limit	*+_static_console_width	   ; %G3 = console[limit] - width
	ADDUS		%G3		%G3		*+_static_cursor_column		   ; %G3 = console[limit] - width + c
	COPYB		*%G3		%G4						   ; &(height - 1, c) = current_char

	;; Advance the cursor, scrolling if necessary.
	ADD		*+_static_cursor_column	*+_static_cursor_column		1	; c = c + 1
	BLT		+print_scroll_end	*+_static_cursor_column	*+_static_console_width	; Skip scrolling if c < width
	;; Fall through...

print_scroll_call:	
	SUBUS		%SP		%SP		8				; Push pfp / ra
	COPY		*%SP		%FP						; pfp = %FP
	COPY		%FP		%SP						; %FP = %SP
	ADDUS		%G5		%FP		4				; %G5 = &ra
	CALL		+_procedure_scroll_console	*%G5
	COPY		%FP		*%SP 						; %FP = pfp
	ADDUS		%SP		%SP		8				; Pop pfp / ra

print_scroll_end:
	;; Place the cursor character in its new position.
	SUBUS		%G3		*+_static_console_limit		*+_static_console_width ; %G3 = console[limit] - width
	ADDUS		%G3		%G3		*+_static_cursor_column	        ; %G3 = console[limit] - width + c	
	COPY		%G4		*+_static_cursor_char				        ; %G4 = <cursor>
	COPYB		*%G3		%G4					        ; console@cursor = <cursor>

	;; Iterate by advancing to the next character in the string.
	ADDUS		%G0		%G0		1
	JUMP		+print_loop_top

print_loop_end:
	;; Epilogue: Pop and restore preserved registers, then return.
	COPY		%G4		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G3		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G0		*%SP
	ADDUS		%SP		%SP		4
	ADDUS		%G5		%FP		8 		; %G5 = &ra
	JUMP		*%G5
;;; ================================================================================================================================


;;; ================================================================================================================================
;;; Procedure: scroll_console
;;; Description: Scroll the console and reset the cursor at the 0th column.
;;; Callee reserved registers:
;;;   [%FP - 4]:  G0
;;;   [%FP - 8]:  G1
;;;   [%FP - 12]: G4
;;; Parameters:
;;;   <none>
;;; Caller preserved registers:
;;;   [%FP + 0]:  FP
;;; Return address:
;;;   [%FP + 4]
;;; Return value:
;;;   <none>
;;; Locals:
;;;   %G0:  The current destination address.
;;;   %G1:  The current source address.

_procedure_scroll_console:

	;; Prologue: Push preserved registers.
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G0
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G1
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G4

	;; Initialize locals.
	COPY		%G0		*+_static_console_base			   ; %G0 = console[base]
	ADDUS		%G1		%G0		*+_static_console_width	   ; %G1 = console[base] + width

	;; Clear the cursor.
	SUBUS		%G4		*+_static_console_limit		*+_static_console_width ; %G4 = console[limit] - width
	ADDUS		%G4		%G4		*+_static_cursor_column			; %G4 = console[limit] - width + c
	COPYB		*%G4		*+_static_space_char					; Clear cursor.

	;; Copy from the source to the destination.
	;;   %G3 = DMA portal
	;;   %G4 = DMA transfer length
	ADDUS		%G3		8		*+_static_device_table_base ; %G3 = &controller[limit]
	SUBUS		%G3		*%G3		12                          ; %G3 = controller[limit] - 3*|word| = &DMA_portal
	SUBUS		%G4		*+_static_console_limit	%G0 		    ; %G4 = console[base] - console[limit] = |console|
	SUBUS		%G4		%G4		*+_static_console_width     ; %G4 = |console| - width

	;; Copy the source, destination, and length into the portal.  The last step triggers the DMA copy.
	COPY		*%G3		%G1 					; DMA[source] = console[base] + width
	ADDUS		%G3		%G3		4 			; %G3 = &DMA[destination]
	COPY		*%G3		%G0 					; DMA[destination] = console[base]
	ADDUS		%G3		%G3		4 			; %G3 = &DMA[length]
	COPY		*%G3		%G4 					; DMA[length] = |console| - width; DMA trigger

	;; Perform a DMA transfer to blank the last line with spaces.
	SUBUS		%G3		%G3		8 			; %G3 = &DMA_portal
	COPY		*%G3		+_string_blank_line			; DMA[source] = &blank_line
	ADDUS		%G3		%G3		4 			; %G3 = &DMA[destination]
	SUBUS		*%G3		*+_static_console_limit	*+_static_console_width	; DMA[destination] = console[limit] - width
	ADDUS		%G3		%G3		4 			; %G3 = &DMA[length]
	COPY		*%G3		*+_static_console_width			; DMA[length] = width; DMA trigger

	;; Reset the cursor position.
	COPY		*+_static_cursor_column		0			                ; c = 0
	SUBUS		%G4		*+_static_console_limit		*+_static_console_width ; %G4 = console[limit] - width
	COPYB		*%G4		*+_static_cursor_char				   	; Set cursor.

	;; Epilogue: Pop and restore preserved registers, then return.
	COPY		%G4		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G1		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G0		*%SP
	ADDUS		%SP		%SP		4
	ADDUS		%G5		%FP		4 		; %G5 = &ra
	JUMP		*%G5
;;; ================================================================================================================================



;;; ================================================================================================================================
	.Numeric

controllerLimit:	 0
bcBase: 0x00001000
bcLimit: 0x00001008

	;; A special marker that indicates the beginning of the statics.  The value is just a magic cookie, in case any code wants
	;; to check that this is the correct location (with high probability).
_static_statics_start_marker:	0xdeadcafe

	;; Device table location and codes.
_static_device_table_base:	0x00001000
_static_dt_entry_size:		12
_static_dt_base_offset:		4
_static_dt_limit_offset:	8
_static_none_device_code:	0
_static_controller_device_code:	1
_static_ROM_device_code:	2
_static_RAM_device_code:	3
_static_console_device_code:	4

	;; Error codes.
_static_error_RAM_not_found:	0xffff0001
_static_error_main_returned:	0xffff0002
_static_error_small_RAM:		0xffff0003	
_static_error_console_not_found:	0xffff0004

	;; Constants for printing and console management.
_static_console_width:		80
_static_console_height:		24
_static_space_char:		0x20202020 ; Four copies for faster scrolling.  If used with COPYB, only the low byte is used.
_static_cursor_char:		0x5f
_static_newline_char:		0x0a

	;; Other constants.
_static_min_RAM_KB:		64
_static_bytes_per_KB:		1024
_static_KB_size:		32	; KB taken by the kernel.

	;; Statically allocated variables.
_static_cursor_column:		0	; The column position of the cursor (always on the last row).
_static_RAM_base:		0
_static_RAM_limit:		0
_static_console_base:		0
_static_console_limit:		0
_static_base:			0
_static_limit:			0
;;; ================================================================================================================================



;;; ================================================================================================================================
	.Text

_string_banner_msg:	"A test message.\n"
_string_blank_line:	"                                                                                "
;;; ================================================================================================================================
