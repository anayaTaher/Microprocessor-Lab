CODE SEGMENT
ASSUME CS:CODE
ORG 100H

START:

MOV AL, 16H
OUT 43H, AL

MOV AL, 100
OUT 40H, AL

END START
CODE ENDS