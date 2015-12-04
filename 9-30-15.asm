;BDOS EQU 5
;Call BDOS; refers to a location in the operating system
         ; that can perform certain operations based on what is in register C

;Program takes 2 character input from user
;then prints in reverse order
ORG 100H
BDOS EQU 5
BOOT EQU 0
LXI SP, SP0
MVI C, 1; read keyboard ASCII key code --> A (automatically prints to screen as well)
CALL BDOS
MOV B, A; B has first character
CALL BDOS; A has second character
MVI E, 0AH; line feed
MVI C, 2; print char in E register
Call BDOS
MVI E, 0DH; carriage return, beginning of line
Call BDOS
MOV E, A
CALL BDOS
MOV E, B
CALL BDOS
JMP BOOT
DS 4
SP0 EQU $
END
