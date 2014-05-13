#Teddy Seem, Alex Kang, Thais Correia
# add READ.ME

var 4 start_pageList
var 4 hold_thisPage

#---------------------------------Initialize Page List-------------------------

procedure 0 InitializePageList(4 fsp 4 pNum)
                                [4 iterator 4 fsp_next]{
# fsp is pointer to freespace in the kernel, k is the number of pages total in the list
# Page aligned, have to make some dead space
# Add 1 to first twenty bits, then make last 12 bits 0

#If page-aligned, don't do this
(= &fsp (>> fsp 12))
(= &fsp (+ fsp 1))
(= &fsp (<< fsp 12))

(= &start_pageList fsp) #Make page_head start where the free space pointer is
#Loop through until we've reserved pNum pages
(= &iterator 1)
   while((not(== iterator pNum))) {

								(= &fsp_next (+ fsp 4096))#Store in the beginning of this page, the base of the next page
								(= fsp fsp_next)
								(= &fsp fsp_next)
        
                (= &iterator (+ iterator 1))#Increment iterator/ We've added one more page
        }

(= fsp 0) #Pointer is now at the last page, so make the first thing in that page 0 to signify that it's the last page


}


procedure 4 NextPage()[4 current_pointer]{
# need to give a free page to the kernel and take it off the linked list. before giving it to the kernel need to wipe it. 


	(= &current_pointer start_pageList)
	while(not(== current_pointer *(4)start_pageList)){
                (= current_pointer 0)
               (= &current_pointer (+ current_pointer 4))
  }

	(= &current_pointer start_pageList)
	(= &start_pageList *(4)start_pageList)

	

  return current_pointer

}

procedure 0 ReturnPage(4 p_add)[]{
# get an address and add it back to the front of the linked list.

  (= p_add start_pageList)
  (= &start_pageList p_add)

}
