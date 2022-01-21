	CODE SEGMENT
	ASSUME CS:CODE

	PA	EQU	0FF28H          ; PA Data port
	PCTL	EQU	0FF2BH          ; 8255 Command port
	RSN	EQU	00H	; PC0   bit set/reset mode of 8255 (PC)
	RS 	EQU	01H
	RWN	EQU	02H	; PC1
	RW	EQU	03H
	EN	EQU	04H	; PC2   Enable = 0
	E	EQU	05H     ;       Enable = 1
	CS1N	EQU	08H	; PC4
	CS1	EQU	09H
	CS2N	EQU	0Ch	;  PC6
	CS2	EQU	0Dh
	ORG 	22E0h           ;2FE0H
        JMP START

        YR  db   ?              ; column address
        pag db   ?              ; page address
        ZR  db   0c0H           ; always first row of page (don't change)
        val db   ?              ; value of command or data

START:

      ; configure 8255
     MOV DX, PCTL
     MOV AL, 80H
     OUT DX, AL

      ; initialize LCD (Display ON command) for both halves (call sendComm procedure)
      ; left half
      CALL SELECTLEFT
      CALL DELAY2MS

      MOV AL, 3FH
      MOV VAL, AL
      CALL SendComm

MAIN:
      ; select first column and first page
      MOV AL, 40H
      MOV YR, AL
      MOV AL, 0B8H
      MOV PAG, AL
      CALL SETCURSOR

      ; select left half of LCD and set cursor


      ; get offset of character to be displayed and call sendData procedure
      ; this can be repeated to print an many characters as required
      CALL dispComm

      jmp $                   ; stay at current location


      ; procecure to display a single character (8 columns)
      ; loop through the columns of the character and call sendData
dispComm:

         MOV AL, 0
         MOV VAL, AL
         MOV CX, 8
         L1:
         PUSH CX
         MOV CX, 64
         L2:
         CALL SendData
         LOOP L2
         POP CX
         MOV AL, PAG
         INC AL
         MOV PAG, AL
         CALL setCursor
         LOOP L1

         LEA SI, HELLO
         MOV CX, 40
         L4:
         MOV AL, [SI]
         MOV VAL, AL

         CALL SendData
         ;INC YR
         INC SI
         LOOP L4
RET

      ; Procedure to send a command to LCD (command value is in variable called val)
SendComm:
         MOV DX, PA
         MOV AL, VAL
         OUT DX, AL

         MOV DX, PCTL
         MOV AL, RSN
         OUT DX, AL

         MOV AL, RWN
         OUT DX, AL

         MOV AL, EN
         OUT DX, AL

         CALL DELAY2MS

         MOV AL, E
         OUT DX, AL

         CALL DELAY2MS

         MOV AL, EN
         OUT DX, AL

         CALL DELAY2MS
RET



     ; Procedure to send a Data (single column) to LCD (data value is in variable called val)
SendData:
         MOV DX, PCTL
         MOV AL, RS
         OUT DX, AL

         MOV DX, PA
         MOV AL, VAL
         OUT DX, AL

         MOV DX, PCTL
         MOV AL, RS
         OUT DX, AL

         MOV AL, RWN
         OUT DX, AL

         MOV AL, EN
         OUT DX, AL

         CALL DELAY2MS

         MOV AL, E
         OUT DX, AL

         CALL DELAY2MS

         MOV AL, EN
         OUT DX, AL

         CALL DELAY2MS
        
RET



; set cursor of LCD to a certain page line and a certain column.
; LCD half should be already selected
setCursor:

          MOV DX, PCTL
          MOV AL, RSN
          OUT DX, AL
          ; set column (send YR value as command)

          MOV DX, PA
          MOV AL, YR
          OUT DX, AL

          ; set page (send PAG (x address) value as command)

          MOV AL, PAG
          OUT DX, AL

          ; set row (send ZR value as command)
          
           MOV AL, ZR
           OUT DX, AL
RET

; enable left half of the LCD (CS1 = 1, CS2 = 0)
SELECTLEFT:
      MOV DX, PCTL
      MOV AL, CS1
      OUT DX, AL

      MOV AL, CS2N
      OUT DX, AL
RET



; enable right half of the LCD (CS1 = 0, CS2 = 1)
SELECTRIGHT:
      MOV DX, PCTL
      MOV AL, CS1N
      OUT DX, AL

      MOV AL, CS2
      OUT DX, AL
RET



DELAY2MS:
        PUSH CX
        MOV CX,78H
	LOOP $            ; current position
        POP CX
RET

; characters can be declared here
CharEmpty: DB  00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h         ; empty block of 8x8 pixels
CHARA:     DB  00h, 7eh, 11h, 11h, 11h, 7eh, 00h, 00h    ; character A on a block of 8x8 pixels
CHARFULL:  DB  0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh  ; all black
HELLO DB 0,07fh,8h,8h,08h,07fh,0,0, 0,38h,54h,54h,54h,18h,0,0, 0,41h,07fh,40h,0,0,0,0, 0,41h,07fh,40h,0,0,0,0, 0,38h,44h,44h,44h,38h,0,0

CODE ENDS
END START