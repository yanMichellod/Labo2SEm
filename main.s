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

asm_main PROC
	push	{lr}		; save return address
;------------------------ FIRST HEAP INIT -------------------------
	ldr	r0,=Heap		; get start of heap
	add	r1,r0,#4		; add 4 for next free bloock
	str	r1,[r0]			; store in start of heap
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

	b	loop


;=================================================================
;------------------------ VIEW DATABASE --------------------------
;=================================================================
ViewDatabase
; TODO complete your code here

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
		