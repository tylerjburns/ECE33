;
;  This is just a little example of an 8085 assembly program.
;  it merely reads a character from the keyboard.  If it is a
;  letter, it prints the corresponding CAPITAL letter.  If it
;  is a not a letter, it prints an error message.  The program
;  ends when you type a Carriage Return, <CR>.
;
   bdos      equ    5            ; CP/M function call address
   boot      equ    0            ; address to get back to CP/M
   conin     equ    1            ; keyboard read function number
   conout    equ    2            ; console output function number
   sprint    equ    9            ; string print function number
   cr        equ    0Dh          ; value of ASCII code of <CR>
   lf        equ    0Ah          ; value of ASCII code of line feed
;
             org    100h         ; standard origin for CP/M
             lxi    sp,sp0       ; initialize stack pointer
;
             mvi    c,sprint     ; print welcome message 
             lxi    d,mess1      ; (the message at mess1 is printed through
             call   bdos         ; these three lines)

   Do:       mvi    c,sprint     ; prompt user for an input
             lxi    d,mess4
             call   bdos

             mvi    c,conin      ; the ASCII code of the character is read
             call   bdos         ; into A reg. through these two instructions

             cpi    cr           ; determine if a <CR> was typed in
             jz     donot        ; if so, end the program

             mvi    c,sprint     ; print string at mess2
             lxi    d,mess2
             call   bdos

             cpi    'a'
             jc     nocvt        ; trying to find if in the range 'a' to 'z'
             cpi    'z'+1        ; if so then convert to Capital
             jnc    nocvt
             adi    'A'-'a'

   nocvt:    cpi    'A'          
             jc     junk         ; trying to find if input was a letter
             cpi    'Z'+1
             jnc    junk

             mvi    c,conout     ; if so, then print that letter
             mov    e,a
             call   bdos
             jmp    last         ; and jump to the end

   junk:     mvi    c,sprint    ; else print the message at mess3 and
             lxi    d,mess3      ; go to the end
             call   bdos

   last:     jmp    do           ; and do the complete thing again

   donot:    mvi    c,sprint    ; print a log out message
             lxi    d,mess5
             call   bdos
             jmp    boot         ; and get back to the operating system

;  This ends the program.  Data and stack area follows.
;  Note all messages printed with function 9 MUST end with '$'.

   mess1:    db     'Capital Converter (Hit ENTER key to end).$'
   mess2:    db     ' ====> $'
   mess3:    db     lf,cr,'Are you sure you passed your first grade?$'
   mess4:    db     lf,cr,'Please type in a letter  : $'
   mess5:    db     lf,cr,'I hope you now know your alphabet better.',lf,'$'

             ds     20           ; 20 bytes reserved for stack
   sp0       equ    $            ; initial address of stack pointer
;
             end                 ; just another assembler directive
