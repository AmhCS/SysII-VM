;;; Kernel program that does project-0.

;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Terri-Anne Hultum && Connor Bottum ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.Code

;;; The entry point.
__start:

	;; %G0 holds the Kernel_begin in RAM (RAM_begin)
	;; %G1 is working along the BC (holds the BC_Kernel_end)
	;; %G2 is free *
	;; %G3 holds the RAM_end
	;; %G4 holds the number of ROMs
	;; %G5 holds the Kernel_end in RAM

	COPY	*+ROM_n	%G4
	;; %G4 is free *

	COPY 	*+RAM_e	%G3	;store the RAM_end in RAM_e
	;; %G3 is free *

	ADDUS 	%SP 	%G5 	0x5000	;lets start the stack here
	COPY 	%FP 	%SP
	COPY	*+stack_end	%SP

	COPY 	*+Ker_e	%G5	;store the kernel_end in Ker_e 	
	;; %G5 is free *

	;; %G3 is free *
	;; %G4 is free *
	;; %G5 is free *

	;; we need to load addresses into the TT
	COPY 	%G5 	+trap_t
	COPY 	%G3 	+null_ih

	ADDUS 	%G4 	%G5 	40	;THIS NUMBER OF INTERRUPTS IN TT
TTCB:	BEQ 	+TTCE 	%G5 	%G4
	COPY 	*%G5 	%G3
	ADDUS 	%G5 	%G5 	4
	JUMP 	+TTCB

TTCE:				;now TT contains null_ih's
	COPY 	%G5 	+trap_t
	SUBUS	%G4	%G4	4
	COPY	*%G4	+sysc
	ADDUS	%G4	+trap_t	12
	COPY	*%G4	+alarm
	SETTBR	%G5		;trap_base_register initialised

	ADDUS	*+free_space_pointer	+free_space_pointer	4 ;Save the end of the statics (first free space) into the free_space_pointer
page_the_kernel:	
	;; Caller prologue

	SUBUS	%SP	%SP	12
	COPY	*%SP	%FP
	SUBUS	%SP	%SP	4
	COPY	*%SP	1024
	COPY	%FP	%SP
	ADDUS	%G0	%FP	8

	;; Call memalloc
	CALL	+_procedure_mem_alloc	*%G0

	;; Caller epilogue
	SUBUS	%FP	%FP	4
	COPY	%FP	*%FP
	ADDUS	%SP	%SP	16

	SUBUS	%G3	%SP	4
	COPY	*+kernel_Upper_Page_Table *%G3
	COPY	%G4	*+kernel_Upper_Page_Table

	;; Caller prologue
	SUBUS	%SP	%SP	12
	COPY	*%SP	%FP
	SUBUS	%SP	%SP	4
	COPY	*%SP	1024
	COPY	%FP	%SP
	ADDUS	%G0	%FP	8

	;; Call memalloc
	CALL	+_procedure_special_mem_alloc	*%G0

	;; Caller epilogue
	SUBUS	%FP	%FP	4
	COPY	%FP	*%FP
	ADDUS	%SP	%SP	16

	SUBUS	%G4	%SP	4
	COPY	*+kernel_Lower_Page_Table *%G4
	COPY	%G0	*+kernel_Upper_Page_Table
	ADDUS	*%G0	*%G4	0x1f

	ADDUS	%G1	*+kernel_Lower_Page_Table	4096
	COPY	%G2	*+kernel_Lower_Page_Table
	COPY	%G3	0b0000000011111

pageLoopTop:
	BGT	+fin	%G2	%G1
	COPY	*%G2	%G3
	ADDUS	%G3	%G3	0b1000000000000
	ADDUS	%G2	%G2	4
	JUMP	+pageLoopTop

fin:    SETPTR  *+kernel_Upper_Page_Table
	JUMPMD +f_3ROM 0xc	


	;; Copy the program (add_two_numbers) into RAM

	SUBUS	%G1	%G1	8
