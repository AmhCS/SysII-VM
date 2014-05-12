;;; William Poss and Avery Klemmer
	.Code

	COPY *+invalid_address		+null_interrupt
	COPY *+invalid_register		+null_interrupt
	COPY *+bus_error		+null_interrupt
	COPY *+clock_alarm		+clock_alarm_handler
	COPY *+divide_by_zero		+null_interrupt
	COPY *+overflow			+null_interrupt
	COPY *+invalid_instruction	+null_interrupt
	COPY *+permission_violation	+null_interrupt	
	COPY *+invalid_shift_amount	+null_interrupt
	COPY *+system_call		+system_call_handler

	SETTBR	+tt
	SETIBR	+int_buff

	ADDUS	*+free_space_pointer	+free_space_pointer	4 ;Save the end of the statics (first free space) into the free_space_pointer
	COPY	%G0	*+free_space_pointer
	;; ADDUS	*+process_table		+free_space_pointer	4
	ADDUS	*+kernel_end		+free_space_pointer	16000
	COPY	%SP	*+kernel_end
	COPY	%FP	%SP
	ADDUS *+newPortion	%SP	16

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
	JUMPMD +ROMloop 0xc	
	COPY	%G0	*+kernel_Upper_Page_Table
	COPY	%G1	*+kernel_Lower_Page_Table

ROMloop:
	BEQ	+init	*%G0	0
	;;If the type is = 2:
	;; 	increment count & check if this is 3rd rom (aka init)
	BNEQ	+ROMloopbottom	*%G0	2
	ADDUS	%G2	%G2	1  ;%G2 = # of ROMs found
	COPY	*+img_count	%G2 ;img_count holds the count for # of ROMs

	BNEQ	+ROMloopbottom	%G2	3   ;When we have found third ROM (init), call EXECUTE	
	;; Caller prologue
	SUBUS 	%SP	%SP	8
	COPY	*%SP	%FP
	SUBUS	%SP	%SP	4
	COPY	*%SP	%G2
	COPY	%FP	%SP
	ADDUS	%G3	%FP	8
	;; Call EXECUTE on init
	CALL	+EXECUTE	*%G3
	;; Caller epilogue
	SUBUS	%FP	%FP	4

	COPY	%FP	*%FP
	ADDUS	%SP	%SP	12

ROMloopbottom:
	ADDUS	%G0	%G0	12
	JUMP	+ROMloop

init:	ADDUS	%G0	*+process_table		8
	COPY	*+curr_process	*+process_table
	SETBS	*%G0
	ADDUS	%G0	%G0	4
	SETLM	*%G0
	COPY	%G0	0
	JUMPMD	%G0	14



	;; DMA: third to last spot in RAM (G3) gets source addr
	;;      second to last spot in RAM(G2) gets dest addr
	;; 	last spot in RAM(G1) gets ROM length

;;; COPY:
;;; 	will use DMA to copy a process into RAM
;;; 	Returns: nothing
;;; 	Locals:	(currently)	%G5 = ROMLimit
;;;				%G4 = ROMBase
;;; Caller preserved registers:
;;;	[%SP - 4] = %G0
;;; 	[%SP - 8] = %G1
;;; Params:
;;;	[%FP +0] =  limit
;;; 	[%FP +4] =  base
;;; 
COPY:
;;; Callee Prologue
	;; Preserve caller registers
	SUBUS	%SP		%SP		4
	COPY	*%SP		%G0
	SUBUS	%SP		%SP		4
	COPY	*%SP		%G1

;;; Call Function
	COPY	%G1	0x00001008 ;%G1 holds the pointer to bus controller limit
	COPY	%G1	*%G1	   ;%G1 holds the address of the bus controller limit

	SUBUS %G3	%G1	12
       	SUBUS %G2	%G1	8
	SUBUS %G1	%G1	4

	;; Initialize locals
	COPY	%G5	*%FP	;%G5 = ROMLimit
	ADDUS	%G0	%FP	4
	COPY	%G4	*%G0	;%G4 = ROMBase


	COPY *%G3	%G4
	COPY *%G2	*+newPortion
	SUBUS %G2	%G5	%G4 ;%G2 = length of portion of code = ROMLimit - ROMBase

;;; 	ADDUS %G2	%G2	0x00000100 ;Give the process 100 extra spaces in RAM for stack and heap !!!!!!!!!!!!!!!!!!!!!!!

	COPY	*%G1	%G2
	COPY	%G3	*+newPortion 		;%G3 = Physical base
	ADDUS	*+newPortion	%G2	*+newPortion
	ADDUS	*+newPortion	*+newPortion	104 ;16 buffer spaces
	COPY	%G4	*+newPortion
	;; SUBUS	%G4	*+newPortion	16 %G4 = Physical Limit 

	;; Return Base in RAM(%G3) and Limit in RAM(%G4)
	ADDUS	%FP	%FP	20
	COPY	*%FP	%G4
	SUBUS	%FP	%FP	4
	COPY	*%FP	%G3

	;; Callee epilogue
	COPY	%G1	*%SP
	ADDUS	%SP	%SP	4
	COPY	%G0	*%SP
	ADDUS   %SP     %SP     4
	SUBUS	%FP	%FP	4

	JUMP	*%FP


