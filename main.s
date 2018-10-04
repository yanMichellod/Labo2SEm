;-------------------------------------------------------------------------------
; First asm code
; working solution !
;-------------------------------------------------------------------------------

;	THUMB
	AREA    |.text|, CODE, READONLY

        EXPORT  asm_main
		EXPORT  Answer
		EXPORT  Header
		EXPORT  Heap
		
		IMPORT  strOut
		IMPORT  strIn
		IMPORT  decIn
		IMPORT  decOut
			
next    EQU	0
name	EQU	4
age		EQU 12
	
storedAddress RN 4		;stock address in r4
previousAddress RN 5	;previous address for the linked list
emptyRegister RN 6

asm_main PROC
	push	{lr}		; save return address
;------------------------ FIRST HEAP INIT -------------------------
	ldr	r0,=Heap		; get start of heap
	add	r1,r0,#4		; add 4 for next free bloock
	str	r1,[r0]			; store in start of heap
	mov emptyRegister , #0
;------------------------ ASK CHOICE ------------------------------
loop
	ldr	r0,=MsgAsk
	bl	strOut			; display message
	ldr r0,=Answer
	mov	r1,#1
	bl	strIn			; read answer
	ldr	r0,=Answer
	ldrb	r0,[r0]		; get first char
;------------------------ CHECK CHOICE ----------------------------
	cmp	r0,#'N'
	beq	NewEntry		; new entry
	cmp	r0,#'n'
	beq	NewEntry		; new entry
	cmp	r0,#'V'
	beq	ViewDatabase	; view database
	cmp	r0,#'v'
	beq	ViewDatabase	; view database
	cmp	r0,#'D'
	beq	DeleteEntry		; delete an entry
	cmp	r0,#'d'
	beq	DeleteEntry		; delete an entry
	cmp	r0,#'S'
	beq	SortDatabase	; sort database
	cmp	r0,#'s'
	beq	SortDatabase	; sort database
	cmp	r0,#'Q'
	beq	Quit			; quit
	cmp	r0,#'q'
	beq	Quit			; quit
	b	loop
;=================================================================
;------------------------ NEW ENTRY ------------------------------
;=================================================================
NewEntry
; TODO complete your code here
	ldr	r0,=MsgName
	bl	strOut					; display message
	
	mov r0, #16					;ask for 14 bytes to store data
	bl	New 					;define the address to store data, in r0, for strIn
	mov storedAddress, r0		;store the memory address
	
	str emptyRegister, [storedAddress] ;set the "next" 4 bytes to 0
	
	add r0, #name				;store the address to write the name, after the "next", for the strIn
	mov r1, #8					;store the max length for strIn 
	bl strIn					;call the stdIn function
	
	ldr	r0,=MsgAge			
	bl	strOut					;display message
	bl decIn					;call the strIn function
	str r0,[storedAddress,#age]
	
	ldr r0, =Header 			;store the value pointed by header into r0 
	mov previousAddress, r0
	cmp r0, emptyRegister
	
While	
	beq Next 				;if "next" pointer == 0 -> end of the list, set next 
	mov previousAddress, r0 ;store the previous address
	ldr r0, [r0]			;get the next address
	cmp r0, emptyRegister	;update flags r0 - 0
	b While					;loop
Next 	
	str storedAddress, [previousAddress]	;update the last pointer of the list
	
	b	loop


;=================================================================
;------------------------ VIEW DATABASE --------------------------
;=================================================================
ViewDatabase
; TODO complete your code here
	ldr r0, =Header 			;store the value pointed by header into r0 
	ldr r0, [r0]     			;store the value pointed by header into r0
	cmp r0, emptyRegister		; test if r0 is NULL
	
WhileView
	beq NextView		; end loop if address is NULL
	mov storedAddress,r0 ; save actual address
	
	ldr	r0,=MsgDspName
	bl	strOut					; display message
	mov r0, storedAddress
	add r0,#name
	bl	strOut					; display message
	ldr	r0,=MsgDspAge
	bl	strOut					; display message
	ldr r0,[storedAddress,#age] ; load the address of the name
	bl	decOut		
	
	mov r0,storedAddress 
	ldr r0, [r0]	        	;get the next pointer
	cmp r0, emptyRegister		; test if r0 is NULL
	b WhileView
NextView
	B	loop			; yes -> return


;=================================================================
;------------------------ DELETE ENTRY ---------------------------
;=================================================================
DeleteEntry
; TODO complete your code here

	B	loop

;=================================================================
;------------------------ SORT DATABASE --------------------------
;=================================================================
SortDatabase
; TODO complete your code here

	B	loop
;=================================================================
;------------------------ QUIT -----------------------------------
;=================================================================
Quit
	pop	{pc}			; restore return address

	ENDP
;==================================================================
; Function  : New
; Goal      : Allocate memory from Heap
; Input     : r0 - size in bytes to allocate
; Output    : r0 - Address of reserved zone
;==================================================================
New
	stmdb	sp!,{r1-r2,lr}	; save registers
	ldr	r1,=Heap			; get heap address
	ldr	r2,[r1]				; get free address
	add	r0,r0,r2			; add offset to free address
	str	r0,[r1]				; store it in heap address
	mov	r0,r2				; return free address
	ldmia	sp!,{r1-r2,pc}	; restore registers and return

;==================================================================

MsgAsk		DCB	"\nMake your choice (N,V,D,S,Q) :",0
MsgName		DCB	"\nEnter the name : ",0
MsgAge		DCB	"\nEnter the age : ",0
MsgDspName	DCB	"\nName : ",0
MsgDspAge	DCB	" Age : ",0
MsgToDelete	DCB	"\nName to delete : ",0

GetChar		DCB	"%c",0

;-------------------------------------------------------------------------------
; example of data section 
;-------------------------------------------------------------------------------
	AREA  |.data|, DATA, READWRITE, ALIGN=8
Header		DCD 	0
Heap		SPACE	4096


	ALIGN 8

Answer		SPACE	8



	
	END
		