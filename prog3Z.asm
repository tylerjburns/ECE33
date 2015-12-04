;Zachary Hille
;Prog3
   bdos      equ    5            ; CP/M function call address
   boot      equ    0            ; address to get back to CP/M
   conin     equ    1            ; keyboard read
   conout    equ    2            ; character out
   sprint    equ    9            ; string print
   cr        equ    0Dh          ; ASCII cr
   lf        equ    0Ah          ; ASCII lf
   space     equ    20h          ; space 
   period 	 equ    2Eh 		 ;period;
   backspace equ	08h			 ;backspace
;
             org    100h         ; standard origin for CP/M
             lxi    sp,sp0       ; initialize stack pointer]
			 lxi    h,buff1;
			 mvi a,0;
			 mvi b,0; initialize the abilty to count
			 call clearmem;
;
             mvi    c,sprint     ; print start message
             lxi    d,mess1      ; (the message at mess1 is printed through
             call   bdos         ; these three lines)
			 mvi c, sprint
			 lxi	d,mess2		 ; Type a sentence
			 call   bdos
			 call takeDigs ;take numbers
			 call printer  ;print 'em out
			 
			 
			 jmp boot    ;end
			 
			 
			 takeDigs: push d; to not destroy registers
			 moreDigs: push h;
			 mvi d,0; to make sure we don't get any interference
			 mvi e,0; for when we add
			 mvi c,conin
			inr b; 
			 call bdos
			 cpi cr; do we end?
			 jz fin;
			 cpi '0' ; to check input is a num
			 cm reprint;
			 cpi '9'+1;
			 cp reprint; erase non letters
			 sbi '0'-1;
			 mov e,a;
			 dad d; find which buffer zone this goes in
			 mov a,M; based on #
			 inr a;
			 mov M,a;
			 pop h
			 jmp moreDigs; get more #'s unless
			 fin: pop h;cr entered
			 pop d;
			 ret; after numbers, return
			 
			 reprint: mvi c,conout;if a non # entered
			 mvi e,backspace; backspace,
			 call bdos;
			 mvi e,space; print over it,
			 call bdos;
			 mvi e,backspace; then print on it again
			 call bdos;
			 ret;

			 printer: mvi c,conout;print out our histogram
			   mvi b,0;
			   lxi h, buff1; reset to our first buffzone
			   moprint: mvi c,sprint
			   lxi d,mess4 ; print ouf # of message
			   call bdos;
			   mov a,b;
			   adi '0'; print ouf # we are on
			   mvi c,conout
			   mov e,a;
			   call bdos;
			   mvi c,sprint;
			   lxi d,mess5; print out the letter s
			   call bdos;
			   mov a,M;
			   ;mvi c,conout;
			   ;adi '0';
			   ;mov e,a;
			   ;call bdos
			   call xs; print out correct X's
			   inx h; print out from memory
			   inr b; count how many we've printed
			   mov a,b; have we printed
			   cpi 10; more than our 10?
			   jnz moprint; if no, go again
			   ret; if so, stop yo.
			 
			 xs: cpi 0; do we need to print zero?
			 jz fin2; if so, end.
			 mvi c,sprint; if not, print
			 lxi d,mess6; an x.
			 call bdos;
			 dcr A; # left to print is 1 less
			 jmp xs; do again.
			 fin2: ret;
			 
			 clearmem: push H; to clear memory, so if no #'s are enters, zero is output, not a weird number
;			so if no #'s are enters, ;
;			zero is output, not a weird number
			 mov M,a;set 0 counter
			 inr L;
			 mov M,a ;set 1;
			 inr L
			 mov M,a; set 2;
			 inr L;
			 mov M,a;3
			 inr L
			 mov M,a;4
			 inr L;
			 mov M,a;5
			 inr L
			 mov M,a;6
			 inr L;
			 mov M,a;7
			 inr L
			 mov M,a; set 8 counter;
			 inr L;			
			 mov M,a;
			 pop H;
			 ret;
			 
			 ;begin massages
			 mess1: db 'The Histrogram$'
			 mess2: db lf,cr,'Please enter your digits: $'
			 mess3: db lf,cr,'Histogram: $'
			 mess4: db lf,cr,'Number of $'
			 mess5: db 's:  $'
			 mess6: db 'X$'
			 ;
			 ds 10 ; 
			 buff1 equ $
			 ds 40 ;
			 sp0 equ  $
			 
			 ;Tyler Burns
;ECE 33
;Program 3
;11/13/15
;This program will create a text 
;histogram of a string of numbers input by the user.

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
		MOV		M, A; put zero into buff+6
		INX		H; increment <HL>
		MOV		M, A; put zero into buff+7
		INX		H; increment <HL>
		MOV		M, A; put zero into buff+8
		INX		H; increment <HL>
		MOV		M, A; put zero into buff+9
		LXI		H, BUFF
		CALL	READ
		CALL	PRINT
		CALL	GBYE
		JMP		BOOT
		
;Name: READ
;Input: None
;Function: receives the user's input, 
;gets rid of bad characters,
;and increments memory locations
;Destroyed Registers: 
;Subroutines Used: 
READ:	PUSH	B
		PUSH	D
		MVI	D, 0
READY:		PUSH 	H
		MVI	C, 1
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
		POP		H
		JMP		READY
DELETE:	MVI		E, 08H
		MVI		C, 2
		CALL	BDOS
		MVI		E, 20H
		CALL	BDOS
		MVI		E, 08H
		CALL	BDOS
		JMP	READY
DONE:		POP		PSW
		POP		H
		POP		D
		POP		B
		RET
		
;Name: PRINT
;Input: None
;Function: Prints the histogram
;Destroyed Registers:
;Subroutines Used: ONELINE
PRINT:	PUSH	B
		MVI		C, 9
		LXI		D, MSG4
		CALL	BDOS
		MVI		B, 10
		LXI		H, BUFF
		MVI		C, 2
		MVI		E, '0'
PRNTPT:		MOV		A, M
		CALL	ONELINE
		INX		H
		INR		E
		DCR		B
		JNZ		PRNTPT	
		POP		B
		RET
		
;Name: ONELINE
;Input: None
;Function: Prints a single line of the histogra
;Destroyed Registers:
;Subroutines Used: 
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

MSG1:	DB		'The Digital Histogram$'
MSG2:	DB		LF, CR, 'Find out which numbers are subconsciously important to you$'
MSG3:	DB		LF, CR, 'Type about 40 digits: $'
MSG4:	DB		LF, CR, 'Your Histogram', LF, CR, '-----------------------------------', LF, CR, '$'
COLON:	DB		': $'
XS:		DB		'X$'
MSG5:	DB		LF, CR, 'Did you find any interesting patterns? Thanks for using the histogram.$'
		DS		10
BUFF		EQU		$
		DS		80
sp0		EQU		$

END