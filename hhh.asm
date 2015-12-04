
		ORG		100H
		LXI		SP, sp0
BOOT	EQU		0
BDOS	EQU		5
CR		EQU		0DH
LF		EQU		0AH
		MVI		C, 9
		LXI		D, MSG1
		CALL	BDOS
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
		MOV		M, A; 6
		INX		H; increment <HL>
		MOV		M, A; p
		INX		H; increment <HL>
		MOV		M, A; 
		INX		H; increment <HL>
		MOV		M, A;
		CALL	READ
		CALL	PRINT
		CALL	GBYE
		JMP		BOOT

READ:	PUSH	B
		PUSH	D
READY:	MVI		C, 1
		CALL	BDOS
		PUSH	PSW
		CPI		CR
		JZ		DONE
		POP		PSW
		JC		DELETE
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
		MVI		E, ' '
		CALL	BDOS
		MVI		E, 08H
		CALL	BDOS
DONE:	POP		D
		POP		B
		RET
		

PRINT:	PUSH	B
		MVI		C, 9
		LXI		D, MSG4
		CALL	BDOS
		MVI		B, 10
		LXI		H, BUFF
		MVI		C, 2
		MVI		E, '0'
PRNTPT:	MOV		A, M
		CALL	ONELINE
		INX		H
		INR		E
		DCR		B
		JNZ		PRNTPT	
		POP		B
		RET
ONELINE:	PUSH	B
		PUSH	D
		MVI		C, 2
		CALL	BDOS
		MVI		C, 9
		LXI		D, COLON
		CALL	BDOS
		CPI		0
		JZ		DONE2
		MVI		C, 9
		LXI		D, XS
AGAIN:	CALL	BDOS
		DCR		A
		JNZ		AGAIN
DONE2:	MVI		C, 2
		MVI		E, LF
		CALL	BDOS
		MVI		E, CR
		CALL	BDOS
		POP		D
		POP		B
		RET

		DS		10
BUFF		EQU		$
		DS		80
sp0		EQU		$

END