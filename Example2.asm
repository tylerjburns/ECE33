;
;  This is an example program by MDW showing how two 16 bit
;  strings are added.  The strings are stored at addresses
;  (highA, lowA) and (highB, lowB).  The result is
;  stored at (highC, lowC).  The important point that needs
;  to be observed is the proper use of subroutines and comments.
;
;  Default values of the operands are 4532 (Hex) and 2ADD (Hex).
;  they may be changed by changing appropriate memory locations.
;  Look at the .prn file to identify these locations.

   bdos     equ    5            ; all CP/M related constants
   boot     equ    0
   sprint   equ    9            ; function number to print a string
   conin    equ    1            ; function number to input a character
   conout   equ    2            ; function number to output a character

            org    100h         ; MUST use this origin always
                                ; it is a CP/M constraint
            lxi    sp,stkpt     ; this is ESSENTIAL if subroutines are used
            mvi    c,sprint
            lxi    d,mess1
            call   bdos         ; CP/M call to print message at address mess1
            lxi    h,lowA       ; getting ready to do lower byte addition
            mov    a,m          ; load first operand (lower byte)
            inx    h
            add    m            ; add second operand (lower byte)
            inx    h
            mov    m,a          ; store the lower byte of addition result
            inx    h            ; now do the higher byte addition
            mov    a,m
            inx    h
            adc    m            ; carry generated in previous add is used here
            inx    h
            mov    m,a          ; store the higher byte
            lxi    h,highA
            call   outnum       ; to print out first operand
            mvi    e,'+'
            mvi    c,conout
            call   bdos         ; CP/M call to print plus sign
            lxi    h,highB
            call   outnum       ; to print out second operand
            mvi    e,'='
            mvi    c,conout
            call   bdos         ; CP/M call to print equal sign
            lxi    h,highC
            call   outnum       ; to print out the result
            jmp    boot         ; the ONLY logical way to end the program
                                ; execution and give control back to
                                ; operationg system.
;  Main program ends here, now come all the subroutines
;
;           Subroutine outnum
;             input  : an address in H-L register pair
;             action : print the byte at the address in H-L pair and
;                      then print byte at address 3 less then the previous
;                      ( thus for example higherA followed by lowerA)
;             registers destroyed : H-L pair
;             subroutines used    : outbyte

   outnum:  push   psw          ; just making sure that registers used
                                ; in the routine are not destroyed
            mov    a,m
            call   outbyte      ; print the first byte
            dcx    h
            dcx    h
            dcx    h
            mov    a,m
            call   outbyte      ; print the second byte
            pop    psw          ; restore a and flag register
            ret                 ; and return

;           Subroutine outbyte
;             input : the byte to be printed in A
;             action : print the byte in A
;             registers destroyed : none
;             subroutines used : outcode

  outbyte:  push   psw          ; save registers that are used
            push   b
            mov    b,a          ; make a copy of the data
            ani    0f0h         ; tap the first four bits (higher nibble !)
            rlc                 ; and shift them to the right edge
            rlc
            rlc
            rlc
            call   outcode      ; print the higher nibble
            mov    a,b          ; get the original data put away in b
            ani    0fh          ; tap the lower nibble
            call   outcode      ; print the lower nibble
            pop    b            ; restore registers
            pop    psw
            ret                 ; and return

;           Subroutine outcode
;             input : a nibble (4 bits) in register a
;             action : to print the hex code of the nibble
;             registers destroyed : none
;             subroutines used : none

   outcode: push   psw          ; save registers used
            push   b
            push   d
            cpi    10           ; find whether to print digit or letter
            jnc    code1        ; no carry implies a letter
            adi    '0'          ; generate ASCII code of the digit
            jmp    code2
   code1:   adi    'A' - 10     ; generates ASCII code of the letter
   code2:   mov    e,a
            mvi    c,conout
            call   bdos         ; CP/M call to print the ASCII code
            pop    d            ; restore registers
            pop    b
            pop    psw
            ret                 ; and return

;  This ends subroutines.  Now comes the data and space for stack.

   lowA:    db     32h          ; default values, try changing them
   lowB:    db     0DDh
   lowC:    ds     1            ; 1 byte space for lower byte of result
   highA:   db     45h
   highB:   db     2Ah
   highC:   ds     1            ; higher byte of result
   mess1:   db     'Addition of two 16 bit strings',0Ah,0Dh,0Ah,0Ah,'$'
                                ; note that the message MUST end with a '$'.
                                ; 0Ah and 0Dh are codes for Line Feed and
                                ; Carriage Return respectively
            ds     30           ; reserve 30 bytes for stack
   stkpt    equ    $
            end                 ; assembler directive, not an instruction

