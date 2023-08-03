TITLE Project 5     (Proj5_Huffmasm.asm)

; Author: Mike Huffmaster
; Last Modified:
; OSU email address: Huffmasm@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:Project 5            Due Date:
; Description: The user will be introduced to the program. This program will create a list of 200 random 
;	integers in the range of 15 to 50. The program will then display the median, and the sorted list in ascending order. 
;	Lastly,the count of each number in the list will be displayed.

INCLUDE Irvine32.inc

LO = 15
HI = 50
ARRAYSIZE = 199

.data

intro_prompt	BYTE	"                   Array, Median, and Sorted Array         by Mike Huffmaster",13,10,13,10
				BYTE	"This program is going to create a list of 200 random integers between the range of 15 and 50.",13,10
				BYTE	"The program will then take this list and display the median and the list in ascending order.",13,10
				BYTE	"Finally, the total count of each number that occurred will be displayed to the user.",13,10,13,10,0
initial_array	BYTE	"The initial array:",13,10,13,10,0
sorted_array	BYTE	"The sorted array:",13,10,13,10,0
median			BYTE	"The median is: ",0
randArray		DWORD	ARRAYSIZE dup(?)
count			DWORD	?



.code
main PROC
	
	call Randomize

	push OFFSET intro_prompt
	call introduction
	
	push OFFSET randArray
	push count
	call fillArray

	
	push count
	push OFFSET initial_array
	push OFFSET randArray
	call displayList
	call CrLf
	

	push OFFSET randArray 
	call sortList

	push OFFSET median
	push OFFSET randArray
	call displayMedian
	call CrLf
	call CrLf

	push OFFSET sorted_array
	push OFFSET randArray
	call displayList

	Invoke ExitProcess,0	; exit to operating system
main ENDP

;---------------------------------------------------------------
;Name: introduction
;
;Introduces the program informs the user of the purpose of the program
;
;preconditions: none
;
;postconditions: EDX changed
;
;receives:	global strings
;
;returns: None
;---------------------------------------------------------------
introduction PROC
	
	push	EBP
	mov		EBP, ESP
	pushad

	mov		EDX, [EBP + 8]
	call	WriteString
	popad
	pop		EBP

	ret		8
introduction ENDP

;---------------------------------------------------------------
;Name: fillArray
;
;Generates random integers by subtracting the LO constant from the HI constant, getting a random number
;	in that range, the adding the LO constant back to the random number.  These are then saved in the memory loaction of
;	randArray
;
;preconditions: none
;
;postconditions: eax, ecx, esi changed 
;
;receives:	address of array and value of count on the stack
;
;returns: completed array memory address on stack
;---------------------------------------------------------------
fillArray PROC
	
	push	EBP
	mov		EBP, ESP
	mov		ECX, ARRAYSIZE			;loops until ARRAYSIZE constant is 0
	mov		ESI, [EBP + 12]			;address of array in esi		
	cmp		ECX, 0
	je		_endLoop

	_arrayLoop:
		mov		EAX, HI
		sub		EAX, LO
		call	RandomRange			;generate a random number 
		add		EAX, LO				;add LO to the number to be within bounds
		mov		[ESI], EAX			;add number to array
		add		ESI, TYPE DWORD	
		LOOP	_arrayLoop			

	_endLoop:
		pop	EBP
		ret 12
fillArray ENDP

;---------------------------------------------------------------
;Name: displayList
;
;This procedure displays the array with 20 numbers per line
;
;preconditions: none
;
;postconditions: 
;
;receives:	address of array on system stack
;
;returns: None
;---------------------------------------------------------------

displayList PROC
	
	push	EBP
	mov		EBP, ESP
	mov		EDX, [EBP+12]			;array message
	mov		ESI, [EBP + 8]			;address of array
	mov		ECX, ARRAYSIZE			;address of count
	mov		EBX, 0

	call	WriteString
	inc		ECX	
		_displayLoop:
			cmp		ECX, 1
			je		_break
			mov		EAX, [ESI]			;first element in array
			call	WriteDec
			mov		al, ' '				;spaces between numbers
			call	WriteChar
			add		ESI, TYPE DWORD		;move to next element in array
			inc		EBX					;increment number in that row, once row is at 20, new row
			cmp		EBX, 20
			je		_newRow			
			LOOP	_displayLoop

		_newRow:
			mov		EBX, 0
			call	CrLf
			LOOP	_displayLoop

	_break:
		pop		EBP
		ret 12
