; Compiled with: Z80 Simulator IDE - Registered Copy v9.81
; Microprocessor model: Z80
; Clock frequency: 2.5MHz
;
;       The address of 'a' (short) (global) is FEFFH (IX-1)
a:	.EQU 0FEFFH
; Begin
	LD IX,0FF00H
	LD SP,0FEFFH
; Begin of program
; 1: 
; 2: Dim a As Short
	LD A,00H
	LD (IX-01H),A
; 3: 
; 4: 
; 5: a = 10 / 2
	LD A,0AH
	LD L,02H
	LD H,A
	LD A,L
	LD L,H
	CALL D01
	LD (IX-01H),A
; End of program
	HALT
; Short Division Routine
D01: :	LD H,A
	XOR L
	LD A,L
	PUSH AF
	BIT 7,H
	JR Z,D02
	LD A,H
	NEG
	LD H,A
D02: :	BIT 7,L
	JR Z,D03
	LD A,L
	NEG
	LD L,A
D03: :	LD A,H
	CALL D04
	LD H,A
	POP AF
	JP P,D05
	PUSH AF
	LD A,H
	NEG
	LD H,A
	POP AF
D05: :	OR A
	LD A,H
	RET P
	LD A,L
	NEG
	LD L,A
	LD A,H
	RET
D04: :	PUSH BC
	LD H,A
	XOR A
	LD B,08H
D08: :	ADD A,A
	SLA L
	JR NC,D06
	INC A
D06: :	CP H
	JR C,D07
	SUB H
	INC L
D07: :	DJNZ D08
	LD H,A
	LD A,L
	LD L,H
	POP BC
	RET
; End of listing
	.END