f_3ROM:	ADDUS 	%G1 	%G1 	12
	BNEQ 	+f_3ROM	*%G1	2	;will stop at the third ROM

	ADDUS 	%G1 	%G1 	4
	COPY 	%G2 	*%G1		;%G2 now contains the ROM3_begin
	ADDUS 	%G1 	%G1 	4
	COPY 	%G1 	*%G1		;%G1 now contains the ROM3_end

	;; (769?)
	;;  We now have the location of the third ROM

	ADDUS	%G4	*+Ker_e	0x5010 	;lets start the program here

	COPY 	*+prg1_b	%G4		;store the beginning of the program

l_top:	BEQ 	+l_end 	%G2 	%G1	;stops when program reaches end
	COPY 	*%G4 	*%G2		;copy into RAM
	ADDUS 	%G2 	%G2 	4
	ADDUS 	%G4 	%G4 	4
	JUMP 	+l_top
	;; now program is in RAM

l_end:	COPY 	%G1	%G4		;%G1 holds the ROM3_end in RAM
	COPY	*+prg1_e	%G1


	COPY 	%G5	*+prg1_b

	;; %G0 holds the Kernel_begin in RAM (RAM_begin)
	;; %G1 holds the ROM3_end in RAM
	;; %G2 is free *
	;; %G3 is free *
	;; %G4 is free *
	;; %G5 holds the beginning of the program

	;; *****
	;; make heap pointer, move everything to heap
	COPY	*+HP	+heap_start
	COPY	*+process_t	+heap_start
	COPY	%G2	*+HP

;;; put init onto the heap in the start of the CPU scheduler
	COPY	*%G2	*+prg1_b	;store the beginning of the init program
	ADDUS	%G2	%G2	4
	COPY 	*%G2	*+prg1_e	;store the end of the init program
	ADDUS	%G2	%G2	4
	;; parent field is empty
	ADDUS	%G2	%G2	32
	;; registers are empty
	ADDUS	%G2	%G2	4
	;; return address	
	ADDUS	%G2	%G2	4
	;; pointer field
	COPY	*%G2	+heap_start	;pointer to itself
	ADDUS	%G2	%G2	4
	COPY	*+HP	%G2
;;; put init onto the heap in the start of the CPU scheduler	

	SETIBR	+ib_space

;;; storing registers
	COPY	*+k_g0	%G0
	COPY	*+k_g1	%G1
	COPY	*+k_g2	%G2
	COPY	*+k_g3	%G3
	COPY	*+k_g4	%G4
	COPY	*+k_g5	%G5
;;; storing registers

;;; set clock alarm
	ADDUS	%G3	+alarm_to	4
	COPY	*+alarm_to	0x0
	COPY	*%G3	0x50
	SETALM	*+alarm_to	*+alarm_at
;;; set clock alarm

	COPY	%G4	*+mode
	JUMPMD	%G5	%G4


statics:	



;;; NULL INTERRUPT HANDLER
null_ih:	;; null_interrupt_handler halts the processor.
	COPY	%G0	0xadead
	HALT
;;; NULL INTERRUPT HANDLER

;;; SYSC INTERRUPT HANDLER
sysc:	
	;; set the alarm interrupt to an absurd value so that the alarm will not go off inside the kernel
	COPY	*+alarm_to	0xffffffff
	SETALM	*+alarm_to	*+alarm_at

	;; save the process's registers
	COPY	*+p_g0	%G0
	COPY	%G0	+here1
	JUMP	+which
here1:	;;%G0 now contains a pointer to the program we have been SYSC'ed from
	;; all of the program's registers have been saved into its process table entry

	ADDUS	%G1	%G0	16 
	SUBUS	%G2	%G1	4  
	COPY	%G2	*%G2	;%G2 now contains what the program had %G0 contain
	COPY	%G1	*%G1	;%G1 now contains what the program had it contain

	BNEQ	+error	%G2	9
	BEQ	+IMAGE_COUNT	%G1	1
	BEQ	+EXECUTE	%G1	2
	BEQ	+EXIT		%G1	3

	;; returns the number of ROMs in %G0
