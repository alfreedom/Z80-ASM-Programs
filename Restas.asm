;Resta dos numeros un numero de 16,24 o 32 bits
;Resta el contenido de HL a DE  [(DE)-(HL)].

VAR1	.EQU	0f0h
VAR2	.equ	014h
	JP	Inicio
	
	ORG	0066h
	RETI
	
	org	070h
Inicio:	LD	HL,VAR1
	CALL	INC24
	JP	FIN


RES16:	LD	b,2
	JP	_inc
RES24:	LD	b,3
	JP	_inc
RES32:	LD	b,4
	JP	_inc
_res	LD	A,0FFh
	INC	A	
CICLO:	LD	A,(HL)
	ADC	A,0
	LD	(HL),A
	INC	HL
	DJNZ	CICLO
	ret
	
FIN:	HALT
	HALT