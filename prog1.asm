;Tyler Burns
;ECE33
;Program 1
;this program will put numbers into bins based on given values
;then it will print the number of "small", "medium", and "large" numbers
	ORG	100H
BOOT	EQU 	0
BDOS	EQU 	5
CR	EQU 	0DH
LF	EQU 	0AH
RUNS	EQU	8		;number of runs
	MVI	A, 0
	MVI	B, RUNS		;set counter
	MVI	C, 0
	MVI	D, 0
	MVI	E, 0
	MVI	H, 0
	MVI	L, 0
	LXI	SP, sp0
	MVI	C, 9
	LXI	D, MSG1
	CALL	BDOS		;print welcome
DO:	CALL	READ
	CPI	167
	JC	LOWER
	INR	H
	JMP	FINISH
	
LOWER:	CPI	66
	JC	FINISH
	INR	L
	
FINISH:	DCR	B
	JNZ	DO
	MVI	A, RUNS
	SUB	H
	SUB	L
	CALL	PRINT
	JMP	BOOT
;this method takes the input from the user
;and processes it into usable numbers
;registers destroyed: none
READ:	PUSH	H		;preserve counters
	PUSH	B		;preserve run counter
	MVI	C, 9
	LXI	D, MSG2
	CALL	BDOS		;print prompt
	
	MVI	C, 1
	CALL	BDOS		;wait for user input
	CPI	CR		;check if enter was pressed
	JZ	DONE		;if so, jump to done
	SUI	'0'		;remove ascii zero
	MOV	H, A
	
	CALL	BDOS		;receive next input
	CPI	CR		;same as above
	JZ	DONE
	SUI	'0'
	MOV	L, A		;multiply first digit by ten
	MOV	A, H
	ADC	A
	MOV	B, A
	ADC	A
	ADC	A
	ADC	B
	ADD	L		;add the second digit
	MOV	H, A
	
	CALL	BDOS		;same as above
	CPI	CR
	JZ	DONE
	SUI	'0'
	MOV	L, A		;multiply by ten
	MOV	A, H
	ADC	A
	MOV	B, A
	ADC	A
	ADC	A
	ADC	B
	ADD	L		;add third digit
	MOV	H, A
	CALL	BDOS		;wait for user to press enter
DONE:	MOV	A, H
	POP	B		;pop preserved run counter
	POP	H		;pop counters
	RET
;prints the data in a readable format
;registers destroyed: none
PRINT:	MVI	C, 9
	LXI	D, MSG3		;print first bin
	CALL	BDOS
	MVI	C, 2 
	ADI 	'0'
	MOV	E, A		;move the ascii value number of small numbers to E
	CALL	BDOS
	MVI	C, 9
	LXI	D, SPACE	;leave space for formatting
	CALL	BDOS
	LXI	D, MSG4		;print second bin
	CALL	BDOS
	MVI	C, 2
	MOV	A, L 		;move second value to A
	ADI 	'0'		;add ascii zero
	MOV	E, A		; move val to E for printing
	CALL	BDOS
	MVI	C, 9
	LXI	D, SPACE
	CALL	BDOS
	LXI	D, MSG5		;print last bin
	CALL	BDOS
	MVI	C, 2
	MOV	A, H		;move third value to A
	ADI 	'0'		;add ascii zero
	MOV	E, A		; move val to E for printing
	CALL	BDOS
	RET

MSG1:	DB	'The Size Finder', LF, CR, 'Quickly sort numbers into three sizes!$'
MSG2:	DB	LF, CR, 'Type a number between 0 and 255: $'
MSG3:	DB	LF, CR, 'Small Numbers: $'
MSG4:	DB	'Medium Numbers: $'
MSG5:	DB	'Large Numbers: $'
SPACE:	DB	'   $'
	DS	50
sp0	EQU	$

END