IMAGE_COUNT:
	COPY	%G3	%G0
	COPY	%G0	*+ROM_n

	;; restore registers
	ADDUS	%G3	%G3	16
	COPY	%G1	*%G3
	ADDUS	%G3	%G3	4
	COPY	%G2	*%G3
	ADDUS	%G3	%G3	8
	COPY	%G4	*%G3
	ADDUS	%G3	%G3	4
	COPY	%G5	*%G3
	ADDUS	%G3	%G3	4
	COPY	%SP	*%G3
	ADDUS	%G3	%G3	4
	COPY	%FP	*%G3
	SUBUS	%G3	%G3	16
	COPY	%G3	*%G3

	ADDUS	*+ib_space	*+ib_space	16
	JUMPMD	*+ib_space	*+mode

EXECUTE:
	ADDUS 	%G2	%G0	20
	COPY	%G2	*%G2
	BGT	+error	%G2	*+ROM_n ;if init asks to open a process that does not exist, jump to 'error'

	COPY	%G1	*+BC
	ADDUS	%G1	%G1	60 ;%G1 is now pointing at the entry after init
	ADDUS	%G2	0	0  ;the number of ROMs we have counted

	;; get the program's %G2
	ADDUS 	%G4	%G0	20
	COPY	%G4	*%G4
	;; get the program's %G2	

new_t:	COPY	%G3	*%G1
	BNEQ	+no2	%G3	2 ;we have not found a ROM
	ADDUS	%G2	%G2	1 ;we found a ROM
	BEQ	+new_b	%G2	%G4 ;do we have the right ROM?
no2:	ADDUS	%G1	%G1	12 ;go to next entry in BC
	JUMP	+new_t

	;; now we have the BC of the correct ROM
new_b:	ADDUS	%G1	%G1	4
	COPY	%G4	*%G1
	ADDUS	%G1	%G1	4
	COPY	%G5	*%G1
	;; %G4 and %G5 hold the beginning and end of the ROM respectively

	SUBUS 	*+bytes_no	%G5	%G4
	JUMP	+allocator
pls_all:
	;; we now have pointer where_bytes

	;; find the next free bit of RAM, given that our CPU schedluer has not yet changed the order of the list - go to  last entry and use RAM from then on

	;; walk down process table until the end, get the new RAM space

	COPY	%G1	*+process_t
	ADDUS	%G2	%G1	48 	;the next pointer
	COPY	%G3	%G1

	BEQ	+last	%G1	*%G2 	;branch if the next process is the beginning one - we have found the end
not_last:
	COPY	%G3	*%G2	   	;go to next process
	ADDUS	%G2	%G3	48 	;the next pointer
	BEQ	+last	%G1	*%G2 	;branch if the next process is the beginning one - we have found the end
	JUMP	+not_last

last:	;;we have found the end process, now get its last used RAM space
	ADDUS	%G2	%G3	4
	COPY	%G2	*%G2		;the last actively used RAM
	ADDUS	%G2	%G2	4	;leave a small buffer of one word
	COPY	*+prg1_b	%G2	;hold the new beginning location until we are ready to create the new process table entry

	;; %G4 and %G5 hold the beginning and end of the ROM respectively
	;; %G3 is holding the last thing in the process table

ex_top:	BEQ 	+ex_end 	%G4 	%G5	;stops when program reaches end
	COPY 	*%G2 	*%G4
	ADDUS 	%G4 	%G4 	4
	ADDUS 	%G2 	%G2 	4
	JUMP 	+ex_top
	;; now program is in RAM

ex_end:	COPY	*+prg1_e	%G2 	;hold end of program

	;; put on the CPU scheduler
	JUMP +scheduler

