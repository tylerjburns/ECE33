;Tyler Burns
;ECE33
;10/25/15
;This program will take a sentence from the user,
;then it will take a word from the user
;and finally a position from the user.
;Then the program will place the word in the sentence
;after the word specified by the number input
;and print out the new sentence.
	ORG	100H	;begin program and initialize all labels
	LXI	SP, sp0
BOOT	EQU	0	;boot
BDOS	EQU	5	;bdos
CR	EQU 	0DH	;carriage return
LF	EQU 	0AH	;line feed
PERIOD	EQU	2EH	;ascii period "."
	MVI	C, 9	; print message 1
	LXI	D, MSG1
	CALL	BDOS
	LXI	D, MSG2	;print message 2
	CALL	BDOS
	CALL	INPUT
	CALL	INPTWD
	CALL	INPUT2
	CALL	PRINT
	JMP	BOOT

;Name:		INPUT
;Input:		None
;Function:	Receives user input and stores it in the buffer. If the character is not a period
;		the subroutine will repeat part of itself, storing more data.
;		When a period is received, the subroutine returns.
;Destroyed registers: A, C, H
;Subroutines used: None
INPUT:	MVI	C, 1
	LXI	H, BUFF
INPUTR:	CALL	BDOS
	MOV	M, A
	INX	H
	CPI	PERIOD
	JNZ	INPUTR
	RET
	
;Name:		INPTWD
;Input:		None
;Function:	Receives the word the user wants to input
;		within the sentence and stores it in mem.
;Destroyed registers: C, D-E, H-L
;Subroutines used: None	
INPTWD:	MVI	C, 9
	LXI	D, MSG3
	CALL	BDOS	;print message 3
	MVI	C, 1
	LXI	H, BUFF2;change pointer to buff2
INPTWR:	CALL	BDOS
	MOV	M, A	;store char
	INX	H
	CPI	CR
	JNZ	INPTWR	;if not CR, jump back and get another char
	MOV	M, A	;if zero, move CR to mem, then return
	RET

;Name:		INPUT2
;Input:		None
;Function:	Receives the position the user wants to input
;		the word within the sentence.
;Destroyed registers: A, B, C, D-E
;Subroutines used: None
INPUT2:	MVI	C, 9
	LXI	D, MSG4
	CALL	BDOS	;print message 4
	MVI	C, 1
	CALL	BDOS	;receive first value
	SUI	'0'	;subtract ascii zero
	MOV	B, A	;move it to B register
	CALL	BDOS	;bring in second value
	MVI	C, 0	;reset C, so that if it was CR, C is zero
	CPI	CR	;compare to CR
	JZ	RET4	;if it's CR, return to main routine
	SUI	'0'	;otherwise, subtract ascii zero
	MOV	C, A	;move it to C
MULT:	MOV	A, B	;multiply the first value by 10
	ADC	A
	MOV	B, A
	ADC	A
	ADC	A
	ADC	B
	ADC	C	;then add C to it
RET4:	RET
	
;Name:		PRINT
;Input:		From Memory
;Function:	Prints the original statement with
;		the new word within the sentence.
;Destroyed registers: A, C, E, H-L
;Subroutines used: SPACE
PRINT:	MVI	C, 2	;go to beginning of next line
	MVI	E, LF	
	CALL	BDOS
	MVI	E, CR
	CALL	BDOS
	LXI	H, BUFF	;set pointer to buffer to start printing
PRINTR:	MOV	E, M	;move the first char to E from mem
	CALL	BDOS	;print it
	INX	H	;increment the pointer
	MOV	A, E	;put the char in the accumulator
	CPI	PERIOD	;compare it to a period
	JZ	RET2	;if it's a period, return
	CPI	20H	;if not, compare it to space
	JNZ	PRINTR	;if not a space, jump and get next char
	CALL	SPACE	;if it is a space, call space
	JMP	PRINTR	;jump back and get next char
RET2:	RET
	
;Name:		SPACE
;Input:		B, Memory
;Function:	Decrement B to keep count of the number of spaces
;		so that the added word can go in the right place.
;Destroyed registers: A, E
;Subroutines used: SPACE2
SPACE:	PUSH	H	;save H-L pair
	DCR	B	;decrement B to keep track of spaces
	JNZ	RET3	;if it's not zero, return
	LXI	H, BUFF2;if it is zero point pointer at new word
PRINTL:	MOV	E, M	;pull first char of new word into E and A
	MOV	A, E
	CPI	CR	;compare it to CR
	JZ	SPACE2	;if it is CR, jump to SPACE2
	CALL	BDOS	;print the character if it's not CR
	INX	H	;increment pointer
	JMP	PRINTL	;jump back to print next char
RET3:	POP	H	;pop H out before returning
	RET

;Name:		SPACE2
;Input:		None
;Function:	Prints a space when a CR is detected in SPACE.
;Destroyed registers: E
;Subroutines used: None
SPACE2:	MVI	E, 20H	;put ascii for space in E
	CALL	BDOS	;print it
	POP	H	;pop H, then return, skipping SPACE
			;since we jumped to this subroutine
	RET
	
MSG1:	DB	'Sentence Editor$'
MSG2:	DB	LF, CR, 'Type in a sentence: $'
MSG3:	DB	LF, CR, 'Input word to add to sentence: $'
MSG4:	DB	LF, CR, 'Input position to add a word: $'
	DS	20
sp0	EQU	$
	DS	80
BUFF	EQU	$
	DS	40
BUFF2	EQU	$

END