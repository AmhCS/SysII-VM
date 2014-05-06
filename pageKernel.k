#create a page table for the kernel to correlate the physical address space
#to paged space

#What is the proper name for the memory allocater procedure in the kernel we are using
procedure extern memalloc( 4 x)

#Same question for this procedure
procedure extern find_device( 4 x, 4 y)

procedure pageKernel ()
	  	     [4 RAMlim, 4 UPbase, 4 LPbase, 4 LPlim, 4 num]
{
	(= &RAMlim (find_device(2, 1)))
	(= &RAMlim *RAMlim)

	(= &UPbase (memAlloc(1024)))
	asm("COPY  *+kernel_Page_Table UPbase") 
	(= &LPbase (memAlloc(1024)))

	(= *UPbase &LPbase)
	(= &LPlim (+ &LPbase 1023)
	(= &num 0)

	while(< &LPbase &LPlim){
#Do we want to set the rwx bits in the 12 latter bits in the LPT now?
#If so, where is the order of the bits specified?
		(= *LPbase &num)
		(= &num (+ &num 1))
		(= &LPbase (+ &num &LPBase))
		}

#Does setting the page table register automatically begin paging, or do we need to jump modes somehow?
#How should we reference a variable we have created in the k code in an assembly injection?
asm("SETPTR	UPbase)
    

}