pls_sch:			;%G3 and %G4 have changed
	;; now copy the return address into the SYSC'ed program's process table entry
	;; %G0 holds the process table entry
	ADDUS	%G1	%G0	44 	;get the return address space
	ADDUS	*+ib_space	*+ib_space	16
	COPY	*%G1	*+ib_space

	;; jump back into the SYSC'ed program
	;; if we wish to change this, we need to store the return address
	;; restore its registers
	COPY	*+restored	+here2
	JUMP	+restore
here2:	
	JUMPMD	*+ib_space	*+mode

EXIT:
	;; look for the process that asked to EXIT - by checking the ranges in the schedule
	;; %G0 contains a pointer to the process table entry for this program
	;; find the previous program

	ADDUS	%G2	%G0	48 	;the pointer
	COPY	%G3	%G0

	BEQ	+prev	%G0	*%G2 	;branch if the next process is the beginning one - we have found the end
not_prev:
	COPY	%G3	*%G2	 	;go to next process
	ADDUS	%G2	%G3	48 	;the next pointer
	BEQ	+prev	%G0	*%G2 	;branch if the next process is the beginning one - we have found the end
	JUMP	+not_prev

prev:	;;we have found the previous process

	;; if this is the only process, issue by HALTing
	ADDUS	%G4	%G0	48
	BNEQ	+not_all_dead	%G0	*%G4
	COPY	%G0	0xa11dead
	HALT

not_all_dead:
	;; if this is the process at the head of the process table, issue by moving the *+HP to the start of the next process
	BNEQ	+not_head	*+process_t	%G0
	ADDUS	%G0	%G0	48
	COPY	%G1	*%G0		;next process
	COPY	*+process_t	%G1
	JUMP	+after_head

not_head:	
	ADDUS	%G0	%G0	48 	;pointer to next process than our EXITing process
	COPY	%G1	*%G0
after_head:
	;; %G2 contains the pointer of the prev process
	;; %G3 contains the prev process
	;; %G0 contains the pointer of EXITing process
	COPY	*%G2	*%G0	;move the pointers to exclude the EXITed process
	COPY	*%G0	0	;mark as EXITed
	COPY	%G0	%G3	;%G0 contins the prev process

	;; jump into another process
	JUMP	+next_process

error:	COPY	%G3	0xdead
	HALT
;;; SYSC INTERRUPT HANDLER


;;; CLOCK ALARM INTERRUPT HANDLER
	;; figure out or ask how to set aralrm - setalm 0x990897 1/0 1 relative 0 abs
alarm:
	COPY	*+p_g0	%G0
	COPY	%G0	+here4
	JUMP	+which
here4:	;now %G0 holds the process table entry of the interrupted program
	;; now save the return address (+1)
	ADDUS	*+ib_space	*+ib_space	16
	ADDUS	%G1	%G0	44 	;get the space for the return address
	COPY	*%G1	*+ib_space	;save the return address
	JUMP	+next_process
;;; CLOCK ALARM INTERRUPT HANDLER


;;; Go the next process on the process table, come here from EXIT and the ALARM
;;; requires that %G0 hold the process table address of the previous process
next_process:
	ADDUS	%G0	%G0	48
	COPY	%G0	*%G0		;go to the next process

	;; get where to jump into the program
	ADDUS	%G1	%G0	44
	COPY	*+return_to	*%G1

	;; re-set the alarm interrupt
	ADDUS	%G5	+alarm_to	4
	COPY	*+alarm_to	0x0
	COPY	*%G5	0x30
	SETALM	*+alarm_to	*+alarm_at

	;; restore the registers
	COPY	*+restored	+new_p
	JUMP	+restore
new_p:
	JUMPMD	*+return_to	*+mode

;;; Go the next process on the process table


;;; RAM allocator
allocator:
	;; look for number of bytes
	COPY 	*+where_bytes	+HP
	ADDUS	*+HP	*+HP	*+bytes_no
	JUMP +pls_all
