ORG 100H
BOOT EQU 0
BDOS EQU 5
LXI SP, SP0
MVI C, 9; C value for printing long messages using BDOS
LXI D, MSG1; loads starting address of massage 1 into <DE>
CALL BDOS
MVI C, 1
CALL BDOS;
MOV B, A; B has first number
CALL BDOS; A has second number
ADD D
SUI '0'; remove second ASCII zero because it actually has a value in hex
MVI E, 0AH
MVI C, 2
CALL BDOS
MVI E, ODH
CALL BDOS
MOV E, A
CALL BDOS
JMP BOOT
MSG1: DB 'Type two numbers', 0AH, 0DH, '$'
DS 4
SP EQU $
END