;;; IMAGE_COUNT: saves the total # of ROMs into rv
IMAGE_COUNT:
	ADDUS	%FP	%FP	8	
	COPY	*%FP	*+img_count
	SUBUS	%FP	%FP	4
	JUMP	*%FP


;;; The EXECUTE procedure will copy the new process into RAM
;;; and enter the new process into the process table.
;;; Callee preserved registers:
;;;   [%SP - 4]:  G0
;;;   [%SP - 8]:  G1
;;;   [%SP - 12]: G2
;;;   [%SP - 16]: G3
;;;   [%SP - 20]: G4
;;;   [%SP - 24]: G5
;;; Parameters:
;;;   [%FP +0] =  device instance
;;; Caller preserved reisters:
;;;   [%FP + 8]	= FP
;;; Locals:
;;; 	%G0:	Incremented pointer into process table entry
;;; 	%G1:	Base of new process in RAM
;;; 	%G2:	Limit of new Process in RAM

EXECUTE:
;;; Callee Prologue


	;; Preserve Registers
	SUBUS	%SP	%SP	4
	COPY	*%SP	%G0
	SUBUS	%SP	%SP	4
	COPY	*%SP	%G1
	SUBUS	%SP	%SP	4
	COPY	*%SP	%G2
	SUBUS	%SP	%SP	4
	COPY	*%SP	%G3
	SUBUS	%SP	%SP	4
	COPY	*%SP	%G4
	SUBUS	%SP	%SP	4
	COPY	*%SP	%G5

	COPY	%G1	*%FP

	;; Caller prologue
	SUBUS	%SP %SP	12
	COPY	*%SP %FP
	SUBUS	%SP %SP	4
	COPY	*%SP %G1
	SUBUS	%SP %SP 4
	COPY	*%SP 2
	COPY	%FP %SP
	ADDUS	%G0	%FP	12
	;; Call
	CALL +_procedure_find_device	*%G0
	;; Caller epilogue
	ADDUS	%G2	%FP	16	
	COPY	%G2	*%G2	;%G2 = rv
	ADDUS	%FP	%FP	8
	COPY	%FP	*%FP
	ADDUS	%SP	%SP	20

	;; Initialize 
	ADDUS	%G2	%G2	4
	COPY	%G0	*%G2	;G0 holds the base of new process
	ADDUS	%G2	%G2	4
	COPY	%G1	*%G2	;G1 now holds the limit of the new process


;;; Call Function

	;; Caller prologue
	SUBUS	%SP	%SP	16
	COPY	*%SP	%FP
	SUBUS	%SP	%SP	4
	COPY	*%SP	%G0
	SUBUS	%SP	%SP	4
	COPY	*%SP	%G1
	COPY	%FP	%SP
	ADDUS	%G0	%FP	12

	;; Call COPY
;;; NOW WHEN WE CALL COPY WE MUST CHECK IF WE ARE COPYING KERNEL INTO BASE PAGES, IF SO CHANGE BITS SO RWX DISABLED
	CALL	+COPY	*%G0

	;; Caller epilogue
	ADDUS   %SP	%SP	16
	COPY	%G1	*%SP	;base
	ADDUS	%SP	%SP	4
	COPY	%G2	*%SP	;lim
	SUBUS	%FP	%FP	4
	COPY	%FP	*%FP
	ADDUS	%SP	%SP	4

;;; Create Process table entry and save info into entry
	;; Give each entry 15 words (Forward link, Reverse link, Base, Lim, Ready?, G0, G1,
	;; G2, G3, G4, G5, FP, SP, IP, Parent ID)

	;; Caller prologue

	SUBUS	%SP	%SP	12
	COPY	*%SP	%FP
	SUBUS	%SP	%SP	4
	COPY	*%SP	60
	COPY	%FP	%SP
	ADDUS	%G0	%FP	8

	;; Call memalloc
	CALL	+_procedure_mem_alloc	*%G0

	;; Caller epilogue
	SUBUS	%FP	%FP	4
	COPY	%FP	*%FP
	ADDUS	%SP	%SP	16


	SUBUS	%G3	%SP	4 ;%G3 points to RV
	COPY	%G0	*%G3	;%G0 holds return value(new process entry addr) of mem_alloc