;;; RAM allocator
;;; mem_alloc procedure allocates memory in kernerls heap
	;; Parameters: [%FP] = # of spaces requested
	;; Returns: free space pointer

_procedure_mem_alloc:

	;; Preserve Registers 
	SUBUS	%SP	%SP	4
	COPY	*%SP	%G1
	SUBUS	%SP	%SP	4
	COPY	*%SP	%G2

	COPY	%G0	*%FP
	ADDUS	%G2	%FP	12
	ADDUS	*%G2	*+free_space_pointer 4 ;Return value set to pointer
	ADDUS	*+free_space_pointer	*+free_space_pointer	%G0 ;free_space_pointer now holds an incremented value

	;; Reset registers
	COPY	%G2	*%SP
	ADDUS	%SP	%SP	4
	COPY	%G1	*%SP
	ADDUS	%SP	%SP	4
	ADDUS	%FP	%FP	8
	JUMP	*%FP
_procedure_special_mem_alloc:
	;; Preserve Registers 
	SUBUS	%SP	%SP	4
	COPY	*%SP	%G1
	SUBUS	%SP	%SP	4
	COPY	*%SP	%G2


	COPY	%G2	*+free_space_pointer
	MOD	%G2	%G2	4096
	SUBUS 	%G3	4096	%G2		
	ADDUS	*+free_space_pointer	%G3	*+free_space_pointer

	COPY	%G0	*%FP
	ADDUS	%G2	%FP	12
	COPY	*%G2	*+free_space_pointer  ;Return value set to pointer
	ADDUS	*+free_space_pointer	*+free_space_pointer	%G0 ;free_space_pointer now holds an incremented value

	;; Reset registers
	COPY	%G2	*%SP
	ADDUS	%SP	%SP	4
	COPY	%G1	*%SP
	ADDUS	%SP	%SP	4
	ADDUS	%FP	%FP	8
	JUMP	*%FP
;;; System call handler must examine %G0 and then call whichever system call it indicates
;;; Preserve registers, and all that.  Give execute the instance of ROM we search
;;; CPU scheduler add one program
scheduler:	
	;; %G3 is holding the last thing on the process table
	;; scheduled: begin,end,parent,%Gx,%SP,%FP,returnAddress,nextPointer

	ADDUS	%G4	%G3	52 	;go to next space
	;; change ^ this to use where_bytes
	COPY	*%G4	*+prg1_b	;store the beginning of the program
	ADDUS	%G4	%G4	4
	COPY	*%G4	*+prg1_e	;store the end of the program
	ADDUS	%G4	%G4	4
	;; parent field is empty
	ADDUS	%G4	%G4	4
	;; registers (%Gx and %SP, %FP = 8)
	ADDUS	%G4	%G4	32
	;; return field is the start of the program
	COPY	*%G4	*+prg1_b
	ADDUS	%G4	%G4	4
	;; now the pointer field. leave this as the last item in the process

	;; %G3 is holding the last thing on the process table
	ADDUS	%G3	%G3	48 	;go to the last pointer
	COPY	*%G4	*%G3		;move pointer that was in the last thing to here
	ADDUS	%G4	%G3	4	;move to the beginning ot this entry
	;; change ^
	COPY	*%G3	%G4		;copy into the pointer of the last one, this process
	JUMP 	+pls_sch
;;; CPU scheduler add one program

;;; find out which program called and save its registers
;;; requires a return address in %G0
;;; returns a pointer to the program in %G0
which:	COPY	*+myG1	%G1
	COPY	*+myreturn	%G0

	COPY	%G0	*+process_t 		;go to first process table entry
	COPY	%G1	%G0
	BLT	+find_p	*+ib_space	*%G0 	;begin
	ADDUS	%G0	%G0	4
	BGT	+find_p	*+ib_space	*%G0 	;end
	;; found thing
	JUMP	+found_p

