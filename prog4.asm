;Tyler Burns
;ECE 33
;Program 4
;12/4/15
;This program adds and subtracts 16 bit numbers
		ORG		100H
		LXI		SP, sp0
BOOT	EQU		0
BDOS	EQU		5
CR		EQU		0DH
LF		EQU		0AH
		MVI		C, 9
		LXI		D, MSG1
		CALL	BDOS
		CALL	READ1
		CALL	READ2
		
READ1:	PUSH	B
		PUSH	D
		MVI		D, 0
READY:	LXI		H, BUFF
		MVI		C, 1
		CALL	BDOS
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
DELETE:	MVI		E, 08H
		MVI		C, 2
		CALL	BDOS
		MVI		E, 20H
		CALL	BDOS
		MVI		E, 08H
		CALL	BDOS
		JMP		READY
DONE:	POP		D
		POP		B
		RET


MSG1:		DB		'The Tiny Calculator$'
MSG2:		DB		LF, CR, 'Enter a problem: $'
MSG3:		DB		LF, CR, '$'
			DS		80
sp0			EQU		$
END