;;; Process table entry:
	;; 1) Link to next process
	;; 2) Link to prev process
	;; 3) Base
	;; 4) Limit
	;; 5) Ready?
	;; 6) %G0
	;; 7) %G1
	;; 8) %G2
	;; 9) %G3
	;;10) %G4
	;;11) %G5
	;;12) %FP
	;;13) %SP
	;;14) IP
	;;15) Parent Process ID


;;; 1) Save the new process table entry's pointer in the old process table entry's reverse link 
	BEQ	+hop	*+process_table	0

	ADDUS	%G3	*+process_table	4
	COPY	*%G3	%G0

hop:	
;;; 2) Save the current process entry pointer into the new process table entry
	COPY	*%G0	*+process_table
;;; 3) Update pointer to process table in statics to new entry
	COPY	*+process_table	%G0

	ADDUS	%G0	%G0	4
	COPY	*%G0	0
;;; 4) Fill in the new entry
	ADDUS	%G0	%G0	4
	COPY	*%G0	%G1	;Base of process in RAM
	ADDUS	%G0	%G0	4
	COPY	*%G0	%G2	;Limit of process in RAM
	ADDUS	%G0	%G0	4
	COPY	*%G0	1	;Status Ready?
	ADDUS	%G0	%G0	36 ;Allocate the space for registers and IP
	COPY	*%G0	0
	ADDUS 	%G0	%G0 4
	COPY	*%G0	*+curr_process	
;;; Callee epilogue

	COPY	%G5	*%SP
	ADDUS	%SP	%SP	4
	COPY	%G4	*%SP
	ADDUS	%SP	%SP	4
	COPY	%G3	*%SP
	ADDUS	%SP	%SP	4
	COPY	%G2	*%SP
	ADDUS	%SP	%SP	4
	COPY	%G1	*%SP
	ADDUS	%SP	%SP	4
	COPY	%G0	*%SP
	ADDUS	%SP	%SP	4

	ADDUS	%FP	%FP	8
	JUMP	*%FP

EXIT:
	COPY	%G0	*+curr_process	
	COPY	%G0	*%G0		;%G0 now holds forward link of process exitin
	BNEQ	+skip1	*+curr_process	*+process_table
	COPY	*+process_table	%G0

	BNEQ	+skip1	%G0	0
	COPY	*+curr_process	0
	JUMP	+skip

skip1:	ADDUS	%G1	*+curr_process 4	
	COPY	%G1	*%G1		;%G1 now holds reverse link of process exiting


	ADDUS	%G2	%G0	4 	;%G2 = second entry of forward linked process

	COPY	*%G2	%G1 		;Set forward process' reverse link to
	BEQ	+skip	%G1	0
							;; reverse link of process exiting
	COPY	*%G1	%G0		;Set reverse linked process' forward link to

					;;forward link of process exiting

skip:	ADDUS	%FP	%FP	8
	JUMP	*%FP



;;; mem_alloc procedure allocates memory in kernerls heap
	;; Parameters: [%FP] = # of spaces requested
	;; Returns: free space pointer
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

;;; System call handler must examine %G0 and then call whichever system call it indicates
;;; Preserve registers, and all that.  Give execute the instance of ROM we search
system_call_handler:
	COPY *+x	%G0
	COPY *+y	%G1
	COPY %G0 *+curr_process


	ADDUS %G0	%G0	20	
	COPY  *%G0	*+x
	ADDUS %G0	%G0	4
	COPY *%G0	%G1
	ADDUS %G0	%G0	4
	COPY *%G0	%G2
	ADDUS %G0	%G0	4
	COPY *%G0	%G3
	ADDUS %G0	%G0	4
	COPY *%G0	%G4
	ADDUS %G0	%G0	4
	COPY *%G0	%G5
	ADDUS %G0	%G0	4
	COPY *%G0	%FP
	ADDUS %G0	%G0	4
	COPY *%G0	%SP
	ADDUS %G0	%G0	4
	ADDUS *+int_buff	*+int_buff	16
	COPY *%G0	*+int_buff

	COPY %G0	*+x

	COPY %SP	*+kernel_end
	COPY %FP	%SP


	BNEQ	+next1	%G0	1
	;; Caller prologue
	SUBUS	%SP	%SP	12
	COPY	*%SP	%FP
	COPY	%FP	%SP
	ADDUS	%G1	%FP	4
	;; Call
	CALL	+IMAGE_COUNT	*%G1
	;; Calller epilogue
	ADDUS	%FP	%FP	4
	COPY	%G5	*%FP	;return image count in %G5
	COPY	%FP	*%SP
	ADDUS	%SP	%SP	12


next1:	BNEQ	+next2	%G0	2
	;; Caller prologue
	SUBUS %SP	%SP	8
	COPY *%SP	%FP	
	SUBUS %SP	%SP	4
	COPY  *%SP	*+y
	COPY  %FP	%SP
	ADDUS %G1	%FP	8	
	;; Call
	CALL	+EXECUTE	*%G1
	;; Caller epilogue
	SUBUS	%FP	%FP	4
	COPY	%FP	*%FP
	ADDUS	%SP	%SP	16