find_p:	ADDUS	%G1	%G1	48 ;go to next pointer
	COPY	%G1	*%G1	   ;go to next
	BLT	+find_p	*+ib_space	*%G1 ;begin
	ADDUS	%G0	%G1	4
	BGT	+find_p	*+ib_space	*%G0 ;end

found_p:	;; found thing
	ADDUS	%G0	%G1	12
	COPY	*%G0	*+p_g0
	ADDUS 	%G0	%G0	4
	COPY	*%G0	*+myG1
	ADDUS 	%G0	%G0	4
	COPY	*%G0	%G2
	ADDUS 	%G0	%G0	4
	COPY	*%G0	%G3
	ADDUS 	%G0	%G0	4
	COPY	*%G0	%G4
	ADDUS 	%G0	%G0	4
	COPY	*%G0	%G5
	ADDUS 	%G0	%G0	4
	COPY	*%G0	%SP
	ADDUS 	%G0	%G0	4
	COPY	*%G0	%FP

	COPY	%G0	%G1	;get the relevant program pointer
	JUMP	*+myreturn
;;; find out which program called and save its registers

;;; restore registers to the ones stored in the process table entry %G0 is pointing at
restore:
	ADDUS	%G0	%G0	16
	COPY	%G1	*%G0
	ADDUS	%G0	%G0	4
	COPY	%G2	*%G0
	ADDUS	%G0	%G0	4
	COPY	%G3	*%G0
	ADDUS	%G0	%G0	4
	COPY	%G4	*%G0
	ADDUS	%G0	%G0	4
	COPY	%G5	*%G0
	ADDUS	%G0	%G0	4
	COPY	%SP	*%G0
	ADDUS	%G0	%G0	4
	COPY	%FP	*%G0
	SUBUS	%G0	%G0	28
	COPY	%G0	*%G0

	JUMP	*+restored
;;; restore registers to the ones stored in the process table entry %G0 is pointing at
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

	BEQ	+find_device_loop_failure *%G2	0

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



	.Numeric	

_static_device_table_base: 	0x00001000
_static_dt_entry_size:		12
_static_dt_base_offset:		4
_static_dt_limit_offset:	8
_static_none_device_code:	0
_static_controller_device_code:	1
_static_ROM_device_code:	2
_static_RAM_device_code:	3
_static_console_device_code:	4


const:	0x100
kernel_Upper_Page_Table:	0
kernel_Lower_Page_Table:	0
BC:	0x00001000		;the bus controller	
hey:	0xdead

mode:	0x2

RAM_e:	0			;holding the RAM and Kernel ends, just in case
Ker_e:	0


trap_t:	0			;this is the trap table
	0
	0
	0
	0
	0
	0
	0
	0
	0

ib_space:	0		;for the instruction buffer register
	0

prg1_b:	0
prg1_e:	0

ROM_n:	0			;number of ROMs other than the first three (BIOS, Kernel, init)

k_g0:	0			;backups of the kernel's registers before a call is made
k_g1:	0
k_g2:	0
k_g3:	0
k_g4:	0
k_g5:	0

p_g0:	0			;just in case, also, p_g0 is used in the 'which' function
p_g1:	0
p_g2:	0
p_g3:	0
p_g4:	0
p_g5:	0

alarm_to:	0		;for the clock alarm interrupt - store the value for the alarm here, to refer to in the first opperand
		0
alarm_at:	1		;1/0 relative or absolute counter for alarm (to cycle counter)

where_bytes:	0		;for the 'allocate' function
bytes_no:	0

myG1:	0			;for the 'which' function
myreturn:	0

restored:	0		;for the 'restore' function: which other function called the restore function

return_to:	0		;for the 'next_process' function - where in the process to return to

stack_end:	0		;hold initial %SP value
HP:	0			;heap pointer
process_t:	0		;here begins the process table (starts at heap_start)
heap_start:	0		;heap starts here
free_space_pointer:	0
