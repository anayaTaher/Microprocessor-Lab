CODE SEGMENT
ASSUME CS:CODE
ORG 1000H

START:

MOV DX, 8000H

L1:
MOV AL, 0
OUT DX, AL
CALL DELAY
MOV AL, 0FFH
OUT DX, AL
CALL DELAY
JMP L1

DELAY PROC NEAR
      MOV CX, 10000
      LD:
      NOP
      LOOP LD
      RET
DELAY ENDP

END START
CODE ENDS
