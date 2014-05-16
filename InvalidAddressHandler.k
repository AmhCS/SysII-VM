# Code for the invalid address interrupt handler.
# A chunk of code should be added to the kernel that
#  1. Saves all registers of the interrupted process in its process table entry.
#  2. Gets the second word of the interrupt buffer, which is the memory address that caused the interrupt.
#  3. Places that word on the stack as a parameter when calling InvalidAddressHandler
#  4. After InvalidAddressHandler returns, jump to the code for scheduling a new process.

# mem_alloc is a procedure in the kernel that allocates memory
procedure extern 4 mem_alloc(4 bytes_to_alloc)

# FindEntry takes in a memory address and returns two words.
# If the LPT that maps that memory address exists, the first word
# is the address of that LPT and the second word is 0.
# If the LPT does not exist, the first word is a pointer to the word
# in the UPT that should contain a pointer to the LPT, and the second
# word is not 0.
procedure extern 4 FindEntry(4 interrupt_address)

# Allocates a new free page and returns a pointer to it.
procedure extern 4 NextPage()

# Takes a pointer to an LPT and a memory address, and returns # a pointer to
# the LPT word that should contain a pointer to the page containing # that
# address
procedure extern 4 WalkLPT(4 lpt 4 address)

# This main procedure is not useful, but when compiled
# it will provide a useful model of how to call InvalidAddressHandler
# in assembly.
procedure 4 main()
		[4 ia]
{
	(InvalidAddressHandler ia)
}


# allocates a new page and returns the correct
# value to be stored in the LPT
procedure 4 NewEntry()
		    [4 to_return
		     4 last_byte_pointer]
{
  (= &to_return (NextPage))
  # get the last byte and set all 8 bits to their
  # correct metadata values
  (= &last_byte_pointer (+ 12 &to_return))
  (= last_byte_pointer 0b11100011)
  # set the remaining metadata bits
  (= &last_byte_pointer (- last_byte_pointer 4))
  (= last_byte_pointer (bitand *(1)last_byte_pointer 0b11111100))
# COPY last_byte_of_to_return 0b11100010
# AND next_last_byte 0b11111100
# Copy 0 into bit 0 of to_return	// valid
# Copy 1 into bit 1 of to_return	// present
# Copy 0 into bits 2-4 of to_return	// rwx for supervisor mode
# Copy 1 into bits 5-7 of to_return	// rwx for user mode
# Copy 0 into bit 8 of to_return	// referenced
# Copy 0 into bit 9 of to_return	// dirty
# bits 10-11 are unused
  return to_return
}

procedure 0 InvalidAddressHandler (4 interrupt_address)
				   [8 entry_return
				   4 entry_address
				   4 entry_value
				   4 lpt_present
				   4 LPT_address
				   4 correct_entry]
{
  # call FindEntry
  (= &entry_return (FindEntry interrupt_address))
  # get the two words of the return
  (= &entry_address *(4)(+ 4 entry_return))
  (= &lpt_present *(4)(+ 4 entry_return))

  # supposing the LPT is present
  ifthenelse((== 0 lpt_present))
  {
    # if the entry already exists there is a problem
    ifthen((!= 0 *(4)entry_address))
    {
       # this behavior could be replaced with something more useful
       asm("        HALT")
    }
    # if the entry does not exist, alloc a new page and fill it
    (= &entry_value (NewEntry))
    (= entry_address entry_value)
  }
  # if the lpt does not exist
  else
  {
	# make a new LPT
  	(= &LPT_address (NewLPT))
	(= entry_address LPT_address)
	# find the correct entry in the new LPT
	(= &correct_entry (WalkLPT LPT_address interrupt_address))
	# make a new page and fill it
	(= &entry_value (NewEntry))
	(= correct_entry entry_value)
  }
}


procedure 4 NewLPT()
		  [4 free_space
		   4 current_byte_addr
		   4 lpt_end]
{
  # we alloc a new page; have to call NextPage so it will
  # be page-aligned
  (= &free_space (NextPage)) 
  (= &current_byte_addr free_space)
  # loop through and zero out every page value
  (= &lpt_end (+ free_space 4096))
  while ( (< current_byte_addr lpt_end) ) {
    (= current_byte_addr 0)
    (= &current_byte_addr (+ current_byte_addr 4))
  }
  return free_space
}
