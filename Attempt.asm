;This program adds values in two slots
;and stores the output in a third slot
ORG 0100H ;start of program
MVI A, 01H
MVI B, 0AH
LXI H, 0115H
MOV M,A
INX H
MOV M,B
MVI A,00
MVI B,00
LDA 0115H ;load first value into register A
LXI H,0116H ;load address of second value into register H
MOV B,M   ;load value at H-L address into B
ADD B     ;add B to A
STA 0117H ;store A into memory slot 0302H 
END ;finishes program