displayList ENDP

;---------------------------------------------------------------
;Name: sortList
;
;This procedure displays the array with 20 numbers per line
;
;preconditions: none
;
;postconditions: 
;
;receives:	address of array on system stack
;
;returns: None
;---------------------------------------------------------------

sortList PROC
	push	EBP
	mov		EBP, ESP
	mov		ECX, ARRAYSIZE
	dec		ECX								;array starts at position '0'
		
		_bubblesortL1:
			push	ECX
			mov		ESI, [EBP + 8]			;pointer to first number in array

		_bubblesortL2:
			mov		EAX, [ESI]				;move start of array in to eax
			mov		EBX, [ESI+4]
			cmp		EBX, EAX				;compare the next item in array to eax
			jg		_bubblesortL3			;if num is less than current eax, swap positions in memory
			pushad
			call	exchangeElements		;move the updated value to the current position 
			popad

		
		_bubblesortL3:
			add		ESI, 4					;move to the next number in the array
			LOOP	_bubblesortL2			;loop through comparing each number with the current position
			pop		ECX						;restore the outer loop counter
			LOOP	_bubblesortL1			;loop through each number in the array 
	
	
	pop	EBP
	ret 12
sortList ENDP

;---------------------------------------------------------------
;Name: exchangeElements
;
;This procedure displays the array with 20 numbers per line
;
;preconditions: none
;
;postconditions: 
;
;receives:	address of array on system stack
;
;returns: None
;---------------------------------------------------------------
exchangeElements PROC
	push	EBP
	mov		EBP, ESP
	mov		EAX, [ESI]
	mov		EBX, [ESI+4]
	mov		[ESI+4], EAX
	mov		[ESI], EBX
	
	pop		EBP
	ret		
exchangeElements ENDP


;---------------------------------------------------------------
;Name: displayMedian
;
;This procedure displays the array with 20 numbers per line
;
;preconditions: none
;
;postconditions: 
;
;receives:	address of array on system stack
;
;returns: None
;---------------------------------------------------------------

displayMedian PROC
	push	EBP
	mov		EBP, ESP
	mov     ESI, [EBP+8]
	pushad
	mov		EDX, [EBP + 12]
	call	WriteString
	mov		EAX, ARRAYSIZE
	mov		EDX, 0
	mov		EBX, 2
	div		EBX
	cmp		EDX, 1
	je		_odd
	jmp		_even

	_odd:
		call	CrLf
		mov		EAX, ARRAYSIZE
		dec		EAX
		mov		EDX, 0
		mov		ECX, 2
		div		ECX
		mov		EAX, [ESI + EAX * 4]
		call	WriteDec
		jmp		_return
		;add one to number and get that element and display that element
		
   
	_even:
		;first get the median location of the array
		
		mov		EBX, EAX
		dec		EAX
		add		EAX, EBX
		mov		EDX, 0
		mov		ECX, 2
		div		ECX

		;once median is obtained, mult by 4 to obtain element position in array to obtain the two median numbers
		mov		EDX, 4
		mul		EDX
		mov		EBX, [ESI + EAX]
		mov		EAX, [ESI + 4 + EAX]	
	
		
		
		;add both element numbers and divide
		add		EAX, EBX
		mov		EDX, 0
		mov		ECX, 2
		div		ECX
		cmp		EDX, 1
		je		_roundUp
		call	WriteDec
		jmp		_return

	_roundUp:
		inc		EAX
		call	WriteDec
    ;     median = (array[n / 2] + array[(n / 2) - 1]) / 2

	_return:
		popad
		pop		EBP
		ret		12
displayMedian ENDP


END main
