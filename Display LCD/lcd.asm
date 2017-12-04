; Begin
	LD IX,0FF00H
	LD SP,0FEF9H
; 1: Dim porta As Short
;       The address of 'porta' is IX-1 (FEFFH)
; 2: Dim portb As Short
;       The address of 'portb' is IX-2 (FEFEH)
; 3: Dim a As Short
;       The address of 'a' is IX-3 (FEFDH)
; 4:
; 5: Const portaadr = 0x00
;       The value of 'portaadr' is 0
; 6: Const portbadr = 0x01
;       The value of 'portbadr' is 1
; 7: Const rsbit = 0
;       The value of 'rsbit' is 0
; 8: Const ebit = 1
;       The value of 'ebit' is 1
; 9:
; 10: porta = 0
	LD A,00H
	LD (IX-01H),A
; 11: portb = 0
	LD A,00H
	LD (IX-02H),A
; 12: Put portaadr, porta
	LD A,(IX-01H)
	OUT (00H),A
; 13: Put portbadr, portb
	LD A,(IX-02H)
	OUT (01H),A
; 14: Gosub delay1
	CALL L0002
; 15: Gosub lcdinit
	CALL L0001
; 16:
; 17: a = "H"
	LD A,48H
	LD (IX-03H),A
; 18: Gosub senddata
	CALL L0005
; 19: a = "e"
	LD A,65H
	LD (IX-03H),A
; 20: Gosub senddata
	CALL L0005
; 21: a = "l"
	LD A,6CH
	LD (IX-03H),A
; 22: Gosub senddata
	CALL L0005
; 23: a = "l"
	LD A,6CH
	LD (IX-03H),A
; 24: Gosub senddata
	CALL L0005
; 25: a = "o"
	LD A,6FH
	LD (IX-03H),A
; 26: Gosub senddata
	CALL L0005
; 27: a = "!"
	LD A,21H
	LD (IX-03H),A
; 28: Gosub senddata
	CALL L0005
; 29: End
	HALT
; 30:
; 31: lcdinit:
L0001:	NOP
; 32: a = 0x33
	LD A,33H
	LD (IX-03H),A
; 33: Gosub sendcommand
	CALL L0004
; 34: a = 0x33
	LD A,33H
	LD (IX-03H),A
; 35: Gosub sendcommand
	CALL L0004
; 36: a = 0x33
	LD A,33H
	LD (IX-03H),A
; 37: Gosub sendcommand
	CALL L0004
; 38: a = 0x38
	LD A,38H
	LD (IX-03H),A
; 39: Gosub sendcommand
	CALL L0004
; 40: a = 0x0f
	LD A,0FH
	LD (IX-03H),A
; 41: Gosub sendcommand
	CALL L0004
; 42: a = 0x01
	LD A,01H
	LD (IX-03H),A
; 43: Gosub sendcommand
	CALL L0004
; 44: Return
	RET
; 45:
; 46: delay1:
L0002:	NOP
; 47: Dim d1 As Integer
;       The address of 'd1' is IX-5 (FEFBH)
; 48: For d1 = 1 To 100
	LD HL,0001H
	LD (IX-05H),L
	LD (IX-04H),H
L0006:	NOP
	LD L,(IX-05H)
	LD H,(IX-04H)
	LD DE,0064H
	CALL C001
	JR Z,L0008
	JP NC,L0007
L0008:	NOP
; 49: Next d1
	LD L,(IX-05H)
	LD H,(IX-04H)
	INC HL
	LD (IX-05H),L
	LD (IX-04H),H
	JP L0006
L0007:	NOP
; 50: Return
	RET
; 51:
; 52: delay2:
L0003:	NOP
; 53: Dim d2 As Integer
;       The address of 'd2' is IX-7 (FEF9H)
; 54: For d2 = 1 To 30
	LD HL,0001H
	LD (IX-07H),L
	LD (IX-06H),H
L0009:	NOP
	LD L,(IX-07H)
	LD H,(IX-06H)
	LD DE,001EH
	CALL C001
	JR Z,L0011
	JP NC,L0010
L0011:	NOP
; 55: Next d2
	LD L,(IX-07H)
	LD H,(IX-06H)
	INC HL
	LD (IX-07H),L
	LD (IX-06H),H
	JP L0009
L0010:	NOP
; 56: Return
	RET
; 57:
; 58: sendcommand:
L0004:	NOP
; 59: ResetBit portb, rsbit
	LD A,(IX-02H)
	RES 0,A
	LD (IX-02H),A
; 60: Put portbadr, portb
	LD A,(IX-02H)
	OUT (01H),A
; 61: porta = a
	LD A,(IX-03H)
	LD (IX-01H),A
; 62: Put portaadr, porta
	LD A,(IX-01H)
	OUT (00H),A
; 63: SetBit portb, ebit
	LD A,(IX-02H)
	SET 1,A
	LD (IX-02H),A
; 64: Put portbadr, portb
	LD A,(IX-02H)
	OUT (01H),A
; 65: ResetBit portb, ebit
	LD A,(IX-02H)
	RES 1,A
	LD (IX-02H),A
; 66: Put portbadr, portb
	LD A,(IX-02H)
	OUT (01H),A
; 67: Gosub delay1
	CALL L0002
; 68: Return
	RET
; 69:
; 70: senddata:
L0005:	NOP
; 71: SetBit portb, rsbit
	LD A,(IX-02H)
	SET 0,A
	LD (IX-02H),A
; 72: Put portbadr, portb
	LD A,(IX-02H)
	OUT (01H),A
; 73: porta = a
	LD A,(IX-03H)
	LD (IX-01H),A
; 74: Put portaadr, porta
	LD A,(IX-01H)
	OUT (00H),A
; 75: SetBit portb, ebit
	LD A,(IX-02H)
	SET 1,A
	LD (IX-02H),A
; 76: Put portbadr, portb
	LD A,(IX-02H)
	OUT (01H),A
; 77: ResetBit portb, ebit
	LD A,(IX-02H)
	RES 1,A
	LD (IX-02H),A
; 78: Put portbadr, portb
	LD A,(IX-02H)
	OUT (01H),A
; 79: Gosub delay2
	CALL L0003
; 80: Return
	RET
; End of program
	HALT
; Integer Comparison Routine
C001:	LD A,H
	XOR D
	JP P,C002
	XOR H
	AND 80H
	CP 7FH
	RET
C002:	SBC HL,DE
	RET
; End of listing
	.END
