;
;  This program is written by MDW to illusrate the cursor control
;  on a Televideo terminal.  Following are valid escape sequences
;  for a Televideo:
;
;       <ESC>*      : clear screen and home cursor
;       0Ah         : line feed, move cursor down by one position
;       0Dh         : carriage return
;       0Ch         : move cursor to the right (one place)
;       more codes are defined as constants in the program

;  This program merely draws a rectangle on the screen

    bdos     equ     5                 ; CP/M related constants
    sprint   equ     9
    conout   equ     2
    boot     equ     0
    esc      equ     1Bh               ; more Televideo terminal codes
    left     equ     08h               ; move cursor to the left (one place)
    up       equ     0Bh               ; move cursor up (one place)
    down     equ     0Ah               ; move cursor down (one place)
    cr       equ     0Dh               ; carriage return (move to begining of line)

             org     100h              ; usual start address of CP/M
             lxi     sp,stkpt          ; initialize stack pointer

             mvi     c, sprint          ; set the cursor to the starting position
             lxi     d, mess1 
             call    bdos

             mvi     l,4               ; complete cycle to be done 4 times
    l0:      mvi     h,20	       ; 20 rows to move the star
    l2:      mvi     c,sprint
             lxi     d,mess2
             call    bdos              ; move star one place to the right
             call    delay             ; wait for some time for visual effects
             dcr     h
             jnz     l2                ; do this 20 times
             mvi     h,6
    l3:      mvi     c,sprint
             lxi     d,mess3
             call    bdos              ; move star one row down
             call    delay             ; wait for some time for visual effects
             dcr     h
             jnz     l3                ; do this 6 times
             mvi     h,20
    l4:      mvi     c,sprint
             lxi     d,mess4
             call    bdos              ; move star one place to the left
             call    delay             ; wait for some time for visual effects
             dcr     h
             jnz     l4                ; do this 20 times
             mvi     h,6
    l5:      mvi     c,sprint
             lxi     d,mess5
             call    bdos              ; move star one row up
             call    delay             ; wait for some time for visual effects
             dcr     h
             jnz     l5                ; do this 6 times
             dcr     l
             jnz     l0                ; repeat cycle again
	     mvi     c, conout         ; erase the last star
             mvi     e, ' '
             call    bdos
             jmp     boot              ; and only then stop

;  End of main program.  Now follow the subroutines
;
;            Subroutine delay
;               input : none
;               action : waste time (approximately how much?)
;               registers destroyed : none
;               subroutines called : none

    delay:   push    h                 ; save all registers disturbed
             push    psw
             mvi     l,1               ; change l an h values for more delay
    d2:      mvi     h,1
    d3:	     dcr     h
             jnz     d3
             dcr     l
             jnz     d2
             pop     psw               ; restore registers
             pop     h  
             ret                       ; and return

;  Now comes the data

    mess1:   db      esc,'*$'                   ; clear screen, home cursor
    mess2:   db      ' ','*',left,'$'
    mess3:   db      ' ',left,down,'*',left,'$'
    mess4:   db      ' ',left,left,'*',left,'$'
    mess5:   db      ' ',left,up,'*',left,'$'
             ds      20                         ; 20 spaces for stack
    stkpt    equ     $
             end                                ; just the directive assembler
