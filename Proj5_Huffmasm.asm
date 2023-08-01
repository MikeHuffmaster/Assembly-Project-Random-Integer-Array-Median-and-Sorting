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
ARRAYSIZE = 200

.data

intro_prompt	BYTE	"                   Array, Median, and Sorted Array         by Mike Huffmaster",13,10,13,10
				BYTE	"This program is going to create a list of 200 random integers between the range of 15 and 50.",13,10
				BYTE	"The program will then take this list and display the median and the list in ascending order.",13,10
				BYTE	"Finally, the total count of each number that occurred will be displayed to the user.",13,10,13,10,0
initial_array	BYTE	"The initial array:",13,10,13,10,0
randArray		DWORD	ARRAYSIZE dup(?)
count			DWORD	?
row_count		DWORD	0


.code
main PROC
	
	call Randomize

	push OFFSET intro_prompt
	call introduction
	
	push OFFSET randArray
	push count
	call fillArray

	push row_count
	push OFFSET randArray
	push count
	push OFFSET initial_array
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

	ret		
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
	mov		ECX, arraySize		;loops until ARRAYSIZE constant is 0
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
		ret 8
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
	mov		EDX, [EBP+8]			;array message
	mov		ESI, [EBP + 16]			;address of array
	mov		ECX, arraySize			;address of count
	mov		EBX, [EBP + 20]

	call	WriteString
		
		_displayLoop:
			mov		EAX, [ESI]
			call	WriteDec
			mov		al, ' '
			call	WriteChar
			add		ESI, TYPE DWORD
			inc		EBX
			cmp		EBX, 20
			je		_newRow
			LOOP	_displayLoop

		_newRow:
			mov		EBX, 0
			call	CrLf
			LOOP	_displayLoop

	pop		EBP
	ret 12
displayList ENDP

END main
