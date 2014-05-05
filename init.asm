;;; init = calls the kernel to make new processes for each of the remaining executable images.

;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Terri-Anne Hultum && Connor Bottum ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	.Code

;;; The entry point.
__start:

	ADDUS	%G0	0	9 ;show that this is a SYSCALL, not an error
	ADDUS	%G1	0	1 ;show that this SYSC is for an IMAGE_COUNT
	SYSC		       	  ;now %G0 will hold the number of ROMs
	COPY	%G3	%G0
	
	;; now we have the nuber of ROMS, start all the processses
not_done:
	BEQ	+done	%G3	0

	ADDUS	%G0	0	9 ;show that this is a SYSCALL, not an error
	ADDUS	%G1	0	2 ;show that this SYSC is for an EXECUTE
	ADDUS	%G2	0	%G3 ;show that we want to execute this exectuable ROM beyond the first three.
	SYSC
	SUBUS	%G3	%G3	1
	JUMP	+not_done
	
done:	
	ADDUS	%G0	0	9 ;show that this is a SYSCALL, not an error
	ADDUS	%G1	0	3 ;show that this SYSC is for an EXIT
	SYSC
	
	.Numeric

heya:	0xca11ed