;Tyler Burns
;ECE 33
;Program 3
;11/13/15
;This program will create a text 
;histogram of a string of numbers input by the user.
		ORG		100H
		LXI		SP, sp0
BOOT		EQU		0
BDOS		EQU		5
CR		EQU		0DH
LF		EQU		0AH
		MVI		C, 9
		LXI		D, MSG1
		CALL		BDOS
		MVI		A, 0
		LXI		H, BUFF; load buff pointer into <HL>
		MOV		M, A; put zero into buff
		INX		H; increment <HL>
		MOV		M, A; put zero into buff+1
		INX		H; increment <HL>
		MOV		M, A; put zero into buff+2
		INX		H; increment <HL>
		MOV		M, A; put zero into buff+3
		INX		H; increment <HL>
		MOV		M, A; put zero into buff+4
		INX		H; increment <HL>
		MOV		M, A; put zero into buff+5
		INX		H; increment <HL>
		MOV		M, A; put zero into buff+6
		INX		H; increment <HL>
		MOV		M, A; put zero into buff+7
		INX		H; increment <HL>
		MOV		M, A; put zero into buff+8
		INX		H; increment <HL>
		MOV		M, A; put zero into buff+9
		LXI		H, BUFF
		MVI		C, 9
		LXI		D, MSG3
		CALL		BDOS
		CALL		READ
		CALL		PRINT
		MVI		C, 9
		LXI		D, MSG5
		CALL		BDOS
		JMP		BOOT
		
;Name: READ
;Input: None
;Function: receives the user's input, 
;gets rid of bad characters,
;and increments memory locations
;Destroyed Registers: 
;Subroutines Used: 
READ:		PUSH		B
		PUSH		D
		MVI		D, 0
READY:		LXI		H, BUFF
		MVI		C, 1
		CALL		BDOS
		CPI		CR
		JZ		DONE
		CPI		'0'
		JM		DELETE
		CPI		'9'+1
		JP		DELETE
		SUI		'0'
		MOV		E, A
		DAD		D
		MOV		A, M
		INR		A
		MOV		M, A
		JMP		READY
DELETE:		MVI		E, 08H
		MVI		C, 2
		CALL		BDOS
		MVI		E, 20H
		CALL		BDOS
		MVI		E, 08H
		CALL		BDOS
		JMP		READY
DONE:		POP		D
		POP		B
		RET
		
;Name: PRINT
;Input: None
;Function: Prints the histogram
;Destroyed Registers:
;Subroutines Used: ONELINE
PRINT:		PUSH		B
		MVI		C, 9
		LXI		D, MSG4
		CALL		BDOS
		MVI		B, 10
		LXI		H, BUFF
		MVI		C, 2
		MVI		E, '0'
PRNTPT:		MOV		A, M
		CALL		ONELINE
		INX		H
		INR		E
		DCR		B
		JNZ		PRNTPT	
		POP		B
		RET
		
;Name: ONELINE
;Input: None
;Function: Prints a single line of the histogram
;Destroyed Registers:
;Subroutines Used: 
ONELINE:	PUSH		B
		PUSH		D
		MVI		C, 2
		CALL		BDOS
		MVI		C, 9
		LXI		D, COLON
		CALL		BDOS
		CPI		0
		JZ		DONE2
		MVI		C, 9
		LXI		D, XS
AGAIN:		CALL		BDOS
		DCR		A
		JNZ		AGAIN
DONE2:	MVI			C, 2
		MVI		E, LF
		CALL		BDOS
		MVI		E, CR
		CALL		BDOS
		POP		D
		POP		B
		RET

MSG1:		DB		'The Digital Histogram$'
MSG2:		DB		LF, CR, '$'
MSG3:		DB		LF, CR, 'Type about 40 digits: $'
MSG4:		DB		LF, CR, 'Histogram', LF, CR, '$'
COLON:		DB		': $'
XS:		DB		'X$'
MSG5:		DB		LF, CR, 'Thanks for using the histogram.$'
		DS		20
BUFF		EQU		$
		DS		80
sp0		EQU		$
END