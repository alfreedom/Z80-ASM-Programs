;Incrementa un numero de 16,24 o 32 bits
VAR1	.EQU	0f0h
VAR2	.equ	014h
	JP	Inicio
	
	ORG	0066h
	RETI
	
	org	070h
Inicio:	LD	HL,VAR1
	CALL	INC24
	JP	FIN


INC16:	LD	b,2
	JP	_inc
INC24:	LD	b,3
	JP	_inc
INC32:	LD	b,4
	JP	_inc
_inc	LD	A,0FFh
	INC	A	
CICLO:	LD	A,(HL)
	ADC	A,0
	LD	(HL),A
	INC	HL
	DJNZ	CICLO
	ret
	
FIN:	HALT
	HALT
	
	