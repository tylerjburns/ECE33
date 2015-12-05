;Tyler Burns
;ECE 33
;Program 4
;12/4/15
;This program adds and subtracts 16 bit numbers

;Hey Ian, Wagh can shed more light on this
;but on Wednesday I emailed him and got an extension
;because when I assembled my work, it deleted the file.
;He said that can happen in assembly.
;So that's why this program doesn't work. 
;I wrote it all tonight (Friday).
;Sorry I didn't have time to debug.
;-Tyler
		ORG		100H
		LXI		SP, sp0
BOOT	EQU		0
BDOS	EQU		5
CR		EQU		0DH
LF		EQU		0AH
PLUS		EQU		2BH
MINUS	EQU		2DH
		MVI		C, 9
		LXI		D, MSG1
		CALL	BDOS
		LXI		D, MSG2
		CALL	BDOS
CALC:	CALL	READ1	;call for first read in
		CPI		CR		;check if user is done
		JZ		BOOT	;break out if so
		CALL	READ2	;call for second read in
		CPI		CR		;check if user is done
		JZ		BOOT	;break out if so
		DAD		D		;since negative numbers are made negative within the read routines
						;and since both routines can handle negatives
						;the results can just be added together
		CALL	PRINT	;print final result
		JMP		CALC		;go again!!

;Name: READ1
;Input: None
;Function: receives the user's input, 
;gets rid of bad characters
;and makes negative numbers negative
;Destroyed Registers: 
;Subroutines Used: MULT
READ1:	PUSH	B		;save B
READY:	MVI		D, 0
		MVI		C, 1
		CALL	BDOS	;receive input
		CPI		CR		;check if enter
		JZ		DONE	;if so, break out
		CPI		MINUS	;check if minus sign (implies negative)
		JZ		READN	;if minus sign, go to negative reading section
READP:	CPI		PLUS		;otherwise, continue
		JZ		DONE	;if it's a plus, then we're done taking number input
		CPI		'+'		;check if it's a character below the range we want on screen
		JM		DELETE	;if it is, the result will be negative, therefore delete it
		CPI		'9'+1	;check if the input is larger than what we want on screen
		JP		DELETE	; if it is, the result will be positive, so delete it
		SUI		'0'		;if it passes all of these checks, then take it out of ascii
		CALL	MULT	;multiply HL by 10
		MOV		A, L		;add the new input to it
		ADC		A
		MOV		L, A		;store new number back in L
		JMP		READP	;read in positive input again
READN:	MVI		C, 1		;receive input
		CALL	BDOS
		CPI		CR		;same as READP
		JZ		DONE
		CPI		PLUS
		JZ		DONE
		CPI		'+'
		JM		DELETE
		CPI		'9'+1
		JP		DELETE
		SUI		'0'
		CALL	MULT
		MOV		A, L
		ADC		A
		MOV		L, A
		JMP		READN
DELETE:	MVI		E, 08H
		MVI		C, 2
		CALL	BDOS
		MVI		E, 20H
		CALL	BDOS
		MVI		E, 08H
		CALL	BDOS
		JMP		READY
DONEN:	MVI		A, 0		;if negative intention (signalled by minus sign)
		SUB		L		;set A to 0 and subtract L to get negative form
		MOV		L, A		; move that to L
		MVI		A, 0		;set A to 0 again
		SBB		H		;subtract H and borrow from A
		MOV		H, A		;move result to H
		MVI		D, 0		;exchange HL and DE
		MVI		E, 0
		XCHG
DONE:	POP		B
		RET

;Name: READ2
;Input: None
;Function: receives the user's input, 
;gets rid of bad characters
;and makes negative numbers negative
;Destroyed Registers: 
;Subroutines Used: MULT
READ2:	PUSH	B		;same as above method, except
READY:	MVI		D, 0
		MVI		C, 1
		CALL	BDOS
		CPI		CR
		JZ		DONE
		CPI		MINUS
		JZ		READN
READP:	CPI		PLUS
		JZ		DONE
		CPI		'+'
		JM		DELETE
		CPI		'9'+1
		JP		DELETE
		SUI		'0'
		CALL	MULT
		MOV		A, L
		ADC		A
		MOV		L, A
		JMP		READP
READN:	MVI		C, 1
		CALL	BDOS
		CPI		CR
		JZ		DONE
		CPI		PLUS
		JZ		DONE
		CPI		'+'
		JM		DELETE
		CPI		'9'+1
		JP		DELETE
		SUI		'0'
		CALL	MULT
		MOV		A, L
		ADC		A
		MOV		L, A
		JMP		READN
DELETE:	MVI		E, 08H
		MVI		C, 2
		CALL	BDOS
		MVI		E, 20H
		CALL	BDOS
		MVI		E, 08H
		CALL	BDOS
		JMP		READY
DONEN:	MVI		A, 0
		SUB		L
		MOV		L, A
		MVI		A, 0
		SBB		H
		MOV		H, A		;don't exchange with DE
DONE:	POP		B
		RET

;Name: MULT
;Input: None
;Function: multiplies the current value in HL by 10
;Destroyed Registers: 
;Subroutines Used: 
MULT:	PUSH	D		;saves D
		DAD		H		;2HL
		MOV		D, H		;move 2HL to DE
		MOV		E, L
		DAD		H		;4HL
		DAD		H		;8HL
		DAD		D		;10HL
		POP		D		;pop out D
		RET

;Name: PRINT
;Input: None
;Function: prints result by decrementing
;each place in the potentially 5 digit number
;Destroyed Registers: 
;Subroutines Used: 
PRINT:	PUSH	D		;save D
		MVI		E, '='	;print equals sign
		MVI		C, 2
		CALL	BDOS
		MVI		E, 0		;set E back to 0
		MOV		A, H		;move higher bits into A
CONT:	SUI		10		;subtract ten thousands place
		JC		CONT2	;on carry (implying too much subtraction), go to next place
		INR		E		;otherwise, increment E
		JMP		CONT	;loop this step until broken out of
CONT2:	CALL	BDOS	;print E, e.g. ten thousands place
		MVI		E, 0		;reset E
		SUI		1		;subtract thousands place
		JC		CONT3	;same as above
		INR		E
		JMP		CONT2
CONT3:	CALL	BDOS	;print thousands place
		MOV		A, L		;bring in lower bits
		MVI		E, 0
		SUI		100		;subtract hundreds place
		JC		CONT4
		INR		E
		JMP		CONT3
CONT4:	CALL	BDOS	;print hundreds place
		MVI		E, 0
		SUI		10
		JC		CONT5
		INR		E
		JMP		CONT4
CONT5:	CALL	BDOS	;print tens place
		MVI		E, 0
		SUI		1
		JC		DONE
		INR		E
		JMP		CONT5
DONE:	CALL	BDOS	;print ones place
		MVI		E, LF		;go down a line
		CALL	BDOS
		MVI		E, CR
		CALL	BDOS
		RET				;return to main routine

MSG1:		DB		'The Tiny Calculator$'
MSG2:		DB		LF, CR, 'Enter a problem: $'
			DS		80
sp0			EQU		$
END