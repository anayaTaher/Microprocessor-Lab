CODE SEGMENT
ASSUME CS:CODE
ORG 1000H

START:

MOV DX, 0FF2BH
MOV AL, 82H
OUT DX, AL

MOV DX, 0FF28H
MOV BL, 88H
MOV BH, 0CCH

L1:
MOV AL, BL
OUT DX, AL
ROL BL, 1
CALL DELAY

MOV AL, BH
OUT DX, AL
ROL BH, 1
CALL DELAY
JMP L1

DELAY PROC NEAR
      MOV CX, 500
      LD:
      NOP
      LOOP LD
      RET
DELAY ENDP

END START
CODE ENDS
