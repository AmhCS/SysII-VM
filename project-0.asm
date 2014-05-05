;;; project-0 = program that does project-0.

;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Terri-Anne Hultum && Connor Bottum ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	.Code

;;; The entry point.
__start:

	;; Initialize the stack at the limit.
	COPY	%SP	*+limit
	
	;; Create a pointer to the beginning of the bus controller
	COPY	%G1	*+BC		;this is correct

	;; Find the RAM
f_RAM:	ADDUS 	%G1 	%G1 	12
	BNEQ 	+f_RAM 	*%G1 	3
	ADDUS 	%G1 	%G1 	4
	COPY	%G2 	*%G1		;%G2 now contains the RAM_begin YES**
	ADDUS 	%G1 	%G1 	4
	COPY 	%G3 	*%G1		;%G3 now contains the RAM_end

	COPY 	%G0	%G2		;%G0 now contains the RAM_begin YES**
	
	;; Find the second ROM (the Kernel)
	COPY	%G1	*+BC
f_ROM:	ADDUS 	%G1 	%G1 	12
	BNEQ 	+f_ROM 	*%G1 	2	;will stop at the first ROM
f_2ROM:	ADDUS 	%G1 	%G1 	12
	BNEQ 	+f_2ROM	*%G1 	2	;will stop at the second ROM
	
	ADDUS 	%G1 	%G1 	4
	COPY 	%G4 	*%G1		;%G4 now contains the ROM_begin
	ADDUS 	%G1 	%G1 	4
	COPY 	%G5 	*%G1		;%G5 now contains the ROM_end

	;;  We now have the locations of RAM and the Kernel

	;; %G0 holds the Kernel_begin in RAM (RAM_begin)
	;; %G1 is free (holds the Kernel_end)
	;; %G2 holds the Kernel_begin in RAM (RAM_begin)
	;; %G3 holds the RAM_end
	;; %G4 holds the Kernel_begin
	;; %G5 holds the Kernel_end

	;; (20)
	
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;; Copying the Kernel into RAM
	
l_top:	BEQ 	+l_end 	%G4 	%G5	;stops when Kernel reaches end
	COPY 	*%G0 	*%G4		;copy into RAM
	ADDUS 	%G4 	%G4 	4
	ADDUS 	%G0 	%G0 	4
	JUMP 	+l_top
	;; now Kernel is in RAM

l_end:	COPY 	%G5	%G0		;so that %G5 holds the end of the Kernel in RAM
	COPY 	%G0	%G2		;hold on to the RAM_begin
	
	;; %G0 holds the Kernel_begin in RAM (RAM_begin)
	;; %G1 is working along the BC (holds the BC_Kernel_end)
	;; %G2 holds the Kernel_begin in RAM (RAM_begin)
	;; %G3 holds the RAM_end
	;; %G4 is free *
	;; %G5 holds the Kernel_end in RAM

	;; ****

;;; ---
	;; Finding the number of ROMS given
	;; the kernel currently need THIS value of %G1 **********

	COPY 	%G2	%G1	;the kernel currently need THIS value of %G1

	;; Find the ROMs
	COPY	%G2	*+BC
	ADDUS	%G2	%G2	48
	;; now are at the next one after Kernel

	ADDUS	%G4	0	0
	
num:	BEQ	+numb	*%G2	0
	BEQ	+two	*%G2	2
	ADDUS	%G2	%G2	12	
	JUMP	+num

two:	ADDUS	%G4	%G4	1
	ADDUS	%G2	%G2	12	
	JUMP	+num
	
numb:	SUBUS	%G4	%G4	1

;;; ---
	
	JUMP 	%G0		;jump to the start of the Kernel

	;; %G0 holds the Kernel_begin in RAM (RAM_begin)
	;; %G1 is working along the BC (holds the BC_Kernel_end)
	;; %G2 holds the Kernel_begin in RAM (RAM_begin)
	;; %G3 holds the RAM_end
	;; %G4 holds the number of ROMs
	;; %G5 holds the Kernel_end in RAM
	
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.Numeric
	
	;; Assume (at least) a 16 KB main memory.
limit:	0x5000

	;; source values and known addresses
BC:	0x00001000		;the bus controller