next2:  BNEQ	+scheduler %G0	3
	SUBUS	%SP	%SP	8
	COPY	*%SP	%FP
	ADDUS	%G1	%FP	8
	CALL	+EXIT	*%G1
	SUBUS	%FP	%FP	4
	COPY	%FP	*%FP
	ADDUS	%SP	%SP	8


	JUMP	+scheduler



scheduler:
	BNEQ	+continue	*+curr_process	0
	HALT

continue:	
	COPY	%G0	*+curr_process
	COPY	%G0	*%G0


	BNEQ	+RUN	%G0	0 ;IF no forwardlinked process
	ADDUS	%G0	*+curr_process	4
	COPY	%G0	*%G0
	BNEQ	+RUN	%G0	0 ;IF neither forward nor reverse linked process
	COPY	%G0	*+curr_process



RUN:
;;; Preserve process to its state and jump back
	COPY	*+curr_process %G0
	COPY	*+x	%SP
	ADDUS 	%SP  *+curr_process 8
	SETBS	*%SP
	ADDUS	%SP %SP	4
	SETLM	*%SP
	ADDUS	%SP %SP	8
	COPY	%G0 *%SP
	ADDUS   %SP %SP 4
	COPY	%G1 *%SP
	ADDUS	%SP %SP	4
	COPY	%G2 *%SP
	ADDUS	%SP %SP 4
	COPY	%G3 *%SP
	ADDUS 	%SP %SP 4 
	COPY	%G4 *%SP
	ADDUS   %SP %SP 4
	;; COPY	%G5 *%SP
	ADDUS 	%SP %SP 4
	COPY	%FP *%SP
	ADDUS	%SP %SP 8	;points to old IP
	COPY	*+y *%SP

	SUBUS   %SP %SP 4

	COPY	%SP *%SP

	JUMPMD	*+y	14




clock_alarm_handler:
;;; Must store current process' registers and IP into its process table entry


	ADDUS %G0	%G0	20	
	COPY  *%G0	*+x
	ADDUS %G0	%G0	4
	COPY *%G0	%G1
	ADDUS %G0	%G0	4
	COPY *%G0	%G2
	ADDUS %G0	%G0	4
	COPY *%G0	%G3
	ADDUS %G0	%G0	4
	COPY *%G0	%G4
	ADDUS %G0	%G0	4
	COPY *%G0	%G5
	ADDUS %G0	%G0	4
	COPY *%G0	%FP
	ADDUS %G0	%G0	4
	COPY *%G0	%SP
	ADDUS %G0	%G0	4
	COPY *%G0	*+int_buff

	JUMP	+scheduler


;;; ================================================================================================================================	
;;; Procedure: find_device
;;; Callee preserved registers:
;;;   [%FP - 4]:  G0
;;;   [%FP - 8]:  G1
;;;   [%FP - 12]: G2
;;;   [%FP - 16]: G4
;;; Parameters:
;;;   [%FP + 0]: The device type to find.
;;;   [%FP + 4]: The instance of the given device type to find (e.g., the 3rd ROM).
;;; Caller preserved registers:
;;;   [%FP + 8]:  FP
;;; Return address:
;;;   [%FP + 12]
;;; Return value:
;;;   [%FP + 16]: If found, a pointer to the correct device table entry; otherwise, null.
;;; Locals:
;;;   %G0: The device type to find (taken from parameter for convenience).
;;;   %G1: The instance of the given device type to find. (from parameter).
;;;   %G2: The current pointer into the device table.

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



null_interrupt:	HALT
	.Numeric
kernel_Upper_Page_Table:	0
kernel_Lower_Page_Table:	0

_static_device_table_base: 	0x00001000
_static_dt_entry_size:		12
_static_dt_base_offset:		4
_static_dt_limit_offset:	8
_static_none_device_code:	0
_static_controller_device_code:	1
_static_ROM_device_code:	2
_static_RAM_device_code:	3
_static_console_device_code:	4


		;; Other constants.
_static_min_RAM_KB:		64
_static_bytes_per_KB:		1024
_static_KB_size:		32	; KB taken by the kernel.
x:	 00
y:	 00
newPortion:	0
img_count:	0

process_table:	00
curr_process:	00
kernel_end:	00
last_IP:	00

tt:	
invalid_address:	0000
invalid_register:	0000
bus_error:		0000
clock_alarm:		0000
divide_by_zero:		0000
overflow:		0000
invalid_instruction:	0000
permission_violation:	0000
invalid_shift_amount:	0000
system_call:		0000
int_buff:	0 0 
free_space_pointer:	0
