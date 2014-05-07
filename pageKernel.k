#create a page table for the kernel to correlate the physical address space
#to paged space

#What is the proper name for the memory allocater procedure in the kernel we are using
procedure extern memalloc( 4 x)

#Same question for this procedure
procedure extern find_device( 4 x, 4 y)

procedure pageKernel ()
	  	     [4 RAMlim, 4 UPbase, 4 LPbase, 4 LPlim, 4 num]
{
	#Currently an unused local
	(= &RAMlim (find_device(2, 1)))
	(= &RAMlim *RAMlim)

	(= &UPbase (memAlloc(1024)))
	(= &LPbase (memAlloc(1024)))

	#Store the pointer to the kernel's upper page table in the statics
	#(and lower page table, for convenient access for other processes)in the statics
	asm("	SUBUS	%FP	%FP 8
		COPY  *+kernel_Upper_Page_Table *%FP
		SUBUS	%FP	%FP 4
		COPY  *+kernel_Lower_Page_Table	*%FP
		ADDUS	%FP	%FP 12") 

	(= *UPbase LPbase)
	(= &LPlim (+ LPbase 1024)
	
	#Initialize num to 
	(= &num 000000011111)

	while(< LPbase LPlim){

		(= &LPbase num)
		(= &num (+ num 10000000000))
		(= &LPbase (+ LPbase 4))
	
	}

#Does setting the page table register automatically begin paging, or do we need to jump modes somehow?
#How should we reference a variable we have created in the k code in an assembly injection?
asm("SUBUS %FP %FP 8
     SETPTR  *%FP
     JUMPMD +jump c #virtual addressing turned on by which bit? This should either be a 2 or a 4
jump: ADDUS %FP %FP 8")

}
